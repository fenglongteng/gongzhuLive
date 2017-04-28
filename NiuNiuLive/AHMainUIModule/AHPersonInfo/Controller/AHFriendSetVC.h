//
//  AHFriendSetVC.h
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/24.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseViewController.h"

@interface AHFriendSetVC : AHBaseViewController
-(instancetype)initWithUserId:(NSString*) userId  AndPersonInfo:(AHPersonInfoModel*)infoModel AndSpecialAttention:(BOOL)isSpecialAttention;
@end
