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
    item.list = self.name;
    [self.listOfItems addObject:item];
}
-(void)removeItem:(int)index
{
    [self.listOfItems removeObjectAtIndex:index];
}
-(NSString*)getDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(id)copyWithZone:(NSZone *)zone
{
    GroceryList* another = [[GroceryList alloc] init];
    another.name = [self.name copyWithZone: zone];
    another.dateCreated = [self.dateCreated copyWithZone: zone];
    
    another.listOfItems = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < self.listOfItems.count; i++)
    {
        GroceryItem* item = self.listOfItems[i];
        [another addItem:item];
    }
    
    return another;
}
@end
