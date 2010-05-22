//
//  pubListController.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapViewController.h"
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h> 
#import "AudioPlayer.h"
#import "CoordinatesTool.h"
#import "RecentlyVisited.h"
#import "Pub.h"
#import "TunifyIPhoneAppDelegate.h"
#import "OverlayView.h"
#import "PubCard.h"

@class CellButton;
@interface pubListController : UITableViewController <UIActionSheetDelegate, AVAudioPlayerDelegate, AudioPlayerDelegate, CoordinatesToolDelegate, UIAccelerometerDelegate, OverlayViewDelegate, PubCardDelegate> {
	mapViewController *mapViewController;
	NSMutableArray *dataSource;		// stores all data
	NSMutableArray *tableData;		// stores data displayed in the table
	NSMutableArray *searchedData;	// stores search results
	
	IBOutlet UITableView *tableView;
	IBOutlet UISearchBar *searchBar;
	
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL recordResults;
	
	NSString *genre;
	
	NSInteger rowPlaying;
	CellButton *buttonPlaying;
	
	CLLocation *userLocation;
	NSTimer *locationTimer;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	// 3D variables
	UIImagePickerController *picker;
	BOOL in3DView;
	OverlayView *overlayView;
	BOOL pubPlaying;
	
	// Test stuff
	NSDate *previousDate;
	float nrReadings;
	float averageZ;
	float averageX;
	float velX;
	float distX;
	
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSMutableString *soapResults;
@property (nonatomic, retain) NSXMLParser *xmlParser;
@property (nonatomic, retain) CellButton *buttonPlaying;
@property (assign) NSInteger rowPlaying;
@property (nonatomic, retain) CLLocation *userLocation;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) OverlayView *overlayView;

// test stuff
@property (nonatomic, retain) NSDate *previousDate;
@property (assign) float nrReadings;
@property (assign) float averageZ;
@property (assign) float averageX;
@property (assign) float velX;
@property (assign) float distX;

- (void) tunify_login;
- (void) btnFilter_clicked:(id)sender;
- (void) btnLookAround_clicked:(id)sender;
- (void) pubCell_clicked:(id)sender row:(NSInteger)theRow;
- (IBAction) searchFieldDoneEditing:(id)sender;
- (void) playMusic:(id)sender;

- (void)insertNewObject:(NSString *)theName andStreet:(NSString *)theStreet andNumber:(NSString *)theNumber
				andZipCode:(NSString *)theZipCode andCity:(NSString *)theCity andUserID:(NSString *)theUserID
				andRating:(NSString *)theRating andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude
				andVisitors:(NSString *)theVisistors;

- (void)show3DList;
- (void)hide3DList;
- (void)buttonDirectionClicked:(OverlayView *)sender card:(Pub *)pub;
- (void)buttonPlayMusicClicked:(id)sender pub:(Pub *)pub;

@end
