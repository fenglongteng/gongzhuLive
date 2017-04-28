//
//  AHPersonInfoVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPersonInfoVC.h"
#import "AHHeaderViewOfTableView.h"
#import "AHMostAttractiveCell.h"
#import "AHInfoItemCell.h"
#import "AHHeaderPhotoAlbumCell.h"
#import "UIResponder+Router.h"
#import "UIView+ST.h"

#import "AHContributionOfListVC.h"
#import "AHFriendSetVC.h"
#import "AHTitleItemCell.h"
#import "AHVideoRecordeVC.h"
#import "AHAttentionVC.h"
#import "AHFansVC.h"
@interface AHPersonInfoVC ()<UITableViewDataSource,UITableViewDelegate>
/**
 自定义下拉放大tableHeaderView
 */
@property (nonatomic, strong) GLHBannerView *bannerView;

/**
 自定义下拉放大tableHeaderView(把他放到bannerView中)
 */
@property(nonatomic,strong)AHHeaderViewOfTableView *headerView;

/**
 列表TableView
 */
@property(nonatomic,strong)UITableView *listTableView;

/**
 list数据源数组
 */
@property(nonatomic,strong)NSMutableArray *sourceArray;

//userId
@property(nonatomic,strong)NSString *userId;

//用户信息
@property(nonatomic,strong) AHPersonInfoModel *infoModel;
@end

@implementation AHPersonInfoVC

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(instancetype)initWithUserId:(NSString*)userid{
    if ([super init]) {
        _userId = userid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getUserInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

//获取用户数据
-(void)getUserInfo{
    UsersGetInfoRequest *getInfoReuqust = [[UsersGetInfoRequest alloc]init];
    getInfoReuqust.userId = self.userId;
    if (_userId.length>0) {
        [[AHTcpApi shareInstance]requsetMessage:getInfoReuqust classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersGetInfoResponse *getInfoRespose = response;
            if (getInfoRespose.result == 0) {
                self.infoModel = [AHPersonInfoModel initWithJson:getInfoRespose];
                [self setUpHeadView];
            }else{
                
            }
            [self.listTableView reloadData];
        }];
    }else{
        AHAlertView *alerView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"传了一个空的id过来，建议用initWithUserId初始化话，再检查一下逻辑哟" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alerView showAlert];
    }
}


-(void)setInfoModel:(AHPersonInfoModel *)infoModel{
    _infoModel = infoModel;
    _headerView.infoModel = _infoModel;
    [self.listTableView reloadData];
}

-(void)setUpView{
    //设置下拉放大tableHeaderView
    [self setUpHeadView];
    //创建tableView
    [self createTableView:UITableViewStylePlain andFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    //设置导航条颜色
    [self setCustomTransparencyNavigationBarWithFrame:CGRectMake(0, 3, 50, 64)];
}

//设置下拉放大tableHeaderView
-(void)setUpHeadView{
    if (!_headerView) {
       _headerView = [[AHHeaderViewOfTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 325)];
    }
    _headerView.infoModel = self.infoModel;
    UIImage *image = [UIImage imageNamed:@"btn_home_more.png"];
    [_headerView.rightTopButton setImage:image  forState:UIControlStateNormal];
    [_headerView.rightTopButton addTarget:self action:@selector(bt_rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.rightBottomBt addBorderColor:[UIColor clearColor] andwidth:1 andCornerRadius:6];
    //加网络数据设置button？？？？
    [_headerView.rightBottomBt addTarget:self action:@selector(bt_attentionAnchor:) forControlEvents:UIControlEventTouchUpInside];
    if (_infoModel.isLiked || _infoModel.isSpecialLike) {
        [_headerView.rightBottomBt setTitle:@"已经关注" forState:UIControlStateNormal];
        _headerView.rightBottomBt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    }else{
        [_headerView.rightBottomBt setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_headerView.rightBottomBt setBackgroundColor:UIColorFromRGB(0xfed215)];
    }
}

//创建tableView
-(void)createTableView:(UITableViewStyle)style andFrame:(CGRect)frame{
    _listTableView = [[UITableView alloc]initWithFrame:frame style:style];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.separatorColor = self.view.backgroundColor;
    _listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_listTableView];
    self.listTableView.estimatedRowHeight = 100;
    [self.bannerView customTableHeaderView:_headerView];
    self.listTableView.tableHeaderView = self.bannerView;
    [self.listTableView registerNib:[UINib nibWithNibName:[AHMostAttractiveCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHMostAttractiveCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHInfoItemCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHInfoItemCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHHeaderPhotoAlbumCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHHeaderPhotoAlbumCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHTitleItemCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHTitleItemCell getIdentifier]];
    self.listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

//关注按钮事件
-(void)bt_attentionAnchor:(UIButton*)sender{
    if (_infoModel.isLiked) {
        [self RequestUnAttent];
    }else{
        [self requestAttent];
    }
}

-(void)requestAttent{
    UsersLikeUserRequest *likeUserRequest = [[UsersLikeUserRequest alloc]init];
    GPBStringBoolDictionary *boolDic = [GPBStringBoolDictionary dictionaryWithBool:NO forKey:self.userId];
    likeUserRequest.users = boolDic;
    [[AHTcpApi shareInstance]requsetMessage:likeUserRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersLikeUserResponse *liskeUserRespose = response;
        if (liskeUserRespose.result != 0) {
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"关注失败" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }else{
            [_headerView.rightBottomBt setTitle:@"已经关注" forState:UIControlStateNormal];
            _headerView.rightBottomBt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
            _infoModel.isLiked = !_infoModel.isLiked;
        }
    }];
}

-(void)RequestUnAttent{
    UsersUnlikeUserRequest  *unlikeUserRequest = [[UsersUnlikeUserRequest alloc]init];
    unlikeUserRequest.userId = self.userId;
    [[AHTcpApi shareInstance]requsetMessage:unlikeUserRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersUnlikeUserResponse *unlikeRespose = response;
        if (unlikeRespose.result != 0) {
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"取消关注失败" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }else{
            [_headerView.rightBottomBt setTitle:@"+ 关注" forState:UIControlStateNormal];
            [_headerView.rightBottomBt setBackgroundColor:UIColorFromRGB(0xfed215)];
            _infoModel.isLiked = !_infoModel.isLiked;
        }
    }];
}

//查找是否关注
-(void)findIsAttention{

}

//顶部右边按钮事件
-(void)bt_rightButtonAction{
    AHFriendSetVC *friendSetVC = [[AHFriendSetVC alloc]initWithUserId:self.userId AndPersonInfo:self.infoModel AndSpecialAttention:self.infoModel.isSpecialLike];
    [self.navigationController pushViewController:friendSetVC animated:YES];
}

-(GLHBannerView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[GLHBannerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 325)];
    }
    return _bannerView;
}

#pragma mark  --UITableViewDataSourceAndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        //魅力贡献榜
        AHMostAttractiveCell *mostAttractiveCell = [tableView dequeueReusableCellWithIdentifier:[AHMostAttractiveCell getIdentifier] forIndexPath:indexPath];
        return mostAttractiveCell;
    }else if (indexPath.section == 1){
        AHInfoItemCell *infoItemCell = [tableView dequeueReusableCellWithIdentifier:[AHInfoItemCell getIdentifier] forIndexPath:indexPath];
        infoItemCell.indexPath = indexPath;
        infoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoItemCell.leftTitleLabel.text = @"总魅力";
        infoItemCell.leftDetailLabel.text = [NSString stringWithFormat:@"%lld",_infoModel.charmValue];
        infoItemCell.rightTitleLabel.text = @"送出";
        infoItemCell.rightDetailLabel.text = [NSString stringWithFormat:@"%lld",_infoModel.outcome];
        infoItemCell.rightButtonAction = ^(){
            //送出
            
        };
        infoItemCell.leftButtonAction = ^{
            //总魅力
            AHContributionOfListVC *contributionListVC = [[AHContributionOfListVC alloc]init];
            [self.navigationController pushViewController:contributionListVC animated:YES];
        };
        return infoItemCell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //视屏回放
            AHTitleItemCell *titleItemCell =  [tableView dequeueReusableCellWithIdentifier:[AHTitleItemCell getIdentifier] forIndexPath:indexPath];
            titleItemCell.detailTitleLabel.text = [NSString stringWithFormat:@"%ld", _infoModel.avatarURLArray_Count];
            return titleItemCell;
        }else{
            AHInfoItemCell *infoItemCell = [tableView dequeueReusableCellWithIdentifier:[AHInfoItemCell getIdentifier] forIndexPath:indexPath];
            infoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            infoItemCell.indexPath = indexPath;
            infoItemCell.leftTitleLabel.text = @"关注";
            infoItemCell.leftDetailLabel.text =  [NSString stringWithFormat:@"%lu", (unsigned long)_infoModel.myLikeCount];
            infoItemCell.rightTitleLabel.text = @"粉丝";
            infoItemCell.rightDetailLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_infoModel.likeMeCount];
            infoItemCell.rightButtonAction = ^(){
                //粉丝
                AHFansVC *myFansVC =   [[AHFansVC alloc]initWithMy:NO andPersonInfoModel:_infoModel];
                [self.navigationController pushViewController:myFansVC animated:YES];
            };
            infoItemCell.leftButtonAction = ^{
                //关注
                AHAttentionVC *myAttentionVC  =[[AHAttentionVC alloc]initWithPersonInfoModel:_infoModel];
                [self.navigationController pushViewController:myAttentionVC animated:nil];
            };
            return infoItemCell;
        }
    }else {
        AHHeaderPhotoAlbumCell *headerPhotoAlbumCell =[tableView dequeueReusableCellWithIdentifier:[AHHeaderPhotoAlbumCell getIdentifier] forIndexPath:indexPath];
        [headerPhotoAlbumCell  setImageArray:_infoModel.avatarArray isOwn:NO];
        headerPhotoAlbumCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headerPhotoAlbumCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 60;
    }else if (indexPath.section == 1){
        return 60;
    }else if (indexPath.section == 2){
        return 60;
    }else {
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.listTableView) {
        CGPoint offset = scrollView.contentOffset;
        //下拉放大实现
        if (offset.y < 0) {
            [self.bannerView setOffSetY:offset.y];
            CGFloat alpha  = 325.0/(-offset.y*13 + 325.0);
            for (UIView *subView in self.headerView.topView.subviews) {
                subView.alpha =  alpha;
            }
            for (UIView *subView in self.headerView.bottomView.subviews) {
                subView.alpha =  alpha;
            }
            if (alpha < 0.15) {
                self.headerView.bottomView.hidden = YES;
                self.headerView.topView.hidden = YES;
            }else{
                self.headerView.bottomView.hidden = NO;
                self.headerView.topView.hidden = NO;
            }
            
        }else{
            [self.bannerView setOffSetY:0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AHContributionOfListVC *contributionListVC = [[AHContributionOfListVC alloc]init];
        [self.navigationController pushViewController:contributionListVC animated:YES];
    }
    if (indexPath.section == 2&& indexPath.row == 0) {
        //视屏回放
        AHVideoRecordeVC *videoRecordeVC = [[AHVideoRecordeVC alloc]initWithTiTle:@"我的视频回放"];
        [self.navigationController  pushViewController:videoRecordeVC animated:YES];
}
}


@end
