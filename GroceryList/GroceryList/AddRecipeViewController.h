//
//  AddRecipeViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreateRecipeDelegate
@required
-(void)recipeEntered;
@end

@interface AddRecipeViewController : UIViewController
@property(nonatomic,assign)id delegate;
@end
