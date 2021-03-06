//
//  GeneralInfoController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/9/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "GeneralInfoController.h"

@implementation GeneralInfoController

@synthesize scroll;
@synthesize page1;

- (void) dealloc {
    [super dealloc];
    [scroll release];
    [page1 release];
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
    
    self.page1.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // setup the page in the scroll view
    [scroll addSubview:page1];
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, page1.frame.size.height)];
                           
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [scroll flashScrollIndicators];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scroll = nil;
    self.page1  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
