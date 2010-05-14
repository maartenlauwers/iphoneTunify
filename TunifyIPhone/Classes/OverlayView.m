//
//  OverlayView.m
//  TunifyIPhone
//
//  Created by thesis on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView
@synthesize delegate;

- (id)init
{
	if ((self = [super init])) {
		NSLog(@"============================");
		NSLog(@"ALL INITED");
		NSLog(@"============================");
		[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
	
	return self;	
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self addTarget:self action:@selector(button_clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)button_clicked:(id)sender {
	NSLog(@"BUTTON CLICKED CLICKED!");
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(viewClicked:)]) {
		NSLog(@"viewClicked called");
		[delegate viewClicked:self];
	} 
}

/*
 -(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 {
 UIView *hitView=[super hitTest:point withEvent:event];
 if(hitView)
 {
 NSLog(@"HIT HIT HIT!");
 }
 return hitView;
 }
 */

- (void)dealloc {
	[delegate release];
    [super dealloc];
}


@end
