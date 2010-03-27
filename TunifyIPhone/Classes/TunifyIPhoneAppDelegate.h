//
//  TunifyIPhoneAppDelegate.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface TunifyIPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabController;
	AudioPlayer *audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic, retain) AudioPlayer *audioPlayer;
@end

