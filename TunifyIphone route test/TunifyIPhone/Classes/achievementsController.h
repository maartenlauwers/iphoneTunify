//
//  achievementsController.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TunifyIPhoneAppDelegate.h"

@interface achievementsController : UITableViewController {
	NSMutableArray *dataSource;	
	NSMutableArray *gainedAchievements;
	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *gainedAchievements;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)button1_clicked:(id)sender;
- (void)button2_clicked:(id)sender;
- (void)button3_clicked:(id)sender;

@end
