//
//  visitCell.h
//  TunifyIPhone
//
//  Created by Elegia on 11/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface visitCell : UITableViewCell {

	UIImageView *friendIcon;
	UILabel *friendLabel;
	CellButton *inviteButton;
	CellButton *achievementsButton;
}

@property (nonatomic, retain) UIImageView *friendIcon;
@property (nonatomic, retain) UILabel *friendLabel;
@property (nonatomic, retain) CellButton *inviteButton;
@property (nonatomic, retain) CellButton *achievementsButton;

@end
