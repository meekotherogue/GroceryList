//
//  CheckInViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-04-02.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZFoursquare.h"
@protocol CheckInDelegate
@required
-(void)checkInCompleted:(NSMutableDictionary*)venue;
@end
@interface CheckInViewController : UIViewController <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate> {
    BZFoursquare* foursquare_;
    BZFoursquareRequest* request_;
    NSDictionary* meta_;
    NSArray* notifications_;
    NSDictionary* response_;
}
@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property(nonatomic,readonly,strong) BZFoursquare *foursquare;

-(void)setFoursquareObject:(BZFoursquare*)foursquare;
-(IBAction)checkInClicked:(id)sender;
@end
