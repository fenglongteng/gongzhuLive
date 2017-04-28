//
//  AHTaskItemCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHTaskItemCell.h"
#import "NSObject+AHUntil.h"
#import "UIButton+WGBCustom.h"
#import "AHSignInVC.h"
#import "LevelController.h"
#import "AHMyTaskCenterVC.h"
#import "NSDate+YYAdd.h"
#import "AHBarrageViewController.h"
@implementation AHTaskItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_signInBt titleBelowTheImageWithSpace:7];
    [_taskCenterBt titleBelowTheImageWithSpace:7];
    [_MyGradeBt titleBelowTheImageWithSpace:7];
    [_signRedot addCornerRadius:3];
    [_taskRedot addCornerRadius:3];
    [_gradeRedot addCornerRadius:3];
  
    // Initialization code
}

-(void)setUpView{
    AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
    _signRedot.hidden = infoModel.signed_p;
}

//签到
- (IBAction)bt_signInAction:(id)sender {
    [NSObject pushFromVC:[AppDelegate getNavigationTopController] toVCWithName:@"AHSignInVC" InTheStoryboardWithName:@"AHStoryboard"];
}

//任务中心
- (IBAction)bt_tashCenterAction:(id)sender {
    AHMyTaskCenterVC *myTaskVC = [[AHMyTaskCenterVC alloc]init];
    [[AppDelegate getNavigationTopController].navigationController pushViewController:myTaskVC animated:YES];
}

//我的等级
- (IBAction)bt_myGradeAction:(id)sender {
    LevelController *levelController = [[LevelController alloc]initWithUserModel:[AHPersonInfoManager manager].getInfoModel];
    [[AppDelegate getNavigationTopController].navigationController pushViewController:levelController animated:YES];
}

//比较时间 返回yes便是已经领取
-(BOOL)isAlreadyReceive{
    NSDate *signTimeOfLastTime = [[NSUserDefaults standardUserDefaults] valueForKey:SignTimeOfLastTime];
    NSDate *signTimeOfNow = [NSDate date];
    NSInteger day = [signTimeOfNow day];
    NSInteger month = [signTimeOfNow month];
    NSInteger year = [signTimeOfNow year];
    NSInteger day1 = [signTimeOfLastTime day];
    NSInteger month1 = [signTimeOfLastTime month];
    NSInteger year1 = [signTimeOfLastTime year];
    if (year>year1+1) {
        return YES;
    }else{
        if (month>month1+1) {
            return YES;
        }else{
            if (day>day1) {
                return YES;
            }else{
                return NO;
            }
        }
    }
}

//网络签到
-(void)sign{
    UsersGetSignedInInfoRequest *getSighedInInfoRequest = [[UsersGetSignedInInfoRequest alloc]init];
    getSighedInInfoRequest.userId = [AHPersonInfoManager manager].getInfoModel.userId;
    [[AHTcpApi shareInstance]requsetMessage:getSighedInInfoRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersGetSignedInInfoResponse *signedInInfoResponse = response;
        self.signedInInfoResponse = signedInInfoResponse;
        if (signedInInfoResponse.result == 0) {
            _signRedot.hidden = signedInInfoResponse.isSignedToday;
        }
        
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
