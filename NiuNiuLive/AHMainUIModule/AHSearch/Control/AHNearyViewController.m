//
//  AHNearyViewController.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHNearyViewController.h"
#import "AHSearchUserCell.h"
#import "AHCustomNavigationBar.h"
#import "AHPersonInfoVC.h"
#import "AHLocationManager.h"

@interface AHNearyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)UIButton *currentSelectBtn;

@property (nonatomic,strong)UIButton *sexCurrentSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *recentlyBtn;//离我最近的Btn
@property (weak, nonatomic) IBOutlet UIButton *allSexBtn;//全部btn
@property (nonatomic,strong)UIImageView *scrollBar;

@property (nonatomic,assign)int kscrollBarWidth;

@property (nonatomic,assign)double radius;

@property (nonatomic,strong)NSMutableArray * dataSource;
//上一次性别展示
@property (nonatomic,strong)NSString * lastGender;

@property (nonatomic,assign)int  nearyType;//离我最近 或推荐用户

@end

#define kscrollBarWidth 45

@implementation AHNearyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.nearyType = 0;
    [[AHLocationManager sharedInstance] startLocation];
    self.dataSource = [NSMutableArray array];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _lastGender = @"全部";
    self.collectionView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(160, 290);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 14;
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AHSearchUserCell" bundle:nil] forCellWithReuseIdentifier:@"searchCollectionCell"];
    
    [self getNearyPeopleArray:0];
    AHCustomNavigationBar *cusNaviView = [[AHCustomNavigationBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, navHeight) OnViewController:self];
    [cusNaviView.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    cusNaviView.titleLabel.text = @"附近的人";
    cusNaviView.titleLabel.textColor = [UIColor whiteColor];
    cusNaviView.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cusNaviView.titleLabel.hidden = NO;
    [self.view addSubview:cusNaviView];
    [self.view bringSubviewToFront:cusNaviView];
    self.currentSelectBtn = self.recentlyBtn;
    self.sexCurrentSelectBtn = self.allSexBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//筛选条件点击事件
- (IBAction)filtrateClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    if (self.currentSelectBtn == btn) {
        
        return;
    }
    self.currentSelectBtn.selected = NO;
    self.currentSelectBtn = btn;
    self.nearyType = (int)btn.tag;
    
    [self getNearyPeopleArray:self.nearyType];
}

//性别的筛选
- (IBAction)sexFiltrateClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = YES;
    
    if (self.sexCurrentSelectBtn == btn) {
        return;
    }
    self.sexCurrentSelectBtn.selected = NO;
    self.sexCurrentSelectBtn = btn;
    if (![_lastGender isEqualToString:self.sexCurrentSelectBtn.currentTitle]) {
        _lastGender = self.sexCurrentSelectBtn.currentTitle;
        [self reloadDatasouce];
    }
}

//性别筛选之后刷新数据

- (void)reloadDatasouce{
    
    [self getNearyPeopleArray:self.nearyType];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.dataSource.count;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AHSearchUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setModel:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    FindUser *findUser = [self.dataSource objectAtIndex:indexPath.row];
    
    AHPersonInfoVC *personVC = [[AHPersonInfoVC alloc]initWithUserId:findUser.userId];
    
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat page = scrollView.contentSize.width/screenWidth;
    
    [UIView animateWithDuration:0.25 animations:^{
    
        CGPoint offset = scrollView.contentOffset;
        CGFloat index = offset.x /page +14;
        CGRect frame = self.scrollBar.frame;
        frame.origin.x = index;
        self.scrollBar.frame = frame;
    }];
}

- (UIImageView *)scrollBar{
    
    if (!_scrollBar) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(14, screenHeight - 30, kscrollBarWidth, 3)];
        imageV.backgroundColor = UIColorFromRGB(0xfff600);
        imageV.layer.cornerRadius = 1.5;
        imageV.layer.masksToBounds = YES;
        [self.view addSubview:imageV];
        _scrollBar = imageV;
    }
    return _scrollBar;
}

- (BOOL)fd_prefersNavigationBarHidden{

    return YES;
}

- (void)getNearyPeopleArray:(int)type{
    
    UsersFindOtherRequest *userNear = [[UsersFindOtherRequest alloc]init];
    userNear.type = type;
    userNear.limit = 20;
    if ([self.sexCurrentSelectBtn.currentTitle isEqualToString:@"全部"]) {
        userNear.gender = Gender_GenderUnknown;
    }else if([self.sexCurrentSelectBtn.currentTitle isEqualToString:@"男"]){
        userNear.gender = Gender_GenderMale;
    }else if ([self.sexCurrentSelectBtn.currentTitle isEqualToString:@"女"]){
        userNear.gender = Gender_GenderFemale;
    }
    [[AHTcpApi shareInstance] requsetMessage:userNear classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersFindOtherResponse * nearUser = (UsersFindOtherResponse *)response;
        self.dataSource = nearUser.findUsersArray;
        [self.collectionView reloadData];
    }];
}


@end
