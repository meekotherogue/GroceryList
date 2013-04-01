//
//  ShowRecipeViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-20.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryList.h"
@protocol ShowRecipeDelegate
@required
-(void)addRecipe:(GroceryList*)list;
@end


@interface ShowRecipeViewController : UIViewController
@property (nonatomic,strong) GroceryList* recipeToShow;
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;

-(GroceryList*)getList;
-(void)setList:(GroceryList*) list;
@end
