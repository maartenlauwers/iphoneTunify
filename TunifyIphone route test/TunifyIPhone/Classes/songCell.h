//
//  songCell.h
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface songCell : UITableViewCell {
	UILabel *songTitle;
	UILabel *songArtist;
	CellButton *playButton;
}

@property (nonatomic, retain) UILabel *songTitle;
@property (nonatomic, retain) UILabel *songArtist;
@property (nonatomic, retain) CellButton *playButton;

@end
