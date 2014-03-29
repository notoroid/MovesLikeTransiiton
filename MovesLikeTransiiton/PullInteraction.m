//
//  PullInteraction.m
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "PullInteraction.h"

@implementation PullInteraction

- (void)startInteractiveTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
    // 画面遷移コンテキストを保存
    self.transitionContext = transitionContext;
    
    // 遷移元、遷移先のビューコントローラを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // コンテナビューにビューを追加
    [[transitionContext containerView] insertSubview:toVC.view
                                        belowSubview:fromVC.view];
    // 画面遷移時間を取得し保存
    _transitionDuration = [[fromVC transitionCoordinator] transitionDuration];
}

- (CGFloat)completionSpeed
{
    return .5f;
}


@end
