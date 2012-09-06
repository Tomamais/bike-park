//
//  BicicletariosSPUpdateKMLViewController.m
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BikeParkUpdateKMLViewController.h"

@interface BikeParkUpdateKMLViewController ()

@end

@implementation BikeParkUpdateKMLViewController
@synthesize activity;
@synthesize labelLastUpdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateLastUpdate
{
    // mostra a data da última atualização
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = [defaults objectForKey:@"lastUpdate"];
    if (lastUpdate != nil) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss zzz"];
        labelLastUpdate.text = [dateFormat stringFromDate:lastUpdate];
    }
    else {
        labelLastUpdate.text = NSLocalizedString(@"FILE_NOT_UPDATED", nil);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    // carrega os dados da URL
	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    kmlurl = [settings objectForKey:@"kmlurl"];
    
    [self updateLastUpdate];
}

- (void)viewDidUnload
{
    [self setActivity:nil];
    [self setLabelLastUpdate:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)UpdateFile:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE_TEXT", nil)
            message:NSLocalizedString(@"CONTINUE_DOWNLOAD_FILE", nil)
            delegate:self 
            cancelButtonTitle:NSLocalizedString(@"CANCEL_TEXT", nil)
            otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) DoUpdateFile
{
    NSURL  *url = [NSURL URLWithString:kmlurl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];  
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"BicicletariosSP.kml"];
        [urlData writeToFile:filePath atomically:YES];
    }
    [activity stopAnimating];  // e pára quando finaliza o download do arquivo
    
    // avisa o usuário que o download terminou
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE_TEXT", nil) message:NSLocalizedString(@"FILE_UPDATED", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"lastUpdate"];
    [defaults synchronize];
    
    [self updateLastUpdate];
    
    appDelegate.reloadMap = YES;
    appDelegate.addCurrentLocation = YES;
    [self.tabBarController setSelectedIndex:0];
}

// para capturar o UIAlertView como um cofirm. Tosco, mas funciona 
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 1)
    {
        [activity startAnimating]; // inicia o activity indicator
        [self performSelector: @selector(DoUpdateFile) withObject: nil afterDelay: 0];
        return;
    }
    else
    {
        // Do nothing
    }
}

@end
