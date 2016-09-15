//
//  SVPullInfiniteScrollingLoadingView.m
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "SVInfiniteScrollingLoadingView.h"

@interface SVInfiniteScrollingLoadingView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *currentImage;
@end

@implementation SVInfiniteScrollingLoadingView

- (instancetype)init {
  if (self = [super init]) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.imageView = imageView;
  [self addSubview:imageView];
}

- (void)setLoadingAnimationImages:(NSArray<UIImage *> *)loadingAnimationImages {
  _loadingAnimationImages = [loadingAnimationImages copy];
  if (loadingAnimationImages.count) {
    UIImage *image = loadingAnimationImages.firstObject;
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.imageView.frame = frame;
    self.imageView.image = image;
    self.frame = frame;
    self.currentImage = image;
  }
}

- (void)startLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
  if (self.loadingAnimationImages.count == 0) {
    return;
  }
  if (self.imageView.isAnimating) {
    return;
  }
  
  NSTimeInterval duration = 1.0;
  self.imageView.animationImages = self.loadingAnimationImages;
  self.imageView.animationDuration = duration;
  self.imageView.animationRepeatCount = NSIntegerMax;
  [self.imageView startAnimating];
}

- (void)animationDone {
  self.currentImage = self.loadingAnimationImages.firstObject;
  self.imageView.image = self.currentImage;
}

- (void)stopLoading {
  NSLog(@"is Animating: %d, %s", self.imageView.isAnimating, __PRETTY_FUNCTION__);
  if (self.imageView.isAnimating) {
    [self.imageView stopAnimating];
    [self animationDone];
  }
}

@end
