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
#import "RMMBTilesTileSource.h"
//#import "RMOpenCycleMapSource.h"
//#import "RMOpenStreetMapSource.h"
#import "RMCloudMadeMapSource.h"
#import "RMYahooMapSource.h"
#import "OfflineMapSourceController.h"

@interface MapViewController : FestivalInfoViewController 
<RMMapViewDelegate, CLLocationManagerDelegate> {
    RMMapView *mapView;
    RMMBTilesTileSource *offlineCycleSource;
    RMCloudMadeMapSource *onlineCycleSource;
    RMYahooMapSource *onlineStreetSource;
    
    UIToolbar *toolbar;
    
    CLLocationCoordinate2D mapCenter;
    CLLocationManager *locationManager;
    CLLocation *position;
    
    UIActivityIndicatorView *gpsIndicator;
    
    OfflineMapSourceController *offlineMapSourceController;
}

@property (nonatomic,retain) IBOutlet RMMapView *mapView;
@property (nonatomic,retain) RMMBTilesTileSource *offlineCycleSource;
@property (nonatomic,retain) RMCloudMadeMapSource *onlineCycleSource;
@property (nonatomic,retain) RMYahooMapSource *onlineStreetSource;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *position;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *gpsIndicator;
@property (nonatomic,retain) OfflineMapSourceController *offlineMapSourceController;

- (IBAction)changeMapSource:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)centerMap:(id)sender;
- (IBAction)showPosition:(id)sender;
- (IBAction)showOfflineSources:(id)sender;

- (void) updateMapSource:(id <RMTileSource>)source withMinZoom:(float)minZoom maxZoom:(float)maxZoom startingZoom:(float)startingZoom mapCenter:(CLLocationCoordinate2D)center;


@end
