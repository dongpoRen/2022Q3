//
//  PrivateTransitioningContext.m
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/2.
//

#import "PrivateTransitioningContext.h"

@interface PrivateTransitioningContext ()

@property (nonatomic, assign) CGRect initialFrameFromRect;
@property (nonatomic, assign) CGRect finalFrameFromRect;
@property (nonatomic, assign) CGRect initialFrameToRect;
@property (nonatomic, assign) CGRect finalFrameToRect;

@property (nonatomic, strong) NSDictionary *viewControllers;
@property (nonatomic, strong) NSDictionary *views;

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property(nonatomic, assign) CGAffineTransform targetTransform;

@end

@implementation PrivateTransitioningContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
    if (self = [super init]) {
        self.containerView = fromViewController.view.superview;
        self.presentationStyle = UIModalPresentationCustom;
        self.targetTransform = CGAffineTransformIdentity;
            
        self.viewControllers = @{
            UITransitionContextFromViewControllerKey: fromViewController,
            UITransitionContextToViewControllerKey: toViewController
        };
        self.views = @{
            UITransitionContextFromViewKey: fromViewController.view,
            UITransitionContextToViewKey: toViewController.view
        };
        
        CGFloat viewWidth = CGRectGetWidth(self.containerView.bounds);
        CGFloat travalDistance = (goingRight ? -viewWidth : viewWidth);
        self.initialFrameFromRect = self.containerView.bounds;
        self.initialFrameToRect = CGRectOffset(self.containerView.bounds, -travalDistance, 0);
        self.finalFrameFromRect = CGRectOffset(self.containerView.bounds, travalDistance, 0);
        self.finalFrameToRect = self.containerView.bounds;
        
    }
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.initialFrameFromRect;
    } else {
        return self.initialFrameToRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.finalFrameFromRect;
    } else {
        return self.finalFrameToRect;
    }
}

// This must be called whenever a transition completes (or is cancelled.)
// Typically this is called by the object conforming to the
// UIViewControllerAnimatedTransitioning protocol that was vended by the transitioning
// delegate.  For purely interactive transitions it should be called by the
// interaction controller. This method effectively updates internal view
// controller state at the end of the transition.
- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (__kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key {
    return self.viewControllers[key];
}

- (__kindof UIView *)viewForKey:(UITransitionContextViewKey)key {
    return self.views[key];
}

- (BOOL)transitionWasCancelled {
    return NO;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}
- (void)pauseInteractiveTransition {}


@end
