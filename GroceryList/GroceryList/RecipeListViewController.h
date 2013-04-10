//
//  RecipeListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecipeViewController.h"
@protocol AddRecipeDelegate
@required
-(void)recipesAdded:(NSMutableArray*)list;
-(void)recipeSelected:(NSMutableArray*)recipes;
-(void)itemsSelectedFromRecipes:(NSMutableArray*)items;
@end

@interface RecipeListViewController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property (strong, nonatomic) AddRecipeViewController *addRecipeViewController;
@property(nonatomic, strong)NSMutableArray* allRecipes;
@property(nonatomic, strong)NSMutableArray* recipesToAddToCurrent;
@property(nonatomic, strong)NSMutableArray* itemsToAddToCurrent;

@end

