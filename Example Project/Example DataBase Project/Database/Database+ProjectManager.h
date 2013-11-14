//
//  Database+ProjectManager.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "NTDatabase.h"
#import "ProjectManager.h"
@interface NTDatabase (Database_ProjectManager)

#pragma mark - Async methods
- (void)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber withCompetionBlock:(void (^)(NSArray*))completion;

- (void)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber andAddProject:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion;

#pragma mark - sync methods
- (NSManagedObjectID*)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber inContext:(NSManagedObjectContext*)contex;
- (NSManagedObjectID*)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber andAddProject:(NSSet*)projects inContext:(NSManagedObjectContext*)context;

@end
