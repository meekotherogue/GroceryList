//
//  ListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-29.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ListViewController.h"
#import "ShowItemLocationViewController.h"

@interface ListViewController ()
{
    NSMutableArray* itemsSelected;
}
@end

@implementation ListViewController
@synthesize delegate;

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
	// Do any additional setup after loading the view.
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addList)];
    self.navigationItem.rightBarButtonItem = addButton;
    itemsSelected = [[NSMutableArray alloc] initWithCapacity:0];
    
    UISwipeGestureRecognizer *showLocationSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    showLocationSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    //[self.tableView addGestureRecognizer:showLocationSwipe];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //self.currentList = NULL;
    if([delegate respondsToSelector:@selector(addItems:)])
    {
        [delegate addItems:itemsSelected];
    }
    itemsSelected = NULL;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    int index = swipedIndexPath.row;
    GroceryItem* cell = self.currentList.listOfItems[index];
    if([cell.venueID length] <= 0)
    {
        return;
    }
    NSArray* coords = [cell.venueID componentsSeparatedByString: @","];
    double lat = [coords[0] doubleValue];
    double lng = [coords[1] doubleValue];
    
    NSArray* titles = [cell.locationName componentsSeparatedByString: @" - "];
    NSString* name = titles[0];
    NSString* address = @"";
    if(titles.count > 1)
    {
        address = titles[1];
    }
    
    ShowItemLocationViewController* showItemListViewController = [ShowItemLocationViewController alloc];
    showItemListViewController = [[ShowItemLocationViewController alloc] initWithNibName:@"ShowItemLocationViewController" bundle:nil];
    [showItemListViewController setLocation:lat longitude:lng name:name address:address];
    showItemListViewController.delegate = self;
    
    [ self.navigationController pushViewController:showItemListViewController animated:YES ];
}

//Add the list to the current list.
-(void)addList
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add List" message:@"Are you sure you want to add this list's items to your Current List?" delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"Ok", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        if([delegate respondsToSelector:@selector(addList:)])
        {
            [delegate addList:self.currentList];
        }
    }
}

//keep track of individual items to add to the Current list.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroceryItem* item = self.currentList.listOfItems[indexPath.row];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [itemsSelected removeObject:item];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [itemsSelected addObject:item];
    }
}

@end
