//
//  ShowRecipeViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-20.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ShowRecipeViewController.h"

@interface ShowRecipeViewController ()

@end

@implementation ShowRecipeViewController
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
    UIBarButtonItem* selectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(selectRecipe)];
    self.navigationItem.rightBarButtonItem = selectButton;
    self.title = self.recipeToShow.name;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRecipe
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Recipe" message:@"Are you sure you want to add this recipe's items to your Current List?" delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"Ok", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        if([delegate respondsToSelector:@selector(addRecipe:)])
        {
            [delegate addRecipe:self.recipeToShow];
        }
    }
}

-(GroceryList*)getList
{
    return self.recipeToShow;
}

-(void)setList:(GroceryList*) list
{
    self.recipeToShow = list;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipeToShow.listOfItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    GroceryItem* item = self.recipeToShow.listOfItems[indexPath.row];

    if([item.locationName length] != 0)
    {
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@\n%@",item.quantity,item.name,item.locationName];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",item.quantity,item.name];
    }
    
    return cell;
}


@end
