//
//  BicicletariosSPUpdateKMLViewController.h
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeParkMapViewController.h"

@interface BikeParkUpdateKMLViewController : UIViewController <UIAlertViewDelegate>{
    BikeParkAppDelegate *appDelegate;
    NSString *kmlurl;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *labelLastUpdate;
- (IBAction)UpdateFile:(id)sender;
@end
