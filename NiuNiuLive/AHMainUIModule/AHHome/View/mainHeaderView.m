//
//  mainHeaderView.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "mainHeaderView.h"
#import "Masonry.h"
#import "Systems.pbobjc.h"
#import "WKWebViewController.h"

NSInteger const imageViewCount = 3; //视图的数量
@interface mainHeaderView()<UIScrollViewDelegate>{
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlBottom;

//自动轮播图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//轮播显示器
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
//站位图片数组
@property (nonatomic, strong) NSMutableArray *imageNameArray;
//添加图片视图的数组
@property (nonatomic, strong) NSMutableArray *imageViewArray;
//当前显示图片的下标
@property (nonatomic,assign) NSInteger currentIndext;
//网络图片urlString数组
@property (nonatomic, strong) NSMutableArray *ImageUrlStrArray;
//滚动
@property (nonatomic, strong) GLHBannerView *bannerView;
@end

@implementation mainHeaderView

- (void)initWithHeaderViewFrame:(CGRect)frame{
    self.frame = frame;
    [self setScrollViewMessage];
    CGFloat buttonWidth = (screenWidth - 50) / 4.0;
    CGFloat buttonHeight = buttonWidth * 55.0 / 80;
    
    NSArray * titleArray = @[@"魅力榜",@"棋牌",@"签到",@"我的等级"];
    NSArray * imageArray = @[@"btn_home_mltop",@"btn_home_pokertool",@"btn_home_mark",@"btn_home_grade"];
    CGFloat rap = 10.0;
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat leftRap = rap + i * (buttonWidth + rap);
        button.frame = CGRectMake(leftRap, 0, buttonWidth, buttonHeight);
        button.tag = 1000 + i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:9.0 * screenWidth / 320 weight:0.5];
        [button addTarget:self action:@selector(button_pressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
            make.left.equalTo(@(leftRap));
            make.bottom.equalTo(@(-8));
        }];
    }
    
}

- (void)setScrollViewMessage{
    //初始化数组
    self.imageNameArray = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    self.currentIndext = 0;
    NSArray * pathArray = @[@"image_gamegold.jpg",@"image_homebanner1.jpg",@"image_bairennn.jpg"];
    for (int i = 0; i <= 2; i ++) {
        NSString *imageName = pathArray[i];
        //获取路径
        NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:imageName];
        [self.imageNameArray addObject:path];
    }
    CGFloat height = CGRectGetHeight(_scrollView.bounds);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(screenWidth * 3, height);
    //添加子视图
    for (int i = 0; i < imageViewCount; i ++) {
        // 配置属性
        CGFloat width = screenWidth;
        CGFloat height = CGRectGetHeight(_scrollView.bounds);
        //创建UIImage
        UIImage *image = [UIImage imageNamed:self.imageNameArray[i]];
        // 创建图片视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:imageView];
        // 添加到数组
        [self.imageViewArray addObject:imageView];
    }
    CGFloat buttonWidth = (screenWidth - 50) / 4.0;
    CGFloat buttonHeight = buttonWidth * 55.0 / 80;
    CGFloat bottm = buttonHeight + 8 + 12;
    _pageControlBottom.constant = bottm;
    [_pageController layoutIfNeeded];
    _pageController.currentPage = 0;
    _pageController.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageController.pageIndicatorTintColor = [UIColor grayColor];
    [self dynimicloadingImageIndext];
}

//网络图片
- (void)setImageUrlStrArray:(NSMutableArray *)ImageUrlStrArray WithBannerFrame:(CGRect)frame andDelegate:(id)delegate{
    self.bannerView  = [[GLHBannerView alloc]initWithFrame:frame];
    [self.bannerView showImageRotatorComponentWithImageArray:ImageUrlStrArray];
   _ImageUrlStrArray = ImageUrlStrArray;
    self.bannerView.clickImageDelegate = delegate;
    [self addSubview:self.bannerView];
}


-(void)pushAdvertismentVC:(UITapGestureRecognizer*)sender{
    NSInteger idx = sender.view.tag -100 ;
    SystemGetADListResponse_AD* ad = self.ImageUrlStrArray[idx];
    WKWebViewController *webViewController = [[WKWebViewController alloc]init];
    [webViewController loadWebURLSring:ad.link];
    [[AppDelegate getNavigationTopController].navigationController pushViewController:webViewController animated:YES];
}

//根据下标动态加载图片
- (void)dynimicloadingImageIndext {
    for (int i = -1; i <= 1; i ++) {
        //获取正确下标
        NSInteger index = (_currentIndext + i + _imageNameArray.count)% _imageNameArray.count;
        UIImage *image = [UIImage imageWithContentsOfFile:_imageNameArray[index]];
        //获取图片视图 [-1,1] + 1  <==> [0,2]
        UIImageView *imageView = _imageViewArray[i + 1];
        //关联图片
        if(image){
              imageView.image = image;
        }else{
             [imageView sd_setImageWithURL:[NSURL URLWithString:_imageNameArray[index]]];
        }
        //将pageControl和图片关联
        _pageController.currentPage = _currentIndext;
    }
    //修改偏移量
    self.scrollView.contentOffset = CGPointMake(screenWidth, 0);
    
}
- (void)pageLeft {
    _currentIndext = (--_currentIndext + _imageNameArray.count) % _imageNameArray.count;
    [self dynimicloadingImageIndext];
}

- (void)pageRight {
    _currentIndext = (++_currentIndext + _imageNameArray.count) % _imageNameArray.count;
    [self dynimicloadingImageIndext];
}

#pragma mark - UIScrollViewDelegate

//已经滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x <= 0) {
        [self pageLeft];
    }else if (scrollView.contentOffset.x >= 2 * CGRectGetWidth(scrollView.bounds)){
        [self pageRight];
    }
}
//将要拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseTimer];
}

//已经减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startTimer];
}


- (void)button_pressed:(UIButton *)sender{
    NSString * title = sender.currentTitle;
    if (self.pushBlock) {
        self.pushBlock(title);
    }
}


#pragma mark - timer

- (void)startTimer{
    if (_timer) {
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

//暂停
- (void)pauseTimer{
    if (_timer) {
        _timer.fireDate = [NSDate distantFuture];
    }
    
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)handleTimer:(NSTimer *)timer{
    [self.scrollView setContentOffset:CGPointMake((self.imageNameArray.count - 1) * screenWidth, 0) animated:YES];
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
