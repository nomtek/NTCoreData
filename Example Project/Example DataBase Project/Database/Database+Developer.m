//
//  Database+Developer.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Database+Developer.h"
#import "Project.h"
@implementation NTDatabase (Database_Developer)

#pragma mark - Async methods
-(void)fetchAllDevelopersLimited:(int)limit offset:(int)offset WithCompetionBlock:(void (^)(NSArray*))completion
{
    NSArray* (^fetchBlock)(NSManagedObjectContext*)=^(NSManagedObjectContext *context){
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:[Developer entityName] inManagedObjectContext:context]];
//        NSFetchRequest *request =  [NSFetchRequest fetchRequestWithEntityName:[Developer entityName]];
//        [request setReturnsObjectsAsFaults:NO];
        request.fetchLimit = limit;
        [request setFetchOffset:offset];
        NSSortDescriptor *sortByID = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        request.sortDescriptors = @[sortByID];
        NSError *e = nil;
        NSArray *fetchResult = [context executeFetchRequest:request error:&e];
        if(e){
            NSLog(@"%@",[e localizedDescription]);
        }
        return [self getObjectIDsArrayFromEntitesArray:fetchResult];
    };
    [self fetchDataInBackgroundWitchContext:fetchBlock withCompletion:completion];
}


- (void)addDeveloperWithName:(NSString*)name andID:(int)idNumber withPlatform:(NSString*)platform withExperience:(int)experience andProjects:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        [result addObject:[self addDeveloperWithName:name andID:idNumber withPlatform:platform withExperience:experience andProjects:projects inContext:context]];
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}

#pragma mark - sync methods

- (NSManagedObjectID*)addDeveloperWithName:(NSString*)name andID:(int)idNumber withPlatform:(NSString*)platform withExperience:(int)experience andProjects:(NSSet*)projects inContext:(NSManagedObjectContext*)context
{
    Developer *d = [NSEntityDescription insertNewObjectForEntityForName:[Developer entityName] inManagedObjectContext:context];
    d.name = name;
    d.id = idNumber;
    d.platform = platform;
    d.experience = experience;
    
    NSMutableSet *newProjects = [[NSMutableSet alloc]initWithCapacity:projects.count];
    for (Project *p in projects) {
        [newProjects addObject: [context objectWithID:p.objectID]];
    }
    
    d.projects = newProjects;
    return d.objectID;
}

@end
