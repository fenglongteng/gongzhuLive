//
//  AHApplyForBanker.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHApplyForBanker.h"
#import "AHBankerViewCell.h"
#import "ProtoEcho.pbobjc.h"
#import "GameSocketManager.h"
#import "SVProgressHUD.h"

@interface AHApplyForBanker ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * _shenRoomid;
}
@property (weak, nonatomic) IBOutlet UILabel *forBankerPersonLb;//申请上庄人数
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong)NSArray * datasource;
//申请上庄按钮
@property (weak, nonatomic) IBOutlet UIButton *ShenqingBtn;
@end

@implementation AHApplyForBanker

+(id)shareApplyForBanker{
    
     return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.datasource = [NSArray array];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AHBankerViewCell" bundle:nil] forCellReuseIdentifier:@"BankerCell"];
    self.headView.layer.cornerRadius = self.headView.height *0.5;
    
}

- (void)setBankerMessageWithRoomid:(NSString *)roomid currentBankerid:(NSString *)bankerid{
    if ([bankerid isEqualToString:[[AHPersonInfoManager manager] getInfoModel].userId]) {
        self.hasBankerd = YES;
    }
    //庄家列表
    DouNiuBankerReq * req = [[DouNiuBankerReq alloc]init];
    req.roomId = roomid;
    _shenRoomid = roomid;
    req.opt = DouNiuBankerReq_DNBOperations_DnbogetBankerList; //获取banker列表
    
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuBankerReq andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        
        DouNiuBankerRes * res = GetMessage(DouNiuBankerRes ,body);
        //res.status; 状态
        //res.bankersArray; 庄列表
        //DouNiuBanker* onebanker; 一个庄家
        //onebanker.id_p; 庄家id
        //onebanker.coin; 庄家钱币
        if (res.status == 0) {
            self.datasource = res.bankersArray;
            [self.tableView reloadData];
            
            for (DouNiuBanker * banker in self.datasource) {
                if ([banker.id_p isEqualToString:roomid]) {
                    self.isBanker = YES;
                    break;
                }
            }
            self.forBankerPersonLb.text = [NSString stringWithFormat:@"当前申请人数：%ld人",res.bankersArray_Count];
            if (self.isBanker == YES || self.hasBankerd == YES) {
                [self.ShenqingBtn setTitle:@"申请下庄" forState:UIControlStateNormal];
            }else{
                [self.ShenqingBtn setTitle:@"申请上庄" forState:UIControlStateNormal];
            }
        }
        
        return 0;
    }];

}

- (void)setRoomid:(NSString *)roomid{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AHBankerViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BankerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.datasource.count > 0) {
        DouNiuBanker * bankerMes = self.datasource[indexPath.row];
        [cell setMessageModel:bankerMes];
        cell.bankerNumLb.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }
    return cell;
    
}

//关闭庄家列表
- (IBAction)closeApplyBanker:(id)sender {
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

//申请上下庄
- (IBAction)applyForBankerClick:(id)sender {
    //庄家列表
    DouNiuBankerReq * req = [[DouNiuBankerReq alloc]init];
    req.roomId = _shenRoomid;
    if (self.isBanker == YES || self.hasBankerd == YES) {
        req.opt = DouNiuBankerReq_DNBOperations_DnboapplyUnBanker; //申请下庄
    }else{
        req.opt = DouNiuBankerReq_DNBOperations_DnboapplyBanker; //申请当庄
    }
    
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuBankerReq andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        
        DouNiuBankerRes * res = GetMessage(DouNiuBankerRes ,body);
        if (res.status == 0) {
            [SVProgressHUD showInfoWithStatus:@"申请成功，下一局即可上下庄！"];
        }
        //res.status; 状态
        //res.bankersArray; 庄列表
        //DouNiuBanker* onebanker; 一个庄家
        //onebanker.id_p; 庄家id
        //onebanker.coin; 庄家钱币
        return 0;
    }];

    if (self.closeBlock) {
        self.closeBlock();
    }
    
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
