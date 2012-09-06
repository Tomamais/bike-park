//
//  BicicletariosSPDetailViewController.m
//  BicicletariosSP
//
//  Created by Tomás Vásquez on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BikeParkDetailViewController.h"

@interface BikeParkDetailViewController ()

@end

@implementation BikeParkDetailViewController

@synthesize point = _point;
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.title = self.point.title;
    // para customizar o comportamento e o texto do botão
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_TEXT", nil)
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    
    NSString *htmlString = [NSString stringWithFormat:
                            @"<!DOCTYPE HTML>"
                            "<html>"
                            "<head>"
                            "<meta charset=\"UTF-8\">"
                            "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">"
                            "<style type=\"text/css\">"
                            "body { margin: 0; background: #DDD; color: black; font-family: arial,sans-serif; font-size: 13px;}"
                            "div { margin: 0; padding: 0; }"
                            "div[align=left] { text-align: -webkit-left; }"
                            "div#content { padding: 8px; }"
                            "div#name { font-weight: bold; padding-bottom: .7em; font-size: 21px }"
                            "div#description { padding-bottom: .7em; }"
                            "</style>"
                            "</head>"
                            "<body>"
                            "<div id=\"content\">"
                            "<div>"
                            "<div align=\"left\" id=\"name\">%@</div>"
                            "<div align=\"left\" id=\"distance\">%@</div>"
                            "<div align=\"left\" id=\"description\">%@</div>"
                            "</div>"
                            "</div>"
                            "</body>"
                            "</html>"
                            , self.point.name ? self.point.name : @""
                            , self.point.subtitle ? self.point.subtitle : @""
                            , self.point.address && self.point.address != self.point.subtitle ? self.point.address : @""];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)seeOnMap:(id)sender {
    // porco, mas com storyboard, é o único jeito de achar um viewcontroller
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
	UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0];
	BikeParkMapViewController *mapViewController = [[navigationController viewControllers] objectAtIndex:0];
    [mapViewController updateMapViewLocation:self.point.coordinate];
    [self.tabBarController setSelectedIndex:0];
    // faz o pop deste viewcontroller
    [self.navigationController popViewControllerAnimated:YES];
    // faz o pop no navigationviewcontroller do mapa
    [navigationController popToRootViewControllerAnimated:YES];
}
@end
