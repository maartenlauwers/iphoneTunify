//
//  rateStar.m
//  TunifyIPhone
//
//  Created by thesis on 03/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RateStar.h"


@implementation RateStar

@synthesize number;
@synthesize delegate;
@synthesize touched;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:TRUE];
		self.touched = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(starTouched:)]) {
		[delegate starTouched:self];
	}    
}

- (void)setTouchedImage:(BOOL)value {
	if (value == TRUE) {
		self.image = [UIImage imageNamed:@"star.png"];
		self.touched = TRUE;
	} else {
		self.image = [UIImage imageNamed:@"star_light.png"];
		self.touched = FALSE;
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
	[delegate release];
    [super dealloc];
}


@end
