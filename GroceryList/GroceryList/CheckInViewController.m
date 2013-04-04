//
//  CheckInViewController.m
//  GroceryList
//
//  Created by Martina Nagy on 2013-04-02.
//  Copyright (c) 2013 Martina Nagy. All rights reserved.
//

#import "CheckInViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface CheckInViewController ()
    @property(nonatomic,readwrite,strong) BZFoursquare* foursquare;
    @property(nonatomic,strong) BZFoursquareRequest* request;
    @property(nonatomic,copy) NSDictionary* meta;
    @property(nonatomic,copy) NSArray* notifications;
    @property(nonatomic,copy) NSDictionary* response;
    @property(nonatomic, strong) CLLocationManager* locationManager;
    @property(nonatomic) double latitude;
    @property(nonatomic) double longitude;
    @property(nonatomic, strong) NSMutableDictionary* venueSelected;
    - (void)updateView;
    - (void)cancelRequest;
    - (void)prepareForRequest;
    - (void)checkin;
@end

@implementation CheckInViewController
@synthesize foursquare = foursquare_;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;
@synthesize delegate;

const int kAccessTokenRow = 0;
const int kAuthenticationSection = 0;
const NSString* kClientID = @"2QEASHX551GMJR211GJ2GK5GMWNNYWOZ3OJE0FTGYWMGJ5VT";
const NSString* kCallbackURL = @"groclist://grocerylist";

NSMutableArray* _venues;

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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    _venues = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.locationManager startUpdatingLocation];

    if(foursquare_ == NULL)
    {
        self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        foursquare_.version = @"20111119";
        foursquare_.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        foursquare_.sessionDelegate = self;
    }
    if(![foursquare_ isSessionValid])
    {
        [foursquare_ startAuthorization];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFoursquareObject:(BZFoursquare*)foursquare
{
    foursquare_ = foursquare;
}

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request
{
    NSLog(@"%@",request);
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(self.response[@"venues"] != NULL)
    {
        NSMutableArray* venues = self.response[@"venues"];
        _venues = venues;
        [self.tableView reloadData];
    }
    if([request.path rangeOfString:@"checkin"].location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Check in was successful!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if([delegate respondsToSelector:@selector(checkInCompleted:)])
        {
            [delegate checkInCompleted:self.venueSelected];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(IBAction)checkInClicked:(id)sender
{
    [self prepareForRequest];
    NSString* coords = [NSString stringWithFormat:@"%f, %f",self.latitude, self.longitude];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:coords, @"ll", nil];
    self.request = [foursquare_ requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin:(NSMutableDictionary*)venue
{
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:venue[@"id"], @"venueId", @"public", @"broadcast", nil];
    self.request = [foursquare_ requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)updateView
{
    if ([self isViewLoaded])
    {

        /*
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView reloadData];
        if (indexPath) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }*/
        //Do shit here
    }
}

- (void)cancelRequest
{
    if (request_)
    {
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kAccessTokenRow inSection:kAuthenticationSection];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
}

//Table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_venues.count > 0)
    {
        return _venues.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:cellID];
    }
    if(_venues.count > 0)
    {
        NSMutableDictionary* venue = _venues[indexPath.row];
        cell.textLabel.text = venue[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* venue = _venues[indexPath.row];
    self.venueSelected = venue;
    [self checkin:venue];
	[ tableView deselectRowAtIndexPath:indexPath animated:YES ];
}

//Locaton Manager methods
-(void) locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation
           fromLocation: (CLLocation *) oldLocation
{
    CLLocation *location = [self.locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];

    //self.latitude = coordinate.latitude;
    //self.longitude = coordinate.longitude;
    self.latitude = 52.115925;
    self.longitude = -106.633753;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

}


@end
