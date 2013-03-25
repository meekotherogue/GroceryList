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
    if([delegate respondsToSelector:@selector(addRecipeToCurrentList:)])
    {
        [delegate addRecipeToCurrentList:9];
    }
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
    cell.textLabel.text = item.name;
    
    return cell;
}


@end
