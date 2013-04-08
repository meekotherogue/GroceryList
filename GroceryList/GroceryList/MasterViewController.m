//
//  MasterViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-02.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "MasterViewController.h"

//#import "DetailViewController.h"
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
/*@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;*/
/*- (void)updateView;
- (void)cancelRequest;
- (void)prepareForRequest;
- (void)searchVenues;
- (void)checkin;*/
@end

@implementation MasterViewController
@synthesize foursquare = foursquare_;
/*@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;*/

//const NSString* kClientID = @"2QEASHX551GMJR211GJ2GK5GMWNNYWOZ3OJE0FTGYWMGJ5VT";
//const NSString* kCallbackURL = @"groclist://grocerylist";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
       /* self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        foursquare_.version = @"20111119";
        foursquare_.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        foursquare_.sessionDelegate = self;*/
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
    
    self.databaseHelper = [[DatabaseHelper alloc] init];
    
    //TODO: load from phone, items that already exist
    _allLists = [[NSMutableArray alloc] initWithCapacity:0];
    _allRecipes = [[NSMutableArray alloc] initWithCapacity:0];
    _allItems = [[NSMutableDictionary alloc] initWithCapacity:0];

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
        else
        {
            //item.hashed = existingItem.hashed;
        }
        [itemsToAdd addObject:item];
    }
    [self.databaseHelper saveItems:itemsToAdd];
    return list;
}

//Delegates
//CreateList delegate
-(void)listCompleted:(GroceryList*)list
{
    _currentList = list;
    [_allLists addObject:list];
    
    NSMutableArray* listArray = [[NSMutableArray alloc] initWithCapacity:0];
    [listArray addObject:[self addItemsFromList:list]];
    [self.databaseHelper saveLists:listArray whichToSave:@"List"];
}
//ListSelected delegate
-(void)listsSelected:(NSMutableArray*)lists
{
    for (int i = 0; i < lists.count; i++)
    {
        GroceryList* curList = lists[i];
        if(_currentList == nil)
        {
            _currentList = curList;
            continue;
        }
        for(int j = 0; j < curList.listOfItems.count; j++)
        {
            GroceryItem* item = curList.listOfItems[j];
            [_currentList addItem:item];
        }
    }
}
//RecipesSelected delegate
-(void)recipeSelected:(NSMutableArray*)recipes
{
    for(int i = 0; i < recipes.count; i++)
    {
        GroceryList* recipe = recipes[i];
        if(_currentList == nil)
        {
            _currentList = recipe;
            continue;
        }
        for(int j = 0; j < recipe.listOfItems.count; j++)
        {
            GroceryItem* item = recipe.listOfItems[j];
            [_currentList addItem:item];
        }
    }
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
//Add Items to list delegate
-(void)addItems:(NSMutableArray*)items
{
    for(int i = 0; i < items.count; i++)
    {
        GroceryItem* item = items[i];
        [_currentList addItem:item];
    }
}
-(void)checkInCompleted:(NSMutableDictionary*)venue
{
    for(int i = 0; i < _currentList.listOfItems.count; i++)
    {
        GroceryItem* curItem = _currentList.listOfItems[i];
        GroceryItem* itemToUpdate = _allItems[curItem.key];
        itemToUpdate.venueID[0] = venue[@"id"];
        itemToUpdate.locationName = venue[@"name"];
        curItem.venueID[0] = venue[@"id"];
        curItem.locationName = venue[@"name"];
    }
    [self.databaseHelper updateItemsWithLocation:_currentList.listOfItems listName:_currentList.name];
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

// Customize the appearance of table view cells.
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
    // Return NO if you do not want the specified item to be editable.
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = (indexPath.section == 2) ? 5 : (indexPath.section * 1) + indexPath.row;
    //NSInteger index = (indexPath.section * 1) + indexPath.row;
    
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
        

        self.currentListViewController = [[CurrentListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
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
            //Blah
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
        UINavigationController* nav =[[UINavigationController alloc]initWithRootViewController:self.listViewController];
        
        [ self.navigationController pushViewController:self.listViewController animated:YES ];
    }
    //Show recipes
    else if(index == 3)
    {
        self.recipeListViewController = NULL;
        self.recipeListViewController = [[RecipeListViewController alloc] initWithNibName:@"RecipeListViewController" bundle:nil];
        self.recipeListViewController.delegate = self;
        self.recipeListViewController.allRecipes = _allRecipes;
        UINavigationController* nav =[[UINavigationController alloc]initWithRootViewController:self.recipeListViewController];

        [ self.navigationController pushViewController:self.recipeListViewController animated:YES ];
    }
    //Show all items
    else if(index == 4)
    {
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
        //ß[self.checkInViewController setFoursquareObject:foursquare_];
    
        [ self.navigationController pushViewController:self.checkInViewController animated:YES];
    }
}

@end
