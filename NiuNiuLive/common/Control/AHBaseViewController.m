//
//  AHBaseViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/16.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"
#import "UIImage+extension.h"
#import "SDImageCache.h"
@interface AHBaseViewController ()
//导航栏分割线颜色
@property(nonatomic,strong)UIView *lineView;

@end

@implementation AHBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_customNavigationBar) {
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xecedef);
    self.view.frame = [UIScreen mainScreen].bounds;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.automaticallyAdjustsScrollViewInsets = YES;
    //消除导航栏黑线
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
    //添加导航栏分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height - 0.5, screenWidth, 0.5)];
    lineView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:lineView];
    self.lineView = lineView;
}


- (void)hideleftBarButtonItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title =  @"";
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)addPopButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [UIImage imageNamed:@"btn_home_arrow"];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = (CGRect ){.size= {image.size.width,image.size.height}};
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIBarButtonItem *rigthBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rigthBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rigthBarbtnItem;
}

- (void)setRightButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action{
    
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *lightImage = [UIImage imageNamed:highlightImageStr];
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rigthBtn setImage:image forState:UIControlStateNormal];
    [rigthBtn setImage:lightImage forState:UIControlStateHighlighted];
    rigthBtn.frame = (CGRect ){.size= {image.size.width,image.size.height}};
    //    [rigthBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -image.size.width+10, 0, 10)];
    [rigthBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
}

- (void)setLeftButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *leftBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [leftBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBarbtnItem;
}

- (void)setLeftButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action{
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *lightImage = [UIImage imageNamed:highlightImageStr];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn setImage:lightImage forState:UIControlStateHighlighted];
    leftBtn.frame = (CGRect ){.size= {image.size.width,image.size.height}};
    //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -image.size.width+10, 0, 10)];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

//设置右边的导航按钮 （文字+颜色）
- (void)setRightButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action{
    UIBarButtonItem *rigthBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rigthBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, color,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rigthBarbtnItem;
}

//设置左边的导航按钮 （文字+颜色）
- (void)setLeftButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action{
    UIBarButtonItem *leftBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [leftBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, color,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBarbtnItem;
}

-(void)setHoldTitle:(NSString*)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
}


-(void)setTitleView:(UIView *)titleView{
    self.navigationItem.titleView = titleView;
}

-(void)setBarTintColor:(UIColor*)color{
    [self.navigationController.navigationBar setBarTintColor:color];
    
}

-(void)setCustomTransparencyNavigationBarWithFrame:(CGRect)frame{
    _customNavigationBar = [[AHCustomNavigationBar alloc]initWithFrame:frame OnViewController:self];
    [self.view addSubview:_customNavigationBar];
}

- (void)setLineViewColor:(UIColor *)color{
    
    _lineView.backgroundColor = color;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
