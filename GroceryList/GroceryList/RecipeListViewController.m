//
//  RecipeListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "RecipeListViewController.h"

@interface RecipeListViewController ()

@end
@implementation RecipeListViewController

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
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITextField *inputField;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    
    
    return cell;
}

-(IBAction)backPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addPressed:(id)sender
{
    /*if([delegate respondsToSelector:@selector(recipeEntered)])
    {
        //send the delegate function with the amount entered by the user
        [delegate recipeEntered];
    }*/
    //[self dismissModalViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
}
@end
