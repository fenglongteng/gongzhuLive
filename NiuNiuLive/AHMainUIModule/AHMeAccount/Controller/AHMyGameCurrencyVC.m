//
//  AHMyGameCurrencyTableVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMyGameCurrencyVC.h"
#import "UIView+ST.h"
#import "AHChoiceOfPaymentView.h"
#import "AHBillVC.h"
#import "NSString+Tool.h"
#import "AHTopUpHistoryVC.h"
@interface AHMyGameCurrencyVC ()
//我的游戏币
@property (weak, nonatomic) IBOutlet UILabel *myNumberLabel;
//充值历史
@property (weak, nonatomic) IBOutlet UILabel *topUpHistoryLabel;
//第一个金额label
@property (weak, nonatomic) IBOutlet UILabel *fistNumberOfGoldCOINSLabel;
@property (weak, nonatomic) IBOutlet UILabel *secodeNumberOfGoldCOINSLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeNumberOfGoldCOINSLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourNumberOfGoldCOINSLabel;
//第一个充值按钮
@property (weak, nonatomic) IBOutlet UIButton *fistTopUpBt;
@property (weak, nonatomic) IBOutlet UIButton *secondTopUpBt;
@property (weak, nonatomic) IBOutlet UIButton *threeTopUpBt;
@property (weak, nonatomic) IBOutlet UIButton *fourTopUpBt;
//体现
@property (weak, nonatomic) IBOutlet UIButton *reflectBt;

@property (nonatomic,strong) NSMutableArray *bundleArray;

@end

@implementation AHMyGameCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getUsersGetChargeCorrespondingTable];
    // Do any additional setup after loading the view.
}

//获取充值配置
-(void)getUsersGetChargeCorrespondingTable{
    UsersGetChargeCorrespondingTableRequest *requset = [[UsersGetChargeCorrespondingTableRequest alloc]init];
    requset.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:requset classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetChargeCorrespondingTableResponse *chargeCorrespondingTableResponse = response;
        if (chargeCorrespondingTableResponse.result == 0) {
            [self setUpConfiguration:chargeCorrespondingTableResponse.bundleArray];
            self.bundleArray = chargeCorrespondingTableResponse.bundleArray;
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:chargeCorrespondingTableResponse.message cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        
        }
    }];
}

-(void)setUpView{
    [self setHoldTitle:@"我的游戏币"];
    _myNumberLabel.text = [NSString stringWithFormat:@"%lld",[AHPersonInfoManager manager].getInfoModel.goldCoins];
    [self.reflectBt addCornerRadius:5];
    NSString *textStr = @"充值历史";
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:UIColorFromRGB(0X3ba9fc),NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    //赋值
    _topUpHistoryLabel.attributedText= attribtStr;
    //充值历史
    [_topUpHistoryLabel addTarget:self action:@selector(bt_TopUpHistory)];
    //按钮初始化
    [_fistTopUpBt addBorderColor:UIColorFromRGB(0x3ba9fc) andwidth:2  andCornerRadius:2];
    [_secondTopUpBt addBorderColor:UIColorFromRGB(0x3ba9fc) andwidth:2  andCornerRadius:2];
    [_threeTopUpBt addBorderColor:UIColorFromRGB(0x3ba9fc) andwidth:2  andCornerRadius:2];
    [_fourTopUpBt addBorderColor:UIColorFromRGB(0x3ba9fc) andwidth:2  andCornerRadius:2];
    [self setRightButtonBarItemTitle:@"账单" titleColor:[UIColor blackColor] target:self action:@selector(bt_pushBillVC)];
}

//更新UI配置
-(void)setUpConfiguration:(NSArray*)setingArray{
    for (int i = 0; i<setingArray.count; i++) {
    UsersGetChargeCorrespondingTableResponse_Bundle *bundle = setingArray[i];
        if (i== 0) {
            _fistNumberOfGoldCOINSLabel.text = [NSString stringWithFormat:@"%lld 游戏币",bundle.goldCoins];
            [_fistTopUpBt setTitle:[NSString stringWithFormat:@"%lld元",bundle.money] forState:UIControlStateNormal];
        }
        if (i== 1) {
            _secodeNumberOfGoldCOINSLabel.text = [NSString stringWithFormat:@"%lld 游戏币",bundle.goldCoins];
            [_secondTopUpBt setTitle:[NSString stringWithFormat:@"%lld元",bundle.money] forState:UIControlStateNormal];
        }
        if (i== 2) {
            _threeNumberOfGoldCOINSLabel.text = [NSString stringWithFormat:@"%lld 游戏币",bundle.goldCoins];
            [_threeTopUpBt setTitle:[NSString stringWithFormat:@"%lld元",bundle.money] forState:UIControlStateNormal];
        }
        if (i== 3) {
            _fourNumberOfGoldCOINSLabel.text = [NSString stringWithFormat:@"%lld 游戏币",bundle.goldCoins];
            [_fourTopUpBt setTitle:[NSString stringWithFormat:@"%lld元",bundle.money] forState:UIControlStateNormal];
        }
    }

}



//账单
-(void)bt_pushBillVC{
    AHBillVC *billVC =[[AHBillVC alloc]init];
    [self.navigationController pushViewController:billVC animated:YES];
}

//充值历史
-(void)bt_TopUpHistory{
    AHTopUpHistoryVC  *topUpHistoryVC =[[AHTopUpHistoryVC alloc]init];
    [self.navigationController pushViewController:topUpHistoryVC animated:YES];
}

//充值按钮响应
- (IBAction)topUp:(UIButton *)sender {
    [_fistTopUpBt setBackgroundColor:[UIColor whiteColor]];
    [_secondTopUpBt setBackgroundColor:[UIColor whiteColor]];
    [_threeTopUpBt setBackgroundColor:[UIColor whiteColor]];
    [_fourTopUpBt setBackgroundColor:[UIColor whiteColor]];
    [_fistTopUpBt setTitleColor:UIColorFromRGB(0x3ba9fc) forState:UIControlStateNormal];
    [_secondTopUpBt setTitleColor:UIColorFromRGB(0x3ba9fc) forState:UIControlStateNormal];
    [_threeTopUpBt setTitleColor:UIColorFromRGB(0x3ba9fc) forState:UIControlStateNormal];
    [_fourTopUpBt setTitleColor:UIColorFromRGB(0x3ba9fc) forState:UIControlStateNormal];
    sender.backgroundColor = UIColorFromRGB(0x3ba9fc);
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    AHChoiceOfPaymentView *paymentView = [[AHChoiceOfPaymentView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [paymentView showOnTheWindow];
    //充值
    NSInteger money =[NSString screenNumber:[sender titleForState:UIControlStateNormal]] ;
    [self topUpWithMoney:money];
}

//充值
-(void)topUpWithMoney:(NSInteger)money{
    AccountsChargeRequest *accountsChargeRequest = [[AccountsChargeRequest alloc]init];
    accountsChargeRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    accountsChargeRequest.money = money;
    [[AHTcpApi shareInstance]requsetMessage:accountsChargeRequest classSite:AccoutsClassName completion:^(id response, NSString *error) {
        AccountsChargeResponse *chargeRespose = response;
        if (chargeRespose.result == 0) {
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"充值成功" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
            for (UsersGetChargeCorrespondingTableResponse_Bundle *bundle in self.bundleArray) {
                if (money == bundle.money) {
                    AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager]getInfoModel];
                    infoModel.goldCoins += bundle.goldCoins;
                    [[AHPersonInfoManager manager]setInfoModel:infoModel];
                    _myNumberLabel.text = [NSString stringWithFormat:@"%lld",infoModel.goldCoins];
                }
            }
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"非常抱歉，充值失败" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
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
