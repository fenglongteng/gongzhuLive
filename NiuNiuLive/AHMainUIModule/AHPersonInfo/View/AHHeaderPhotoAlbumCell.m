//
//  AHHeaderPhotoAlbumCell.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHHeaderPhotoAlbumCell.h"
#import "UIImage+extension.h"
#import "UIView+ST.h"
#import "AHPhotoAlubmVC.h"
#import "CustomCamerButton.h"
#import "MWPhotoBrowser.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "NSString+Tool.h"
#import "NSObject+AHUntil.h"
@interface AHHeaderPhotoAlbumCell()<MWPhotoBrowserDelegate>
//显示全部图片
@property (weak, nonatomic) IBOutlet UIView *showAllPhotoView;
//集合视图是自己头像还是别人的
@property(nonatomic,assign)BOOL isOwn;
/**
 图片数组
 */
@property(nonatomic,strong)NSMutableArray *imageArray;

/**
 照片数量
 */
@property (weak, nonatomic) IBOutlet UILabel *imageNumberLabel;

/**
 *  图片浏览器
 */
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
/**
 *  图片集合
 */
@property (strong, nonatomic) NSMutableArray *mwPhotos;

//图片选择器
@property (strong, nonatomic)CustomCamerButton *customCamerBt;
@end
@implementation AHHeaderPhotoAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 创建一个流式布局管理
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置滚动方向为垂直方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置单元格的最小水平间距
    layout.minimumInteritemSpacing = 8;
    // 设置最小行间间距
    layout.minimumLineSpacing = 8;
    // 设置内边距
    layout.itemSize = CGSizeMake((screenWidth - 21*2-24)/4.0, (screenWidth - 21*2-24)/4.0);
    _imageCollectionView.delegate = self;
    _imageCollectionView.dataSource = self;
    [_imageCollectionView setCollectionViewLayout:layout animated:NO];
    [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (IBAction)bt_showAllPhotoAlbum:(id)sender {
    AHPhotoAlubmVC *photoAlubmVC= [[AHPhotoAlubmVC alloc]initWithMy:_isOwn AndSourceArray:_imageArray];
    UINavigationController *nav = [AppDelegate getNavigationTopController].navigationController;
    [nav pushViewController:photoAlubmVC animated:YES];
}

#pragma mark-----UICollectionViewDelegate--------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_isOwn) {
        return 8;
    }else{
        return self.imageArray.count;
    }
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [cell.contentView viewWithTag:200];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (screenWidth - 21*2-24)/4.0, (screenWidth - 21*2-24)/4.0)];
        imageView.tag = 200;
        [imageView addCornerRadius:10];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:imageView];
    }
    
    if (_isOwn) {
        //有个站位加图片的cell
        if (indexPath.row <= _imageArray.count - 1) {
            if (self.imageArray.count == 0) {
                //添加图片的cell
                if (indexPath.row == 0) {
                    UIImage *image = [UIImage imageNamed:@"btn_me_xc_add.png"];
                    imageView.image = image;
                }else{
                    //如果不写这个代码那个cell在复用的时候还是有子视图
                    for (UIView *view in cell.contentView.subviews) {
                        [view removeFromSuperview];
                    }
                }
            }else{
                if (indexPath.row<7) {
                    NSString  *imageUrlString =[NSString stringWithFormat:@"%@%@",[AHPersonInfoManager manager].getInfoModel.webApiUserGetAvatarURL,self.imageArray[indexPath.row]];
                    NSURL *url = [NSURL URLWithString:imageUrlString];
                    [imageView sd_setImageWithURL:url placeholderImage:DefaultHeadImage];
                }else{
                    //添加图片的cell
                    UIImage *image = [UIImage imageNamed:@"btn_me_xc_add.png"];
                    imageView.image = image;
                }
                
            }
        }else if(indexPath.row == _imageArray.count){
            //添加图片的cell
            UIImage *image = [UIImage imageNamed:@"btn_me_xc_add.png"];
            imageView.image = image;
        }else{
            //如果不写这个代码那个cell在复用的时候还是有子视图
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        
    }else{
        NSString  *imageUrlString =[NSString stringWithFormat:@"%@%@",[AHPersonInfoManager manager].getInfoModel.webApiUserGetAvatarURL,self.imageArray[indexPath.row]];
        NSURL *url = [NSURL URLWithString:imageUrlString];
        [imageView sd_setImageWithURL:url placeholderImage:DefaultHeadImage];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isOwn) {
        //有个站位加图片的cell
        if (indexPath.row <= _imageArray.count - 1 ){
            if (self.imageArray.count == 0) {
                if (indexPath.row == 0) {
                    //添加头像
                    WeakSelf;
                    _customCamerBt = [[CustomCamerButton alloc]initAddTargetVC:[AppDelegate getNavigationTopController] AndSeltedCompleteHandle:^(UIImage *image) {
                        [weakSelf uploadImage:image andUser_id:[AHPersonInfoManager manager].getInfoModel.userId];
                    }];
                    [_customCamerBt showImagePicker];
                }else{
           
                }
            }else{
                if (indexPath.row<7) {
                    //显示大图
                    [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
                    [[AppDelegate getNavigationTopController] presentViewController:self.photoBrowser animated:NO completion:nil];
                }else{
                    //添加头像
                    WeakSelf;
                    _customCamerBt = [[CustomCamerButton alloc]initAddTargetVC:[AppDelegate getNavigationTopController] AndSeltedCompleteHandle:^(UIImage *image) {
                        [weakSelf uploadImage:image andUser_id:[AHPersonInfoManager manager].getInfoModel.userId];
                    }];
                    [_customCamerBt showImagePicker];
                }
                
            }
        }else if(indexPath.row == _imageArray.count){
            //添加头像
            WeakSelf;
            _customCamerBt = [[CustomCamerButton alloc]initAddTargetVC:[AppDelegate getNavigationTopController] AndSeltedCompleteHandle:^(UIImage *image) {
                [weakSelf uploadImage:image andUser_id:[AHPersonInfoManager manager].getInfoModel.userId];
            }];
            [_customCamerBt showImagePicker];
        }
        
    }else{
        //显示大图
        [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
        [[AppDelegate getNavigationTopController] presentViewController:self.photoBrowser animated:NO completion:nil];
    }
}



-(void)setImageArray:(NSArray*)imageArray isOwn:(BOOL)isOwn{
    _isOwn = isOwn;
    _imageArray = [imageArray mutableCopy];
    if (_isOwn) {
        //有个站位加图片的cell
        if (_imageArray.count +1 <5) {
            _colletionViewHeightContraint.constant = (screenWidth - 21*2-24)/4.0;
        }else{
            _colletionViewHeightContraint.constant = (screenWidth - 21*2-24)/4.0*2 + 8;
        }
    }else{
        if (!(_imageArray.count >0) ) {
            _colletionViewHeightContraint.constant = 0;
        }else if (_imageArray.count<5) {
            _colletionViewHeightContraint.constant = (screenWidth - 21*2-24)/4.0;
        }else{
            _colletionViewHeightContraint.constant = (screenWidth - 21*2-24)/4.0*2 + 8;
        }
    }
    self.imageNumberLabel.text = [NSString stringWithFormat:@"%lu张照片",(unsigned long)imageArray.count];
    [self.imageCollectionView reloadData];
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
        _photoBrowser.isOwn = _isOwn;
          WeakSelf;
        _photoBrowser.deletePhotoBlock = ^(id info){
            NSString *imageString = info;
            UsersRemoveAvatarRequest *removeRequest = [[UsersRemoveAvatarRequest alloc]init];
            removeRequest.avatarName = imageString;
            [[AHTcpApi shareInstance]requsetMessage:removeRequest classSite:UsersClassName completion:^(id response, NSString *error) {
                UsersRemoveAvatarResponse *removeResponse = response;
                if (removeResponse.result == 0) {
                    if (weakSelf.isOwn) {
                        AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
                        NSMutableArray *array = [infoModel.avatarArray mutableCopy];
                        [array removeObject:imageString];
                        infoModel.avatarArray = array;
                        [[AHPersonInfoManager manager] setInfoModel:infoModel];
                        weakSelf.imageArray = array;
                        [weakSelf.imageCollectionView reloadData];
                        NSInteger number = [weakSelf numberOfPhotosInPhotoBrowser:weakSelf.photoBrowser];
                        if ( number== 0) {
                            [weakSelf.photoBrowser closeSelf];
                        }else{
                             [weakSelf.photoBrowser reloadData];

                        }
                    }
                }else{
                    
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
    if (self.imageArray.count>0) {
        for (int i= 0; i < self.imageArray.count; i++) {
            //        LTImageModel * model = self.imageArray[i];
            //        MWPhoto *imageMW = [MWPhoto photoWithURL:[NSURL URLWithString:model.pic]];
            MWPhoto *imageMW = [MWPhoto photoWithURL:[NSString getImageUrlString:self.imageArray[i]]];
            [_mwPhotos addObject:imageMW];
        }
    }
    
    return _mwPhotos;
}

#pragma mark  ---上传图片
//上传图片
-(void)uploadImage:(UIImage*)image andUser_id:(NSString*)user_id{
    //1.创建一个名为mgr的请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain",nil];
    //2.上传文字时用到的拼接请求参数(如果只传图片，可不要此段）
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//创建一个名为params的可变字典
    params[@"user_id"] = user_id;//通过服务器给定的Key上传数据
    
    //3.发送请求
    [mgr POST:[AHPersonInfoManager manager].getInfoModel.webApiUserUploadAvatarURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //单张图片
        NSData *data = UIImageJPEGRepresentation(image, 1.0);//将UIImage转为NSData，1.0表示不压缩图片质量。
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [responseObject yy_modelToJSONObject];
        NSString   *imageString = dic[@"avatar"];
        AHPersonInfoModel *infoModel = [AHPersonInfoManager manager].getInfoModel;
        NSMutableArray *array = [infoModel.avatarArray mutableCopy];
        if (imageString.length>0) {
            [array insertObject:imageString atIndex:0];
            [self.imageArray insertObject:imageString atIndex:0];
              self.imageNumberLabel.text = [NSString stringWithFormat:@"%lu张照片",(unsigned long)+_imageArray.count];
            if (!(infoModel.avatarURL.length > 0)) {
                [self bt_setHead:imageString];
            }
        }
        infoModel.avatarArray = array;
        [[AHPersonInfoManager manager] setInfoModel:infoModel];
        //刷新列表
        [[NSNotificationCenter defaultCenter]postNotificationName:RefreshMeAccountViewController object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您上传片失败啦！" cancelBtnTitle:@"知道了" cancelAction:nil];
        [alertView showAlert];
    }];
}


//设置为头像
-(void)bt_setHead:(NSString*)imageUrlString{
    UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
    editeInfoRequst.avatar = imageUrlString;
    [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
    [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
        UsersAlterInfoResponse *editeRespose = response;
        if (editeRespose.result == 0 ) {
            AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
            infoModel.avatarURL = imageUrlString;
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您的头像修改成功啦！" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
            //刷新列表
            [[NSNotificationCenter defaultCenter]postNotificationName:RefreshMeAccountViewController object:nil];
        }else{
            AHAlertView *alertView = [[AHAlertView alloc]initAlertViewReminderTitle:@"温馨提示" title:@"您的头像修改失败啦！" cancelBtnTitle:@"知道了" cancelAction:nil];
            [alertView showAlert];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
