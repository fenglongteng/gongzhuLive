//
//  CAEmitterLayerView.m
//  Weather
//
//  Created by Anvei on 16/3/21.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "CAEmitterLayerView.h"

@interface CAEmitterLayerView(){
    CAEmitterLayer * _emitterLayer;
}

@end

@implementation CAEmitterLayerView
//创建layer的过程中把CALayer替换成CAEmitterLayer
+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _emitterLayer = (CAEmitterLayer *)self.layer;
        
    }
    return self;
}

- (void)setEmitterLayer:(CAEmitterLayer *)layer {
    _emitterLayer = layer;
}

- (CAEmitterLayer *)emitterLayer {
    return _emitterLayer;
}

- (void)show {

}


@end

