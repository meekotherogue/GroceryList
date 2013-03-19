//
//  CreateListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryList.h"
@protocol CreateListDelegate
@required
-(void)listCompleted:(GroceryList*)items;

@end

@interface CreateListViewController : UIViewController <UITextFieldDelegate>
@property(nonatomic,assign)id delegate;


@property(nonatomic, strong) IBOutlet UITableView* tableView;
- (void)addItem: (id)sender;
-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;
@end
