//
//  RecipeListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecipeViewController.h"

@interface RecipeListViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AddRecipeViewController *addRecipeViewController;

-(IBAction)backPressed:(id)sender;
-(IBAction)addPressed:(id)sender;
@end

