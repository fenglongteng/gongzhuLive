//
//  AHHistoryGainsView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHHistoryGainsView.h"
#import "AHHistoryCell.h"
#import "ProtoEcho.pbobjc.h"
#import "GameSocketManager.h"

@interface AHHistoryGainsView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;

//当前点击cell
@property(nonatomic,copy)NSIndexPath * selectedIndex;
//是否展开
@property(nonatomic,assign)BOOL isOpen;
@end


@implementation AHHistoryGainsView

+ (id)shareHistoryGainsView{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource  = self;

    [_tableView registerNib:[UINib nibWithNibName:@"AHHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count > 0) {
        self.placeLbl.alpha = 0;
    }else{
        self.placeLbl.alpha = 1;
    }
    return self.dataSource.count;
}

- (void)setRoomid:(NSString *)roomid{
    _roomid = roomid;
    //历史战绩
    DouNiuHistoryReq * req = [[DouNiuHistoryReq alloc]init];
    req.start = 0; //起始记录
    req.count = 10; //记录数目
    req.htype = DouNiuHistoryReq_HistoryType_Htself;
    req.roomId = self.roomid;
    [[GameSocketManager instance] query:ProtoTypes_PtIddouNiuHistoryReq andMessage:req andHandler:^int(PackHeader *header, NSData *body) {
        
        DouNiuHistoryRes * res = GetMessage(DouNiuHistoryRes ,body);
        if (res.status == 0) {
            self.dataSource = res.historyArray;
            [self.tableView reloadData];
        }
        return 0;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AHHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        [cell setDetailMessageWithModel:self.dataSource[indexPath.row]];
    }
    if (indexPath.row == _selectedIndex.row && _selectedIndex != nil) {
        //如果是展开
        if (_isOpen == YES) {
            cell.detailView.alpha = 1;
        }else{
            cell.detailView.alpha = 0;
        }
    }else{
        cell.detailView.alpha = 0;
    }
    //点击展开/收缩操作
    __weak typeof (UITableView *) tempTable = tableView;
    cell.extendsBlokc = ^(AHHistoryCell * cell){
        NSIndexPath * index = [tempTable indexPathForCell:cell];
            //初次进入,记录被点击cell不存在的情况。
            if (self.selectedIndex == nil) {
                _isOpen = YES;
            }
            //cell点击展开折叠效果
            NSArray *indexPaths = [NSArray arrayWithObject:index];
            if (self.selectedIndex != nil && index.row == _selectedIndex.row) {
                _isOpen = !_isOpen;
            }else if (self.selectedIndex != nil && index.row != _selectedIndex.row) {
                indexPaths = [NSArray arrayWithObjects:self.selectedIndex,index, nil];
                _isOpen = YES;
            }
            //记下选中的索引
            self.selectedIndex = index;
            //刷新
            [tempTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    };

    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == _selectedIndex.row && _selectedIndex != nil) {
        if (_isOpen == YES){
            return 216.f;
        }else{
            return 60.f;
        }
    }else{
        return 60.f;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}


//关闭
- (IBAction)closeHistoryGainsView:(id)sender {
    if (self.closeHistoryGainsBlock) {
        self.closeHistoryGainsBlock();
    }
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
