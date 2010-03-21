//
//  UICGoogleMapsAPI.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "UICGoogleMapsAPI.h"

@interface UIWebView(JavaScriptEvaluator)
- (void)webView:(UIWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end

@implementation UICGoogleMapsAPI

//@synthesize delegate;
@synthesize message;

- (id)init {
    if (self = [super initWithFrame:CGRectZero]) {
		self.delegate = self;
		[self makeAvailable];
    }
    return self;
}

- (void)dealloc {
	//[delegate release];
	[message release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    // Nothing to do.
}


- (void)makeAvailable {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"mapcontainer" ofType:@"html"];
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}


- (void)webView:(UIWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
	self.message = message;
	if ([self.delegate respondsToSelector:@selector(goolgeMapsAPI:didGetObject:)]) {
		[(id<UICGoogleMapsAPIDelegate>)self.delegate goolgeMapsAPI:self didGetObject:message];
	}
	
	
}

@end
