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
#import "AudioPlayer.h"
#import "Pub.h"
#import "RecentlyVisited.h"
#import "mapViewController.h"
#import "CellButton.h"

@interface musicViewController : UIViewController <AVAudioPlayerDelegate> {
	NSMutableArray *dataSource;		// stores all data
	Pub *pub;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *artistLabel;
	IBOutlet UISlider *volumeSlider;
	
	NSInteger rowPlaying;
	NSInteger source;
	IBOutlet UITableView *tableView;
	
	//AVAudioPlayer *player; 

}

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) Pub *pub;
@property (assign) NSInteger source;
@property (assign) NSInteger rowPlaying;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction) volumeChanged;
- (void) playMusic:(id)sender;

@end
