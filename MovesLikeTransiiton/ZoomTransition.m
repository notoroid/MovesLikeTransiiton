//
//  ZoomTransition.m
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "ZoomTransition.h"
#import "RootViewController.h"
#import "DetailViewController.h"

@implementation ZoomTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    id fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    id toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    RootViewController* rootViewController = [fromVC isKindOfClass:[RootViewController class]] ? fromVC : nil;
    UIView *fromView = rootViewController.view;
    
    DetailViewController* detailViewController = [toVC isKindOfClass:[DetailViewController class]] ? toVC : nil;
    UIView *toView = detailViewController.view;
    
    
    UIView* circleView = rootViewController.circleView;
    [circleView removeFromSuperview];
    [circleView removeGestureRecognizer:rootViewController.circleTapGesture];
        // ジェスチャを削除

    CGRect centerViewPlaceHolderRect = detailViewController.circlePlaceholderView.frame;
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    [containerView addSubview:circleView];
    
    
    CGRect toViewOriginalRect = toView.frame;
    [UIView animateWithDuration:.5f delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        toView.frame = toViewOriginalRect;
        circleView.frame = centerViewPlaceHolderRect;
        
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [circleView removeFromSuperview];
        [toView addSubview:circleView];
        detailViewController.circleView = circleView;
        [circleView setNeedsDisplay];
        
        BOOL completed = [transitionContext transitionWasCancelled] ? NO : YES;
        [transitionContext completeTransition:completed];
    }];
     
    
    
    
    
}
@end
