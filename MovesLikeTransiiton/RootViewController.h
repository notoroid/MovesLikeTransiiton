//
//  RootViewController.h
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullInteraction.h"

@interface RootViewController : UIViewController<PullInteractionDelegate>

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIView *backgroundPlaceholderView;
@property (weak, nonatomic) IBOutlet UIView *circlePlaceholderView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *circleTapGesture;
@property (strong, nonatomic)id <UIViewControllerInteractiveTransitioning> interactiveTransitioning;

@end
