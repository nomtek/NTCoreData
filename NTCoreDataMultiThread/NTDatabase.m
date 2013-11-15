//
//  NTDatabase.m
//  Nomtek
//
//  Created by Adam Szeptycki on 5/16/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "NTDatabase.h"


#define DATA_MODEL_NAME @"DataModel"
@interface NTDatabase ()

@property (strong, nonatomic) NSManagedObjectContext *masterContext;
@property (nonatomic,strong) NSManagedObjectContext *mainContext;

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;


@property (nonatomic,retain) dispatch_queue_t backgroundCoreDataQueue;
@property (nonatomic,retain) dispatch_queue_t masterCodeDataQueue;


@property (nonatomic) UIBackgroundTaskIdentifier backgroundSQliteSaveTask;

@property (nonatomic,strong) NSHashTable *delegates;
@end

@implementation NTDatabase
//@synthesize masterContext = _masterContext


static NTDatabase* _sharedInstance=nil;



+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NTDatabase alloc] init];

    });
    return _sharedInstance;
}


- (id)init
{
    self=[super init];
    if(self) {
        _backgroundCoreDataQueue = dispatch_queue_create("com.nomtek.backgroundDataBaseThread", DISPATCH_QUEUE_CONCURRENT);
        _masterCodeDataQueue = dispatch_queue_create("com.nomtek.masterDataBaseThread", DISPATCH_QUEUE_CONCURRENT);
        _backgroundSQliteSaveTask = UIBackgroundTaskInvalid;
        [self addSelfAsApplicationWillResignActiveNotification];

    }
    return self;
}


-(void)addSelfAsApplicationWillResignActiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}


#pragma mark Save helping function

- (void)saveDataInContext:(void (^)(NSManagedObjectContext*context))saveBlock
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    [context setParentContext:self.mainContext];
    saveBlock(context);
    if ([context hasChanges]) {
        NSError *error=nil;
        if(![context save:&error]) {
            NSLog(@"background context error %@",[error localizedDescription]);
        } else {
            
        }
    }
}

- (void)saveDataInBackgroundWithContext:(void (^)(NSManagedObjectContext*context))saveBlock withArrayOfIds:(NSArray*)idsArray completion:(void (^)(NSArray*))completionBlock 
{
    dispatch_barrier_async(self.backgroundCoreDataQueue, ^{
        [self saveDataInContext:saveBlock];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *arrayOfEntities = [[NSMutableArray alloc]initWithCapacity:idsArray.count];
            
            for (NSManagedObjectID*ObjectId in idsArray) {
                NSManagedObject *object = [self.mainContext objectWithID:ObjectId];
                [arrayOfEntities addObject:object];
            }
            if(completionBlock) {
                completionBlock(arrayOfEntities);
            }
        });
    });
}

#pragma mark Fetch helping function
- (NSArray*)fetchDataInBackground:(NSArray*(^)(NSManagedObjectContext*context))fetchBlock
{
    NSLog(@"Started fetching");
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:self.mainContext];
    context.undoManager = nil;
    NSArray *objectsId = fetchBlock(context);
    return objectsId;
}

- (void)fetchDataInBackgroundWitchContext:(NSArray*(^)(NSManagedObjectContext*context))fetchBlock withCompletion:(void (^)(NSArray*))completionBlock
{
    dispatch_async(self.backgroundCoreDataQueue, ^{
        NSArray *objectsId = [self fetchDataInBackground:fetchBlock];
        NSLog(@"Ended fetching");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *fetchedObjects = [[NSMutableArray alloc]initWithCapacity:objectsId.count];
            for (NSManagedObjectID*objectId in objectsId) {
                NSManagedObject *object = [self.mainContext objectWithID:objectId];
                [fetchedObjects addObject:object];
            }
            completionBlock(fetchedObjects);
        });
    });
}

- (void)saveMainContext
{
    dispatch_barrier_async(self.backgroundCoreDataQueue,^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSError *error;
            if (![self.mainContext save:&error]) {
                NSLog(@"Main context error : %@",[error localizedDescription]);
            } else {
                NSLog(@"Main context saved succesfully");
            }
        });
    });
}

- (void)saveMainContextWithCompletion:(void (^)(void))completion
{
    NSError *error;
    if(![self.mainContext save:&error]) {
        NSLog(@"Main context error : %@",[error localizedDescription]);
    }
    completion();
}

- (void)saveMasterContext
{
    [self saveMainContextWithCompletion:^{
        dispatch_async(self.masterCodeDataQueue, ^{
           NSError *error;
            if(![self.masterContext save:&error]) {
                NSLog(@"Master context error : %@",[error localizedDescription]);
            } else {
                NSLog(@"Master context saved");
            }
        });
    }];
}

#pragma mark counting in background
- (NSUInteger)countDataInBackground:(NSUInteger (^)(NSManagedObjectContext*context))countBlock
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:self.mainContext];
    NSUInteger result = countBlock(context);
    return result;
}

- (void)countDataInBackgroundWithBlock:(NSUInteger (^)(NSManagedObjectContext*context))countBlock withCompletion:(void (^)(NSUInteger))completionBlock
{
    dispatch_async(self.backgroundCoreDataQueue, ^{
        __block NSUInteger countResult = [self countDataInBackground:countBlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(countResult);
        });
    });
}

- (NSArray*)getObjectIDsArrayFromEntitesArray:(NSArray*)entitiesArray
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:entitiesArray.count];
    for(NSManagedObject*object in entitiesArray) {
        [resultArray addObject:object.objectID];
    }
    return resultArray;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext*)masterContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            dispatch_sync(self.masterCodeDataQueue, ^{
                _masterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [_masterContext setPersistentStoreCoordinator:coordinator];
            });
        }
    });
    
    return _masterContext;
}

- (NSManagedObjectContext*)mainContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
            _mainContext.parentContext = self.masterContext;
    });
    return _mainContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATA_MODEL_NAME withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - App Life Cycle delegate

-(void)appWillResignActive
{

    self.backgroundSQliteSaveTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundSQliteSaveTask];
        self.backgroundSQliteSaveTask = UIBackgroundTaskInvalid;
    }];
    [self saveMasterContext];
}

#pragma mark - Context Notification Methods

-(void)registerForContextChangesNotifications
{
    dispatch_barrier_async(self.backgroundCoreDataQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainContextDidChanged:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.mainContext];
        });
    });
}

-(void)unregisterFromContextChangesNotifications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.mainContext];
}

-(void)mainContextDidChanged:(NSNotification*)notification
{
    for(id<NTDataBaseContextChangesNotifications> delegate in self.delegates){
        [self notifyInsertDelegate:delegate withNotification:notification];
        [self notifyUpdateDelegate:delegate withNotification:notification];
        [self notifyDeleteDelegate:delegate withNotification:notification];
    }
}

-(void)notifyDeleteDelegate:(id)delegate withNotification:(NSNotification*)notification
{
    if([delegate respondsToSelector:@selector(mainContextDidDeleteObjects:)]){
        NSSet *deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
        [delegate mainContextDidDeleteObjects:deletedObjects];
    }
}

-(void)notifyUpdateDelegate:(id)delegate withNotification:(NSNotification*)notification
{
    if([delegate respondsToSelector:@selector(mainContextDidUpdateObjects:)]){
        NSSet *updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
        [delegate mainContextDidUpdateObjects:updatedObjects];
    }
}

-(void)notifyInsertDelegate:(id)delegate withNotification:(NSNotification*)notification
{
    if([delegate respondsToSelector:@selector(mainContextDidInsertObjects:)]){
        NSSet *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
        [delegate mainContextDidInsertObjects:insertedObjects];
    }
}


- (void)addDelegate:(id<NTDataBaseContextChangesNotifications>)newDelegate
{
    if(!self.delegates){
        [self registerForContextChangesNotifications];
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    [self.delegates addObject:newDelegate];
}

@end