//
//  FestivalInfo.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/8/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "FestivalInfoMainController.h"
#import "FestivalInfoViewController.h"
#import "GeneralInfoController.h"
#import "RegistrationController.h"
#import "CampingController.h"
//#import "DirectionsController.h"
#import "VolunteerController.h"
#import "GearSwapController.h"
#import "MapViewController.h"
#import "FestivalInfoCell.h"

@implementation FestivalInfoMainController

@synthesize sections;
@synthesize infoTable;
@synthesize aboutController;
@synthesize infoButton;


- (void) dealloc {
    [super dealloc];
    [sections release];
    [infoTable release];
    [aboutController release];
    [infoButton release];
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

- (IBAction)infoButtonPressed:(id)sender {
    //NSLog(@"info button pressed!");
    if (aboutController == nil) {
        AboutController *about = [[AboutController alloc] initWithNibName:@"AboutController" bundle:nil];
        self.aboutController = about;
        [about release];
    }
    [aboutController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:aboutController animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"Back";
    self.navigationItem.backBarButtonItem = back;
    [back release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"svbc.png"]];
    self.navigationItem.titleView = imageView;
    [imageView release];
    
    self.title = @"Information";

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    // add an info icon to the nav bar
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = info;
    [info release];

    self.infoTable.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    
    /*
    NSArray *array = [[NSArray alloc] initWithObjects:@"General Information",
                      @"Registration", @"Camping", @"Directions", @"Volunteers",
                      @"Gear Swap", nil];
     */
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // About
    GeneralInfoController *generalInfoController = [[GeneralInfoController alloc] initWithNibName:@"GeneralInfoController" bundle:nil];
    generalInfoController.title = @"The Festival";
    generalInfoController.rowImage = [UIImage imageNamed:@"festival.png"];
    generalInfoController.rowImageHighlighted = [UIImage imageNamed:@"festival-white.png"];
    [array addObject:generalInfoController];
    [generalInfoController release];
    
    // Registration
    RegistrationController *registrationController = [[RegistrationController alloc] initWithNibName:@"RegistrationController" bundle:nil];
    registrationController.title = @"Register";
    registrationController.rowImage = [UIImage imageNamed:@"register.png"];
    registrationController.rowImageHighlighted = [UIImage imageNamed:@"register-white.png"];    
    [array addObject:registrationController];
    [registrationController release];
    
    // Camping
    CampingController *campingController = [[CampingController alloc] initWithNibName:@"CampingController" bundle:nil];
    campingController.title = @"Campground";
    campingController.rowImage = [UIImage imageNamed:@"campground.png"];
    campingController.rowImageHighlighted = [UIImage imageNamed:@"campground-white.png"];
    [array addObject:campingController];
    [campingController release];
    
    //MapView
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.title = @"Maps";
    mapViewController.rowImage = [UIImage imageNamed:@"maps.png"];
    mapViewController.rowImageHighlighted = [UIImage imageNamed:@"maps-white.png"];
    [array addObject:mapViewController];
    [mapViewController release];
    
    // Volunteers
    VolunteerController *volunteersController = [[VolunteerController alloc] initWithNibName:@"VolunteerController" bundle:nil];
    volunteersController.title = @"Volunteers";
    volunteersController.rowImage = [UIImage imageNamed:@"volunteers.png"];
    volunteersController.rowImageHighlighted = [UIImage imageNamed:@"volunteers-white.png"];
    [array addObject:volunteersController];
    [volunteersController release];
    
    // Gear Swap Controller
    GearSwapController *gearSwapController = [[GearSwapController alloc] initWithNibName:@"GearSwapController" bundle:nil];
    gearSwapController.title = @"Gear Swap";
    gearSwapController.rowImage = [UIImage imageNamed:@"gearswap.png"];
    gearSwapController.rowImageHighlighted = [UIImage imageNamed:@"gearswap-white.png"];
    [array addObject:gearSwapController];
    [gearSwapController release];
    
    self.sections = array;
    [array release];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [infoTable deselectRowAtIndexPath:[infoTable indexPathForSelectedRow] animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.sections = nil;
    self.infoTable = nil;
    self.aboutController = nil;
    self.infoButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table View Data Source Methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%d",[self.sections count]);
    
    return [self.sections count];
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FestivalInfoCellIdentifier = @"FestivalInfoCell";
    
    FestivalInfoCell *cell = (FestivalInfoCell *)[tableView dequeueReusableCellWithIdentifier:FestivalInfoCellIdentifier];
    
    if (cell == nil) {
        cell = [[[FestivalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FestivalInfoCellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    FestivalInfoViewController *controller = [sections objectAtIndex:row];
    cell.textLabel.text = controller.title;
    if (controller.rowImage != nil) {
        cell.imageView.image = controller.rowImage;
    }
    if (controller.rowImageHighlighted != nil) {
        cell.imageView.highlightedImage = controller.rowImageHighlighted;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    FestivalInfoViewController *nextController = [self.sections objectAtIndex:row];
    [self.navigationController pushViewController:nextController animated:YES];
}

@end
