//
//  AHVideoRecordeCollectionCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//
#import "AHBaseCollectionViewCell.h"
#import "AHPhotoAlbumCell.h"
@interface AHVideoRecordeCollectionCell : AHBaseCollectionViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//详情
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
//删除事件
@property(nonatomic,copy)DeleteSeletedCell deleteSeletedCell;
//位置
@property(nonatomic,assign)NSIndexPath *index;
@end
