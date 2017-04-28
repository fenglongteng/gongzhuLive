//
//  AHDirectMessagesView.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/5.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHDirectMessagesView.h"
#import "UITableViewFreshAndLoad_Head.h"
#import "AHMessageCell.h"
#import "AHMessageDetailVC.h"
@interface AHDirectMessagesView()<ReloadNewData,UITableViewDelegate,UITableViewDataSource>

/**
 底部view约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *sourceArray;
@end

@implementation AHDirectMessagesView

-(void)showOnTheWindow{
    [[AppDelegate getAppdelegateWindow] addSubview:self];
    self.bottomViewBottomConstraint.constant = 0;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
    AHPersonInfoManager *personInfoManage = [AHPersonInfoManager manager];
    [self.sourceArray addObjectsFromArray: [personInfoManage getMyMessageArray]];
    [self.tableView reloadData];
}

-(void)dismiss{
    self.bottomViewBottomConstraint.constant = -300;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        UIView *view = [[NSBundle mainBundle]loadNibNamed:@"AHDirectMessagesView" owner:self options:0].firstObject;
        view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [self addSubview:view];
        [self setUpView];
        
    }
    return self;
}

-(void)setUpView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:[AHMessageCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHMessageCell getIdentifier]];
    AHEmptyPlaceHoldView *placeHoldView = self.tableView.placeHolderView;
    [placeHoldView setUpWithIsHighLighted:NO andTitle:@"还没有新消息哟"];
    [self addTarget:self action:@selector(dismiss)];
}

//删除所有cell
- (IBAction)bt_deleteAllCell:(UIButton *)sender {
    [self.sourceArray removeAllObjects];
    [self.tableView ah_reloadData];
}

-(NSMutableArray*)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

#pragma mark  UITableViewDelegateAndeUITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:[AHMessageCell getIdentifier] forIndexPath:indexPath];
    AHMessageModel *model = self.sourceArray[indexPath.row];
    messageCell.messageModel = model;
    return messageCell;
}

-(UITableViewCellEditingStyle)tableView :(UITableView *)tableView editingStyleForRowAtIndexPath :(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete ;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        [self.sourceArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        AHPersonInfoManager *personInfoManage = [AHPersonInfoManager manager];
        [personInfoManage setMyMessageArray:self.sourceArray];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc{

    LOG(@"%s",__func__);
}

@end
