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

@interface pubList3DController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	
	NSString *genre;
	
	UIView *overlayView;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) UIView *overlayView;

- (void) btnFilter_clicked:(id)sender;
- (void) btnList_clicked:(id)sender;

@end
