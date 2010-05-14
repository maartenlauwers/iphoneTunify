//
//  OverlayView.h
//  TunifyIPhone
//
//  Created by thesis on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OverlayView;
@protocol OverlayViewDelegate <NSObject>
@optional
- (void)viewClicked:(OverlayView *)sender;
@end

@interface OverlayView : UIButton {
	id<OverlayViewDelegate> delegate;
}

@property (nonatomic, assign) id<OverlayViewDelegate> delegate;

-(void)button_clicked:(id)sender;
@end
