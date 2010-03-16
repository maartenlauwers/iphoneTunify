//
//  rateStar.h
//  TunifyIPhone
//
//  Created by thesis on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pubVisitViewController.h"

@protocol rateStar <NSObject>
@optional
- (void)starTouched:(rateStar *)sender;
@end

@interface rateStar : UIImageView {
	NSInteger *number;
	BOOL touched;
	id<rateStar> delegate;
}

@property (assign) id<rateStar> delegate;
@property (assign) NSInteger *number;
@property BOOL touched;

- (void)setTouchedImage:(BOOL)value;


@end