//
//  OpenSpringBoardVC.m
//  openspringboard
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "OpenSpringBoardVC.h"


@implementation OpenSpringBoardVC

@synthesize openSpringBoard = _openSpringBoard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//! Custom initialization to add logo image
		self.title = @"OpenSpringBoardVC";
		
		UIBarButtonItem *modalButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						 target:self
																						 action:@selector(doneButton:)];
		
		self.navigationItem.rightBarButtonItem = modalButtonDone;
		[modalButtonDone release];
		
	}
	return self;
}

- (IBAction) doneButton: (id)sender
{
	//[mainLoopTimer invalidate];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	_openSpringBoard = [[OpenSpringBoard alloc] init];
	_openSpringBoard.delegate = self;
	[self.view addSubview:_openSpringBoard.view];
	//[_openSpringBoard viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark OpenSpringBoard Delegate Methods

- (NSMutableArray *) openSringBoardLoadIconArray:(OpenSpringBoard *)openSringBoardVC iconPageLimit:(int *)numIcons
{
// Create an array of icons programmatically
#define addIcon(png,title,code) d = [NSDictionary dictionaryWithObjectsAndKeys:png,@"icon_png",title,@"icon_title",code,@"icon_code",nil]; [itemArray addObject:d];

	NSDictionary *d;
	itemArray = [[[NSMutableArray alloc] initWithCapacity:18] autorelease];

    addIcon(@"tool_calendar_JAN.png",@"January",@"1")
    addIcon(@"tool_calendar_FEB.png",@"February",@"2")
    addIcon(@"tool_calendar_MAR.png",@"March",@"3")
    
    addIcon(@"tool_calendar_APR.png",@"April",@"4")
    addIcon(@"tool_calendar_MAY.png",@"May",@"5")
    addIcon(@"tool_calendar_JUL.png",@"January1",@"6")
    
    addIcon(@"tool_calendar_FEB.png",@"February1",@"7")
    addIcon(@"tool_calendar_OCT.png",@"March1",@"8")
    addIcon(@"tool_calendar_APR.png",@"April1",@"9")
    
    addIcon(@"tool_calendar_SEP.png",@"May1",@"10")
    addIcon(@"tool_calendar_AUG.png",@"January2",@"11")
    addIcon(@"tool_calendar_NOV.png",@"February2",@"12")
    
    addIcon(@"tool_calendar_DEC.png",@"March2",@"13")
    addIcon(@"tool_calendar_APR_ON.png",@"April2",@"14")
    addIcon(@"tool_calendar_AUG_ON.png",@"May2",@"15")
    
	
	*numIcons = 9;
	
	return itemArray;
}

- (void) openSringBoardIconPress:(OpenSpringBoard *)openSringBoardVC iconSelectedTag:(int)iconTag
{
	// Handle icon press
	NSLog(@"OpenSpringBoardVC: launchTool=%d",iconTag);

}

- (void) openSringBoardDidReorderIcons:(OpenSpringBoard *)openSringBoardVC iconArray:(NSMutableArray *)iconArray
{
	// Respond to new ordered array of icons, save to NSDefaults?
	for (NSDictionary *item in itemArray) {
		NSLog(@"Icon image: %@  title: %@  code: %@",
			  [item objectForKey:@"icon_png"],
			  [item objectForKey:@"icon_title"],
			  [item objectForKey:@"icon_code"]);
	}
	
}

@end
