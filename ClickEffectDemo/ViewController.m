//
//  ViewController.m
//  ClickEffectDemo
//
//  Created by monkey2016 on 17/2/23.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UIImageView *testImgView;

@property (nonatomic,strong) UITapGestureRecognizer *singleTap1;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给testLabel添加单机手势
    _singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapACTION1:)];
    self.testLabel.userInteractionEnabled = YES;
    [self.testLabel addGestureRecognizer:_singleTap1];
    
    //给testImgView添加单机手势
    _singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapACTION2:)];
    self.testImgView.userInteractionEnabled = YES;
    [self.testImgView addGestureRecognizer:_singleTap2];
    
}


// 点击label
-(void)singleTapACTION1:(UITapGestureRecognizer *)sender{
    //防止手势冲突
    [sender requireGestureRecognizerToFail:_singleTap2];
    
    CGPoint location = [sender locationInView:self.testLabel];
    NSLog(@"location:(%f,%f)",location.x,location.y);
    [self addClickEffectForView:self.testLabel withClickPointInSuperView:location withEffectColor:[UIColor redColor] removeWhenFinished:YES];
}

// 点击button
- (IBAction)testBtnACTION:(UIButton *)sender {
    [self addClickEffectForView:sender withClickPointInSuperView:CGPointMake(sender.bounds.size.width/2, sender.bounds.size.height/2) withEffectColor:[UIColor blueColor] removeWhenFinished:YES];
}

// 点击imageView
-(void)singleTapACTION2:(UITapGestureRecognizer *)sender{
    //防止手势冲突
    [sender requireGestureRecognizerToFail:_singleTap1];
    
    CGPoint location = [sender locationInView:self.testImgView];
    NSLog(@"location:(%f,%f)",location.x,location.y);
    [self addClickEffectForView:self.testImgView withClickPointInSuperView:location withEffectColor:[UIColor orangeColor] removeWhenFinished:YES];
}


-(void)addClickEffectForView:(UIView *)view withClickPointInSuperView:(CGPoint)point withEffectColor:(UIColor *)color removeWhenFinished:(BOOL)isRemove {
    view.layer.masksToBounds = YES;
    //创建layer
    CALayer *clickEffectLayer = [CALayer layer];
    CGFloat radius = sqrtf((powf(view.frame.size.width, 2) + powf(view.frame.size.height, 2)));//扩散圆的半径
    
    clickEffectLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    clickEffectLayer.cornerRadius = radius;
    clickEffectLayer.position = point;
    clickEffectLayer.backgroundColor = color.CGColor;
    [view.layer insertSublayer:clickEffectLayer atIndex:0];//将layer放在底层
    //layer动画
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = 1;//重复次数 ( 无限次为:INFINITY )
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = defaultCurve;
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.1;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 1;//动画持续时间
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1;
    opacityAnimation.values = @[@0.4, @0.45, @0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2, @1];//关键帧
    opacityAnimation.removedOnCompletion = NO;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
    [clickEffectLayer addAnimation:animationGroup forKey:@"pulse"];
    //完成动画是否移除
    if (isRemove) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [clickEffectLayer removeFromSuperlayer];
        });
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
