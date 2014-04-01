//
//  DetailViewController.m
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "DetailViewController.h"
#import "PullInteraction.h"
#import "RootViewController.h"

@interface DetailViewController ()
{
    PullInteraction* _pullInteraction;
    
    IBOutlet UIPanGestureRecognizer *_panGesture;
    CGPoint _panBeginPoint;
    CGFloat _percentComplete;
}
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firedPan:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // RootViewController を探す
            NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
            currentIndex = currentIndex > 0 ? (currentIndex-1) : 0;
            
            RootViewController* rootViewController = [self.navigationController.viewControllers[currentIndex] isKindOfClass:[RootViewController class]] ? (RootViewController*)self.navigationController.viewControllers[currentIndex] : nil;
            
            _pullInteraction = [[PullInteraction alloc] init];
            rootViewController.interactiveTransitioning = _pullInteraction;
            _pullInteraction.delegate = rootViewController;
            
            [self.navigationController popViewControllerAnimated:YES];

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if( _pullInteraction != nil ){
                CGPoint translation = [panGesture translationInView:self.view];
//            NSLog(@"translation=%@",[NSValue valueWithCGPoint:translation]);
                
                UIViewController *fromVC = [_pullInteraction.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
                
                // ビューの位置を更新
                CGRect frame = fromVC.view.frame;
                frame.origin.y = translation.y;
                fromVC.view.frame = frame;
                
                // 画面遷移の進捗を更新
#define PULL_MAX 120.0f
                _percentComplete = frame.origin.y < 0 ? 0 : frame.origin.y / PULL_MAX;
                _percentComplete = _percentComplete > 1.0 ? 1.0 : _percentComplete;
                
                [_pullInteraction.transitionContext updateInteractiveTransition:_percentComplete];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if( _pullInteraction != nil ){
                CGPoint translation = [panGesture translationInView:self.view];
//            NSLog(@"translation=%@",[NSValue valueWithCGPoint:translation]);
                
                if (translation.y <= PULL_MAX)
                {
                    UIViewController *fromVC = [_pullInteraction.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
                    CGRect frame = [_pullInteraction.transitionContext initialFrameForViewController:fromVC];
                    NSTimeInterval duration = _pullInteraction.transitionDuration *  _percentComplete / [_pullInteraction completionSpeed];
                    
                    [_pullInteraction.transitionContext cancelInteractiveTransition];
                        // インタラクティブ画面遷移をキャンセル

                    [UIView animateWithDuration:duration delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
                        fromVC.view.frame = frame;
                        
                    } completion:^(BOOL finished) {
                        [_pullInteraction.transitionContext completeTransition:NO];
                        
                        [_pullInteraction.delegate pullInteractionDidFinish:_pullInteraction];
                            // delegate 呼び出し
                        _pullInteraction = nil;
                    }];
                    
                } else {
                    id fromVC = [_pullInteraction.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
                    id toVC = [_pullInteraction.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

                    CGRect frame = [_pullInteraction.transitionContext initialFrameForViewController:fromVC];
                    frame =CGRectOffset(frame, .0f, frame.size.height);
                    NSTimeInterval duration = _pullInteraction.transitionDuration *  _percentComplete / [_pullInteraction completionSpeed];

                    [_pullInteraction.transitionContext finishInteractiveTransition];
                        // インタラクティブ画面遷移を終了

                    DetailViewController* detailViewController = [fromVC isKindOfClass:[DetailViewController class]] ? fromVC : nil;
                    UIView *fromView = detailViewController.view;
                    
                    RootViewController* rootViewController = [toVC isKindOfClass:[RootViewController class]] ? toVC : nil;
                    UIView *toView = rootViewController.view;
                    
                    CGRect centerViewPlaceHolderRect = rootViewController.circlePlaceholderView.frame;
                    UIView *containerView = [_pullInteraction.transitionContext containerView];
                    
                    UIView *circleView = detailViewController.circleView;
                    circleView.frame = CGRectOffset(circleView.frame, .0f, translation.y );
                    
                    [circleView removeFromSuperview];
                    [containerView addSubview:circleView];
                    
                    [UIView animateWithDuration:duration delay:.0f usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
                        fromView.frame = frame;
                        circleView.frame = centerViewPlaceHolderRect;
                    } completion:^(BOOL finished) {
                        // サークルを遷移先に移動
                        [circleView removeFromSuperview];
                        [toView addSubview:circleView];
                        rootViewController.circleView = circleView;
                        [circleView setNeedsDisplay];
                        
                        [circleView addGestureRecognizer:rootViewController.circleTapGesture];
                        
                        
                        [_pullInteraction.transitionContext completeTransition:YES];
                        
                        [_pullInteraction.delegate pullInteractionDidFinish:_pullInteraction];
                            // delegate 呼び出し
                        _pullInteraction = nil;
                    }];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end

