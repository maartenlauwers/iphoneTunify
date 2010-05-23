//
//  TunifyIPhoneAppDelegate.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "FBSession.h"
#import "Achievement.h"

@interface TunifyIPhoneAppDelegate : NSObject <UIApplicationDelegate> {
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	UITabBarController *tabController;
	AudioPlayer *audioPlayer;
	FBSession *fbSession;
	
	float radius;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic, retain) AudioPlayer *audioPlayer;
@property (nonatomic, retain) FBSession *fbSession;

@property (assign) float radius;

- (NSString *)applicationDocumentsDirectory;

@end

