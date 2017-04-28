//
//  AHPhotoAlbumCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseCollectionViewCell.h"
typedef void (^DeleteSeletedCell)(NSIndexPath*);

@interface AHPhotoAlbumCell : AHBaseCollectionViewCell
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
//删除事件
@property(nonatomic,copy)DeleteSeletedCell deleteSeletedCell;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//位置
@property(nonatomic,strong)NSIndexPath *index;
@end
