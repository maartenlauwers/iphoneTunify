//
//  pubCard.h
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarView.h"
#import "Pub.h"

@class PubCard;
@protocol PubCardDelegate <NSObject>
@optional
- (void)cardClicked:(PubCard *)sender;
@end

@interface PubCard : UIView {
	id<PubCardDelegate> delegate;
	
	NSString *name;
	NSString *address;
	NSInteger visitors;
	NSInteger rating;
	Pub *pub;
	BOOL visible;
	float heading;
	double distance;
	
	UIButton *iconButton;
}


@property (nonatomic, assign) id <PubCardDelegate> delegate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (assign) NSInteger visitors;
@property (assign) NSInteger rating;
@property (nonatomic, retain) Pub *pub;
@property (assign) BOOL visible;
@property (assign) float heading;
@property (assign) double distance;

@property (nonatomic, retain) UIButton *iconButton;

- (id)initWithPub:(Pub *)pub;
- (void)setPosition:(float)x y:(float)y;
- (float)getX;
- (void)setSize:(float)theWidth height:(float)theHeight;
- (float)getWidth;
- (float)getHeight;
- (void)setHeading:(float)theHeading;
- (float)getHeading;
- (void)setDistance:(double)theDistance;
- (double)getDistance;

- (void)button_clicked:(id)sender;

- (void)updateSizeByDistance;
- (void)updateSizeByVisitors:(double)maxVisitors;
- (void)updateSizeByRating;
@end
