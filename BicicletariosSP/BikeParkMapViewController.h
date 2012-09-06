//
//  BicicletariosSPViewController.h
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KMLParser.h"
#import "MapPoint.h"
#import "BikeParkAppDelegate.h"

#define METERS_PER_MILE 1609.344

@interface BikeParkMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    BikeParkAppDelegate *appDelegate;
    KMLParser *kmlParser;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, readwrite) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readwrite) CLLocationCoordinate2D newLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, readwrite) MKMapRect flyTo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myBikeButton;

- (void)updateMapViewLocation:(CLLocationCoordinate2D)zoomLocation;
- (IBAction)zoomAllPoints:(id)sender;

@end
