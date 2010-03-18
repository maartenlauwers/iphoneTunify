//
//  worldViewController.h
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"


//@class EAGLView;

@interface worldViewController : UIViewController <GLViewDelegate> {
	NSString *strPubName;
	IBOutlet UISegmentedControl *capturedToggle;
	
	GLView *glView;
}

@property (nonatomic, retain) NSString *strPubName;
@property (nonatomic, retain) IBOutlet UISegmentedControl *capturedToggle;
@property (nonatomic, retain) GLView *glView;

- (void) btnPubs_clicked:(id)sender;
- (void) btnMusic_clicked:(id)sender;
- (IBAction) capturedToggleChanged:(id)sender;

@end
