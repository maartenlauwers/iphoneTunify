//
//  selectedAchievementViewController.h
//  TunifyIPhone
//
//  Created by thesis on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSession.h"
#import "FBDialog.h"
#import "Achievement.h"

@interface selectedAchievementViewController : UIViewController <FBSessionDelegate, FBDialogDelegate> {
	Achievement *achievement;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *locationLabel;
	
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *facebookButton;
}

@property (nonatomic, retain) Achievement *achievement;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;

- (void)btnAchievements_clicked:(id)sender;
- (IBAction)btnTwitter_clicked:(id)sender;
- (IBAction)btnFacebook_clicked:(id)sender;
- (void)postToFacebook;
- (void)showSuccess;

@end
