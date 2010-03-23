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
@synthesize overlayView;
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
	
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//overlayView.center = CGPointMake(160, 250);
	self.overlayView.opaque = YES;
	//overlayView.alpha = OVERLAY_ALPHA;
	
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
	self.view = self.overlayView;

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
	
	
	//Create a number of test cards
	PubCard *card1 = [[PubCard alloc] initWithPub:@"De Werf" pubAddress:@"Tiensestraat 49 3000 Leuven" pubVisitors:45 pubRating:3];
	[card1 setPosition:300 y:100];
	
	PubCard *card2 = [[PubCard alloc] initWithPub:@"Passevit" pubAddress:@"Veurnestraat 123 8970 Poperinge" pubVisitors:12 pubRating:4];
	[card2 setPosition:100 y:300];
	
	
	/*
	UIView *card2 = [self createPubCard:@"De Kouter" pubAddress:@"Tervuursesteenweg 433 3001 Heverlee" pubVisitors:100 pubRating:4];
	UIView *card3 = [self createPubCard:@"Passevit" pubAddress:@"Veurnestraat 130 8970 Poperinge" pubVisitors:20 pubRating:2];
	*/
	[self.overlayView insertSubview:card1 atIndex:0];
	[self.overlayView insertSubview:card2 atIndex:1];
	//[self.overlayView insertSubview:card2 atIndex:1];
	//[self.overlayView insertSubview:card3 atIndex:2];
	
	
	//UIImagePickerController *picker;
	CustomUIImagePickerController *picker;
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		picker = [[CustomUIImagePickerController alloc] init];
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		picker.delegate = self;
		picker.allowsImageEditing = NO;
		picker.showsCameraControls = NO;
		
		[self presentModalViewController:picker animated:YES];
	}
	else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		
		picker = [[CustomUIImagePickerController alloc] init];
		//picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		
		picker.delegate = self;
		picker.allowsImageEditing = NO;
		[self presentModalViewController:picker animated:YES];
	}
	else {
		picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this application."
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
		[alertView release];
	}
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


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searching = YES;
	
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	//[tableData removeAllObjects];
	//[tableData addObjectsFromArray:dataSource];
	@try{
		//[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[searchBar resignFirstResponder];
	searchBar.text = @"";
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	searching = NO;
	[searchBar resignFirstResponder];
}


- (void)dealloc {
	[genre release];
	[searchBar release];
	[overlayView release];
	[super dealloc];
}


@end
