//
//  DatabaseHelper.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-29.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GroceryList.h"

@interface DatabaseHelper : NSObject
{
    NSString* databasePath;
    sqlite3* groceryDB;
}
-(id) init;
-(void)saveLists:(NSArray*)lists whichToSave:(NSString*)whichToSave;
-(NSMutableArray*)loadLists:(NSString*)whichToLoad;
-(void)saveItems:(NSMutableArray*)items;
-(NSMutableDictionary*)loadItems;
-(void)updateItemsWithLocation:(NSMutableArray*)items listName:(NSString*)listName;

@end
