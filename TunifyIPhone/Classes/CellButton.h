//
//  PlayPauzeButton.h
//  TunifyIPhone
//
//  Created by thesis on 21/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellButton : UIButton {
	NSIndexPath *indexPath;
}

@property (nonatomic, retain) NSIndexPath *indexPath;

@end
