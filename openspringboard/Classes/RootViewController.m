//
//  RootViewController.m
//  openspringboard
//
//  Created by fieldforceapp_dev on 2/22/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "RootViewController.h"
#import "OpenSpringBoardVC.h"


@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	tableSectionData = [[NSMutableArray alloc] init];
	
	NSArray *rows;
	NSDictionary *d;
	
#define kSectionSpringBoardTests 0
	rows = [NSArray arrayWithObjects:@"Default",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"SpringBoard UI Tests",@"section_title",nil];
	[tableSectionData addObject:d];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.title = @"Open SpringBoard";
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return ( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
			(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) );
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableSectionData count];
}

// For grouped tableview, customize the group title.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[tableSectionData objectAtIndex:section] objectForKey:@"section_title"];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[tableSectionData objectAtIndex:section] objectForKey:@"rows"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[[tableSectionData objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	UIViewController *detailViewController = nil;
	
	if (indexPath.section == kSectionSpringBoardTests)
	{
		if (indexPath.row == 0) {
			// Default UIAnimation based SpringBoard
			detailViewController = [[OpenSpringBoardVC alloc] initWithNibName:@"OpenSpringBoardVC" bundle:nil];
		}
	}
	
	if (detailViewController) {
		self.title = @"";
		
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableSectionData release];
    [super dealloc];
}


@end

