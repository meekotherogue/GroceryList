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
    UIBarButtonItem* selectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectRecipe)];
    
    self.navigationItem.rightBarButtonItem = selectButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRecipe
{
    if([delegate respondsToSelector:@selector(recipeSelected:)])
    {
        [delegate recipeSelected];
    }
}

@end
