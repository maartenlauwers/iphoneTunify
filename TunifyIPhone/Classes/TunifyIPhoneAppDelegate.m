//
//  TunifyIPhoneAppDelegate.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TunifyIPhoneAppDelegate.h"

@implementation TunifyIPhoneAppDelegate

@synthesize window;
@synthesize tabController;
@synthesize audioPlayer;
@synthesize fbSession;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	self.fbSession = nil;
	
	// Set app radius default
	NSNumber *lastRead = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"];
	if (lastRead == nil)     // App first run: set up user defaults.
	{
		NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:5], @"radius", nil];
		
		// do any other initialization you want to do here - e.g. the starting default values.    
		// [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
		
		// sync the defaults to disk
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	
	// Fill the Core Data with all available achievements
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Might want to do something more serious... 
		NSLog(@"Can’t load the Pub data!"); 
	} 

	if (mutableFetchResults == nil || [mutableFetchResults count] <= 0) {
		Achievement *achievement = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement setName:@"City Hopper"];
		[achievement setCompletion:@"50"];
		[achievement setInfo:@"Visit pubs in at least 5 different cities."];
		[achievement setLocation:@"Unknown"];
		[achievement setDate:[[NSDate alloc] init]];
		// Save the context.
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		Achievement *achievement2 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement2 setName:@"Pub Hopper"];
		[achievement2 setCompletion:@"50"];
		[achievement2 setInfo:@"Visit 5 pubs in less than 5 hours."];
		[achievement2 setLocation:@"Unknown"];
		[achievement2 setDate:[[NSDate alloc] init]];
		// Save the context.
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		Achievement *achievement3 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement3 setName:@"Restless"];
		[achievement3 setCompletion:@"50"];
		[achievement3 setInfo:@"Visit more than 5 pubs before the night is over."];
		[achievement3 setLocation:@"Unknown"];
		[achievement3 setDate:[[NSDate alloc] init]];
		// Save the context.
		NSError *error = nil;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		Achievement *achievement4 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement4 setName:@"Recognized"];
		[achievement4 setCompletion:@"50"];
		[achievement4 setInfo:@"Visit the same pub over 10 times."];
		[achievement4 setLocation:@"Unknown"];
		[achievement4 setDate:[[NSDate alloc] init]];
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	
		Achievement *achievement5 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement5 setName:@"Settler"];
		[achievement5 setCompletion:@"50"];
		[achievement5 setInfo:@"Visit the same pub over 50 times."];
		[achievement5 setLocation:@"Unknown"];
		[achievement5 setDate:[[NSDate alloc] init]];
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		Achievement *achievement6 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement6 setName:@"Pathfinder"];
		[achievement6 setCompletion:@"50"];
		[achievement6 setInfo:@"Follow route directions to at least 25 different pubs."];
		[achievement6 setLocation:@"Unknown"];
		[achievement6 setDate:[[NSDate alloc] init]];
		// Save the context.
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
		Achievement *achievement7 = (Achievement *)[NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:managedObjectContext];
		[achievement7 setName:@"Social"];
		[achievement7 setCompletion:@"50"];
		[achievement7 setInfo:@"Invite at least 10 friends to one or more pubs."];
		[achievement7 setLocation:@"Unknown"];
		[achievement7 setDate:[[NSDate alloc] init]];
		// Save the context.
		if (![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	 for(Achievement *achievement in mutableFetchResults) {
		 NSLog(@"Achievement: %@", [achievement name]);
 		 NSLog(@"Achievement: %@", [achievement location]);
  		 NSLog(@"Achievement: %@", [achievement date]);
   		 NSLog(@"Achievement: %@", [achievement info]);
	 }
	
	[mutableFetchResults release];
	[request release];
	/*
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:managedObjectContext]; 
	[request setEntity:entity]; 
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	[sortDescriptors release]; 
	[sortDescriptor release]; 
	NSError *error; 
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (mutableFetchResults == nil) { 
		// Might want to do something more serious... 
		NSLog(@"Can’t load the Pub data!"); 
	} 
	*/
	//self.audioPlayer = [[AudioPlayer alloc] init];
    [window addSubview:tabController.view];
    [window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"pub.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[fbSession release];
	[audioPlayer release];
	[tabController release];
    [window release];
    [super dealloc];
}


@end
