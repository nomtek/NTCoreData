//
//  Database+ProjectManager.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Database+ProjectManager.h"
#import "Project.h"
@implementation NTDatabase (Database_ProjectManager)
#pragma mark - Async methods
- (void)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        [self addprojectManagerWithName:projectManagerName skype:skype andID:idNumber inContext:context];
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}

- (void)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber andAddProject:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        [self addprojectManagerWithName:projectManagerName skype:skype andID:idNumber andAddProject:projects inContext:context];
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}

#pragma mark - sync methods
- (NSManagedObjectID*)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber inContext:(NSManagedObjectContext*)contex
{
    ProjectManager *pm = [NSEntityDescription insertNewObjectForEntityForName:[ProjectManager entityName] inManagedObjectContext:contex];
    pm.name = projectManagerName;
    pm.skype = skype;
    pm.id = idNumber;
    
    return pm.objectID;
}

- (NSManagedObjectID*)addprojectManagerWithName:(NSString*)projectManagerName skype:(NSString*)skype andID:(int)idNumber andAddProject:(NSSet*)projects inContext:(NSManagedObjectContext*)context
{
    ProjectManager *pm = (ProjectManager*)[context objectWithID:[self addprojectManagerWithName:projectManagerName skype:skype andID:idNumber inContext:context]];
    
    NSArray* projectsIDs = [self getObjectIDsArrayFromEntitesArray: [projects allObjects]];
    NSMutableSet *currentProjects = [pm.projects mutableCopy];
    if(!currentProjects){
        currentProjects = [[NSMutableSet alloc]initWithCapacity:projects.count];
    }

    for (NSManagedObjectID *projectManagedObjectID in projectsIDs) {
        Project *project = (Project*)[context objectWithID:projectManagedObjectID];
        [currentProjects addObject:project];
    }
    
    pm.projects = currentProjects;

    return pm.objectID;
}
@end
