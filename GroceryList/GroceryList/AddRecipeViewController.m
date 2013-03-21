//
//  AddRecipeViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-03-03.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "GroceryList.h"
#import "GroceryItem.h"

@interface AddRecipeViewController ()
{
    GroceryList* arrayOfItems;
}
@end

@implementation AddRecipeViewController
@synthesize delegate;
int _rows;
UITextField* _nameEntered;

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
        if([delegate respondsToSelector:@selector(recipeCreated:)])
        {
            //send the delegate function with the amount entered by the user
            if(![_nameEntered.text isEqualToString:@""])
            {
                arrayOfItems.name = _nameEntered.text;
            }
            [delegate recipeCreated:arrayOfItems];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(IBAction)addPressed:(id)sender
{
    
}

@end
