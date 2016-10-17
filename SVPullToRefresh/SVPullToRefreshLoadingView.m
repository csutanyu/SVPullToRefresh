//
//  SVPullToRefreshLoadingView.m
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "SVPullToRefreshLoadingView.h"

@interface SVPullToRefreshLoadingView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *currentImage;
@end

@implementation SVPullToRefreshLoadingView

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

- (void)setDragingAnimationImages:(NSArray<UIImage *> *)dragingAnimationImages {
  _dragingAnimationImages = [dragingAnimationImages copy];
  if (dragingAnimationImages.count) {
    UIImage *image = dragingAnimationImages.firstObject;
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.imageView.frame = frame;
    self.imageView.image = image;
    self.frame = frame;
    self.currentImage = image;
  }
}

- (void)setLoadingAnimationImages:(NSArray<UIImage *> *)loadingAnimationImages {
  _loadingAnimationImages = loadingAnimationImages;
  self.imageView.animationImages = _loadingAnimationImages;
}

- (void)startLoading {
//  NSLog(@"%s", __PRETTY_FUNCTION__);
  if (self.loadingAnimationImages.count == 0) {
    return;
  }
  if (self.imageView.isAnimating) {
    return;
  }
  
  NSTimeInterval duration = 1.0;
//  self.imageView.animationImages = self.loadingAnimationImages;
  self.imageView.animationDuration = duration;
  self.imageView.animationRepeatCount = NSIntegerMax;
  [self.imageView startAnimating];
}

- (void)animationDone {
  self.currentImage = self.dragingAnimationImages.firstObject;
  self.imageView.image = self.currentImage;
}

- (void)stopLoading {
//  NSLog(@"is Animating: %d, %s", self.imageView.isAnimating, __PRETTY_FUNCTION__);
  if (self.imageView.isAnimating) {
    [self.imageView stopAnimating];
    [self animationDone];
  }
}

- (void)updateTriggerWithPercent:(CGFloat)percent state:(SVPullToRefreshState)state {
  NSParameterAssert(percent <= 1.0);
  [self stopLoading];
  
  if (state == SVPullToRefreshStateStopped) {
    self.imageView.image = self.dragingAnimationImages.lastObject;
    return;
  }
  if (state == SVPullToRefreshStateAll || state == SVPullToRefreshStateLoading) {
    return;
  }
  CGFloat percentUnit = 1.0 / self.dragingAnimationImages.count;
  NSInteger index = floor((percent / percentUnit));
  if (index >= self.dragingAnimationImages.count - 1) {
    index = self.dragingAnimationImages.count - 1;
  }
  UIImage *image= self.dragingAnimationImages[index];
  if (image != self.currentImage) {
//    NSLog(@"Set new Image");
    self.imageView.image = image;
    self.currentImage = image;
  }
  
}

@end
