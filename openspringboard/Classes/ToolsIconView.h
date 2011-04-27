//
//  ToolsIconView.h
//  openspringboard
//
//  Created by d. nye on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelOvalBadge : UILabel
{
}
@end

@interface UIToolIconButton : UIButton
{
	UIView	*containerView;								//!< UIView containing touch handler
}
@property (nonatomic, retain) UIView	*containerView;
@end

@interface ToolsIconView : UIView {

	IBOutlet UIToolIconButton *toolIconButton;			//!< Button with icon
	IBOutlet UILabelOvalBadge *badgeCountLabel;			//!< Badge count label
	IBOutlet UILabel *toolLabel;						//!< Tool name label
}
@property (nonatomic,retain) UIToolIconButton *toolIconButton;
@property (nonatomic,retain) UILabelOvalBadge *badgeCountLabel;
@property (nonatomic,retain) UILabel *toolLabel;
@end
