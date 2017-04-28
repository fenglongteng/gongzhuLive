//
//  AHWinnerView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHWinnerView.h"
#import "AHUserWinnerCell.h"
#import "ProtoEcho.pbobjc.h"
#import "GameSocketManager.h"
#import "UserApis.pbobjc.h"

@interface AHWinnerView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *gameWinnerView;

@property (nonatomic,strong)NSMutableArray * datasource;

@property (nonatomic,strong)NSMutableArray * coinArray;
@end

@implementation AHWinnerView

+(id)shareWinerView{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)showWinnerViewFrom:(UIView *)fromView{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.转化
    CGRect newFrame = [fromView convertRect:fromView.bounds toView:window];
    self.frame = window.bounds;
    [window addSubview: self];
    self.bottomLayout.constant = window.frame.size.height - newFrame.origin.y;
}

- (void)removeWinnerView{
    
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isDescendantOfView:self.gameWinnerView]) {
        return;
    }
    [self removeWinnerView];
}

- (void)setGameid:(NSString *)gameid{
    self.coinArray = [NSMutableArray array];
    //历史战绩
    DouNiuHistoryReq * req = [[DouNiuHistoryReq alloc]init];
    req.start = 0; //起始记录
    req.count = 10; //记录数目
    req.htype = DouNiuHistoryReq_HistoryType_HtgameWinCoin;
    req.roomId = self.roomid;
    req.gameId = gameid;
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuHistoryReq andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        DouNiuHistoryRes * res = GetMessage(DouNiuHistoryRes ,body);
        if (res.historyArray.count > 0) {
            NSMutableArray * idArray = [NSMutableArray array];
            for (DouNiuHistoryItem * model in res.historyArray) {
                [idArray addObject:model.userId];
                [self.coinArray addObject:@(model.winCoin)];
            }
            UserBasicInfoReq * info = [[UserBasicInfoReq alloc] init];
            info.idsArray = idArray;
            [[GameSocketManager instance] query:ProtoTypes_PtIdapigetUsersBasicInfo andMessage:info andHandler:^int(PackHeader *header, NSData *body) {
                UserBasicInfoRes * infoRes = GetMessage(UserBasicInfoRes ,body);
                if (infoRes.status == 0) {
                    self.datasource = infoRes.usersArray;
                    [self.tableView reloadData];
                }
                return 0;
            }];
        }
        [self.tableView reloadData];
        return 0;
    }];
}

//拿到个人金币数 装换成字符串
- (NSString *)getCurrentGold:(int64_t)goldCoin{
    if (goldCoin >= 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",goldCoin / 100000000.0];
    }else if(goldCoin >= 10000 && goldCoin < 100000000){
        return [NSString stringWithFormat:@"%.2fW",goldCoin / 10000.0];
    }else if(goldCoin <= -10000){
        return [NSString stringWithFormat:@"-%.2fW",goldCoin / -10000.0];
    }else{
        return [NSString stringWithFormat:@"%lld",goldCoin ];
    }
}

- (void)awakeFromNib{

    [super awakeFromNib];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datasource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"AHUserWinnerCell" bundle:nil] forCellReuseIdentifier:@"userWinnerCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AHUserWinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userWinnerCell" forIndexPath:indexPath];
    if (self.coinArray.count >0) {
        cell.winCoin.text = [self getCurrentGold:[self.coinArray[indexPath.row] intValue]];
    }
    if (self.datasource.count > 0) {
        [cell setUserInfo:self.datasource[indexPath.row]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)dealloc{

    LOG(@"%s",__func__);

}

@end
