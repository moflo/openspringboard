//
//  OpenSpringBoard.h
//  ScrollTests
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_ICON_POSITION 9

@interface OpenSpringBoard : UIViewController  <UIGestureRecognizerDelegate> {
	
	IBOutlet UIView	*toolButtonOne, *toolButtonTwo, *toolButtonThree, *toolButtonFour, *toolButtonFive;
	IBOutlet UIView	*toolButtonSix, *toolButtonSeven, *toolButtonEight, *toolButtonNine, *toolButtonTen;
	IBOutlet UIImageView	*toolButtonEleven, *toolButtonTwelve, *toolButtonThirten, *toolButtonFourteen, *toolButtonFifteen;
	
	NSTimer *mainLoopTimer;
	double startTime;
	IBOutlet UILabel *fpsLabel;
	
	NSMutableArray *iconViews;									//<! Ordered array of icon views
	CGPoint iconVerts[MAX_ICON_POSITION];						//<! Ordered array of icon positions (cpv)
	BOOL isIconAnimating;										//<! State flag, indicates icons moving
	int currentSelectedIcon;									//<! Index of selected (moving) icon +1
	
	BOOL isUserMovingIcons;										//<! Enter icon move mode, make icons dance!
	
}
- (IBAction) doToolButton:(id)sender;

- (void) setupSpace;
- (void) teardownSpace;
- (void) mainLoop:(NSTimer *)timer;
- (void) showFPS:(double)dt;
- (void) addNewSpriteFromView:(UIView *)uiview m:(float)m u:(float)u;
- (void) setupIconCollisionMatrix;
- (int) checkIconCollision:(float)dist;
- (void) animateIconInsertPosition:(int)position;
- (void) animationDone;
- (void) setupGestureRecognition;

- (void) setIconAnimation:(BOOL)isAnimating;

@end
