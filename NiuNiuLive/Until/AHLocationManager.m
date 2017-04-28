//
//  LBLocationManager.m
//  Weather
//
//  Created by luobaoyin on 16/2/29.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "AHLocationManager.h"
#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"
#import "AHDeviceInfo.h"
#import "AHPersonInfoManager.h"
#import "AHAlertView.h"
#import "NSObject+AHUntil.h"
static AHLocationManager *manage;
@interface AHLocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
}
@end

@implementation AHLocationManager

+(AHLocationManager *) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[AHLocationManager alloc] init];
    });
    return manage;
}

-(instancetype)init{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        //当前系统是否大于等于ios 8
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestAlwaysAuthorization]; // 永久授权
            [_locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        //设置代理
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 3000.0;
        _locationManager.distanceFilter = distance;
    }
    return self;
}

- (void)startLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusDenied){
        [self showMessage];
    }else{
        //关闭定位
        [_locationManager stopUpdatingLocation];
        //开始定位
        [_locationManager startUpdatingLocation];
    }
}

- (void)firstStartLocation{
    //开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationIsOpen{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //程序使用中定位
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
         [self startLocation];
    }
    //用户拒绝定位
    if (status == kCLAuthorizationStatusDenied) {
        [self showMessage];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //当前时间和上次时间必须大于2分钟才能再次定位
    NSTimeInterval timeInterval = -[self.lastTime timeIntervalSinceNow];
    if (timeInterval < 120 &&  self.lastTime) {
        return;
    }
    //这一段本来是在判断上面修改到下面来了
    if (self.locationStartBlock) {
        self.locationStartBlock(@"");
    }
    self.lastTime = [NSDate date];
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    //设置经纬度
    self.longitude = coordinate.longitude;
    self.latitude = coordinate.latitude;
    //通过地理反编译出实际地址
    //获取当前所在的城市名
    CLLocation *currentLocation = [locations lastObject];
    [self setUpCLLocation:currentLocation];
    [self setUpDetailString:[NSString stringWithFormat:@"%@,%@",self.provinces,self.city]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    AHWeakSelf(self);
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //市
             weakself.city = placemark.locality;
             //区
             weakself.subLocality = placemark.subLocality;
             //详细位置
             weakself.detailLocation = placemark.addressDictionary[@"FormattedAddressLines"];
             //省
             weakself.provinces = placemark.addressDictionary[@"State"];
             //subThoroughfare街道号数 如99号  Name街道名称 如天益街（不包含号） FormattedAddressLines全部详情地址
             //Street包含号数
             NSString *provincesAndCity = [NSString stringWithFormat:@"%@%@",weakself.provinces,weakself.city];
             if (self.locationSuccBlock) {
                 self.locationSuccBlock(provincesAndCity);
             }
         }else if (error == nil && [array count] == 0)
         {
             if (self.locationFailBlock) {
                 self.locationFailBlock(@"获取地址信息失败");
             }
         }else if (error != nil)
         {
             [self tellLocationFailWithError:error];
         }
     }];
}

- (void)showMessage{
    AHAlertView *alertView = [[AHAlertView alloc]initSetAlertViewTitle:@"温馨提示" detailString:@"打开定位可以和附近的好友一起愉快的聊天哟" AndLeftBt:@"取消" AndRight:@"设置" cancelAction:^{
        
    } settingAction:^{
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];

    [alertView showAlert];
}

-(void)showMesssageAlertView{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //程序使用中定位
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self startLocation];
    }
    //用户拒绝定位
    if (status == kCLAuthorizationStatusDenied) {
        AHAlertView *alertView = [[AHAlertView alloc]initSetAlertViewTitle:@"温馨提示" detailString:@"打开定位可以和附近的好友一起愉快的聊天哟" AndLeftBt:@"取消" AndRight:@"设置" cancelAction:^{
            
        } settingAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertView showAlert];
    }
}

/**
 定位失败

 @param manager 定位manager
 @param error   错误信息
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self tellLocationFailWithError:error];
}

/**
 告诉调用者定位失败原因

 @param error 系统错误原因
 */
- (void)tellLocationFailWithError:(NSError *)error{
    NSString *errorStr;
    if(error.code == kCLErrorLocationUnknown)
    {
        errorStr = @"无法获取当前位置!";
    }
    else if(error.code == kCLErrorNetwork)
    {
        errorStr = @"网络无法使用!";
    }
    else if(error.code == kCLErrorDenied)
    {
        errorStr = @"关闭定位服务!";
    }
    if (self.locationFailBlock) {
        self.locationFailBlock(errorStr);
    }
}

- (void)cancelLocation{
    [_locationManager stopUpdatingLocation];
}

/**
 *  根据当前设备使用语言补全定位信息
 *
 *  @param type 区或者县 1：区 0：县
 *
 *  @return 补全信息
 */
- (NSString *)completionLocationInfoWithType:(NSInteger)type{
    NSString *currentLanguage = [AHDeviceInfo currentLanguage];
    if ([currentLanguage isEqualToString:@"zh-Hans"]
        || [currentLanguage isEqualToString:@"zh-Hant"]
        || [currentLanguage isEqualToString:@"zh-HK"]
        || [currentLanguage isEqualToString:@"zh-TW"]
        || [currentLanguage isEqualToString:@"zh-Hans-CN"]
        || [currentLanguage isEqualToString:@"zh-Hant-CN"]) {
        return @"";
    }
    return type > 0 ? @"qu" : @"xian";
}


/**
 *  根据当前设备使用语言补全定位信息
 *  @return 补全信息
 */
- (NSString *)completionLocationCityInfoWithType{
    NSString *currentLanguage = [AHDeviceInfo currentLanguage];
    if ([currentLanguage isEqualToString:@"zh-Hans"]
        || [currentLanguage isEqualToString:@"zh-Hant"]
        || [currentLanguage isEqualToString:@"zh-HK"]
        || [currentLanguage isEqualToString:@"zh-TW"]
        || [currentLanguage isEqualToString:@"zh-Hans-CN"]
        || [currentLanguage isEqualToString:@"zh-Hant-CN"]) {
        return @"";
    }
    return @"shi";
}

//网络传送更新坐标
-(void)setUpCLLocation:(CLLocation*)location{
    double latitude = location.coordinate.latitude;
    double  longitude = location.coordinate.longitude;
    UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
    editeInfoRequst.longitude = longitude;
    editeInfoRequst.latitude = latitude;
      [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
    [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
        UsersAlterInfoResponse *editeRespose = response;
        if (editeRespose.result == 0 ) {
            AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager]getInfoModel];
            infoModel.latitude = latitude;
            infoModel.longitude = longitude;
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
        }
    }];
}

//上传位置
-(void)setUpDetailString:(NSString*)detailString{
    //网络传送地址
    UsersAlterInfoRequest *editeInfoRequst = [[UsersAlterInfoRequest alloc]init];
    editeInfoRequst.cityName = detailString;
      [NSObject getFieldOfUsersAlterInfoRequest:editeInfoRequst isEditGender:NO];
    [[AHTcpApi shareInstance]requsetMessage:editeInfoRequst classSite:@"Users" completion:^(id response, NSString *error) {
        UsersAlterInfoResponse *editeRespose = response;
        if (editeRespose.result == 0 ) {
            AHPersonInfoModel *infoModel = [[AHPersonInfoManager manager] getInfoModel];
            infoModel.cityName = detailString;
            [[AHPersonInfoManager manager]setInfoModel:infoModel];
        }
    }];

}

@end
