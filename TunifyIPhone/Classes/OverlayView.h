//
//  OverlayView.h
//  TunifyIPhone
//
//  Created by Maarten on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OverlayView;
@protocol OverlayViewDelegate <NSObject> 
@optional
- (void)viewClicked:(OverlayView *)sender;
@end

@interface OverlayView : UIButton {
	id<OverlayViewDelegate> delegate;
}

@property (nonatomic, assign) id<OverlayViewDelegate> delegate;
@end
