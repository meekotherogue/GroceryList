//
//  GroceryItem.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-17.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroceryItem : NSObject
@property NSString* name;
@property NSString* locationName; //Human readable string of the latest checkin place
@property NSMutableArray* venueID; //Array of id strings for venues this item has been checked in at.
@property BOOL checked;

-(id)initWithName:(NSString*)name;
@end
