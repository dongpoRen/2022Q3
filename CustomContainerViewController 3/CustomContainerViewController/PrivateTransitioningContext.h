//
//  PrivateTransitioningContext.h
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivateTransitioningContext : NSObject<UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight;

@property(nonatomic, assign, getter=isAnimated) BOOL animated;
@property(nonatomic, assign, getter=isInteractive) BOOL interactive;
@property (nonatomic, copy) void(^completionBlock)(void);

@end

NS_ASSUME_NONNULL_END
