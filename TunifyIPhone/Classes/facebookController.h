//
//  facebookController.h
//  TunifyIPhone
//
//  Created by thesis on 25/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"

@interface facebookController : UIViewController <FBDialogDelegate> {
	FBSession *fbSession;
	
	NSString *strPubName;
	IBOutlet UITextView *facebookMessageView;
}


@property (nonatomic, retain) FBSession *fbSession;
@property (nonatomic, retain) NSString *strPubName;
@property (nonatomic, retain) IBOutlet UITextView *facebookMessageView;

@end
