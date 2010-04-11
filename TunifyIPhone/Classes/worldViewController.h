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
#import "Pub.h"

//@class EAGLView;

@interface worldViewController : UIViewController <GLViewDelegate, CoordinatesToolDelegate> {
	Pub *pub;
	NSString *pubAddress;
	
	IBOutlet UISegmentedControl *capturedToggle;
	IBOutlet UILabel *lblDistanceToDestination;
	GLView *glView;
	
	CoordinatesTool *ct;
	CLLocation *userLocation;
	CLLocation *pubLocation;
	CLLocationDistance distance;
}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSString *pubAddress;

@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UILabel *lblDistanceToDestination;
@property (nonatomic, retain) GLView *glView;

@property (nonatomic, retain) CoordinatesTool *ct;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (assign) CLLocationDistance distance;

- (void) initAll;
- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (IBAction) capturedToggleChanged:(id)sender;
- (GLfloat *)getArrowHeading;

@end
