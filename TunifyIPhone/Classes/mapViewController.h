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
#import "TunifyIPhoneAppDelegate.h"
#import "worldViewController.h"
#import "musicViewController.h"
#import "pubVisitViewController.h"
#import "mapAnnotation.h"
#import "CSMapAnnotation.h"
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"
#import "CSImageAnnotationView.h"
#import "CSWebDetailsViewController.h"
#import "CSPubAnnotation.h"
#import "RecentlyVisited.h"

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
	
	//CoordinatesTool *ct;
	NSString *userCoordinates;
	CLLocation *userLocation;
	CLLocation *lastUserLocation;
	NSString *pubCoordinates;
	CLLocation *pubLocation;
	BOOL webViewDidFinishLoading;
	
	NSInteger distanceFromDestination;
	NSTimer *locationTimer;
}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSString *pubAddress;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *lastUserLocation;
@property (nonatomic, retain) NSString *pubCoordinates;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (nonatomic, retain) UICGoogleMapsAPI *googleMapsAPI;
@property (nonatomic, assign) BOOL webViewDidFinishLoading;
@property (nonatomic, assign) NSInteger distanceFromDestination;

- (void)initAll;
- (void)parseCoordinatesHtml:(NSString *)html;
- (void)setupMap;
- (void) showWebViewForURL:(NSURL*) url;

- (void) updateMusicPlayback:(CLLocation *)oldLocation currentLocation:(CLLocation *)currentLocation;
- (void) repeatSearchWithPub:(Pub *)pub;
- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (void) loadPubView;
- (IBAction) capturedToggleChanged:(id)sender;
@end
