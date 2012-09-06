//
//  MapPoint.m
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize distance = _distance;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate  {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

-(NSString *)subtitle {
    if (_distance == 0) {
        return _address;
    }
    else{
        if (_distance < 1000) {
            return [[NSString alloc] initWithFormat:@"%1.0f %@", _distance, NSLocalizedString(@"METER_TEXT", nil)];
        }
        else {
            return [[NSString alloc] initWithFormat:@"%1.3f km", _distance/1000];
        }
    }
}

@end