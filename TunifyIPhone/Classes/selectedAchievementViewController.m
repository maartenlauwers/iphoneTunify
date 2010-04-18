//
//  selectedAchievementViewController.m
//  TunifyIPhone
//
//  Created by thesis on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "selectedAchievementViewController.h"
#import "achievementsController.h"
#import "twitterController.h"
#import "facebookController.h"

@implementation selectedAchievementViewController

@synthesize achievementName;
@synthesize achievementDescription;
@synthesize achievementNumber;
@synthesize achieved;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize statusLabel;
@synthesize dateLabel;
@synthesize locationLabel;
@synthesize twitterButton;
@synthesize facebookButton;

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

/*
 Share on Twitter
 */
- (IBAction) btnTwitter_clicked:(id)sender {
	if (self.achieved == TRUE) {
		twitterController *controller = [[twitterController alloc] initWithNibName:@"twitterMessageView" bundle:[NSBundle mainBundle]];
		controller.strAchievementName = self.achievementName;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		controller = nil;
	}
}

/*
 Share on Facebook
 
 This method will create a working session for the user and will show the login dialog.
 */
- (IBAction) btnFacebook_clicked:(id)sender {
	if (self.achieved == TRUE) {
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
}

/*
 This method is called upon a successful facebook login.
 */
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	
	[self postToFacebook];
}

- (void)postToFacebook {
	NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"Achievement reached!\","
							"\"href\":\"#\","
							"\"caption\":\"%@\",\"description\":\"%@\","
							"\"media\":[{\"type\":\"image\","
							"\"src\":\"%@\","
							"\"href\":\"http://www.tunify.com\"}],"
							"\"properties\":{\"Download at\":{\"text\":\"Tunify.com\",\"href\":\"http://www.tunify.com\"}}}", self.achievementName, self.achievementDescription, 
							[NSString stringWithFormat:@"http://dl.dropbox.com/u/964150/tunifyIphoneIcons/achievement%d.png", self.achievementNumber]];
	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Share your achievement";
	dialog.attachment = attachment;
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
														message:NSLocalizedString(@"Your achievement has been published.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	[alertView show]; 
}

- (void)btnAchievements_clicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Achievements";
	
	// Create the left bar button item
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
	backBarButtonItem.title = @"Back";
	backBarButtonItem.target = self;
	backBarButtonItem.action = @selector(btnAchievements_clicked:);
	self.navigationItem.leftBarButtonItem = backBarButtonItem;
	[backBarButtonItem release];
	
	
	self.achievementNumber += 1;
	titleLabel.text = self.achievementName;
	descriptionLabel.text = self.achievementDescription;
	
	if (self.achieved == TRUE) {
		statusLabel.text = @"Status: Achieved";
		dateLabel.text = @"Achieved at: March 11, 2010";
		locationLabel.text = @"Location: De Werf";
	} else {
		statusLabel.text = @"Status: Not achieved";
		dateLabel.text = @"Achieved at: Unknown";
		locationLabel.text = @"Location: Unknown";
	}
	

	UIImageView *imageView;
	if (self.achieved == TRUE) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"achievement" stringByAppendingString:[NSString stringWithFormat:@"%d.png", self.achievementNumber]]]];
		[twitterButton setImage:[UIImage imageNamed:@"twitter_icon.png"] forState:UIControlStateNormal];
		[facebookButton setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
	} else {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"achievement" stringByAppendingString:[NSString stringWithFormat:@"%d_disabled.png", self.achievementNumber]]]];
		[twitterButton setImage:[UIImage imageNamed:@"twitter_icon_disabled.png"] forState:UIControlStateNormal];
		[facebookButton setImage:[UIImage imageNamed:@"facebook_icon_disabled.png"] forState:UIControlStateNormal];
	}
	
	[imageView setFrame:CGRectMake(130, 55, 60, 60)];
	[self.view addSubview:imageView];
	[imageView release];
}


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
	[achievementName release];
	[achievementDescription release];
	[titleLabel release];
	[descriptionLabel release];
	[statusLabel release];
	[dateLabel release];
	[locationLabel release];
	[twitterButton release];
	[facebookButton release];
    [super dealloc];
}


@end
