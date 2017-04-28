//
//  ResultTableViewController.m
//  Weather
//
//  Created by Anvei on 16/3/14.
//  Copyright © 2016年 anvei. All rights reserved.
//

#import "ResultTableViewController.h"
#import "AHAttentionCell.h"
#import "NSString+Tool.h"
@interface ResultTableViewController ()

@end

@implementation ResultTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.tableView.backgroundColor = [UIColor lightGrayColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.estimatedRowHeight = 65.f;
        self.tableView.rowHeight = 65.f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"AHAttentionCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:@"resultCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>30) {
         [self.searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AHAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    FindUser * user = self.dataSource[indexPath.row];
    cell.nickNameLabel.text = user.nickName;
    cell.detailLabel.text = user.brief;
    [cell.headImageView sd_setImageWithURL:[NSString getImageUrlString:user.avatar] placeholderImage:DefaultHeadImage];
    cell.attentionBt.hidden = YES;
    cell.rightBottomImageView.hidden = user.isToHao == YES ? NO : YES;
    if (user.isToHao) {
        cell.leftBottomImageView.hidden = NO;
        cell.leftBottomImageView.image =  [UIImage imageNamed:[NSString stringWithFormat:@"icon_user_dlevel%d",user.level.level]];
        cell.rightBottomImageView.image = [UIImage imageNamed:@"icon_user_dhao0"];
    }else{
        cell.leftBottomImageView.hidden = YES;
        cell.rightBottomImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_user_dlevel%d",user.level.level]];
    }
    return cell;
}
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

- (void)cellPressedWithBlock:(closeResultTableBlock)block{
    self.closeBlock = block;
}
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindUser * user = self.dataSource[indexPath.row];
    if (user.userId.length > 0) {
        if (_closeBlock) {
            self.closeBlock(user.userId);
        }
    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
