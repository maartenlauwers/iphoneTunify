//
//  OverlayView.h
//  TunifyIPhone
//
//  Created by thesis on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubCard.h"
#import "CoordinatesTool.h"

@class OverlayView;
@protocol OverlayViewDelegate <NSObject>
@optional
- (void)viewClicked:(OverlayView *)sender;
- (void)buttonDirectionClicked:(OverlayView *)sender;
- (void)buttonPlayMusicClicked:(OverlayView *)sender;
@end

@interface OverlayView : UIButton <PubCardDelegate> {
	id<OverlayViewDelegate> delegate;
	
	float horizonHeight;
	float rotation;
	UIView *cardView;
	NSMutableArray *cardSource;
	Pub *selectedPub;
	
	NSInteger sortState;
	
}

@property (nonatomic, assign) id<OverlayViewDelegate> delegate;
@property (assign) float horizonHeight;
@property (assign) float rotation;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) NSMutableArray *cardSource;
@property (nonatomic, retain) Pub *selectedPub;
@property (assign) NSInteger sortState;

-(void)button_clicked:(id)sender;
-(void)updateHorizon:(float)height;
-(float)getHorizon;
-(void)updateRotation:(float)theRotation;
- (void)layoutCards;
- (float)calculatePubHeading:(Pub *)pub;
- (void)cardClicked:(id)sender;
- (void)viewClicked;
- (void)createPubCards:(NSMutableArray *)dataSource;
- (void)updateCards;
- (void)updateAllHeadings;
- (void)buttonPlayMusicClicked:(id)sender;
- (void)buttonDirectionClicked:(id)sender;

- (void)filterByDistance;
- (void)filterByRating;
- (void)filterByVisitors;
@end
