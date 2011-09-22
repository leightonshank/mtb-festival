//
//  MapViewController.h
//  SMB Festival
//
//  Created by Leighton Shank on 9/19/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalInfoViewController.h"
#import "RMMapView.h"

@interface MapViewController : FestivalInfoViewController <RMMapViewDelegate> {
    RMMapView *mapView;
}

@property (nonatomic,retain) IBOutlet RMMapView *mapView;


@end
