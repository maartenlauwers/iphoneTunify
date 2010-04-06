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
@synthesize rowPlayingIndexPath;
@synthesize userLocation;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (IBAction)btnFilter_clicked:(id)sender {
	
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
		gvc.sourceId = 1;
		[self.navigationController pushViewController:gvc animated:YES];
		[gvc release];
		gvc = nil;
		
    } else if (buttonIndex == 1) {
		// Sort by song similarity
    } else if (buttonIndex == 2) {
		
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		
		for(NSArray *pub in dataSource) {
			NSLog(@"Pub name: %@", [pub objectAtIndex:0]);
			
			// Initial entry
			if ([sortedArray count] == 0) {
				[sortedArray addObject:pub];
			} else {
				// Further entries
				if ([[pub objectAtIndex:6] intValue] <= [[[sortedArray lastObject] objectAtIndex:6] intValue]) {
					[sortedArray addObject:pub];
				} else if ([[pub objectAtIndex:6] intValue] >= [[[sortedArray objectAtIndex:0] objectAtIndex:6] intValue]) {
					[sortedArray insertObject:pub atIndex:0];
				} else {
					for(int i=1; i<[sortedArray count]-1; i++) {
						if ([[pub objectAtIndex:6] intValue] == [[[sortedArray objectAtIndex:i] objectAtIndex:6] intValue]) {
							[sortedArray insertObject:pub atIndex:i];
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
		// Sort by visitors
	}
}

- (IBAction)btnLookAround_clicked:(id)sender {
	pubList3DController *controller = [[pubList3DController alloc] initWithNibName:@"pubList3D" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (void) pubCell_clicked:(id)sender row:(NSInteger *)theRow {
	
	NSArray *pub = [dataSource objectAtIndex:theRow];
	
	// Add the pub to the recently visited pub list
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	[rv addPub:pub];
	
	mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
	controller.strPubName = [pub objectAtIndex:0];
	
	NSString *address = [NSString stringWithFormat:@"%@ %@, %@ %@", [pub objectAtIndex:1], [pub objectAtIndex:2], [pub objectAtIndex:3], [pub objectAtIndex:4]];
	controller.strPubAddress = address;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}

- (IBAction) searchFieldDoneEditing:(id)sender {
	NSLog(@"Searching");
}

- (void) playMusic:(id)sender {

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
	[theplayer release]; 
} 

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
	
	
	// Create some test data for the table
	dataSource = [[NSMutableArray alloc] init];

	NSArray *pub1 = [[NSArray alloc] initWithObjects:@"De zoete bron", @"M.Noestraat", 	@"15", @"3050", @"oud heverlee", @"418090", @"4", @"50.8236691", @"4.6626304", nil];
	NSArray *pub2 = [[NSArray alloc] initWithObjects:@"Fitforyou", @"Mechelsesteenweg", @"763", @"3020", @"Herent", @"418012", @"3",@"50.9204853", @"4.6479286", nil];
	NSArray *pub3 = [[NSArray alloc] initWithObjects:@"Cafe Mezza", @"Mathieu de Layensplein", @"119", @"3000", @"Leuven", @"416197", @"5",@"50.8799430", @"4.7002825", nil];
	NSArray *pub4 = [[NSArray alloc] initWithObjects:@"Linx", @"Vismarkt", 	@"17", @"3000", @"Leuven", @"416665", @"1", @"50.8817091", @"4.6998039",nil];
	NSArray *pub5 = [[NSArray alloc] initWithObjects:@"Mundo", @"Martelarenplein", @"14", @"3000", @"Leuven", @"418090", @"0", @"50.8814212", @"4.7145274",nil];
	NSArray *pub6 = [[NSArray alloc] initWithObjects:@"Mephisto", @"Oude Markt", @"2", @"3000", @"Leuven", @"315056", @"2", @"50.8783624", @"4.6996464",nil];
	NSArray *pub7 = [[NSArray alloc] initWithObjects:@"Cafe de Zappa", @"Emile Carelsstraat", @"1", @"3090", @"Overijse", @"413875", @"3",@"50.7709673", @"4.5401609", nil];
	
	[dataSource addObject:pub1];
	[dataSource addObject:pub2];
	[dataSource addObject:pub3];
	[dataSource addObject:pub4];
	[dataSource addObject:pub5];
	[dataSource addObject:pub6];
	[dataSource addObject:pub7];

	tableData = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	[tableData addObjectsFromArray:dataSource];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	
	[self tunify_login];
	
	self.rowPlayingIndexPath = nil;
	
	//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
	
}

- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	[tableView reloadData];
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
	} else if ([elementName isEqualToString:@"ns1:loginUserResponse"]) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (self.genre != nil) {
		NSLog(self.genre);
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
	return [tableData count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    static NSString *CellIdentifier = @"Cell";
	
	pubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[pubCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

	NSArray *pub = [tableData objectAtIndex:indexPath.row];
	cell.nameLabel.text = [pub objectAtIndex:0];
	
	
	if (self.userLocation != nil) {
		CLLocationDegrees longitude= [[pub objectAtIndex:8] doubleValue];
		CLLocationDegrees latitude = [[pub objectAtIndex:7] doubleValue];
		CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation];
		[pubLocation release];
		NSString *strDistance = [NSString stringWithFormat:@"%f", distance/1000];
		NSRange commaRange = [strDistance rangeOfString:@"."];
		strDistance = [strDistance substringToIndex:commaRange.location + 2];
		cell.distanceLabel.text = [NSString stringWithFormat:@"%@ km", strDistance];
	} else {
		cell.distanceLabel.text = @"Distance unknown";
	}
	
	cell.ratingLabel.text = @"Rating:";
	[cell.stars setRating:[[pub objectAtIndex:6] intValue]];
		
	[cell.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	[cell.playButton addTarget:self	action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.playButton.indexPath = indexPath;
	
    return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self pubCell_clicked:tableView row:indexPath.row];
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
	for(NSArray *pub in dataSource) 
	{
		NSString *name = [pub objectAtIndex:0];
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


- (void)dealloc {
	[genre release];
	[rowPlayingIndexPath release];
	[dataSource release];
	[tableView release];
	[soapResults release];
	[xmlParser release];
	[webData release];
	[userLocation release];
    [super dealloc];
}


@end

