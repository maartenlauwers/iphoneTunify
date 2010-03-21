//
//  rateViewController.m
//  TunifyIPhone
//
//  Created by thesis on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "rateViewController.h"


@implementation rateViewController

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
	UIView *rateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
	rateView.opaque = YES;
	//self.overlayView.alpha = OVERLAY_ALPHA;
	
	//UIImageView *binocs = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binocs.png"]] autorelease];
	//binocs.tag = BINOCS_TAG;
	//[self.overlayView addSubview:binocs];
	
	UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
	rateLabel.text = @"Rate 'De Werf'";
	rateLabel.textAlignment = UITextAlignmentCenter;
	rateLabel.adjustsFontSizeToFitWidth = NO;
	rateLabel.textColor = [UIColor blackColor];
	rateLabel.backgroundColor = [UIColor whiteColor];
	
	
	[rateView addSubview:rateLabel];
	
	self.view = rateView;
}


-(IBAction) cancelButton_clicked:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"-- I AM TOUCHED --");
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
    [super dealloc];
}


@end
