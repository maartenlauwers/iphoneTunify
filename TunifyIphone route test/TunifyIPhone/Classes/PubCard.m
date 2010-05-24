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
@synthesize iconButton;

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
		
		self.frame = CGRectMake(0, 0, 60, 60);
		//self.center = CGPointMake(160, 250);
		self.opaque = FALSE;
		self.backgroundColor = [UIColor clearColor];
		
		iconButton = [[UIButton buttonWithType:UIButtonTypeCustom] init];
		iconButton.contentMode = UIViewContentModeScaleToFill;
		[iconButton setBackgroundImage:[UIImage imageNamed:@"Settler.png"] forState:UIControlStateNormal];
		[iconButton addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
		iconButton.frame = CGRectMake(0, 0, 60, 60);
		
		[self addSubview:iconButton];

	}
	
	//[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

- (void)setPosition:(float)x y:(float)y {
	self.center = CGPointMake(x, y);
}

- (float)getX {
	return self.center.x;
}


- (void)setSize:(float)theWidth height:(float)theHeight {
	
	if (theWidth > 60 || theHeight > 60) {
		iconButton.frame = CGRectMake((theWidth - 60)/2, (theHeight - 60), theWidth, theHeight);
	} else {
		iconButton.frame = CGRectMake((60 - theWidth)/2, (60 - theHeight), theWidth, theHeight);
	}
}

- (float)getWidth {
	return iconButton.frame.size.width;
}

- (float)getHeight {
	return iconButton.frame.size.height;
}

- (void)setHeading:(float)theHeading {
	heading = theHeading;
}

- (float)getHeading {
	return heading;
}

- (void)setDistance:(double)theDistance {
	distance = theDistance;
}

- (double)getDistance {
	return distance;
}

- (void)updateSizeByDistance {
	
	// Scale our view based on the distance from the user
	// Round to one kilometre
	NSString *strDistance = [NSString stringWithFormat:@"%f", self.distance];
	double firstNumber = [[strDistance substringToIndex:1] doubleValue];
	double secondNumber = [[strDistance substringWithRange:NSMakeRange(1, 1)] doubleValue];

	double distanceInKm = 0;
	if(secondNumber >= 5) { 
		distanceInKm = firstNumber + 1;
	} else {
		distanceInKm = firstNumber;
	}
	
	NSLog(@"Distance in km: %f", distanceInKm);
	if (distanceInKm == 5) {
		[self setSize:60 height:60];
	} else {
		NSLog(@"UPDATING SIZE");
		float newWidth = 0;
		float newHeight = 0;
		if(distanceInKm > 5) {
			newWidth = 60 - ((distanceInKm - 5) * 5);
			newHeight = 60 - ((distanceInKm - 5) * 5);
		} else if(distanceInKm < 5) {
			newWidth = 60 + ((5 - distanceInKm) * 5);
			newHeight = 60 + ((5 - distanceInKm) * 5);
		}
		NSLog(@"width: %f", newWidth);
		NSLog(@"height: %f", newHeight);
		[self setSize:newWidth height:newHeight];
	}
	
}

- (void)updateSizeByRating {
	if (self.rating == 2.5) {
		[self setSize:60 height:60];
	} else {
		NSLog(@"UPDATING SIZE");
		float newWidth = 0;
		float newHeight = 0;
		if(self.rating > 2.5) {
			newWidth = 60 + ((self.rating - 2.5) * 5);
			newHeight = 60 + ((self.rating - 2.5) * 5);
		} else if(self.rating < 2.5) {
			newWidth = 60 - ((2.5 - self.rating) * 5);
			newHeight = 60 - ((2.5 - self.rating) * 5);
		}
		NSLog(@"width: %f", newWidth);
		NSLog(@"height: %f", newHeight);
		[self setSize:newWidth height:newHeight];
	}
}

- (void)updateSizeByVisitors:(double)maxVisitors {

	
	if (self.visitors == maxVisitors/2) {
		[self setSize:60 height:60];
	} else {
		NSLog(@"UPDATING SIZE");
		float newWidth = 0;
		float newHeight = 0;
		if(self.visitors > maxVisitors/2) {
			newWidth = 85;
			newHeight = 85;
			//newWidth = 60 - ((distanceInKm - 5) * 5);
			//newHeight = 60 - ((distanceInKm - 5) * 5);
		} else if(self.visitors < maxVisitors/2) {
			newWidth = 35;
			newHeight = 35;
			//newWidth = 60 + ((5 - distanceInKm) * 5);
			//newHeight = 60 + ((5 - distanceInKm) * 5);
		}
		NSLog(@"width: %f", newWidth);
		NSLog(@"height: %f", newHeight);
		[self setSize:newWidth height:newHeight];
	}
	
	
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
