//
//  RecipeListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddRecipeDelegate
@required
-(void)recipeEntered;
@end

@interface RecipeListViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
-(IBAction)backPressed:(id)sender;
-(IBAction)addPressed:(id)sender;
@end

