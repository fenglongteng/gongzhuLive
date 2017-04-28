//
//  AHVideoRecordeVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHVideoRecordeVC.h"
#import "AHVideoRecordeCollectionCell.h"
#import "AHDeleteCellAnimation.h"

@interface AHVideoRecordeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

//是否在管理状态
@property(nonatomic,assign)BOOL isManangerStatus;
@end

@implementation AHVideoRecordeVC

-(instancetype)initWithTiTle:(NSString*)title{
    if ([super init]) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    NSMutableArray *arra  = [NSMutableArray array];
    for (int i = 0; i<30; i++) {
        UIImage *image = [UIImage imageNamed:@"head.jpg"];
        [arra addObject:image];
    }
    self.sourceArray = arra;
    // Do any additional setup after loading the view from its nib.
}

-(void)setUpView{
    [self setHoldTitle:self.title];
    [self setUpCollectionView];
    [self setRightButtonBarItemTitle:@"管理" titleColor:[UIColor blackColor] target:self action:@selector(bt_manageVideoRecorde:)];
    
}

//管理播放记录
-(void)bt_manageVideoRecorde:(UIBarButtonItem*)buttonItem{
     _isManangerStatus = !_isManangerStatus;
    if (_isManangerStatus) {
        [buttonItem setTitle:@"取消"];
    }else{
        [buttonItem setTitle:@"管理"];
    }
    [self.colletionView reloadData];
}

-(void)setUpCollectionView{
    // 创建一个流式布局管理
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置滚动方向为垂直方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置单元格的最小水平间距
    layout.minimumInteritemSpacing = 4;
    // 设置最小行间间距
    layout.minimumLineSpacing = 4;
    // 设置内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //item大小
    layout.itemSize = CGSizeMake((screenWidth - 2*2-4)/2.f, (screenWidth -2*2-4)/2.0 + 50);
    [self createColltionView:layout andFrame:CGRectMake(0, 0, screenWidth - 4, screenHeight - 64)];
    [self.colletionView registerNib:[UINib nibWithNibName:@"AHVideoRecordeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.colletionView.backgroundColor = self.view.backgroundColor;

}

#pragma mark ------UICollectionViewDelegateAndDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AHVideoRecordeCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [self setUpCell:cell withIndexPath:indexPath];
    return cell;
}

-(void)setUpCell:(AHVideoRecordeCollectionCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    if (_isManangerStatus) {
        cell.deleteBt.hidden = NO;
        [AHDeleteCellAnimation vibrateAnimation:cell];
    }else{
        cell.deleteBt.hidden = YES;
        [cell.layer removeAnimationForKey:@"shake"];
    }
    cell.index = indexPath;
    WeakSelf;
    cell.deleteSeletedCell = ^(NSIndexPath *index){
        [weakSelf.colletionView performBatchUpdates:^{
            //delete the cell you selected
            [weakSelf.sourceArray removeObjectAtIndex:index.row];
            [weakSelf.colletionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index.row inSection:0]]];
        } completion:^(BOOL finished) {
            [weakSelf.colletionView reloadData];
        }];
    };
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell
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
