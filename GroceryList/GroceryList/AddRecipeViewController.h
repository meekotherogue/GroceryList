//
//  AddRecipeViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryList.h"
@protocol CreateRecipeDelegate
@required
-(void)recipeCreated:(GroceryList*)items;
@end

@interface AddRecipeViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField* addItemText;
    IBOutlet UIButton* addItemButton;
}
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;
-(IBAction)addPressed:(id)sender;
@end



