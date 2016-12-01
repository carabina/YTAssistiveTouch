//
//  YTAssistiveTouch.h
//  YTAssistiveTouch
//
//  Created by songyutao on 2016/11/30.
//  Copyright © 2016年 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN    NSString    *const YTAssistiveTouchClickNotification;

@interface YTAssistiveTouch : UIWindow

+ (YTAssistiveTouch *)sharedInstance;

@property(nonatomic, strong)UIImage             *assistiveImage;
@property(nonatomic, assign)BOOL                 canDrag;//default YES

- (void)shake;

- (void)show;

- (void)dismiss;

@end
