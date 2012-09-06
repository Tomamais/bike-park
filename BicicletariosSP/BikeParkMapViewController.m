//
//  BicicletariosSPViewController.m
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BikeParkMapViewController.h"
#import "BikeParkAppDelegate.h"
#import "BikeParkDetailViewController.h"

@interface BikeParkMapViewController ()

@end

@implementation BikeParkMapViewController
@synthesize activity;

@synthesize mapView;
@synthesize currentLocation = _currentLocation;
@synthesize newLocation = _newLocation;
@synthesize flyTo = _flyTo;
@synthesize myBikeButton;

- (void)startLocation
{
    appDelegate.locationManager = [[CLLocationManager alloc] init];
    [appDelegate.locationManager setDelegate:self];
    
    [appDelegate.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [appDelegate.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if (!([CLLocationManager locationServicesEnabled] && self.mapView.userLocation != nil)) {
        // avisa o usuário sobre a não ativação da localização
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOCATION", nil) message:NSLocalizedString(@"LOCATION_MESSAGE", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [appDelegate.locationManager startUpdatingLocation];
        [activity startAnimating];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // inicia a localização
    [self startLocation];
    
    // dá o foco na localização atual
    [self updateMapViewLocation:[appDelegate getMyLocation]];
    appDelegate.reloadMap = YES;
    appDelegate.reloadList = YES;
    appDelegate.addCurrentLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (appDelegate.reloadMap == YES) {
        
        // carrega o KML no mapa
        [self reloadKMLFile];
        
       appDelegate.reloadMap = NO;
    }
}

- (void)viewDidUnload
{
    [self setActivity:nil];
    [self setMyBikeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)goToMyLocation {
    self.newLocation = [appDelegate getMyLocation];
    
    appDelegate.annotations = [kmlParser sortPoints:self.newLocation points:appDelegate.annotations];
    appDelegate.reloadList = YES;
    
    // remove o local anterior do mapa
    if (self.newLocation.latitude != self.currentLocation.latitude || self.newLocation.longitude != self.currentLocation.longitude) {
        
        NSArray *annotations = [mapView annotations];
        MapPoint *annotation = nil;
        NSMutableArray *removedAnnotations = [[NSMutableArray alloc] init];
        for (int i=0; i<[annotations count]; i++)
        {
            annotation = (MapPoint*)[annotations objectAtIndex:i];
            if ((annotation.coordinate.latitude == self.currentLocation.latitude && annotation.coordinate.longitude == self.currentLocation.longitude) || [annotation isKindOfClass:[MKUserLocation class]])
            {
                [removedAnnotations addObject:annotation];
            }
        }
        
        if(removedAnnotations.count > 0) {
            [mapView removeAnnotations:removedAnnotations];
            MapPoint *newPoint = [[MapPoint alloc] initWithName:NSLocalizedString(@"MY_BIKE", nil) address:NSLocalizedString(@"YOU_ARE_HERE", nil) coordinate:self.newLocation];
            [mapView addAnnotation:newPoint];
        }
        
        // atualiza a flag e no mapa
        self.currentLocation = self.newLocation;
    }
    // centraliza o mapa na localização
    [self updateMapViewLocation:self.newLocation];
    
    // desativa o botão
    myBikeButton.enabled = NO;
}

- (IBAction)backToMyLocation:(id)sender {
    [self goToMyLocation];
}

- (void)updateMapViewLocation:(CLLocationCoordinate2D)zoomLocation {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];             
    [mapView setRegion:adjustedRegion animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self goToMyLocation];
    [manager stopUpdatingLocation];
    [activity stopAnimating];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapPoint";   
    
    MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        annotationView.annotation = annotation;
    }
    
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        if ((annotation.coordinate.latitude == self.currentLocation.latitude && annotation.coordinate.longitude == self.currentLocation.longitude))
        {
            annotationView.image=[UIImage imageNamed:@"bike.png"];// imagem da minha bike
        }
        else {
            // coloca a distância no lugar da descrição, para não sujar com HTML
            annotationView.image=[UIImage imageNamed:@"pin.png"];// imagem do bicicletário
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        // adiciona um botão no marcador
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.hidden = false;
        
    }
    else
        // oculta o pin da localização
        annotationView.hidden = true;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!animated) {
        myBikeButton.enabled = YES;
    }
}

// mapeia o click no MapPoint
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){ // faz a chegcagem do tipo de botão
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        BikeParkDetailViewController *detailViewController = (BikeParkDetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"BicicletariosSPDetailViewController"];
        MapPoint *point = (MapPoint *)view.annotation;
        detailViewController.point = point;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    } 
}

- (void)reloadKMLFile
{
    // apaga todos os points do mapa, se houver
    [mapView removeAnnotations:mapView.annotations];
    [mapView removeOverlays:mapView.overlays];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* BicicletariosSPFile = [documentsPath stringByAppendingPathComponent:@"BicicletariosSP.kml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:BicicletariosSPFile];
    
    // por padrão, o arquivo carregado é o que vem com o aplicativo
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BicicletariosSP" ofType:@"kml"];
    
    // a não ser que um novo tenha sido baixado
    if (fileExists == true) {
        path = BicicletariosSPFile;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kmlParser points];
    // ordena
    annotations = [kmlParser sortPoints:[appDelegate getMyLocation] points:annotations];
    // atualiza a lista global de localizações
    appDelegate.annotations = annotations;
    // e adiciona
    [mapView addAnnotations:annotations];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    self.flyTo = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(self.flyTo)) {
            self.flyTo = pointRect;
        } else {
            self.flyTo = MKMapRectUnion(self.flyTo, pointRect);
        }
    }
    
    if (appDelegate.addCurrentLocation) {
        MapPoint *newPoint = [[MapPoint alloc] initWithName:NSLocalizedString(@"MY_BIKE", nil) address:NSLocalizedString(@"YOU_ARE_HERE", nil) coordinate:self.newLocation];
        [mapView addAnnotation:newPoint];
        appDelegate.addCurrentLocation = NO;
    }
    
    // Foca o mapa em mostrar todos os points existentes
    mapView.visibleMapRect = self.flyTo;
}


- (IBAction)zoomAllPoints:(id)sender {
    // Foca o mapa em mostrar todos os points existentes
    mapView.visibleMapRect = self.flyTo;
}
@end
