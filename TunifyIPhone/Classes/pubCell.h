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
	UILabel *ratingLabel;

	StarView *stars;
	CellButton *playButton;
	CellButton *infoButton;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *ratingLabel;
@property (nonatomic, retain) StarView *stars;
@property (nonatomic, retain) CellButton *playButton;
@property (nonatomic, retain) CellButton *infoButton;

@end
