//
//  Database+Project.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Database+Project.h"

@implementation NTDatabase (Database_Project)

#pragma mark - async methods

- (void)addProjectWithName:(NSString*)projectName
                    budget:(int)budget
                     andID:(int)idNumber
        withCompetionBlock:(void (^)(NSArray*))completion
{

    
}

- (void)addProjectWithName:(NSString*)projectName budget:(int)budget andID:(int)idNumber
                 forClient:(Client*)client
            withDevelopers:(NSSet*)developers
        withProjectManager:(ProjectManager*)projectManager
        withCompetionBlock:(void (^)(NSArray*))completion
{

}


#pragma mark - sync methods

- (NSManagedObjectID*)addProjectWithName:(NSString*)projectName
                                  budget:(int)budget
                                   andID:(int)idNumber
                               inContext:(NSManagedObjectContext*)context
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:[Project entityName]  inManagedObjectContext:context];
    project.name = projectName;
    project.budget = budget;
    project.id = idNumber;

    return project.objectID;
}

- (NSManagedObjectID*)addProjectWithName:(NSString*)projectName budget:(int)budget andID:(int)idNumber
                               forClient:(Client*)client
                          withDevelopers:(NSSet*)developers
                      withProjectManager:(ProjectManager*)projectManager
                           withinContext:(NSManagedObjectContext*)context
{
    Project *project =  (Project*)[context objectWithID:[self addProjectWithName:projectName budget:budget andID:idNumber inContext:context]];
    project.client = client;
    project.developers = developers;
    project.projectManagers = projectManager;
    
    return project.objectID;
}

@end
