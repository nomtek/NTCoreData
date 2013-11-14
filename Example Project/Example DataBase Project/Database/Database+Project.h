//
//  Database+Project.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NTDatabase.h"
#import "Project.h"
#import "Client.h"
#import "ProjectManager.h"
#import "Developer.h"

@interface NTDatabase (Database_Project)


#pragma mark - async methods

- (void)addProjectWithName:(NSString*)projectName
                                  budget:(int)budget
                                   andID:(int)idNumber
                      withCompetionBlock:(void (^)(NSArray*))completion;


- (void)addProjectWithName:(NSString*)projectName budget:(int)budget andID:(int)idNumber
                               forClient:(Client*)client
                          withDevelopers:(NSSet*)developers
                      withProjectManager:(ProjectManager*)projectManager
                      withCompetionBlock:(void (^)(NSArray*))completion;


#pragma mark - sync methods

- (NSManagedObjectID*)addProjectWithName:(NSString*)projectName
                                  budget:(int)budget
                                   andID:(int)idNumber
                               inContext:(NSManagedObjectContext*)context;

- (NSManagedObjectID*)addProjectWithName:(NSString*)projectName budget:(int)budget andID:(int)idNumber
                               forClient:(Client*)client
                          withDevelopers:(NSSet*)developers
                      withProjectManager:(ProjectManager*)projectManager
                           withinContext:(NSManagedObjectContext*)context;
@end
