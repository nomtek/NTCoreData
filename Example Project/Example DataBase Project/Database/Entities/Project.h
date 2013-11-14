//
//  Project.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, Developer, ProjectManager;

@interface Project : NSManagedObject

@property (nonatomic) int16_t id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t budget;
@property (nonatomic, retain) ProjectManager *projectManagers;
@property (nonatomic, retain) NSSet *developers;
@property (nonatomic, retain) Client *client;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addDevelopersObject:(Developer *)value;
- (void)removeDevelopersObject:(Developer *)value;
- (void)addDevelopers:(NSSet *)values;
- (void)removeDevelopers:(NSSet *)values;

@end
