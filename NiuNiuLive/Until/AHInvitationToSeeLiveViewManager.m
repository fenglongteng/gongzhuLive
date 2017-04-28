//
//  AHInvitationToSeeLiveView.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/26.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHInvitationToSeeLiveViewManager.h"
#import "UIImageView+CornerRadius.h"
#import "UIView+ST.h"
@interface AHInvitationToSeeLiveViewManager()

//view更新消息定时器
@property(nonatomic, strong)NSTimer *timer;

//消息model数组
@property(nonatomic, strong) NSMutableArray *array;

//三个消息view
@property(nonatomic, strong)AHInvitationToSeeLiveView *view1;

@property(nonatomic, strong)AHInvitationToSeeLiveView *view2;

@property(nonatomic, strong)AHInvitationToSeeLiveView *view3;
@end
@implementation AHInvitationToSeeLiveViewManager

+(instancetype)Manager{
    static AHInvitationToSeeLiveViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AHInvitationToSeeLiveViewManager alloc]init];
    });
    return manager;
}

-(void)addInvitationView:(AHMessageModel*)messageModel{
    @synchronized (self) {
       [self.array addObject:messageModel];
    }
}


-(void)show{
    [self timer];
}

-(void)setUpView{
    if (self.array.count > 3) {
        NSArray *prefixArray = [self.array subarrayWithRange:NSMakeRange(0, 3)];
        @synchronized (self) {
            [self.array removeObjectsInRange:NSMakeRange(0, 3)];
        }
        [self showPrefixArray:prefixArray];
    }else{
        [self showPrefixArray:self.array];
        @synchronized (self) {
            [self dismiss];
        }
    }
}

-(void)dismiss{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.array removeAllObjects];
        [_view1 removeFromSuperview];
        [_view2 removeFromSuperview];
        [_view3 removeFromSuperview];
        _view1 = nil;
        _view2 = nil;
        _view3 = nil;
        _array = nil;
        [_timer invalidate];
        _timer = nil;
    });

}

-(void)showPrefixArray:(NSArray*)prefixArray{
    [prefixArray enumerateObjectsUsingBlock:^(AHMessageModel *messageModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [self.view1 setMessageModel:messageModel];
        }else if(idx == 1){
            [self.view2 setMessageModel:messageModel];
        }else{
            [self.view3 setMessageModel:messageModel];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.52 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (prefixArray.count<3) {
            self.view2.hidden = 3-prefixArray.count ==2?YES:NO;
            self.view3.hidden = YES;
        }
        
    });
}

-(NSMutableArray*)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(AHInvitationToSeeLiveView*)view1{
    if (!_view1) {
        UIWindow *window = [AppDelegate getAppdelegateWindow];
        _view1 = [[AHInvitationToSeeLiveView alloc]init];
        _view1.frame = CGRectMake(-12, 200 + (58 + 15)*0, 203, 58);
        _view1.alpha = 0;
        [window addSubview:_view1];
    }
    return _view1;
}

-(AHInvitationToSeeLiveView*)view2{
    if (!_view2) {
        UIWindow *window = [AppDelegate getAppdelegateWindow];
        _view2 = [[AHInvitationToSeeLiveView alloc]init];
        _view2.frame = CGRectMake(-12, 200 + (58 + 15)*1, 203, 58);
        _view2.alpha = 0;
        [window addSubview:_view2];
    }
    return _view2;
}

-(AHInvitationToSeeLiveView*)view3{
    if (!_view3) {
        UIWindow *window = [AppDelegate getAppdelegateWindow];
        _view3 = [[AHInvitationToSeeLiveView alloc]init];
        _view3.frame = CGRectMake(-12, 200 + (58 + 15)*2, 203, 58);
        _view3.alpha = 0;
        [window addSubview:_view3];
    }
    return _view3;
}

-(NSTimer*)timer{
    if (!_timer) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:3 target:self selector:@selector(setUpView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


@end


@implementation AHInvitationToSeeLiveView
-(instancetype)init{
    if ([super init]) {
        [self setUpView];
        
    }
    return self;
}

-(void)setUpView{
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
    [_headImageView addBorderColor:[UIColor whiteColor] andwidth:3 andCornerRadius:29];
    [self addSubview:_headImageView];
    
    UIImage *messageBackgroudImage = [UIImage imageNamed:@"image_nn_kbl"];
    _messageBackgroudImageView = [[UIImageView alloc]initWithImage:messageBackgroudImage];
    CGSize messageBackgroudImageViewSize = messageBackgroudImage.size;
    _messageBackgroudImageView.frame = CGRectMake(45, 0, messageBackgroudImageViewSize.width, messageBackgroudImageViewSize.height);
    [_messageBackgroudImageView setCenterY:_headImageView.centerY];
    _messageBackgroudImageView.clipsToBounds = YES;
    [self addSubview:_messageBackgroudImageView];
    
    UIImage *deleteImage = [UIImage imageNamed:@"image_nn_kblclose"];
    
    _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, _messageBackgroudImageView.width - deleteImage.size.width - 13, 12)];
    _nickNameLabel.textColor  = [UIColor blackColor];
    [self.messageBackgroudImageView addSubview:_nickNameLabel];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11 +12 + 7, _messageBackgroudImageView.width - deleteImage.size.width - 13, 13)];
    _messageLabel.textColor = [UIColor lightGrayColor];
    [self.messageBackgroudImageView addSubview:_messageLabel];
    
    _deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deletButton setImage:deleteImage forState:UIControlStateNormal];
    _deletButton.size = deleteImage.size;
    [_deletButton  setX: (_messageBackgroudImageView.width - _deletButton.width - 9)];
    [self.messageBackgroudImageView addSubview:self.deletButton];
     [_deletButton setCenterY: self.messageBackgroudImageView.centerY-5];
    [_deletButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hideView{
    self.alpha = 0;
}

-(void)setMessageModel:(AHMessageModel *)messageModel{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            _nickNameLabel.text = messageModel.nickName;
            _messageLabel.text = messageModel.message;
        }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    });
}


@end
