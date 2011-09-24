//
//  OfflineMapSourceController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/23/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "OfflineMapSourceController.h"
#import "DownloadController.h"

@implementation OfflineMapSourceController
@synthesize maplist;
@synthesize table;

- (void) dealloc {
    [super dealloc];
    [maplist release];
    [table release];
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

- (void) backToMaps {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSDictionary *)sourceForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    return [[[maplist objectAtIndex:section] objectForKey:@"Maps"] objectAtIndex:row];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Offline Sources";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    //setup the done button in the nav bar
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToMaps)];
    self.navigationItem.rightBarButtonItem = done;
    [done release];
    
    // load the maps
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Maps" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.maplist = [dict objectForKey:@"Root"];
    [dict release];
    
    self.table.backgroundColor = [UIColor clearColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [table indexPathForSelectedRow];
    //NSDictionary *source = [self sourceForIndexPath:indexPath];
    
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.maplist release];
    [self.table release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [maplist count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[maplist objectAtIndex:section] objectForKey:@"Maps"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *OfflineSourceCellIdentifier = @"OfflineSourceCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OfflineSourceCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle 
                 reuseIdentifier:OfflineSourceCellIdentifier] autorelease];
    }
    
    NSDictionary *source = [self sourceForIndexPath:indexPath];
    cell.textLabel.text = [source objectForKey:@"Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Filesize %@",[source objectForKey:@"Filesize"]];
    //set cell.imageView if downloaded
    //add checkmark disclosure icon if enabled
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[maplist objectAtIndex:section] valueForKey:@"Label"];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected section:%d , row:%d",[indexPath section],[indexPath row]);
    
    DownloadController *download = [[DownloadController alloc] initWithNibName:@"DownloadController" bundle:nil];
    download.sectionLabel = [[maplist objectAtIndex:[indexPath section]] objectForKey:@"Label"];
    download.source = [self sourceForIndexPath:indexPath];
    
    [self.navigationController pushViewController:download animated:YES];
}

@end
