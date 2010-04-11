//
//  mapViewController.h
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UICGoogleMapsAPI.h"
#import "CoordinatesTool.h"
#import "Pub.h"

@class CSWebDetailsViewController;

@interface mapViewController : UIViewController <UIWebViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, CoordinatesToolDelegate> {
	Pub *pub;
	NSString *pubAddress;
	
	IBOutlet MKMapView *mapView;
	IBOutlet UISegmentedControl *capturedToggle;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	NSMutableData *webData;
	NSMutableArray *pointsArray;
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary* _routeViews;
	
	// details view controller
	CSWebDetailsViewController* _detailsVC; 
	
	UICGoogleMapsAPI *googleMapsAPI;
	UIWebView *tempView;
	
	CoordinatesTool *ct;
	NSString *userCoordinates;
	CLLocation *userLocation;
	NSString *pubCoordinates;
	CLLocation *pubLocation;
	BOOL *webViewDidFinishLoading;
}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSString *pubAddress;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) CoordinatesTool *ct;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) NSString *pubCoordinates;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (nonatomic, retain) UICGoogleMapsAPI *googleMapsAPI;
@property (nonatomic, assign) BOOL *webViewDidFinishLoading;

- (void)initAll;
- (void)parseCoordinatesHtml:(NSString *)html;
- (void)setupMap;
- (void) showWebViewForURL:(NSURL*) url;

- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (void) loadPubView;
- (IBAction) capturedToggleChanged:(id)sender;
@end
