//
//  songCell.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "songCell.h"


@implementation songCell

@synthesize songTitle;
@synthesize songArtist;
@synthesize buyButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        songTitle = [[UILabel alloc]init];
		songTitle.textAlignment = UITextAlignmentLeft;
		songTitle.font = [UIFont systemFontOfSize:14];
		songArtist = [[UILabel alloc]init];
		songArtist.textAlignment = UITextAlignmentLeft;
		songArtist.font = [UIFont systemFontOfSize:14];

		buyButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		buyButton.titleLabel.textAlignment = UITextAlignmentCenter;
		buyButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[buyButton setTitle:@"Buy" forState:UIControlStateNormal];
		
		[self.contentView addSubview:songTitle];
		[self.contentView addSubview:songArtist];
		[self.contentView addSubview:buyButton];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX+10 ,5, 200, 25);
	songTitle.frame = frame;
	frame = CGRectMake(boundsX+10 ,30, 200, 25);
	songArtist.frame = frame;
	frame = CGRectMake(boundsX+240 ,15, 60, 30);
	buyButton.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
