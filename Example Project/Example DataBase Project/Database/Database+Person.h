//
//  Database+Person.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "NTDatabase.h"


/**
 This is example category that should be done for each NSManagedObject in Model.
 */
@interface NTDatabase (Database_Person)

- (void)addPersonWithName:(NSString*) name andNumber:(int)number withCompetionBlock:(void (^)(NSArray*))completion;
- (void)fetchPersonWithName:(NSString*) name withCompetionBlock:(void (^)(NSArray*))completion;
- (void)fetchAllPeopleWithCompetionBlock:(void (^)(NSArray*))completion;
- (void)countPeopleWithNumberGreaterThen:(int)number withCompetionBlock:(void (^)(NSUInteger))completion;
- (void)removePersonWithNumber:(int)number withCompletionBlock:(void (^)(NSArray*))completion;
@end
