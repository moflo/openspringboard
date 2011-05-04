//
//  OpenSpringBoardVC.h
//  openspringboard
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenSpringBoard.h"

@interface OpenSpringBoardVC : UIViewController <OpenSpringBoardDelegate> {

	OpenSpringBoard *_openSpringBoard;
	
	NSMutableArray *itemArray;						//!< Array to store the icon information & order
	
}
@property (nonatomic,retain) OpenSpringBoard *openSpringBoard;

@end
