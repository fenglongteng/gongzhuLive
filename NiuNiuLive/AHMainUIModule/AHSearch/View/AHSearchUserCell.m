//
//  AHSearchUserCell.m
//  NiuNiuLive
//
//  Created by anhui on 17/3/27.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHSearchUserCell.h"
#import "AHLocationManager.h"
#import "NSString+Tool.h"
@interface AHSearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *locationLb;
@property (weak, nonatomic) IBOutlet UILabel *meiLiLb;//魅力
@property (weak, nonatomic) IBOutlet UILabel *fensiLb;//粉丝
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@end

@implementation AHSearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.locationView.layer.cornerRadius = self.locationView.height *0.5;
    self.layer.cornerRadius = 8.0;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.userImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.userImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.userImageView.layer.mask = maskLayer;
}

- (void)setModel:(FindUser *)model{
    _model = model;
    self.userNameLb.text = model.nickName;
    self.fensiLb.text = [NSString stringWithFormat:@"%lld",model.likeUserNumber];
    self.meiLiLb.text = [NSString stringWithFormat:@"%lld",model.charmValue];
    self.addressLb.text = model.cityName;
    double longF = [AHLocationManager sharedInstance].longitude;
    double latF  = [AHLocationManager sharedInstance].latitude;
    double longF1 = model.longitude;
    double latF1 = model.latitude;
    if (longF1 > 0 && latF1 > 0) {
        double distance = [self distanceBetweenOrderBy:latF :latF1 :longF :longF1];
        if (distance > 999) {
            double dis =  distance * 1000;
            self.locationLb.text = [NSString stringWithFormat:@"%.0fKm",dis];
        }else{
            self.locationLb.text = [NSString stringWithFormat:@"%.0fM",distance];;
        }
    }else{
        self.locationLb.text = @"null";
    }
     [self.userImageView sd_setImageWithURL:[NSString getImageUrlString:model.avatar] placeholderImage:[UIImage imageNamed:@"image_user_def"] completed:nil];
}

- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

@end
