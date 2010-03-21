//
//  pubCard.m
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PubCard.h"


@implementation PubCard

@synthesize name;
@synthesize address;
@synthesize visitors;
@synthesize rating;

- (id)init
{
	if ((self = [super init])) {
		
    }
	
	return self;	
}

- (id)initWithFrame:(CGRect)aRect
{
	if ((self = [super initWithFrame:aRect])) {
		
    }
	
	return self;	
}

- (id)initWithPub:(NSString *)pubName pubAddress:(NSString *)pubAddress pubVisitors:(NSInteger *)pubVisitors pubRating:(NSInteger *)pubRating {
	if ((self = [super init])) {
		
		self.name = pubName;
		self.address = pubAddress;
		self.visitors = pubVisitors;
		self.rating = pubRating;
		
		self.frame = CGRectMake(0, 0, 200, 90);
		self.center = CGPointMake(160, 250);
		self.backgroundColor = [UIColor lightGrayColor];
		
		UILabel* pubName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 20)];
		pubName.text = self.name;
		pubName.textAlignment = UITextAlignmentLeft;
		pubName.font = [UIFont systemFontOfSize:14];
		pubName.adjustsFontSizeToFitWidth = NO;
		pubName.textColor = [UIColor blackColor];
		pubName.backgroundColor = [UIColor lightGrayColor];
		
		UILabel* pubAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 21, 190, 20)];
		pubAddress.text = self.address;
		pubAddress.textAlignment = UITextAlignmentLeft;
		pubAddress.font = [UIFont systemFontOfSize:12];
		pubAddress.adjustsFontSizeToFitWidth = NO;
		pubAddress.textColor = [UIColor blackColor];
		pubAddress.backgroundColor = [UIColor lightGrayColor];
		
		UILabel* pubVisitors = [[UILabel alloc] initWithFrame:CGRectMake(5, 37, 190, 20)];
		pubVisitors.text = [NSString stringWithFormat:@"Visitors: %d", self.visitors];
		pubVisitors.textAlignment = UITextAlignmentLeft;
		pubVisitors.font = [UIFont systemFontOfSize:12];
		pubVisitors.adjustsFontSizeToFitWidth = NO;
		pubVisitors.textColor = [UIColor blackColor];
		pubVisitors.backgroundColor = [UIColor lightGrayColor];
		
		StarView *stars = [[StarView alloc] initWithRating:CGRectMake(0, 60, 190, 25) rating:self.rating];
		stars.backgroundColor = [UIColor lightGrayColor];
		
		[self addSubview:pubName];	
		[self addSubview:pubAddress];
		[self addSubview:pubVisitors];
		[self addSubview:stars];
	}
	
	return self;
}

- (void)setPosition:(float)x y:(float)y {
	self.center = CGPointMake(x, y);
}

- (void)dealloc {
	[name release];
	[address release];
	[super dealloc];
}

@end
