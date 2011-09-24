//
//  MapViewController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/19/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "MapViewController.h"

#define kStartingLat    38.352906
#define kStartingLon   -79.149274
#define kStartingZoom   13.0f

#define kOnlineCycleSourceSegment   0
#define kOnlineStreetSourceSegment  1

@implementation MapViewController
@synthesize mapView, toolbar;
@synthesize offlineCycleSource, onlineCycleSource, onlineStreetSource;
@synthesize locationManager,position;
@synthesize gpsIndicator;
@synthesize offlineMapSourceController;

- (void) dealloc {
    [super dealloc];
    [mapView release];
    [offlineCycleSource release];
    [onlineCycleSource release];
    [onlineStreetSource release];
    [toolbar release];
    [locationManager release];
    [gpsIndicator release];
    [offlineMapSourceController release];
}

- (RMMBTilesTileSource *) loadOfflineCycleSource {    // setup the MBTiles data source (default)
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tiles" ofType:@"mbtiles"]];
    RMMBTilesTileSource *source = [[[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL] autorelease];
    return source;
}

- (RMCloudMadeMapSource *) loadOnlineCycleSource {
    //RMOpenCycleMapSource *source = [[RMOpenCycleMapSource alloc] init];
    RMCloudMadeMapSource *source = [[RMCloudMadeMapSource alloc] initWithAccessKey:@"cbfee0d2292d4341a9f0fa945be4ccdc" styleNumber:537];
    return source;
}

- (RMYahooMapSource *) loadOnlineStreetSource {
    //RMOpenStreetMapSource *source = [[RMOpenStreetMapSource alloc] init];
    //RMCloudMadeMapSource *source = [[RMCloudMadeMapSource alloc] initWithAccessKey:@"cbfee0d2292d4341a9f0fa945be4ccdc" styleNumber:1];
    RMYahooMapSource *source = [[RMYahooMapSource alloc] init];
    return source;
}

- (void) updateMapSource:(id <RMTileSource>)source withMinZoom:(float)minZoom maxZoom:(float)maxZoom startingZoom:(float)startingZoom mapCenter:(CLLocationCoordinate2D)center 
{
    mapView.contents.zoom = startingZoom;
    mapView.contents.mapCenter = center;
    
    if (minZoom < mapView.contents.tileSource.minZoom) {
        NSLog(@"===== Scenario 1: load source then set zoom");
        mapView.contents.tileSource = source;
        
        mapView.contents.minZoom = minZoom;
        mapView.contents.maxZoom = maxZoom;
    }
    else {
        NSLog(@"===== Scenario 2: set zoom then load source");
        mapView.contents.minZoom = minZoom;
        mapView.contents.maxZoom = maxZoom;
        
        mapView.contents.tileSource = source;
    }
    
    [mapView.contents moveToLatLong:center];
}

- (void) updateToOfflineCycleSource {
    if (offlineCycleSource == nil) {
        self.offlineCycleSource = [self loadOfflineCycleSource];
    }
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
    float curStartingZoom = kStartingZoom;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        NSLog(@"Retina Display detected!  Adjusting zoom.");
        curMaxZoom--;
        curStartingZoom--;
    }
    
    [self updateMapSource:offlineCycleSource withMinZoom:curMinZoom maxZoom:curMaxZoom startingZoom:curStartingZoom mapCenter:mapView.contents.mapCenter];
}

- (void) updateToOnlineCycleSource {
    if (onlineCycleSource == nil) {
        self.onlineCycleSource = [self loadOnlineCycleSource];
    }
    [self updateMapSource:onlineCycleSource withMinZoom:onlineCycleSource.minZoom maxZoom:onlineCycleSource.maxZoom startingZoom:kStartingZoom mapCenter:mapView.contents.mapCenter];
}

- (void) updateToOnlineStreetSource {
    if (onlineStreetSource == nil) {
        self.onlineStreetSource = [self loadOnlineStreetSource];
    }
    [self updateMapSource:onlineStreetSource withMinZoom:onlineStreetSource.minZoom maxZoom:onlineStreetSource.maxZoom startingZoom:kStartingZoom mapCenter:mapView.contents.mapCenter];
}

#pragma mark - IBAction methods

- (IBAction)changeMapSource:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *) sender;
    NSLog(@"s==> selectedSegmentIndex: %d",control.selectedSegmentIndex);
    switch (control.selectedSegmentIndex) {
        case kOnlineCycleSourceSegment:
            NSLog(@"===> online-cycle");
            [self updateToOnlineCycleSource];
            break;
        case kOnlineStreetSourceSegment:
            NSLog(@"===> online-street");
            [self updateToOnlineStreetSource];
            break;
    }
}

- (IBAction)zoomIn:(id)sender {
    if (mapView.contents.zoom < mapView.contents.maxZoom) {
        CGPoint center = CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
        [mapView zoomInToNextNativeZoomAt:center animated:YES];
    }
}

- (IBAction)zoomOut:(id)sender {
    if (mapView.contents.zoom > mapView.contents.minZoom) {
        CGPoint center = CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
        [mapView zoomOutToNextNativeZoomAt:center animated:YES];
    }
}

- (IBAction)centerMap:(id)sender {
    [mapView moveToLatLong:mapCenter];
}

- (IBAction)showPosition:(id)sender {
    if (position != nil) {
        [mapView moveToLatLong:position.coordinate];
    }
}

- (IBAction)showOfflineSources:(id)sender {
    NSLog(@"switching to offline source view");
    if (offlineMapSourceController == nil) {
        OfflineMapSourceController *offline = [[OfflineMapSourceController alloc] initWithNibName:@"OfflineMapSourceController" bundle:nil];
        self.offlineMapSourceController = offline;
        [offline release];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:offlineMapSourceController];
    nav.navigationBar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    [self presentModalViewController:nav animated:YES];
    [nav release];
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
    // Do any additional setup after loading the view from its nib.
    // Start finding our location
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    self.locationManager = manager;
    [manager release];
    locationManager.delegate = self;
    
    // for the route-me map view
    [RMMapView class];
    self.mapView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.toolbar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    // setup the map center
    mapCenter.latitude = kStartingLat;
    mapCenter.longitude = kStartingLon;
    
    // setup some properties on the map
    mapView.enableRotate = NO;
    mapView.deceleration = NO;
    
    
    // Init the map contents
    [[[RMMapContents alloc] initWithView:mapView] autorelease];
    self.mapView.contents.mapCenter = mapCenter;
    [self updateToOnlineCycleSource];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [locationManager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView = nil;
    self.offlineCycleSource = nil;
    self.onlineCycleSource = nil;
    self.onlineStreetSource = nil;
    self.toolbar = nil;
    self.locationManager = nil;
    self.gpsIndicator = nil;
    self.offlineMapSourceController = nil;
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
        NSLog(@"===== gps!");
        [gpsIndicator stopAnimating];
    }
    else {
        NSLog(@"===== no gps :(");
        [gpsIndicator startAnimating];
    }
    
    NSLog(@"===== loc update} (%f,%f) accuracy: %f",newLocation.coordinate.latitude,
          newLocation.coordinate.longitude,newLocation.horizontalAccuracy);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Error %i", error.code);
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:[error localizedDescription]
                          message:[error localizedFailureReason]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
