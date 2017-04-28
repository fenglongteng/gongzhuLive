//
//  homeMainCell.m
//  NiuNiuLive
//
//  Created by Zhangwenmin on 17/3/17.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "homeMainCell.h"
#import "Users.pbobjc.h"
#import "Rooms.pbobjc.h"
#import "UIImageView+WebCache.h"
#import "NSString+Tool.h"
#import "AHLocationManager.h"

@implementation homeMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width / 2.0;
    CAGradientLayer * mainLayer = [CAGradientLayer layer];
    mainLayer.frame = CGRectMake(0, 0, self.sentimentLbl.frame.size.width, 25);
    mainLayer.colors = @[(__bridge id)[UIColor colorWithRed:71/255.0 green:22/255.0 blue:98/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:204/255.0 green:61/255.0 blue:211/255.0 alpha:1].CGColor];
    mainLayer.cornerRadius = 12.5;
    mainLayer.startPoint = CGPointMake(0, 1);
    mainLayer.endPoint = CGPointMake(1, 1);
    [self.sentimentLbl.layer addSublayer:mainLayer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHomeCell:(Room *)room{
    if (self.isLocation == YES) {
        self.locationView.hidden = NO;
        double longF = [AHLocationManager sharedInstance].longitude;
        double latF  = [AHLocationManager sharedInstance].latitude;
        double longF1 = room.longitude;
        double latF1 = room.latitude;
        if (longF1 > 0 && latF1 > 0) {
            double distance = [self distanceBetweenOrderBy:latF :latF1 :longF :longF1];
            if (distance > 999) {
                double dis =  distance * 1000;
                self.locatDisanceLb.text = [NSString stringWithFormat:@"%.0fKm",dis];
            }else{
                self.locatDisanceLb.text = [NSString stringWithFormat:@"%.0fM",distance];;
            }
        }else{
            self.locatDisanceLb.text = @"null";
        }
    }else{
        self.locationView.hidden = YES;
    }
    self.nameLbl.text = room.nickName;
    if (room.cityName.length > 0) {
        self.cityLabel.text = room.cityName;
    }else{
        self.cityLabel.text = @"未设置";
    }
    NSURL *headerImageUrl = [NSString getImageUrlString:room.avatar];
    [self.headImage sd_setImageWithURL:headerImageUrl placeholderImage:[UIImage imageNamed:@"logo_500.jpg"]];
    [self.backImage sd_setImageWithURL:headerImageUrl placeholderImage:[UIImage imageNamed:@"pokersquare.jpg"]];
    self.labelText.text = room.brief;
    if (room.isLiving == YES) {
        self.InGame.image = [UIImage imageNamed:@"icon_home_zbzbz"];
    }else if(room.isGaming == YES){
        self.InGame.image = [UIImage imageNamed:@"icon_home_zbyxz"];
    }
    self.sentimentLbl.text = [NSString stringWithFormat:@"欢乐牛牛 %lld人气",room.audienceTotalCount];
   
    
}
//根据经纬度计算距离
- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

@end
