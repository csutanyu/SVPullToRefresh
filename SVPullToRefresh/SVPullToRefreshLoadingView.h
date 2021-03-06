//
//  SVPullToRefreshLoadingView.h
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "SVLoadingViewProtocol.h"

@interface SVPullToRefreshLoadingView : UIView <SVLoadingViewProtocol>
@property (copy, nonatomic) NSArray<UIImage *> *dragingAnimationImages;
@property (copy, nonatomic) NSArray<UIImage *> *loadingAnimationImages;

- (void)startLoading;
- (void)stopLoading;

- (void)updateTriggerWithPercent:(CGFloat)percent state:(SVPullToRefreshState)state;
@end
