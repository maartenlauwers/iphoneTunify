//
//  pubVisitViewController.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"
#import "Pub.h"

@class rateStar;

@interface pubVisitViewController : UIViewController <FBSessionDelegate, FBDialogDelegate> {
	Pub *pub;
	IBOutlet UILabel *infoLabel;
	rateStar *star1;
	rateStar *star2;
	rateStar *star3;
	rateStar *star4;
	rateStar *star5;
	UIView *rateView;

}

@property (nonatomic, retain) Pub *pub;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) rateStar *star1;
@property (nonatomic, retain) rateStar *star2;
@property (nonatomic, retain) rateStar *star3;
@property (nonatomic, retain) rateStar *star4;
@property (nonatomic, retain) rateStar *star5;
@property (nonatomic, retain) UIView *rateView;

- (void) btnPubs_clicked:(id)sender;
- (void) btnRate_clicked:(id)sender;
- (void)showSuccess;
- (IBAction)btnTwitter_clicked:(id)sender;
- (IBAction)btnFacebook_clicked:(id)sender;
- (void)postToFacebook;
- (IBAction)btnMusic_clicked:(id)sender;


@end
