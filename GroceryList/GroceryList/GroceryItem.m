//
//  GroceryItem.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-17.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "GroceryItem.h"

@implementation GroceryItem

-(id)initWithName:(NSString *)name
{
    self=[super init];

    if(self != nil)
    {
        self.name = name;
        self.key = [name lowercaseString];
        self.quantity = @"";
        [self initLocation];
    }
    return (self);
}
-(id)initWithNameAndQuantity:(NSString*)name quantity:(NSString*)quantity
{
    self=[super init];
    
    if(self != nil)
    {
        self.name = name;
        self.key = [name lowercaseString];
        self.quantity = quantity;
        [self initLocation];
    }
    return (self);
}
-(void)initLocation
{
    self.locationName = @"";
    self.venueID = @"";
}
-(id)copyWithZone:(NSZone *)zone
{
    GroceryItem* anotherItem = [[GroceryItem alloc] init];
    anotherItem.name = [self.name copyWithZone: zone];
    anotherItem.locationName = [self.locationName copyWithZone: zone];
    anotherItem.venueID = [self.venueID copyWithZone: zone];
    anotherItem.key = [self.key copyWithZone: zone];
    anotherItem.quantity = [self.quantity copyWithZone: zone];
    anotherItem.list = [self.list copyWithZone: zone];
    return anotherItem;
}
@end
