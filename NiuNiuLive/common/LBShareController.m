//
//  LBShareController.m
//  Weather
//
//  Created by luobaoyin on 16/12/2.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "LBShareController.h"
#import "AppDelegate.h"
#import "UIViewController+HUD.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>
#import "UIViewController+HUD.h"
#import "CCHUD.h"

@interface LBShareController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIScrollViewDelegate>
//中间按钮的左边距约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QQConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageConst;


/**
 遮盖层
 */
@property (weak, nonatomic) IBOutlet UIView *maskView;

/**
 分享视图
 */
@property (weak, nonatomic) IBOutlet UIView *shareView;

/**
 分享视图距离底部的layout
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottomLayout;

/**
 分享滚动界面
 */
@property (weak, nonatomic) IBOutlet UIScrollView *shareScroller;

/**
 分享滚动content
 */
@property (weak, nonatomic) IBOutlet UIView *scrollerContentView;

/**
 页数page
 */
@property (weak, nonatomic) IBOutlet UIPageControl *sharePage;

/**
 标题view
 */
@property (weak, nonatomic) IBOutlet UIView *titleView;

/**
 第一页
 */
@property (weak, nonatomic) IBOutlet UIView *page1;

/**
 第二页
 */
@property (weak, nonatomic) IBOutlet UIView *page2;
/**
 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/**
 分享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqzoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxpyqBtnm;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

/**
 *  短信分享界面
 */
@property (nonatomic,strong) MFMessageComposeViewController *controller;


@end

@implementation LBShareController

-(instancetype)initWithMessage:(NSString *)message;{
    if (self = [super init]) {
        _shareText = message;
    }
    return self;
}

+(instancetype)showShareViewWithMessage:(NSString *)message{
    LBShareController *shareVC = [[LBShareController alloc] initWithMessage:message];
    shareVC.view.tag = 300;
    [[AppDelegate getAppdelegateWindow] addSubview:shareVC.view];
    return shareVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //中间分享按钮左边距
    CGFloat leftPadding = (screenWidth - 50 - 204) / 3.0;
    _friendConst.constant = leftPadding;
    _QQConst.constant = leftPadding;
    _messageConst.constant = leftPadding;
    [_wxpyqBtnm layoutIfNeeded];
    [_qqBtn layoutIfNeeded];
    [_messageBtn layoutIfNeeded];
    //计算frame
    [self endLayout];
    //遮盖层添加关闭事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareViewAnimation)];
    [self.maskView addGestureRecognizer:tapGesture];
    
    //设置滚动代理
    _shareScroller.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endLayout{
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
    [self.maskView setNeedsLayout];
    [self.maskView layoutSubviews];
    [self.shareView setNeedsLayout];
    [self.shareView layoutSubviews];
//    [self.sharePage setNeedsLayout];
//    [self.sharePage layoutSubviews];
    [self.cancelBtn setNeedsLayout];
    [self.cancelBtn layoutSubviews];
    [self.titleView setNeedsLayout];
    [self.titleView layoutSubviews];
    [self.scrollerContentView setNeedsLayout];
    [self.scrollerContentView layoutSubviews];
    [self.shareScroller setNeedsLayout];
    [self.shareScroller layoutSubviews];
    [self.page1 setNeedsLayout];
    [self.page1 layoutSubviews];
    [self.page2 setNeedsLayout];
    [self.page2 layoutSubviews];
    [self.wxBtn setNeedsLayout];
    [self.wxBtn layoutSubviews];
    [self.wxpyqBtnm setNeedsLayout];
    [self.wxpyqBtnm layoutSubviews];
    [self.qqBtn setNeedsLayout];
    [self.qqBtn layoutSubviews];
    [self.qqzoneBtn setNeedsLayout];
    [self.qqzoneBtn layoutSubviews];
    [self.sinaBtn setNeedsLayout];
    [self.sinaBtn layoutSubviews];
    [self.messageBtn setNeedsLayout];
    [self.messageBtn layoutSubviews];
}

- (IBAction)shareBtn:(id)sender {
    UIButton *button = sender;
    NSString *identifier = [button currentTitle];
    if ([identifier isEqualToString:@"微信"] || [identifier isEqualToString:@"朋友圈"]) {
        [self shareWXWithType:identifier];
    }
    if ([identifier isEqualToString:@"QQ"] || [identifier isEqualToString:@"QQ空间"]) {
        [self shareTencQQzone:identifier];
    }
    if ([identifier isEqualToString:@"新浪微博"]) {
        [self shareSina];
    }
    
    if ([identifier isEqualToString:@"短信"]){
        [self shareSMS];
    }
    //移除分享视图
    [self hiddenShareViewAnimation];
}

/**
 取消分享

 @param sender 取消btn
 */
- (IBAction)cancelShate_Event:(id)sender {
    [self hiddenShareViewAnimation];
}

#pragma mark - scrollerdelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pagge = offsetX / self.view.bounds.size.width;
    _sharePage.currentPage = pagge;
}


#pragma mark - 分享方法
/**
 *  微信和朋友圈分享
 *
 *  @param type 区分好友还是朋友圈
 */
- (void)shareWXWithType:(NSString *)type{
    SSDKPlatformType shareType = [type isEqualToString:@"微信"] ? SSDKPlatformSubTypeWechatSession : SSDKPlatformSubTypeWechatTimeline;
    [self ShareMessageWithType:shareType];
}

/**
 *  分享qq以及qq空间
 *
 *  @param type 区分qq和qq空间
 */
- (void)shareTencQQzone:(NSString *)type{
    SSDKPlatformType shareType = [type isEqualToString:@"QQ"] ? SSDKPlatformSubTypeQQFriend : SSDKPlatformSubTypeQZone;
    [self ShareMessageWithType:shareType];
}

/**
 *  新浪分享
 */
- (void)shareSina{
    [self ShareMessageWithType:SSDKPlatformTypeSinaWeibo];
}

/**
 *  短信分享
 */
-(void)shareSMS{
    
    self.controller = [[MFMessageComposeViewController alloc] init];
    self.controller.recipients = @[];
    self.controller.navigationBar.tintColor = [UIColor redColor];
    self.controller.body = self.shareText;
    self.controller.messageComposeDelegate = self;
    [_beViewController presentViewController:self.controller animated:YES completion:nil];
    [[[[self.controller viewControllers] lastObject] navigationItem] setTitle:@"发送新信息"];//修改短信界面标题
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSMSVC)];
    [[[self.controller viewControllers] lastObject] navigationItem].rightBarButtonItem = rightItem;
    
}

- (void)dismissSMSVC{
    [self showHint:@"取消分享!"];
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    self.controller = nil;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            [self showHint:@"取消分享!"];
            break;
        }
        case MessageComposeResultSent:
        {
            [self showHint:@"分享成功!"];
        }
        default:
        {
            [self showHint:@"分享失败!"];
            if (self.shareFailBlock) {
                self.shareFailBlock();
            }
            break;
        }
    }
    [self dismissSMSVC];
}

- (void)ShareMessageWithType:(SSDKPlatformType)shareType{
    NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareText
                                     images:@[[self thumbnailWithImageWithoutScale:self.shareImg size:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)]] //传入要分享的图片
                                        url:nil
                                      title:@"牛牛直播"
                                       type:SSDKContentTypeImage];
    
    WeakSelf;;
    [ShareSDK share:shareType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         StrongSelf;
         [strongSelf logShareMessaheWithSSDKResponseState:state error:error];
     }];
}

/**
 *  显示分享阶段的信息
 *
 *  @param state 状态
 */
- (void)logShareMessaheWithSSDKResponseState:(SSDKResponseState)state error:(NSError *)error{
    
    if (state == SSDKResponseStateBegin) {
        [self showHudInView:[AppDelegate getAppdelegateWindow] hint:nil];
    }else{
        [self hideHud];
    }
    if (state == SSDKResponseStateSuccess )
    {
        [CCHUD showTip:@"分享成功"];
        return;
    }
    if (state == SSDKResponseStateCancel) {
        [CCHUD showTip:@"取消分享"];
        return;
    }
    if (state == SSDKResponseStateFail)
    {
        [CCHUD showTip:@"分享失败"];
    }
}


/**
 *  图片等比例压缩处理
 */
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image){
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


#pragma mark - 渐变动画
/**
 *  动画显示分享视图
 */
-(void)showShareViewAnimation{
    [UIView animateWithDuration:0.45 animations:^{
        self.maskView.alpha = 1;
        _shareViewBottomLayout.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

/**
 *  动画隐藏分享视图
 */
-(void)hiddenShareViewAnimation{
    _shareViewBottomLayout.constant = -310;
    [UIView animateWithDuration:0.45 animations:^{
        self.maskView.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        for(UIView * view in self.view.subviews){
            [view removeFromSuperview]; 
        }
        [self.view removeFromSuperview];
    }];
}

#pragma mark - get/set
- (NSString *)shareText{
    if (_shareText) {
        return _shareText;
    }
    return @"";
}

@end
