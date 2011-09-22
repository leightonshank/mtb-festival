//
//  RegistrationWebController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/10/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "RegistrationWebController.h"

@implementation RegistrationWebController
@synthesize web;
@synthesize loading;

- (void)loadPage {
    // add the loading subview
    [self.view addSubview:loading];
    
    // then fire off the request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.active.com/register/index.cfm?CHECKSSO=0&EVENT_ID=1931854&stop_mobi=yes"]];
    self.web.scalesPageToFit = YES;
    [web loadRequest:request];
}

- (void) dealloc {
    [super dealloc];
    [web release];
    [loading release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.web.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *reload = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(loadPage)];
    self.navigationItem.rightBarButtonItem = reload;
    [reload release];
    
    [self loadPage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.web = nil;
    self.loading = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegete methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loading removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error %i", error.code);
    if (error.code == NSURLErrorCancelled) return; // this is Error -999
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:[error localizedDescription]
                          message:[error localizedFailureReason]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.loading removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
