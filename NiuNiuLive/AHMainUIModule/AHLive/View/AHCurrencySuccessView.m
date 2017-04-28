//
//  AHCurrencySuccessView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHCurrencySuccessView.h"
#import "AHFinalGiftButton.h"
#import "UserApis.pbobjc.h"
#import "WMLocationManager.h"

@interface AHCurrencySuccessView ()

@property (weak, nonatomic) IBOutlet AHFinalGiftButton *firstGiftBt;
@property (weak, nonatomic) IBOutlet AHFinalGiftButton *sencondgiftBtn;
@property (weak, nonatomic) IBOutlet AHFinalGiftButton *treeGiftBtn;
@property (weak, nonatomic) IBOutlet UILabel *ownFinalGoldLb;//自己的结算金币
@property (weak, nonatomic) IBOutlet UILabel *bankerFinalGoldLb;//庄家的结算金币

@property (nonatomic,strong)AHFinalGiftButton *selectSelectBtn;

@end

@implementation AHCurrencySuccessView

+(id)currencySuccessShareView{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.selectSelectBtn = self.firstGiftBt;

}

- (void)setWinMessage:(NSArray *)giftsArray winCoin:(int64_t)coin{
    
    NSMutableArray * exception = [NSMutableArray array];
    RewordConfig *lastConfig =  giftsArray.lastObject;
    if (coin > lastConfig.maxCoin) {
        [exception addObjectsFromArray:lastConfig.giftsArray];
    }else{
        for (RewordConfig * config in giftsArray) {
            if (coin >= config.minCoin && coin <= config.maxCoin) {
                exception = [NSMutableArray arrayWithArray:config.giftsArray];
                break;
            }
        }
    }
    int i = 0;
    for (RewordGift * config in exception) {
        Gift * gift = [[WMLocationManager defaultDBManage] getGiftWithGiftId:config.id_p];
        if (i == 0) {
            [self.firstGiftBt setGiftModel:gift];
        }
        if (i == 1) {
            [self.sencondgiftBtn setGiftModel:gift];
        }
        if (i == 2) {
            [self.treeGiftBtn setGiftModel:gift];
        }
        i++;
    }
    
    if (self.winCoin > 0) {
        self.ownFinalGoldLb.text = [NSString stringWithFormat:@"本家 +%lld",self.winCoin];
    }else{
        self.ownFinalGoldLb.text = [NSString stringWithFormat:@"本家 %lld",self.winCoin];
        self.ownFinalGoldLb.textColor = [UIColor whiteColor];
    }
    if (self.bankerCoin > 0) {
        self.bankerFinalGoldLb.text = [NSString stringWithFormat:@"庄家 +%lld",self.bankerCoin];
    }else{
        self.bankerFinalGoldLb.text = [NSString stringWithFormat:@"庄家 %lld",self.bankerCoin];
        self.bankerFinalGoldLb.textColor = [UIColor whiteColor];
    }
}

//选择
- (IBAction)giftSelectClick:(AHFinalGiftButton *)sender {
    
    sender.selected = YES;
    if (self.selectSelectBtn == sender) {
        return;
    }
    self.selectSelectBtn.selected = NO;
    self.selectSelectBtn = sender;
}

//打赏礼物
- (IBAction)sendGiftClick:(id)sender {
    SendGiftRequest *sendGiftRequest = [[SendGiftRequest alloc]init];
    sendGiftRequest.gift =  self.selectSelectBtn.giftModel;
    sendGiftRequest.count = 1;
    [[AHTcpApi shareInstance]requsetMessage:sendGiftRequest classSite:GiftsClassName completion:^(id response, NSString *error) {
        SendGiftResponse *sendGiftRespones = response;
        if (sendGiftRespones.result == 0) {
            AHPersonInfoModel *model = [AHPersonInfoManager manager].getInfoModel;
            model.goldCoins -= self.selectSelectBtn.giftModel.goldCoins;
            [[AHPersonInfoManager manager] setInfoModel:model];
        }else{
        }
    }];

}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
