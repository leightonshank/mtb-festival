//
//  VolunteerControll.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/12/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VolunteerController.h"

@implementation VolunteerController
@synthesize webController;
@synthesize button;

- (void) dealloc {
    [super dealloc];
    [webController release];
    [button release];
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
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"Back";
    self.navigationItem.backBarButtonItem = back;
    [back release];
    
    // setup buttons
    UIImage *buttonImageNormal = [UIImage imageNamed:@"yellowButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:16 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"greenButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:16 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webController = nil;
    self.button = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(id)sender {
    if (self.webController == nil) {
        VolunteerWebController *wc = [[VolunteerWebController alloc] initWithNibName:@"VolunteerWebController" bundle:nil];
        wc.title = @"Volunteer Signup";
        self.webController = wc;
        [wc release];
    }
    [self.navigationController pushViewController:self.webController animated:YES];
}

@end
