//
//  BigAnimOperation.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "BigAnimOperation.h"
//大动画队列
@interface BigAnimOperation()
//结束
@property (nonatomic, getter = isFinished)  BOOL finished;
//执行
@property (nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation BigAnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)initBigAnimationWithAnimationView:(UIView *)animView time:(int64_t)time{
    BigAnimOperation * op = [[BigAnimOperation alloc] init];
    op.animView = animView;
    op.time = time;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //添加动画队列
        
        
    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"BigisExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"BigisExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"BigisFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"BigisFinished"];
}





@end
