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
@synthesize ratingImage;
@synthesize visitorsImage;
@synthesize visitorsLabel;
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
		ratingImage = [[UIImageView alloc] init];
		[ratingImage setImage:[UIImage imageNamed:@"beermug.png"]];
		visitorsImage = [[UIImageView alloc] init];
		[visitorsImage setImage:[UIImage imageNamed:@"visitors.png"]];
		visitorsLabel = [[UILabel alloc] init];
		visitorsLabel.textAlignment = UITextAlignmentLeft;
		visitorsLabel.font = [UIFont systemFontOfSize:16];
		
		stars = [[StarView alloc] initWithFrame:CGRectMake(30 ,60, 90, 17.3)];
		[stars setBackgroundColor:[UIColor whiteColor]];
		
		playButton = [[CellButton buttonWithType:UIButtonTypeCustom] init];
		infoButton = [[CellButton buttonWithType:UIButtonTypeInfoDark] init];
		
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:distanceLabel];
		[self.contentView addSubview:ratingImage];
		[self.contentView addSubview:visitorsImage];
		[self.contentView addSubview:visitorsLabel];
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
	frame = CGRectMake(boundsX+10 ,60, 21, 25);
	ratingImage.frame = frame;
	frame = CGRectMake(boundsX+130 ,60, 18, 25);
	visitorsImage.frame = frame;
	frame = CGRectMake(boundsX+155, 60, 50, 20);
	visitorsLabel.frame = frame;

	frame = CGRectMake(boundsX+230 ,30, 30, 30);
	playButton.frame = frame;
	frame = CGRectMake(boundsX+280 ,31, 25, 25);
	infoButton.frame = frame;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[nameLabel release];
	[distanceLabel release];
	[ratingImage release];
	[visitorsImage release];
	[visitorsLabel release];
	[stars release];
	[playButton release];
	[infoButton release];
    [super dealloc];
}


@end
