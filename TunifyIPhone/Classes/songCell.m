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
@synthesize playButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        songTitle = [[UILabel alloc]init];
		songTitle.textAlignment = UITextAlignmentLeft;
		songTitle.font = [UIFont systemFontOfSize:14];
		songArtist = [[UILabel alloc]init];
		songArtist.textAlignment = UITextAlignmentLeft;
		songArtist.font = [UIFont systemFontOfSize:14];

		playButton = [[CellButton buttonWithType:UIButtonTypeCustom] init];
		
		[self.contentView addSubview:songTitle];
		[self.contentView addSubview:songArtist];
		[self.contentView addSubview:playButton];
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
	frame = CGRectMake(boundsX+230 ,12, 30, 30);
	playButton.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[songTitle release];
	[songArtist release];
	[playButton release];
    [super dealloc];
}


@end
