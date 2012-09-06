//
//  BicicletariosSPAppDelegate.h
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BikeParkAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *annotations;
@property (strong, nonatomic) NSMutableArray *filteredannotations;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, readwrite) BOOL reloadMap;
@property (nonatomic, readwrite) BOOL reloadList;
@property (nonatomic, readwrite) BOOL addCurrentLocation;

-(CLLocationCoordinate2D)getMyLocation;

@end
