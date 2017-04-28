//
//  AHBaseTableViewController.m
//  NiuNiuLive
//
//  Created by ComAnvei on 17/3/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHBaseTableViewController.h"

@interface AHBaseTableViewController ()

@end

@implementation AHBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xecedef);
    self.view.frame = [UIScreen mainScreen].bounds;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.automaticallyAdjustsScrollViewInsets = YES;
    //消除导航栏黑线
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}


- (void)hideleftBarButtonItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title =  @"";
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setRightButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIBarButtonItem *rigthBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rigthBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rigthBarbtnItem;
}

//设置右边的导航按钮 （文字+颜色）
- (void)setRightButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action{
    UIBarButtonItem *rigthBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rigthBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, color,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rigthBarbtnItem;
}

- (void)setRightButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action{
    
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *lightImage = [UIImage imageNamed:highlightImageStr];
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rigthBtn setImage:image forState:UIControlStateNormal];
    [rigthBtn setImage:lightImage forState:UIControlStateHighlighted];
    rigthBtn.frame = (CGRect ){.size= {image.size.width,image.size.height}};
    //    [rigthBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -image.size.width+10, 0, 10)];
    [rigthBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
}

- (void)setLeftButtonBarItemTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *leftBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [leftBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBarbtnItem;
}

//设置左边的导航按钮 （文字+颜色）
- (void)setLeftButtonBarItemTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action{
    UIBarButtonItem *leftBarbtnItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [leftBarbtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, color,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBarbtnItem;
}

- (void)setLeftButtonBarItemImage:(NSString *)imageStr highlightImage:(NSString *)highlightImageStr target:(id)target action:(SEL)action{
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *lightImage = [UIImage imageNamed:highlightImageStr];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn setImage:lightImage forState:UIControlStateHighlighted];
    leftBtn.frame = (CGRect ){.size= {image.size.width,image.size.height}};
    //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -image.size.width+10, 0, 10)];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

-(void)setHoldTitle:(NSString*)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
}


-(void)setTitleView:(UIView *)titleView{
    self.navigationItem.titleView = titleView;
}

-(void)setBarTintColor:(UIColor*)color{
    [self.navigationController.navigationBar setBarTintColor:color];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
