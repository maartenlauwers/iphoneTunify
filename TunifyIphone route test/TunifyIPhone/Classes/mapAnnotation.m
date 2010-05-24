//
//  mapAnnotation.m
//  TunifyIPhone
//
//  Created by thesis on 19/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "mapAnnotation.h"


@implementation mapAnnotation

@synthesize coordinate, title, subtitle;


-(void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
