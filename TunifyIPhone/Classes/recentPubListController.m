//
//  recentPubListController.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "recentPubListController.h"
#import "mapViewController.h"
#import "pubCell.h"
#import "CellButton.h"
#import "genreViewController.h"

@implementation recentPubListController

@synthesize genre;
@synthesize dataSource;
@synthesize tableView;
@synthesize rowPlayingIndexPath;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

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
		gvc.sourceId = 3;
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

- (void) playMusic:(id)sender {
	NSLog(@"Playing the sound of the pub");
	
	CellButton *button = (UIButton *)sender;
	
	if (self.rowPlayingIndexPath == nil ) {
		// Nothing is playing yet
		self.rowPlayingIndexPath = button.indexPath;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		
		NSError *error = nil; 
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Equus" ofType:@"mp3"]] error:&error]; 
		player.delegate = self; 
		if(error != NULL) { 
			NSLog([error description]);  
			[error release]; 
		} 
		
		[player play]; 
	} else {
		if (self.rowPlayingIndexPath.row == button.indexPath.row) {
			// Our current cell is playing
			self.rowPlayingIndexPath = nil;
			[button setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			[player stop];
			player.delegate = nil;
			[player release];
			
		} else {
			// Another cell is playing. We need to stop it and play our current one.
			[player stop];
			player.delegate = nil;
			[player release];
			
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.rowPlayingIndexPath];
			pubCell *c = (pubCell *)cell;
			[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			// Now update our current cell
			self.rowPlayingIndexPath = button.indexPath;
			[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
			
			NSError *error = nil; 
			player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Equus" ofType:@"mp3"]] error:&error]; 
			player.delegate = self; 
			if(error != NULL) { 
				NSLog([error description]);  
				[error release]; 
			} 
			
			[player play]; 
			
		}
	}
	
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)theplayer successfully:(BOOL)flag { 
	NSLog(@"Song played");
	[theplayer release]; 
} 

- (void) pubCell_clicked:(id)sender pubName:(NSString*)pubName {
	mapViewController *mvc = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
	mvc.strPubName = pubName;
	[self.navigationController pushViewController:mvc animated:YES];
	[mvc release];
	mvc = nil;
}
	
- (void)viewDidLoad {
    [super viewDidLoad];

	searchBar.showsCancelButton = YES;
	
	self.navigationItem.title = @"Recently visited";
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	self.navigationItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];
	
	
	// Create some test data for the table
	dataSource = [[NSMutableArray alloc] init];
	
	[dataSource addObject:@"De Werf"];
	[dataSource addObject:@"Plaza"];
	[dataSource addObject:@"De Moete"];
	
	tableData = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	[tableData addObjectsFromArray:dataSource];
	
	self.rowPlayingIndexPath = nil;
}


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
	return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
	
	pubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[pubCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
	cell.distanceLabel.text = @"801 meters east";
	cell.ratingLabel.text = @"Rating:";
		
	cell.star1.image = [UIImage imageNamed:@"28-star.png"];
	cell.star2.image = [UIImage imageNamed:@"28-star.png"];
	cell.star3.image = [UIImage imageNamed:@"28-star.png"];
	cell.star4.image = [UIImage imageNamed:@"28-star.png"];
	cell.star5.image = [UIImage imageNamed:@"28-star.png"];
		
	[cell.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	[cell.playButton addTarget:self	action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.playButton.indexPath = indexPath;
	
    return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *strPubName = [dataSource objectAtIndex:indexPath.row];
	[self pubCell_clicked:tableView pubName:strPubName];
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
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
	for(NSString *name in dataSource)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(r.location != NSNotFound)
		{
			[tableData addObject:name];
		}
		counter++;
		[pool release];
	}
	
	[tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:dataSource];
	@try{
		[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	[tableView reloadData];
	
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}


- (void)dealloc {
	[genre release];
	[rowPlayingIndexPath release];
	[dataSource release];
	[tableView release];
    [super dealloc];
}


@end

