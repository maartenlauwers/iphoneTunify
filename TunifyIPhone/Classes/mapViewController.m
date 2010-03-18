//
//  mapViewController.m
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "mapViewController.h"
#import "worldViewController.h"
#import "musicViewController.h"
#import "pubVisitViewController.h"
#import "mapAnnotation.h"
#import "CSMapAnnotation.h"
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"
#import "CSImageAnnotationView.h"
#import "CSWebDetailsViewController.h"

@implementation mapViewController

@synthesize strPubName;
@synthesize strPubAddress;
@synthesize capturedToggle;
@synthesize activityIndicator;
@synthesize locationManager;
@synthesize mapView;
@synthesize pointsArray;
@synthesize webData;
@synthesize tempView;
@synthesize ct;
@synthesize userCoordinates;
@synthesize userLocation;
@synthesize pubCoordinates;
@synthesize pubLocation;
@synthesize googleMapsAPI;
@synthesize webViewDidFinishLoading;


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

- (void) btnPubs_clicked:(id)sender {
	
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

- (void) btnMusic_clicked:(id)sender {
	musicViewController *mvc = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	mvc.strPubName = strPubName;
	mvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//[self presentModalViewController:mvc animated:YES];
	[self.navigationController pushViewController:mvc animated:YES];
	[mvc release];
	mvc = nil;
}

- (void) loadPubView {
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
	{
		UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
		UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	pubVisitViewController *pvvc = [[pubVisitViewController alloc] initWithNibName:@"pubVisitView" bundle:[NSBundle mainBundle]];
	pvvc.strPubName = strPubName;
	[self.navigationController pushViewController:pvvc animated:YES];
	[pvvc release];
	pvvc = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 1) {
		worldViewController *controller = [[worldViewController alloc] initWithNibName:@"worldView" bundle:[NSBundle mainBundle]];
		controller.strPubName = self.strPubName;
		controller.strPubAddress = self.strPubAddress;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		controller = nil;
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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

	self.navigationItem.title = strPubName;
	
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
	
	pointsArray = [[NSMutableArray alloc] init];
	
	// dictionary to keep track of route views that get generated. 
	_routeViews = [[NSMutableDictionary alloc] init];
	
	[self.activityIndicator startAnimating];
	
	if(self.webViewDidFinishLoading == TRUE) {
		NSLog(@"WEBVIEWDIDFINISHLOADING STILL TRUE");
	}
	self.webViewDidFinishLoading = FALSE;
	
	ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchPubLocation:self.strPubAddress];

	
	googleMapsAPI = [[UICGoogleMapsAPI alloc] init];
	googleMapsAPI.delegate = self;
	
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
	self.userLocation = sender.userLocation;
	self.userCoordinates = sender.userCoordinates;
	
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE && self.webViewDidFinishLoading == TRUE) {
		[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];
	}
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

- (void)pubLocationFound:(CoordinatesTool *)sender {
	self.pubLocation = sender.pubLocation;
	self.pubCoordinates = sender.pubCoordinates;
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE && self.webViewDidFinishLoading == TRUE) {
		[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];
	}
}

- (void)pubLocationError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while the pub's position.",  
																				  @"message") 
														delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
														otherButtonTitles:nil]; 
	[alertView show]; 
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
	NSString *html = goolgeMapsAPI.message;
	[self parseCoordinatesHtml:html];
}

- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message {
	NSLog(@"ERROR: %@", message);
}

- (void)messageReceived:(UICGoogleMapsAPI *)sender {
	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	NSLog(@"Did finish load");
	self.webViewDidFinishLoading = TRUE;
	if (self.ct.userLocationOK == TRUE && self.ct.pubLocationOK == TRUE) {
		[googleMapsAPI stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadDirections(\"%@\", \"%@\")", self.userCoordinates, self.pubCoordinates]];	
	}
}



-(void)parseCoordinatesHtml:(NSString *)html {
	NSLog(@"Current user coordinates: %@", self.userCoordinates);
	NSLog(@"Current pub coordinates: %@", self.pubCoordinates);
	
	NSLog(@"html: %@", html);
	
	
	NSString *remainingSubString = html;
	NSRange coordRange = [remainingSubString rangeOfString:@"<br>"];
	NSLog(@"starting while");
	while(coordRange.location != NSNotFound) {
		NSString *coordPair = [remainingSubString substringWithRange:NSMakeRange(0, coordRange.location)];
		NSLog(@"CoordPair: %@", coordPair);

		NSRange kommaRange = [coordPair rangeOfString:@","];
		CLLocationDegrees longitude  = [[coordPair substringWithRange:NSMakeRange(0, kommaRange.location)] doubleValue];
		CLLocationDegrees latitude  = [[coordPair substringFromIndex:(kommaRange.location + 1)] doubleValue];
		NSLog(@"My Latitude: %d", latitude);
		NSLog(@"My Longitude: %d", longitude);
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:longitude longitude:latitude] autorelease];
		[pointsArray addObject:currentLocation];
		
		remainingSubString = [remainingSubString substringFromIndex:(coordRange.location + 4)];
		NSLog(@"Remaining: %@", remainingSubString);
		
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
	NSLog(@"So far so good");
	NSLog(@"point amount: %d", pointsArray.count);
	
	// CREATE THE ANNO1TATIONS AND ADD THEM TO THE MAP
	
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
														title:self.strPubName] autorelease];
	[annotation subtitle:self.strPubAddress];
	[mapView addAnnotation:annotation];
	
	
	// center and size the map view on the region computed by our route annotation. 
	[mapView setRegion:routeAnnotation.region];
	
	[self.activityIndicator stopAnimating];
}

#pragma mark mapView delegate functions

- (void)mapView:(MKMapView *)mapView
{
	NSLog(@"regionWillChangeAnimated");
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
	NSLog(@"regionDidChangeAnimated");
	// re-enable and re-poosition the route display. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}
	
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSLog(@"viewForAnnotation");
	MKAnnotationView* annotationView = nil;
	
	
	if([annotation isKindOfClass:[CSMapAnnotation class]])
	{
		// determine the type of annotation, and produce the correct type of annotation view for it.
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		if(csAnnotation.annotationType == CSMapAnnotationTypeStart || 
		   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
		{
			NSString* identifier = @"Pin";
			MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			if(nil == pin)
			{
				pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier] autorelease];
			}
			
			[pin setPinColor:(csAnnotation.annotationType == CSMapAnnotationTypeEnd) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen];
			
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
			CSRouteView* routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = routeView;
		}
	}
	
	return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"annotationView");
	NSLog(@"calloutAccessoryControlTapped");
	
	CSImageAnnotationView* imageAnnotationView = (CSImageAnnotationView*) view;
	CSMapAnnotation* annotation = (CSMapAnnotation*)[imageAnnotationView annotation];
	
	if(annotation.url != nil)
	{
		if(nil == _detailsVC)	
			_detailsVC = [[CSWebDetailsViewController alloc] initWithNibName:@"CSWebDetailsViewController" bundle:nil];
		
		_detailsVC.url = annotation.url;
		[self.view addSubview:_detailsVC.view];
	}
}
 


-(void) showWebViewForURL:(NSURL*) url
{
	NSLog(@"showWebViewForURL");
	CSWebDetailsViewController* webViewController = [[CSWebDetailsViewController alloc] initWithNibName:@"CSWebDetailsViewController" bundle:nil];
	[webViewController setUrl:url];
	
	[self presentModalViewController:webViewController animated:YES];
	//[webViewController autorelease];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSLog(@"Button clicked");
	if (buttonIndex == 1) 
	{ 
		[self loadPubView];
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


-(void) viewWillDisappear:(BOOL)animated { 
	[super viewWillDisappear:animated]; 
	
	NSLog(@"Shutting down core location..."); 
	[self.locationManager stopUpdatingLocation]; 
	self.locationManager = nil;
} 

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[strPubName release];
	[strPubAddress release];
	[pointsArray release];
	[locationManager release];
	[tempView release];
	[mapView release];
	[_routeViews release];
	[_detailsVC release];
	[googleMapsAPI release];
	[ct release];
	[userCoordinates release];
	[userLocation release];
	[pubCoordinates release];
	[pubLocation release];
	[activityIndicator release];
	[capturedToggle release];
    [super dealloc];
}


@end
