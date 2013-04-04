//
//  RecipeListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ShowRecipeViewController.h"
#import "RecipeListViewController.h"
#import "GroceryList.h"

@interface RecipeListViewController ()
{
    int _rows;
}
@end
@implementation RecipeListViewController
@synthesize delegate;
NSMutableArray* _newRecipes;

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
    _newRecipes = [[NSMutableArray alloc] initWithCapacity:0];
    _rows = self.allRecipes.count;
    self.recipesToAddToCurrent =[[NSMutableArray alloc] initWithCapacity:0];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Recipes";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)recipeCreated:(GroceryList*) list
{
    _rows++;
    [_newRecipes addObject:list];
    [self.allRecipes addObject:list];
    [self.tableView reloadData];
}

//Actions
-(IBAction)backPressed:(id)sender
{
    _rows = 0;
    self.allRecipes = NULL;
    [self returnLists];
    if([delegate respondsToSelector:@selector(recipeSelected:)])
    {
        [delegate recipeSelected:self.recipesToAddToCurrent];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addPressed:(id)sender
{
    self.addRecipeViewController = NULL;
    self.addRecipeViewController = [[AddRecipeViewController alloc] initWithNibName:@"AddRecipeViewController" bundle:nil];
    self.addRecipeViewController.delegate = self;
    [self presentViewController:self.addRecipeViewController animated:YES completion:^{
    }];
}
//End Actions

-(void)addRecipe:(GroceryList*)list
{
    [self.recipesToAddToCurrent addObject:list];
}

-(void)returnLists
{
    if([delegate respondsToSelector:@selector(recipesAdded:)])
    {
        [delegate recipesAdded:_newRecipes];
    }
}

//Table methods
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
    NSLog(@"%d",indexPath.row);
    GroceryList* list = self.allRecipes[indexPath.row];
    cell.textLabel.text = list.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];

    /*if([delegate respondsToSelector:@selector(recipeSelected:)])
    {
        [self returnLists];
        [delegate recipeSelected:indexPath.row];
    }*/
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowRecipeViewController* showRecipeViewController = [[ShowRecipeViewController alloc] initWithNibName:@"ShowRecipeViewController" bundle:nil];
    showRecipeViewController.delegate = self;
    GroceryList* recipeToSet = _allRecipes[indexPath.row];
    [showRecipeViewController setList:recipeToSet];
    [self.navigationController pushViewController:showRecipeViewController animated:YES];
    
}
@end
