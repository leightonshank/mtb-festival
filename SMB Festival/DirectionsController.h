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

@interface DirectionsController : FestivalInfoViewController {
    MKMapView *map;
}

@property (nonatomic,retain) IBOutlet MKMapView *map;

@end
