//
//  DatabaseHelper.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-29.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "DatabaseHelper.h"

@implementation DatabaseHelper

-(id) init
{
    self = [super init];
    if(self)
    {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"grocery.db"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            const char* dbPath = [databasePath UTF8String];
            
            if (sqlite3_open(dbPath, &groceryDB) == SQLITE_OK)
            {
                char* errMsg;
                
                char* createList = "CREATE TABLE IF NOT EXISTS List (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, datecreated TEXT, item_ids TEXT)";
                if (sqlite3_exec(groceryDB, createList, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Error: %s", errMsg);
                }
                char* createRecipe = "CREATE TABLE IF NOT EXISTS Recipe (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, datecreated TEXT, item_ids TEXT)";
                if (sqlite3_exec(groceryDB, createRecipe, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Error: %s", errMsg);
                }
                char* createItem = "CREATE TABLE IF NOT EXISTS Item (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, location_name TEXT, venue_ids TEXT, item_id TEXT)";
                if (sqlite3_exec(groceryDB, createItem, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Error: %s", errMsg);
                }
                
                sqlite3_close(groceryDB);
                
            } else {
                //fuck
            }
        }
    }
    return self;
}
-(NSString*)getItemListString:(GroceryList*)list
{
    NSString* toReturn = @"";
    for(int i = 0; i<list.listOfItems.count; i++)
    {
        GroceryItem* item = list.listOfItems[i];
        toReturn = [NSString stringWithFormat: @"%@%u", toReturn, item.hash];
        if(i != list.listOfItems.count-1)
        {
            toReturn = [NSString stringWithFormat: @"%@,", toReturn];
        }
    }
    return toReturn;
}

-(NSString*)getVenueIDString:(NSMutableArray*)venues
{
    NSString* toReturn = @"";
    for(int i = 0; i<venues.count; i++)
    {
        NSString* venue = venues[i];
        toReturn = [NSString stringWithFormat: @"%@%@", toReturn, venue];
        if(i != venues.count-1)
        {
            toReturn = [NSString stringWithFormat: @"%@,", toReturn];
        }
    }
    return toReturn;
}

-(NSMutableArray*)deserializeVenueID:(NSString*)venues
{
    NSMutableArray* newVenues = [NSMutableArray arrayWithArray:[venues componentsSeparatedByString: @","]];
    return newVenues;
}

//Database methods
-(NSMutableArray*)loadLists:(NSString*)whichToLoad
{
    const char* dbpath = [databasePath UTF8String];
    sqlite3_stmt* loadListStatment;
    NSMutableArray* lists = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return NULL;
    }
    
    NSString* loadListSQL = [NSString stringWithFormat: @"SELECT name, datecreated, item_ids FROM %@", whichToLoad];
    
    const char *loadListQuery = [loadListSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadListQuery, -1, &loadListStatment, NULL) != SQLITE_OK)
    {
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadListStatment) == SQLITE_ROW)
    {
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 0)];
        NSString* dateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 1)];
        NSString* itemIds = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 2)];
        
        GroceryList* list = [[GroceryList alloc] initWithName:name];
        list.dateCreated = dateCreated;
        list.listOfItems = [self loadItemsGivenItemId:itemIds];
        [lists addObject:list];
        
    }
    sqlite3_finalize(loadListStatment);
    sqlite3_close(groceryDB);
    return lists;
}
/*-(NSMutableArray*)loadLists
{
    const char* dbpath = [databasePath UTF8String];
    sqlite3_stmt* loadListStatment;
    NSMutableArray* lists = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return NULL;
    }
    
    NSString* loadListSQL = [NSString stringWithFormat: @"SELECT name, datecreated, item_ids FROM List"];
    
    const char *loadListQuery = [loadListSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadListQuery, -1, &loadListStatment, NULL) != SQLITE_OK)
    {
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadListStatment) == SQLITE_ROW)
    {
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 0)];
        NSString* dateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 1)];
        NSString* itemIds = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadListStatment, 2)];
        
        GroceryList* list = [[GroceryList alloc] initWithName:name];
        list.dateCreated = dateCreated;
        list.listOfItems = [self loadItemsGivenItemId:itemIds];
        [lists addObject:list];
        
    }
    sqlite3_finalize(loadListStatment);
    sqlite3_close(groceryDB);
    return lists;
}*/

- (void)saveLists:(NSArray*)lists whichToSave:(NSString *)whichToSave
{
    sqlite3_stmt* insertListsStatement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return;
    }
    
    for(int i = 0; i < lists.count; i++)
    {
        GroceryList* list = lists[0];
        NSString* name = list.name;
        NSString* dateCreated = list.dateCreated;
        NSString* itemIds = [self getItemListString:list];
        NSString* insertListSQL =
            [NSString stringWithFormat: @"INSERT INTO %@ (name, datecreated, item_ids) VALUES (\"%@\", \"%@\", \"%@\")", whichToSave, name, dateCreated, itemIds];
       
        const char* insertList = [insertListSQL UTF8String];
        
        sqlite3_prepare_v2(groceryDB, insertList, -1, &insertListsStatement, NULL);
        if (sqlite3_step(insertListsStatement) != SQLITE_DONE)
        {
        }
        
        sqlite3_finalize(insertListsStatement);
        sqlite3_close(groceryDB);
    }
}

- (void)saveRecipes:(NSArray*)lists
{
    sqlite3_stmt* insertListsStatement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return;
    }
    
    for(int i = 0; i < lists.count; i++)
    {
        GroceryList* list = lists[0];
        NSString* name = list.name;
        NSString* dateCreated = list.dateCreated;
        NSString* itemIds = [self getItemListString:list];
        NSString* insertListSQL =
        [NSString stringWithFormat: @"INSERT INTO List (name, datecreated, item_ids) VALUES (\"%@\", \"%@\", \"%@\")", name, dateCreated, itemIds];
        
        const char* insertList = [insertListSQL UTF8String];
        
        sqlite3_prepare_v2(groceryDB, insertList, -1, &insertListsStatement, NULL);
        if (sqlite3_step(insertListsStatement) != SQLITE_DONE)
        {
        }
        
        sqlite3_finalize(insertListsStatement);
        sqlite3_close(groceryDB);
    }
}



-(void)saveItems:(NSMutableArray*)items
{
    sqlite3_stmt* insertItemsStatement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return;
    }
    
    for(int i = 0; i < items.count; i++)
    {
        GroceryItem* item = items[i];
        NSString* name = item.name;
        NSString* locationName = item.locationName;
        NSString* venueIds = [self getVenueIDString:item.venueID];
        NSUInteger* dum = item.hash;
        NSString* itemId = [NSString stringWithFormat: @"%u",item.hash];
        NSString* insertItemSQL =
            [NSString stringWithFormat: @"INSERT INTO Item (name, location_name, venue_ids, item_id) VALUES (\"%@\", \"%@\", \"%@\",\"%@\")", name, locationName,venueIds, itemId];
        
        const char* insertList = [insertItemSQL UTF8String];
        
        sqlite3_prepare_v2(groceryDB, insertList, -1, &insertItemsStatement, NULL);
        if (sqlite3_step(insertItemsStatement) == SQLITE_DONE)
        {
        }
        sqlite3_finalize(insertItemsStatement);
    }
    sqlite3_close(groceryDB);
}
-(NSMutableDictionary*)loadItems
{
    const char* dbpath = [databasePath UTF8String];
    sqlite3_stmt* loadItemStatment;
    NSMutableDictionary* items = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return NULL;
    }
    
    NSString* loadListSQL = [NSString stringWithFormat: @"SELECT name, location_name, venue_ids, item_id FROM Item"];
    
    const char *loadListQuery = [loadListSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadListQuery, -1, &loadItemStatment, NULL) != SQLITE_OK)
    {
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadItemStatment) == SQLITE_ROW)
    {
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 0)];
        NSString* locationName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 1)];
        NSString* venueIds = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 2)];
        NSMutableArray* venueIdsArray = [self deserializeVenueID:venueIds];
        NSString* itemId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 3)];
        
        GroceryItem* item = [[GroceryItem alloc] initWithName:name];
        item.locationName = locationName;
        item.venueID = venueIdsArray;
        [items setObject:item forKey:item.key];
    }
    sqlite3_finalize(loadItemStatment);
    sqlite3_close(groceryDB);
    return items;
}

-(NSMutableArray*)loadItemsGivenItemId:(NSString*)itemIds
{
    const char* dbpath = [databasePath UTF8String];
    sqlite3_stmt* loadItemStatment;
    NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return NULL;
    }
    
    NSString* loadItemSQL = [NSString stringWithFormat: @"SELECT name, location_name, venue_ids, item_id FROM Item WHERE item_id IN (%@)", itemIds];
    
    const char *loadListQuery = [loadItemSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadListQuery, -1, &loadItemStatment, NULL) != SQLITE_OK)
    {
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadItemStatment) == SQLITE_ROW)
    {
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 0)];
        NSString* locationName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 1)];
        NSString* venueIds = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 2)];
        NSMutableArray* venueIdsArray = [self deserializeVenueID:venueIds];
        
        GroceryItem* item = [[GroceryItem alloc] initWithName:name];
        item.locationName = locationName;
        item.venueID = venueIdsArray;
        [items addObject:item];
    }
    sqlite3_finalize(loadItemStatment);
    sqlite3_close(groceryDB);
    return items;
}

@end
