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
#import "ShowRecipeViewController.h"
#import "ItemListViewController.h"
#import "DatabaseHelper.h"
#import "BZFoursquare.h"

@interface MasterViewController : UITableViewController<BZFoursquareRequestDelegate, BZFoursquareSessionDelegate> {
    BZFoursquare        *foursquare_;
    BZFoursquareRequest *request_;
    NSDictionary        *meta_;
    NSArray             *notifications_;
    NSDictionary        *response_;
}

@property(nonatomic,readonly,strong) BZFoursquare *foursquare;

@property (strong, nonatomic) CreateListViewController* createListViewController;
@property (strong, nonatomic) CurrentListViewController* currentListViewController;
@property (strong, nonatomic) ListsViewController* listViewController;
@property (strong, nonatomic) RecipeListViewController* recipeListViewController;
@property (strong, nonatomic) ShowRecipeViewController* showRecipeViewController;
@property (strong, nonatomic) ItemListViewController* itemListViewController;
@property (strong, nonatomic) DatabaseHelper* databaseHelper;

@end
