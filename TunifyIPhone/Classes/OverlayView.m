//
//  OverlayView.m
//  TunifyIPhone
//
//  Created by thesis on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

#define DEFAULT_HORIZON_HEIGHT 350

@implementation OverlayView
@synthesize delegate;
@synthesize horizonHeight;
@synthesize rotation;
@synthesize cardView;
@synthesize cardSource;
@synthesize selectedPub;
@synthesize sortState;

- (id)init
{
	if ((self = [super init])) {
		NSLog(@"============================");
		NSLog(@"ALL INITED");
		NSLog(@"============================");
		[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
		self.horizonHeight = 0;
		self.sortState = 1;
		/*
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didRotate:)
												 name:UIDeviceOrientationDidChangeNotification
												 object:nil];
		 */
    }
	
	return self;	
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
		NSLog(@"initWithFrame");
		
    }
    return self;
}

-(void)button_clicked:(id)sender {
	[self viewClicked];
}

/*
- (void)drawRect:(CGRect)rect
{
	
	// Start by getting your context, you will need it
	// for the rest of the drawing functions.
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Rotate around the screen center
	//CGContextTranslateCTM(context, 160, 240);
	//CGContextRotateCTM(context, self.rotation);
	//CGContextTranslateCTM(context, -160, -240);
	
	// This array holds all of the points to be put into the context.
	CGPoint points[2];
	points[0] = CGPointMake (-300.0, self.horizonHeight);
	points[1] = CGPointMake (720.0, self.horizonHeight);
	
	
	
	// Set background color of the context to white.
	// Arguments 2, 3, and 4 represent red, green, and blue, respectively.
	// The last argument is the opacity.
	// The value ranges are between 0.0 and 1.0.
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);
	
	// Paint the base of the context.
	CGContextFillRect(context, rect);
	
	// Set color of the lines to black, with full opacity.
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	
	CGContextSetLineWidth(context, 2);
	
	// Add the coordinates of the lines to the context.
	// The last argument is the number of elements in the array.
	CGContextAddLines(context, points, 2);
	
	// Connect the end of the last line to the first
	// to close the triangle.
	CGContextClosePath(context);
	
	// Finally draw your lines.
	CGContextStrokePath(context);
}
*/
-(void)updateHorizon:(float)height {
	self.horizonHeight = DEFAULT_HORIZON_HEIGHT + height;
	//[self setNeedsDisplay];
}

-(float)getHorizon {
	return DEFAULT_HORIZON_HEIGHT + self.horizonHeight;
}


-(void)updateRotation:(float)theRotation {
	/*
	self.rotation = theRotation;
	//[self setNeedsDisplay];
	

	
	// Anchorpoint coords are between 0.0 and 1.0
	//self.layer.anchorPoint = CGPointMake(160/sz.width, 240/sz.height);
	
	for(PubCard *pubCard in self.cardSource) {
			[UIView beginAnimations:@"rotate" context:nil];
			//pubCard.transform = CGAffineTransformMakeRotation( theRotation / 180. * 3.14 );
			//pubCard.transform = CGAffineTransformMakeTranslation(160, 240);
			pubCard.transform = CGAffineTransformMakeRotation( theRotation);
			//pubCard.transform = CGAffineTransformMakeTranslation(-160, -240);
			[pubCard setPosition:[pubCard getX] y:[pubCard getY]];
			[UIView commitAnimations];
	}
	 
	[self setNeedsDisplay];
	 */
}

- (void)createPubCards:(NSMutableArray *)dataSource {
	
	self.cardSource = [[NSMutableArray alloc] init];
	int i = 0;
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	CLLocation *userLocation = [ct userLocation];
	for(Pub *pub in dataSource) {
		PubCard *card =  [[PubCard alloc] initWithPub:pub];
		[card setPosition:-500 y:-500];
		card.visible = FALSE;
		[card setHeading:-1];
		
		// Get our distance from the pub
		CLLocation *myPubLocation = [[CLLocation alloc] initWithLatitude:[[pub latitude] floatValue] longitude:[[pub longitude] floatValue]];		
		double distance = [ct fetchDistance:userLocation locationB:myPubLocation];
		[card setDistance:distance];
		
		card.delegate = self;
		[self insertSubview:card atIndex:i];
		[self.cardSource addObject:card];
		i++;
	}
	
}

- (void)updateAllHeadings {
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	CLLocation *userLocation = [ct userLocation];
	
	for(PubCard *pubCard in self.cardSource) {
		// Update heading
		float heading = [self calculatePubHeading:[pubCard pub]];
		[pubCard setHeading:heading];
		
		// Update distance
		CLLocation *myPubLocation = [[CLLocation alloc] initWithLatitude:[[pubCard.pub latitude] floatValue] longitude:[[pubCard.pub longitude] floatValue]];		
		double distance = [ct fetchDistance:userLocation locationB:myPubLocation];
		[pubCard setDistance:distance];
		
	}
}

- (void)updateCards {
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	
	int cardScreenIndex = 0;
	int validIntervalInDegrees = 80;
	
	for(PubCard *pubCard in self.cardSource) {
		float heading = [pubCard getHeading];
		
		// Check if a correct heading was initialized
		if(heading != -1) {
			float newHeading = heading - [ct getHeading];
			
			BOOL isValidHeading = FALSE;
			if(heading < 40) {
				if((360 - [ct getHeading]) <= heading) {
					isValidHeading = TRUE;
				}
			} else if (heading > 320) {
				if(((360 - heading) + [ct getHeading]) <= 40) {
					isValidHeading = TRUE;
				}
			}
			
			if( ((newHeading <= validIntervalInDegrees/2) && (newHeading >= -(validIntervalInDegrees/2))) || (isValidHeading == TRUE)) {

				int localHeadingOffset = 0;
				if (newHeading < 0) {
					localHeadingOffset = validIntervalInDegrees/2 - (newHeading * -1);
				} else {
					localHeadingOffset = newHeading + validIntervalInDegrees/2;
				}
				
				// Show the pub
				pubCard.visible = TRUE;
				//if(self.inLandScapeMode == TRUE) {
				//	[pubCard setPosition:-500 y:(localHeadingOffset*6.5 - 100)];
				//} else {
					[pubCard setPosition:(localHeadingOffset*6.5 - 100) y:-500];
				//}


				cardScreenIndex++;
				
			} else {
				if(pubCard.visible == TRUE) {
					[pubCard setPosition:-500 y:-500];
				}
				pubCard.visible = FALSE;
				
			}
		}
	}
	
	[self layoutCards];
}

- (void)filterByDistance {
	self.sortState = 1;
}
- (void)filterByRating {
	self.sortState = 2;
}
- (void)filterByVisitors {
	self.sortState = 3;
}

- (void)layoutCards {
	
	if (sortState == 1) {
		for(PubCard *pubCard in self.cardSource) {
			[pubCard updateSizeByDistance];
		}
	} else if (sortState == 2) {
		for(PubCard *pubCard in self.cardSource) {
			[pubCard updateSizeByRating];
		}
	} else if (sortState == 3) {
		double maxVisitors = 0;
		for(PubCard *pubCard in self.cardSource) {
			if(pubCard.visitors > maxVisitors) {
				maxVisitors = pubCard.visitors;
			} 
		}
		
		for(PubCard *pubCard in self.cardSource) {			
			[pubCard updateSizeByVisitors:maxVisitors];
		}
	}
	
	NSMutableArray *stacksArray = [[NSMutableArray alloc] init];
	NSMutableArray *cardsArray = [[NSMutableArray alloc] init];
	
	// Create stacks of overlapping cards
	for (PubCard *pubCard in self.cardSource) {
		if (! [cardsArray containsObject:pubCard]) {
			if (pubCard.visible) {
				NSMutableArray *stackArray = [[NSMutableArray alloc] initWithObjects:pubCard, nil];
				
				// Compare each pubcard to every other pubcard to find those that will overlap with it.
				for (PubCard *neighbour in self.cardSource) {
					if (neighbour.visible && neighbour != pubCard) {
						if (([pubCard getX] >= [neighbour getX] - 30) && ([pubCard getX] <= [neighbour getX] + 30)) {
							[stackArray addObject:neighbour];
							[cardsArray addObject:neighbour];
						}
					}
				}
				[stacksArray addObject:stackArray];
			}
		}
		[cardsArray addObject:pubCard];
	}
	
	[cardsArray release];
	

	// Order the individual stacks depending on their size

		for (NSMutableArray *stackArray in stacksArray) {
			if ([stackArray count] > 1) {
				// Order the stack by pub distance/icon size
				NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
				for(PubCard *pubCard in stackArray) {
					
					// Initial entry
					if ([sortedArray count] == 0) {
						[sortedArray addObject:pubCard];
					} else {
						// Further entries
						if ([pubCard getWidth] <= [[sortedArray lastObject] getWidth]) {
							[sortedArray addObject:pubCard];
						} else if ([pubCard getWidth] >= [[sortedArray objectAtIndex:0] getWidth]) {
							[sortedArray insertObject:pubCard atIndex:0];
						} else {
							for(int i=0; i<[sortedArray count]; i++) {
								if ([pubCard getWidth] == [[sortedArray objectAtIndex:i] getWidth]) {
									[sortedArray insertObject:pubCard atIndex:i];
									break;
								} else if ([pubCard getWidth] < [[sortedArray objectAtIndex:i] getWidth] && [pubCard getWidth] > [[sortedArray objectAtIndex:i+1] getWidth]) {
									[sortedArray insertObject:pubCard atIndex:i+1];
									break;
								}
							} // end for loop
						}				
					}
					
					stackArray = sortedArray;
				}
			}
		}

	
		
	// Set the height of each card in each stack
	for (NSMutableArray *stackArray in stacksArray) {
		int i = 1;
		float totalHeight = 0;
		for (PubCard *pubCard in stackArray) {
			if ( i > 1) {
				[pubCard setPosition:[pubCard getX] y:(self.horizonHeight - totalHeight - [pubCard getHeight] - 15)];
			} else {
				[pubCard setPosition:[pubCard getX] y:(self.horizonHeight - totalHeight - [pubCard getHeight])];
			}
			
			totalHeight += [pubCard getHeight];
			i++;
		}
	}
}


- (float)calculatePubHeading:(Pub *)pub {
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	CLLocation *userLocation = [ct userLocation];
	
	float u2 = userLocation.coordinate.latitude;
	float u1 = userLocation.coordinate.longitude;
	float v2 = [[pub latitude] floatValue];		
	float v1 = [[pub longitude] floatValue];
	
	// Base vector
	float b1 = 0;
	float b2 = 1;
	
	// Normalize V
	float normV1 = v1 - u1;
	float normV2 = v2 - u2;	
	
	// Calculate the angle between the base vector (pointing north) and the pub location
	float uv = (b1*normV1) + (b2*normV2);
	float normU = sqrt(b1*b1 + b2*b2);
	float normV = sqrt(normV1*normV1 + normV2*normV2);
	float normMultiplication = normU * normV;
	float division = uv/normMultiplication;
	float resultRad = acos(division);
	float resultDeg = resultRad * (180/M_PI);
	
	// If our pub's longitude is smaller than the users, then the angle will be larger than 180 degrees.
	// However, the above method only returns angles smaller than or equal to 180, so we'll need to fix this ourselves.
	if (v1 < u1) {
		resultDeg = (180 - resultDeg) + 180;
	} 
	
	return resultDeg;
}


- (void)cardClicked:(id)sender {
	
	PubCard *card = (PubCard *)sender;
	self.selectedPub = [card pub];
	
	// Remove any already existing cardviews
	if(self.cardView != nil) {
		[self.cardView removeFromSuperview];
	}
	
	self.cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 370, 320, 130)];
	self.cardView.opaque = YES;
	self.cardView.backgroundColor = [UIColor lightGrayColor];
	
	UIButton *directionsButton = [[UIButton alloc] init];
	[directionsButton setImage:[UIImage imageNamed:@"3DMapsIcon.png"] forState:UIControlStateNormal];
	[directionsButton addTarget:self action:@selector(buttonDirectionClicked:) forControlEvents:UIControlEventTouchUpInside];
	directionsButton.frame = CGRectMake(250, 10, 59, 60);	
	
	
	UIButton *playMusicButton = [[UIButton alloc] init];
	[playMusicButton setImage:[UIImage imageNamed:@"3DPlayIcon.png"] forState:UIControlStateNormal];
	[playMusicButton addTarget:self action:@selector(buttonPlayMusicClicked:) forControlEvents:UIControlEventTouchUpInside];
	playMusicButton.frame = CGRectMake(10, 10, 59, 60);	
	
	
	UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 0, 180, 25)];
	nameLabel.text = [[card pub] name];
	nameLabel.textAlignment = UITextAlignmentCenter;
	nameLabel.font = [UIFont systemFontOfSize:14];
	nameLabel.adjustsFontSizeToFitWidth = NO;
	nameLabel.textColor = [UIColor blackColor];
	nameLabel.opaque = FALSE;
	nameLabel.backgroundColor = [UIColor clearColor];
	
	StarView *stars = [[StarView alloc] initWithRating:CGRectMake(120, 20, 80, 25) rating:[[[card pub] rating] intValue]];
	stars.opaque = FALSE;
	stars.backgroundColor = [UIColor clearColor];
	
	UILabel *address1Label = [[UILabel alloc] initWithFrame:CGRectMake(73, 40, 180, 25)];
	address1Label.text = [NSString stringWithFormat:@"%@ %@", [[card pub] street], [[card pub] number]];
	address1Label.textAlignment = UITextAlignmentCenter;
	address1Label.font = [UIFont systemFontOfSize:12];
	address1Label.adjustsFontSizeToFitWidth = NO;
	address1Label.textColor = [UIColor blackColor];
	address1Label.opaque = FALSE;
	address1Label.backgroundColor = [UIColor clearColor];
	
	UILabel *address2Label = [[UILabel alloc] initWithFrame:CGRectMake(73, 60, 180, 25)];
	address2Label.text = [NSString stringWithFormat:@"%@ %@", [[card pub] zipcode], [[card pub] city]];
	address2Label.textAlignment = UITextAlignmentCenter;
	address2Label.font = [UIFont systemFontOfSize:12];
	address2Label.adjustsFontSizeToFitWidth = NO;
	address2Label.textColor = [UIColor blackColor];
	address2Label.opaque = FALSE;
	address2Label.backgroundColor = [UIColor clearColor];
	
	UILabel *visitorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 200, 25)];
	visitorsLabel.text = [NSString stringWithFormat:@"Visitors: %@", [[card pub] visitors]];
	visitorsLabel.textAlignment = UITextAlignmentCenter;
	visitorsLabel.font = [UIFont systemFontOfSize:12];
	visitorsLabel.adjustsFontSizeToFitWidth = NO;
	visitorsLabel.textColor = [UIColor blackColor];
	visitorsLabel.opaque = FALSE;
	visitorsLabel.backgroundColor = [UIColor clearColor];
	
	
	[self.cardView insertSubview:playMusicButton atIndex:0];
	[self.cardView insertSubview:directionsButton atIndex:1];
	[self.cardView insertSubview:address1Label atIndex:2];
	[self.cardView insertSubview:address2Label atIndex:3];
	[self.cardView insertSubview:visitorsLabel atIndex:4];
	[self.cardView insertSubview:nameLabel atIndex:5];
	[self.cardView insertSubview:stars atIndex:6];
	
	[self insertSubview:self.cardView atIndex:20];
}


#pragma mark OverlayViewDelegateHandlers

- (void)viewClicked {
	
	[self.cardView removeFromSuperview];
}


#pragma mark popUpScreenButotnHandlers
-(void)buttonPlayMusicClicked:(id)sender {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buttonPlayMusicClicked:)]) {
		[delegate buttonPlayMusicClicked:self];
	} 
}

-(void)buttonDirectionClicked:(id)sender {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buttonDirectionClicked:)]) {
		[delegate buttonDirectionClicked:self];
	} 

}

/*
-(void)didRotate:(NSNotification *)theNotification {
	UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];

	if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
		NSLog(@"LANDSCAPE MODE");
		[UIView beginAnimations:@"rotate" context:nil];
		self.transform = CGAffineTransformMakeRotation( 90.0 * (M_PI/180));
		//self.transform = CGAffineTransformMakeRotation( -90.0 * (180/M_PI));
		//self.transform = CGAffineTransformMakeRotation(M_PI/4);
		//self.frame = CGRectMake(0, 0, 480, 320);
		//self.bounds = CGRectMake(320, 0, 480, 320); 
		[UIView commitAnimations];
		
		
	}
	
	if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
		NSLog(@"POTRAIT MODE");
		[UIView beginAnimations:@"rotate" context:nil];
		self.transform = CGAffineTransformMakeRotation( -90 * (M_PI/180));
		//self.transform = CGAffineTransformMakeRotation( 90.0 * (180/M_PI));
		//self.transform = CGAffineTransformMakeRotation(-M_PI/4);
		//self.frame = CGRectMake(0, 0, 320, 480);
		//self.bounds = CGRectMake(0, 0, 320, 480);
		[UIView commitAnimations];
	}
	
}
 */



- (void)dealloc {
	[delegate release];
	[selectedPub release];
	[cardSource release];
    [super dealloc];
}


@end
