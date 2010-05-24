//
//  pubListController.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pubListController.h"
#import "pubList3DController.h"
#import "mapViewController.h"
#import "pubCell.h"
#import "CellButton.h"
#import "genreViewController.h"

@implementation pubListController

@synthesize tableView;
@synthesize dataSource;
@synthesize genre;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize webData;
@synthesize buttonPlaying;
@synthesize rowPlaying;
@synthesize userLocation;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize picker;
@synthesize overlayView;

// test stuff
@synthesize previousDate;
@synthesize nrReadings;
@synthesize averageZ;
@synthesize averageX;
@synthesize velX;
@synthesize distX;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (IBAction)btnFilter_clicked:(id)sender {
	
	if(in3DView) {
		UIActionSheet *popupQuery = [[UIActionSheet alloc]
									 initWithTitle:nil
									 delegate:self
									 cancelButtonTitle:@"Cancel"
									 destructiveButtonTitle:nil
									 otherButtonTitles:@"By genre", @"By rating", @"By visitors", @"By distance", nil];
		
		popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
		[popupQuery showInView:self.tabBarController.view];
		[popupQuery release];
	} else {
		UIActionSheet *popupQuery = [[UIActionSheet alloc]
									 initWithTitle:nil
									 delegate:self
									 cancelButtonTitle:@"Cancel"
									 destructiveButtonTitle:nil
									 otherButtonTitles:@"By genre", @"By rating", @"By visitors", @"By distance", nil];
		
		popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
		[popupQuery showInView:self.tabBarController.view];
		[popupQuery release];
	}
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (in3DView) {
		if (buttonIndex == 0) {
		} else if (buttonIndex == 1) {
			// sort by rating
			[self.overlayView filterByRating];
		} else if (buttonIndex == 2) {
			[self.overlayView filterByVisitors];
		} else if (buttonIndex == 3) {
			[self.overlayView filterByDistance];
		}
	} else {
		if (buttonIndex == 0) {
			// Sort by genre
			genreViewController *gvc = [[genreViewController alloc] initWithNibName:@"genreView" bundle:[NSBundle mainBundle]];
			gvc.sourceView = self;
			gvc.sourceId = 1;
			[self.navigationController pushViewController:gvc animated:YES];
			[gvc release];
			gvc = nil;
			
		} else if (buttonIndex == 1) {
			// Sort by rating
			NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
			
			for(Pub *pub in dataSource) {
				// Initial entry
				if ([sortedArray count] == 0) {
					[sortedArray addObject:pub];
				} else {
					// Further entries
					if ([[pub rating] intValue] <= [[[sortedArray lastObject] rating] intValue]) {
						[sortedArray addObject:pub];
					} else if ([[pub rating] intValue] >= [[[sortedArray objectAtIndex:0] rating] intValue]) {
						[sortedArray insertObject:pub atIndex:0];
					} else {
						for(int i=0; i<[sortedArray count]; i++) {
							if ([[pub rating] intValue] == [[[sortedArray objectAtIndex:i] rating] intValue]) {
								[sortedArray insertObject:pub atIndex:i];
								break;
							} else if ([[pub rating] intValue] < [[[sortedArray objectAtIndex:i] rating] intValue] && [[pub rating] intValue] > [[[sortedArray objectAtIndex:i+1] rating] intValue]) {
								[sortedArray insertObject:pub atIndex:i+1];
								break;
							}
						} // end for loop
					}				
				}
			} // end for loop
			
			[dataSource removeAllObjects];
			dataSource = sortedArray;
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:dataSource];
			[tableView reloadData];
			
		} else if (buttonIndex == 2) {
			// Sort by visitors
			NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
			
			for(Pub *pub in dataSource) {
				NSLog(@"Pub: %@", [pub name]);
				NSLog(@"Visitors: %@", [pub visitors]);
				// Initial entry
				if ([sortedArray count] == 0) {
					[sortedArray addObject:pub];
				} else {
					// Further entries
					if ([[pub visitors] intValue] <= [[[sortedArray lastObject] visitors] intValue]) {
						[sortedArray addObject:pub];
					} else if ([[pub visitors] intValue] >= [[[sortedArray objectAtIndex:0] visitors] intValue]) {
						[sortedArray insertObject:pub atIndex:0];
					} else {
						for(int i=0; i<[sortedArray count]; i++) {
							if ([[pub visitors] intValue] == [[[sortedArray objectAtIndex:i] visitors] intValue]) {
								[sortedArray insertObject:pub atIndex:i];
								break;
							} else if ([[pub visitors] intValue] < [[[sortedArray objectAtIndex:i] visitors] intValue] && [[pub visitors] intValue] > [[[sortedArray objectAtIndex:i+1] visitors] intValue]) {
								[sortedArray insertObject:pub atIndex:i+1];
								break;
							}
						} // end for loop
					}				
				}
			} // end for loop
			
			[dataSource removeAllObjects];
			dataSource = sortedArray;
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:dataSource];
			[tableView reloadData];
			
		} else if (buttonIndex == 3) {
			NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
			
			CoordinatesTool *ct = [CoordinatesTool sharedInstance];
			for(Pub *pub in dataSource) {
				NSLog(@"Pub: %@", [pub name]);
				
				CLLocationDegrees longitude= [[pub longitude] doubleValue];
				CLLocationDegrees latitude = [[pub latitude] doubleValue];
				CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
				CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
				[pubLocation release];
				
				NSLog(@"Distance: %f", distance);
				
				// Initial entry
				if ([sortedArray count] == 0) {
					[sortedArray addObject:pub];
				} else {
					// Further entries
					CLLocationDegrees longitude= [[[sortedArray lastObject] longitude] doubleValue];
					CLLocationDegrees latitude = [[[sortedArray lastObject] latitude] doubleValue];
					CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
					CLLocationDistance lastPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
					[pubLocation release];
					
					longitude= [[[sortedArray objectAtIndex:0] longitude] doubleValue];
					latitude = [[[sortedArray objectAtIndex:0] latitude] doubleValue];
					pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
					CLLocationDistance firstPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
					[pubLocation release];
					
					if (distance >= lastPubDistance) {
						[sortedArray addObject:pub];
					} else if (distance <= firstPubDistance) {
						[sortedArray insertObject:pub atIndex:0];
					} else {
						for(int i=0; i<[sortedArray count]; i++) {
							
							CLLocationDegrees longitude= [[[sortedArray objectAtIndex:i] longitude] doubleValue];
							CLLocationDegrees latitude = [[[sortedArray objectAtIndex:i] latitude] doubleValue];
							CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
							CLLocationDistance otherPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
							[pubLocation release];
							
							if (distance == otherPubDistance) {
								[sortedArray insertObject:pub atIndex:i];
								break;
							} else { 
								CLLocationDegrees longitude= [[[sortedArray objectAtIndex:i+1] longitude] doubleValue];
								CLLocationDegrees latitude = [[[sortedArray objectAtIndex:i+1] latitude] doubleValue];
								CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
								CLLocationDistance nextPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
								[pubLocation release];
								
								if (distance > otherPubDistance && distance < nextPubDistance) {
									[sortedArray insertObject:pub atIndex:i+1];
									break;
								}
							}
						} // end for loop
					}				
				}
			} // end for loop
			
			[dataSource removeAllObjects];
			dataSource = sortedArray;
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:dataSource];
			[tableView reloadData];
		}
		
	}

}


- (IBAction)btnList_clicked:(id)sender {
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	self.rowPlaying = -1;
	pubPlaying = FALSE;
	
	[self hide3DList];
}

- (IBAction)btnLookAround_clicked:(id)sender {
	/*
	pubList3DController *controller = [[pubList3DController alloc] initWithNibName:@"pubList3D" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	*/
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	
	
	if(! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		NSLog(@"error with picker");
		self.picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this feature."
														   delegate:self
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
		
		[alertView show];
		[alertView release];
	} else {
		[self show3DList];
	}	

}

- (void) pubCell_clicked:(id)sender row:(NSInteger)theRow {
	
	Pub *pub = [dataSource objectAtIndex:theRow];
	
	// Add the pub to the recently visited pub list
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	[rv addPub:pub];
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	
	
	mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
	controller.pub = pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}

- (IBAction) searchFieldDoneEditing:(id)sender {
	NSLog(@"Searching");
}

- (void) playMusic:(id)sender {

	CellButton *button = (CellButton *)sender;
	self.buttonPlaying = button;
	
	if (self.rowPlaying == -1) {
		// Nothing is playing yet
		self.rowPlaying = button.row;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];

		//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		//audioPlayer.delegate = self;
		//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
		
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer playTest:@"song1"];
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
			pubCell *c = (pubCell *)cell;
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
			[audioPlayer playTest:@"song1"];
			
			[indexPath release];
		}
	}
	
}

- (void) showMusic:(id)sender {
	CellButton *button = (CellButton *)sender;
	Pub *thePub = (Pub*)[self.dataSource objectAtIndex:button.row];
	musicViewController *controller = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	controller.pub = thePub;
	controller.source = 1;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}

#pragma mark -
#pragma mark View managment

- (void)viewDidLoad {
    [super viewDidLoad];
	
	searchBar.showsCancelButton = YES;
	
	self.navigationItem.title = @"Pubs";
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	self.navigationItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];

	// Create the right bar button item
	UIBarButtonItem *lookBarButtonItem = [[UIBarButtonItem alloc] init];
	lookBarButtonItem.title = @"Look around";
	lookBarButtonItem.target = self;
	lookBarButtonItem.action = @selector(btnLookAround_clicked:);
	self.navigationItem.rightBarButtonItem = lookBarButtonItem;
	[lookBarButtonItem release];
	
	// This is required to prevent the bottom part of the table from hiding behind the tab bar.
	[self.tableView setFrame:CGRectMake(0,0,320,400)];
	
	
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *theManagedObjectContext = appDelegate.managedObjectContext;
	self.managedObjectContext = theManagedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pub" inManagedObjectContext:self.managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Might want to do something more serious... 
		NSLog(@"Can’t load the Pub data!"); 
	} 
	NSLog(@"MutableFetchResults: %d", [mutableFetchResults count]);
	if (mutableFetchResults == nil || [mutableFetchResults count] <= 0) {
		NSLog(@"INserting new pubs");
		[self insertNewObject:@"De zoete bron" andStreet:@"M.Noestraat" andNumber:@"15" andZipCode:@"3050" andCity:@"Oud heverlee" 
					andUserID:@"418090" andRating:@"4" andLatitude:@"50.8236691" andLongitude:@"4.6626304" andVisitors:@"87"];
		
		[self insertNewObject:@"Fitforyou" andStreet:@"Mechelsesteenweg" andNumber:@"763" andZipCode:@"3020" andCity:@"Herent" 
					andUserID:@"418012" andRating:@"3" andLatitude:@"50.9204853" andLongitude:@"4.6479286" andVisitors:@"90"];
		
		[self insertNewObject:@"Cafe Mezza" andStreet:@"Mathieu de Layensplein" andNumber:@"119" andZipCode:@"3000" andCity:@"Leuven" 
					andUserID:@"416197" andRating:@"5" andLatitude:@"50.8799430" andLongitude:@"4.7002825" andVisitors:@"18"];
		
		[self insertNewObject:@"Linx" andStreet:@"Vismarkt" andNumber:@"17" andZipCode:@"3000" andCity:@"Leuven" 
					andUserID:@"416665" andRating:@"1" andLatitude:@"50.8817091" andLongitude:@"4.6998039" andVisitors:@"23"];
		
		[self insertNewObject:@"Mundo" andStreet:@"Martelarenplein" andNumber:@"14" andZipCode:@"3000" andCity:@"Leuven" 
					andUserID:@"418090" andRating:@"0" andLatitude:@"50.8814212" andLongitude:@"4.7145274" andVisitors:@"24"];
		
		[self insertNewObject:@"Mephisto" andStreet:@"Oude Markt" andNumber:@"2" andZipCode:@"3000" andCity:@"Leuven" 
					andUserID:@"315056" andRating:@"2" andLatitude:@"50.8783624" andLongitude:@"4.6996464" andVisitors:@"54"];
		
		[self insertNewObject:@"Cafe de Zappa" andStreet:@"Emile Carelsstraat" andNumber:@"1" andZipCode:@"3090" andCity:@"Overijse" 
					andUserID:@"413875" andRating:@"3" andLatitude:@"50.7709673" andLongitude:@"4.5401609" andVisitors:@"9"];
		
		// Route test location
		/*
		[self insertNewObject:@"Campus" andStreet:@"Celestijnenlaan" andNumber:@"200" andZipCode:@"3001" andCity:@"Heverlee" 
					andUserID:@"23423" andRating:@"5" andLatitude:@"50.86311" andLongitude:@"4.67858" andVisitors:@"1000"];
		*/
		
		if (![self.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	[mutableFetchResults release];
	[request release];
	 
	
	/*
	for(Pub *pub in mutableFetchResults) {
		[self.managedObjectContext deleteObject:pub];
	}
	*/
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	[self tunify_login];
	
	self.rowPlaying = -1;
	NSLog(@"End viewdidload");
	
	//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	NSLog(@"publistcontroller view did appear");
	
	
	if(rowPlaying == -1 && pubPlaying == FALSE) {
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer stopTest];
	} 

	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	
	ct.delegate = self;
	[ct fetchUserLocation];
	
	locationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateCurrentLocation) userInfo:nil repeats: YES];
	NSLog(@"end publistcontroller view did appear");
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// Stop the music and reset all play buttons to the play icon
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	if (rowPlaying > -1) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		pubCell *c = (pubCell *)cell;
		[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	}
	self.rowPlaying = -1;
	pubPlaying = FALSE;
	
	if(in3DView == FALSE) {
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		[ct stop];
		NSLog(@"VIEW DID DISAPPEAR STOP");
		[locationTimer invalidate];
	}
	 
	 
 }
 
#pragma mark -
#pragma mark Location management

- (void)updateCurrentLocation {
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	//[ct reInit];
	[ct fetchUserLocation];
	NSLog(@"Updating current location");
}

#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject:(NSString *)theName andStreet:(NSString *)theStreet andNumber:(NSString *)theNumber
				andZipCode:(NSString *)theZipCode andCity:(NSString *)theCity andUserID:(NSString *)theUserID
				andRating:(NSString *)theRating andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude
				andVisitors:(NSString *)theVisistors
{
	
	Pub *pub = (Pub *)[NSEntityDescription insertNewObjectForEntityForName:@"Pub" inManagedObjectContext:self.managedObjectContext];
	[pub setName:theName];
	[pub setStreet:theStreet];
	[pub setNumber:theNumber];
	[pub setZipcode:theZipCode];
	[pub setCity:theCity];
	[pub setUserid:theUserID];
	[pub setRating:theRating];
	[pub setLatitude:theLatitude];
	[pub setLongitude:theLongitude];
	[pub setVisitors:theVisistors];
	[pub setAddress:[NSString stringWithFormat:@"%@ %@, %@ %@", theStreet, theNumber, theZipCode, theCity]];
	
	// Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
}


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark AudioPlayer delegate
- (void)audioPlayerError:(AudioPlayer *)sender {
	
	[self.buttonPlaying setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"Could not contact the Tunify server. Audio playback will not work.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	
	[alertView show]; 
}

#pragma mark -
#pragma mark Location lookup callbacks

- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	
	NSLog(@"userLatitude: %f", self.userLocation.coordinate.latitude);
	NSLog(@"userLongitude: %f", self.userLocation.coordinate.longitude);
	
	NSLog(@"USERLOCATION FOUND");
	// Fetch all possible pubs from Core Data
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *theManagedObjectContext = appDelegate.managedObjectContext;
	self.managedObjectContext = theManagedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pub" inManagedObjectContext:self.managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Might want to do something more serious... 
		NSLog(@"Can’t load the Pub data!"); 
	} 
	
	// Now that we know our location, we can filter the discoverd pubs based on their distance from us.
	float radius = appDelegate.radius;
	
	/*
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString *radius = [userDefaults stringForKey:@"radius"];
	//int radius = [[userDefaults stringForKey:@"radius"] intValue];
	//NSLog(@"Radius: %d", [radius doubleValue]);
	*/
	//NSLog(@"Radius: %d", [radius doubleValue]);
	//NSLog(@"Radius: %@", radius);
	NSLog(@"PUBS: %d", [mutableFetchResults count]);
	self.dataSource = [[NSMutableArray alloc] init];
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	for(Pub *pub in mutableFetchResults) {
		NSLog(@"pub name: %@", pub.name);
		CLLocationDegrees longitude = [[pub longitude] doubleValue]; 
		CLLocationDegrees latitude = [[pub latitude] doubleValue]; 
		CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation];
		NSLog(@"distance: %f", distance);	
		//NSLog(@"Radius: %f", [radius doubleValue] * 1000);
		NSLog(@"Radius: %f", radius * 1000);
		if (distance <= (radius * 1000)) {

			[self.dataSource addObject:pub];
		}
	}
	
	tableData = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	[tableData addObjectsFromArray:dataSource];
	for (Pub *pub in tableData) {
		NSLog(@"Pub name: %@", pub.name);
	}
	
	if (in3DView == TRUE) {
		[self.overlayView updateAllHeadings];
	} else {
		[tableView reloadData];
		
		// Reset the playbuttons (because a pauze button will be reset to a play button after reloadData was called)
		if (rowPlaying > -1) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			pubCell *c = (pubCell *)cell;
			[c.playButton setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		}
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)userLocationError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while fetching your position.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	[alertView show]; 
}

#pragma mark -
#pragma mark Tunify and XML 
-(void)tunify_login {
	// Log in the user
	NSString *soapMessage;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SOAP_loginUser" ofType:@"xml"];  
	if (filePath) {  
		soapMessage = [NSString stringWithContentsOfFile:filePath];  
	}
	NSLog(soapMessage);
	
	
	NSURL *url = [NSURL URLWithString:@"http://webservice.aristomusic.com/production/services/tunify2/"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:@"http://www.tunify.com/loginUser" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue:@"webservice.aristomusic.com" forHTTPHeaderField:@"Host"];
	[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		webData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(theXML);
	[theXML release];
	
	if( xmlParser )
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	[connection release];
	[webData release];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"statusCode"] || [elementName isEqualToString:@"sessionCode"] || [elementName isEqualToString:@"userID"]) {
		if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
		recordResults = TRUE;
	} else if ([elementName isEqualToString:@"faultcode"]) {
		[xmlParser abortParsing];
		// An error occured while loggin in.
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
															message:NSLocalizedString(@"Could not connect to the Tunify server.",  
																					  @"message") 
															delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel")
															otherButtonTitles:nil];
		[alertView show];
	}
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
		[soapResults appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"statusCode"])
	{
		recordResults = FALSE;
		
		if ([soapResults isEqualToString:@"OK"] == FALSE) {
			[xmlParser abortParsing];
			// An error occured while loggin in.
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
																message:NSLocalizedString(@"Could not connect to the Tunify server.",  
																						  @"message") 
																delegate:self 
																cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel")
																otherButtonTitles:nil]; 
			[alertView show]; 
		}		
		
		[soapResults release];
		soapResults = nil;
	} else if ([elementName isEqualToString:@"sessionCode"]) {

		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
		[userDefaults setObject:soapResults forKey:@"sessionCode"];
		
		[soapResults release];
		soapResults = nil;
	} else if ([elementName isEqualToString:@"userID"]) {
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
		[userDefaults setObject:soapResults forKey:@"userID"];
		
		[soapResults release];
		soapResults = nil;
	}
}

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
	NSLog(@"numberofRowsInSection");
	return [tableData count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	pubCell *cell = (pubCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[pubCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Pub *pub = [tableData objectAtIndex:indexPath.row];
	cell.nameLabel.text = [pub name];
	
	if (self.userLocation != nil) {
		CLLocationDegrees longitude= [[pub longitude] doubleValue];
		CLLocationDegrees latitude = [[pub latitude] doubleValue];
		CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation];
		[pubLocation release];
		NSString *strDistance = [NSString stringWithFormat:@"%f", distance/1000];
		NSRange commaRange = [strDistance rangeOfString:@"."];
		strDistance = [strDistance substringToIndex:commaRange.location + 2];
		cell.distanceLabel.text = [NSString stringWithFormat:@"%@ km", strDistance];
	} else {
		cell.distanceLabel.text = @"Distance unknown";
	}
	
	// Set stars rating
	[cell.stars setRating:[[pub rating] intValue]];
	// Set visitor amount
	cell.visitorsLabel.text = pub.visitors;
		
	
	
	[cell.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	[cell.playButton addTarget:self	action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
	//cell.playButton.indexPath = indexPath;
	NSLog(@"Playbutton row: %d", cell.playButton.row);
	cell.playButton.row = indexPath.row;
	
	[cell.infoButton setImage:[UIImage imageNamed:@"infoButton.png"] forState:UIControlStateNormal];
	[cell.infoButton addTarget:self action:@selector(showMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.infoButton.row = indexPath.row;
	
    return cell;
	
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Did select row at index path");
	[self pubCell_clicked:theTableView row:indexPath.row];
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
	return 90;
}


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
	
	// only show the status bar’s cancel button while in edit mode
	theSearchBar.showsCancelButton = YES;
	theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
	theSearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[tableData removeAllObjects]; // remove all data that belongs to previous search
	if([searchText isEqualToString:@""] || searchText == nil) {
		[tableData addObjectsFromArray:dataSource];
		[tableView reloadData];
		return;
	}

	NSInteger counter = 0;
	for(Pub *pub in dataSource) 
	{
		NSString *name = [pub name];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(r.location != NSNotFound)
		{
			[tableData addObject:pub];
		}
		counter++;
		[pool release];
	}
	
	[tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:dataSource];
	@try{
		[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[theSearchBar resignFirstResponder];
	theSearchBar.text = @"";
	[tableView reloadData];
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	[theSearchBar resignFirstResponder];
}

#pragma mark 3D list methods
- (void)show3DList {
	//self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.overlayView = [[OverlayView buttonWithType:UIButtonTypeCustom] init];
	self.overlayView.frame = CGRectMake(0, 0, 320, 480);
	self.overlayView.opaque = NO;
	self.overlayView.backgroundColor = [UIColor clearColor];
	self.overlayView.delegate = self;
	
	// Create the navigation bar
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	navBar.barStyle = UIBarStyleDefault;
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Pubs"];
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	navItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] init];
	listBarButtonItem.title = @"List";
	listBarButtonItem.target = self;
	listBarButtonItem.action = @selector(btnList_clicked:);
	navItem.rightBarButtonItem = listBarButtonItem;
	[listBarButtonItem release];
	
	
	[navBar pushNavigationItem:navItem animated:NO];
	[self.overlayView insertSubview:navBar atIndex:11];
	
	
	
	//Create the required pub 'cards'
	[self.overlayView createPubCards:self.dataSource];
	
	/*
	NSLog(@"Creating pub cards");
	self.cardSource = [[NSMutableArray alloc] init];
	int i = 0;
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	for(Pub *pub in self.dataSource) {
		PubCard *card =  [[PubCard alloc] initWithPub:pub];
		[card setPosition:-500 y:-500];
		card.visible = FALSE;
		[card setHeading:-1];
		
		// Get our distance from the pub
		CLLocation *myPubLocation = [[CLLocation alloc] initWithLatitude:[[pub latitude] floatValue] longitude:[[pub longitude] floatValue]];		
		double distance = [ct fetchDistance:self.userLocation locationB:myPubLocation];
		[card setDistance:distance];
		
		card.delegate = self;
		[self.overlayView insertSubview:card atIndex:i];
		[self.cardSource addObject:card];
		i++;
	}
	
	NSLog(@"Pub cards created");
	//[mutableFetchResults release];
	//[request release];
	*/
	
	in3DView = TRUE;
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchHeading];
	
	// test stuff
	self.previousDate = [NSDate date];
	NSLog(@"%@", self.previousDate);
	self.nrReadings = 0;
	self.averageX = 0;
	self.averageZ = 0;
	self.velX = 0;
	self.distX = 0;
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		self.picker = [[UIImagePickerController alloc] init];
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		self.picker.showsCameraControls = NO;
		self.picker.cameraOverlayView = self.overlayView;
		CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.0, 1.132);
		self.picker.cameraViewTransform = cameraTransform;
		self.picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[self presentModalViewController:self.picker animated:YES];
		
		// Enable the accelerometer
		UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
		accel.delegate = self;
		accel.updateInterval = 1.0f/20.0f;
		
	} else {
		NSLog(@"error with picker");
		self.picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this feature."
														   delegate:self
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
		
		[alertView show];
		[alertView release];
		
		[self hide3DList];
	}
	
	NSLog(@"end 3d view did load");
	
}

- (void)hide3DList {

	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	ct.delegate = self;
	[ct fetchUserLocation];
	NSLog(@"HIDE3DLIST");
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = nil;
	
	[self dismissModalViewControllerAnimated:YES];
	
	in3DView = FALSE;
}

- (void)headingUpdated:(CoordinatesTool *)sender {
	[self.overlayView updateCards];
}

- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)acceleration {
	//NSLog([[NSString alloc] initWithFormat:@"x: %g\ty:%g\tz:%g", acceleration.x, acceleration.y, acceleration.z]);
	
	
	if ((acceleration.x >= 0.7 && acceleration.x <= 1.0) || (acceleration.x <= -0.7 && acceleration.x >= -1.0)) {
		//[self.overlayView setLandscapeMode];
	} else {
		//[self.overlayView setPortraitMode];
	}
	
	self.averageX += acceleration.x;
	self.averageZ += acceleration.z;
	self.nrReadings += 1;
	
	/*
	NSTimeInterval interval = 0;
	NSDate *currentDate = [NSDate date];
	if (self.previousDate != nil) {
		interval = [currentDate timeIntervalSinceDate:self.previousDate];
	}
	self.previousDate = currentDate;
	*/
	
	//NSLog(@"readings: %f", self.nrReadings);
	//NSLog(@"averageZ: %f", self.averageZ);
	if(nrReadings >= 10) {
		//float avgAccelerationX = self.averageX / self.nrReadings;
		float avgAccelerationZ = self.averageZ / self.nrReadings;

		//NSLog(@"AvgAccelerationX: %f", avgAccelerationX);
		//NSLog(@"AvgAccelerationZ: %f", avgAccelerationZ);

		
		//float angle = atan2(acceleration.x, -acceleration.y);
		//NSLog(@"ANGLE: %f", angle);
		//[self.overlayView updateRotation:(-angle *(180/M_PI))];
		//[self.overlayView updateRotation:(-angle)];
		//[self.overlayView updateRotation:-(avgAccelerationX * 1.57079633)];
		
		
		
		[self.overlayView updateHorizon:(avgAccelerationZ * 250)];
		[self.overlayView updateCards];
		
		self.averageX = 0;
		self.averageZ = 0;
		self.nrReadings = 0;
	}
	
	/*
	if (acceleration.z >= -0.2 && acceleration.z <= 0.2) {
		[self.overlayView updateHorizon:0];
	} else {file://localhost/Users/thesis/Desktop/TunifyIPhone/MainWindow.xib
		[self.overlayView updateHorizon:(acceleration.z * 250)];
	}
	 */
	
	/*
	if (acceleration.x >= -0.1 && acceleration.x <= 0.1) {
		[self.overlayView updateRotation:0];
	} else {
		[self.overlayView updateRotation:(-(acceleration.x * 1.57079633))];	
	}
	
	NSLog(@"Starting date stuff");
	NSTimeInterval interval = 0;
	NSLog(@"a");
	NSDate *currentDate = [NSDate date];
	NSLog(@"b");
	NSLog(@"%@", self.previousDate);
	if (self.previousDate != nil)
	{
		NSLog(@"c");
		interval = [currentDate timeIntervalSinceDate:self.previousDate];
	}
	NSLog(@"d");
	self.previousDate = currentDate;	
	
	velX += (acceleration.x * interval);
	distX += (velX * interval);
	//do other axis here too
	
	// setup for next UIAccelerometer event
	
	NSLog(@"VELOCITY X: %f", velX);
	NSLog(@"DISTANCE X: %f", distX);
	*/
}

// Override to allow orientations other than the default portrait orientation.
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	NSLog(@"rotating");
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	return YES;
}
 */

- (void)buttonDirectionClicked:(OverlayView *)sender {
	
	Pub *pub = sender.selectedPub;
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct stop];
	NSLog(@"Buttondirectionclicked");
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = nil;
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	// Add the pub to the recently visited pub list
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	[rv addPub:pub];
	
	worldViewController *controller = [[worldViewController alloc] initWithNibName:@"worldView" bundle:[NSBundle mainBundle]];
	controller.pub = pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}

-(void)buttonPlayMusicClicked:(OverlayView *)sender {
	
	//Pub *pub = sender.selectedPub;
	//Pub *pub = self.selectedPub;
	if (pubPlaying == TRUE) {
		// stop the music
		NSLog(@"Stopping the music in buttonPlayMusicClicked in pubListController");
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer stopTest];
		pubPlaying = FALSE;
	} else {
		// start the music
		NSLog(@"Starting the music in buttonPlayMusicClicked in pubListController");
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer playTest:@"song1"];
		pubPlaying = TRUE;
	}
}

- (void)dealloc {
	[overlayView release];
	[picker release];
	[genre release];
	[dataSource release];
	[buttonPlaying release];
	[tableView release];
	[soapResults release];
	[xmlParser release];
	[webData release];
	[userLocation release];
	[previousDate release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

