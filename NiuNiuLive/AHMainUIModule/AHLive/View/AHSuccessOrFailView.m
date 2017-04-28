//
//  AHSuccessOrFailView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSuccessOrFailView.h"
#import "AHRecordViewCell.h"
#import "GameSocketManager.h"
#import "ProtoEcho.pbobjc.h"

@interface AHSuccessOrFailView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray * datasource;

@property (weak, nonatomic) IBOutlet UILabel *skyWinRate;
@property (weak, nonatomic) IBOutlet UILabel *earthWinRate;
@property (weak, nonatomic) IBOutlet UILabel *personWinRate;
@end

@implementation AHSuccessOrFailView

+ (id)successOrFailShareView{
    
return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    
}

- (IBAction)closeRecordView:(id)sender {
    //关闭recordView
    if (self.closeRecodView) {
        self.closeRecodView();
    }
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AHRecordViewCell" bundle:nil] forCellReuseIdentifier:@"recordViewCell"];
    
    self.datasource = [NSArray array];
    
    
}

- (void)setRoomid:(NSString *)roomid{
    _roomid = roomid;
    __block int skyRate = 0;
    __block int earthRate = 0;
    __block int personRate = 0;
    
    __block CGFloat sky = 0.0;
    __block CGFloat earth = 0.0;
    __block CGFloat person = 0.0;
    //历史战绩
    DouNiuHistoryReq * req = [[DouNiuHistoryReq alloc]init];
    req.start = 0; //起始记录
    req.count = 10; //记录数目
    req.htype = DouNiuHistoryReq_HistoryType_Htgames;
    req.roomId = self.roomid;
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuHistoryReq andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        
        DouNiuHistoryRes * res = GetMessage(DouNiuHistoryRes ,body);
        if (res.status == 0) {
            self.datasource = res.historyArray;
            [self.tableView reloadData];
            //计算胜率
            for (DouNiuHistoryItem * item in self.datasource) {
                if (item.handsArray[0].win == 1) {
                    skyRate += 1;
                }
                if (item.handsArray[1].win == 1) {
                    earthRate += 1;
                }
                if (item.handsArray[2].win == 1) {
                    personRate += 1;
                }
            }
            if (self.datasource.count > 0) {
                self.skyWinRate.hidden = NO;
                self.earthWinRate.hidden = NO;
                self.personWinRate.hidden = NO;
                sky = (CGFloat)skyRate / self.datasource.count;
                earth = (CGFloat)earthRate / self.datasource.count;
                person = (CGFloat)personRate / self.datasource.count;
                self.skyWinRate.text = [NSString stringWithFormat:@"%.0f%%",sky * 100];
                self.earthWinRate.text = [NSString stringWithFormat:@"%.0f%%",earth * 100];
                self.personWinRate.text = [NSString stringWithFormat:@"%.0f%%",person * 100];
            }
            
        }
        return 0;
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AHRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.datasource.count > 0) {
        DouNiuHistoryItem * item = self.datasource[indexPath.row];
        NSArray * mes = item.handsArray;
        if (((DouNiuHistoryHand *)mes[0]).win == 1) {
            cell.skyImage.image = [UIImage imageNamed:@"icon_zb_sfsheng"];
        }else{
            cell.skyImage.image = [UIImage imageNamed:@"icon_zb_sffu"];
        }
        if (((DouNiuHistoryHand *)mes[1]).win == 1) {
            cell.earthImage.image = [UIImage imageNamed:@"icon_zb_sfsheng"];
        }else{
            cell.earthImage.image = [UIImage imageNamed:@"icon_zb_sffu"];
        }
        if (((DouNiuHistoryHand *)mes[2]).win == 1) {
            cell.personImage.image = [UIImage imageNamed:@"icon_zb_sfsheng"];
        }else{
            cell.personImage.image = [UIImage imageNamed:@"icon_zb_sffu"];
        }
    }
    
    return cell;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.closeRecodView) {
        self.closeRecodView();
    }
    
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
