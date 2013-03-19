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
        self.listOfItems = [[NSMutableArray alloc] initWithCapacity:0];
        self.dateCreated = [self getDate];
    }
    return (self);
}
-(id)init
{
    self=[super init];
    
    if(self != nil)
    {
        self.listOfItems = [[NSMutableArray alloc] initWithCapacity:0];
        self.dateCreated = [self getDate];
        self.name = [self getDate];
    }
    return (self);
}
-(void)addItem:(GroceryItem *)item
{
    [self.listOfItems addObject:item];
}
-(NSString*)getDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end
