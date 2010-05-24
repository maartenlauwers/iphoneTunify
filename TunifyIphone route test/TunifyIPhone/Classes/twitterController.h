//
//  twitterController.h
//  TunifyIPhone
//
//  Created by thesis on 22/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pub.h"

@interface twitterController : UIViewController {
	Pub *pub;
	NSString *strAchievementName;
	NSString *strAchievementDesc;
	NSString *strAchievementLocation;
	NSInteger charactersLeft;
	IBOutlet UILabel *charactersLeftLabel;
	IBOutlet UITextView *twitterMessageView;
}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSString *strAchievementName;
@property (nonatomic, retain) NSString *strAchievementDesc;
@property (nonatomic, retain) NSString *strAchievementLocation;
@property (nonatomic, retain) IBOutlet UILabel *charactersLeftLabel;
@property (nonatomic, retain) IBOutlet UITextView *twitterMessageView;
@property (assign) NSInteger charactersLeft;


@end
