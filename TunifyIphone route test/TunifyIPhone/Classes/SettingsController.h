//
//  SettingsController.h
//  TunifyIPhone
//
//  Created by Elegia on 23/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "TunifyIPhoneAppDelegate.h"

@interface SettingsController : UIViewController {

	IBOutlet UISlider *radiusSlider;
	IBOutlet UISlider *volumeSlider;
	BOOL radiusChangedManually;
}

@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (assign) BOOL radiusChangedManually;

-(IBAction)volumeChanged;
-(IBAction)radiusChanged;
@end
