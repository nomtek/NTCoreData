//
//  NTDatabase.m
//  Nomtek
//
//  Created by Adam Szeptycki on 5/16/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObject+EntityName.h"
@protocol NTDataBaseContextChangesNotifications

@optional
- (void)mainContextDidInsertObjects:(NSSet*)objects;
- (void)mainContextDidDeleteObjects:(NSSet *)objects;
- (void)mainContextDidUpdateObjects:(NSSet *)objects;

@end


/**
 @brief Database class provides mechanism that allows to make async calls to
 database using Core Data Framework.

 The class provides 3 layers of NSManagedObjectContext (from now on called
 context) that are orginised as follows:

 1. MasterContext - master context is the context associated with one of
    background queues. It's linked to the SQLite file and is populated with
    data from it. Every time the app is goes background, it will save all
    accomodated changes to SQLite file. Note that if you don't invoke
    saveMasterContext directly and your app crashes, the data won't be saved.
    You should invoke this method manually if you have important data to save. 
 2. MainContext - is linked to MainQueue (same as the UI) and it's a child
    context of the MasterContext (1). Every change done in Core Data
    (save/update) is stored in this context and saved to MasterContext when
    saveMasterContext is called. This context is not directly linked to the
    SQLite file so saving the data to file system won't block user interface.
 3. Background contexts - are contexts created for each task and are child
    contexts of MainContext. Each change made in them is pushed to MainContext.
 */

@interface NTDatabase : NSObject
@property (nonatomic,readonly) NSManagedObjectContext *mainContext;

/**
 Creates singleton of the Database class that is responsible for
 managing the async Core Data stack.

 @returns Database class singleton
 */
+ (id)sharedInstance;

/**
 Saves data in background context and gets NSManagedObject instances that were
 saved and are valid for use in MainQueue.

 @param saveBlock block that will be executed in the background task with the
        newly created NSManagedObjectContext as the argument
 @param completionBlock block that will be invoked with array of
        NSManagedObject instances valid  for use in MainQueue
 @param idsArray array of ids of NSManagedObject instances that will be
        changed/created
 */
- (void)saveDataInBackgroundWithContext:(void (^)(NSManagedObjectContext*context))saveBlock withArrayOfIds:(NSArray*)idsArray completion:(void (^)(NSArray*))completionBlock;

/**
 Fetches data from database in background context and gets NSManagedObject
 instances valid for use on MainQueue.

 fetchBlock will be executed in the background task. The newly created
 NSManagedObjectContext will be passed as the argument. It should return an
 array of NSManagedObjectId instances that will later be used to get
 NSManagedObject instances valid for use on MainQueue.

 @param fetchBlock
 @param completionBlock block that will be invoked with fetched NSManagedObject
        instances valid for use on MainQueue
 */
- (void)fetchDataInBackgroundWitchContext:(NSArray*(^)(NSManagedObjectContext *context)) fetchBlock withCompletion:(void(^) (NSArray*))completionBlock;

/**
 Counts data in background context and then invokes completion block with
 the result.

 @param countBlock block that will be executed in the background task with the
        newly created NSManagedObjectContext as the argument. It should perform
        a fetch and return count of rows.
 @param completionBock block that will be invoked on main thread with the
        result of countBlock.
 */
- (void)countDataInBackgroundWithBlock:(NSUInteger(^) (NSManagedObjectContext*context)) countBlock withCompletion:(void (^) (NSUInteger))completionBlock;

/**
 Returns array of NSManagedObjectID instancess corresponding to received
 array of NSManagedObject instances.

 @param entitiesArray array of NSManagedObject instances
 @returns array of NSManagedObjectID instances
 */
- (NSArray*)getObjectIDsArrayFromEntitesArray:(NSArray*)entitiesArray;

/**
 I HAZ NO DOCZORZ! FIXME PLZ
 */
- (void)addDelegate:(id<NTDataBaseContextChangesNotifications>)newDelegate;

/**
 Saves the MainContext pushing changes to MasterContext. This function will
 wait until all saves started before calling it are completed. It won't block
 the calling thread.
*/
- (void)saveMainContext;

/**
 Saves the MasterContext and saves all changes to the SQLite file. Invoking
 this function automatically calls saveMainContext before saving the
 MasterContext.
*/
- (void)saveMasterContext;
@end
