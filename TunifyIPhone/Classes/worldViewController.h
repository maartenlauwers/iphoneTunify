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
#import "CoordinatesTool.h"


//@class EAGLView;

@interface worldViewController : UIViewController <GLViewDelegate, CoordinatesToolDelegate> {
	NSString *strPubName;
	IBOutlet UISegmentedControl *capturedToggle;
	IBOutlet UILabel *lblDistanceToDestination;
	GLView *glView;
	
	CoordinatesTool *ct;
	NSString *strPubAddress;
	CLLocation *userLocation;
	CLLocation *pubLocation;
	CLLocationDistance distance;
}

@property (nonatomic, retain) NSString *strPubName;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UILabel *lblDistanceToDestination;
@property (nonatomic, retain) GLView *glView;

@property (nonatomic, retain) CoordinatesTool *ct;
@property (nonatomic, retain) NSString *strPubAddress;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (assign) CLLocationDistance distance;

- (void) initAll;
- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (IBAction) capturedToggleChanged:(id)sender;
- (GLfloat *)getArrowHeading;

@end
