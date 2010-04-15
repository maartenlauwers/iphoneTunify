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

@interface PubCard : UIView {
	NSString *name;
	NSString *address;
	NSInteger *visitors;
	NSInteger *rating;
	Pub *pub;
	BOOL *visible;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (assign) NSInteger *visitors;
@property (assign) NSInteger *rating;
@property (nonatomic, retain) Pub *pub;
@property (assign) BOOL *visible;

- (id)initWithPub:(Pub *)pub;
- (void)setPosition:(float)x y:(float)y;
@end
