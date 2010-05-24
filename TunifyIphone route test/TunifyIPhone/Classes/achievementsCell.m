//
//  achievementsCell.m
//  TunifyIPhone
//
//  Created by thesis on 25/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "achievementsCell.h"


@implementation achievementsCell

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize label1;
@synthesize label2;
@synthesize label3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		button1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		button2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		button3 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
		label1 = [[UILabel alloc]init];
		label1.textAlignment = UITextAlignmentCenter;
		label1.font = [UIFont systemFontOfSize:12];
		
		label2 = [[UILabel alloc]init];
		label2.textAlignment = UITextAlignmentCenter;
		label2.font = [UIFont systemFontOfSize:12];
		
		label3 = [[UILabel alloc]init];
		label3.textAlignment = UITextAlignmentCenter;
		label3.font = [UIFont systemFontOfSize:12];
		
		[self.contentView addSubview:button1];
		[self.contentView addSubview:button2];
		[self.contentView addSubview:button3];
		
		[self.contentView addSubview:label1];
		[self.contentView addSubview:label2];
		[self.contentView addSubview:label3];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat boundsX = 0;
	CGRect frame;
	
	frame = CGRectMake(boundsX+20 ,20, 64, 64);
	button1.frame = frame;
	frame = CGRectMake(boundsX+130 ,20, 64, 64);
	button2.frame = frame;
	frame = CGRectMake(boundsX+236 ,20, 64, 64);
	button3.frame = frame;
	
	frame = CGRectMake(boundsX - 10, 90, 120, 15);
	label1.frame = frame;
	frame = CGRectMake(boundsX+100 ,90, 120, 15);
	label2.frame = frame;
	frame = CGRectMake(boundsX+210 ,90, 120, 15);
	label3.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}


@end
