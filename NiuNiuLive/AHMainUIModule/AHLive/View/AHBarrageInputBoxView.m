//
//  AHBarrageInputBoxView.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/1.
//  Copyright © 2017年 AH. All rights reserved.
//
#import "AHBarrageInputBoxView.h"
#import "AHHighlyAdaptiveTextView.h"
#import "UIView+ST.h"
#import "UIImage+extension.h"
#import "Messages.pbobjc.h"
#define BarrageInputTag 300 //输入框的tag值
static  AHBarrageInputBoxView *barrageInputBoxView;
@interface AHBarrageInputBoxView()

/**
 弹幕开启开关
 */
@property (weak, nonatomic) IBOutlet UIImageView *switchImageView;

/**
 发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBt;

/**
 背景view
 */
@property (weak, nonatomic) IBOutlet UIView *backgroudView;

/**
 textView高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

/**
 输入框
 */
@property (weak, nonatomic) IBOutlet AHHighlyAdaptiveTextView *textView;

/**
 底部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstrant;

//毛玻璃效果
@property (strong, nonatomic)UIVisualEffectView *effectView;

//是否是弹幕 不是弹幕就是消息
@property (nonatomic, assign)BOOL isBarrageis;

//to userID
@property(nonatomic,copy)NSString *toUserId;

@end
@implementation AHBarrageInputBoxView

+(instancetype)shareWithId:(NSString*)userId;{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        barrageInputBoxView = [[AHBarrageInputBoxView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        barrageInputBoxView.tag = BarrageInputTag;
        UIView *view = [[NSBundle mainBundle]loadNibNamed:@"AHBarrageInputBoxView" owner:barrageInputBoxView options:0].firstObject;
        view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [barrageInputBoxView addSubview:view];
        [barrageInputBoxView setUpView];
    });
    barrageInputBoxView.toUserId = userId;
    return barrageInputBoxView;
}

+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        barrageInputBoxView = [[AHBarrageInputBoxView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        UIView *view = [[NSBundle mainBundle]loadNibNamed:@"AHBarrageInputBoxView" owner:barrageInputBoxView options:0].firstObject;
        view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [barrageInputBoxView addSubview:view];
        [barrageInputBoxView setUpView];
    });
    barrageInputBoxView.toUserId = nil;
    return barrageInputBoxView;
}

//更新view
-(void)setUpView{
    //      [barrageInputBoxView.textViewHeightConstraint addObserver:barrageInputBoxView forKeyPath:@"heightContraintChange" options:1 context:nil];
    //圆角
    [self.sendBt addCornerRadius:4];
    //开关
    [self.switchImageView addTarget:self action:@selector(switchChange:)];
    //空白放回
    [self addTarget:self action:@selector(dimiss)];
    //毛玻璃效果
    UIBlurEffect *effect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _effectView.frame = CGRectMake(0, 0, screenWidth, 72);
    [self.backgroudView insertSubview:_effectView atIndex:0];
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backgroudView).offset(0);
    }];
    //textView
    self.textView.constrainH1  = self.textViewHeightConstraint;
    [self.textView setCustomPlaceHoder:@"可以愉快的聊天咯，亲！"];
    [self.textView setCustomPlaceHoderColor:[UIColor whiteColor]];
    WeakSelf;
    self.textView.setUpViewBlock = ^(CGFloat during,CGFloat height){
            weakSelf.bottomViewBottomConstrant.constant = height;
            [weakSelf updateConstraints];
            [UIView animateWithDuration:during  animations:^{
                [weakSelf layoutIfNeeded];
            }];
    };
}

//switch开关
-(void)switchChange:(UITapGestureRecognizer*)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    _isBarrageis = !_isBarrageis;
    [UIView animateWithDuration:0.3 animations:^{
        if (!_isBarrageis) {
            imageView.image = [UIImage imageNamed:@"btn_liver_danmu0"];
            [self.sendBt setTitle:@"弹幕" forState:UIControlStateNormal];
        }else{
            imageView.image = [UIImage imageNamed:@"btn_liver_danmu1"];
            [self.sendBt setTitle:@"发送" forState:UIControlStateNormal];
        }
    }];
    
}

-(void)showOnTheWindow{
    //[[IQKeyboardManager sharedManager] setEnable:NO];
    [self.textView becomeFirstResponder];
    UIWindow *window = [AppDelegate getAppdelegateWindow];
    if (![window  viewWithTag:BarrageInputTag]) {
        [window addSubview:self];
    }
   
}

-(void)showOnTheView:(UIView*)view{
    [view addSubview:self];
    [self.textView becomeFirstResponder];
}

-(void)dimiss{
    //[[IQKeyboardManager sharedManager] setEnable:YES];
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}

/**
 发送弹幕或者聊天消息
 
 @param sender 按钮
 */
- (IBAction)bt_senderAction:(UIButton *)sender {
    SendMessageRequest *sendMessageRequest = [[SendMessageRequest alloc]init];
    //0是普通 1是弹幕
    if (_isBarrageis) {
        sendMessageRequest.type = 1;
    }else{
        sendMessageRequest.type = 0;
    }
    if (_toUserId) {
        sendMessageRequest.toUserId= self.toUserId;
    }
    sendMessageRequest.message = self.textView.text;
    self.textView.text = @"";
    [[AHTcpApi shareInstance]requsetMessage:sendMessageRequest classSite:MessageClassName completion:^(id response, NSString *error) {
        SendMessageResponse *messageRespose = response;
        if (messageRespose.result == 0) {
            LOG(@"发送弹幕或者消息成功");
        }else{
            LOG(@"发送弹幕或者消息失败：%@",messageRespose.message);
        }
    }];
    
    //    static BOOL isBarrage = NO;
    //    isBarrage  = !isBarrage;
    //    if (isBarrage) {
    //        sender.backgroundColor = UIColorFromRGB(0xfff600);
    //        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    }else{
    //        sender.backgroundColor = UIColorFromRGB(0x656065);
    //        [sender setTitleColor:UIColorFromRGB(0xaaa4a3) forState:UIControlStateNormal];
    //    }
}

-(void)dealloc{
    //    [self removeObserver:self forKeyPath:@"heightContraintChange"];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
