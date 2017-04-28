//
//  LevelController.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "LevelController.h"
#import "levelCell.h"
#import "levelHeader.h"

@interface LevelController ()<UITableViewDelegate,UITableViewDataSource>{
    AHPersonInfoModel * _userModel;
}

@property (weak, nonatomic) IBOutlet UITableView *levelTable;
@property (nonatomic,strong)levelHeader * headerView;
@end

@implementation LevelController

- (instancetype)initWithUserModel:(AHPersonInfoModel *)userModel{
    self = [super init];
    if (self) {
        _userModel = userModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLineViewColor:BYColor(236, 237, 239)];
    self.navigationItem.title = @"我的等级";
    self.levelTable.delegate = self;
    self.levelTable.dataSource = self;
    self.levelTable.rowHeight = 55;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.levelTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.levelTable.alwaysBounceVertical = YES;
    [self.levelTable registerNib:[UINib nibWithNibName:@"levelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"levelCells"];
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"levelHeader" owner:nil options:nil];
    levelHeader *headerView = (levelHeader *)[nibView objectAtIndex:0];
    AHPersonInfoModel *infoModel = _userModel;
    UserLevel*levelModel = infoModel.level;
    headerView.levelTitle.text = levelModel.rank;
    UIImage *image = [UIImage  imageNamed:[NSString stringWithFormat:@"icon_grad%d",levelModel.level]];
    headerView.levelImage.image = image;
    //当前
    headerView.JingYanLbl.text = [NSString stringWithFormat:@"%lld/%lld",levelModel.experiencePoint,levelModel.nextLevelExperiencePoint];
    self.headerView = headerView;
    [self.headerView initWithFrame:CGRectMake(0, 0, screenWidth, 0.75*screenHeight) userModel:_userModel];
    self.levelTable.tableHeaderView = self.headerView;
    self.levelTable.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headerView.height = 0.75*screenHeight;
    [self.headerView updateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    levelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"levelCells"];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userLevelModel = _userModel.level;
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
    return cell;
}

@end
