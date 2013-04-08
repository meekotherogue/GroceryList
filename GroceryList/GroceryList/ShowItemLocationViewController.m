//
//  ShowItemLocationViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-04-07.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "ShowItemLocationViewController.h"

@interface ShowItemLocationViewController ()

@end

@implementation ShowItemLocationViewController
@synthesize delegate;

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

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.latitude;
    zoomLocation.longitude= self.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
-(void)setLocation:(double)latitude longitude:(double)longitude
{
    self.latitude = latitude;
    self.longitude = longitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
