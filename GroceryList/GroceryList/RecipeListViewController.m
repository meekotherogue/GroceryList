//
//  RecipeListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "RecipeListViewController.h"
#import "GroceryList.h"

@interface RecipeListViewController ()

@end
@implementation RecipeListViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)recipeCreated:(GroceryList*) list
{
}

//Actions
-(IBAction)backPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addPressed:(id)sender
{
    if (!self.addRecipeViewController)
    {
        self.addRecipeViewController = [[AddRecipeViewController alloc] initWithNibName:@"AddRecipeViewController" bundle:nil];
        self.addRecipeViewController.delegate = self;
    }
    [self presentViewController:self.addRecipeViewController animated:YES completion:^{
        //Blah
    }];
}
//End Actions

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allRecipes.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    GroceryList* list = self.allRecipes[indexPath.row];
    cell.textLabel.text = list.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
}
@end
