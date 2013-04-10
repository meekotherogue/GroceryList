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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GroceryItem* item = self.currentList.listOfItems[indexPath.row];
    if([item.locationName length] != 0)
    {
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        /*UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 5, 100.0, 35.0)];
        [title setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        title.text = item.name;
        [cell.contentView addSubview:title];
        
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 5, 100.0, 35.0)];
        [location setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        location.text = item.locationName;
        [cell.contentView addSubview:location];*/
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@\n%@",item.quantity,item.name,item.locationName];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",item.quantity,item.name];
    }
    
    return cell;
}

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    GroceryItem* cell = self.currentList.listOfItems[swipedIndexPath.row];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
