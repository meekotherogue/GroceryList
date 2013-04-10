
//
//  ListsViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ListsViewController.h"
#import "GroceryList.h"
#import "ListViewController.h"

@interface ListsViewController ()

@end

@implementation ListsViewController
@synthesize delegate;

NSIndexPath* _currentSelection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listsToAddToCurrent = [[NSMutableArray alloc] initWithCapacity:0];
    self.itemsToAddToCurrent = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addList:(GroceryList*)list
{
    [self.listsToAddToCurrent addObject:list];
}
-(void)addItems:(NSMutableArray*)items
{
    [self.itemsToAddToCurrent addObjectsFromArray:items];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([delegate respondsToSelector:@selector(listsSelected:)])
        {
            [delegate listsSelected:self.listsToAddToCurrent];
        }
        if([delegate respondsToSelector:@selector(itemsSelectedFromLists:)])
        {
            [delegate itemsSelectedFromLists:self.itemsToAddToCurrent];
        }
    }
    [super viewWillDisappear:animated];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allLists.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    GroceryList* list = self.allLists[indexPath.row];
    cell.textLabel.text = list.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Push the List view of the list selected
    ListViewController* listViewController = [[ListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
    listViewController.delegate = self;
    GroceryList* listToSet = _allLists[indexPath.row];
    [listViewController setList:listToSet];
    [self.navigationController pushViewController:listViewController animated:YES];
}
@end
