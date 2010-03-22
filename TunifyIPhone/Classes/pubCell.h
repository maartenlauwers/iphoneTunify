//
//  pubCell.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface pubCell : UITableViewCell {
	UILabel *nameLabel;
	UILabel *distanceLabel;
	UILabel *ratingLabel;
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
	CellButton *playButton;
	CellButton *infoButton;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *ratingLabel;
@property (nonatomic, retain) UIImageView *star1;
@property (nonatomic, retain) UIImageView *star2;
@property (nonatomic, retain) UIImageView *star3;
@property (nonatomic, retain) UIImageView *star4;
@property (nonatomic, retain) UIImageView *star5;
@property (nonatomic, retain) CellButton *playButton;
@property (nonatomic, retain) CellButton *infoButton;

@end
