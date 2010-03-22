//
//  musicViewController.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h> 


@interface musicViewController : UIViewController <AVAudioPlayerDelegate> {
	NSMutableArray *dataSource;		// stores all data
	NSString *strPubName;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *artistLabel;
	IBOutlet UISlider *volumeSlider;
	
	NSInteger *source;
	
	AVAudioPlayer *player; 

}

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *strPubName;
@property (assign) NSInteger *source;

@end
