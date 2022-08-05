//
//  Animator.m
//  CustomContainerViewController
//
//  Created by ren.dongpo on 2022/8/2.
//

#import "Animator.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.3;
}

/// UIKit calls this method when presenting or dismissing a view controller. Use this method to configure the animations associated with your custom transition. You can use view-based animations or Core Animation to configure your animations.
-  (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.view.frame = [transitionContext initialFrameForViewController:toVC];
    fromVC.view.frame = [transitionContext initialFrameForViewController:fromVC];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = [transitionContext finalFrameForViewController:fromVC];
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
