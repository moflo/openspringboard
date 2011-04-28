//
//  OpenSpringBoard.h
//  ScrollTests
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsIconView.h"


#define MAX_ICON_POSITION 9

@interface OpenSpringBoard : UIViewController  <UIGestureRecognizerDelegate> {
	
	IBOutlet UIImageView	*toolButtonSelected;
	
	NSTimer *mainLoopTimer;
	double startTime;
	IBOutlet UILabel *fpsLabel;
	
	NSMutableArray *iconViews;									//!< Ordered array of icon views
	IBOutlet ToolsIconView *toolIconView;						//!< IBFactory for standard icon view container
	ToolsIconView *selectedIconView;							//!< Placeholder for selected icon view  
	CGPoint iconVerts[MAX_ICON_POSITION];						//!< Ordered array of icon positions (cpv)
	int maxIconPerPage;											//!< Max number of icons shown per page
	BOOL isIconAnimating;										//!< State flag, indicates icons moving
	int toolButtonSelectedIndex;									//!< Index of selected (moving) icon +1
	
	BOOL isUserMovingIcons;										//!< Enter icon move mode, make icons dance!
	
}
- (IBAction) doToolButton:(id)sender;

- (void) buildIconViews;
- (IBAction) launchTool:(id)sender;
- (void) listIconOrder;

- (void) mainLoop:(NSTimer *)timer;
- (void) showFPS:(double)dt;
- (void) setupIconCollisionMatrix;
- (int) checkIconCollision:(float)dist;
- (void) animateIconInsertPosition:(int)position;
- (void) animationDone;
- (void) setupGestureRecognition;

- (void) setIconAnimation:(BOOL)isAnimating;

@end
