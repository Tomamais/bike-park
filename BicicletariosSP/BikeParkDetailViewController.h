//
//  BicicletariosSPDetailViewController.h
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"
#import "BikeParkMapViewController.h"

@interface BikeParkDetailViewController : UIViewController {
    BikeParkAppDelegate *appDelegate;
}

@property (nonatomic, readwrite) MapPoint *point;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)seeOnMap:(id)sender;

@end
