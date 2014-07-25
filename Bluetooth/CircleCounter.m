//
//  CircleCounter.m
//  Color
//
//  Created by john on 7/7/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "CircleCounter.h"
@interface CircleCounter()
@property (nonatomic) double currentPosition;
@property (strong,nonatomic) UILabel *label;
@end

@implementation CircleCounter

- (void)setCurrentPosition:(double)currentPosition
{
    _currentPosition = currentPosition;
    int i = (int)self.currentPosition * 100;
    [self.label setText:[NSString stringWithFormat:@"%i%%",i]];
    [self setNeedsDisplay];

}

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    
    self.circleColor = [UIColor greenColor];
    self.circleBackgroundColor = JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT;
    self.circleWidth = JWG_CIRCLE_TIMER_WIDTH;
    


}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];

    }
    return self;
}

- (void)start
{
    self.currentPosition = 0.0;
    [self setNeedsDisplay];
}

- (void)increment
{
    if (self.currentPosition < 1){
        self.currentPosition += 0.01;
    }
    [self setNeedsDisplay];
}

- (void)decrement
{
    if (self.currentPosition > 0) {
        self.currentPosition -= 0.01;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - self.circleWidth/2.0f;
    float angleOffset = M_PI_2;
    
    // Draw the background of the circle.
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    0,
                    2*M_PI,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleBackgroundColor CGColor]);
    CGContextStrokePath(context);
    
    // Draw the remaining amount of timer circle.
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGFloat startAngle = ((CGFloat)self.currentPosition*M_PI*2 - angleOffset);
    CGFloat endAngle = 2*M_PI - angleOffset;
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    startAngle,
                    endAngle,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleColor CGColor]);
    CGContextStrokePath(context);
    
    NSLog(@"%f", self.currentPosition);
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x - 50, self.bounds.origin.y - 50, 100, 100)];
    [self addSubview:self.label];
    int i = (int)self.currentPosition * 100;
    self.label.text = [NSString stringWithFormat:@"%i%%",i];
}


@end
