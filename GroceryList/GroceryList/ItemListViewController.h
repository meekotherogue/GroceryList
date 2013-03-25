//
//  ItemListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-24.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryList.h"
#import "GroceryItem.h"
@protocol AddItemDelegate
@required
-(void)addItems:(NSMutableArray*)item;
@end

@interface ItemListViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property(nonatomic,assign)GroceryList* currentList;
@property(nonatomic, strong)NSMutableDictionary* allItems;

-(IBAction)backPressed:(id)sender;

@end


