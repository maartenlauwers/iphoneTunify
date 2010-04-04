//
//  StarView.h
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StarView : UIView {
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
	
	NSInteger *rating;
}

@property (nonatomic, retain) UIImageView *star1;
@property (nonatomic, retain) UIImageView *star2;
@property (nonatomic, retain) UIImageView *star3;
@property (nonatomic, retain) UIImageView *star4;
@property (nonatomic, retain) UIImageView *star5;

- (id)initWithRating:(CGRect)frame rating:(NSInteger *)theRating;
- (void)setRating:(NSInteger *)theRating;
@end
