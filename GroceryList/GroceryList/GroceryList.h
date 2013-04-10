//
//  GroceryList.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-17.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroceryItem.h"

@interface GroceryList : NSObject
@property NSMutableArray* listOfItems;
@property NSString* name;
@property NSString* dateCreated;

-(id)init;
-(id)initWithName:(NSString*)name;

-(void)addItem:(GroceryItem*)item;
-(void)removeItem:(int)index;
@end
