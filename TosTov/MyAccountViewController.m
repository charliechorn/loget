//
//  MyAccountViewController.m
//  TosTov
//
//  Created by Charlie on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PrivacyViewController.h"
#import "TermViewController.h"

@interface MyAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *accTable;
@property (nonatomic, strong) NSMutableArray *arrContent;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrContent = [NSMutableArray arrayWithObjects:@"Sign Out",@"Term of service",@"Privacy policy",@"Rate the app", nil];
    
    [self addComponents];
    
}

                                            /** Functionality **/




                                            /** View Decoration **/
-(void)addComponents{
    self.accTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,
                                                                 self.view.bounds.size.width,
                                                                 self.view.bounds.size.height - 25)];
    self.accTable.dataSource = self;
    self.accTable.delegate = self;
    [self.view addSubview:self.accTable];
    
    // add footer to table
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    //footerView.backgroundColor = [UIColor redColor];
    UILabel *lblVersion = [[UILabel alloc]initWithFrame:CGRectMake((footerView.frame.size.width/4) - 20,
                                                               15,45,20)];
    lblVersion.text = @"Version";
    lblVersion.font = [UIFont systemFontOfSize:12];
    [footerView addSubview:lblVersion];
    
    UILabel *lblVersionNum = [[UILabel alloc]initWithFrame:CGRectMake((footerView.frame.size.width - footerView.frame.size.width/4)-20,
                                                                   lblVersion.frame.origin.y,45,20)];
    lblVersionNum.text = @"1.1.1";
    lblVersionNum.font = [UIFont systemFontOfSize:12];
    [footerView addSubview:lblVersionNum];
    
    self.accTable.tableFooterView = footerView;
}

                                            // UITableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.accTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"AccountIcon.png"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"InfoIcon.png"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"PolicyIcon.png"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"StarIcon.png"];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [self.arrContent objectAtIndex:indexPath.row];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 44, self.view.bounds.size.width - 30, 1)];
    line.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:line];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NofLogin" object:nil];
    }
    if (indexPath.row==1){
        TermViewController *termVc = [[TermViewController alloc]init];
        termVc.view.frame = self.view.bounds;
        termVc.title = @"TERMS OF SERVICE";
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:termVc];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                               self.view.bounds.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [nav.navigationBar addSubview:line];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        nav.navigationBar.translucent = NO;
        
        [self presentViewController:nav animated:true completion:nil];
    }
    if (indexPath.row==2){
        PrivacyViewController *privacyVc = [[PrivacyViewController alloc]init];
        privacyVc.view.frame = self.view.bounds;
        privacyVc.title = @"PRIVACY POLICY";
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:privacyVc];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                               self.view.bounds.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [nav.navigationBar addSubview:line];
        nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        nav.navigationBar.translucent = NO;
        [self presentViewController:nav animated:true completion:nil];
    }
}

@end
