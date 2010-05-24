//
//  rateStar.h
//  TunifyIPhone
//
//  Created by thesis on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RateStar;
@protocol RateStarDelegate <NSObject>
@optional
- (void)starTouched:(RateStar *)sender;
@end

@interface RateStar : UIImageView {
	id<RateStarDelegate> delegate;
	
	NSInteger number;
	BOOL touched;
	
}

@property (nonatomic, assign) id<RateStarDelegate> delegate;
@property (assign) NSInteger number;
@property BOOL touched;

- (void)setTouchedImage:(BOOL)value;


@end