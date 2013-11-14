//
//  Database+Client.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTDatabase.h"
#import "Client.h"
@interface NTDatabase (Database_Client)

#pragma mark - Async methods

- (void)addClientWithName:(NSString*)clientName andID:(int)idNumber withCompetionBlock:(void (^)(NSArray*))completion;
- (void)addClientWithName:(NSString*)clientName andID:(int)idNumber andProjects:(NSSet*)projects withCompetionBlock:(void (^)(NSArray*))completion;

#pragma mark - sync methods

- (NSManagedObjectID*)addClientWithName:(NSString*)clientName andID:(int) idNumber inContext:(NSManagedObjectContext*)context;
- (NSManagedObjectID*)addClientWithName:(NSString*)clientName andID:(int) idNumber andAddProjects:(NSSet*)projects inContext:(NSManagedObjectContext*)context;

@end
