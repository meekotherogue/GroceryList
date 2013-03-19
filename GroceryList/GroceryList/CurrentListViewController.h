//
//  CurrentListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryList.h"
#import "GroceryItem.h"

@interface CurrentListViewController : UITableViewController
@property(nonatomic,assign)id delegate;

@property(nonatomic,assign)GroceryList* currentList;

@end
