//
//  Database+Person.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Database+Person.h"
#import "Person.h"
@implementation NTDatabase (Database_Person)

-(void)removePersonWithNumber:(int)number withCompletionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        NSArray *arrayOfPrediacates =@[[NSPredicate predicateWithFormat:@" number = %d ",number]];
        NSArray *entitiesToDelete = [self fetchPeopleWithPredicates:arrayOfPrediacates inContext:context shouldReturnEntities:YES];
        for (NSManagedObject *object in entitiesToDelete) {
            [context deleteObject:object];
        }
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}

- (void)addPersonWithName:(NSString*) name andNumber:(int)number withCompetionBlock:(void (^)(NSArray*))completion
{
    __block NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
    void (^saveBlock)(NSManagedObjectContext*)= ^(NSManagedObjectContext* context){
        Person *personEntity = [NSEntityDescription insertNewObjectForEntityForName:[Person entityName] inManagedObjectContext:context];
        personEntity.name = name;
        personEntity.number = number;
        [result addObject:personEntity.objectID]; // this line is important you should add objectID not NSManagedObject
    };
    [self saveDataInBackgroundWithContext:saveBlock withArrayOfIds:result completion:completion];
}
- (void)fetchPersonWithName:(NSString*) name withCompetionBlock:(void (^)(NSArray*))completion
{
    NSArray* (^fetchBlock)(NSManagedObjectContext*)=^(NSManagedObjectContext *context){
        return [self fetchPeopleWithPredicates:@[[NSPredicate predicateWithFormat:@" name = %@",name]] inContext:context shouldReturnEntities:NO];
    };
    [self fetchDataInBackgroundWitchContext:fetchBlock withCompletion:completion];
}


- (void)fetchAllPeopleWithCompetionBlock:(void (^)(NSArray*))completion
{
    NSArray* (^fetchBlock)(NSManagedObjectContext*)=^(NSManagedObjectContext *context){
        return [self fetchPeopleWithPredicates:Nil inContext:context shouldReturnEntities:NO];
    };
    
    [self fetchDataInBackgroundWitchContext:fetchBlock withCompletion:completion];
}

- (void)countPeopleWithNumberGreaterThen:(int)number withCompetionBlock:(void (^)(NSUInteger))completion
{
        NSUInteger (^countBlock)(NSManagedObjectContext*) = ^NSUInteger (NSManagedObjectContext *context){
            return [self fetchPeopleWithPredicates:Nil inContext:context shouldReturnEntities:YES].count;
        };
        [self countDataInBackgroundWithBlock:countBlock withCompletion:completion];
}

-(NSArray*)fetchPeopleWithPredicates:(NSArray*)predicates inContext:(NSManagedObjectContext*)context shouldReturnEntities:(BOOL)returnEntities
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person entityName]];
    if(predicates){
        request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    }
    NSError *error;
    NSArray *fetchResult = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }
    return returnEntities ? fetchResult : [self getObjectIDsArrayFromEntitesArray:fetchResult];
}

@end
