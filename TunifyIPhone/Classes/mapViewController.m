//
//  mapViewController.m
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "mapViewController.h"

@implementation mapViewController

@synthesize pub;
@synthesize pubAddress;
@synthesize capturedToggle;
@synthesize activityIndicator;
@synthesize mapView;
@synthesize pointsArray;
@synthesize webData;
@synthesize userCoordinates;
@synthesize userLocation;
@synthesize lastUserLocation;
@synthesize pubCoordinates;
@synthesize pubLocation;
@synthesize googleMapsAPI;
@synthesize webViewDidFinishLoading;
@synthesize distanceFromDestination;

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


/* NOTE: This method allows the volume to range from the minimum to the maximum available. The maximum might be too loud for the user.
		 Also, the current distance at which the volume changes is 25 meters. This might be too much or too little.
*/
- (void) updateMusicPlayback:(CLLocation *)oldLocation currentLocation:(CLLocation *)currentLocation {	

	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	CLLocationDistance oldDistance = [ct fetchDistance:self.pubLocation locationB:oldLocation];
	CLLocationDistance newDistance = [ct fetchDistance:self.pubLocation locationB:currentLocation];
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	if (newDistance < oldDistance) {
		double difference = oldDistance - newDistance;
		while(difference > 0) {
			[audioPlayer decreaseVolume];
			difference -= 25;
		}
	} else if (newDistance > oldDistance) {
		double difference = newDistance - oldDistance;
		while(difference > 0) {
			[audioPlayer increaseVolume];
			difference -= 25;
		}
	} 
}

- (void) repeatSearchWithPub:(Pub *)thePub {
	NSLog(@"Other pub selected");
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[locationTimer invalidate];
	[ct stop];
	
	[mapView removeAnnotations:[mapView annotations]];
	
	// Add the pub to the recently visited pub list
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	[rv addPub:thePub];
	
	self.pub = thePub;
	[self initAll];
	
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
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[locationTimer invalidate];
	[ct stop];
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
		
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) btnMusic_clicked:(id)sender {
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[locationTimer invalidate];
	[ct stop];

	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	
	musicViewController *controller = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	controller.pub = self.pub;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (void)loadPubView {
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
	{
		UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
		UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[locationTimer invalidate];
	[ct stop];
	
	pubVisitViewController *controller = [[pubVisitViewController alloc] initWithNibName:@"pubVisitView" bundle:[NSBundle mainBundle]];
	controller.pub = self.pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 1) {
		
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		[locationTimer invalidate];
		[ct stop];
		
		worldViewController *controller = [[worldViewController alloc] initWithNibName:@"worldView" bundle:[NSBundle mainBundle]];
		controller.pub = self.pub;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		controller = nil;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) // Visit pub
	{ 
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		[locationTimer invalidate];
		[ct stop];
		
		[self loadPubView];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"map viewdidload");
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
                                   
		view.frame = CGRectMake(0, 0, 320, 480 );     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }

	self.navigationItem.title = [self.pub name];
	
	// Create the left bar button item
	UIBarButtonItem *pubsBarButtonItem = [[UIBarButtonItem alloc] init];
	pubsBarButtonItem.title = @"Pubs";
	pubsBarButtonItem.target = self;
	pubsBarButtonItem.action = @selector(btnPubs_clicked:);
	self.navigationItem.leftBarButtonItem = pubsBarButtonItem;
	[pubsBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *musicBarButtonItem = [[UIBarButtonItem alloc] init];
	musicBarButtonItem.title = @"Music";
	musicBarButtonItem.target = self;
	musicBarButtonItem.action = @selector(btnMusic_clicked:);
	self.navigationItem.rightBarButtonItem = musicBarButtonItem;
	[musicBarButtonItem release];
	
		
}

-(void) viewDidAppear:(BOOL)animated { 
	[super viewDidAppear:animated]; 
	
	/*
	 We re-initialize the map here. We might have left this view by pushing another view over it. When we move back to this view, our location may have changed.
	 Also, if we didn't get our location previously, we need to fix this now.
	*/
	[self initAll];
} 

- (void)initAll {
	
	[self.activityIndicator startAnimating];
	
	self.userLocation = nil;
	self.pubLocation = nil;
	self.userCoordinates = nil;
	self.pubCoordinates = nil;
	
	// dictionary to keep track of route views that get generated. 
	_routeViews = [[NSMutableDictionary alloc] init];
	
	self.webViewDidFinishLoading = FALSE;
	
	
	// Fetch the pub's address
	NSLog(@"Setting pub address");
	self.pubAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", [pub street], [pub number], [pub zipcode], [pub city]];
	
	// Fetch the user location and the pub's location
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchPubLocation:self.pub];
	
	
	googleMapsAPI = [[UICGoogleMapsAPI alloc] init];
	googleMapsAPI.delegate = self;
	
	// Play the pub's music
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer playTest];
	
	// TODO: The following alert view should only show up when we've reached our destination
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Destination reached",@"title") 
														message:NSLocalizedString(@"What do you want to do?",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Keep walking", @"cancel") 
											  otherButtonTitles:NSLocalizedString(@"Grab a drink", @"checkin"), 
							  nil]; 
	[alertView show]; 
}

- (void)userLocationFound:(CoordinatesTool *)sender {
	NSLog(@"maps: userLocationFound");

	if(self.userLocation == nil ||
	(self.userLocation.coordinate.latitude != self.lastUserLocation.coordinate.latitude) || 
	(self.userLocation.coordinate.longitude != self.lastUserLocation.coordinate.longitude)) {
			self.userLocation = sender.userLocation;
			self.userCoordinates = sender.userCoordinates;
			
			
			if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE && self.webViewDidFinishLoading == TRUE) {
				NSLog(@"evaluating javascript");
				[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];
			}
		
			// If we arrive here it is either the first time or it is because we've come closer to our destination. In te latter case we must
			// adapt the music playback.
		
			[self updateMusicPlayback:self.lastUserLocation currentLocation:sender.userLocation];
			self.lastUserLocation = sender.userLocation;
	}
	
	
}

- (void)userLocationError:(CoordinatesTool *)sender {
	/*
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while locating your position.",  
																				  @"message") 
														delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
														otherButtonTitles:nil]; 
	[alertView show]; 
	*/
	if (sender.userLocationOK == FALSE && sender.pubLocationOK == FALSE) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
															message:NSLocalizedString(@"Cannot locate the pub's position.",  
																					  @"message") 
														   delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
															otherButtonTitles:nil]; 
		[alertView show];
	}
}

- (void)pubLocationFound:(CoordinatesTool *)sender {
	NSLog(@"maps: pubLocationFound");
	self.pubLocation = sender.pubLocation;
	self.pubCoordinates = sender.pubCoordinates;
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE && self.webViewDidFinishLoading == TRUE) {
		[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];
	}
}

- (void)pubLocationError:(CoordinatesTool *)sender {
	/*
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while locating the pub.",  
																				  @"message") 
														delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
														otherButtonTitles:nil]; 
	[alertView show]; 
	*/
	if (sender.userLocationOK == FALSE && sender.pubLocationOK == FALSE) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
															message:NSLocalizedString(@"Cannot locate the pub's position.",  
																					  @"message") 
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
												  otherButtonTitles:nil]; 
		[alertView show];
	}
}


/*
- (void) getCoordinates {
	//self.locationManager = [[CLLocationManager alloc] init]; 
	//self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	//self.locationManager.delegate = self; 
	//[self.locationManager startUpdatingLocation]; 
	
	
	// Store the coordinates of the user
	self.userCoordinates = [NSString stringWithFormat:@"%f,%f", 50.8610959, 2.7315335]; // TODO: Replace by actual user coordinates with 
	// self.locationManager.location.coordinate.latitude;
	// self.locationManager.location.coordinate.longitude;
	NSLog(@"userCoordinates: %@", userCoordinates);
	// Fetch the coordinates of the pub
	self.strPubAddress = @"Ieperstraat 100 8970 Poperinge"; // TODO: Replace by actual pub address
	NSString *pubAddress = self.strPubAddress;
	NSString *pubAddressString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&sensor=false", [pubAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *pubAddressURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:pubAddressString]];
	NSArray *userLocationAddressResults = [pubAddressURL componentsSeparatedByString:@","];
	self.pubCoordinates = @"";
	if([userLocationAddressResults count] >= 4 && [[userLocationAddressResults objectAtIndex:0] isEqualToString:@"200"]) {
		
		for(int i=2; i<[userLocationAddressResults count]; i++) {
			if (i == 3) {
				self.pubCoordinates = [self.pubCoordinates stringByAppendingString:@","];
			}
			self.pubCoordinates = [self.pubCoordinates stringByAppendingString:[userLocationAddressResults objectAtIndex:i]];
		}
		NSLog(@"pubCoordinates: %@", pubCoordinates);
	}
	else {
		//Error handling
		NSLog(@"Error while getting target address location");
	}
	
	//googleMapsAPI = [[UICGoogleMapsAPI alloc] init];
	//googleMapsAPI.delegate = self;
	
}
*/

- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object {
	NSLog(@"Didgetobject");
	NSString *html = goolgeMapsAPI.message;
	[self parseCoordinatesHtml:html];
}

- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message {
	NSLog(@"ERROR: %@", message);
}

- (void)messageReceived:(UICGoogleMapsAPI *)sender {
	NSLog(@"googlemaps message received");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.webViewDidFinishLoading = TRUE;
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	if (ct.userLocationOK == TRUE && ct.pubLocationOK == TRUE) {
		[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];	
	}
}



-(void)parseCoordinatesHtml:(NSString *)html {
	
	pointsArray = [[NSMutableArray alloc] init];
	
	NSString *remainingSubString = html;
	NSRange coordRange = [remainingSubString rangeOfString:@"<br>"];

	while(coordRange.location != NSNotFound) {
		NSString *coordPair = [remainingSubString substringWithRange:NSMakeRange(0, coordRange.location)];

		NSRange kommaRange = [coordPair rangeOfString:@","];
		CLLocationDegrees longitude  = [[coordPair substringWithRange:NSMakeRange(0, kommaRange.location)] doubleValue];
		CLLocationDegrees latitude  = [[coordPair substringFromIndex:(kommaRange.location + 1)] doubleValue];
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:longitude longitude:latitude] autorelease];
		[pointsArray addObject:currentLocation];
		
		remainingSubString = [remainingSubString substringFromIndex:(coordRange.location + 4)];
		
		coordRange = [remainingSubString rangeOfString:@"<br>"];
	}		
	
	[self setupMap];
	
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
	NSLog([error localizedDescription]);
	[connection release];
	[webData release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	[webData release];
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation { 
    NSLog(@"Core location claims to have a position."); 
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error { 
		NSLog(@"Core location says no-go on the position info."); 
} 
 */

- (void)setupMap {
	
	NSLog(@"setupMap");
	
	// Remove any existing annotations
	[mapView removeAnnotations:[mapView annotations]];
	
	// CREATE THE ANNOTATIONS AND ADD THEM TO THE MAP
	
	// first create the route annotation, so it does not draw on top of the other annotations. 
	CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:pointsArray] autorelease];
	[mapView addAnnotation:routeAnnotation];
	
	
	
	// create the rest of the annotations
	CSMapAnnotation* annotation = nil;
	
	
	// create the start annotation and add it to the array
	annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[pointsArray objectAtIndex:0] coordinate]
											   annotationType:CSMapAnnotationTypeStart
														title:@"You are here"] autorelease];
	[annotation subtitle:@""];
	[mapView addAnnotation:annotation];
	
	// create the end annotation and add it to the array
	annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[pointsArray objectAtIndex:pointsArray.count - 1] coordinate]
											   annotationType:CSMapAnnotationTypeEnd
														title:[self.pub name]] autorelease];
	
	[annotation subtitle:[self.pubAddress copy]];
	[mapView addAnnotation:annotation];
	
	
	// Place other pubs on the map
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
	} else {
		NSLog(@"Mutablefetchresults count: %d", [mutableFetchResults count]);
		for(Pub *thePub in mutableFetchResults) {
			if(thePub != self.pub) {
				NSLog(@"pub name: %@", thePub.name);
				CLLocationDegrees longitude = [[thePub longitude] doubleValue]; 
				CLLocationDegrees latitude = [[thePub latitude] doubleValue]; 
				
				CLLocationCoordinate2D coord;
				coord.latitude = latitude;
				coord.longitude = longitude;
				
				CSPubAnnotation *pubAnnotation = [[[CSPubAnnotation alloc] initWithCoordinate:coord
														title:[thePub name]
														pub:thePub] autorelease];
				
				NSString *address = [[NSString stringWithFormat:@"%@ %@, %@ %@", [thePub street], [thePub number], [thePub zipcode], [thePub city]] retain];
				[pubAnnotation subtitle:address];
				
				[mapView addAnnotation:pubAnnotation];
			}
		}
		
	}
	
	
	// center and size the map view on the region computed by our route annotation. 
	[mapView setRegion:routeAnnotation.region];
	
	[self.activityIndicator stopAnimating];
	NSLog(@"end setupMap");
	
	
	// Get the total distance to the destination
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	int totalDistance = 0;
	int i = 0;
	for(i=1; i<[pointsArray count]; i++) {
		CLLocation *locA = [pointsArray objectAtIndex:i-1];
		CLLocation *locB = [pointsArray objectAtIndex:i];
		totalDistance += [ct fetchDistance:locA locationB:locB];
	}
	self.distanceFromDestination = totalDistance;
	NSLog(@"TotalDistance: %d", self.distanceFromDestination);
	
	locationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateLocation) userInfo:nil repeats: YES];
	[ct stop];

	NSLog(@"MAPVIEW ANNOTATION COUNT: %d", [[mapView annotations] count]);
	
}

- (void)updateLocation {
	NSLog(@"Update location");
	googleMapsAPI = [[UICGoogleMapsAPI alloc] init];
	googleMapsAPI.delegate = self;
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	ct.delegate = self;
	[ct fetchUserLocation];
	NSLog(@"self.pubAddress: %@", self.pubAddress);
	[ct fetchPubLocation:self.pub];
}

#pragma mark mapView delegate functions

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
		
	}
	
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}
	
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	
	
	if([annotation isKindOfClass:[CSMapAnnotation class]])
	{
		// determine the type of annotation, and produce the correct type of annotation view for it.
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		if(csAnnotation.annotationType == CSMapAnnotationTypeStart || 
		   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
		{
			NSLog(@"CSMapAnnotation pub name: %@", csAnnotation.title);
			NSString* identifier = @"Pin";
			MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			if(nil == pin)
			{
				pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier] autorelease];
			}
			
			if (csAnnotation.annotationType == CSMapAnnotationTypeStart) {
				[pin setPinColor:MKPinAnnotationColorGreen];
			} else if (csAnnotation.annotationType == CSMapAnnotationTypeEnd) {
				[pin setPinColor:MKPinAnnotationColorRed];
			} 
			
			annotationView = pin;
		}
		else if(csAnnotation.annotationType == CSMapAnnotationTypeImage)
		{
			NSString* identifier = @"Image";
			
			CSImageAnnotationView* imageAnnotationView = (CSImageAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			if(nil == imageAnnotationView)
			{
				imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];	
				imageAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			}
			
			annotationView = imageAnnotationView;
		}
		
		[annotationView setEnabled:YES];
		[annotationView setCanShowCallout:YES];
	}
	else if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteView* routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(0, 0, theMapView.frame.size.width, theMapView.frame.size.height)] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = theMapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = routeView;
		}
	}
	else if([annotation isKindOfClass:[CSPubAnnotation class]])
	{
		CSPubAnnotation* pubAnnotation = (CSPubAnnotation*) annotation;
		
		NSLog(@"HANDLING PUB ANNOTATIONS");
		NSLog(@"pub name: %@", pubAnnotation.pub.name);
		NSString* identifier = @"PubPin";
		MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		
		if(nil == pin)
		{
			NSLog(@"ADDING PUB BUTTON");
			NSLog(@"pub name: %@", pubAnnotation.pub.name);
			pin = [[[MKPinAnnotationView alloc] initWithAnnotation:pubAnnotation reuseIdentifier:identifier] autorelease];
			UIButton *pubButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			pin.rightCalloutAccessoryView = pubButton;
		}
		
		[pin setPinColor:MKPinAnnotationColorPurple];
		
		annotationView = pin;
		[annotationView setEnabled:YES];
		[annotationView setCanShowCallout:YES];

	}
	
	return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	CSImageAnnotationView* imageAnnotationView = (CSImageAnnotationView*) view;
	CSPubAnnotation* annotation = (CSPubAnnotation*)[view annotation];
	
	NSLog(@"Clicked pub: %@", annotation.pub.name);
	[self repeatSearchWithPub:[annotation pub]];
	/*
	if(annotation.url != nil)
	{
		if(nil == _detailsVC)	
			_detailsVC = [[CSWebDetailsViewController alloc] initWithNibName:@"CSWebDetailsViewController" bundle:nil];
		
		_detailsVC.url = annotation.url;
		[self.view addSubview:_detailsVC.view];
	}
	 */
}
 

/*
-(void) showWebViewForURL:(NSURL*) url
{
	CSWebDetailsViewController* webViewController = [[[CSWebDetailsViewController alloc] initWithNibName:@"CSWebDetailsViewController" bundle:nil] autorelease];
	[webViewController setUrl:url];
	
	[self presentModalViewController:webViewController animated:YES];
	//[webViewController autorelease];
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

-(void) viewWillDisappear:(BOOL)animated { 
	[super viewWillDisappear:animated]; 
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct stop];
	//[self.locationManager stopUpdatingLocation]; 
	//self.locationManager = nil;
} 

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[pointsArray release];
	[webData release]; // scratch this if you get crashes
	[mapView release];
	[_routeViews release];
	[_detailsVC release];
	[googleMapsAPI release];
	[userCoordinates release];
	[userLocation release];
	[lastUserLocation release];
	[pubCoordinates release];
	[pubLocation release];
	[pubAddress release];
	[pub release];
	[activityIndicator release];
	[capturedToggle release];
    [super dealloc];
}


@end
