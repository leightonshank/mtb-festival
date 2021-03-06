//
//  MapViewController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/19/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "MapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "CampingController.h"
#import "RMMarkerManager.h"
#import "RMMarker.h"
#import "Reachability.h"

#define kDataFilename @"offline-sources.plist"

#define kStartingLat    38.352906
#define kStartingLon   -79.149274
#define kRouteMeStartingZoom    13.0f

#define kMapKitStartingZoom     12
#define kMapKitMinZoomLevel     1
#define kMapKitMaxZoomLevel     18

#define kMapKitSource             0
#define kRouteMeOpenCycleSource   1

#define kOfflineTopoSource   0

@implementation MapViewController
@synthesize rmMapView, toolbar;
@synthesize offlineCycleSource, onlineCycleSource;
@synthesize locationManager,position;
@synthesize offlineMapSourceController;
@synthesize mkMapView;
@synthesize mapAttribution;
@synthesize campgroundAnnotation;
@synthesize gpsOn, gpsOff;
@synthesize campgroundMarker, locationMarker;

- (void) dealloc {
    [super dealloc];
    [rmMapView release];
    [offlineCycleSource release];
    [onlineCycleSource release];
    [toolbar release];
    [locationManager release];
    [offlineMapSourceController release];
    [mkMapView release];
    [mapAttribution release];
    [campgroundAnnotation release];
    [gpsOn release];
    [gpsOff release];
    [campgroundMarker release];
    [locationMarker release];
}

- (void)showCampgroundDetails:(id)sender {
    CampingController *campController = [[CampingController alloc] initWithNibName:@"CampingController" bundle:nil];
    campController.title = @"Campground";
    [self.navigationController pushViewController:campController animated:YES];
    [campController release];
}

- (RMMBTilesTileSource *) loadOfflineCycleSource:(NSString *)filename {    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSURL *tilesURL = [NSURL fileURLWithPath:filepath];
    RMMBTilesTileSource *source = [[[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL] autorelease];
    return source;
}

- (RMOpenCycleMapSource *) loadOnlineCycleSource {
    RMOpenCycleMapSource *source = [[[RMOpenCycleMapSource alloc] init] autorelease];
    //RMCloudMadeMapSource *source = [[RMCloudMadeMapSource alloc] initWithAccessKey:@"cbfee0d2292d4341a9f0fa945be4ccdc" styleNumber:537];
    return source;
}

/*
- (RMYahooMapSource *) loadOnlineStreetSource {
    //RMOpenStreetMapSource *source = [[RMOpenStreetMapSource alloc] init];
    //RMCloudMadeMapSource *source = [[RMCloudMadeMapSource alloc] initWithAccessKey:@"cbfee0d2292d4341a9f0fa945be4ccdc" styleNumber:1];
    RMYahooMapSource *source = [[RMYahooMapSource alloc] init];
    return source;
}
 */

- (void) updateRMMapSource:(id <RMTileSource>)source withMinZoom:(float)minZoom maxZoom:(float)maxZoom startingZoom:(float)startingZoom mapCenter:(CLLocationCoordinate2D)center 
{
    rmMapView.contents.zoom = startingZoom;
    rmMapView.contents.mapCenter = center;
    
    if (minZoom < rmMapView.contents.tileSource.minZoom) {
        //NSLog(@"===== Scenario 1: load source then set zoom");
        rmMapView.contents.tileSource = source;
        
        rmMapView.contents.minZoom = minZoom;
        rmMapView.contents.maxZoom = maxZoom;
    }
    else {
        //NSLog(@"===== Scenario 2: set zoom then load source");
        rmMapView.contents.minZoom = minZoom;
        rmMapView.contents.maxZoom = maxZoom;
        
        rmMapView.contents.tileSource = source;
    }
    
    [rmMapView.contents moveToLatLong:center];
}

- (void) updateToOfflineCycleSource:(NSString *)filename {
    //if (offlineCycleSource == nil) {
        self.offlineCycleSource = [self loadOfflineCycleSource:filename];
    //}
    /*
     * set the max/min zoom ranges.  route-me uses a hack for the retina display where it
     * shows the next higher zoom level tiles for a given zoom level (e.g. at zoom level 15
     * it shows the level 16 tiles).  There is a bug at the max zoom level where it tries to
     * look for the tiles at the next highest zoom level, and in this case for offline map
     * storage, those tiles don't exist.  We have tiles for levels 11-15.  At zoom level 15
     * it tries to find the tiles for level 16, but since the max zoom level is set as 15
     * then it fails an assertation that the zoom level <= max zoom level, and the app
     * crashes.  We're going to compensate for this by adjusting the max zoom level and the
     * starting zoom level if it is a retina display.
     */
    float curMaxZoom = self.offlineCycleSource.maxZoom;
    float curMinZoom = self.offlineCycleSource.minZoom;
    float curStartingZoom = kRouteMeStartingZoom;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        //NSLog(@"Retina Display detected!  Adjusting zoom.");
        curMaxZoom--;
        curStartingZoom--;
    }
    
    [self updateRMMapSource:offlineCycleSource withMinZoom:curMinZoom maxZoom:curMaxZoom startingZoom:curStartingZoom mapCenter:rmMapView.contents.mapCenter];
}

- (void) updateToOnlineCycleSource {
    if (onlineCycleSource == nil) {
        self.onlineCycleSource = [self loadOnlineCycleSource];
    }
    [self updateRMMapSource:onlineCycleSource withMinZoom:onlineCycleSource.minZoom maxZoom:onlineCycleSource.maxZoom startingZoom:kRouteMeStartingZoom mapCenter:rmMapView.contents.mapCenter];
}

/*
- (void) updateToOnlineStreetSource {
    if (onlineStreetSource == nil) {
        self.onlineStreetSource = [self loadOnlineStreetSource];
    }
    [self updateRMMapSource:onlineStreetSource withMinZoom:onlineStreetSource.minZoom maxZoom:onlineStreetSource.maxZoom startingZoom:kRouteMeStartingZoom mapCenter:rmMapView.contents.mapCenter];
}
*/

- (void) updateToMapKitSource {

}

- (NSString *) filenameForEnabledOfflineSourceOfType:(NSInteger) type {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:kDataFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filepath];
        NSArray *sources = [[array objectAtIndex:type] objectForKey:@"Maps"];
 
        
        NSString *filename = @"";
        
        for (int ii=0; ii < [sources count]; ii++) {
            NSDictionary *src = [sources objectAtIndex:ii];
            bool enabled = [[src objectForKey:@"Enabled"] boolValue];
            if (enabled) {
                filename = [[[NSString alloc] initWithString:[src objectForKey:@"Filename"]] autorelease];
            //    filename = @"";
            }
        }
        
        [array release];
        return filename;
    }

    return @"";
}


#pragma mark - IBAction methods

- (IBAction)changeMapSource:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *) sender;
    //NSLog(@"s==> selectedSegmentIndex: %d",control.selectedSegmentIndex);
    switch (control.selectedSegmentIndex) {
        case kRouteMeOpenCycleSource:
            //NSLog(@"===> online-cycle");
            rmMapView.contents.mapCenter = mkMapView.centerCoordinate;
            
            mkMapView.hidden = YES;
            rmMapView.hidden = NO;
            mapAttribution.hidden = NO;
            currentSource = kRouteMeOpenCycleSource;
            //check and see if one of the offline sources is enabled
            NSString *srcFilename = [self filenameForEnabledOfflineSourceOfType:kOfflineTopoSource];
            if ([srcFilename length] > 0) {
                [self updateToOfflineCycleSource:srcFilename];
            }
            else {
                // otherwise load the online source
                [self updateToOnlineCycleSource];
            }
            break;
        case kMapKitSource:
            //NSLog(@"===> online-street");
            //[self updateToOnlineStreetSource];
            //NSLog(@"mapkit source");
            mkMapView.centerCoordinate = rmMapView.contents.mapCenter;
            
            rmMapView.hidden = YES;
            mkMapView.hidden = NO;
            mapAttribution.hidden = YES;
            currentSource = kMapKitSource;
            [self updateToMapKitSource];
            break;
    }
}

- (IBAction)zoomIn:(id)sender {
    switch (currentSource) {
        case kRouteMeOpenCycleSource:
            if (rmMapView.contents.zoom < rmMapView.contents.maxZoom) {
                CGPoint center = CGPointMake(rmMapView.frame.size.width/2, rmMapView.frame.size.height/2);
                [rmMapView zoomInToNextNativeZoomAt:center animated:YES];
            }
            break;
        case kMapKitSource:
            if (currentMapKitZoomLevel < kMapKitMaxZoomLevel) {
                currentMapKitZoomLevel++;
                [mkMapView setCenterCoordinate:mkMapView.region.center zoomLevel:currentMapKitZoomLevel animated:YES];
            }
            break;
        default:
            break;
    }

}

- (IBAction)zoomOut:(id)sender {
    switch (currentSource) {
        case kRouteMeOpenCycleSource:
            if (rmMapView.contents.zoom > rmMapView.contents.minZoom) {
                CGPoint center = CGPointMake(rmMapView.frame.size.width/2, rmMapView.frame.size.height/2);
                [rmMapView zoomOutToNextNativeZoomAt:center animated:YES];
            }
            break;
        case kMapKitSource:
            if (currentMapKitZoomLevel > kMapKitMinZoomLevel) {
                currentMapKitZoomLevel--;
                [mkMapView setCenterCoordinate:mkMapView.region.center zoomLevel:currentMapKitZoomLevel animated:YES];
            }
            break;
        default:
            break;
    }

}

- (IBAction)centerMap:(id)sender {
    switch (currentSource) {
        case kRouteMeOpenCycleSource:
            [rmMapView moveToLatLong:mapCenter];
            break;
        case kMapKitSource:
            [mkMapView setCenterCoordinate:mapCenter zoomLevel:currentMapKitZoomLevel animated:YES];
            break;
        default:
            break;
    }
    
}

- (IBAction)showPosition:(id)sender {
    if (position != nil) {
        switch (currentSource) {
            case kRouteMeOpenCycleSource:
                [rmMapView moveToLatLong:position.coordinate];
                break;
            case kMapKitSource:
                [mkMapView setCenterCoordinate:position.coordinate zoomLevel:currentMapKitZoomLevel animated:YES];
                break;
            default:
                break;
        }
    }
}

- (IBAction)showOfflineSources:(id)sender {
    //NSLog(@"switching to offline source view");
    if (offlineMapSourceController == nil) {
        OfflineMapSourceController *offline = [[OfflineMapSourceController alloc] initWithNibName:@"OfflineMapSourceController" bundle:nil];
        self.offlineMapSourceController = offline;
        [offline release];
    }
    
    offlineMapSourceController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:offlineMapSourceController];
    nav.navigationBar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    [self presentModalViewController:nav animated:YES];
    [nav release];
}

- (bool)isNetworkAvailable {
    	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

#pragma mark - housekeeping

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ( ! [self isNetworkAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Access will be limited to cached and offline map sources" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    // Do any additional setup after loading the view from its nib.
    // Start finding our location
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    self.locationManager = manager;
    [manager release];
    locationManager.delegate = self;
    
    // for the route-me map view
    [RMMapView class];
    self.rmMapView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.toolbar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    // setup the map center
    mapCenter.latitude = kStartingLat;
    mapCenter.longitude = kStartingLon;
    
    // setup some properties on the map
    rmMapView.enableRotate = NO;
    rmMapView.deceleration = NO;
    
    // Init the route-me map contents
    [[[RMMapContents alloc] initWithView:rmMapView] autorelease];
    self.rmMapView.contents.mapCenter = mapCenter;
    
    // Init the MapKit mapView (default)
    // setup the annotation for the campground
    FestivalAnnotation *festivalAnnotation = [[FestivalAnnotation alloc] init];
    self.campgroundAnnotation = festivalAnnotation;
    [festivalAnnotation release];
    
    currentMapKitZoomLevel = kMapKitStartingZoom;
    [mkMapView setCenterCoordinate:mapCenter zoomLevel:currentMapKitZoomLevel animated:YES];
    
    [self.mkMapView addAnnotation:campgroundAnnotation];
    [self.mkMapView selectAnnotation:self.campgroundAnnotation animated:YES];
    
    // set the map attribution
    RMOpenCycleMapSource *opencycle = [[RMOpenCycleMapSource alloc] init];
    self.mapAttribution.text = [opencycle shortAttribution];
    self.mapAttribution.hidden = YES;
    [opencycle release];
    
    // init the gps indicator
    UIImageView *gpsOnView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps-on.png"]];
    UIImageView *gpsOffView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps-off.png"]];
    self.gpsOn = gpsOnView;
    self.gpsOff = gpsOffView;
    [gpsOnView release];
    [gpsOffView release];
    
    UIBarButtonItem *gpsIndicator = [[UIBarButtonItem alloc] initWithCustomView:gpsOff];
    self.navigationItem.rightBarButtonItem = gpsIndicator;
    [gpsIndicator release];
    
    // setup the route-me map markers
    RMMarker *aCampgroundMarker = [[RMMarker alloc]
                                  initWithUIImage:[UIImage imageNamed:@"mapmarker-campground.png"]
                                  anchorPoint:CGPointMake(0.5,1.0)];
    self.campgroundMarker = aCampgroundMarker;
    [aCampgroundMarker release];
    
    [rmMapView.contents.markerManager addMarker:campgroundMarker AtLatLong:mapCenter];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
    mkMapView.showsUserLocation = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [locationManager stopUpdatingLocation];
    mkMapView.showsUserLocation = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.rmMapView = nil;
    self.offlineCycleSource = nil;
    self.onlineCycleSource = nil;
    self.toolbar = nil;
    self.locationManager = nil;
    self.offlineMapSourceController = nil;
    self.mkMapView = nil;
    self.mapAttribution = nil;
    self.campgroundAnnotation = nil;
    self.gpsOn = nil;
    self.gpsOff = nil;
    self.campgroundMarker = nil;
    self.locationMarker = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - RMMapViewDelegate methods
- (void)beforeMapZoom:(RMMapView *)map byFactor:(float)zoomFactor near:(CGPoint)center {
}

#pragma mark - CLLocationManagerDelegete methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.position = newLocation;
    if (newLocation.horizontalAccuracy < 100.0f) {
        UIBarButtonItem *gpsIndicator = [[UIBarButtonItem alloc] initWithCustomView:gpsOn];
        self.navigationItem.rightBarButtonItem = gpsIndicator;
        [gpsIndicator release];
    }
    else {
        UIBarButtonItem *gpsIndicator = [[UIBarButtonItem alloc] initWithCustomView:gpsOff];
        self.navigationItem.rightBarButtonItem = gpsIndicator;
        [gpsIndicator release];
    }
    
    // update the position marker
    if (locationMarker == nil) {
        RMMarker *aLocationMarker = [[RMMarker alloc]
                                     initWithUIImage:[UIImage imageNamed:@"mapmarker-user.png"]
                                     anchorPoint:CGPointMake(0.5,1.0)];
        self.locationMarker = aLocationMarker;
        [aLocationMarker release];
        [rmMapView.contents.markerManager addMarker:locationMarker AtLatLong:position.coordinate];
    }
    else {
        [rmMapView.contents.markerManager moveMarker:locationMarker AtLatLon:position.coordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    //NSLog(@"Error %i", error.code);
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:[error localizedDescription]
                          message:[error localizedFailureReason]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - OfflineMapSourceDelegate methods
-(void)didDismissOfflineMapSourceController:(OfflineMapSourceController *)controller {
    //NSLog(@"++ just changed offline sources, let's check or change our source type");
    NSString *srcFilename = [self filenameForEnabledOfflineSourceOfType:kOfflineTopoSource];
    if ([srcFilename length] > 0) {
        [self updateToOfflineCycleSource:srcFilename];
    }
    else {
        [self updateToOnlineCycleSource];
    }
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation { 
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // try to dequeue an existing pin view first
    static NSString* FestivalAnnotationIdentifier = @"festivalAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [mkMapView dequeueReusableAnnotationViewWithIdentifier:FestivalAnnotationIdentifier];
    if (!pinView)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:FestivalAnnotationIdentifier] autorelease];
        customPinView.pinColor = MKPinAnnotationColorGreen;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showCampgroundDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
    
}

@end
