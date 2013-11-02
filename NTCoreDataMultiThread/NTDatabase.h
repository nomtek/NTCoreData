//
//  NTDatabase.m
//  Nomtek
//
//  Created by Adam Szeptycki on 5/16/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
@brief Database class provides mechanism that will allow to make async calls for database using Core Data Framework. Class provides 3 layers of NSManagedObjectContext (called later context) that are orginised as follows:
 1. MasterContext - master context is context associated with one of background queues. Is populated by data from (and is linked to)  SQLite file. Every time app is going to background app will save all acomodated data to SQLite file. Note if you don't invoke saveMasterContext directly and your app crash your data won't save (so if you have any important information you should invoke it).
 2. MainContext - is linked to MainQueue (same as UI) and it's child context to Master Context (1). Every change done in core data (save / update) is stored in this context and saved to Master context when saveMasterContext is called. This context is not directly linked to SQLite so saving data to file system won't block user interface
 3. Background contexts - are context created for each task and are child context for MainContext. Each change made in them is pushed to MainContext.
 */




@interface NTDatabase : NSObject
/**
 Creates singleton of Database class that is responsible for managing asyc core data stack handling.
 @returns Database class singleton
 */
+ (id)sharedInstance;

/**
 Saves data in background context and get NSManagedObjects that was save and are valid for use on MainQueue
 @param saveBlock block that will be executed on background task with created for this background NSManagedObjectContext
 @param completionBlock block that should be invoked with array of NSManagedObject valid for MainQueue
 @param idsArray array of ids of NSManagedObject that will be changed / created
 */
- (void)saveDataInBackgroundWithContext:(void (^)(NSManagedObjectContext*context))saveBlock withArrayOfIds:(NSArray*)idsArray completion:(void (^)(NSArray*))completionBlock;
/**
 Fetched data from database in background and then get NSManagedObjects valid to use on MainQueue
 @param fetchBlock block that will be executed on background task with created for this background NSManagedObjectContext it shuld return NSArray of NSManagedObjectIds that will later be used to get NSManagedObjects valid on Main Queue
 @param completionBlock block that will be invoked with fetched NSManagedObjects valid for MainQueue
 */
- (void)fetchDataInBackgroundWitchContext:(NSArray*(^)(NSManagedObjectContext *context)) fetchBlock withCompletion:(void(^) (NSArray*))completionBlock;


/**
 Counts data in background queue and then invokes completion block with result
 @param countBlock block that takes as an argument context that will be created for him and then should fetch data and return count result
 @param completionBock block that will be invoked on main thread with result of count request
 */
- (void)countDataInBackgroundWithBlock:(NSUInteger(^) (NSManagedObjectContext*context)) countBlock withCompletion:(void (^) (NSUInteger))completionBlock;

/**
 Returns array of NSManagedObjectIDs corresponding to recived array of NSManagedObjects
 @param entitiesArray array NSManagedObject
 @returns resultArray array of NSManagedObjectIDs
 */

- (NSArray*)getObjectIDsArrayFromEntitesArray:(NSArray*)entitiesArray;

#pragma mark counting in background

/**
 Saves mainContext pushing changes to masterContext. This function will wait till all saves invoked before callinkg this function are completed, but it wont block thread that called this function.
*/
- (void)saveMainContext;
/**
 Saves masterContext and saves all changes to SQLite. Invoking this function automatically calls saveMainContext before saving masterContext.
*/
- (void)saveMasterContext;

@end
