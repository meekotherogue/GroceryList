//
//  CreateListViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "CreateListViewController.h"
#import "GroceryList.h"
#import "GroceryItem.h"

@interface CreateListViewController ()
{
    NSMutableArray* arrayOfItems;
}
@end

@implementation CreateListViewController
@synthesize delegate;
int rows = 0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayOfItems = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addItem:(id)sender;
{
    rows ++;
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(IBAction)cancelPressed:(id)sender
{
    rows = 0;
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)savePressed:(id)sender;
{
    rows = 0;
    [self dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(listCompleted:)])
    {
        //send the delegate function with the amount entered by the user
        [delegate listCompleted:arrayOfItems];
    }
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 1;
    }
    return rows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITextField *inputField;
    inputField.delegate = self;
    inputField.returnKeyType = UIReturnKeyDone;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    
    if(indexPath.section == 1)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(10, 0, 300, 46)];
        
        [button setTitle:@"Add Item" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        
        button.userInteractionEnabled=YES;
        
        [button addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchUpInside];
        [button becomeFirstResponder];
        [cell addSubview:button];
        return cell;
    }
    
    if(indexPath.row == rows-1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell becomeFirstResponder];
        
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(12,12,185,30)];
        inputField.adjustsFontSizeToFitWidth = YES;
        [inputField setTag:indexPath.row+1];
        
        [cell addSubview:inputField];
    }
    else if(indexPath.row == rows-2)
    {
        UIView* itemView = [cell viewWithTag:indexPath.row+1];
        UITextView* textView = (UITextView*)itemView;
        GroceryItem* item;
        item = [[GroceryItem alloc] initWithName:textView.text];
        [arrayOfItems addObject:item];
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
}

@end
