//
//  CurrentListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "CurrentListViewController.h"
#import "ShowItemLocationViewController.h"

@interface CurrentListViewController ()

@end
@implementation CurrentListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.currentList.name;

    UISwipeGestureRecognizer *showLocationSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    showLocationSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:showLocationSwipe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(GroceryList*)getList
{
    return self.currentList;
}

-(void)setList:(GroceryList*) list
{
    self.currentList = list;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentList.listOfItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    GroceryItem* item = self.currentList.listOfItems[indexPath.row];
    if([item.locationName length] != 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",item.quantity,item.name];
        cell.detailTextLabel.text = item.locationName;
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",item.quantity,item.name];
    }
    
    return cell;
}

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    GroceryItem* cell = self.currentList.listOfItems[swipedIndexPath.row];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
