//
//  GiftBase.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/4/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "GiftBase.h"
//送礼基础动画相关
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
//大礼物动画
#import "carView.h"
#import "fireWorksView.h"
#import "gemView.h"
#import "NSString+Tool.h"
#import "AppDelegate.h"

@interface GiftBase()

//移动动画View
@property(nonatomic,strong)carView * moveView;
//放大动画View
@property(nonatomic,strong)gemView * scaleView;

@property (nonatomic,weak)UIView *giftView;  //动画底层父视图
@end

@implementation GiftBase

- (void)dealloc{
    self.moveView = nil;
    self.scaleView = nil;
}

+ (GiftBase *)initGiftType{
    static GiftBase * gift;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gift = [[GiftBase alloc] init];
    });
    return gift;
}

- (void)baseGiftAnimationWithModel:(PushGift *)giftModel backView:(UIView *)giftView{
    _giftView = giftView;
    // IM 消息
    GSPChatMessage *msg = [[GSPChatMessage alloc] init];
    msg.text = giftModel.gift.name;
    msg.senderChatID = giftModel.fromUserId;
    msg.senderName = giftModel.nickName;
    // 礼物模型
    GiftModel *gift = [[GiftModel alloc] init];
    gift.headImageUrl = giftModel.avatar;
    gift.name = msg.senderName;
    //礼物图片
    gift.giftUrl = giftModel.gift.icon;
    gift.giftName = msg.text;
    gift.giftCount = giftModel.count;
    NSString * userAndGiftName = [NSString stringWithFormat:@"%@%@",giftModel.fromShowId,msg.text];
    //连发循环
    for (int i = 0; i < giftModel.count; i++) {
        AnimOperationManager *manager = [AnimOperationManager sharedManager];
        manager.parentView = _giftView;
        // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
        [manager animWithUserID:userAndGiftName model:gift finishedBlock:^(BOOL result) {
            
        }];
    }
    //根据动画类型进行显示动画
    [self bigGiftAnimation:giftModel.gift.animation gift:giftModel];
    
}
//大礼物调用动画

- (void)bigGiftAnimation:(int32_t)animation gift:(PushGift *)giftModel{
    if (animation== 0) {
        return;
    }
    if (animation== 1) {
        carView *car = [carView loadCarViewWithPoint:CGPointZero];
        car.backView = _giftView;
        [car.giftImage sd_setImageWithURL:[NSString getImageUrlString:giftModel.gift.icon]];
        NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
        car.curveControlAndEndPoints = pointArrs;
        CGPoint giftViewFormPoint = [_giftView convertPoint:CGPointMake(screenWidth, 500) fromView:[AppDelegate getAppdelegateWindow]];
        CGPoint giftViewToPoint = [_giftView convertPoint:CGPointMake(-225, 100) fromView:[AppDelegate getAppdelegateWindow]];
        [car addAnimationsMoveToPoint:giftViewFormPoint endPoint:giftViewToPoint];
        [_giftView addSubview:car];
        self.moveView = car;
    }else if (animation== 2){
        carView *car = [carView loadCarViewWithPoint:CGPointZero];
        car.backView = _giftView;
        car.scaleToValue = [NSNumber numberWithFloat:2.0];
        [car.giftImage sd_setImageWithURL:[NSString getImageUrlString:giftModel.gift.icon]];
        NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
        car.curveControlAndEndPoints = pointArrs;
        CGPoint giftViewFormPoint = [_giftView convertPoint:CGPointMake(screenWidth, 100) fromView:[AppDelegate getAppdelegateWindow]];
        CGPoint giftViewToPoint = [_giftView convertPoint:CGPointMake(-225, 500) fromView:[AppDelegate getAppdelegateWindow]];
        [car addAnimationsMoveToPoint:giftViewFormPoint endPoint:giftViewToPoint];
        [_giftView addSubview:car];
        self.moveView = car;
    }else if (animation== 4){
        gemView * gem = [gemView loadGemViewWithPoint:CGPointZero];
        [gem.animationImageView sd_setImageWithURL:[NSString getImageUrlString:giftModel.gift.icon]];
        CGPoint point = [_giftView convertPoint:CGPointMake(screenWidth / 2.0, screenHeight / 2.0) fromView:[AppDelegate getAppdelegateWindow]];
        gem.center = point;
        gem.backView = _giftView;
        [gem addGemAnimationFromValue:5 toValue:1.0];
        [_giftView addSubview:gem];
        self.scaleView = gem;
    }else if(animation== 3){
        carView *car = [carView loadCarViewWithPoint:CGPointZero];
        car.backView = _giftView;
        car.scaleToValue = [NSNumber numberWithFloat:2.0];
        [car.giftImage sd_setImageWithURL:[NSString getImageUrlString:giftModel.gift.icon]];
        NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
        car.curveControlAndEndPoints = pointArrs;
        CGPoint giftViewFormPoint = [_giftView convertPoint:CGPointMake(100, screenHeight) fromView:[AppDelegate getAppdelegateWindow]];
        CGPoint giftViewToPoint = [_giftView convertPoint:CGPointMake(screenWidth/2.0+100, -200) fromView:[AppDelegate getAppdelegateWindow]];
        [car addAnimationsMoveToPoint:giftViewFormPoint endPoint:giftViewToPoint];
        [_giftView addSubview:car];
        self.moveView = car;
    }
}
@end
