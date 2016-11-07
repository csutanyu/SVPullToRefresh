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
@property (strong, nonatomic) UILabel *textLabel;
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
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor grayColor];
  self.textLabel = label;
  [self addSubview:label];
  self.textLabel.frame = self.frame;
  self.textLabel.hidden = YES;
}

- (void)setLoadingAnimationImages:(NSArray<UIImage *> *)loadingAnimationImages {
  _loadingAnimationImages = [loadingAnimationImages copy];
  if (loadingAnimationImages.count) {
    UIImage *image = loadingAnimationImages.firstObject;
    CGPoint origin = CGPointMake(roundf((self.bounds.size.width-image.size.width)/2), roundf((self.bounds.size.height-image.size.height)/2));
    CGRect frame = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
    self.imageView.frame = frame;
    self.currentImage = image;
  }
}

- (void)startLoading {
//  NSLog(@"%s", __PRETTY_FUNCTION__);
  if (self.loadingAnimationImages.count == 0) {
    return;
  }
  if (self.imageView.isAnimating) {
    return;
  }
  self.textLabel.hidden = YES;
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
//  NSLog(@"is Animating: %d, %s", self.imageView.isAnimating, __PRETTY_FUNCTION__);
  if (self.imageView.isAnimating) {
    [self.imageView stopAnimating];
    [self animationDone];
    self.imageView.image = nil;
  }
}

- (NSString *)textTips {
  return self.textLabel.text;
}

- (void)setTextTips:(NSString *)textTips {
  [self stopLoading];
  self.textLabel.hidden = NO;
  self.textLabel.text = textTips;
}

- (UIColor *)tipsTextColor {
  return self.textLabel.textColor;
}

- (void)setTipsTextColor:(UIColor *)tipsTextColor {
  self.textLabel.textColor = tipsTextColor;
}

@end
