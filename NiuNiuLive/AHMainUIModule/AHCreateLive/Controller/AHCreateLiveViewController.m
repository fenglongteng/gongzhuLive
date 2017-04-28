//
//  AHCreateLiveViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHCreateLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "certificationController.h"
#import "openLive.h"
#import "UIView+ST.h"
@interface AHCreateLiveViewController ()<UITextFieldDelegate>
//公开或者私密 选择控件
@property (weak, nonatomic) IBOutlet UISegmentedControl *commonSeg;
//输入框
@property (weak, nonatomic) IBOutlet UITextField *insertText;
//字数限制
@property (weak, nonatomic) IBOutlet UILabel *textCount;
//上次点击的按钮
@property(nonatomic,strong)UIButton * lastSelectedButton;

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)AVCaptureSession *session;
// AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;
//segment宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segWidthConstraint;
// 照片输出流对象
@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;
// 预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
// 放置预览图层的View
@property (nonatomic, strong)UIView *cameraShowView;
@end
 
@implementation AHCreateLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //相机相关设置
    [self initialSession];
    [self initCameraShowView];
    //更新UI
    [self setUpView];
}

-(void)setUpView{
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    visualEffectView.frame = self.view.frame;
    visualEffectView.alpha = 0.7;
    [self.view insertSubview:visualEffectView atIndex:1];
    //给View添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endingEdit)];
    [self.pressView addGestureRecognizer:tap];
    self.commonSeg.layer.borderColor = [UIColor grayColor].CGColor;
    self.commonSeg.layer.borderWidth = 1.0f;
    self.commonSeg.selectedSegmentIndex = 1;
    self.commonSeg.layer.masksToBounds = YES;
    [self.insertText setValue:UIColorFromRGB(0x878385) forKeyPath:@"_placeholderLabel.textColor"];
    [self.insertText setValue:[UIFont boldSystemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    self.insertText.delegate = self;
    //添加分享按钮
    UIView * shareView = [[UIView alloc] initWithFrame:CGRectMake(20, 250, screenWidth - 40, 40)];
    shareView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shareView];
    NSArray * btnImage = @[@"btn_ilive_shareweixin0",@"btn_ilive_sharepyq0",@"btn_ilive_shareqq0",@"btn_ilive_sharekj0",@"btn_ilive_sharesina0",@"btn_ilive_sharedx0"];
    NSArray * selectedImage = @[@"btn_ilive_shareweixin1",@"btn_ilive_sharepyq1",@"btn_ilive_shareqq1",@"btn_ilive_sharekj1",@"btn_ilive_sharesina1",@"btn_ilive_sharedx1"];
    CGFloat padding = (screenWidth - 280) / 7.0;
    for (int i = 0; i < 6; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImage[i]] forState:UIControlStateSelected];
        button.adjustsImageWhenHighlighted = NO;
        [shareView addSubview:button];
        button.frame = CGRectMake((padding + 40) * i + padding, 0, 40, 40);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)initialSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
}

- (void)initCameraShowView
{
    self.cameraShowView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:self.cameraShowView atIndex:0];
}
#pragma mark 摄像头方法
// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [viewLayer addSublayer:self.previewLayer];
    }
}

#pragma mark 切换摄像头
- (void)toggleCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        } else {
            return;
        }
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (void)endingEdit{
    [self.view endEditing:YES];
}

#pragma mark 分享按钮
- (void)buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (_lastSelectedButton && _lastSelectedButton != button) {
        _lastSelectedButton.selected = NO;
        button.selected = YES;
        _lastSelectedButton = button;
    }else{
        _lastSelectedButton = button;
        button.selected = YES;
    }
}

#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setUpCameraLayer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

//设置这个方法可以隐藏navigation
- (BOOL)fd_prefersNavigationBarHidden{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)closeOpeningLive:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 切换摄像头
- (IBAction)changeCamareFrontOrBack:(id)sender {
    [self toggleCamera];
}

#pragma mark 公开 或 私密 直播
- (IBAction)LiveOfPublicOrPrivate:(id)sender {
    UISegmentedControl * seg = (UISegmentedControl *)sender;
}

- (IBAction)startLive:(id)sender {
    if (self.commonSeg.selectedSegmentIndex == 0) {
        certificationController * cerVC = [[certificationController alloc] init];
        cerVC.showLabel = self.insertText.text;
        [self.navigationController pushViewController:cerVC animated:YES];
    }else{
        [self.navigationController pushViewController:[[openLive alloc] initWithInvitationMessage:self.insertText.text] animated:YES];
    }
    
}

- (void)dealloc{

    LOG(@"%s",__func__);

}


#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.insertText) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        self.textCount.text = [NSString stringWithFormat:@"%ld/18",proposedNewLength];
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.insertText) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}


@end
