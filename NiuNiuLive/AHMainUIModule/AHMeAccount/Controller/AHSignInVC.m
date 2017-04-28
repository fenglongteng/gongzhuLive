//
//  AHSignInVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSignInVC.h"
#import "UIView+ST.h"
#import "AHSignCollectionCell.h"
#import "AHPersonInfoManager.h"
#import "UIImage+extension.h"
#import "NSDate+YYAdd.h"
#import "AHTopUpHistoryVC.h"
#import "NSString+Tool.h"
#define ImageViewTag 300
@interface AHSignInVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 联系登录金币展示
 */
@property (weak, nonatomic) IBOutlet UICollectionView *signCollectionView;

/**
 小黄点view
 */
@property (weak, nonatomic) IBOutlet UIView *pointView;

/**
 完成view
 */
@property (weak, nonatomic) IBOutlet UIView *getGameCurrencyBt;

/**
 配置文件
 */
@property(nonatomic,strong)NSMutableArray *array;

/**
 领取金币数量
 */
@property (weak, nonatomic) IBOutlet UILabel *getCurrencyNumberLabel;

/**
 我的游戏币
 */
@property (weak, nonatomic) IBOutlet UILabel *myNumberLabel;

#pragma mark 约束
/**
 顶部view高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightCostraint;

/**
 我的游戏币view
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myGameCurrencyViewHeightConstraint;

/**
 领取游戏币的顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currencyViewTopContraint;

/**
 领取金币高、宽 度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currencyViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currencyViewHeightConstraint;

/**
 领取金币label的底部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCurrencyLabelBottomConstraint;

/**
 顶部视图title顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewDetailTitleLabelTopConstraint;

//当前签到天数
@property(nonatomic,assign)int64_t accumulationSignedDays;
//动画站位imageView
@property(nonatomic,strong)UIView *imageView;
//文字动画
@property(nonatomic ,strong)NSTimer *timer;
//签到获取的游戏币
@property(nonatomic, assign) int64_t goldCoins;
//提示领取金币
@property (weak, nonatomic) IBOutlet UILabel *tipsToGetGoldLabel;

@property(nonatomic,strong)UsersGetSignedInInfoResponse *signedInInfoResponse;

@end

@implementation AHSignInVC

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getConfigurationFile];
    
    // Do any additional setup after loading the view.
}

//获取签到配置文件
-(void)getConfigurationFile{
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    UsersGetSignedInInfoRequest *getSighedInInfoRequest = [[UsersGetSignedInInfoRequest alloc]init];
    getSighedInInfoRequest.userId = infoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:getSighedInInfoRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetSignedInInfoResponse *signedInInfoResponse = response;
        self.signedInInfoResponse = signedInInfoResponse;
        if (signedInInfoResponse.result == 0) {
            self.array = signedInInfoResponse.signedInInfoArray;
            self.accumulationSignedDays = signedInInfoResponse.accumulationSignedDays;
            [self.signCollectionView reloadData];
            if (infoModel.signed_p) {
                self.getCurrencyNumberLabel.text = @"已领取";
                self.getCurrencyNumberLabel.textColor = AHColor(236, 237, 239, 1);
                self.getGameCurrencyBt.backgroundColor = [UIColor whiteColor];
                self.tipsToGetGoldLabel.hidden = YES;
                self.accumulationSignedDays--;
            }else{
                if (self.accumulationSignedDays > self.array.count) {
                    UsersGetSignedInInfoResponse_SignedInInfo *signInfo = self.array.lastObject;
                    self.getCurrencyNumberLabel.text = [NSString stringWithFormat:@"%lld",signInfo.goldCoins];
                    self.goldCoins = signInfo.goldCoins;
                }else{
                    UsersGetSignedInInfoResponse_SignedInInfo *signInfo = self.array[self.accumulationSignedDays];
                    self.getCurrencyNumberLabel.text = [NSString stringWithFormat:@"%lld",signInfo.goldCoins];
                    self.goldCoins = signInfo.goldCoins;
                }
                
            }
            
        }
        
    }];
}

-(void)setUpView{
    [self setHoldTitle:@"签卡获得游戏币"];
    [self.pointView addCornerRadius:5];
    self.myNumberLabel.text =[NSString stringWithFormat:@"%lld",[AHPersonInfoManager manager].getInfoModel.goldCoins];
    [_getGameCurrencyBt addTarget:self action:@selector(bt_getGemeCurrencyBt)];
    [self setUpSignCollectionView];
    [self updateViewConstraints];
    if ([self isAlreadyReceive]) {
        self.getCurrencyNumberLabel.text = @"已领取";
    }
}

//更新约束
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [_getGameCurrencyBt addCornerRadius:60];
    self.topViewHeightCostraint.constant = 188*screenHeight/iPhone6ScreenHeight;
    //        self.myGameCurrencyViewHeightConstraint.constant = 92*screenHeight/iPhone6ScreenHeight;
    if (screenHeight<=iPhone5ScreenHeight) {
        self.currencyViewTopContraint.constant = 15;
        //            self.currencyViewWidthConstraint.constant = 190*screenWidth/iPhone6ScreenWidth/1.3;
        //            self.currencyViewHeightConstraint.constant = 190*screenWidth/iPhone6ScreenWidth/1.3;
        //            [_getGameCurrencyBt addCornerRadius:190*screenWidth/iPhone6ScreenWidth/2/1.3];
        //            self.getCurrencyNumberLabel.font  = [UIFont systemFontOfSize:30];
        //            self.getCurrencyLabelBottomConstraint.constant = 6;
        self.topViewDetailTitleLabelTopConstraint.constant = 12;
    }else{
        //            self.currencyViewWidthConstraint.constant = 190*screenWidth/iPhone6ScreenWidth;
        //            self.currencyViewHeightConstraint.constant = 190*screenWidth/iPhone6ScreenWidth;
        //            [_getGameCurrencyBt addCornerRadius:190*screenWidth/iPhone6ScreenWidth/2];
    }
    
}

-(void)setUpSignCollectionView{
    // 创建一个流式布局管理
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置滚动方向为垂直方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置单元格的最小水平间距
    layout.minimumInteritemSpacing = 8;
    // 设置最小行间间距
    layout.minimumLineSpacing = 8;
    // 设置内边距
    layout.itemSize = CGSizeMake((screenWidth - 21*2-24)/4.0, (screenWidth - 15*2-24)/4.0/0.618);
    _signCollectionView.delegate = self;
    _signCollectionView.dataSource = self;
    [_signCollectionView setCollectionViewLayout:layout animated:NO];
    [_signCollectionView registerNib:[UINib nibWithNibName:@"AHSignCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

//领取游戏币
-(void)bt_getGemeCurrencyBt{
    UIView *view = [self.view viewWithTag:ImageViewTag];
    if (!view) {
        [self addAnimationPlaceView];
    }
    
    [self beginAnimation];
    //取当前时间
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    if (infoModel.signed_p) {
        self.getCurrencyNumberLabel.text = @"已领取";
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"今日已签到，请明日再来" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
    }else{
        UsersSignedInRequest *signInRequest = [[UsersSignedInRequest alloc]init];
        signInRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
        [[AHTcpApi shareInstance]requsetMessage:signInRequest classSite:@"Users" completion:^(id response, NSString *error) {
            UsersSignedInResponse *signedInrespose = response;
            if (signedInrespose.result == 0) {
                NSDate *signTimeOfNow = [NSDate date];
                [[NSUserDefaults standardUserDefaults]setObject:signTimeOfNow forKey:SignTimeOfLastTime];
                [self timer];
                AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                infoModel.goldCoins += self.goldCoins;
                infoModel.signed_p = YES;
                [[AHPersonInfoManager manager]setInfoModel:infoModel];
                self.myNumberLabel.text =[NSString stringWithFormat:@"%lld",infoModel.goldCoins];
                 [self getConfigurationFile];
            }else if(signedInrespose.result == Result_IsSignedInToday){
                self.getCurrencyNumberLabel.text = @"已领取";
                AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"今日已签到，请明日再来" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }else{
                AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"很抱歉，没有领取成功，请重试" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
        }];
        
    }
}

//点击动画效果
-(void)beginAnimation{
    _imageView.backgroundColor = self.getGameCurrencyBt.backgroundColor;
    // 先放大
    _imageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        _imageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

//文字动画
-(void)characterAnimation{
    static NSInteger number  = 120;
    number--;
    if (number >  4) {
        self.getCurrencyNumberLabel.text = [NSString stringWithFormat:@"%lld",self.goldCoins*number/120];
    }else{
        number = 120;
        self.getCurrencyNumberLabel.text = @"已领取";
        [_timer invalidate];
        _timer = nil;
    }
}

//比较时间 返回yes便是已经领取
-(BOOL)isAlreadyReceive{
    NSDate *signTimeOfLastTime = [[NSUserDefaults standardUserDefaults] valueForKey:SignTimeOfLastTime];
    NSDate *signTimeOfNow = [NSDate date];
    NSInteger day = [signTimeOfNow day];
    NSInteger month = [signTimeOfNow month];
    NSInteger year = [signTimeOfNow year];
    NSInteger day1 = [signTimeOfLastTime day];
    NSInteger month1 = [signTimeOfLastTime month];
    NSInteger year1 = [signTimeOfLastTime year];
    if (year>year1+1) {
        return YES;
    }else{
        if (month>month1+1) {
            return YES;
        }else{
            if (day>day1) {
                return YES;
            }else{
                return NO;
            }
        }
    }
}

//添加动画站位view
-(void)addAnimationPlaceView{
    CGRect frame = _getGameCurrencyBt.frame;
    _imageView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-64, frame.size.width, frame.size.height)];
    _imageView.tag = ImageViewTag;
    [self.view insertSubview:_imageView belowSubview:self.getGameCurrencyBt];
    _imageView.center = self.getGameCurrencyBt.center;
    _imageView.backgroundColor = self.getGameCurrencyBt.backgroundColor;
    [_imageView addCornerRadius:frame.size.height/2];
}

-(NSTimer*)timer{
    if (_timer == nil) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:0.01 target:self selector:@selector(characterAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark -----UICollectionViewDelegatAndDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AHSignCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == self.accumulationSignedDays) {
        cell.daysLabel.textColor = [UIColor whiteColor];
        cell.goldCOINSLabel.textColor = [UIColor whiteColor];
        cell.backgroundImageView.image = [UIImage imageNamed:@"bg_gamemark0"];
    }else{
        cell.backgroundImageView.image = [UIImage imageNamed:@"bg_gamemark1"];
        cell.daysLabel.textColor = [UIColor blackColor];
        cell.goldCOINSLabel.textColor = [UIColor blackColor];
    }
    cell.signInInfo = self.array[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
