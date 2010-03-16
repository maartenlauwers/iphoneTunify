//
//  facebookController.m
//  TunifyIPhone
//
//  Created by thesis on 25/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "facebookController.h"


@implementation facebookController

@synthesize strPubName;
@synthesize facebookMessageView;
@synthesize fbSession;

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) 
	{ 
		[self.navigationController popViewControllerAnimated:YES];
	}
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

- (void)postToFacebook {
	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Share your visit";
	dialog.attachment = @"{\"name\":\"Facebook Connect for iPhone\","
	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\","
	"\"caption\":\"Caption\",\"description\":\"Description\","
	"\"media\":[{\"type\":\"image\","
	"\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\","
	"\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}],"
	"\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}";
	[dialog show];
	[self showSuccess];
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  
	
	if ([text isEqualToString:@"\n"]) {  
		[textView resignFirstResponder];  
		[self postToFacebook];
		return NO;
	}
	
	return YES;
} 


-(void) btnCancel_clicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = strPubName;
	
	// Create the left bar button item
	UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] init];
	cancelBarButtonItem.title = @"Cancel";
	cancelBarButtonItem.target = self;
	cancelBarButtonItem.action = @selector(btnCancel_clicked:);
	self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
	[cancelBarButtonItem release];
	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Share your visit";
	dialog.attachment =  @"";
	[dialog show];
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
	[facebookMessageView release];
    [super dealloc];
}


@end
