//
//  ListsViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ListsViewController.h"
#import "GroceryList.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)backPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(listSelected:)])
    {
        if(_currentSelection != nil)
        {
            [delegate listSelected:_currentSelection.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_currentSelection != nil)
    {
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:_currentSelection];
        currentCell.accessoryType = UITableViewCellAccessoryNone;
    }
    _currentSelection = indexPath;
}
@end
