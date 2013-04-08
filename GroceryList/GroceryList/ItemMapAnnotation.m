//
//  ItemMapAnnotation.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-04-07.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ItemMapAnnotation.h"

@implementation ItemMapAnnotation

@synthesize coordinate = _coordinate;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        self.name = [name copy];
        self.address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    if ([_name isKindOfClass:[NSNull class]])
    {
        return @"Unknown title";
    }
    else
    {
        return self.name;
    }
}

- (NSString *)subtitle
{
    return self.address;
}

@end