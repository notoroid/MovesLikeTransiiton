//
//  PullInteraction.h
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullInteractionDelegate;

@interface PullInteraction : NSObject<UIViewControllerInteractiveTransitioning>
@property (weak,nonatomic) id<PullInteractionDelegate> delegate;
@property (strong,nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@property (assign,nonatomic) CGFloat transitionDuration;
@end

@protocol PullInteractionDelegate <NSObject>

- (void) pullInteractionDidFinish:(PullInteraction *)pullInteraction;

@end