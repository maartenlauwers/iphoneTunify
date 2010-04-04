//
//  pubCard.h
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarView.h"

@interface PubCard : UIView {
	NSString *name;
	NSString *address;
	NSInteger *visitors;
	NSInteger *rating;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (assign) NSInteger *visitors;
@property (assign) NSInteger *rating;

- (id)initWithPub:(NSString *)name pubAddress:(NSString *)address pubVisitors:(NSInteger *)visitors pubRating:(NSInteger *)rating;
- (void)setPosition:(float)x y:(float)y;
@end
