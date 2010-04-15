//
//  pubList3DController.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pubList3DController.h"
#import "pubListController.h"
#import "genreViewController.h"

@implementation pubList3DController

@synthesize searchBar;
@synthesize genre;
@synthesize picker;
@synthesize overlayView;
@synthesize dataSource;
@synthesize ct;
@synthesize userLocation;
@synthesize lblCo;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	/*
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//overlayView.center = CGPointMake(160, 250);
	self.overlayView.opaque = YES;
	//overlayView.alpha = OVERLAY_ALPHA;
	*/
	//UIImageView *binocs = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binocs.png"]] autorelease];
	//binocs.tag = BINOCS_TAG;
	//[self.overlayView addSubview:binocs];
	/*
	UILabel* overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 40)];
	overlayLabel.text = @"De Werf";
	overlayLabel.textAlignment = UITextAlignmentLeft;
	overlayLabel.adjustsFontSizeToFitWidth = NO;
	overlayLabel.textColor = [UIColor whiteColor];
	overlayLabel.backgroundColor = [UIColor darkGrayColor];
	overlayLabel.shadowOffset = CGSizeMake(0, -1);  
	overlayLabel.shadowColor = [UIColor blackColor]; 
	
	[overlayView addSubview:overlayLabel];
	*/
	//self.view = self.overlayView;

}



- (IBAction)btnFilter_clicked:(id)sender {
	NSLog(@"Filter clicked");
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles:@"By genre",@"By song",@"By rating", @"By visitors",nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
    [popupQuery showInView:self.tabBarController.view];
    [popupQuery release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		// Sort by genre
		genreViewController *gvc = [[genreViewController alloc] initWithNibName:@"genreView" bundle:[NSBundle mainBundle]];
		gvc.sourceView = self;
		gvc.sourceId = 2;
		[self.navigationController pushViewController:gvc animated:YES];
		[gvc release];
		gvc = nil;
		
    } else if (buttonIndex == 1) {
		// Sort by song similarity
    } else if (buttonIndex == 2) {
		// Sort by rating
	} else if (buttonIndex == 3) {
		// Sort by visitors
	}
	
}

- (IBAction)btnList_clicked:(id)sender {
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	searchBar.showsCancelButton = YES;
	
	
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480);     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }

	
	self.navigationItem.title = @"Pubs";
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	self.navigationItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] init];
	listBarButtonItem.title = @"List";
	listBarButtonItem.target = self;
	listBarButtonItem.action = @selector(btnList_clicked:);
	self.navigationItem.rightBarButtonItem = listBarButtonItem;
	[listBarButtonItem release];
	
}

- (void)viewDidAppear:(BOOL)animated {
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.overlayView.opaque = YES;
	
	
	
	// Fetch our discovered pubs from Core Data
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pub" inManagedObjectContext:managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		NSLog(@"Can’t load the Pub data!"); 
	} 
	
	self.dataSource = [[NSMutableArray alloc] init];		
	
	
	
	
	lblCo = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 25)];
	lblCo.text = @"";
	lblCo.textAlignment = UITextAlignmentLeft;
	lblCo.font = [UIFont systemFontOfSize:14];
	lblCo.adjustsFontSizeToFitWidth = NO;
	lblCo.textColor = [UIColor blackColor];
	lblCo.backgroundColor = [UIColor lightGrayColor];
	[self.overlayView insertSubview:lblCo atIndex:10];
	
	
	//Create the required pub 'cards'
	int i = 0;
	for(Pub *pub in mutableFetchResults) {
		//if([pub.name isEqualToString:@"Cafe de Zappa"]) {
			PubCard *card =  [[PubCard alloc] initWithPub:pub];
			[card setPosition:-500 y:-500];
			card.visible = FALSE;
			[self.overlayView insertSubview:card atIndex:i];
			[self.dataSource addObject:card];
			i++;
			//heading = [self calculatePubHeading:pub];
			//NSLog(@"Pub: %@, Heading: %f", [pub name], heading);
		//}
	}
	
	
	[mutableFetchResults release];
	[request release];
	
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		self.picker = [[CustomUIImagePickerController alloc] init];
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		self.picker.showsCameraControls = NO;
		self.picker.cameraOverlayView = self.overlayView;
		CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.0, 1.132);
		self.picker.cameraViewTransform = cameraTransform;
		self.picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[self presentModalViewController:self.picker animated:YES];
		
	} else {
		NSLog(@"error with picker");
		self.picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this application."
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
		[alertView release];
	}
	
	NSLog(@"end 3d view did load");
	
	// Enable the accelerometer
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 1.0f/20.0f;
	
	ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchHeading];
	
	//timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCards) userInfo:nil repeats: YES];
}



- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
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

- (void)updateCards {
	NSLog(@"Our heading: %f", [ct getHeading]);
	
	NSArray *yValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:250],[NSNumber numberWithInt:150],[NSNumber numberWithInt:350],[NSNumber numberWithInt:50],nil]; 
	int cardScreenIndex = 0;
	int validIntervalInDegrees = 80;
	for(PubCard *pubCard in self.dataSource) {
		
		float heading = [self calculatePubHeading:[pubCard pub]];
		float newHeading = heading - [ct getHeading];
		
		BOOL isValidHeading = FALSE;
		if(heading < 40) {
			if((360 - [ct getHeading]) <= heading) {
				isValidHeading = TRUE;
			}
		} else if (heading > 320) {
			if(((360 - heading) + [ct getHeading]) <= 40) {
				isValidHeading = TRUE;
			}
		}
		
		if( ((newHeading <= validIntervalInDegrees/2) && (newHeading >= -(validIntervalInDegrees/2))) || (isValidHeading == TRUE)) {
			NSLog(@"Card heading: %f", heading);
			NSLog(@"new Heading: %f", newHeading);
			int localHeadingOffset = 0;
			if (newHeading < 0) {
				localHeadingOffset = validIntervalInDegrees/2 - (newHeading * -1);
			} else {
				localHeadingOffset = newHeading + validIntervalInDegrees/2;
			}
			NSLog(@"LOCALHEADINGOFFSET: %d", localHeadingOffset);
			// iphone width = 320 px;
			// card width = 200 px;
			// width of each degree on screen = 520/(validIntervalInDegrees)
			
			// Show the pub
			NSLog(@"VALID INTERVAL");
			pubCard.visible = TRUE;
			[pubCard setPosition:(localHeadingOffset*6.5 - 100) y:[[yValues objectAtIndex:cardScreenIndex] floatValue]];
			cardScreenIndex++;
			//NOTE: When we have more than 4 pubs on the screen, the yValues array will run out of bounds.
			
			
		} else {
			if(pubCard.visible == TRUE) {
				[pubCard setPosition:-500 y:-500];
			}
			pubCard.visible = FALSE;
			
		}
	}
	
	[yValues release];
}

- (void)headingUpdated:(CoordinatesTool *)sender {
	[self updateCards];
	lblCo.text = [NSString stringWithFormat:@"%f", [ct getHeading]];
	
}

- (float)calculatePubHeading:(Pub *)pub {
	float u2 = userLocation.coordinate.latitude;					//Our position.
	float u1 = userLocation.coordinate.longitude;
	u2 = 50.8728119;
	u1 = 4.6644344;
	float v2 = [[pub latitude] floatValue];		
	float v1 = [[pub longitude] floatValue];
	NSLog(@"u1: %f, u2: %f, v1: %f, v2: %f", u1, u2, v1, v2);
	float result;						//The resulting bearing.
	
	
	// Base vector
	float b1 = 0;
	float b2 = 1;
	
	// Normalize V
	float normV1 = v1 - u1;
	float normV2 = v2 - u2;	
	
	// Calculate the angle between the base vector (pointing north) and the pub location
	//float uv = (normalizedX2*bx) + (normalizedY2*by);
	float uv = (b1*normV1) + (b2*normV2);
	//NSLog(@"uv: %f", uv);
	float normU = sqrt(b1*b1 + b2*b2);
	//NSLog(@"normU: %f", normU);
	float normV = sqrt(normV1*normV1 + normV2*normV2);
	//NSLog(@"normV: %f", normV);
	float normMultiplication = normU * normV;
	//NSLog(@"normMultiplication: %f", normMultiplication);
	float division = uv/normMultiplication;
	//NSLog(@"division: %f", division);
	float resultRad = acos(division);
	//NSLog(@"resultRad: %f", resultRad);
	float resultDeg = resultRad * (180/M_PI);
	//NSLog(@"resultDeg: %f", resultDeg);
	
	// If our pub's longitude is smaller than the users, then the angle will be larger than 180 degrees.
	// However, the above method only returns angles smaller than or equal to 180, so we'll need to fix this ourselves.
	if (v1 < u1) {
		resultDeg = (180 - resultDeg) + 180;
	} 
	
	return resultDeg;
}


- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)acceleration {
	//NSLog([[NSString alloc] initWithFormat:@"x: %g\ty:%g\tz:%g", acceleration.x, acceleration.y, acceleration.z]);
	
	
	if (fabsf(acceleration.x) > 1.5 || fabsf(acceleration.y) > 1.5 || fabsf(acceleration.z) > 1.5)
	{
		//NSLog([[NSString alloc] initWithFormat:@"x: %g\ty:%g\tz:%g", acceleration.x, acceleration.y, acceleration.z]);
	}
	
}

/*
-(void)renderCards {
	for(PubCard *pubCard in self.dataSource) {
		if(pubCard.visible == TRUE) {
			
			[pubCard setPosition:0 y:200];
			[self.overlayView insertSubview:pubCard atIndex:0];
			
		}
	}
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
	NSLog(@"Memory warning received");
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
	//theSearchBar = YES;
	
	// only show the status bar’s cancel button while in edit mode
	theSearchBar.showsCancelButton = YES;
	theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
	theSearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	/*
	[tableData removeAllObjects]; // remove all data that belongs to previous search
	if([searchText isEqualToString:@""]) {
		searching = NO;
		searchText==nil;
	} else { 
		searching = YES;
		[tableView reloadData];
		return;
	}
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(r.length > 0) {
			//[tableData addObject:name];
		}
		counter++;
		[pool release];
	}
	*/
	//[tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	//[tableData removeAllObjects];
	//[tableData addObjectsFromArray:dataSource];
	@try{
		//[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[theSearchBar resignFirstResponder];
	theSearchBar.text = @"";
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	searching = NO;
	[theSearchBar resignFirstResponder];
}


- (void)dealloc {
	[lblCo release];
	[genre release];
	[searchBar release];
	[overlayView release];
	[picker release];
	[userLocation release];
	[ct release];
	[dataSource release];
	[super dealloc];
}


@end
