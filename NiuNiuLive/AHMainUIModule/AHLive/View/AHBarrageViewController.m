//
//  AHBarrageViewController.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/4/19.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBarrageViewController.h"
#import "FXDanmaku.h"
#import "DemoDanmakuItemData.h"
#import "DemoDanmakuItem.h"
#import "Messages.pbobjc.h"
#import "NSString+Tool.h"
#import "UIImageView+CornerRadius.h"
#define CurrentDevice [UIDevice currentDevice]
#define CurrentOrientation [[UIDevice currentDevice] orientation]
#define ScreenScale [UIScreen mainScreen].scale
#define NotificationCetner [NSNotificationCenter defaultCenter]
@interface AHBarrageViewController ()<FXDanmakuDelegate>
@property (weak, nonatomic) IBOutlet FXDanmaku *danmaku;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation AHBarrageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:CloseLive object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupDanmaku];
    [self timer];
}

-(NSTimer*)timer{
    if (_timer==nil) {
     _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:5 target:self selector:@selector(addDatas) userInfo:nil repeats:YES];
      [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)addDatas{
    [self addDatasWithCount:1];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    LOG(@"----%s-------",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Orientation
- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Views
- (void)setupDanmaku {
    FXDanmakuConfiguration *config = [FXDanmakuConfiguration defaultConfiguration];
    config.rowHeight = 30;
    config.estimatedRowSpace = 5;
    config.itemInsertOrder = FXDanmakuItemInsertOrderFromTop;
    self.danmaku.configuration = config;
    self.danmaku.backgroundColor = [UIColor clearColor];
    self.danmaku.delegate = self;
    config.itemMinVelocity = 80;  // set random velocity between 80 and 120 pt/s
    config.itemMaxVelocity = 120;
    [self.danmaku registerNib:[UINib nibWithNibName:NSStringFromClass([DemoDanmakuItem class]) bundle:nil]
       forItemReuseIdentifier:[DemoDanmakuItem reuseIdentifier]];
}

#pragma mark - Observer
- (void)setupObserver {
    [NotificationCetner addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [NotificationCetner addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self.danmaku start];
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    [self.danmaku pause];
}


#pragma mark - FXDanmakuDelegate
- (void)danmaku:(FXDanmaku *)danmaku didClickItem:(FXDanmakuItem *)item withData:(DemoDanmakuItemData *)data {
 // LOG(@"didClick");
}
- (void)danmaku:(FXDanmaku *)danmaku willDisplayItem:(FXDanmakuItem *)item withData:(FXDanmakuItemData *)data{
  //  LOG(@"display");
}
- (void)danmaku:(FXDanmaku *)danmaku didEndDisplayingItem:(FXDanmakuItem *)item withData:(FXDanmakuItemData *)data{
 //    LOG(@"Enddisplay");
}


#pragma mark - DataSource
- (void)addDatasWithCount:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        DemoDanmakuItemData *data = [DemoDanmakuItemData data];
        data.avatarName = @"";
        data.desc = @"";
        [self.danmaku addData:data];
    }
    
    if (!self.danmaku.isRunning) {
        [self.danmaku start];
    }
}

#pragma mark  - 添加弹幕

-(void)addBarrageDArrayOfEmoDanmakuItemData:(NSArray*)Array{
    
    static NSInteger index = 0;
    for (PushMessage *pushMessage in Array) {
        DemoDanmakuItemData *data = [DemoDanmakuItemData data];
        data.avatarName = [NSString getImageUrlString:pushMessage.avatar].absoluteString;
        data.desc = pushMessage.message;
        [self.danmaku addData:data];
        index++;
    }
    LOG(@"当前是第======%ld=====个弹幕",(long)index);
    if (!self.danmaku.isRunning) {
        [self.danmaku start];
    }
}

-(void)dismiss{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    [self.view removeFromSuperview];
    [self.danmaku emptyData];
}

#pragma mark - Orientation
#pragma mark For iOS8 And Later
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // if danmaku view's height will change in different device orientation, you'd better pause danmaku and clean screen before orientation will change.
    [self.danmaku pause];
    // if you could set danmaku.cleanScreenWhenPaused = false, then you need to call 'cleanScreen' method after pause.
    //    [self.danmaku cleanScreen];
    
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                     // resume danmaku after orientation did change
                                     [self.danmaku start];
                                 }];
}
#pragma mark For Version below iOS8
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.danmaku pause];
    // if you could set danmaku.cleanScreenWhenPaused = false, then you need to call 'cleanScreen' method after pause.
    //    [self.danmaku cleanScreen];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.danmaku start];
}

@end
