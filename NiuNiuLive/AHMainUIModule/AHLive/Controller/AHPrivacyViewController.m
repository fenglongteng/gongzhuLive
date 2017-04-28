//
//  AHPrivacyViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPrivacyViewController.h"
#import "AHLiveViewController.h"

@interface AHPrivacyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UITextField *privacyLiveTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *liveIntroLb;

@end

@implementation AHPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.liveImageView.layer.cornerRadius = self.liveImageView.height *0.5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)popPrivacyLive:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//进入直播间
- (IBAction)intoPrivacyLiveRoom:(id)sender {

    AHLiveViewController *liveVc = [[AHLiveViewController alloc]init];
    liveVc.roomId = self.roomInfo.ownerId;
    liveVc.roomPassW = self.privacyLiveTextFiled.text;
    [self.navigationController pushViewController:[[AHLiveViewController alloc]init] animated:YES];
}


@end
