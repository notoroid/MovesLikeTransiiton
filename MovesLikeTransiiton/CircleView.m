//
//  CircleView.m
//  MovesLikeTransiiton
//
//  Created by 能登 要 on 2014/03/29.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.133 green: 0.827 blue: 0.373 alpha: 1];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [color setFill];
    [ovalPath fill];

}

@end
