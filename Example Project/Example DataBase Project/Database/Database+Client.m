//
//  Database+Client.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Database+Client.h"
#import "Project.h"
@implementation NTDatabase (Database_Client)

#pragma mark - Async methods
- (void)addClientWithName:(NSString*)clientName andID:(int)idNumber withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        [result addObject:[self addClientWithName:clientName andID:idNumber inContext:context]];
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];

}
- (void)addClientWithName:(NSString*)clientName andID:(int)idNumber andProjects:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        [result addObject:[self addClientWithName:clientName andID:idNumber andAddProjects:projects inContext:context]];
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}

#pragma mark - sync methods

- (NSManagedObjectID*)addClientWithName:(NSString*)clientName andID:(int) idNumber inContext:(NSManagedObjectContext*)context
{
    Client *client = [NSEntityDescription insertNewObjectForEntityForName:[Client entityName] inManagedObjectContext:context];
    client.name = clientName;
    client.id = idNumber;
    return client.objectID;
}

- (NSManagedObjectID*)addClientWithName:(NSString*)clientName andID:(int) idNumber andAddProjects:(NSSet*)projects inContext:(NSManagedObjectContext*)context
{
    Client *client = (Client *)[context objectWithID:[self addClientWithName:clientName andID:idNumber inContext:context]];
    NSArray* projectsIDs = [self getObjectIDsArrayFromEntitesArray: [projects allObjects]];
    NSMutableSet *currentProjects = [client.projects mutableCopy];
    
    if(!currentProjects){
        currentProjects = [[NSMutableSet alloc]initWithCapacity:projects.count];
    }
    
    for (NSManagedObjectID *projectManagedObjectID in projectsIDs) {
        Project *project = (Project*)[context objectWithID:projectManagedObjectID];
        [currentProjects addObject:project];
    }

    client.projects = currentProjects;
    
    return client.objectID;
}


@end
