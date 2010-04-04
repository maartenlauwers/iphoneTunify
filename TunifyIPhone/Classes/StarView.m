//
//  StarView.m
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StarView.h"


@implementation StarView
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.star1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 13, 13)];
		self.star1.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 13, 13)];
		self.star2.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star3 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 13, 13)];
		self.star3.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star4 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 13, 13)];
		self.star4.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star5 = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, 13, 13)];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
		
		[self addSubview:self.star1];
		[self addSubview:self.star2];
		[self addSubview:self.star3];
		[self addSubview:self.star4];
		[self addSubview:self.star5];
    }
    return self;
}

- (id)initWithRating:(CGRect)frame rating:(NSInteger *)theRating {
    if (self = [super initWithFrame:frame]) {
		
		rating = theRating;
		
        self.star1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 13, 13)];
		self.star2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 13, 13)];
		self.star3 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 13, 13)];
		self.star4 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 13, 13)];
		self.star5 = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, 13, 13)];
		
		[self addSubview:self.star1];
		[self addSubview:self.star2];
		[self addSubview:self.star3];
		[self addSubview:self.star4];
		[self addSubview:self.star5];
		
		[self setRating:theRating];
    }
    return self;
}

- (void)setRating:(NSInteger *)theRating {
	rating = theRating;
	
	if (rating == 0) {
		self.star1.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
	} else if(rating == 1) {
		self.star1.image = [UIImage imageNamed:@"star_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
	} else if(rating == 2) {
		self.star1.image = [UIImage imageNamed:@"star_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
	} else if(rating == 3) {
		self.star1.image = [UIImage imageNamed:@"star_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_light_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
	} else if(rating == 4) {
		self.star1.image = [UIImage imageNamed:@"star_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_light_small.png"];
	} else {
		self.star1.image = [UIImage imageNamed:@"star_small.png"];
		self.star2.image = [UIImage imageNamed:@"star_small.png"];
		self.star3.image = [UIImage imageNamed:@"star_small.png"];
		self.star4.image = [UIImage imageNamed:@"star_small.png"];
		self.star5.image = [UIImage imageNamed:@"star_small.png"];
	}
}

- (NSInteger *)getRating {
	return rating;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
