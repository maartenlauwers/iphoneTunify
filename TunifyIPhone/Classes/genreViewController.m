//
//  genreViewController.m
//  TunifyIPhone
//
//  Created by thesis on 19/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "genreViewController.h"
#import "pubListController.h"
#import "pubList3DController.h"
#import "recentPubListController.h"

@implementation genreViewController

@synthesize dataSource;
@synthesize tableView;
@synthesize sourceView;
@synthesize sourceId;
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void) btnCancel_clicked:(id)sender {
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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480 );     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }
	
	self.navigationItem.title = @"Filter by genre";
	
	// Create the left bar button item
	UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] init];
	cancelBarButtonItem.title = @"Cancel";
	cancelBarButtonItem.target = self;
	cancelBarButtonItem.action = @selector(btnCancel_clicked:);
	self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
	[cancelBarButtonItem release];
	
	
	// Init our datasource to keep the categories
	dataSource = [[NSMutableArray alloc] init];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString *sessionCode = [userDefaults stringForKey:@"sessionCode"]; 
	NSString *userID = [userDefaults stringForKey:@"userID"]; 
	
	// Fetch all possible genres
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tun=\"http://www.tunify.com\">\n"
							 "<soapenv:Header/>\n"
							 "<soapenv:Body>\n"
							 "<tun:getAllCategories>\n"
							 "<credentials>\n"
							 "<userID>%@</userID>\n"
							 "<userPassword>iphonethesis</userPassword>\n"
							 "<appID>7</appID>\n"
							 "<appPassword>m4rc3llu5w4ll4c3</appPassword>\n"
							 "<sessionCode>%@</sessionCode>\n"
							 "</credentials>\n"
							 "</tun:getAllCategories>\n"
							 "</soapenv:Body>\n"
							 "</soapenv:Envelope>\n", userID, sessionCode
							 ];
	NSLog(soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://webservice.aristomusic.com/production/services/tunify2/"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:@"http://www.tunify.com/getAllCategories" forHTTPHeaderField:@"SOAPAction"];
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
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
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
	if( [elementName isEqualToString:@"statusCode"])
	{
		if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
		recordResults = TRUE;
	} else if ([elementName isEqualToString:@"faultcode"]) {
		[xmlParser abortParsing];
		// An error occured while loggin in.
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
															message:NSLocalizedString(@"Could not get the genres from the Tunify server.",  
																					  @"message") 
															delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel")
															otherButtonTitles:nil];
		[alertView show]; 
	} else if ([elementName isEqualToString:@"category"]) {
		NSString *category = [attributeDict objectForKey:@"value"];
		NSLog(@"Category: %@", category);
		[dataSource addObject:category];
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
	} else if ([elementName isEqualToString:@"ns1:getAllCategoriesResponse"]) {
		[tableView reloadData];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
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
    return [dataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [dataSource objectAtIndex:[indexPath row]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	/*
	 First we create a copy of the current pubListController.
	 Then we update that copy with the genre data.
	 Then we remove all active controllers on the navigation stack and push the updated pubListController copy and the
	 current controller on the stack (the current controller is required to create a smooth transitation animation)
	 Then we show the tabbar again and pop to the root view controller (which is the updated pubListcontroller copy)
	 */
	
	/*
	pubListController *pvc = (pubListController *)[self.navigationController.viewControllers objectAtIndex:0];
	pvc.genre = [dataSource objectAtIndex:[indexPath row]];	
	
	[[self retain] autorelease];
	NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
	[controllers removeAllObjects];
	[controllers insertObject:pvc atIndex:0];
	[controllers insertObject:self atIndex:1];
	
	self.navigationController.viewControllers = controllers;
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	*/
	
	
	
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	if(self.sourceId == 1) {
		pubListController *controller = (pubListController *)self.sourceView;
		controller.genre = [dataSource objectAtIndex:[indexPath row]];
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else if (self.sourceId == 2) {
		pubList3DController *controller = (pubList3DController *)self.sourceView;
		controller.genre = [dataSource objectAtIndex:[indexPath row]];
		[self.navigationController popToViewController:controller animated:YES];
	} else if (self.sourceId == 3) {
		recentPubListController *controller = (recentPubListController *)self.sourceView;
		controller.genre = [dataSource objectAtIndex:[indexPath row]];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	
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


- (void)dealloc {
	[sourceView release];
	[dataSource release];
	[tableView release];
	[webData release];
	
	[soapResults release];
	[xmlParser release];
    [super dealloc];
}


@end

