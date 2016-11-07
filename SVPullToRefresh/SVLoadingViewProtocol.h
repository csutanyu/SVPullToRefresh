//
//  SVLoadingViewProtocol.h
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@protocol SVLoadingViewProtocol <NSObject>
- (void)startLoading;
- (void)stopLoading;

@optional
- (void)updateTriggerWithPercent:(CGFloat)percent state:(SVPullToRefreshState)state;
- (void)setTextTips:(NSString *)tips;
@end
