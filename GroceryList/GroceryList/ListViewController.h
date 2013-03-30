//
//  ListViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-29.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "CurrentListViewController.h"
@protocol AddListDelegate
@required
-(void)addList:(GroceryList*)list;
@end
@interface ListViewController : CurrentListViewController

@end
