//
//  DirectionsController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/12/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "DirectionsController.h"
#import "MapDetailController.h"
#import "FestivalAnnotation.h"

#define kStokesvilleLatitude    38.352906
#define kStokesvilleLongitude   -79.149274

@implementation DirectionsController
@synthesize map, mapAnnotation, detailController;
@synthesize toolbar;

- (void) dealloc {
    [super dealloc];
    [map release];
    [mapAnnotation release];
    [detailController release];
    [toolbar release];
}

#pragma mark -

/*
+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}
 */

- (void)gotoLocation
{
    // start off by default in Stokesville
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = kStokesvilleLatitude;
    newRegion.center.longitude = kStokesvilleLongitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.map setRegion:newRegion animated:YES];
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
    
    self.toolbar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:0.5f];
    
    self.map.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    
    // create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
    
    
    
    // setup the annotation for the campground
    FestivalAnnotation *festivalAnnotation = [[FestivalAnnotation alloc] init];
    self.mapAnnotation = festivalAnnotation;
    [festivalAnnotation release];
    
    [self gotoLocation];
    [self.map addAnnotation:mapAnnotation];
    [self.map selectAnnotation:self.mapAnnotation animated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.map = nil;
    self.detailController = nil;
    self.mapAnnotation = nil;
    self.toolbar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showDetails:(id)sender
{
    [self.navigationController pushViewController:self.detailController animated:YES];
}

- (IBAction)viewDirectionsPressed:(id)sender {
    [self showDetails:sender];
}
- (IBAction)showCampgroundPressed:(id)sender {
    [self gotoLocation];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation { 
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // try to dequeue an existing pin view first
    static NSString* FestivalAnnotationIdentifier = @"festivalAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [map dequeueReusableAnnotationViewWithIdentifier:FestivalAnnotationIdentifier];
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
                        action:@selector(showDetails:)
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
