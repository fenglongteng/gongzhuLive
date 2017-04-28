//
//  AHPhotoAlubmVC.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPhotoAlubmVC.h"
#import "AHPhotoAlbumCell.h"
#import "AHDeleteCellAnimation.h"
#import "MWPhotoBrowser.h"
#import "NSString+Tool.h"
#import "AHAlertView.h"
@interface AHPhotoAlubmVC ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>

//是否在管理状态
@property(nonatomic,assign)BOOL isManangerStatus;

/**
 *  图片浏览器
 */
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
/**
 *  图片集合
 */
@property (strong, nonatomic) NSMutableArray *mwPhotos;

@property(nonatomic,assign)BOOL isMy;
@end

@implementation AHPhotoAlubmVC

-(instancetype)initWithMy:(BOOL)isMy AndSourceArray:(NSArray*)array{
    if ([super init]) {
        _isMy = isMy;
        self.sourceArray = [array mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setUpView{
    [self setHoldTitle:@"相册"];
    [self setUpCollectionView];
    if (_isMy) {
        [self setRightButtonBarItemTitle:@"管理" titleColor:[UIColor blackColor] target:self action:@selector(bt_managePhotoAlubm:)];
    }else{
        
    }
    
}

//管理相册
-(void)bt_managePhotoAlubm:(UIBarButtonItem*)buttonItem{
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
    layout.minimumInteritemSpacing = 2;
    // 设置最小行间间距
    layout.minimumLineSpacing = 2;
    // 设置内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //item大小
    layout.itemSize = CGSizeMake((screenWidth - 5*2-6)/4.f, (screenWidth - 5*2-6)/4.f);
    [self createColltionView:layout andFrame:CGRectMake(5, 0, screenWidth -10, screenHeight -64)];
    [self.colletionView registerNib:[UINib nibWithNibName:@"AHPhotoAlbumCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.colletionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

#pragma mark ------UICollectionViewDelegateAndDataSource
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7.5, 200, 10)];
    titleLabel.textColor = UIColorFromRGB(969696);
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.contentMode = UIViewContentModeTopLeft;
    titleLabel.text = @"";
    [headView addSubview:titleLabel];
    return headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 20);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AHPhotoAlbumCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSURL *imageUrl = [NSString getImageUrlString:self.sourceArray[indexPath.row]];
    [cell.headImageView sd_setImageWithURL:imageUrl placeholderImage:DefaultHeadImage];
    [self setUpCell:cell withIndexPath:indexPath];
    return cell;
}

-(void)setUpCell:(AHPhotoAlbumCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    cell.index = indexPath;
    if (_isManangerStatus) {
        cell.deleteBt.hidden = NO;
        [AHDeleteCellAnimation vibrateAnimation:cell];
    }else{
        cell.deleteBt.hidden = YES;
        [cell.layer removeAnimationForKey:@"shake"];
    }
    NSString *urlString = self.sourceArray[indexPath.row];
    cell.deleteSeletedCell = ^(NSIndexPath *index){
//        [self RemoveAvatarWithUrlString:urlString indexPath:index];
        [self.colletionView performBatchUpdates:^{
            //delete the cell you selected
            //删除头像
            [self RemoveAvatarWithUrlString:urlString indexPath:index];
        } completion:^(BOOL finished) {
            
        }];
    };
}

//删除头像
-(void)RemoveAvatarWithUrlString:(NSString*)urlString indexPath:(NSIndexPath*)indexPath{
    UsersRemoveAvatarRequest *removeRequest = [[UsersRemoveAvatarRequest alloc]init];
    removeRequest.avatarName = urlString;
    [[AHTcpApi shareInstance]requsetMessage:removeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
        UsersRemoveAvatarResponse *removeResponse = response;
        if (removeResponse.result == 0) {
             LOG(@"删除成功==%@=====位置%ld",urlString,indexPath.row);
            if (self.sourceArray.count>indexPath.row) {
                AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                NSMutableArray *array = [infoModel.avatarArray mutableCopy];
                [array removeObject:urlString];
                infoModel.avatarArray = array;
                [[AHPersonInfoManager manager] setInfoModel:infoModel];
                [self.sourceArray removeObjectAtIndex:indexPath.row];
//                [self.colletionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
                [self.colletionView reloadData];
            }
        }
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell
    [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
    [[AppDelegate getNavigationTopController] presentViewController:self.photoBrowser animated:NO completion:nil];
}

/**
 *  初始化相册浏览器
 *
 *  @return 相册浏览器
 */
- (MWPhotoBrowser *)photoBrowser{
    
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.displayNavArrows = NO;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        _photoBrowser.dismissWithTap = YES;
        _photoBrowser.showPageControl = NO;
        _photoBrowser.showCustomView = YES;
        _photoBrowser.isOwn = _isMy;
        WeakSelf;
        _photoBrowser.deletePhotoBlock = ^(id info){
            NSString *imageString = info;
            UsersRemoveAvatarRequest *removeRequest = [[UsersRemoveAvatarRequest alloc]init];
            removeRequest.avatarName = imageString;
            [[AHTcpApi shareInstance]requsetMessage:removeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
                UsersRemoveAvatarResponse *removeResponse = response;
                if (removeResponse.result == 0) {
                    if (weakSelf.isMy) {
                        AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                        NSMutableArray *array = [infoModel.avatarArray mutableCopy];
                        [array removeObject:imageString];
                        infoModel.avatarArray = array;
                        [[AHPersonInfoManager manager] setInfoModel:infoModel];
                        weakSelf.sourceArray = array;
                        [weakSelf.colletionView reloadData];
                        [weakSelf.photoBrowser reloadData];
                        NSInteger number = [weakSelf numberOfPhotosInPhotoBrowser:weakSelf.photoBrowser];
                        if ( number== 0) {
                            [weakSelf.photoBrowser closeSelf];
                        }else{
                            [weakSelf.photoBrowser reloadData];
                            
                        }
                    }
                }
            }];
            
            return YES;
        };
        
        _photoBrowser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [_photoBrowser reloadData];
    return _photoBrowser;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mwPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mwPhotos.count) {
        return [self.mwPhotos objectAtIndex:index];
    }
    return nil;
}

-(NSMutableArray*)mwPhotos{
    if (!_mwPhotos) {
        _mwPhotos = [NSMutableArray array];
    }
    [_mwPhotos removeAllObjects];
    for (int i= 0; i < self.sourceArray.count; i++) {
        MWPhoto *imageMW = [MWPhoto photoWithURL:[NSString getImageUrlString:self.sourceArray[i]]];
        [_mwPhotos addObject:imageMW];
    }
    return _mwPhotos;
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
