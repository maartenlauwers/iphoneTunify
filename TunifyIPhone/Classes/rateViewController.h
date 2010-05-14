//
//  rateViewController.h
//  TunifyIPhone
//
//  Created by thesis on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface rateViewController : UIViewController {
	IBOutlet UIImageView *star1;
	IBOutlet UIImageView *star2;
	IBOutlet UIImageView *star3;
	IBOutlet UIImageView *star4;
	IBOutlet UIImageView *star5;
	IBOutlet UIButton *cancelButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *star1;
@property (nonatomic, retain) IBOutlet UIImageView *star2;
@property (nonatomic, retain) IBOutlet UIImageView *star3;
@property (nonatomic, retain) IBOutlet UIImageView *star4;
@property (nonatomic, retain) IBOutlet UIImageView *star5;

-(IBAction) cancelButton_clicked:(id)sender;
@end
