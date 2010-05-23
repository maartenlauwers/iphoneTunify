//
//  pubVisitViewController.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pubVisitViewController.h"
#import "twitterController.h"
#import "facebookController.h"
#import "rateViewController.h"
#import "musicViewController.h"

#define STAR_TOUCHED = @"28-star.png";
#define STAR_NOT_TOUCHED = @"28-star_light.png";

@implementation pubVisitViewController
@synthesize pub;
@synthesize dataSource;
@synthesize achievementLabel;
@synthesize achievementNameLabel;
@synthesize achievementReached;
@synthesize friendsLabel;
@synthesize shareLabel;
@synthesize twitterButton;
@synthesize facebookButton;
@synthesize achievementButton;
@synthesize friendsImage;
@synthesize tableView;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize rateView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) inviteButton_clicked:(id)sender {
	
	//CellButton *button = (UIButton *)sender;
	
}

- (void) achievementsButton_clicked:(id)sender {
	
	//CellButton *button = (UIButton *)sender;
	
}

- (void) achievementButton_clicked:(id)sender {
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];

	controller.achievement = achievementReached;
	//controller.achievementName = achievementReached.name;
	//controller.achievementDescription = achievementReached.description;
	//controller.achievementNumber = achievementNumber;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (IBAction) btnMusic_clicked:(id)sender {
	musicViewController *controller = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	controller.pub = self.pub;
	controller.source = 1;
	
	/*
	UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:controller]; 
	newNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:newNavigationController animated:YES]; 
	[newNavigationController release]; 
	*/
	//mvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//[self.navigationController presentModalViewController:mvc animated:YES];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (void) btnPubs_clicked:(id)sender {
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	
	NSLog(@"Jumping back to pubs");
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) doneRating:(id)sender {
	NSLog(@"Rating done clicked:");
	int rating = 0;
	if (self.star5.touched == TRUE) {
		rating = 5;
	} else if (self.star4.touched == TRUE) {
		rating = 4;
	} else if (self.star3.touched == TRUE) {
		rating = 3;
	} else if (self.star2.touched == TRUE) {
		rating = 2;
	} else if (self.star1.touched == TRUE) {
		rating = 1;
	}
	NSLog(@"Rating: %d", rating);
	
	self.rateView.hidden = TRUE;
}

- (void) btnRate_clicked:(id)sender {
	NSLog(@"Rate button clicked");
	
	//rateViewController *controller = [[rateViewController alloc] initWithNibName:@"rateView" bundle:[NSBundle mainBundle]];
	//rateViewController *controller = [[rateViewController alloc] init];
	//controller.delegate = self;
	//[self presentModalViewController:controller animated:YES];
	
	rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
	rateView.center = CGPointMake(160, 170);
	rateView.backgroundColor = [UIColor whiteColor];
	rateView.opaque = NO;
	rateView.alpha = 0.95f;
	
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,300,140)];
	backgroundImage.image = [UIImage imageNamed:@"rate_background.png"];
	[rateView addSubview:backgroundImage];
	[backgroundImage release];
	
	UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
	rateLabel.text = [[@"Rate '" stringByAppendingString:[self.pub name]] stringByAppendingString:@"'"];
	rateLabel.textAlignment = UITextAlignmentCenter;
	rateLabel.adjustsFontSizeToFitWidth = NO;
	rateLabel.textColor = [UIColor blackColor];
	rateLabel.backgroundColor = [UIColor whiteColor];
	
	star1 = [[RateStar alloc] initWithFrame:CGRectMake(50, 50, 28, 28)];
	star1.image = [UIImage imageNamed:@"star_light.png"];
	star1.number = 1;
	star1.delegate = self;
	[rateView addSubview:star1];
	
	star2 = [[RateStar alloc] initWithFrame:CGRectMake(90, 50, 28, 28)];
	star2.image = [UIImage imageNamed:@"star_light.png"];
	star2.number = 2;
	star2.delegate = self;
	[rateView addSubview:star2];

	
	star3 = [[RateStar alloc] initWithFrame:CGRectMake(130, 50, 28, 28)];
	star3.image = [UIImage imageNamed:@"star_light.png"];
	star3.number = 3;
	star3.delegate = self;
	[rateView addSubview:star3];

	
	star4 = [[RateStar alloc] initWithFrame:CGRectMake(170, 50, 28, 28)];
	star4.image = [UIImage imageNamed:@"star_light.png"];
	star4.number = 4;
	star4.delegate = self;
	[rateView addSubview:star4];

	
	star5 = [[RateStar alloc] initWithFrame:CGRectMake(210, 50, 28, 28)];
	star5.image = [UIImage imageNamed:@"star_light.png"];
	star5.number = 5;
	star5.delegate = self;
	[rateView addSubview:star5];
	
	
	UIButton *doneButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	doneButton.frame = CGRectMake(100, 95, 100, 30);
	doneButton.titleLabel.textAlignment = UITextAlignmentCenter;
	doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[doneButton setTitle:@"Done" forState:UIControlStateNormal];	
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[doneButton setTitle:@"Done" forState:UIControlStateHighlighted];
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[doneButton addTarget:self action:@selector(doneRating:) forControlEvents:UIControlEventTouchUpInside];
	[rateView addSubview:doneButton];
	
	[rateView addSubview:rateLabel];
	
	[self.view addSubview:rateView];
	
}

- (void)starTouched:(RateStar *)sender {
	NSInteger number = sender.number;
	NSLog(@"Star clicked: %d", number);
	if (number == 1) {
		if (sender.touched == FALSE) {
			[sender setTouchedImage:TRUE];
		} else {
			if (self.star2.touched == FALSE) {
				[sender setTouchedImage:FALSE];
				[self.star2 setTouchedImage:FALSE];
				[self.star3 setTouchedImage:FALSE];
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			} else {
				[self.star2 setTouchedImage:FALSE];
				[self.star3 setTouchedImage:FALSE];
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			}
			
		}
		
	} else if (number == 2) {
		if (sender.touched == FALSE) {
			[sender setTouchedImage:TRUE];
			[self.star1 setTouchedImage:TRUE];
		} else {
			if (self.star3.touched == FALSE) {
				[sender setTouchedImage:FALSE];
				[self.star1 setTouchedImage:FALSE];
				[self.star3 setTouchedImage:FALSE];
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			} else {
				[self.star3 setTouchedImage:FALSE];
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			}
			
		}
		
	} else if (number == 3) {
		if (sender.touched == FALSE) {
			[sender setTouchedImage:TRUE];
			[self.star1 setTouchedImage:TRUE];
			[self.star2 setTouchedImage:TRUE];
		} else {
			if (self.star4.touched == FALSE) {
				[sender setTouchedImage:FALSE];
				[self.star1 setTouchedImage:FALSE];
				[self.star2 setTouchedImage:FALSE];
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			} else {
				[self.star4 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			}
			
		}

	} else if (number == 4) {
		if (sender.touched == FALSE) {
			[sender setTouchedImage:TRUE];
			[self.star1 setTouchedImage:TRUE];
			[self.star2 setTouchedImage:TRUE];
			[self.star3 setTouchedImage:TRUE];
		} else {
			if (self.star5.touched == FALSE) {
				[sender setTouchedImage:FALSE];
				[self.star1 setTouchedImage:FALSE];
				[self.star2 setTouchedImage:FALSE];
				[self.star3 setTouchedImage:FALSE];
				[self.star5 setTouchedImage:FALSE];
			} else {
				[self.star5 setTouchedImage:FALSE];
			}
		}
		
	} else if (number == 5) {
		if (sender.touched == FALSE) {
			[sender setTouchedImage:TRUE];
			[self.star1 setTouchedImage:TRUE];
			[self.star2 setTouchedImage:TRUE];
			[self.star3 setTouchedImage:TRUE];
			[self.star4 setTouchedImage:TRUE];
		} else {
			[sender setTouchedImage:FALSE];
			[self.star1 setTouchedImage:FALSE];
			[self.star2 setTouchedImage:FALSE];
			[self.star3 setTouchedImage:FALSE];
			[self.star4 setTouchedImage:FALSE];
		}
		
	}

}

/*
	Share on Twitter
*/
- (IBAction) btnTwitter_clicked:(id)sender {
	twitterController *controller = [[twitterController alloc] initWithNibName:@"twitterMessageView" bundle:[NSBundle mainBundle]];
	controller.pub = self.pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

/*
	Share on Facebook
 
	This method will create a working session for the user and will show the login dialog.
 */
- (IBAction) btnFacebook_clicked:(id)sender {	
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	FBSession *session = appDelegate.fbSession;	
	session = [[FBSession sessionForApplication:@"cb12aa127decea40af4479de16b4e9c1" secret:@"47d30f1b4e2d78c4941cd5baea1bfb14" delegate:self] retain];
	
	if ([session isConnected]) {
		[self postToFacebook];
	} else {
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:session] autorelease]; 
		[dialog show];
	}
	
}

/*
	This method is called upon a successful facebook login.
 */
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	[self postToFacebook];
}

- (void)postToFacebook { 
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Share your visit";
	dialog.attachment = @"";
	
	[dialog show];
}

/*
	This method is called upon a successful facebook publish.
 */
- (void)dialogDidSucceed:(FBDialog*)dialog {
	[self showSuccess];
}

/*
	This method is called when the user cancels the facebook publish dialog.
 */
- (void)dialogDidCancel:(FBDialog*)dialog {
	NSLog(@"Cancelled");
}


- (void)showSuccess {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",@"title") 
														message:NSLocalizedString(@"Your visit has been published.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	[alertView show]; 
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"VISIT VIEW DID LOAD");
	self.navigationItem.title = [self.pub name];
	
	// Create the left bar button item
	UIBarButtonItem *pubsBarButtonItem = [[UIBarButtonItem alloc] init];
	pubsBarButtonItem.title = @"Pubs";
	pubsBarButtonItem.target = self;
	pubsBarButtonItem.action = @selector(btnPubs_clicked:);
	self.navigationItem.leftBarButtonItem = pubsBarButtonItem;
	[pubsBarButtonItem release];
	
	
	
	// create a toolbar where we can place some buttons
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 120, 45)];
	[toolbar setBarStyle:UIBarStyleDefault];
	
	// create an array for the buttons
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
	
	// create a standard save button
	UIBarButtonItem *musicButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Music" style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(btnMusic_clicked:)];
	musicButton.style = UIBarButtonItemStyleBordered;
	[buttons addObject:musicButton];
	[musicButton release];
	
	// create a spacer between the buttons
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
							   target:nil
							   action:nil];
	[buttons addObject:spacer];
	[spacer release];
	
	// create a standard delete button with the trash icon
	UIBarButtonItem *rateButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Rate" style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(btnRate_clicked:)];
	rateButton.style = UIBarButtonItemStyleBordered;
	[buttons addObject:rateButton];
	[rateButton release];
	
	// put the buttons in the toolbar and release them
	[toolbar setItems:buttons animated:NO];
	[buttons release];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
	
	
	// Check if any achievements were reached
	BOOL isAchievementReached = FALSE;
	
	// NOTE: Because this would require an active database with registered users of the application together with their achievements, we can't actually check
	// for achieved goals at this time. Instead, we check for a number of pseudo-achievements such as visiting a pub three times during the same session.
	
	// Update achievements (in this case, only the settler achievement)
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
		
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Might want to do something more serious... 
		NSLog(@"Can’t load the Pub data!"); 
	} 
	
	// Check for gained achievements (currently we only check for the settler achievement)
	for (Achievement *achievement in mutableFetchResults) {
		if ([achievement.name isEqualToString:@"Settler"]) {
			NSLog(@"Achievement completion: %@", [achievement completion]);
			if (([achievement.completion doubleValue] + 25) >= 100) {
				
				if ([achievement.completion doubleValue] < 100) {
					double completion = [achievement.completion doubleValue] + 25;
					[achievement setCompletion:[NSString stringWithFormat:@"%f", completion]];
					[achievement setLocation:pub.name];
					[achievement setDate:[[NSDate alloc] init]];
					NSError *error = nil;
					if (![managedObjectContext save:&error]) {
						NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
						abort();
					}
					
					isAchievementReached = TRUE;
					self.achievementReached = achievement;
					
				}
			} else {
				double completion = [achievement.completion doubleValue] + 25;
				[achievement setCompletion:[NSString stringWithFormat:@"%f", completion]];
				NSError *error = nil;
				if (![managedObjectContext save:&error]) {
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
					abort();
				}
				
			}	
			
		}
	}
	
	[mutableFetchResults release];
	[request release];
	
		
	//achievementReached = TRUE;
	// Layout the screen according to whether an achievement was reached
	if (isAchievementReached == TRUE) {
		
		// Set a badge
		TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate];
		UITabBar *tabBar = appDelegate.tabController.tabBar;
		UITabBarItem *achievementsTabItem = [tabBar.items objectAtIndex:2];
		achievementsTabItem.badgeValue = @"1";
		
		achievementLabel = [[UILabel alloc]init];
		achievementLabel.textAlignment = UITextAlignmentCenter;
		achievementLabel.font = [UIFont systemFontOfSize:16];
		achievementLabel.frame = CGRectMake(89, 30, 211, 21);
		achievementLabel.text = @"Achievement reached!";
		[self.view addSubview:achievementLabel];
		
		achievementNameLabel = [[UILabel alloc]init];
		achievementNameLabel.textAlignment = UITextAlignmentCenter;
		achievementNameLabel.font = [UIFont systemFontOfSize:16];
		achievementNameLabel.frame = CGRectMake(89, 51, 211, 21);
		achievementNameLabel.text = self.achievementReached.name;
		[self.view addSubview:achievementNameLabel];
		
		achievementButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[achievementButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.achievementReached.name]] forState:UIControlStateNormal];
		[achievementButton addTarget:self action:@selector(achievementButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
		achievementButton.frame = CGRectMake(20, 20, 64, 64);
		[self.view addSubview:achievementButton];
		
		self.friendsImage.frame = CGRectMake(0, 118, 36, 33);
		self.friendsLabel.frame = CGRectMake(40, 124, 64, 21);
		self.shareLabel.frame = CGRectMake(122, 124, 86, 21);
		self.twitterButton.frame = CGRectMake(216, 114, 36, 36);
		self.facebookButton.frame = CGRectMake(262, 114, 36, 36);
		self.tableView.frame = CGRectMake(0, 164, 320, 203);
	} else {
		self.friendsImage.frame = CGRectMake(0, 14, 36, 33);
		self.friendsLabel.frame = CGRectMake(40, 20, 64, 21);
		self.shareLabel.frame = CGRectMake(122, 20, 86, 21);
		self.twitterButton.frame = CGRectMake(216, 14, 36, 36);
		self.facebookButton.frame = CGRectMake(262, 14, 36, 36);
		self.tableView.frame = CGRectMake(0, 55, 320, 295);
	}
	
	// Fill our datasource with some friends
	self.dataSource = [[NSMutableArray alloc] init];
	[self.dataSource addObject:@"Hein Forcé"];
	[self.dataSource addObject:@"Glenn Verdru"];
	[self.dataSource addObject:@"Pieter De Rydt"];
	[self.dataSource addObject:@"Niels Schroyen"];
	
	[tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSLog(@"Cell for row at index path");
    static NSString *CellIdentifier = @"Cell";
	
	visitCell *cell = (visitCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[visitCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.friendLabel.text = [self.dataSource objectAtIndex:indexPath.row];
	
	[cell.inviteButton setImage:[UIImage imageNamed:@"beermug.png"] forState:UIControlStateNormal];
	[cell.inviteButton setImage:[UIImage imageNamed:@"beermug.png"] forState:UIControlStateHighlighted];
	[cell.inviteButton addTarget:self action:@selector(inviteButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
	cell.inviteButton.row = indexPath.row;
	
	[cell.achievementsButton setImage:[UIImage imageNamed:@"trophy.png"] forState:UIControlStateNormal];
	[cell.achievementsButton setImage:[UIImage imageNamed:@"trophy.png"] forState:UIControlStateHighlighted];
	[cell.achievementsButton addTarget:self action:@selector(achievementsButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
	cell.achievementsButton.row = indexPath.row;
	
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120;
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


- (void)dealloc {
	NSLog(@"ra");
	[pub release];
	[achievementLabel release];
	[achievementNameLabel release];
	[achievementButton release];
	[friendsLabel release];
	[friendsImage release];
	[shareLabel release];
	[twitterButton release];
	[facebookButton release];
	
	
	[rateView release];
	
	[achievementReached release];
	//[tableView release];
	NSLog(@"rb");
    [super dealloc];
}


@end
