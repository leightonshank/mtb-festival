//
//  MapViewController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/19/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "MapViewController.h"
#import "RMMBTilesTileSource.h"

#define kStartingLat    38.352906
#define kStartingLon   -79.149274
#define kStartingZoom   13.0f

@implementation MapViewController
@synthesize mapView;

- (void) dealloc {
    [super dealloc];
    [mapView release];
}

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
    
    // for the route-me map view
    [RMMapView class];
    self.mapView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // setup the map
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = kStartingLat;
    mapCenter.longitude = kStartingLon;
    
    // setup the MBTiles data source
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tiles" ofType:@"mbtiles"]];
    RMMBTilesTileSource *source = [[[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL] autorelease];
    
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
    float maxZoom = source.maxZoom;
    float minZoom = source.minZoom;
    float startingZoom = kStartingZoom;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        NSLog(@"Retina Display detected!  Adjusting zoom.");
        maxZoom--;
        startingZoom--;
    }
    
    // Init the map contents
    [[[RMMapContents alloc] 
      initWithView:mapView
      tilesource:source
      centerLatLon:mapCenter 
      zoomLevel:startingZoom
      maxZoomLevel:maxZoom
      minZoomLevel:minZoom 
      backgroundImage:nil] autorelease];
    
    mapView.enableRotate = NO;
    mapView.deceleration = NO;
    
    mapView.contents.zoom = startingZoom;
    [mapView.contents moveToLatLong:mapCenter];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - RMMapViewDelegate methods
- (void)beforeMapZoom:(RMMapView *)map byFactor:(float)zoomFactor near:(CGPoint)center {
    NSLog(@"cur: %f / zoomFactor: %f",map.contents.zoom,zoomFactor);
    if (zoomFactor > map.contents.maxZoom) {
        map.contents.zoom = map.contents.maxZoom;
    }
}

@end
