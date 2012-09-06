//
//  BicicletariosSPListaViewController.h
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeParkAppDelegate.h"

@interface BikeParkListViewController : UITableViewController <UISearchBarDelegate>{
    BikeParkAppDelegate *appDelegate;
    bool isFiltered;
}

@property (strong, nonatomic) NSArray *annotations;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
