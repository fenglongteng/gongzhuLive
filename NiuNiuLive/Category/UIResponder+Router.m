//
//  UIResponder+Router.m
//  StockGroup
//
//  Created by lsb on 15/4/14.
//  Copyright (c) 2015年 lsb. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)
//响应链遵循：先冒泡后捕获。
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    //把事件往上传递
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
