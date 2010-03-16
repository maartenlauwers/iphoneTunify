//
//  genreViewController.h
//  TunifyIPhone
//
//  Created by thesis on 19/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface genreViewController : UITableViewController {
	NSMutableArray *dataSource;		// stores all data
	
	IBOutlet UITableView *tableView;
	
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL *recordResults;
	
	UIViewController *sourceView;		// A reference to the view we came from
	NSInteger sourceId;				// Did we arrive here from the publistController (1), the publist3DController (2) or the recentPubListController (3)?
										// We need this to know to what type of controller we can cast our sourceView.
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableString *soapResults;
@property (nonatomic, retain) NSXMLParser *xmlParser;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIViewController *sourceView;
@property (assign) NSInteger sourceId;

- (void) btnCancel_clicked:(id)sender;

@end
