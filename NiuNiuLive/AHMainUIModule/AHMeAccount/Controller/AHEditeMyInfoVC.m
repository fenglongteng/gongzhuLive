//
//  AHEditeMyInfoVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHEditeMyInfoVC.h"
#import "UIView+ST.h"
#import "CustomCamerButton.h"
#import "UIButton+WGBCustom.h"
#import "STPickerSingle.h"
#import "AHRecommendAttentionVC.h"
#import "AHPersonInfoManager.h"
#import "NSObject+AHUntil.h"
#import "AFNetworking.h"
#import "YYModel.h"
@interface AHEditeMyInfoVC ()<STPickerSingleDelegate,UITextFieldDelegate>
//头像imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//编辑头像按钮
@property (weak, nonatomic) IBOutlet UIButton *editHeadImageBt;
//头像图片
@property(nonatomic,strong)UIImage *headImage;
//编辑性别按钮
@property (weak, nonatomic) IBOutlet UIButton *editSexBt;
//sex选择所在view
@property (weak, nonatomic) IBOutlet UIView *sexView;
//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *completeBt;
//昵称
@property (weak, nonatomic) IBOutlet UITextField *nickNameLabel;
//性别
@property(nonatomic,assign)Gender gender;
@end

@implementation AHEditeMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //默认是男
    self.gender = 1;
    // Do any additional setup after loading the view from its nib.
}

-(void)setUpView{
    [self setHoldTitle:@"完善个人信息"];
    [_completeBt addCornerRadius:4.5];
    self.view.backgroundColor = UIColorFromRGB(0xecedef);
    [_headImageView addCornerRadius:40];
    [_editHeadImageBt addCornerRadius:13];
    [_editSexBt imageOnTheTitleRightWithSpace:7];
    [_sexView addTarget:self action:@selector(bt_editSex:)];
    _nickNameLabel.delegate = self;
    self.nickNameLabel.text = [[AHPersonInfoManager manager]getInfoModel].nickName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择头像
- (IBAction)bt_editHeadImageAction:(CustomCamerButton*)sender {
    [self.view endEditing:YES];
    sender.customVC = self;
    __weak   typeof(self) weakSelf = self;
    sender.pickSeletedImageBlock = ^(UIImage *image){
        weakSelf.headImageView.image = image;
        weakSelf.headImage = image;
        [weakSelf uploadImage:image andUser_id:[AHPersonInfoManager manager].getInfoModel.userId];
    };
    [sender showImagePicker];
}

//性别选择
- (IBAction)bt_editSex:(UIButton *)sender {
    [self.view endEditing:YES];
    STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
    NSArray * tourDuringTimeArray =@[@"男",@"女"];
    [pickerSingle setArrayData:tourDuringTimeArray];
    [pickerSingle setTitle:@""];
    pickerSingle.widthPickerComponent = 100;
    [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
}

//push到推荐关注
-(void)pushToRecommendAttentionVC{
    AHRecommendAttentionVC *recommendAttentionVC = [[AHRecommendAttentionVC alloc]init];
    [self.navigationController pushViewController:recommendAttentionVC animated:YES];
}

//完成
- (IBAction)bt_completeAction:(id)sender {
    if (_nickNameLabel.text.length > 12 ||  _nickNameLabel.text.length == 0 || ! _nickNameLabel.text) {
        AHAlertView *alertView =[[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"亲，昵称要0到12个字符哟" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
        [_nickNameLabel becomeFirstResponder];
        return;
    }
    //完成我的信息页面
        if (![_nickNameLabel.text isEqualToString:[[AHPersonInfoManager manager]getInfoModel].nickName]) {
            UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
            editeInfoRequst.nickName =_nickNameLabel.text;
            editeInfoRequst.gender = self.gender;
            [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:YES];
            [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
                UsersAlterInfoResponse *editeRespose = response;
                if (editeRespose.result == 0 ) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                    infoModel.nickName = _nickNameLabel.text;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                    [self pushToRecommendAttentionVC];
                }else{
                    AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                    [alertView showAlert];
                }
            }];
        }else{
               [self pushToRecommendAttentionVC];
        }
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
        AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
        NSMutableArray *array = [infoModel.avatarArray mutableCopy];
        if (imageString.length>0) {
            [array insertObject:imageString atIndex:0];
        }
        infoModel.avatarArray = array;
        [[AHPersonInfoManager manager] setInfoModel:infoModel];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LOG(@"%@",error);
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length+range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length]+[string length] -range.length;
    return newLength <= 12;
}

#pragma mark————————————性别选择代理————————————————
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    [_editSexBt setTitle:selectedTitle forState:UIControlStateNormal];
    Gender  gender = 0;
    if ([selectedTitle isEqualToString:@"男"]) {
        gender = 1;
    }else if([selectedTitle isEqualToString:@"女"]){
        gender = 2;
    }else{
        gender = 0;
    }
    self.gender = gender;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
