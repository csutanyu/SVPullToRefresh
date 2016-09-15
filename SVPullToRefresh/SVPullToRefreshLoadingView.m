//
//  SVLoadingView.m
//  SVPullToRefreshDemo
//
//  Created by arvin.tan on 9/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "SVPullToRefreshLoadingView.h"

@interface SVLoadingView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *currentImage;
@end

@implementation SVLoadingView

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

- (instancetype)initWithImages:(NSArray *)images {
  if (self = [super initWithFrame:CGRectZero]) {
    [self commonInit];
    self.images = images;
  }
  return self;
}

- (void)commonInit {
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.imageView = imageView;
  [self addSubview:imageView];
}

- (void)setImages:(NSArray<UIImage *> *)images {
  _images = [images copy];
  if (images.count) {
    UIImage *image = images.firstObject;
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.imageView.frame = frame;
    self.imageView.image = image;
    self.frame = frame;
    self.currentImage = image;
  }
}

- (void)startLoading {
  NSLog(@"%s", __PRETTY_FUNCTION__);
  if (self.images.count == 0) {
    return;
  }
  if (self.imageView.isAnimating) {
    return;
  }
  
  NSTimeInterval duration = 1.0;
  self.imageView.animationImages = self.images;
  self.imageView.animationDuration = duration;
  self.imageView.animationRepeatCount = NSIntegerMax;
  [self.imageView startAnimating];
//  [self performSelector:@selector(animationDone) withObject:nil afterDelay:duration];
}

- (void)animationDone {
  self.currentImage = self.images.firstObject;
  self.imageView.image = self.currentImage;
}

- (void)stopLoading {
  NSLog(@"is Animating: %d, %s", self.imageView.isAnimating, __PRETTY_FUNCTION__);
  if (self.imageView.isAnimating) {
    [self.imageView stopAnimating];
    [self animationDone];
  }
}

- (void)updateTriggerWithPercent:(CGFloat)percent state:(SVPullToRefreshState)state {
  [self stopLoading];
  
  if (state == SVPullToRefreshStateStopped) {
    self.imageView.image = self.images.lastObject;
    return;
  }
  if (state == SVPullToRefreshStateAll || state == SVPullToRefreshStateLoading) {
    return;
  }
//  if (percent > 0 && state == SVPullToRefreshStateStopped) {
//    self.frontCircleLayer.hidden = NO;
//    self.backCircleLayer.hidden = NO;
//    self.pieLayer.hidden = NO;
//  }
//
//  [CATransaction begin];
//  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//  
//  [self updatePie:self.pieLayer forAngle:percent * 360.0f];
//  self.frontCircleLayer.mask = self.pieLayer;
//  
//  [CATransaction commit];
  NSParameterAssert(percent <= 1.0);
  CGFloat percentUnit = 1.0 / self.images.count;
  NSInteger index = floor((percent / percentUnit));
  if (index >= self.images.count - 1) {
    index = self.images.count - 1;
  }
  UIImage *image= self.images[index];
  if (image != self.currentImage) {
    NSLog(@"Set new Image");
    self.imageView.image = image;
    self.currentImage = image;
  }
  
}

@end
