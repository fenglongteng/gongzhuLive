//
//  AHAlertView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAlertView.h"
#import "NSString+Tool.h"
#import "UIImage+extension.h"
typedef void (^CancelHandler)();
@interface AHAlertView()
//背景图片
@property (nonatomic,strong)UIImageView *backImageView;

//弹框提示图片
@property (nonatomic,strong)UIImageView *alertTypeImageV;

//弹框标题
@property (nonatomic,strong)UILabel *alertMessage;

//弹框详情
@property (nonatomic,strong)UILabel *introduceLabel;

//取消按钮
@property (nonatomic,strong)UIButton *cancelBtn;

//取消事件
@property (nonatomic,copy)CancelHandler cancelHandler;

//设置事件
@property (nonatomic,copy)CancelHandler settingHandler;

//任务详情 数组
@property(nonatomic,strong)NSArray *detailArray;

//双选按钮
@property(nonatomic,strong)UIButton *leftButton;

@property(nonatomic,strong)UIButton *rightButton;

//直播状态图片
@property(nonatomic,strong)UIImageView *statusImageView;

//直播状态label
@property(nonatomic ,strong)UILabel *statusLabel;


@end

@implementation AHAlertView
//主播离开//主播有电话来//被踢出//你成为场控//被禁言
- (instancetype)initAlertViewReminderTitle:(NSString *)reminderTitle title:(NSString *)title cancelBtnTitle:(NSString *)cancel cancelAction:(void (^)())cancelHandler{
    self = [super init];
    if (self) {
        [self hostCreateUI];
        [self.cancelBtn setTitle:cancel forState:UIControlStateNormal];
        self.alertMessage.text = reminderTitle;
        self.introduceLabel.text = title;
        self.cancelHandler = cancelHandler;
        self.backgroundColor = AHColor(0, 0, 0, 0.4);
        [self addTarget:self action:@selector(disMissAlert)];
    }
    return self;
}

//任务提示
-(instancetype)initListAlertTitle:(NSString*)title AndDetailInstructions:(NSArray*)detailArray cancelAction:(void (^)())cancelHandler{
    self = [super init];
    if (self) {
        _cancelHandler = cancelHandler;
        _detailArray = detailArray;
        [self taskSetUpView];
        self.alertMessage.text = title;
        [self addTarget:self action:@selector(disMissAlert)];
    }
    return self;
}

//设置提示
- (instancetype)initSetAlertViewTitle:(NSString *)title detailString:(NSString *)detailString AndLeftBt:(NSString *)leftStr AndRight:(NSString*)rightStr  cancelAction:(void (^)())cancelHandler settingAction:(void (^)())settingAcion{
    self = [super init];
    if (self) {
        _cancelHandler = cancelHandler;
        _settingHandler = settingAcion;
        self.alertMessage.text = title;
        self.introduceLabel.text = detailString;
        [self.leftButton setTitle:leftStr forState:UIControlStateNormal];
        [self.rightButton setTitle:rightStr forState:UIControlStateNormal];
        [self settingSetUpView];
        [self addTarget:self action:@selector(disMissAlert)];
    }
    return self;
}

//直播通知提示框
-(instancetype)initLiveNoticeAlertViewHeadImage:(NSString*)urlStr Status:(NSString*)statusStr Title:(NSString *)title detailString:(NSString *)detailString AndLeftBt:(NSString *)leftStr AndRight:(NSString*)rightStr  cancelAction:(void (^)())cancelHandler settingAction:(void (^)())settingAcion{
    self = [super init];
    if (self) {
        _cancelHandler = cancelHandler;
        _settingHandler = settingAcion;
        self.statusLabel.text = statusStr;
        self.alertMessage.text = title;
        self.introduceLabel.text = detailString;
        UIImage *image = DefaultHeadImage;
        image  = [UIImage circleImageWithImage:image borderWidth:2 borderColor:AHColor(230, 237, 237,0.8)];
        [self.alertTypeImageV sd_setImageWithURL:[NSString getImageUrlString:urlStr] placeholderImage:image];
        [self.leftButton setTitle:leftStr forState:UIControlStateNormal];
        [self.rightButton setTitle:rightStr forState:UIControlStateNormal];
        [self liveNoticeSetUpView];
        [self addTarget:self action:@selector(disMissAlert)];
    }
    return self;
}

//设置  主播离开-主播有电话来-被踢出-你成为场控-被禁言 类型
- (void)setAlertType:(AHAlertShowType)alertType{
    _alertType = alertType;
    switch (alertType) {
        case AHAlertAnchorLeave:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_zting"];
            self.alertMessage.text = @"主播离开一会";
            self.introduceLabel.text = @"主播离开一会，软件正在后台运行中，不要心急，主播马上回来。";
            
            break;
        case AHAlertAnchorPhone:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_dhl"];
            self.alertMessage.text = @"主播有电话进来";
            self.introduceLabel.text = @"请耐心等待，当主播接完电话后，精彩直播将会继续进行。";
            
            break;
        case AHAlertBanned:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_tips"];
            self.alertMessage.text = @"您已被管理禁言";
            self.introduceLabel.text = @"您已经被管理禁言，在直播结束后才能把您放出来";
            break;
        case AHAlertMaster:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_ckong"];
            self.alertMessage.text = @"主播将您设置为场控";
            self.introduceLabel.text = @"您已经被主播设置为场控，可以帮忙监督，踢人和禁言的权利。";
            break;
        case AHAlertKictOut:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_tips"];
            self.alertMessage.text = @"您已经被管理踢出";
            self.introduceLabel.text = @"您已经被管理踢出，在直播结束后才能放肆的进TA的直播间。";
            break;
        case AHAlertPushNotification:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_ktxx"];
            self.alertMessage.text = @"开启推送通知";
            self.introduceLabel.text = @"通知关闭后，您可能会错过不少经常的主播房间及好友关注，快快去手机系统[设置]-[通知]-[牛牛直播]设置哦~";
            break;
        case AHAlertViewNoNetwork:
            self.alertTypeImageV.image = [UIImage imageNamed:@"icon_live_nowifi"];
            self.alertMessage.text = @"温馨提示";
            self.introduceLabel.text = @"您当前无网络，请打开您的网络设置，或换个网络好的地方";
        default:
            break;
    }
}

//主播控制view
- (void)hostCreateUI{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.alertTypeImageV];
    [self.backImageView addSubview:self.alertMessage];
    [self.backImageView addSubview:self.introduceLabel];
    [self.backImageView addSubview:self.cancelBtn];
    _backImageView.center = self.center;
    _alertTypeImageV.centerX = _backImageView.width/2;
    _alertTypeImageV.y = 32;
    _alertMessage.frame = CGRectMake(0, 90, _backImageView.width, 25);
    _introduceLabel.frame = CGRectMake(40, CGRectGetMaxY(_alertMessage.frame), _backImageView.width - 80, 40);
    _cancelBtn.frame = CGRectMake(0, _backImageView.height - 45, _backImageView.width, 45);
}

//任务view
-(void)taskSetUpView{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.cancelBtn];
    [self.backImageView addSubview:self.alertMessage];
    _backImageView.center = self.center;
    _alertMessage.frame = CGRectMake(0, 16, _backImageView.width, 25);
    _cancelBtn.frame = CGRectMake(0, _backImageView.height - 45, _backImageView.width, 45);
    //
    if (_detailArray.count>0) {
        for (int i = 0; i<_detailArray.count; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 70+i*20, 5, 5)];
            [self.backImageView addSubview:view];
            view.backgroundColor = [UIColor blackColor];
            [view addCornerRadius:2.5];
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70+i*20, _backImageView.width, 20)];
            detailLabel.centerY = view.centerY;
            detailLabel.text = _detailArray[i];
            detailLabel.textColor = [UIColor blackColor];
            [self.backImageView addSubview:detailLabel];
            [detailLabel sizeToFit];
            detailLabel.font = [UIFont systemFontOfSize: 13];
        }
    }
    
}

//设置view
-(void)settingSetUpView{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.alertMessage];
    [self.backImageView addSubview:self.introduceLabel];
    [self.backImageView addSubview:self.rightButton];
    [self.backImageView addSubview:self.leftButton];
    [self.backImageView addSubview:self.alertTypeImageV];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"bg_live_pop3"];
    _backImageView.image = image;
    _backImageView.size = image.size;
    _introduceLabel.numberOfLines = 0;
    _backImageView.center = self.center;
    _alertTypeImageV.centerX = _backImageView.width/2;
    _alertTypeImageV.y = 32;
    _alertMessage.frame = CGRectMake(0, 90, _backImageView.width, 25);
    _introduceLabel.frame = CGRectMake(40, CGRectGetMaxY(_alertMessage.frame), _backImageView.width - 80, 80);
    _leftButton.frame = CGRectMake(0, _backImageView.height-45, _backImageView.width/2,45);
    _rightButton.frame = CGRectMake(_backImageView.width/2, _backImageView.height-45, _backImageView.width/2, 45);
}

//直播推送View
-(void)liveNoticeSetUpView{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.alertMessage];
    [self.backImageView addSubview:self.introduceLabel];
    [self.backImageView addSubview:self.rightButton];
    [self.backImageView addSubview:self.leftButton];
    [self.backImageView addSubview:self.alertTypeImageV];
    [self.backImageView addSubview:self.statusImageView];
    [self.backImageView addSubview:self.statusLabel];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"bg_live_popsm"];
    _backImageView.image = image;
    _backImageView.size = image.size;
    _leftButton.frame = CGRectMake(0, _backImageView.height-45, _backImageView.width/2,45);
    _rightButton.frame = CGRectMake(_backImageView.width/2, _backImageView.height-45, _backImageView.width/2, 45);
    _introduceLabel.numberOfLines = 0;
    _backImageView.center = self.center;
    _alertTypeImageV.size = CGSizeMake(70, 70);
    _alertTypeImageV.centerX = _backImageView.width/2;
    _alertTypeImageV.y = 32;
    _alertMessage.frame = CGRectMake(0, 150, _backImageView.width, 25);
    _statusImageView.centerX = _backImageView.width/2;
    _statusImageView.y = CGRectGetMaxY(self.alertTypeImageV.frame) -15;
    _statusLabel.frame = CGRectMake(40, CGRectGetMaxY(_alertMessage.frame), _backImageView.width - 80, 20);
    _statusLabel.y = CGRectGetMaxY(self.statusImageView.frame)-_statusLabel.height - 2;
    _introduceLabel.frame = CGRectMake(40, CGRectGetMaxY(_statusImageView.frame)+40, _backImageView.width - 80, 80);
}

#pragma mark 显示、布局

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.backgroundColor = AHColor(0, 0, 0, 0.4);;
        self.clipsToBounds = YES;
    }
    return self;
}

//由于页面布局耦合弹框类型较高不建议在这里面写
- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)showAlert{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.添加自己到窗口上
    [window addSubview:self];
    _backImageView.transform = CGAffineTransformMakeScale(2, 2);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        _backImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    // 3.设置尺寸
    self.frame = window.bounds;
}

- (void)disMissAlert{
    if (self.cancelHandler) {
        self.cancelHandler();
    }
    [self removeFromSuperview];
}

-(void)settingAcion{
    if (self.settingHandler) {
        self.settingHandler();
    }
    [self removeFromSuperview];
}

#pragma mark   懒加载

- (UIButton *)cancelBtn{
    
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(disMissAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIImageView *)alertTypeImageV{
    
    if (_alertTypeImageV == nil) {
        _alertTypeImageV = [[UIImageView alloc]init];
        _alertTypeImageV.image = [UIImage imageNamed:@"icon_live_ckong"];
        _alertTypeImageV.size = _alertTypeImageV.image.size;
        
    }
    return _alertTypeImageV;
}

- (UILabel *)alertMessage{
    
    if (_alertMessage == nil) {
        _alertMessage =[[UILabel alloc]init];
        _alertMessage.font = [UIFont boldSystemFontOfSize:16];
        _alertMessage.textAlignment = NSTextAlignmentCenter;
        _alertMessage.textColor = UIColorFromRGB(0x000000);
    }
    return _alertMessage;
}

- (UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel =[[UILabel alloc]init];
        _introduceLabel.font = [UIFont systemFontOfSize:13.0];
        _introduceLabel.numberOfLines = 2;
        _introduceLabel.textAlignment = NSTextAlignmentCenter;
        _introduceLabel.textColor = UIColorFromRGB(0xa7a7a7);
    }
    return _introduceLabel;
}

- (UIImageView *)backImageView{
    
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"bg_live_pop2"];
        _backImageView.size = _backImageView.image.size;
    }
    return _backImageView;
}

-(UIButton*)leftButton{
    if (nil == _leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_leftButton addTarget:self action:@selector(disMissAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
    
}

-(UIButton*)rightButton{
    if (nil == _rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_rightButton addTarget:self action:@selector(settingAcion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(UIImageView*)statusImageView{
    if (nil == _statusImageView) {
        _statusImageView = [[UIImageView alloc]init];
        _statusImageView.image = [UIImage imageNamed:@"bg_live_poppd"];
        _statusImageView.size = _statusImageView.image.size;
    }
    return _statusImageView;
}

-(UILabel*)statusLabel{
    if (nil == _statusLabel) {
        _statusLabel =[[UILabel alloc]init];
        _statusLabel.font = [UIFont boldSystemFontOfSize:16];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
    }
    return _statusLabel;

}
@end
