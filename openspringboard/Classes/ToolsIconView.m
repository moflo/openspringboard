//
//  ToolsIconView.m
//  openspringboard
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "ToolsIconView.h"
#import <QuartzCore/QuartzCore.h>


@implementation UILabelOvalBadge
//! Class override to draw badge behind label in textview

- (void) awakeFromNib {
	//! Load UILabel from NIB, apply CGLayer tranforms
	// Add rounded edges
	[[self layer] setCornerRadius:9.5f];
	
	// Add border with white color
    [[self layer] setBorderWidth:2.2f];
    [[self layer] setBorderColor:[[UIColor whiteColor] CGColor]];
	
}

- (void)drawTextInRect:(CGRect)rect {
	//! Class override to draw gradient on UILabel
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	//CGContextClip(context);
	
	CGGradientRef gradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 4;
	CGFloat locations[4] = { 0.0, 0.5, 0.5, 1.0 };
	CGFloat components[16] = {	243/255., 173/255., 173/255., 1.0,  // Start color
		228/255., 76/255., 83/255., 1.0,    // Middle color
		218/255., 8/255., 18/255., 1.0,     // End color
		218/255., 8/255., 18/255., 1.0 };   // End color
	
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	//CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
	CGPoint botCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
	CGContextDrawLinearGradient(context, gradient, topCenter, botCenter, 0);
	
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(rgbColorspace);             
	
	[super drawTextInRect:rect];
	
}
@end

@implementation UIToolIconButton
@synthesize containerView;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
    //NSLog(@"UIToolIconButton touchesBegan");
    [super touchesBegan:touches withEvent:event]; 
	if (containerView) {
		if ([containerView respondsToSelector:@selector(touchesBegan:withEvent:)]) {
			[containerView touchesBegan:touches withEvent:event];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {  
    //NSLog(@"UIToolIconButton touchesMoved");
    [super touchesMoved:touches withEvent:event]; 
	if (containerView) {
		if ([containerView respondsToSelector:@selector(touchesMoved:withEvent:)]) {
			[containerView touchesMoved:touches withEvent:event];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
    //NSLog(@"UIToolIconButton touchesEnded");
    [super touchesEnded:touches withEvent:event]; 
	if (containerView) {
		if ([containerView respondsToSelector:@selector(touchesEnded:withEvent:)]) {
			[containerView touchesEnded:touches withEvent:event];
		}
	}
}

@end


@implementation ToolsIconView 
@synthesize toolIconButton, badgeCountLabel, toolLabel;

//! ToolsIconView loaded from NIB, used by OpenSpringBoard method


@end

