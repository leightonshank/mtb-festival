//
//  DirectionsController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/12/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FestivalInfoViewController.h"

@class MapDetailController;
@class FestivalAnnotation;

@interface DirectionsController : FestivalInfoViewController
    <MKMapViewDelegate>
{
    MKMapView *map;
    FestivalAnnotation *mapAnnotation;
    MapDetailController *detailController;
    UIToolbar *toolbar;
}

@property (nonatomic,retain) IBOutlet MKMapView *map;
@property (nonatomic,retain) IBOutlet MapDetailController *detailController;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic,retain) FestivalAnnotation *mapAnnotation;

/*
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;
*/

- (IBAction)viewDirectionsPressed:(id)sender;
- (IBAction)showCampgroundPressed:(id)sender;

@end
