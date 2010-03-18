//
//  worldViewController.h
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
#import <CoreLocation/CoreLocation.h>


//@class EAGLView;

@interface worldViewController : UIViewController <GLViewDelegate> {
	NSString *strPubName;
	IBOutlet UISegmentedControl *capturedToggle;
	IBOutlet UILabel *lblDistanceToDestination;
	GLView *glView;
	
	CLLocationManager *locationManager;
	NSString *strPubAddress;
	NSString *userCoordinates;
	NSString *pubCoordinates;
}

@property (nonatomic, retain) NSString *strPubName;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UILabel *lblDistanceToDestination;
@property (nonatomic, retain) GLView *glView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *strPubAddress;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) NSString *pubCoordinates;

- (void) getCoordinates;
- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (IBAction) capturedToggleChanged:(id)sender;

@end
