//
//  AHMessageDetailVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/29.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHMessageDetailVC.h"

@interface AHMessageDetailVC ()

/**
 文章详情textView
 */
@property (weak, nonatomic) IBOutlet UITextView *messageDetailTextView;

@end

@implementation AHMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHoldTitle:@"消息详情"];
    self.messageDetailTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置页边距上边距10，左右边距各10，底边距0
    // Do any additional setup after loading the view from its nib.
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
