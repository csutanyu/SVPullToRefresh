//
//  SVPullInfiniteScrollingLoadingView.h
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVLoadingViewProtocol.h"

@interface SVInfiniteScrollingLoadingView : UIView <SVLoadingViewProtocol>
@property (copy, nonatomic) NSArray<UIImage *> *loadingAnimationImages;
@property (copy, nonatomic) NSString *textTips;
@property (strong, nonatomic) UIColor *tipsTextColor;

- (void)startLoading;
- (void)stopLoading;
@end
