//
//  Person.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 02/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "Person.h"


@implementation Person

@dynamic name;
@dynamic number;

+ (NSString*)entityName
{
    return @"Person";
}
@end
