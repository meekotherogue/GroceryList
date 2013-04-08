//
//  ShowItemLocationViewController.h
//  GroceryList
//
//  Created by Martina Nagy on 2013-04-07.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface ShowItemLocationViewController : UIViewController
@property(nonatomic,assign)id delegate;

@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* address;
-(void)setLocation:(double)latitude longitude:(double)longitude name:(NSString*)name address:(NSString*)address;
@end

