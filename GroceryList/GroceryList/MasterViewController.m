//
//  MasterViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-02.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "MasterViewController.h"

#import "CreateListViewController.h"
#import "CurrentListViewController.h"
#import "ListsViewController.h"
#import "RecipeListViewController.h"
#import "AddRecipeViewController.h"
#import "GroceryList.h"
#import "DatabaseHelper.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
    NSArray* _tableData;
    GroceryList* _currentList;
    NSMutableArray* _allLists;
    GroceryList* _currentRecipe;
    NSMutableArray* _allRecipes;
    NSMutableDictionary* _allItems;
}
@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@end

@implementation MasterViewController
@synthesize foursquare = foursquare_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Grocery List";
    
	// Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TitlePage" ofType:@"plist"];
    _tableData = [NSArray arrayWithContentsOfFile:filePath];
    _allLists = [[NSMutableArray alloc] initWithCapacity:0];
    _allRecipes = [[NSMutableArray alloc] initWithCapacity:0];
    _allItems = [[NSMutableDictionary alloc] initWithCapacity:0];

    self.databaseHelper = [[DatabaseHelper alloc] init];
    _allItems = [self.databaseHelper loadItems];
    _allLists = [self.databaseHelper loadLists:@"List"];
    _allRecipes = [self.databaseHelper loadLists:@"Recipe"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// Add the items from another list/recipe to the Current list.
-(GroceryList*)addItemsFromList:(GroceryList*)list
{
    NSMutableArray* itemsToAdd = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < list.listOfItems.count; i++)
    {
        GroceryItem* item =list.listOfItems[i];
        NSString* itemKey = item.key;
        GroceryItem* existingItem = _allItems[itemKey];
        if(!existingItem)
        {
            [_allItems setObject:list.listOfItems[i] forKey:item.name];
        }
        [itemsToAdd addObject:item];
    }
    //Add the item to the database.
    [self.databaseHelper saveItems:itemsToAdd];
    return list;
}

//Delegates
//CreateList delegate
-(void)listCompleted:(GroceryList*)list
{
    _currentList = list;
    [_allLists addObject:list];
    
    self.currentListViewController = [[CurrentListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
    NSMutableArray* listArray = [[NSMutableArray alloc] initWithCapacity:0];
    [listArray addObject:[self addItemsFromList:list]];
    [self.databaseHelper saveLists:listArray whichToSave:@"List"];
}
//ListSelected delegate
-(void)listsSelected:(NSMutableArray*)lists
{
    bool newList = false;
    NSMutableArray* itemsToAdd = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < lists.count; i++)
    {
        GroceryList* curList = lists[i];
        
        //If the Current list is empty, create a new list.
        if(_currentList == nil)
        {
            _currentList = [[GroceryList alloc] init];
            newList = true;
        }
        //Add each object to the Current list
        for(int j = 0; j < curList.listOfItems.count; j++)
        {
            GroceryItem* item = curList.listOfItems[j];
            [_currentList addItem:[item copy]];
            
            //Keep items we need to update in the Item_Quantity table
            item.list = _currentList.name;
            [itemsToAdd addObject:[item copy]];
        }
    }
    //If the Current list is new, add it to the list array to persist it.
    if(newList)
    {
        [self saveNewListFromCurrent];
    }
    else
    {
        //Update the List itself
        [self saveNewItemsToExistingList:itemsToAdd];
    }
}
//RecipesSelected delegate
-(void)recipeSelected:(NSMutableArray*)recipes
{
    [self listsSelected:recipes];
}

//Delegate for adding the recipe items to the list of all items
-(void)recipesAdded:(NSMutableArray*)list
{
    NSMutableArray* recipeArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < list.count; i++)
    {
        GroceryList* curRecipe = list[i];
        [self addItemsFromList:curRecipe];
        [recipeArray addObject:curRecipe];
    }
    [self.databaseHelper saveLists:recipeArray whichToSave:@"Recipe"];
}
//Add Items for list delegate
-(void)addItems:(NSMutableArray*)items
{
    bool newList = false;
    if(items.count == 0)
    {
        return;
    }
    if(_currentList == nil)
    {
        newList = true;
        _currentList = [[GroceryList alloc] init];
    }
    for(int i = 0; i < items.count; i++)
    {
        GroceryItem* item = items[i];
        [_currentList addItem:item];
    }
    if(newList)
    {
        [self saveNewListFromCurrent];
    }
    else
    {
        [self saveNewItemsToExistingList:items];
    }
}
//Add items from other lists delegate
-(void)itemsSelectedFromLists:(NSMutableArray*)items
{
    [self addItems:items];
}
//Add items from other recipes delegate
-(void)itemsSelectedFromRecipes:(NSMutableArray*)items
{
    [self addItems:items];
}

//Foursquare checkin is complete.
-(void)checkInCompleted:(NSMutableDictionary*)venue
{
    for(int i = 0; i < _currentList.listOfItems.count; i++)
    {
        GroceryItem* curItem = _currentList.listOfItems[i];
        GroceryList* updateList = [self findListByName:curItem.list];
        GroceryItem* itemToUpdate = [self findItemInListByName:updateList.listOfItems name:curItem.key];
        itemToUpdate.venueID = [NSString stringWithFormat:@"%@,%@",venue[@"location"][@"lat"],venue[@"location"][@"lng"]];
        itemToUpdate.locationName = venue[@"name"];
        curItem.venueID = itemToUpdate.venueID;
        curItem.locationName = venue[@"name"];
    }
    //Update the location of each item in the Current list.
    [self.databaseHelper updateItemsWithLocation:_currentList.listOfItems listName:_currentList.name];
}

//Helper methods
//Get a list given it's name
-(GroceryList*)findListByName:(NSString*)name
{
    GroceryList* foundList;
    for (GroceryList* list in _allLists)
    {
        if([list.name isEqualToString:name])
        {
            foundList = list;
            break;
        }
    }
    return foundList;
}
//Get an item given its name
-(GroceryItem*)findItemInListByName:(NSMutableArray*)list name:(NSString*)name
{
    GroceryItem* foundItem;
    for (GroceryItem* item in list)
    {
        if([item.key isEqualToString:name])
        {
            foundItem = item;
            break;
        }
    }
    return foundItem;
}
//Save the Current List if creating it from another list, recipe, or items
-(void)saveNewListFromCurrent
{
    GroceryList* newGroceryList = [_currentList copy];
    [_allLists addObject:newGroceryList];
    NSMutableArray* listArray = [[NSMutableArray alloc] initWithCapacity:0];
    [listArray addObject:[self addItemsFromList:newGroceryList]];
    [self.databaseHelper saveLists:listArray whichToSave:@"List"];
}
//Save items that were added from other lists to the existing current list.
-(void)saveNewItemsToExistingList:(NSMutableArray*)itemsToAdd
{
    GroceryList* updateList = [self findListByName:_currentList.name];
    for (GroceryItem* item in itemsToAdd)
    {
        [updateList addItem:[item copy]];
    }
    [self.databaseHelper updateList:[_currentList copy] items:itemsToAdd];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == 2) return 1;
    else return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if(indexPath.section == 2)
    {
        NSString *object = _tableData[5];
        NSString* label = [object description];
        cell.textLabel.text = label;
        
        return cell;
    }
    NSInteger index = (indexPath.section * 1) + indexPath.row;
    NSString *object = _tableData[index];
    NSString* label = [object description];
    cell.textLabel.text = label;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// Create new view based on entry.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = (indexPath.section == 2) ? 5 : (indexPath.section * 1) + indexPath.row;
    
    //Show current list
    if(index == 0)
    {
        if(_currentList == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No list selected"
                                                            message:@"You must select or create a list in order to set the Current List"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(_allLists.count <= 0 && _allRecipes <= 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No lists entered"
                                                            message:@"You must enter a list into the app before you can view one.  Please go to \"Create List\" and enter your list."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(self.currentListViewController == NULL)
        {
            self.currentListViewController = [[CurrentListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
        }
        self.currentListViewController.delegate = self;
        [self.currentListViewController setList:_currentList];

        [ self.navigationController pushViewController:self.currentListViewController animated:YES];
    }
    //Create list view
    else if(index == 1)
    {
        if(self.createListViewController) self.createListViewController = NULL;

        self.createListViewController = [[CreateListViewController alloc] initWithNibName:@"CreateListViewController" bundle:nil];
        self.createListViewController.delegate = self;
        [ self presentViewController:self.createListViewController animated:YES completion:^{
        }];
    }
    //View all lists
    else if(index == 2)
    {
        if(_allLists.count <= 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No lists entered"
                                                            message:@"You must enter a list into the app before you can view one.  Please go to \"Create List\" and enter your list."
                                                            delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

        self.listViewController = [[ListsViewController alloc] initWithNibName:@"ListsViewController" bundle:nil];
        self.listViewController.delegate = self;
        self.listViewController.allLists = _allLists;
        
        [ self.navigationController pushViewController:self.listViewController animated:YES ];
    }
    //Show recipes
    else if(index == 3)
    {
        self.recipeListViewController = NULL;
        self.recipeListViewController = [[RecipeListViewController alloc] initWithNibName:@"RecipeListViewController" bundle:nil];
        self.recipeListViewController.delegate = self;
        self.recipeListViewController.allRecipes = _allRecipes;

        [ self.navigationController pushViewController:self.recipeListViewController animated:YES ];
    }
    //Show all items
    else if(index == 4)
    {
        _allItems = [[NSMutableDictionary alloc] initWithCapacity:0];
        _allItems = [self.databaseHelper loadItems];
        
        self.itemListViewController = NULL;
        self.itemListViewController = [[ItemListViewController alloc] initWithNibName:@"ItemListViewController" bundle:nil];
        self.itemListViewController.delegate = self;
        self.itemListViewController.allItems = _allItems;
        
        [ self.navigationController pushViewController:self.itemListViewController animated:YES];
    }
    //Check in with Foursquare
    else if(index == 5)
    {
        if(self.checkInViewController == NULL)
        {
            self.checkInViewController = [[CheckInViewController alloc] initWithNibName:@"CheckInViewController" bundle:nil];
        }
        self.checkInViewController.delegate = self;
    
        [ self.navigationController pushViewController:self.checkInViewController animated:YES];
    }
}

@end
