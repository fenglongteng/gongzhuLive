//
//  AHAddressListViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHAddressListViewController.h"
#import "AHBindingView.h"
#import "AHReportListCell.h"
#import "AHPersonInfoVC.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "PPGetAddressBook.h"
#import "NSString+Tool.h"
#import "AHMobilePhoneLoginVC.h"
#define START NSDate *startTime = [NSDate date]
#define END NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
@interface AHAddressListViewController ()<AHBingViewDelegate,UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

/**
 未绑定手机号的站位试图
 */
@property (nonatomic,strong)AHBindingView *bingView;

/**
 列表
 */
@property (nonatomic,strong)UITableView *tableView;

/**
 tableView数据源
 */
@property (nonatomic,strong)NSMutableArray *dataSource;

/**
 消息发送器
 */
@property(nonatomic,strong)MFMessageComposeViewController *messageComposer;

/**
 手机通讯录原始数据   采用的是字母分组，每个分组是内部为数组（按第二字母排列）
 */
@property (nonatomic, copy) NSDictionary *contactPeopleDict;

/**
 手机通讯录原始数据  按字母排序中的 字母数组
 */
@property (nonatomic, copy) NSArray *keys;

/**
 返回的通讯录电话信息
 */
@property(nonatomic,strong)NSMutableDictionary *returnDic;
@end

@implementation AHAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getAddressList];
}

-(void)setUpView{
    self.navigationItem.title = @"通讯录好友";
    self.bingView.frame = self.view.bounds;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = 65;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AHReportListCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    //若没有绑定手机号码怎么搞
    if (![AHPersonInfoManager manager].getInfoModel.isTelephoneBinding) {
         [self.view addSubview:self.bingView];
    }
   
    //设置侧边栏快捷索引颜色
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        /** 背景色 */
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        /** 字体颜色 */
        self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    }
}

//获取本地通讯录
-(void)getAddressList{
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        [self uploadAdddressList];
        [self.tableView reloadData];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}

//上传通信录
-(void)uploadAdddressList{
    NSMutableArray *listArray = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("uploadAddress.infoDict", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (NSString *key in self.keys) {
            NSArray *array = _contactPeopleDict[key];
            for (PPPersonModel *model in array) {
                UsersVerifyIsRegisteredUserRequest_Bundle *bundle = [[UsersVerifyIsRegisteredUserRequest_Bundle alloc]init];
                if (model.mobileArray.count>0) {
                    bundle.telephone = model.mobileArray[0];
                }else{
                    bundle.telephone = @"";
                }
                [listArray addObject:bundle];
            }
        }
        UsersVerifyIsRegisteredUserRequest *verifyRequest = [[UsersVerifyIsRegisteredUserRequest alloc]init];
        verifyRequest.bundleArray = listArray;
        [[AHTcpApi shareInstance]requsetMessage:verifyRequest classSite:UsersClassName completion:^(id response, NSString *error) {
            UsersVerifyIsRegisteredUserResponse *verifyRepose  = response ;
            if (verifyRepose.result == 0 && verifyRepose.bundleArray_Count>0) {
                [self changeReturnAddressBook:verifyRepose.bundleArray];
            }
        }];
    });
    
}

-(NSMutableDictionary*)returnDic{
    if (_returnDic == nil) {
        _returnDic = [NSMutableDictionary dictionary];
    }
    return _returnDic;
}

//网络获取的通讯录转本地
-(void)changeReturnAddressBook:(NSArray*)array{
    for (UsersVerifyIsRegisteredUserResponse_Bundle *bundle in array) {
        [_returnDic setObject:@(bundle.isRegisteredUser) forKey:bundle.telephone];
    }
     [self.tableView reloadData];
}

//若没有绑定手机号则显示绑定手机号按钮
- (AHBindingView *)bingView{
    if (_bingView == nil) {
        _bingView = [[AHBindingView alloc]init];
        _bingView.bingType = AHBingPhone;
        _bingView.delegate = self;
    }
    return _bingView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark -AHBingViewDelegate

- (void)bingAccount:(AHBindingView *)bingView{
    bingView.hidden = YES;
    AHMobilePhoneLoginVC *mobilePhoneLoginVC = [[AHMobilePhoneLoginVC alloc]init];
    [self.navigationController pushViewController:mobilePhoneLoginVC animated:YES];
}


#pragma mark -UITableViewDelegateAndDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _keys[section];
    
    return [(NSArray *)[_contactPeopleDict objectForKey:key]count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}

//侧边栏的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    NSString *telephone = people.mobileArray.count>0?people.mobileArray[0]:@"";
    BOOL isInstall = [[self.returnDic objectForKey:telephone] boolValue];
    cell.inviteBtn.hidden = isInstall;
    cell.people = people;
    cell.invitationBlock = ^(PPPersonModel*personModel){
        [self bt_invitation:personModel];
    };
    if (isInstall) {
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
       cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AHReportListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.inviteBtn.isHidden) {
        AHPersonInfoVC *personInfoVC = [[AHPersonInfoVC alloc]init];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }
}



//发送短信分享app
-(void)bt_invitation:(PPPersonModel*)personModel{
    NSArray *recipients = personModel.mobileArray;
    [self sendSMS:@"短信分享内容?????" recipientList:recipients];
}

-(void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(screenWidth -65, 8, 50, 30)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(msgbackFun:) forControlEvents:UIControlEventTouchUpInside];
        [controller.navigationBar addSubview:button];
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)msgbackFun:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  -  MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if(result==MessageComposeResultSent)
    {
        // NSLog(@"发短信成功");
    }
    else if(result==MessageComposeResultCancelled)
    {
        //  NSLog(@"发短信取消");
    }
    else if(result==MessageComposeResultFailed)
    {
        //  NSLog(@"发短信失败");
        [SVProgressHUD showErrorWithStatus:@"短信发送失败，请重试"];
    }
}


@end
