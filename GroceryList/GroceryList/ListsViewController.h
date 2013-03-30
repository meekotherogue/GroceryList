//
//  ListsViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ListSelectedDelegate
@required
-(void)listsSelected:(NSMutableArray*)lists;
@end

@interface ListsViewController : UIViewController
@property(nonatomic,assign)id delegate;

@property(nonatomic, strong) IBOutlet UITableView* tableView;
-(IBAction)backPressed:(id)sender;
@property(nonatomic, strong)NSMutableArray* allLists;
@property(nonatomic, strong)NSMutableArray* listsToAddToCurrent;
@end