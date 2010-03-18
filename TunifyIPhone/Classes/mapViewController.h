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

@class CSWebDetailsViewController;

@interface mapViewController : UIViewController <UIWebViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
	NSString *strPubName;
	NSString *strPubAddress;
	CLLocationManager *locationManager;
	
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
	
	NSString *userCoordinates;
	NSString *pubCoordinates;
}

@property (nonatomic, retain) NSString *strPubName;
@property (nonatomic, retain) NSString *strPubAddress;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIWebView *tempView;

@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) NSString *pubCoordinates;
@property (nonatomic, retain) UICGoogleMapsAPI *googleMapsAPI;

- (void)getCoordinates;
- (void)parseCoordinatesHtml:(NSString *)html;
- (void)parseData:(NSMutableData*)data;
- (void)setupMap;
- (void) showWebViewForURL:(NSURL*) url;

- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (void) loadPubView;
- (IBAction) capturedToggleChanged:(id)sender;
@end
