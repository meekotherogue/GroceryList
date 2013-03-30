//
//  ListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-29.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

//Override superclass method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
