//
//  fireWorksView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/30.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "fireWorksView.h"

@implementation fireWorksView

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        [self initEmitterLayerProperties];
        
    }
    return self;
}

- (void)initEmitterLayerProperties {
    //初始化一些参数
    self.emitterLayer.emitterShape    = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode     = kCAEmitterLayerOutline;
    self.emitterLayer.emitterSize     = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height - 100);
    // 发射源的渲染模式
    self.emitterLayer.renderMode = kCAEmitterLayerUnordered;
    self.emitterLayer.seed = (5 + (arc4random() % 10));;
    [self show];
}

- (void)show {
    /**
     * 添加发射点
     一个圆（发射点）从底下发射到上面的一个过程
     */
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    rocket.birthRate = 2.0; //是每秒某个点产生的effectCell数量
    rocket.emissionRange = 0.1 * M_PI; // 周围发射角度
    rocket.velocity = 400; // 速度
    rocket.velocityRange = 20.f; // 速度范围
    rocket.yAcceleration = 75; // 粒子y方向的加速度分量
    rocket.lifetime = 1.02;
    
    // 下面是对 rocket 中的内容，颜色，大小的设置
    rocket.contents = (id) [[UIImage imageNamed:@"image_meet_zx12"] CGImage];
    rocket.scale = 0.05;
    rocket.scaleRange = 0.02;
    rocket.spinRange = M_PI; // 子旋转角度范围
    
    /**
     * 添加爆炸的效果，突然之间变大一下的感觉
     */
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 2.5;
    burst.lifetime = 0.35;

    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 1; i <= 56; i++) {
        /**
         * 添加星星扩散的粒子
         */
        CAEmitterCell* spark = [CAEmitterCell emitterCell];
        spark.birthRate = 10;
        spark.velocity = 125;
        spark.emissionRange = 2* M_PI;
        spark.yAcceleration = 85; //粒子y方向的加速度分量
        spark.lifetime = 2;
        spark.contents = (id) ([UIImage imageNamed:[NSString stringWithFormat:@"image_meet_zx%d",i]]).CGImage;
        spark.scaleSpeed =-0.05;
        spark.scale = 0.7;
        spark.scaleRange = 0.1;
        spark.alphaSpeed = -0.25; // 例子透明度的改变速度
        spark.spin = 2* M_PI; // 子旋转角度
        spark.spinRange = 0.3* M_PI;
        [array addObject:spark];
    }
    
    // 将 CAEmitterLayer 和 CAEmitterCell 结合起来
    self.emitterLayer.emitterCells = [NSArray arrayWithObject:rocket];
    //在圈圈粒子的基础上添加爆炸粒子
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    //在爆炸粒子的基础上添加星星粒子
    burst.emitterCells = [NSArray arrayWithArray:array];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
