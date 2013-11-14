//
//  Client.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person.h"

@class Project;

@interface Client : Person

@property (nonatomic, retain) NSSet *projects;
@end

@interface Client (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
