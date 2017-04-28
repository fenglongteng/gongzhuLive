//
//  AHMeAccoutViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMeAccoutViewController.h"
#import "AHHeaderViewOfTableView.h"
#import "AHInfoItemCell.h"
#import "AHHeaderPhotoAlbumCell.h"
#import "AHTaskItemCell.h"
#import "AHTitleItemCell.h"
#import "AHPreferenceTableVC.h"
#import "NSObject+AHUntil.h"
#import "AHMyGameCurrencyVC.h"
#import "STPickerSingle.h"
#import "AHPreferenceTableVC.h"
#import "CustomCamerButton.h"
#import "AHMyAttentionVC.h"
#import "AHVideoRecordeVC.h"
#import "AHFansVC.h"
#import "AHContributionOfListVC.h"
#import "LevelController.h"
#import "AHPersonInfoManager.h"
#import "AFNetworking.h"
#import "YYModel.h"


extern const NSInteger constellationViewTag;
extern const NSInteger SexViewTag;

//boundary
//#define HQBoundary @"com.hq"


@interface AHMeAccoutViewController ()<STPickerSingleDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 自定义下拉放大  容器view
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

/**
 拍照+图片选择功能
 */
@property(nonatomic,strong)CustomCamerButton *camerBt;


@end

@implementation AHMeAccoutViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
    [self.listTableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //接受通知刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView) name:RefreshMeAccountViewController object:nil];
}

-(void)refreshTableView{
    [self.listTableView reloadData];
    _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
}

-(void)setUpView{
    [self createTableView:UITableViewStylePlain andFrame:CGRectMake(0, 0, screenWidth, screenHeight - tabBarHeight)];
    //设置下拉放大tableHeaderView
    _headerView = [[AHHeaderViewOfTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 325)];
    _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
    [_headerView.rightBottomBt addBorderColor:[UIColor whiteColor] andwidth:1 andCornerRadius:6];
    [_headerView.rightBottomBt addTarget:self action:@selector(bt_showLoadUpHeaderImage) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.rightTopButton addTarget:self action:@selector(bt_pushPreferenceVC) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addTarget:self action:@selector(bt_showLoadUpHeaderImage)];
    [_headerView.briefLabel addTarget:self action:@selector(pushBriefVC)];
    self.listTableView.estimatedRowHeight = 100;
    [self.bannerView customTableHeaderView:_headerView];
    self.listTableView.tableHeaderView = self.bannerView;
    self.listTableView.showsVerticalScrollIndicator = NO;
    [self.listTableView registerNib:[UINib nibWithNibName:[AHTaskItemCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHTaskItemCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHTitleItemCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHTitleItemCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHInfoItemCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHInfoItemCell getIdentifier]];
    [self.listTableView registerNib:[UINib nibWithNibName:[AHHeaderPhotoAlbumCell getIdentifier] bundle:nil] forCellReuseIdentifier:[AHHeaderPhotoAlbumCell getIdentifier]];
    self.listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

//push到编辑简介页面
-(void)pushBriefVC{
    [NSObject pushFromVC:self toVCWithName:@"AHEditProfileVC" InTheStoryboardWithName:@"AHStoryboard"];
}

//创建tableView
-(void)createTableView:(UITableViewStyle)style andFrame:(CGRect)frame{
    _listTableView = [[UITableView alloc]initWithFrame:frame style:style];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.separatorColor = self.view.backgroundColor;
    _listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_listTableView];
}

//导航到设置控制器
-(void)bt_pushPreferenceVC{
    [NSObject pushFromVC:self toVCWithName:@"AHPreferenceTableVC" InTheStoryboardWithName:@"AHStoryboard"];
}

//打开选择照片或图片的alert
-(void)bt_showLoadUpHeaderImage{
    WeakSelf;
    _camerBt = [[CustomCamerButton alloc]initAddTargetVC:self AndSeltedCompleteHandle:^(UIImage * image) {
                [weakSelf uploadImage:image andUser_id:[AHPersonInfoManager manager].getInfoModel.userId];
    }];
    [_camerBt showImagePicker];
}

//上传图片
-(void)uploadImage:(UIImage*)image andUser_id:(NSString*)user_id{
    //1.创建一个名为mgr的请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain",nil];
    //2.上传文字时用到的拼接请求参数(如果只传图片，可不要此段）
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//创建一个名为params的可变字典
    params[@"user_id"] = user_id;//通过服务器给定的Key上传数据
    
    //3.发送请求
    [mgr POST:[AHPersonInfoManager manager].getInfoModel.webApiUserUploadAvatarURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //单张图片
        NSData *data = UIImageJPEGRepresentation(image, 1.0);//将UIImage转为NSData，1.0表示不压缩图片质量。
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LOG(@"%@",responseObject);
        NSDictionary *dic = [responseObject yy_modelToJSONObject];
        NSString   *imageString = dic[@"avatar"];
        //相册本地化
        AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
        NSMutableArray *array = [infoModel.avatarArray mutableCopy];
        if (imageString.length>0) {
            [array insertObject:imageString atIndex:0];
            //设置为头像
            [self bt_setHead:imageString];
        }
        infoModel.avatarArray = array;
        [[AHPersonInfoManager manager] setInfoModel:infoModel];
        [self.listTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您上传片失败啦！" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
    }];
    
}

//设置为头像
-(void)bt_setHead:(NSString*)imageUrlString{
    UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
    editeInfoRequst.avatar = imageUrlString;
    [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
    [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
        UsersAlterInfoResponse *editeRespose = response;
        if (editeRespose.result == 0 ) {
            AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
            infoModel.avatarURL = imageUrlString;
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
            [self.listTableView reloadData];
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您的头像修改失败啦！" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
}

#pragma mark  -------MJHeaderView下拉放大--------
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
        return 2;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else{
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            AHTaskItemCell *taskItemeCell = [tableView dequeueReusableCellWithIdentifier:[AHTaskItemCell getIdentifier] forIndexPath:indexPath];
            [taskItemeCell setUpView];
            taskItemeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return taskItemeCell;
        }else{
            AHInfoItemCell *infoItemCell = [tableView dequeueReusableCellWithIdentifier:[AHInfoItemCell getIdentifier] forIndexPath:indexPath];
            infoItemCell.leftTitleLabel.text = @"收益";
            infoItemCell.leftDetailLabel.text = [NSString stringWithFormat:@"%lld", infoModel.income];
            infoItemCell.rightTitleLabel.text = @"牛牛币";
            infoItemCell.rightDetailLabel.text = [NSString stringWithFormat:@"%lld", infoModel.goldCoins];;
            infoItemCell.rightButtonAction = ^(){
                //我的游戏币
                [NSObject pushFromVC:self toVCWithName:@"AHMyGameCurrencyVC" InTheStoryboardWithName:@"AHStoryboard"];
            };
            infoItemCell.leftButtonAction = ^{
                //收益
            };
            infoItemCell.indexPath = indexPath;
            infoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return infoItemCell;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //视频回放
            AHTitleItemCell *titleItemCell =  [tableView dequeueReusableCellWithIdentifier:[AHTitleItemCell getIdentifier] forIndexPath:indexPath];
            titleItemCell.detailTitleLabel.text = [NSString stringWithFormat:@"%ld", infoModel.avatarURLArray_Count];
            return titleItemCell;
        }else{
            AHInfoItemCell *infoItemCell = [tableView dequeueReusableCellWithIdentifier:[AHInfoItemCell getIdentifier] forIndexPath:indexPath];
            infoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            infoItemCell.indexPath = indexPath;
            infoItemCell.leftTitleLabel.text = @"关注";
            infoItemCell.leftDetailLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)infoModel.myLikeCount];
            infoItemCell.rightTitleLabel.text = @"粉丝";
            infoItemCell.rightDetailLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)infoModel.likeMeCount];
            infoItemCell.rightButtonAction = ^(){
                //粉丝
                AHFansVC *myFansVC =   [[AHFansVC alloc]initWithMy:YES andPersonInfoModel:infoModel];
                [self.navigationController pushViewController:myFansVC animated:YES];
            };
            infoItemCell.leftButtonAction = ^{
                //关注
                AHMyAttentionVC *myAttentionVC  =[[AHMyAttentionVC alloc]init];
                [self.navigationController pushViewController:myAttentionVC animated:nil];
            };
            return infoItemCell;
        }
        
    }else if (indexPath.section == 2){
        //相册
        AHHeaderPhotoAlbumCell *headerPhotoAlbumCell =[tableView dequeueReusableCellWithIdentifier:[AHHeaderPhotoAlbumCell getIdentifier] forIndexPath:indexPath];
        [headerPhotoAlbumCell  setImageArray:infoModel.avatarArray isOwn:YES] ;
        headerPhotoAlbumCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headerPhotoAlbumCell;
    }else {
        AHInfoItemCell *infoItemCell = [tableView dequeueReusableCellWithIdentifier:[AHInfoItemCell getIdentifier] forIndexPath:indexPath];
        infoItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoItemCell.indexPath = indexPath;
        if (indexPath.row == 0) {
            infoItemCell.leftTitleLabel.text = @"星座";
            infoItemCell.leftDetailLabel.text = infoModel.constellation;
            infoItemCell.rightTitleLabel.text = @"性别";
            infoItemCell.rightDetailLabel.text =infoModel.genderString;
            infoItemCell.rightButtonAction = ^(){
                //性别
                [self.view endEditing:YES];
                STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
                pickerSingle.tag = SexViewTag;
                NSArray * tourDuringTimeArray =@[@"男",@"女"];
                [pickerSingle setArrayData:tourDuringTimeArray];
                [pickerSingle setTitle:@""];
                pickerSingle.widthPickerComponent = 100;
                [pickerSingle setContentMode:STPickerContentModeBottom];
                [pickerSingle setDelegate:self];
                [pickerSingle show];
                
            };
            infoItemCell.leftButtonAction = ^{
                //星座
                NSString *constellationString = @"魔羯座,水瓶座,双鱼座,白羊座,金牛座,双子座,巨蟹座,狮子座,处女座,天秤座,天蝎座,射手座,魔羯座";
                NSArray*constellationArray = [constellationString componentsSeparatedByString:@","];
                [self.view endEditing:YES];
                STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
                pickerSingle.tag = constellationViewTag;
                [pickerSingle setArrayData:constellationArray];
                [pickerSingle setTitle:@""];
                pickerSingle.widthPickerComponent = 100;
                [pickerSingle setContentMode:STPickerContentModeBottom];
                [pickerSingle setDelegate:self];
                [pickerSingle show];
            };
        }else{
            infoItemCell.leftTitleLabel.text = @"总魅力";
            infoItemCell.leftDetailLabel.text =[NSString stringWithFormat:@"%lld",infoModel.charmValue];
            infoItemCell.rightTitleLabel.text = @"送出";
            infoItemCell.rightDetailLabel.text = [NSString stringWithFormat:@"%lld",infoModel.outcome];
            infoItemCell.rightButtonAction = ^(){
                //送出
                
            };
            infoItemCell.leftButtonAction = ^{
                //总魅力
                AHContributionOfListVC *contributionListVC = [[AHContributionOfListVC alloc]init];
                [self.navigationController pushViewController:contributionListVC animated:YES];
            };
        }
        
        return infoItemCell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 72;
    }else if(indexPath.section == 2){
        return UITableViewAutomaticDimension;
    }else{
        return  60;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 1) {
        AHVideoRecordeVC *videoRecordeVC = [[AHVideoRecordeVC alloc]initWithTiTle:@"我的视频回放"];
        [self.navigationController  pushViewController:videoRecordeVC animated:YES];
    }
    
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


#pragma mark————————————性别、星座选择代理————————————————
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    
    if (pickerSingle.tag == SexViewTag) {
        Gender gender = 0;
        if ([selectedTitle isEqualToString:@"男"]) {
            gender = 1;
        }else if([selectedTitle isEqualToString:@"女"]){
            gender = 2;
        }else{
            gender = 0;
        }
        if (gender != [[AHPersonInfoManager manager]getInfoModel].gender) {
            UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
            editeInfoRequst.gender = gender;
              [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:YES];
            [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
                UsersAlterInfoResponse *editeRespose = response;
                if (editeRespose.result == 0 ) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                    infoModel.gender = gender;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                    _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
                    [self.listTableView reloadData];
                }else{
                    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                    [alertView showAlert];
                }
            }];
            
        }
        
    }else{
        TasksRequest_ConstellationParams *constellationTask = [[TasksRequest_ConstellationParams alloc]init];
        constellationTask.constellation = selectedTitle;
        [[AHTcpApi shareInstance]requsetMessage:constellationTask classSite:TasksClssName completion:^(id response, NSString *error) {
            LOG(@"星座：%@",response);
        }];
        if (![selectedTitle isEqualToString: [[AHPersonInfoManager manager]getInfoModel].constellation]) {
//            UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
//            editeInfoRequst.field = 32;
//            editeInfoRequst.constellation = selectedTitle;
//            [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
//                UsersAlterInfoResponse *editeRespose = response;
//                if (editeRespose.result == 0 ) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                    infoModel.constellation = selectedTitle;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                   _headerView.infoModel = [AHPersonInfoManager manager].getInfoModel;
                    [self.listTableView reloadData];
//                }else{
//                    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
//                    [alertView showAlert];
//                }
//            }];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
