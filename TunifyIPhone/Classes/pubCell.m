//
//  pubCell.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pubCell.h"


@implementation pubCell

@synthesize nameLabel;
@synthesize distanceLabel;
@synthesize ratingLabel;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize playButton;
@synthesize infoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		nameLabel = [[UILabel alloc]init];
		nameLabel.textAlignment = UITextAlignmentLeft;
		nameLabel.font = [UIFont systemFontOfSize:16];
		distanceLabel = [[UILabel alloc]init];
		distanceLabel.textAlignment = UITextAlignmentLeft;
		distanceLabel.font = [UIFont systemFontOfSize:16];
		ratingLabel = [[UILabel alloc]init];
		ratingLabel.textAlignment = UITextAlignmentLeft;
		ratingLabel.font = [UIFont systemFontOfSize:16];
		
		star1 = [[UIImageView alloc]init];
		star2 = [[UIImageView alloc]init];
		star3 = [[UIImageView alloc]init];
		star4 = [[UIImageView alloc]init];
		star5 = [[UIImageView alloc]init];
		
		playButton = [[UIButton buttonWithType:UIButtonTypeCustom] init];
		infoButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] init];
		
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:distanceLabel];
		[self.contentView addSubview:ratingLabel];
		[self.contentView addSubview:star1];
		[self.contentView addSubview:star2];
		[self.contentView addSubview:star3];
		[self.contentView addSubview:star4];
		[self.contentView addSubview:star5];
		[self.contentView addSubview:playButton];
		[self.contentView addSubview:infoButton];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX+10 ,5, 200, 25);
	nameLabel.frame = frame;
	frame = CGRectMake(boundsX+10 ,30, 200, 25);
	distanceLabel.frame = frame;
	frame = CGRectMake(boundsX+10 ,55, 60, 25);
	ratingLabel.frame = frame;
	
	frame = CGRectMake(boundsX+70 ,60, 17.3, 17.3);
	star1.frame = frame;
	frame = CGRectMake(boundsX+90 ,60, 17.3, 17.3);
	star2.frame = frame;
	frame = CGRectMake(boundsX+110 ,60, 17.3, 17.3);
	star3.frame = frame;
	frame = CGRectMake(boundsX+130 ,60, 17.3, 17.3);
	star4.frame = frame;
	frame = CGRectMake(boundsX+150 ,60, 17.3, 17.3);
	star5.frame = frame;
	
	frame = CGRectMake(boundsX+230 ,40, 25, 25);
	playButton.frame = frame;
	frame = CGRectMake(boundsX+280 ,40, 25, 25);
	infoButton.frame = frame;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[nameLabel release];
	[distanceLabel release];
	[ratingLabel release];
	[star1 release];
	[star2 release];
	[star3 release];
	[star4 release];
	[star5 release];
	[playButton release];
	[infoButton release];
    [super dealloc];
}


@end
