//
//  UIBezierPath+N_thOrderBezier.m
//  N-thOrderBezier
//
//  Created by sdanke on 16/4/16.
//  Copyright © 2016年 sdanke. All rights reserved.
//

#import "UIBezierPath+N_thOrderBezier.h"

@implementation UIBezierPath (N_thOrderBezier)

+ (instancetype)bezierPathWithPoints:(NSArray *)points {
    
    
    NSUInteger count = points.count;
    if (count < 2) {
        return nil;
    }
    
    NSMutableArray *coors = [NSMutableArray arrayWithArray:points];
    CGPoint fromPoint = [[coors firstObject] CGPointValue];
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    
    CGFloat u = 0;
    while (u <= 1) {
        
        for(int i = 1; i < count; i++) {
            
            for(int j = 0; j < count - i; j++) {
                
                CGFloat x = [coors[j] CGPointValue].x * (1 - u) + [coors[j + 1] CGPointValue].x * u;
                CGFloat y = [coors[j] CGPointValue].y * (1 - u) + [coors[j + 1] CGPointValue].y * u;
                coors[j] = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            }
            
        }
        
        CGPathMoveToPoint(cgPath, NULL, fromPoint.x, fromPoint.y);
        CGPathAddLineToPoint(cgPath, NULL, [[coors firstObject] CGPointValue].x, [[coors firstObject] CGPointValue].y);
        
        fromPoint = [[coors firstObject] CGPointValue];
        
        u += 0.02/count;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGPathRelease(cgPath);
    return path;
}
@end
