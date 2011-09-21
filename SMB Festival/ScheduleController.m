//
//  Schedule.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/17/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "ScheduleController.h"

#define kScheduleCellTime   1
#define kScheduleCellName   2
#define kScheduleCellLevel  3
#define kScheduleCellLength 4

@implementation ScheduleController

@synthesize list;
@synthesize scheduleCell;
@synthesize detailView;

- (void)dealloc {
    [super dealloc];
    [list release];
    [scheduleCell release];
    [detailView release];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.title = @"Schedule";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"svbc.png"]];
    self.navigationItem.titleView = imageView;
    [imageView release];
    
    // load the schedule
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Schedule" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.list = [dict objectForKey:@"Root"];
    [dict release];
    
    //set background color
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scheduleCell = nil;
    self.detailView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.list count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.list objectAtIndex:section] objectForKey:@"Label"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.list objectAtIndex:section] objectForKey:@"Items"] count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ScheduleCell" owner:self options:nil];
        cell = scheduleCell;
        self.scheduleCell = nil;
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule-cell.png"]];
        cell.backgroundView = bg;
        [bg release];
        
        UIImageView *bgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule-cell-selected.png"]];
        cell.selectedBackgroundView = bgSelected;
        [bgSelected release];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSDictionary *info = [[[self.list objectAtIndex:section] objectForKey:@"Items"] 
                          objectAtIndex:row];
    
    // Colors
    UIColor *timeColor = [UIColor colorWithRed:69.0/255.0 green:119.0/255.0 blue:0.0 alpha:1.0];
    UIColor *levelColor = [UIColor colorWithRed:171.0/255.0 green:80.0/255.0 blue:38.0/255.0 alpha:1.0];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:kScheduleCellTime];
    label.text = [info objectForKey:@"Time"];
    label.textColor = timeColor;
    
    label = (UILabel *)[cell viewWithTag:kScheduleCellName];
    label.text = [info objectForKey:@"Name"];
    
    label = (UILabel *)[cell viewWithTag:kScheduleCellLevel];
    label.text = [info objectForKey:@"Level"];
    label.textColor = levelColor;
    
    label = (UILabel *)[cell viewWithTag:kScheduleCellLength];
    label.text = [info objectForKey:@"Length"];
    label.textColor = timeColor;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (detailView == nil) {
        //init the detail view
        detailView = [[ScheduleDetailController alloc] initWithNibName:@"ScheduleDetailController" bundle:nil];
    }
    
    detailView.title = @"Details";
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSDictionary *details = [[[self.list objectAtIndex:section] objectForKey:@"Items"] 
                          objectAtIndex:row];
    
    detailView.name = [details objectForKey:@"Name"];
    detailView.time = [details objectForKey:@"Time"];
    detailView.level = [details objectForKey:@"Level"];
    detailView.length = [details objectForKey:@"Length"];
    detailView.description = [details objectForKey:@"Description"];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"Back";
    self.navigationItem.backBarButtonItem = back;
    [back release]; 
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
    return [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule-header.png"]] autorelease];
     */
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 36.0)] autorelease];
    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"schedule-header.png"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 9.0, 280.0, 18.0)];
    label.text = [[self.list objectAtIndex:section] objectForKey:@"Label"];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    label.shadowColor = [UIColor blackColor];
    
    [header addSubview:label];
    [label release];
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0;
}

@end
