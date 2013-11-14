//
//  Developer.h
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person.h"

@class Project;

@interface Developer : Person

@property (nonatomic, retain) NSString * platform;
@property (nonatomic) int16_t experience;
@property (nonatomic, retain) NSSet *projects;
@end

@interface Developer (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
