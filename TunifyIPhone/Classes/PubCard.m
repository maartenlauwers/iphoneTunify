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
@synthesize pub;
@synthesize visible;
@synthesize heading;
@synthesize distance;
@synthesize delegate;

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

//- (id)initWithPub:(NSString *)pubName pubAddress:(NSString *)pubAddress pubVisitors:(NSInteger *)pubVisitors pubRating:(NSInteger *)pubRating {
	
- (id)initWithPub:(Pub *)thePub {
	if ((self = [super init])) {
		
		self.visible = FALSE;
		
		self.pub = thePub;
		self.name = [pub name];
		self.address = [pub address];
		self.visitors = [[pub visitors] intValue];
		self.rating = [[pub rating] intValue];
		
		self.frame = CGRectMake(0, 0, 200, 90);
		self.center = CGPointMake(160, 250);
		self.opaque = FALSE;
		self.backgroundColor = [UIColor clearColor];

		
		UIButton *iconButton = [[UIButton buttonWithType:UIButtonTypeCustom] init];
		[iconButton setImage:[UIImage imageNamed:@"achievement5.png"] forState:UIControlStateNormal];
		[iconButton addTarget:self	action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
		iconButton.frame = CGRectMake(71, 5, 59, 60);
		
		//UILabel* pubName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 25)];
		UILabel* pubName = [[UILabel alloc] initWithFrame:CGRectMake(5, 64, 190, 25)];
		pubName.text = self.name;
		pubName.textAlignment = UITextAlignmentCenter;
		pubName.font = [UIFont systemFontOfSize:14];
		pubName.adjustsFontSizeToFitWidth = NO;
		pubName.textColor = [UIColor blackColor];
		pubName.opaque = FALSE;
		pubName.backgroundColor = [UIColor clearColor];
		
		/*
		UILabel* pubAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 26, 190, 25)];
		pubAddress.text = self.address;
		pubAddress.textAlignment = UITextAlignmentLeft;
		pubAddress.font = [UIFont systemFontOfSize:12];
		pubAddress.adjustsFontSizeToFitWidth = NO;
		pubAddress.textColor = [UIColor blackColor];
		pubAddress.backgroundColor = [UIColor lightGrayColor];
		
		UILabel* pubVisitors = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 190, 25)];
		pubVisitors.text = [NSString stringWithFormat:@"Visitors: %d", self.visitors];
		pubVisitors.textAlignment = UITextAlignmentLeft;
		pubVisitors.font = [UIFont systemFontOfSize:12];
		pubVisitors.adjustsFontSizeToFitWidth = NO;
		pubVisitors.textColor = [UIColor blackColor];
		pubVisitors.backgroundColor = [UIColor lightGrayColor];
		*/
		//StarView *stars = [[StarView alloc] initWithRating:CGRectMake(60, 65, 80, 25) rating:self.rating];
		StarView *stars = [[StarView alloc] initWithRating:CGRectMake(60, 80, 80, 25) rating:self.rating];
		stars.opaque = FALSE;
		stars.backgroundColor = [UIColor clearColor];
		
		[self addSubview:iconButton];
		[self addSubview:pubName];	
		//[self addSubview:pubAddress];
		//[self addSubview:pubVisitors];
		[self addSubview:stars];
	}
	
	//[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

- (void)setPosition:(float)x y:(float)y {
	self.center = CGPointMake(x, y);
}

- (void)setSize:(float)theWidth height:(float)theHeight {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, theWidth, theHeight);
}

- (void)setHeading:(float)theHeading {
	heading = theHeading;
}

- (float)getHeading {
	return heading;
}

- (void)setDistance:(double)theDistance {
	distance = theDistance;
	
	// Scale our view based on the distance from the user
	// Round to one kilometre
	NSString *strDistance = [NSString stringWithFormat:@"%f", distance];
	double firstNumber = [[strDistance substringToIndex:1] doubleValue];
	double secondNumber = [[strDistance substringWithRange:NSMakeRange(1, 1)] doubleValue];
	
	if(secondNumber >= 5) { 
		[self updateSize:(firstNumber + 1)];
	} else {
		[self updateSize:firstNumber];
	}
	
}

- (double)getDistance {
	return distance;
}

- (void)updateSize:(double)distanceInKm {
	// assuming we rescale the entire view
	// max size = 300, 135
	// base size = 200, 90
	// min size = 100, 45 
	// 5 kilometres = base size
	
	if (distanceInKm == 5) {
		[self setSize:200 height:90];
	} else {
		float newWidth = 0;
		float newHeight = 0;
		if(distanceInKm > 5) {
			newWidth = 200 + ((distanceInKm - 5) * 20);
			newHeight = 90 + ((distanceInKm - 5) * 9);
		} else if(distanceInKm < 5) {
			newWidth = 200 - (distanceInKm * 20);
			newHeight = 90 - (distanceInKm * 9);
		}
		[self setSize:newWidth height:newHeight];
	}
	
	// assuming we rescale the icon only
	// base size = 59, 60
	// 5 kilometres = base size
}

- (void)button_clicked:(id)sender {
	NSLog(@"Button clicked!");
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cardClicked:)]) {
		[delegate cardClicked:self];
	} 
}

- (void)dealloc {
	delegate = nil;
	[delegate release];
	[name release];
	[address release];
	[pub release];
	[super dealloc];
}

@end
