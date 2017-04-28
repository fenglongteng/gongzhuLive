//
//  LBLocationManager.h
//  Weather
//
//  Created by luobaoyin on 16/2/29.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

typedef void(^locationBlock)(NSString *location); //定位成功执行的逻辑

@interface AHLocationManager : NSObject

/**
 *  定位成功执行
 */
@property (nonatomic,copy) locationBlock locationSuccBlock;

/**
 *  定位失败
 */
@property (nonatomic,copy) locationBlock locationFailBlock;

/**
 *  开始定位
 */
@property (nonatomic,copy) locationBlock locationStartBlock;

/**
 *  最后一次定位时间
 */
@property (nonatomic,strong) NSDate *lastTime;

/**
 *  经度
 */
@property (nonatomic,assign) float longitude;

/**
 *  纬度
 */
@property (nonatomic,assign) float latitude;

//省
@property(nonatomic,strong)NSString *provinces;

//市： 城市
@property(nonatomic,strong)NSString *city;

//区
@property(nonatomic,strong)NSString *subLocality;

//全部信息  可具体到街道
@property(nonatomic,strong)NSString *detailLocation;

/**
 *  单例
 *
 *  @return 定位管理
 */
+(AHLocationManager *) sharedInstance;

/**
 *  第一次启动定位
 */
- (void)firstStartLocation;

/**
 *  定位是否已经开启
 *
 */
- (void)locationIsOpen;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  关闭定位
 */
- (void)cancelLocation;

//打开定位设置alert
-(void)showMesssageAlertView;
@end
