//
//  MapViewController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/19/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "MapViewController.h"
#import "RMMapView.h"
#import "RMOpenCycleMapSource.h"

#define kStokesvilleLatitude    38.352906
#define kStokesvilleLongitude   -79.149274

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // setup the map
    id tileSource = [[RMOpenCycleMapSource alloc] init];
    [[[RMMapContents alloc] initWithView:mapView tilesource:tileSource] autorelease];
    
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = kStokesvilleLatitude;
    mapCenter.longitude = kStokesvilleLongitude;
    
    [self.mapView.contents moveToLatLong:mapCenter];
    [self.mapView.contents setZoom:13.0f];
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

@end
