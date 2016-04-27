//
//  ViewController.m
//  N-thOrderBezier
//
//  Created by sdanke on 16/4/16.
//  Copyright © 2016年 sdanke. All rights reserved.
//

#import "ViewController.h"
#import "UIBezierPath+N_thOrderBezier.h"

static NSString *const drawAnimationKey = @"drawAnim";
@interface ViewController ()

@property (nonatomic,   weak) IBOutlet UIView   *canvas;
@property (nonatomic, strong) CAShapeLayer      *curveLayer;
@property (nonatomic, strong) NSMutableArray    *points;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    [self setupCurveLayer];
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.canvas addGestureRecognizer:tap];
}

- (void)setupCurveLayer {
    
    self.curveLayer = ({
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor yellowColor].CGColor;
        layer.lineWidth = 1.0;
//        layer.strokeEnd = 0;
        [self.canvas.layer addSublayer:layer];
        layer;
    });
}

- (void)tapAction:(UITapGestureRecognizer *)sender {

    UIView *canvas = sender.view;
    CGPoint touchedPoint = [sender locationInView:canvas];
    [self addPointToCanvas:touchedPoint];
    [self.points addObject:[NSValue valueWithCGPoint:touchedPoint]];
}

- (void)addPointToCanvas:(CGPoint)point {
    
    UIView *p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    p.center = point;
    p.backgroundColor = [UIColor redColor];
    [self.canvas addSubview:p];
    
}

- (IBAction)drawAction:(UIButton *)sender {

    UIBezierPath *path = [UIBezierPath bezierPathWithPoints:self.points];

    self.curveLayer.path = path.CGPath;
    [self startAnimation];
}

- (void)startAnimation {
    
    [self stopAnimation];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @0;
    anim.toValue = @1;
    anim.duration = 0.5;
    anim.removedOnCompletion = NO;
    [self.curveLayer addAnimation:anim forKey:drawAnimationKey];
}

- (void)stopAnimation {
    
    if ([self.curveLayer animationForKey:drawAnimationKey]) {
        [self.curveLayer removeAnimationForKey:drawAnimationKey];
    }
}

- (IBAction)cleanAction:(UIButton *)sender {
    
    self.curveLayer.path = nil;
    [self.canvas.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.points removeAllObjects];
}


- (NSMutableArray *)points {
    
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}


@end
