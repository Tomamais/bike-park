//
//  BicicletariosSPListaViewController.m
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BikeParkListViewController.h"
#import "BikeParkAppDelegate.h"
#import "MapPoint.h"
#import "BikeParkDetailViewController.h"

@interface BikeParkListViewController ()

@end

@implementation BikeParkListViewController

@synthesize annotations = _annotations;
@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.annotations = appDelegate.annotations;
    searchBar.delegate = (id)self;
    
    for(UIView *view in [searchBar subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            [(UIBarItem *)view setTitle:NSLocalizedString(@"CANCEL_TEXT", nil)];
        }
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    if (appDelegate.reloadList) {
        [self.tableView reloadData];
        appDelegate.reloadList = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rowCount;
    if(isFiltered)
        rowCount = appDelegate.filteredannotations.count;
    else
        rowCount = appDelegate.annotations.count;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bicicletario";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // obtém o objecto MapPoint, considerando o filtro
    MapPoint* myPoint;
    
    if(isFiltered)
        myPoint = [appDelegate.filteredannotations objectAtIndex:indexPath.row];
    else
        myPoint = [appDelegate.annotations objectAtIndex:indexPath.row];
    
    // calcula a distância, se não estiver definida
    if (!myPoint.distance) {
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:myPoint.coordinate.latitude longitude:myPoint.coordinate.longitude];
        CLLocation *locB = appDelegate.locationManager.location;
        myPoint.distance = [locA distanceFromLocation:locB];
    }
    
    cell.textLabel.text = myPoint.name;
    cell.detailTextLabel.text = myPoint.subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [self performSegueWithIdentifier:@"BicicletarioDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{         
    if ([segue.identifier isEqualToString:@"BicicletarioDetail"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        // quando o ViewController estiver dentro de um NavigationController, precisa disto:
        /* UINavigationController *navigationController = [segue destinationViewController];
        BicicletariosSPDetailViewController *detailViewController = [[navigationController viewControllers] objectAtIndex:0];*/
        
        
        BikeParkDetailViewController *detailViewController = [segue destinationViewController];
        
        if(isFiltered)
            detailViewController.point = [appDelegate.filteredannotations objectAtIndex:selectedRowIndex.row];
        else
            detailViewController.point = [appDelegate.annotations objectAtIndex:selectedRowIndex.row];
    
    }
    
    // oculta o teclado do searchbar
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
        [self.searchBar resignFirstResponder];
    }
    else
    {
        isFiltered = TRUE;
        appDelegate.filteredannotations = [[NSMutableArray alloc] init];
        
        for (MapPoint* point in appDelegate.annotations)
        {
            NSRange nameRange = [point.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [point.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [appDelegate.filteredannotations addObject:point];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];    
}

@end
