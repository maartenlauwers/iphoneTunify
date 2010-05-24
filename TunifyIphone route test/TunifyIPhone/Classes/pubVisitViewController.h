//
//  pubVisitViewController.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Achievement.h"
#import "FBConnect/FBConnect.h"
#import "Pub.h"
#import "visitCell.h"
#import "selectedAchievementViewController.h"
#import "RateStar.h"

//@class rateStar;

@interface pubVisitViewController : UIViewController <RateStarDelegate, FBSessionDelegate, FBDialogDelegate> {
	Pub *pub;
	NSMutableArray *dataSource;
	
	UILabel *achievementLabel;
	UILabel *achievementNameLabel;
	UIButton *achievementButton;
	
	IBOutlet UILabel *friendsLabel;
	IBOutlet UILabel *shareLabel;
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *facebookButton;
	IBOutlet UIImageView *friendsImage;
	
	RateStar *star1;
	RateStar *star2;
	RateStar *star3;
	RateStar *star4;
	RateStar *star5;
	UIView *rateView;
	
	Achievement *achievementReached;

}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, retain) UILabel *achievementLabel;
@property (nonatomic, retain) UILabel *achievementNameLabel;
@property (nonatomic, retain) UIButton *achievementButton;

@property (nonatomic, retain) IBOutlet UILabel *friendsLabel;
@property (nonatomic, retain) IBOutlet UILabel *shareLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, retain) IBOutlet UIImageView *friendsImage;

@property (nonatomic, retain) RateStar *star1;
@property (nonatomic, retain) RateStar *star2;
@property (nonatomic, retain) RateStar *star3;
@property (nonatomic, retain) RateStar *star4;
@property (nonatomic, retain) RateStar *star5;
@property (nonatomic, retain) UIView *rateView;

@property (nonatomic, retain) Achievement *achievementReached;

- (void) inviteButton_clicked:(id)sender;
- (void) achievementsButton_clicked:(id)sender;
- (void) btnPubs_clicked:(id)sender;
- (void) btnRate_clicked:(id)sender;
- (void)showSuccess;
- (IBAction)btnTwitter_clicked:(id)sender;
- (IBAction)btnFacebook_clicked:(id)sender;
- (void)postToFacebook;
- (IBAction)btnMusic_clicked:(id)sender;


@end
