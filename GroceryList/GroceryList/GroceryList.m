//
//  GroceryList.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-17.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "GroceryList.h"

@implementation GroceryList
-(id)initWithName:(NSString *)name
{
    self=[super init];
    
    if(self != nil)
    {
        self.name = name;
        self.listOfItems = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return (self);
}
@end
