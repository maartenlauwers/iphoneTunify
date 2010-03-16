//
//  pubListController.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapViewController.h"

@interface pubListController : UITableViewController <UIActionSheetDelegate> {
	mapViewController *mapViewController;
	NSMutableArray *dataSource;		// stores all data
	NSMutableArray *tableData;		// stores data displayed in the table
	NSMutableArray *searchedData;	// stores search results
	
	IBOutlet UITableView *tableView;
	IBOutlet UISearchBar *searchBar;
	
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL *recordResults;
	
	NSString *genre;
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *genre;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;

- (void) tunify_login;
- (void) btnFilter_clicked:(id)sender;
- (void) btnLookAround_clicked:(id)sender;
- (void) pubCell_clicked:(id)sender pubName:(NSString*)pubName;
- (IBAction) searchFieldDoneEditing:(id)sender;
- (void) playMusic:(id)sender;

@end
