//
//  AHGiftView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/25.
//  Copyright © 2017年 AH. All rights reserved.
// 礼物界面

#import "AHGiftView.h"
#import "AHGiftListView.h"
#import "SVProgressHUD.h"
#import "AHGiftPageView.h"
#import "Gifts.pbobjc.h"
#import "WMLocationManager.h"

#define  AHGiftMaxRow  5   //一行最多5个
#define AHGiftPageSize  10 //每一页最大礼物数

@interface AHGiftView ()

@property (nonatomic,weak)IBOutlet UIButton *senderGiftBtn;

@property (nonatomic,weak)IBOutlet UIButton *redPackerBtn;

@property (nonatomic,weak)IBOutlet UIView *rechargeView;

@property (nonatomic,weak)IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong)AHGiftListView *selectGiftView;//当前选中的礼物
@property (weak, nonatomic) IBOutlet UIButton *runningFireBtn;//连发
@property (weak,nonatomic)IBOutlet UILabel *goldLb;

@property (nonatomic,strong)NSMutableArray *giftArr;

@property (nonatomic,assign)NSInteger runCount;//连发次数

@property (nonatomic,assign)int timerCount;//倒计时次数

@property (nonatomic,strong)NSTimer *timer;
//当前金币数
@property(nonatomic,assign) int64_t goldCoin;

@end

@implementation AHGiftView

+ (id)shareGiftView{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.senderGiftBtn.layer.cornerRadius = 3.0;
    self.redPackerBtn.layer.cornerRadius = 3.0;
    self.rechargeView.layer.cornerRadius = self.rechargeView.height *0.5;
    self.goldCoin = [[AHPersonInfoManager manager] getInfoModel].goldCoins;
    self.goldLb.text = [self getCurrentGold:[[AHPersonInfoManager manager] getInfoModel].goldCoins];
    
    self.giftArr = [NSMutableArray array];

    //数据库获取礼物信息
    NSArray * array = [[WMLocationManager defaultDBManage] getAllGiftsData];
    for (Gift *gift in array) {
        if (!gift.hidden) {
            [self.giftArr addObject:gift];
        }
    }
    [self creatGiftList:self.giftArr];
}

//拿到个人金币数 装换成字符串
- (NSString *)getCurrentGold:(int64_t)goldCoin{
    if (goldCoin >= 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",goldCoin / 100000000.0];
    }else if(goldCoin >= 10000 && goldCoin < 100000000){
        return [NSString stringWithFormat:@"%.2fW",goldCoin / 10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",goldCoin];
    }
}


- (void)creatGiftList:(NSMutableArray *)arr{
    NSUInteger pageCount = (arr.count + AHGiftPageSize - 1) / AHGiftPageSize;
    for (int i=0; i<pageCount; i++) {
        AHGiftPageView *giftPageView = [[AHGiftPageView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, self.scrollView.height)];
        NSRange range;
        range.location = i * AHGiftPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = arr.count - range.location;
        if (left >= AHGiftPageSize) { // 这一页足够10个
            range.length = AHGiftPageSize;
        } else {
            range.length = left;
        }
        //设置这一页的表情
        giftPageView.giftArray = [arr subarrayWithRange:range];
        [self.scrollView addSubview:giftPageView];
        __weak typeof(self)weakself = self;
        [giftPageView setGiftClickBlock:^(AHGiftListView *gift) {
            weakself.selectGiftView = gift;
            //设置时候需要连发
            if (!weakself.selectGiftView.gift.allowContinue) {
                weakself.runningFireBtn.hidden = YES;
            }
        }];
    }
    self.scrollView.contentSize = CGSizeMake(screenWidth *pageCount, 0);
}

//送礼物
- (IBAction)senderGiftClick:(id)sender {
    
    self.runCount = 1;
    
    int64_t giftCoin = self.selectGiftView.gift.goldCoins * (int32_t)self.runCount;
    if (self.goldCoin < giftCoin) {
        [SVProgressHUD showInfoWithStatus:@"金币不足"];
        return;
    }
    if (!self.selectGiftView.gift.name) {
        return;
    }
    if (self.selectGiftView.gift.allowContinue) {
        self.runningFireBtn.hidden = NO;
        self.timerCount = 0;
        [self createTimer];
    }else{
      self.runningFireBtn.hidden = YES;
      SendGiftRequest *sendGiftRequest = [[SendGiftRequest alloc]init];
        sendGiftRequest.gift =  self.selectGiftView.gift;
        sendGiftRequest.count = (int32_t)self.runCount;
        [[AHTcpApi shareInstance]requsetMessage:sendGiftRequest classSite:GiftsClassName completion:^(id response, NSString *error) {
            SendGiftResponse *sendGiftRespones = response;
            if (sendGiftRespones.result == 0) {
                AHPersonInfoModel *model = [AHPersonInfoManager manager].getInfoModel;
                model.goldCoins -= giftCoin;
                self.goldCoin = model.goldCoins;
                NSDictionary *dic = [NSDictionary dictionaryWithObject:@(model.goldCoins) forKey:@"userGold"];
                [[NSNotificationCenter defaultCenter]postNotificationName:UserGoldDidChange object:nil userInfo:dic];
                [[AHPersonInfoManager manager] setInfoModel:model];
                self.goldLb.text = [self getCurrentGold:model.goldCoins];
            }else{
                 [SVProgressHUD showInfoWithStatus:sendGiftRespones.message];
            }
        }];
    }
}

//发红包
- (IBAction)redPacketClick:(id)sender {
    
    if (self.senderRedPacketViewBlock) {
        self.senderRedPacketViewBlock();
    }
}

//连发
- (IBAction)runningFireClick:(UIButton *)sender {
    
    int64_t giftCoin = self.selectGiftView.gift.goldCoins * (int32_t)self.runCount;
    
    if (self.goldCoin < giftCoin) {
        [SVProgressHUD showInfoWithStatus:@"金币不足"];
        self.runCount--;
        return;
    }
    self.runCount++;
}

//充值
- (IBAction)rechargeClick:(id)sender {
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isDescendantOfView:self.giftBackView]) {
        return;
    }
    if (self.closeGiftViewBlock) {
        [self timerInvalidate];
        self.closeGiftViewBlock();
    }
}

- (void)timerInvalidate{
    
    if (self.timer) {
        self.runningFireBtn.hidden = YES;
        int64_t giftCoin = self.selectGiftView.gift.goldCoins * (int32_t)self.runCount;
        SendGiftRequest *sendGiftRequest = [[SendGiftRequest alloc]init];
        sendGiftRequest.gift =  self.selectGiftView.gift;
        sendGiftRequest.count = (int32_t)self.runCount;
        [[AHTcpApi shareInstance]requsetMessage:sendGiftRequest classSite:GiftsClassName completion:^(id response, NSString *error) {
            SendGiftResponse *sendGiftRespones = response;
            if (sendGiftRespones.result == 0) {
                AHPersonInfoModel *model = [AHPersonInfoManager manager].getInfoModel;
                model.goldCoins -= giftCoin;
                self.goldCoin = model.goldCoins;
                NSDictionary *dic = [NSDictionary dictionaryWithObject:@(model.goldCoins) forKey:@"userGold"];
                [[NSNotificationCenter defaultCenter]postNotificationName:UserGoldDidChange object:nil userInfo:dic];
                [[AHPersonInfoManager manager] setInfoModel:model];
                self.goldLb.text = [self getCurrentGold:model.goldCoins];
            }else{
                 [SVProgressHUD showInfoWithStatus:sendGiftRespones.message];
            }
        }];
    }
    [self.timer invalidate];
    self.timer = nil;
}

//开启定时器
- (void)createTimer{
    if (self.timer == nil) {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRunBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    }
}

- (void)timerRunBtn{
    ++self.timerCount;
    if (self.timerCount>=3) {
      [self timerInvalidate];
    }
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    LOG(@"%s",__func__);
}

@end
