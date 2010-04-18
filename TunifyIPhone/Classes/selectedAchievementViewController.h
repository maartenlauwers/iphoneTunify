//
//  selectedAchievementViewController.h
//  TunifyIPhone
//
//  Created by thesis on 10/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface selectedAchievementViewController : UIViewController {
	NSString *achievementName;
	NSString *achievementDescription;
	NSInteger achievementNumber;
	BOOL *achieved;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *locationLabel;
	//IBOutlet UIImageView *imageView;
	
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *facebookButton;
}

@property (nonatomic, retain) NSString *achievementName;
@property (nonatomic, retain) NSString *achievementDescription;
@property (assign) NSInteger achievementNumber;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
//@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (assign) BOOL *achieved;

- (void)btnAchievements_clicked:(id)sender;
- (IBAction)btnTwitter_clicked:(id)sender;
- (IBAction)btnFacebook_clicked:(id)sender;
- (void)postToFacebook;

@end
