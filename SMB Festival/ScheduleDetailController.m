//
//  ScheduleDetailController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/17/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "ScheduleDetailController.h"

@implementation ScheduleDetailController
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize levelLabel;
@synthesize lengthLabel;
@synthesize descriptionText;
@synthesize name;
@synthesize time;
@synthesize level;
@synthesize length;
@synthesize description;

- (void) dealloc {
    [super dealloc];
    [nameLabel release];
    [timeLabel release];
    [levelLabel release];
    [lengthLabel release];
    [descriptionText release];
    [name release];
    [time release];
    [level release];
    [length release];
    [description release];
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

- (void)viewWillAppear:(BOOL)animated {
    // setup detailView from info
    nameLabel.text = name;
    timeLabel.text = time;
    lengthLabel.text = length;
    descriptionText.text = description;
    
    if ([level length] == 0) {
        self.level = @"n/a";
    }
    levelLabel.text = level;
    
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.nameLabel = nil;
    self.timeLabel = nil;
    self.lengthLabel = nil;
    self.levelLabel = nil;
    self.description = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
