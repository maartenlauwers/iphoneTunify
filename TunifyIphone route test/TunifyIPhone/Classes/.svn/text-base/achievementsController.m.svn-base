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

- (NSString *)get_achievement_description:(NSString *)achievementName {
	if (achievementName == @"City hopper") {
		return @"Visit pubs in at least 5 different cities.";
	} else if (achievementName == @"Pub hopper") {
		return @"Visit over 5 pubs in less than 5 hours.";
	} else if (achievementName == @"Restless") {
		return @"Visit more than 5 pubs before the night is over.";
	} else if (achievementName == @"Recognized") {
		return @"Visit the same pub over 10 times.";
	} else if (achievementName == @"Settler") {
		return @"Visit the same pub over 50 times.";		
	} else if (achievementName == @"Pathfinder") {
		return @"Follow route directions to at least 25 different pubs.";
	} else if (achievementName == @"Social") {
		return @"Invite at least 10 friends to one or more pubs.";
	}
	
}
- (void)button1_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	NSString *name = [dataSource objectAtIndex:([row intValue] * 3)];
	NSInteger achievementNumber = [row intValue] * 3;
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	// For testing purposes
	if (achievementNumber == 1 || achievementNumber == 2 || achievementNumber == 5 || achievementNumber == 6) {
		controller.achieved = FALSE;
	} else {
		controller.achieved = TRUE;
	} 
	
	controller.achievementName = name;
	controller.achievementDescription = [self get_achievement_description:name];
	controller.achievementNumber = achievementNumber;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}
- (void)button2_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	NSString *name = [dataSource objectAtIndex:([row intValue] * 3) + 1];
	NSInteger achievementNumber = ([row intValue] * 3) + 1;
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	// For testing purposes
	if (achievementNumber == 1 || achievementNumber == 2 || achievementNumber == 5 || achievementNumber == 6) {
		controller.achieved = FALSE;
	} else {
		controller.achieved = TRUE;
	} 
	
	controller.achievementName = name;
	controller.achievementDescription = [self get_achievement_description:name];
	controller.achievementNumber = achievementNumber;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}
- (void)button3_clicked:(id)sender {
	
	UIButton *button = (UIButton *)sender;
	
	NSString *row = button.titleLabel.text;
	NSString *name = [dataSource objectAtIndex:([row intValue] * 3) + 2];
	NSInteger achievementNumber = ([row intValue] * 3) + 2;
	
	selectedAchievementViewController *controller = [[selectedAchievementViewController alloc] initWithNibName:@"achievementsView" bundle:[NSBundle mainBundle]];
	
	// For testing purposes
	if (achievementNumber == 1 || achievementNumber == 2 || achievementNumber == 5 || achievementNumber == 6) {
		controller.achieved = FALSE;
	} else {
		controller.achieved = TRUE;
	} 
	
	controller.achievementName = name;
	controller.achievementDescription = [self get_achievement_description:name];
	controller.achievementNumber = achievementNumber;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Achievements";
	
	// Create some test data for the table
	dataSource = [[NSMutableArray alloc] init];
	
	[dataSource addObject:@"City hopper"];
	[dataSource addObject:@"Pub hopper"];
	[dataSource addObject:@"Restless"];
	[dataSource addObject:@"Recognized"];
	[dataSource addObject:@"Settler"];
	[dataSource addObject:@"Pathfinder"];
	[dataSource addObject:@"Social"];
	[dataSource addObject:@"..."];
	[dataSource addObject:@"..."];
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSource count]/3;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView setSeparatorColor:[UIColor whiteColor]];
	
    static NSString *CellIdentifier = @"Cell";
    
	
	achievementsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[achievementsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	
	
	/*
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	 if (cell == nil) {
	 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	 }
	 */
	
	NSLog(@"row: %d", indexPath.row);
	
	cell.label1.text = [dataSource objectAtIndex:(indexPath.row * 3)];
	cell.label2.text = [dataSource objectAtIndex:(indexPath.row * 3) + 1];
	cell.label3.text = [dataSource objectAtIndex:(indexPath.row * 3) + 2];
	
	NSString *strRow = [NSString stringWithFormat:@"%d", indexPath.row];
	NSLog(@"Row: %@", strRow);
	if (indexPath.row == 0) {
		[cell.button1 setImage:[UIImage imageNamed:@"achievement1.png"] forState:UIControlStateNormal];
		[cell.button2 setImage:[UIImage imageNamed:@"achievement2_disabled.png"] forState:UIControlStateNormal];
		[cell.button3 setImage:[UIImage imageNamed:@"achievement3_disabled.png"] forState:UIControlStateNormal];
	} else if (indexPath.row == 1) {
		[cell.button1 setImage:[UIImage imageNamed:@"achievement4.png"] forState:UIControlStateNormal];
		[cell.button2 setImage:[UIImage imageNamed:@"achievement5.png"] forState:UIControlStateNormal];
		[cell.button3 setImage:[UIImage imageNamed:@"achievement6_disabled.png"] forState:UIControlStateNormal];
	} else {
		[cell.button1 setImage:[UIImage imageNamed:@"achievement7_disabled.png"] forState:UIControlStateNormal];
		[cell.button2 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
		[cell.button3 setImage:[UIImage imageNamed:@"testicon64x64.jpg"] forState:UIControlStateNormal];
	}
	
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
    [super dealloc];
}


@end
