//
//  AHContributeView.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
// 贡献榜弹出框

#import "AHContributeView.h"
#import "AHContributionLiveCell.h"

@interface AHContributeView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *top1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *top2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *top3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *top1userName;
@property (weak, nonatomic) IBOutlet UILabel *top2userName;
@property (weak, nonatomic) IBOutlet UILabel *top3userName;
@property (weak, nonatomic) IBOutlet UILabel *top1ContributeNum;
@property (weak, nonatomic) IBOutlet UILabel *top2ContributeNum;
@property (weak, nonatomic) IBOutlet UILabel *top3ContributeNum;

@property (nonatomic,strong)NSMutableArray *chatArr;

@end

@implementation AHContributeView

+ (id)contributeShareView{
    
 return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [ self setImageLayerCornerRadius:self.top1ImageView];
     [self setImageLayerCornerRadius:self.top2ImageView];
     [self setImageLayerCornerRadius:self.top3ImageView];
    self.chatArr = [NSMutableArray arrayWithCapacity:3];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AHContributionLiveCell" bundle:nil] forCellReuseIdentifier:@"contributeCell"];
}

- (void)setImageLayerCornerRadius:(UIView *)view{
    view.layer.cornerRadius = view.height*0.5;
    view.layer.masksToBounds = YES;
    
}

//我知道了按钮
- (IBAction)meKnowClick:(id)sender {
    if (self.meKnowBlock) {
        self.meKnowBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.chatArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AHContributionLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contributeCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{

    [[NSNotificationCenter defaultCenter]postNotificationName:kNotifyClickUser object:nil userInfo:@{@"userId" : @""}];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBankerClickUser object:nil userInfo:@{@"userId" : @""}];
}

- (void)dealloc{
   
    
    LOG(@"%s",__func__);
}

@end
