//
//  achievementsController.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "achievementsController.h"
#import "achievementsCell.h"
#import "selectedAchievementViewController.h"

@implementation achievementsController

@synthesize dataSource;
@synthesize gainedAchievements;
@synthesize tableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)button1_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	Achievement *achievement = [dataSource objectAtIndex:([row intValue] * 3)];
	
	NSLog(@"Achievement description: %@", achievement.description);
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	controller.achievement = achievement;
	NSLog(@"Pushing achievement view controller");
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}
- (void)button2_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	Achievement *achievement = [dataSource objectAtIndex:([row intValue] * 3) + 1];
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	controller.achievement = achievement;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}
- (void)button3_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	Achievement *achievement = [dataSource objectAtIndex:([row intValue] * 3) + 2];
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	controller.achievement = achievement;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Achievements";
	
	// Fetch all available achievements
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	
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
	
	
	// Create some test data for the table
	NSLog(@"NSMutableArray count: %d", [mutableFetchResults count]);
	dataSource = [[NSMutableArray alloc] init];
	for (Achievement *achievement in mutableFetchResults) {
		[dataSource addObject:achievement];
	}
	NSLog(@"Datasource count: %d", [dataSource count]);

	gainedAchievements = [[NSMutableArray alloc] init];
	for (Achievement *achievement in mutableFetchResults) {
		if([achievement.completion doubleValue] >= 100) {
			[gainedAchievements addObject:achievement];
		}
	}
	
	[mutableFetchResults release];
	[request release];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSLog(@"View did appear");
	[dataSource removeAllObjects];
	
	// Fetch all available achievements
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	
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
	
	
	// Create some test data for the table
	NSLog(@"NSMutableArray count: %d", [mutableFetchResults count]);
	dataSource = [[NSMutableArray alloc] init];
	for (Achievement *achievement in mutableFetchResults) {
		[dataSource addObject:achievement];
	}
	NSLog(@"Datasource count: %d", [dataSource count]);
	
	gainedAchievements = [[NSMutableArray alloc] init];
	for (Achievement *achievement in mutableFetchResults) {
		if([achievement.completion doubleValue] >= 100) {
			[gainedAchievements addObject:achievement];
		}
	}
	
	[mutableFetchResults release];
	[request release];
	[self.tableView reloadData];
	
	
	// Update any potential badges
	appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate];
	UITabBar *tabBar = appDelegate.tabController.tabBar;
	UITabBarItem *achievementsTabItem = [tabBar.items objectAtIndex:2];
	NSInteger badgeValue = [achievementsTabItem.badgeValue intValue];
	
	if(achievementsTabItem.badgeValue.length > 0) {
		if(badgeValue > 0) {
			badgeValue = badgeValue - 1;
			
			if(badgeValue == 0) {
				achievementsTabItem.badgeValue = nil;
			} else {
				achievementsTabItem.badgeValue = [NSString stringWithFormat:@"%d", badgeValue];
			}
		}
	}
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource count]/3;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[theTableView setSeparatorColor:[UIColor whiteColor]];
	
    static NSString *CellIdentifier = @"Cell";
    
	
	achievementsCell *cell = (achievementsCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[achievementsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	
	NSLog(@"row: %d", indexPath.row);
	
	Achievement *achievement1 = [dataSource objectAtIndex:(indexPath.row * 3)];
	Achievement *achievement2 = [dataSource objectAtIndex:(indexPath.row * 3) + 1];
	Achievement *achievement3 = [dataSource objectAtIndex:(indexPath.row * 3) + 2];
	
	cell.label1.text = achievement1.name;
	cell.label2.text = achievement2.name;
	cell.label3.text = achievement3.name;
	
	if([gainedAchievements containsObject:achievement1]) {
		[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement1.name]] forState:UIControlStateNormal];
	} else {
		[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement1.name]] forState:UIControlStateNormal];
	}
	if([gainedAchievements containsObject:achievement2]) {
		[cell.button2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement2.name]] forState:UIControlStateNormal];
	} else {
		[cell.button2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement2.name]] forState:UIControlStateNormal];
	}
	if([gainedAchievements containsObject:achievement3]) {
		[cell.button3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement3.name]] forState:UIControlStateNormal];
	} else {
		[cell.button3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement3.name]] forState:UIControlStateNormal];
	}
	
	NSString *strRow = [NSString stringWithFormat:@"%d", indexPath.row];
	/*
	NSLog(@"Row: %@", strRow);
	if (indexPath.row == 0) {
		
		if([gainedAchievements containsObject:achievement1]) {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement1.name]] forState:UIControlStateNormal];
		} else {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement1.name]] forState:UIControlStateNormal];
		}
		if([gainedAchievements containsObject:achievement2]) {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement2.name]] forState:UIControlStateNormal];
		} else {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement2.name]] forState:UIControlStateNormal];
		}
		if([gainedAchievements containsObject:achievement3]) {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", achievement3.name]] forState:UIControlStateNormal];
		} else {
			[cell.button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_disabled.png", achievement3.name]] forState:UIControlStateNormal];
		}
		
	} else if (indexPath.row == 1) {
		if([gainedAchievements containsObject:cell.label1.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement4.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"achievement5_disabled.png"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"achievement6_disabled.png"] forState:UIControlStateNormal];
		} else if ([gainedAchievements containsObject:cell.label2.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement4_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"achievement5.png"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"achievement6_disabled.png"] forState:UIControlStateNormal];
		} else if ([gainedAchievements containsObject:cell.label3.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement4_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"achievement5_disabled.png"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"achievement6.png"] forState:UIControlStateNormal];
		} else {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement4_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"achievement5_disabled.png"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"achievement6_disabled.png"] forState:UIControlStateNormal];
		}
	} else {
		if([gainedAchievements containsObject:cell.label1.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement7.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
		} else if ([gainedAchievements containsObject:cell.label2.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement7_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
		} else if ([gainedAchievements containsObject:cell.label3.text]) {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement7_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
		} else {
			[cell.button1 setImage:[UIImage imageNamed:@"achievement7_disabled.png"] forState:UIControlStateNormal];
			[cell.button2 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
			[cell.button3 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
		}	
	}
	*/
	[cell.button1 setTitle:strRow forState:UIControlStateNormal];
	[cell.button2 setTitle:strRow forState:UIControlStateNormal];
	[cell.button3 setTitle:strRow forState:UIControlStateNormal];
	

	[cell.button1 addTarget:self action:@selector(button1_clicked:) forControlEvents:UIControlEventTouchUpInside];
	[cell.button2 addTarget:self action:@selector(button2_clicked:) forControlEvents:UIControlEventTouchUpInside];
	[cell.button3 addTarget:self action:@selector(button3_clicked:) forControlEvents:UIControlEventTouchUpInside];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dataSource release];
	[gainedAchievements release];
	[tableView release];
    [super dealloc];
}


@end
