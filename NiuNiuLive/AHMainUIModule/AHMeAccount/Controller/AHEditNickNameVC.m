//
//  AHEditNickNameVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHEditNickNameVC.h"
#import "UIView+ST.h"
#import "AHPersonInfoManager.h"
#import "NSObject+AHUntil.h"
@interface AHEditNickNameVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *compeleBt;

/**
 新用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@end

@implementation AHEditNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHoldTitle:@"用户名称"];
    [_compeleBt addCornerRadius:5];
    _nickName.text = [[AHPersonInfoManager manager]getInfoModel].nickName;
    [_nickName becomeFirstResponder];
    _nickName.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//完成按钮事件
- (IBAction)bt_compeletAction:(id)sender {
    if (_nickName.text.length > 12 ||  _nickName.text.length == 0 || ! _nickName.text) {
        AHAlertView *alertView =[[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"亲，昵称要0到12个字符哟" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
        return;
    }
    if (![_nickName.text isEqualToString:[[AHPersonInfoManager manager]getInfoModel].nickName]) {
        UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
        editeInfoRequst.nickName = self.nickName.text;
          [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
        [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
            UsersAlterInfoResponse *editeRespose = response;
            if (editeRespose.result == 0 ) {
                AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
                infoModel.nickName = self.nickName.text;
                [[AHPersonInfoManager manager]setInfoModel:infoModel];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
            
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length+range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length]+[string length] -range.length;
    return newLength <= 12;
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
