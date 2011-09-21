//
//  RegistrationController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/10/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "RegistrationController.h"
#import "RegistrationWebController.h"

@implementation RegistrationController
@synthesize scroll;
@synthesize page;

- (void) dealloc {
    [super dealloc];
    [scroll release];
    [page release];
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
    
    self.page.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // setup the page in the scroll view
    [scroll addSubview:page];
    [scroll setContentSize:CGSizeMake(self.view.frame.size.width, page.frame.size.height)];
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
    self.page = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction methods
- (IBAction)buttonPressed:(id)sender {
    RegistrationWebController *nextController = [[RegistrationWebController alloc] initWithNibName:@"RegistrationWebController" bundle:nil];
    nextController.title = @"Register On-Line";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"Back";
    self.navigationItem.backBarButtonItem = back;
    [back release];
    
    [self.navigationController pushViewController:nextController animated:YES];
}

@end
