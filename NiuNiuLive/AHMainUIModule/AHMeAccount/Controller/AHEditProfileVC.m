//
//  AHEditProfileVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHEditProfileVC.h"
#import "AHPersonInfoManager.h"
#import "NSObject+AHUntil.h"
#define MAX_LIMIT_NUMS 30
@interface AHEditProfileVC ()<UITextViewDelegate>
//简介内容
@property (weak, nonatomic) IBOutlet UITextView *briefTextView;
//数量label
@property (weak, nonatomic) IBOutlet UILabel *showCountOfBriefLabel;

@end

@implementation AHEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

-(void)setUpView{
    [self setHoldTitle:@"编辑简介"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightButtonBarItemTitle:@"更新" titleColor:[UIColor blackColor] target:self action:@selector(bt_setUpMyProfile)];
    _briefTextView.text = [[AHPersonInfoManager manager]getInfoModel].brief;
    _showCountOfBriefLabel.text = [NSString stringWithFormat:@"%ld/30",_briefTextView.text.length];
    _briefTextView.delegate = self;
}

//更新资料
-(void)bt_setUpMyProfile{
    if(![_briefTextView.text isEqualToString:[[AHPersonInfoManager manager]getInfoModel].brief]){
        UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
        editeInfoRequst.brief = self.briefTextView.text;
          [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
        [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
            UsersAlterInfoResponse *editeRespose = response;
            if (editeRespose.result == 0 ) {
                AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager]getInfoModel];
                infoModel.brief = self.briefTextView.text;
                [[AHPersonInfoManager manager]setInfoModel:infoModel];
              AHAlertView *alertView =   [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"更新简介成功" cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:editeRespose.message cancelBtnTitle:@"知道了" cancelAction:nil];
                [alertView showAlert];
            }
        }];
    }
}

#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //显示负数
    self.showCountOfBriefLabel.text = [NSString stringWithFormat:@"%ld/%d",textView.text.length,MAX_LIMIT_NUMS];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
