//
//  visitCell.m
//  TunifyIPhone
//
//  Created by Elegia on 11/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "visitCell.h"


@implementation visitCell

@synthesize friendIcon;
@synthesize friendLabel;
@synthesize inviteButton;
@synthesize achievementsButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		friendLabel = [[UILabel alloc]init];
		friendLabel.textAlignment = UITextAlignmentLeft;
		friendLabel.font = [UIFont systemFontOfSize:16];
		//[friendLabel setBackgroundColor:[[UIColor alloc] initWithRed:1.0 green:0.8 blue:0.4 alpha:0.0]];
		
		friendIcon = [[UIImageView alloc] init];
		[friendIcon setImage:[UIImage imageNamed:@"visitors.png"]];
		
		inviteButton = [[CellButton buttonWithType:UIButtonTypeCustom] init];
		achievementsButton = [[CellButton buttonWithType:UIButtonTypeCustom] init];
		
		[self.contentView addSubview:friendLabel];
		[self.contentView addSubview:friendIcon];
		[self.contentView addSubview:inviteButton];
		[self.contentView addSubview:achievementsButton];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX+50, 7, 200, 25);
	friendLabel.frame = frame;
	frame = CGRectMake(boundsX+10, 7, 18, 25);
	friendIcon.frame = frame;
	frame = CGRectMake(boundsX+220, 7, 21, 25);
	inviteButton.frame = frame;
	frame = CGRectMake(boundsX+270, 7, 24, 24);
	achievementsButton.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	[friendLabel release];
	[friendIcon release];
	[inviteButton release];
	//[achievementsButton release];
    [super dealloc];
}

@end
