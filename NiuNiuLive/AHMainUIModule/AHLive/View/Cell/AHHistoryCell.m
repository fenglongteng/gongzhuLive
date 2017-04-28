//
//  AHHistoryCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHHistoryCell.h"

@interface AHHistoryCell()

@end

@implementation AHHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//点击cell
- (IBAction)click:(UIButton *)sender {
    __weak typeof(self) tempSelf= self;
    if (self.extendsBlokc) {
        self.extendsBlokc(tempSelf);
    }
}

- (void)setDetailMessageWithModel:(DouNiuHistoryItem *)model{
    NSArray * count = @[@"没牛",@"牛一",@"牛二",@"牛三",@"牛四",@"牛五",@"牛六",@"牛七",@"牛八",@"牛九",@"牛牛"];
    //时间戳转时间的方法:
    NSTimeInterval time = model.time / 1000000000 ;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd H:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];

    //天
    DouNiuHistoryHand * skyMes = model.handsArray[0];
    self.skyWin.text = [self getWinCoinStringWithWintype:skyMes.win coin:skyMes.coin rate:skyMes.rate bankerRate:model.bankerRate];
    self.skyCoin.text = [self getWinStringWithCoin:skyMes.coin isAll:NO];
    self.skyCount.text = count[skyMes.niuN];
    //地
    DouNiuHistoryHand * earthMes = model.handsArray[1];
    self.earthWin.text = [self getWinCoinStringWithWintype:earthMes.win coin:earthMes.coin rate:earthMes.rate bankerRate:model.bankerRate];
    self.earthCoin.text = [self getWinStringWithCoin:earthMes.coin isAll:NO];
    self.earthCount.text = count[earthMes.niuN];
    //人
    DouNiuHistoryHand * personMes = model.handsArray[2];
    
    self.personWin.text = [self getWinCoinStringWithWintype:personMes.win coin:personMes.coin rate:personMes.rate bankerRate:model.bankerRate];
    self.personCoin.text = [self getWinStringWithCoin:personMes.coin isAll:NO];
    self.personCount.text = count[personMes.niuN];
    
    int64_t allWinCoin = model.winCoin;
    
    self.AllWin.text = [self getWinStringWithCoin:allWinCoin isAll:YES];
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%@ 庄 %@",currentDateStr,count[model.bankerNiuN]] forState:UIControlStateNormal];
}

- (NSString *)getWinCoinStringWithWintype:(int32_t)type coin:(int64_t)coin rate:(int64_t)rate bankerRate:(int64_t)bankerRate{
    if (type == 1) {
        int64_t selfCoin = coin * rate;
        return [NSString stringWithFormat:@"+%@",[self getWinStringWithCoin:selfCoin isAll:NO]];
    }else{
        int64_t selfCoin = coin * bankerRate;
        return [NSString stringWithFormat:@"-%@",[self getWinStringWithCoin:selfCoin isAll:NO]];
    }
}

- (NSString *)getWinStringWithCoin:(int64_t)coin isAll:(BOOL)isall{
    if (coin >= 10000) {
        if (isall == YES) {
            return [NSString stringWithFormat:@"+%.2fW",coin / 10000.0];
        }
        return [NSString stringWithFormat:@"%.2fW",coin / 10000.0];
    }else if(coin <= -10000){
        if (isall == YES) {
            return [NSString stringWithFormat:@"%.2fW",coin / 10000.0];
        }
        return [NSString stringWithFormat:@"%.2fW",coin / -10000.0];
    }else{
        if (coin > 0) {
            if (isall == YES) {
                return [NSString stringWithFormat:@"+%lld",coin];
            }
            return [NSString stringWithFormat:@"%lld",coin];
        }
        return [NSString stringWithFormat:@"%lld",coin];
    }
}

@end
