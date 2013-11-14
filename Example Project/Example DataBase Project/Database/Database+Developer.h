//
//  Database+Developer.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NTDatabase.h"
#import "Developer.h"
@interface NTDatabase (Database_Developer)
#pragma mark - Async methods
- (void)addDeveloperWithName:(NSString*)name andID:(int)idNumber withPlatform:(NSString*)platform withExperience:(int)experience andProjects:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion;
- (void)fetchAllDevelopersLimited:(int)limit offset:(int)offset WithCompetionBlock:(void (^)(NSArray*))completion;
#pragma mark - sync methods
- (NSManagedObjectID*)addDeveloperWithName:(NSString*)name andID:(int)idNumber withPlatform:(NSString*)platform withExperience:(int)experience andProjects:(NSSet*)projects inContext:(NSManagedObjectContext*)context;

@end
