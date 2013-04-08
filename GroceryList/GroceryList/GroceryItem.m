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
        self.hashed = [NSString stringWithFormat:@"%u",self.hash];
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
        self.hashed = [NSString stringWithFormat:@"%u",self.hash];
    }
    return (self);
}
-(void)initLocation
{
    self.locationName = @"";
}
@end
