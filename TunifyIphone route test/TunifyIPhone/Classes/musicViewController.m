//
//  musicViewController.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "musicViewController.h"
#import "songCell.h"

@implementation musicViewController

@synthesize pub;
@synthesize source;
@synthesize dataSource;
@synthesize tableView;
@synthesize rowPlaying;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void) btnPubs_clicked:(id)sender {
	if ( self.tabBarController.view.subviews.count >= 2 )
	{
		UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
		UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) btnRoute_clicked:(id)sender {
	NSLog(@"self source: %d", self.source);
	if (self.source == 1) {
		// We come from the pub visit view, so we'll need the tab bar back
		if ( self.tabBarController.view.subviews.count >= 2 )
		{
			UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
			UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
			
			[view sizeToFit];
			tabBar.hidden = FALSE;
		}
		
		[self.navigationController popViewControllerAnimated:YES];

	} else if (self.source == 2) {
		
		
		[self.navigationController popViewControllerAnimated:YES];
		
		/*
		// Add the pub to the recently visited pub list
		RecentlyVisited *rv = [RecentlyVisited sharedInstance];
		[rv addPub:self.pub];
		
		mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
		controller.pub = self.pub;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		controller = nil;
		 */
	}
	
	
	
}


- (void) playMusic:(id)sender {
	
	NSLog(@"Playing music: %d", self.rowPlaying);
	CellButton *button = (CellButton *)sender;
	
	if (self.rowPlaying == -1) {
		// Nothing is playing yet
		self.rowPlaying = button.row;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		
		//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		//audioPlayer.delegate = self;
		//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
		
		NSLog(@"PLAYING");
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer playTest:@"song2"];
	} else {
		if (self.rowPlaying == button.row) {
			// Our current cell is playing
			self.rowPlaying = -1;
			[button setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			//[audioPlayer stop];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer stopTest];
		} else {
			NSLog(@"a");
			NSLog(@"row playing: %d", self.rowPlaying);
			//NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:self.rowPlaying];
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			songCell *c = (songCell *)cell;
			NSLog(@"b");
			[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			// Now update our current cell
			self.rowPlaying = button.row;
			[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
			
			//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			//audioPlayer.delegate = self;
			//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer stopTest];
			[audioPlayer playTest:@"song2"];
			
			[indexPath release];
		}
	}
	
}


- (void) buySong:(id)sender {
	NSLog(@"buying song");
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480 );     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }
	
	
	self.navigationItem.title = [self.pub name];
	
	// Create the left bar button item
	UIBarButtonItem *pubsBarButtonItem = [[UIBarButtonItem alloc] init];
	pubsBarButtonItem.title = @"Pubs";
	pubsBarButtonItem.target = self;
	pubsBarButtonItem.action = @selector(btnPubs_clicked:);
	self.navigationItem.leftBarButtonItem = pubsBarButtonItem;
	[pubsBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *routeBarButtonItem = [[UIBarButtonItem alloc] init];
	routeBarButtonItem.title = @"Close";
	
	routeBarButtonItem.target = self;
	routeBarButtonItem.action = @selector(btnRoute_clicked:);
	self.navigationItem.rightBarButtonItem = routeBarButtonItem;
	[routeBarButtonItem release];

	
	// Create some test data for the table
	dataSource = [[NSMutableArray alloc] init];
	
	NSArray *song1 = [NSArray arrayWithObjects:@"Kitten moon", @"Fluke", nil];
	NSArray *song2 = [NSArray arrayWithObjects:@"Kingdom of Rust", @"Doves", nil];
	NSArray *song3 = [NSArray arrayWithObjects:@"Rain", @"Mika", nil];
	
	[dataSource addObject:song1];
	[dataSource addObject:song2];
	[dataSource addObject:song3];
	
	self.rowPlaying = -1;
	
	//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	//[audioPlayer play:@"http://localhost:1935/live/mp3:LethalIndustry.mp3/playlist.m3u8"];
	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	NSLog(@"music view controller view did appear");
	
	
	if(rowPlaying == -1) {
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer stopTest];
	} 
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	songCell *c = (songCell *)cell;
	[self playMusic:c.playButton];
	
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// Stop the music and reset all play buttons to the play icon
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	if (rowPlaying > -1) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		songCell *c = (songCell *)cell;
		[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	}
	self.rowPlaying = -1;
	
}

/*
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) theplayer successfully:(BOOL)flag { 
	NSLog(@"Song played");
	[theplayer release]; 
} 
 */



/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    songCell *cell = (songCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[songCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSArray *infoArray = [dataSource objectAtIndex:[indexPath row]];
	cell.songTitle.text = [infoArray objectAtIndex:0];
	cell.songArtist.text = [infoArray objectAtIndex:1];
	
	[cell.playButton addTarget:self	action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.playButton.row = indexPath.row;	
	[cell.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}


- (void)dealloc {
	[pub release];
	[dataSource release];
	//[tableView release];
	
    [super dealloc];
}


@end

