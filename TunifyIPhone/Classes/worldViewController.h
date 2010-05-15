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
#import "CustomUIImagePickerController.h"
#import "CustomImagePicker.h"

//@class EAGLView;

@interface worldViewController : UIViewController <GLViewDelegate, CoordinatesToolDelegate> {
	Pub *pub;
	NSString *pubAddress;
	
	IBOutlet UISegmentedControl *capturedToggle;
	IBOutlet UILabel *lblDistanceToDestination;
	GLView *glView;
	
	CLLocation *userLocation;
	CLLocation *lastUserLocation;
	CLLocation *pubLocation;
	CLLocationDistance distance;
	
	CustomUIImagePickerController *picker;
	UIView *overlayView;
	
	NSTimer *locationTimer;		// Timer to keep our current location updated

}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSString *pubAddress;

@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) IBOutlet UILabel *lblDistanceToDestination;
@property (nonatomic, retain) GLView *glView;

@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *lastUserLocation;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (assign) CLLocationDistance distance;

@property (nonatomic, retain) CustomUIImagePickerController *picker;
@property (nonatomic, retain) UIView *overlayView;

- (void) initAll;
- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (IBAction) capturedToggleChanged:(id)sender;
- (GLfloat *)getArrowHeading;
- (void)showPickerView:(UIImagePickerController *)controller;
- (void) updateMusicPlayback:(CLLocation *)oldLocation currentLocation:(CLLocation *)currentLocation;

@end
