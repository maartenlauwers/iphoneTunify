//
//  pubCell.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"
#import "StarView.h"

@interface pubCell : UITableViewCell {
	UILabel *nameLabel;
	UILabel *distanceLabel;
	UIImageView *ratingImage;
	UIImageView *visitorsImage;
	UILabel *visitorsLabel;

	StarView *stars;
	CellButton *playButton;
	CellButton *infoButton;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UIImageView *ratingImage;
@property (nonatomic, retain) UIImageView *visitorsImage;
@property (nonatomic, retain) UILabel *visitorsLabel;
@property (nonatomic, retain) StarView *stars;
@property (nonatomic, retain) CellButton *playButton;
@property (nonatomic, retain) CellButton *infoButton;

@end
