//
//  FestivalAnnotation.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/18/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "FestivalAnnotation.h"

@implementation FestivalAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 38.352906;
    theCoordinate.longitude = -79.149274;
    return theCoordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"Stokesville Campground";
}

/*
// optional
- (NSString *)subtitle
{
    return @"Opened: May 27, 1937";
}
 */

- (void)dealloc
{
    [super dealloc];
}

@end
