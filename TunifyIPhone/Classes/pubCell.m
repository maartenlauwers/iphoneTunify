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
@synthesize stars;
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
		
		
		stars = [[StarView alloc] initWithFrame:CGRectMake(65 ,57, 100, 17.3)];
		[stars setBackgroundColor:[UIColor whiteColor]];
		
		playButton = [[CellButton buttonWithType:UIButtonTypeCustom] init];
		infoButton = [[CellButton buttonWithType:UIButtonTypeInfoDark] init];
		
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:distanceLabel];
		[self.contentView addSubview:ratingLabel];
		[self.contentView addSubview:stars];
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
	[stars release];
	[playButton release];
	[infoButton release];
    [super dealloc];
}


@end
