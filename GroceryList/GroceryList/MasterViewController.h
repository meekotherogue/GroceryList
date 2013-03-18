//
//  MasterViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-02.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateListViewController.h"
#import "CurrentListViewController.h"
#import "ListsViewController.h"
#import "RecipeListViewController.h"
#import "AddRecipeViewController.h"
//@class DetailViewController;

@interface MasterViewController : UITableViewController

//@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) CreateListViewController *createListViewController;
@property (strong, nonatomic) CurrentListViewController *currentListViewController;
@property (strong, nonatomic) ListsViewController *listViewController;
@property (strong, nonatomic) RecipeListViewController *recipeListViewController;
@property (strong, nonatomic) AddRecipeViewController *addRecipeViewController;

@end
