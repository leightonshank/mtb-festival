//
//  OfflineMapSourceController.m
//  SMB Festival
//
//  Created by Leighton Shank on 9/23/11.
//  Copyright 2011 Ideas for Stuff. All rights reserved.
//

#import "OfflineMapSourceController.h"
#import "DownloadController.h"

#define kDataFilename @"offline-sources.plist"

@implementation OfflineMapSourceController
@synthesize maplist;
@synthesize table;
@synthesize downloadController;
@synthesize delegate;

- (void) dealloc {
    [super dealloc];
    [maplist release];
    [table release];
    [downloadController release];
    [delegate release];
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

- (void) doneButtonPressed {
    //[self dismissModalViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(didDismissOfflineMapSourceController:)]) {
        [self.delegate didDismissOfflineMapSourceController:self];
    }
}

- (NSDictionary *)sourceForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    return [[[maplist objectAtIndex:section] objectForKey:@"Maps"] objectAtIndex:row];
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kDataFilename];
}

- (void) loadOfflineMapData {
    NSLog(@"[loading offline map source data]");
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"-> read existing");
        // data file exists, so just read it
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        self.maplist = data;
        [data release];
        [array release];
    }
    else {
        NSLog(@"-> initialize");
        // no data file yet, so init from the template in our resource bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Maps" ofType:@"plist"];
        NSArray *array = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"Root"];
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        self.maplist = data;
        [data release];
        [array release];
    }
}

- (void) saveOfflineMapData {
    [maplist writeToFile:[self dataFilePath] atomically:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Offline Sources";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    //setup the done button in the nav bar
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = done;
    [done release];
    
    self.table.backgroundColor = [UIColor clearColor];
    
    [self loadOfflineMapData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"== view will appear ==");
    [self loadOfflineMapData];
    [table reloadData];
    
    NSIndexPath *indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveOfflineMapData];
}
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.maplist = nil;
    self.table = nil;
    self.downloadController = nil;
    self.delegate = nil;
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"File size %@",[source objectForKey:@"Filesize"]];

    //add checkmark disclosure icon if enabled
    bool enabled = [[source objectForKey:@"Enabled"] boolValue];
    if (enabled) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //set cell.imageView if downloaded
    bool downloaded = [[source objectForKey:@"Downloaded"] boolValue];
    if (downloaded) {
        cell.imageView.image = [UIImage imageNamed:@"downloaded.png"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"not-downloaded.png"];
    }
    cell.imageView.highlightedImage = [UIImage imageNamed:@"download-highlight.png"];
    
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[maplist objectAtIndex:section] valueForKey:@"Label"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == [maplist count] - 1) {
        return @"Sources with a checkmark are used in place of an online source.  Swipe a downloaded source to remove it from the device.";
    }
    return @"";
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected section:%d , row:%d",[indexPath section],[indexPath row]);

    NSDictionary *source = [self sourceForIndexPath:indexPath];
    bool downloaded = [[source objectForKey:@"Downloaded"] boolValue];
    
    if ( ! downloaded) {
        // if the map hasn't been downloaded yet then just setup the download controller and download it first
        // then it will be automatically enabled.
        if (downloadController == nil) {
            DownloadController *download = [[DownloadController alloc] initWithNibName:@"DownloadController" bundle:nil];
            self.downloadController = download;
            [download release];
        }
        
        downloadController.sourceLabel = [[maplist objectAtIndex:[indexPath section]] objectForKey:@"Label"];
        downloadController.sourceName = [source objectForKey:@"Name"];
        downloadController.sourceSize = [source objectForKey:@"Filesize"];
        downloadController.sourceURL = [source objectForKey:@"URL"];
        downloadController.sourceFilename = [source objectForKey:@"Filename"];
        downloadController.sourceDescription = [source objectForKey:@"Description"];
        downloadController.sourceIndexPath = indexPath;
        [self.navigationController pushViewController:downloadController animated:YES];
    }
    else {
        bool enabled = [[source objectForKey:@"Enabled"] boolValue];
        // disable whichever source is enabled !!
        NSMutableArray *sources = [[[maplist objectAtIndex:[indexPath section]] objectForKey:@"Maps"] mutableCopy];
        for (int ii=0; ii < [sources count]; ii++) {
            // get the source for this row
            NSDictionary *src = [[[maplist objectAtIndex:[indexPath section]] objectForKey:@"Maps"] objectAtIndex:ii];
            // and then make a mutable copy
            NSMutableDictionary *newSource = [[NSMutableDictionary alloc] initWithDictionary:src];
            
            if (ii == [indexPath row]) {
                // this is the row we selected so toggle the enabled value (!enabled)
                [newSource setValue:[NSNumber numberWithBool:!enabled] forKey:@"Enabled"];
            }
            else {
                // for all other rows set enabled to NO
                [newSource setValue:[NSNumber numberWithBool:NO] forKey:@"Enabled"];
            }
            
            [sources replaceObjectAtIndex:ii withObject:newSource];
            [newSource release];
        }
        
        // now that our sources is setup how we want them to be, we replace them in the "Maps" key for the section data
        NSMutableDictionary *section = [[maplist objectAtIndex:[indexPath section]] mutableCopy];
        [section setValue:sources forKey:@"Maps"];
        
        // finally we replace the section data in the maps list
        [maplist replaceObjectAtIndex:[indexPath section] withObject:section];
        
        [sources release];
        [section release];
        
        // save our data and pop back to the previous controller
        [self saveOfflineMapData];
        [table reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *source = [self sourceForIndexPath:indexPath];
    bool downloaded = [[source objectForKey:@"Downloaded"] boolValue];
    if (downloaded) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sources = [[[maplist objectAtIndex:[indexPath section]] objectForKey:@"Maps"] mutableCopy];
    for (int ii=0; ii < [sources count]; ii++) {
        // get the source for this row
        NSDictionary *src = [[[maplist objectAtIndex:[indexPath section]] objectForKey:@"Maps"] objectAtIndex:ii];
        // and then make a mutable copy
        NSMutableDictionary *newSource = [[NSMutableDictionary alloc] initWithDictionary:src];
        
        if (ii == [indexPath row]) {
            // this is the row we selected so delete the file and change the downloaded
            // and enabled statuses
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filepath = [documentsDirectory stringByAppendingPathComponent:[src objectForKey:@"Filename"]];
            
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:&error];
            
            if (error == nil) {
                [newSource setValue:[NSNumber numberWithBool:NO] forKey:@"Downloaded"];
                [newSource setValue:[NSNumber numberWithBool:NO] forKey:@"Enabled"];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:[error localizedDescription]
                                      message:[error localizedFailureReason]
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        
        [sources replaceObjectAtIndex:ii withObject:newSource];
        [newSource release];
    }
    
    // now that our sources is setup how we want them to be, we replace them in the "Maps" key for the section data
    NSMutableDictionary *section = [[maplist objectAtIndex:[indexPath section]] mutableCopy];
    [section setValue:sources forKey:@"Maps"];
    
    // finally we replace the section data in the maps list
    [maplist replaceObjectAtIndex:[indexPath section] withObject:section];
    
    [sources release];
    [section release];
    
    // save our data and pop back to the previous controller
    [self saveOfflineMapData];
    [table reloadData];
}

@end
