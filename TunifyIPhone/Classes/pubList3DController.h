//
//  pubList3DController.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PubCard.h"
#import "CustomUIImagePickerController.h"
#import "CustomImagePicker.h"
#import "Pub.h"
#import "CoordinatesTool.h"
#import "worldViewController.h"
#import "mapViewController.h"

@interface pubList3DController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAccelerometerDelegate> {
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	
	NSString *genre;
	
	CustomUIImagePickerController *picker;
	UIView *overlayView;
	
	NSMutableArray *dataSource;
	
	CLLocation *userLocation;
	NSTimer *timer;
	UILabel* lblCo;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) CustomUIImagePickerController *picker;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) UILabel *lblCo;

- (void) btnFilter_clicked:(id)sender;
- (void) btnList_clicked:(id)sender;
- (float)calculatePubHeading:(Pub *)pub;

@end
