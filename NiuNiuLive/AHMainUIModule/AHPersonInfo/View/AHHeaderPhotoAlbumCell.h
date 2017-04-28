//
//  AHHeaderPhotoAlbumCell.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/20.
//  Copyright © 2017年 AH. All rights reserved.
//
#import "AHBaseTableViewCell.h"
//换行
#define HQNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

//将字符串编码
#define HQEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]
@interface AHHeaderPhotoAlbumCell : AHBaseTableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
//头像集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
//集合视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewHeightContraint;
//设置图片数组，和当前是否是自己的头像
-(void)setImageArray:(NSArray*)imageArray isOwn:(BOOL)isOwn;
@end
