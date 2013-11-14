//
//  NSManagedObject+EntityName.m
//  Example DataBase Project
//
//  Created by Adam Szeptycki on 13/11/13.
//  Copyright (c) 2013 Adam Szeptycki. All rights reserved.
//

#import "NSManagedObject+EntityName.h"

@implementation NSManagedObject (NSManagedObject_EntityName)

+ (NSString*)entityName
{
    return [NSString stringWithFormat:@"%@", [self class]];
}

@end
