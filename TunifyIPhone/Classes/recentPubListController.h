//
//  recentPubListController.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h> 

@interface recentPubListController : UITableViewController {
	NSMutableArray *dataSource;		// stores all data
	NSMutableArray *tableData;		// stores data displayed in the table
	NSMutableArray *searchedData;	// stores search results
	
	IBOutlet UITableView *tableView;
	IBOutlet UISearchBar *searchBar;
	
	NSString *genre;
	
	AVAudioPlayer *player; 
	NSIndexPath *rowPlayingIndexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *genre;
@property (assign) NSIndexPath *rowPlayingIndexPath;

- (void) pubCell_clicked:(id)sender pubName:(NSString*)pubName;
- (void) btnFilter_clicked:(id)sender;
- (void) playMusic:(id)sender;

@end
