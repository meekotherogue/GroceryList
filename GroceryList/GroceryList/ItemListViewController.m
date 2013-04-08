//
//  ItemListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-24.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ItemListViewController.h"
#import "ShowItemLocationViewController.h"

@interface ItemListViewController ()
{
    int _rows;
    NSArray* allItemsArray;
    NSMutableArray* itemsSelected;
}
@end

@implementation ItemListViewController
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
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _rows = 0;
    self.title = @"All Items";
    itemsSelected = [[NSMutableArray alloc] initWithCapacity:0];
    
    UISwipeGestureRecognizer *showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:showExtrasSwipe];
    
    allItemsArray = [self.allItems allValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Actions
-(IBAction)backPressed:(id)sender
{
    _rows = 0;
    self.allItems = NULL;
    [self dismissModalViewControllerAnimated:YES];
    //Delegate to send items back
    [self dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(addItems:)])
    {
        [delegate addItems:itemsSelected];
    }
    itemsSelected = NULL;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    _rows = 0;
    self.allItems = NULL;
    if([delegate respondsToSelector:@selector(addItems:)])
    {
        [delegate addItems:itemsSelected];
    }
    itemsSelected = NULL;
    [super viewWillDisappear:animated];
}

//End Actions

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
//    UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    GroceryItem* cell = allItemsArray[swipedIndexPath.row];
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

//Table methods
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    GroceryItem* item = allItemsArray[indexPath.row];
    
    if([item.locationName length] != 0)
    {
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",item.name,item.locationName];
    }
    else
    {
        cell.textLabel.text = item.name;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    GroceryItem* item = allItemsArray[indexPath.row];
    [itemsSelected addObject:item];
}
@end
