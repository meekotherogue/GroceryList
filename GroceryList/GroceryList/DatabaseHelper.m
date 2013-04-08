
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
                char* createItem = "CREATE TABLE IF NOT EXISTS Item (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, item_id TEXT)";
                if (sqlite3_exec(groceryDB, createItem, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Error: %s", errMsg);
                }
                char* createItemQuant = "CREATE TABLE IF NOT EXISTS Item_Quantity (id INTEGER PRIMARY KEY AUTOINCREMENT, item_name TEXT, list_name TEXT, quantity TEXT, location_name TEXT, venue_id TEXT)";
                if (sqlite3_exec(groceryDB, createItemQuant, NULL, NULL, &errMsg) != SQLITE_OK)
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
        toReturn = [NSString stringWithFormat: @"%@%@", toReturn, item.key];
        if(i != list.listOfItems.count-1)
        {
            toReturn = [NSString stringWithFormat: @"%@,", toReturn];
        }
    }
    return toReturn;
}

-(NSString*)formatIds:(NSString*)ids
{
    NSArray* stringArray = [ids componentsSeparatedByString: @","];
    NSString* toReturn = @"";
    for(int i = 0; i < stringArray.count; i++)
    {
        toReturn = [NSString stringWithFormat: @"%@\"%@\"", toReturn, stringArray[i]];
        if(i != stringArray.count-1)
        {
            toReturn = [NSString stringWithFormat: @"%@,", toReturn];
        }
    }
    return toReturn;
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
        itemIds = [self formatIds: itemIds];
        
        GroceryList* list = [[GroceryList alloc] initWithName:name];
        list.dateCreated = dateCreated;
        list.listOfItems = [self loadItemsGivenItemId:itemIds listName:name];
        [lists addObject:list];
        
    }
    sqlite3_finalize(loadListStatment);
    sqlite3_close(groceryDB);
    return lists;
}

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
        NSString* itemId = item.key;
        NSString* venueId = item.venueID;
        
        NSString* insertItemSQL =
            [NSString stringWithFormat: @"INSERT INTO Item (name, item_id) VALUES (\"%@\", \"%@\")", name, itemId];
        
        const char* insertItem = [insertItemSQL UTF8String];
        sqlite3_prepare_v2(groceryDB, insertItem, -1, &insertItemsStatement, NULL);
        if (sqlite3_step(insertItemsStatement) != SQLITE_DONE)
        {
            NSLog(@"Inserting into Item failed.");
        }
        sqlite3_finalize(insertItemsStatement);

        NSString* quantity = item.quantity;
        NSString* parent = item.list;
        NSString* insertItemQuantSQL =
        [NSString stringWithFormat: @"INSERT INTO Item_Quantity (item_name, list_name, quantity, location_name, venue_id) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", name, parent,quantity, locationName, venueId];
        const char* insertItemQuant = [insertItemQuantSQL UTF8String];
        sqlite3_prepare_v2(groceryDB, insertItemQuant, -1, &insertItemsStatement, NULL);
        if (sqlite3_step(insertItemsStatement) != SQLITE_DONE)
        {
            NSLog(@"Inserting into Item_Quantity failed.");
        }
        sqlite3_finalize(insertItemsStatement);
    }
    sqlite3_close(groceryDB);
}

-(void)saveItemQuantities:(NSMutableArray*)items
{

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
    
    NSString* loadItemSQL = [NSString stringWithFormat: @"SELECT name, item_id FROM Item"];
    
    const char *loadItemQuery = [loadItemSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadItemQuery, -1, &loadItemStatment, NULL) != SQLITE_OK)
    {
        NSLog(@"%s", sqlite3_errmsg(groceryDB));
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadItemStatment) == SQLITE_ROW)
    {
        sqlite3_stmt* loadItemDataStatment;
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 0)];
        NSString* itemId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 1)];
        
        NSString* loadItemDataSQL = [NSString stringWithFormat: @"SELECT quantity, location_name, list_name, venue_id FROM Item_Quantity WHERE item_name=\"%@\"",name];
        
        const char *loadItemDataQuery = [loadItemDataSQL UTF8String];
        
        if (sqlite3_prepare_v2(groceryDB, loadItemDataQuery, -1, &loadItemDataStatment, NULL) != SQLITE_OK)
        {
            NSLog(@"%s", sqlite3_errmsg(groceryDB));
            sqlite3_close(groceryDB);
            return NULL;
        }
        while (sqlite3_step(loadItemDataStatment) == SQLITE_ROW)
        {
            NSString* quantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 0)];
            NSString* locationName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 1)];
            NSString* listName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 2)];
            NSString* venueId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 3)];
            
            GroceryItem* item = [[GroceryItem alloc] initWithNameAndQuantity:name quantity:quantity];
            item.locationName = locationName;
            item.list = listName;
            item.venueID = venueId;
            [items setObject:item forKey:item.key];
        }
        sqlite3_finalize(loadItemDataStatment);
    }
    sqlite3_finalize(loadItemStatment);
    sqlite3_close(groceryDB);
    return items;
}

-(NSMutableArray*)loadItemsGivenItemId:(NSString*)itemIds listName:(NSString*)listName
{
    const char* dbpath = [databasePath UTF8String];
    sqlite3_stmt* loadItemStatment;
    NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return NULL;
    }
    
    NSString* loadItemSQL = [NSString stringWithFormat: @"SELECT name, item_id FROM Item WHERE item_id IN (%@)", itemIds];
    
    const char *loadItemQuery = [loadItemSQL UTF8String];
    
    if (sqlite3_prepare_v2(groceryDB, loadItemQuery, -1, &loadItemStatment, NULL) != SQLITE_OK)
    {
        NSLog(@"%s", sqlite3_errmsg(groceryDB));
        sqlite3_close(groceryDB);
        return NULL;
    }
    while (sqlite3_step(loadItemStatment) == SQLITE_ROW)
    {
        NSString* name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemStatment, 0)];

        sqlite3_stmt* loadItemDataStatment;
        NSString* loadItemDataSQL = [NSString stringWithFormat: @"SELECT quantity, location_name, venue_id FROM Item_Quantity WHERE item_name=\"%@\" AND list_name=\"%@\"",name,listName];
        
        const char *loadItemDataQuery = [loadItemDataSQL UTF8String];
        
        if (sqlite3_prepare_v2(groceryDB, loadItemDataQuery, -1, &loadItemDataStatment, NULL) != SQLITE_OK)
        {
            NSLog(@"%s", sqlite3_errmsg(groceryDB));
            sqlite3_close(groceryDB);
            return NULL;
        }
        while (sqlite3_step(loadItemDataStatment) == SQLITE_ROW)
        {
            NSString* quantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 0)];
            NSString* locationName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 1)];
            NSString* venueId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(loadItemDataStatment, 2)];
            
            GroceryItem* item = [[GroceryItem alloc] initWithNameAndQuantity:name quantity:quantity];
            item.locationName = locationName;
            item.list = listName;
            item.venueID = venueId;
            [items addObject:item];
        }
        sqlite3_finalize(loadItemDataStatment);
    }
    sqlite3_finalize(loadItemStatment);
    sqlite3_close(groceryDB);
    return items;
}

-(void)updateItemsWithLocation:(NSMutableArray*)items listName:(NSString *)listName
{
    sqlite3_stmt* updateItemsStatement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &groceryDB) != SQLITE_OK)
    {
        return;
    }
    
    for(int i = 0; i < items.count; i++)
    {
        GroceryItem* item = items[i];
        NSString* locationName = item.locationName;
        NSString* name = item.name;
        NSString* venueId = item.venueID;

        const char *updateItemSQL = "update Item_Quantity Set location_name = ?, venue_id = ? WHERE item_name = ? AND list_name = ?";
        if(sqlite3_prepare_v2(groceryDB, updateItemSQL, -1, &updateItemsStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(groceryDB));
        }
    
        sqlite3_bind_text(updateItemsStatement, 1, [locationName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateItemsStatement, 2, [venueId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateItemsStatement, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateItemsStatement, 4, [listName UTF8String], -1, SQLITE_TRANSIENT);
    
        if(SQLITE_DONE != sqlite3_step(updateItemsStatement))
        {
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(groceryDB));
        }
    
        sqlite3_reset(updateItemsStatement);
        
    }
    sqlite3_close(groceryDB);
}

@end
