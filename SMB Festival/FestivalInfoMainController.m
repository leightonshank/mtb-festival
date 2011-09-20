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

@implementation FestivalInfoMainController

@synthesize sections;
@synthesize infoTable;
@synthesize titleView;

- (void) dealloc {
    [super dealloc];
    [sections release];
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
    self.title = @"Information";
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    
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
    generalInfoController.title = @"About";
    //generalInfoController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:generalInfoController];
    [generalInfoController release];
    
    // Registration
    RegistrationController *registrationController = [[RegistrationController alloc] initWithNibName:@"RegistrationController" bundle:nil];
    registrationController.title = @"Registration";
    //registrationController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:registrationController];
    [registrationController release];
    
    // Camping
    CampingController *campingController = [[CampingController alloc] initWithNibName:@"CampingController" bundle:nil];
    campingController.title = @"Camping";
    //campingController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:campingController];
    [campingController release];
    
    // Directions
    /*
    DirectionsController *directionsController = [[DirectionsController alloc] initWithNibName:@"DirectionsController" bundle:nil];
    directionsController.title = @"Directions";
    //directionsController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:directionsController];
    [directionsController release];
     */
    
    //MapView
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.title = @"Map and Directions";
    //mapViewController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:mapViewController];
    [mapViewController release];
    
    // Volunteers
    VolunteerController *volunteersController = [[VolunteerController alloc] initWithNibName:@"VolunteerController" bundle:nil];
    volunteersController.title = @"Volunteers";
    //volunteersController.rowImage = [UIImage imageNamed:@"image.png"];
    [array addObject:volunteersController];
    [volunteersController release];
    
    // Gear Swap Controller
    GearSwapController *gearSwapController = [[GearSwapController alloc] initWithNibName:@"GearSwapController" bundle:nil];
    gearSwapController.title = @"Gear Swap";
    //gearSwapController.rowImage = [UIImage imageNamed:@"image.png"];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table View Data Source Methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d",[self.sections count]);
    
    return [self.sections count];
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FestivalInfoCell = @"FestivalInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FestivalInfoCell];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FestivalInfoCell] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    FestivalInfoViewController *controller = [sections objectAtIndex:row];
    cell.textLabel.text = controller.title;
    //cell.imageView.image = controller.rowImage;
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
