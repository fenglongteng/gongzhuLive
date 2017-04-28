//
//  ResultTableViewController.h
//  Weather
//
//  Created by Anvei on 16/3/14.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closeResultTableBlock)(NSString * userid);

@interface ResultTableViewController : UITableViewController
@property(nonatomic,strong)UISearchBar *searchBar;
//数据源
@property(nonatomic,copy)NSMutableArray * dataSource;
//cell被点击时调用
@property(nonatomic,copy) closeResultTableBlock closeBlock;

- (void)cellPressedWithBlock:(closeResultTableBlock)block;

@end
