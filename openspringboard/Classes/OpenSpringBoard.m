//
//  OpenSpringBoard.m
//  ScrollTests
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "OpenSpringBoard.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/time.h>


static double
GetCurrentTime(void)
{
    struct timeval time;
	
    gettimeofday(&time, nil);
    return (double)time.tv_sec + (0.000001 * (double)time.tv_usec);
}



@implementation OpenSpringBoard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//! Custom initialization to add logo image
		self.title = @"OpenSpringBoard";
		
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
	[self teardownSpace];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.view.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
	[self.view.layer insertSublayer:gradient atIndex:0];
	
	[self setupIconCollisionMatrix];
	currentSelectedIcon = 0;	// testing, indicate outside position
		
	mainLoopTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/30) target:self selector:@selector(mainLoop:) userInfo:nil repeats:YES];

	[self setupGestureRecognition];
	
	isUserMovingIcons = NO;
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

#pragma mark Physics Methods

- (void) setupIconCollisionMatrix
//! Create linear array of icon positions, and bounding circles to test for collision
{

	// Loop over all subviews (icons) and stuff into ordered array
	iconViews = [[[NSMutableArray alloc] initWithCapacity:9] retain];
	for (UIView *view in [self.view subviews]) {
		if (view.tag != 99) {
			[iconViews addObject:view];
		}
	}
	
	// Build static matix (linear array) of icon positions and bounding circles
#define cpv(x,y) CGPointMake(x,y)
	int num = MAX_ICON_POSITION, xl=51, xm=156, xr=261, yt=57, ym=169, yb=273;
	CGPoint verts[] = {
		cpv(xl,yt), cpv(xm,yt), cpv(xr,yt),
		cpv(xl,ym), cpv(xm,ym), cpv(xr,ym),
		cpv(xl,yb), cpv(xm,yb), cpv(xr,yb),
	};
	
	// Stuff verts into global
	for (int j=0; j<num; j++) {
		iconVerts[j] = verts[j];		
	}
	
	// Loop over all icon views & move to position as per the vert matrix
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if (i<num) {
			NSLog(@"view.tag=%d (%.2f,%.2f)",view.tag,iconVerts[i].x,iconVerts[i].y);
			view.center = CGPointMake(iconVerts[i].x,iconVerts[i].y);
		}
	}
	
	isIconAnimating = NO;		// Flag to signal animation
}

- (void) setupSpace
//! Inherited initialization method. Set up Chipmunk physics engine.
{
	
}

- (void) addNewSpriteFromView:(UIView *)uiview m:(float)m u:(float)u
//! Add sprites to the scene in at a specific location (x,y)
{
	
}

- (void) mainLoop:(NSTimer *)timer {
	//! The game's mainLoop, an NSTimer selector. Wait for player to place piece on the board, when the
	
	// Check if we're still animating icon position move, return
	if (isIconAnimating) {
		return;
	}
	
	// First check collision status
	int iconInsertPosition = [self checkIconCollision:25.0];
	if (iconInsertPosition) {
		NSLog(@"position=%d",iconInsertPosition);
		isIconAnimating = YES;
		[self animateIconInsertPosition:iconInsertPosition];
		return;
	}
	
	
	[self showFPS:(GetCurrentTime()-startTime)];
	startTime = GetCurrentTime();
}

- (int) checkIconCollision:(float)dist
//! Check the icon matrix to see if any have been displaced, return index (+1)
{
#define	testPointInCircle(p1,p2,r1) (sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)) <= (r1))

	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] != [NSNull class]) {
			CGPoint p1 = toolButtonOne.center;
			CGPoint p2 = cpv(iconVerts[i].x,iconVerts[i].y);
			int test = testPointInCircle(p1,p2,dist);
			if (test) {
				NSLog(@"[%d] view.tag=%d state=%@ dist=%.2f",i,view.tag,(test?@"IN":@"OUT"),sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)));
				return i+1;
			}
		}
	}
	
	return 0;
}

- (void) animateIconInsertPosition:(int)position
//! Start animation sequence to insert icon into view matrix at new position
{
	// Remove icon from old position
	if (currentSelectedIcon) {
		[iconViews removeObjectAtIndex:currentSelectedIcon-1];
	}
	
	// Insert icon into new position
	[iconViews insertObject:[NSNull null] atIndex:position-1];
	currentSelectedIcon = position;

	// Move icons to new positions
	[UIView beginAnimations:@"MoveIcons" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDone)];
	[UIView setAnimationDuration:0.25];

	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] != [NSNull class]) {
			NSLog(@"animate view.tag=%d (%.2f,%.2f)",view.tag,iconVerts[i].x,iconVerts[i].y);
			view.center = CGPointMake(iconVerts[i].x,iconVerts[i].y);
		}
	}
	
	[UIView commitAnimations];

}

- (void) animationDone
//- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//! Animation completed, start the physic main loop again
{
	NSLog(@"AnimationDone");
	isIconAnimating = NO;
}

- (void) showFPS:(double)dt {
	//! Routine to update & show FPS
	static float frames = 0.0;
	static float totalDt = 0.0;
	
	frames++;
	totalDt += dt;
	if (totalDt > 0.2) {
		fpsLabel.text = [NSString stringWithFormat:@"%.1f fps",(frames/totalDt)];
		frames = 0.0;
		totalDt = 0.0;
	}
}

- (void) teardownSpace {
	//! Remove the physics objects
	
	[mainLoopTimer invalidate];

}

- (void) setIconAnimation:(BOOL)isAnimating
{
	//! Attach block-based animation to icons, depending on location (order)
	if (!isAnimating) {
		// Animation done
		return;
	}
	
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] != [NSNull class]) {
			// Loop over all icon views, add "dancing" animation to each
#define kAnimationRotateDeg 6.0
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 2.0
			[UIView animateWithDuration:0.25 
								delay:0.0 
							  options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat 
						   animations:^{
							   view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, kAnimationTranslateX, kAnimationTranslateY);
							   view.transform = CGAffineTransformMakeRotation(kAnimationRotateDeg*(i%2 ? -1 : +1)*(3.141519/180.0));
						   }
						   completion:^(BOOL finished){
							   [UIView animateWithDuration:0.25
													 delay: 0.0
												   options: UIViewAnimationOptionAllowUserInteraction
												animations:^{
													view.transform = CGAffineTransformTranslate(view.transform, -kAnimationTranslateX, -kAnimationTranslateY);
													view.transform = CGAffineTransformMakeRotation(-kAnimationRotateDeg*(i%2 ? +1 : -1)*(3.141519/180.0));
												}
												completion:nil];							   
						   }];

		}
	}
		
	//[UIView commitAnimations];
}


#pragma mark UITouch & UIGesture Methods

- (IBAction) doToolButton:(id)sender {
	NSLog(@"doToolButton down");
}

- (void) longPressDetected:(UIGestureRecognizer *)gestureRecognizer {
	//! Method to handle long presses on view
	if (isUserMovingIcons) {
		// User already moving so do nothing
		return;
	}
	if (gestureRecognizer.view == toolButtonOne) {
		NSLog(@"longPressDetected: toolButtonOne");
		[self setIconAnimation:TRUE];
		isUserMovingIcons = YES;
	}
	if (gestureRecognizer.view == toolButtonTwo) {
		NSLog(@"longPressDetected: toolButtonOne");
		[self setIconAnimation:TRUE];
		isUserMovingIcons = YES;
	}
}

- (void) setupGestureRecognition {
	// Attached UIGesture recognizers to the timeLineView
	UILongPressGestureRecognizer *recognizer;
    
    recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
	recognizer.minimumPressDuration = 1.0f;	// default is 0.4f
    [toolButtonOne addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    [recognizer release];
	
    recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
	recognizer.minimumPressDuration = 1.0f;	// default is 0.4f
    [toolButtonTwo addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    [recognizer release];
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	
    // If gesture was within bounds of timelineView then allow
    if ((touch.view == toolButtonOne)) {
        return YES;
    }
    if ((touch.view == toolButtonTwo)) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	UITouch *touch = [touches anyObject];	
	//CGPoint location = [touch locationInView: [touch view]];
	
	if ([touch view] == toolButtonOne) {
		// Change to active shape
		//NSLog(@"touchesBegan: toolButtonOne");
		CGAffineTransform transform = CGAffineTransformMakeScale(2.0,2.0);
		toolButtonOne.transform = transform;
	}
	if ([touch view] == toolButtonTwo) {
		// Change to active shape
		//NSLog(@"touchesBegan: toolButtonOne");
		CGAffineTransform transform = CGAffineTransformMakeScale(2.0,2.0);
		toolButtonOne.transform = transform;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	UITouch *touch = [touches anyObject];	
	CGPoint location = [touch locationInView:self.view];
	
	if ([touch view] == toolButtonOne) {
		toolButtonOne.center = CGPointMake(location.x, location.y);	// 47 = height of navigation bar
		//NSLog(@"touchesMoved: toolButtonOne (%2.f, %2.f)", location.x, location.y);
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	UITouch *touch = [touches anyObject];	
	//CGPoint location = [touch locationInView: [touch view]];
	
	if ([touch view] == toolButtonOne) {
		// Change back to dynamic shape
		NSLog(@"touchesEnded: toolButtonOne");
		isUserMovingIcons = NO;
		CGAffineTransform transform = CGAffineTransformMakeScale(1.0,1.0);
		toolButtonOne.transform = transform;
		for (int i=0; i<[iconViews count]; i++) {
			UIView *view = [iconViews objectAtIndex:i];
			if ([view class] != [NSNull class]) {
				// Loop over all icon views, add "dancing" animation to each
				[UIView animateWithDuration:0.2 
									  delay:0.0 
									options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 view.alpha = 1.0;
									 view.transform = CGAffineTransformIdentity;	
								 }
								 completion:^(BOOL finished){
									 view.transform = CGAffineTransformIdentity;	
								 }];
			}
		}
	}
}
	
@end
