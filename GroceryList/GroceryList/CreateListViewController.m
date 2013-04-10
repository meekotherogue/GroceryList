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
    GroceryList* arrayOfItems;
    int _rows;
}
@end

@implementation CreateListViewController
@synthesize delegate;


UITextField* _nameEntered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayOfItems = [[GroceryList alloc] init];
    addItemText.delegate = self;
    addItemButton.enabled = FALSE;
    [addItemButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _rows = 0;
    
    [self.tableView reloadData];
    self.editing = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Actions
-(IBAction)cancelPressed:(id)sender
{
    _rows = 0;
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)savePressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter" message:@"Enter the name for this list:" delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    _nameEntered = [alertView textFieldAtIndex:0];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        _rows = 0;
            
        [self dismissModalViewControllerAnimated:YES];
        if([delegate respondsToSelector:@selector(listCompleted:)])
        {
            //send the delegate function with the amount entered by the user
            if(![_nameEntered.text isEqualToString:@""])
            {
                arrayOfItems.name = _nameEntered.text;
                for(int i = 0; i < arrayOfItems.listOfItems.count; i++)
                {
                    GroceryItem* item = arrayOfItems.listOfItems[i];
                    item.list = _nameEntered.text;
                }
            }
            [delegate listCompleted:arrayOfItems];
        }
    }
}

-(IBAction)addPressed:(id)sender
{
    if([sender isEqual:addItemButton] && !addItemButton.isEnabled)
    {
        return;
    }
    [self.view endEditing:TRUE];
    addItemButton.enabled = FALSE;
    [self addItem];
}
//End Actions

-(void)addItem
{
    [addItemText resignFirstResponder];
    if([addItemText.text isEqualToString:@""])
    {           
        return;           
    }
    GroceryItem* item;
    NSString* itemText = addItemText.text;
    NSString* itemQuant = addItemQuant.text;
    if([itemQuant length] > 0)
    {
        item = [[GroceryItem alloc] initWithNameAndQuantity:itemText quantity:itemQuant];
    }
    else
    {
        item = [[GroceryItem alloc] initWithName:itemText];
    }
    [arrayOfItems addItem:item];
    
    _rows++;
    [self.tableView reloadData];
}

//TextField methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addItem];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if([sender isEqual:addItemText] || [sender isEqual:addItemQuant])
    {
        addItemButton.enabled = TRUE;
        if([sender isEqual:addItemText])
        {
            addItemText.text = @"";
        }
        else
        {
            addItemQuant.text = @"";
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)sender
{
    if([sender isEqual:addItemText] || [sender isEqual:addItemQuant])
    {
        //if([ ])
        //addItemButton.enabled = FALSE;
    }
}

//Table methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [arrayOfItems removeItem:indexPath.row];
        _rows--;
    }
    [tableView endUpdates];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    
    if(indexPath.row == _rows-1)
    {
        cell.textLabel.text = addItemText.text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
}

@end
