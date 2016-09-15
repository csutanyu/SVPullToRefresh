//
//  SVLoadingView.h
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVPullToRefresh.h"

@interface SVLoadingView : UIView

@property (copy, nonatomic) NSArray<UIImage *> *images;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images;

- (void)startLoading;

- (void)stopLoading;

- (void)updateTriggerWithPercent:(CGFloat)percent state:(SVPullToRefreshState)state;

@end
