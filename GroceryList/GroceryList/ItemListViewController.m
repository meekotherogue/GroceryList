//
//  ItemListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-24.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ItemListViewController.h"

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
    
    /*allItemsArray = [self.allItems keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                   {
                                       GroceryItem* item1 = obj1;
                                       GroceryItem* item2 = obj2;
                                       return [item2.name compare:item1.name];
                                   }];*/
    
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
