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


@synthesize fetchedResultsController;
@synthesize managedObjectContext;

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
					for(int i=1; i<[sortedArray count]-1; i++) {
						if ([[pub rating] intValue] == [[[sortedArray objectAtIndex:i] rating] intValue]) {
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
	
	Pub *pub = [dataSource objectAtIndex:theRow];
	
	// Add the pub to the recently visited pub list
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	[rv addPub:pub];
	
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

	CellButton *button = (UIButton *)sender;
	
	if (self.rowPlayingIndexPath == nil ) {
		// Nothing is playing yet
		self.rowPlayingIndexPath = button.indexPath;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];

		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
	} else {
		if (self.rowPlayingIndexPath.row == button.indexPath.row) {
			// Our current cell is playing
			self.rowPlayingIndexPath = nil;
			[button setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer stop];
		} else {
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.rowPlayingIndexPath];
			pubCell *c = (pubCell *)cell;
			[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];

			// Now update our current cell
			self.rowPlayingIndexPath = button.indexPath;
			[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
			
		}
	}
	
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
	
	
	// CoreData test
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	self.managedObjectContext = managedObjectContext;
	
	// Uncomment the following code to add the pubs to the database
	/*
	[self insertNewObject:@"De zoete bron" andStreet:@"M.Noestraat" andNumber:@"15" andZipCode:@"3050" andCity:@"Oud heverlee" 
				andUserID:@"418090" andRating:@"4" andLatitude:@"50.8236691" andLongitude:@"4.6626304"];
	
	[self insertNewObject:@"Fitforyou" andStreet:@"Mechelsesteenweg" andNumber:@"763" andZipCode:@"3020" andCity:@"Herent" 
				andUserID:@"418012" andRating:@"3" andLatitude:@"50.9204853" andLongitude:@"4.6479286"];
	
	[self insertNewObject:@"Cafe Mezza" andStreet:@"Mathieu de Layensplein" andNumber:@"119" andZipCode:@"3000" andCity:@"Leuven" 
				andUserID:@"416197" andRating:@"5" andLatitude:@"50.8799430" andLongitude:@"4.7002825"];
	
	[self insertNewObject:@"Linx" andStreet:@"Vismarkt" andNumber:@"17" andZipCode:@"3000" andCity:@"Leuven" 
				andUserID:@"416665" andRating:@"1" andLatitude:@"50.8817091" andLongitude:@"4.6998039"];
	
	[self insertNewObject:@"Mundo" andStreet:@"Martelarenplein" andNumber:@"14" andZipCode:@"3000" andCity:@"Leuven" 
				andUserID:@"418090" andRating:@"0" andLatitude:@"50.8814212" andLongitude:@"4.7145274"];
	
	[self insertNewObject:@"Mephisto" andStreet:@"Oude Markt" andNumber:@"2" andZipCode:@"3000" andCity:@"Leuven" 
				andUserID:@"315056" andRating:@"2" andLatitude:@"50.8783624" andLongitude:@"4.6996464"];
	
	[self insertNewObject:@"Cafe de Zappa" andStreet:@"Emile Carelsstraat" andNumber:@"1" andZipCode:@"3090" andCity:@"Overijse" 
				andUserID:@"413875" andRating:@"3" andLatitude:@"50.7709673" andLongitude:@"4.5401609"];
	
	*/
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
	
	self.dataSource = [[NSMutableArray alloc] init];
	[self.dataSource addObjectsFromArray:mutableFetchResults];
	
	// Uncomment the following code to remove all items from the database
	/*
	for(Pub *pub in mutableFetchResults) {
		[self.managedObjectContext deleteObject:pub];
	}
	 */
	
	// Uncomment the following code to commit the removal or add of items in the database
	// Save the context.
    //NSError *error = nil;
	/*
    if (![self.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	 */
	
	
	[mutableFetchResults release];
	[request release];


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


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject:(NSString *)theName andStreet:(NSString *)theStreet andNumber:(NSString *)theNumber
				andZipCode:(NSString *)theZipCode andCity:(NSString *)theCity andUserID:(NSString *)theUserID
				andRating:(NSString *)theRating andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude
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
#pragma mark Location lookup callbacks

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

	Pub *pub = [tableData objectAtIndex:indexPath.row];
	cell.nameLabel.text = [pub name];
	
	if (self.userLocation != nil) {
		CLLocationDegrees longitude= [[pub longitude] doubleValue];
		CLLocationDegrees latitude = [[pub latitude] doubleValue];
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
	[cell.stars setRating:[[pub rating] intValue]];
		
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


- (void)dealloc {
	[genre release];
	[rowPlayingIndexPath release];
	[dataSource release];
	[tableView release];
	[soapResults release];
	[xmlParser release];
	[webData release];
	[userLocation release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

