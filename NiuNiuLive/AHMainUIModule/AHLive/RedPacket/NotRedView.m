//
//  NotRedView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "NotRedView.h"
#import "redPacketCell.h"
#import "Gifts.pbobjc.h"

@interface NotRedView()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *redDetailTable;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (assign, nonatomic) BOOL isShowTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (nonatomic,strong)NSMutableArray *userRedArr;//有哪些抢到了红包
@end

@implementation NotRedView

- (void)awakeFromNib{

    [super awakeFromNib];
    
    _isShowTable = NO;
    self.redDetailTable.dataSource = self;
    self.redDetailTable.rowHeight = 45;
    self.redDetailTable.tableFooterView = [[UIView alloc] init];
    self.redDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.redDetailTable.alwaysBounceVertical = YES;
    [self.redDetailTable registerNib:[UINib nibWithNibName:@"redPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"redPacketCells"];
    self.userRedArr = [NSMutableArray arrayWithCapacity:3];
    
}

- (void)setRedViewMessage{

    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    if (self.isNull == YES) {
        self.remindLbl.text = @"红包已被抢光！";
        self.getRedPacketLbl.hidden = YES;
    }
    else{
        self.remindLbl.text = @"您成功领取游戏币";
        self.getRedPacketLbl.text = [NSString stringWithFormat:@"%lld",self.redCoins];
    }
    [[AppDelegate getAppdelegateWindow] addSubview:self];
}

#pragma mark UItableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userRedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GetGrabRedPackagesResultResponse_GrabRedPackagesResult *redList = [self.userRedArr objectAtIndex:indexPath.row];
    redPacketCell * cell = [tableView dequeueReusableCellWithIdentifier:@"redPacketCells"];
    cell.redPackResList = redList;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    return cell;
}
- (IBAction)closeRedPacketView:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)showRedPacketDetailTableView:(id)sender {
    
    if (_isShowTable == NO) {
         [self getRedPackList];
        self.detailView.backgroundColor = [UIColor colorWithRed:243/255.0 green:44/255.0 blue:38/255.0 alpha:1.0];
        self.bottomViewHeight.constant = 147;
        [self.bottomBtn setImage:[UIImage imageNamed:@"btn_redbar_shang"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.detailView layoutIfNeeded];
        }];
        _isShowTable = YES;
    }else{
       
        self.detailView.backgroundColor = [UIColor clearColor];
        self.bottomViewHeight.constant = 24;
        [self.bottomBtn setImage:[UIImage imageNamed:@"btn_redbar_xia"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.detailView layoutIfNeeded];
        }];
        _isShowTable = NO;
    }
    
}

- (void)getRedPackList{
    
    GetGrabRedPackagesResultRequest *redPackListReq = [[GetGrabRedPackagesResultRequest alloc]init];
    redPackListReq.giftUuid = self.reduuid;
    redPackListReq.userId = [[AHPersonInfoManager manager]getInfoModel].userId;
    [[AHTcpApi shareInstance]requsetMessage:redPackListReq classSite:GiftsClassName completion:^(id response, NSString *error) {
        GetGrabRedPackagesResultResponse *redRes = (GetGrabRedPackagesResultResponse *)response;
        if (redRes.result == 0) {
            self.userRedArr = redRes.redpacksArray;
            [self.redDetailTable reloadData];
        }
    }];
}

@end
