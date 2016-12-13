//
//  HelpViewController.m
//  TosTov
//
//  Created by Pichzz on 11/3/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpDetailViewController.h"

@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *helpTable;
@property (nonatomic, strong) NSMutableArray *arrContent;
@property (nonatomic ,strong) UIButton *btnCall;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrContent = [NSMutableArray arrayWithObjects:@"Wing",@"TOS-TOV",@"TOS-SEND",@"TOV-FOOD",@"OTHER", nil];
    [self addComponents];
}


                                        /** Functionality **/



                                        /** View Decoration **/
-(void)addComponents{
    self.helpTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,
                                                                 self.view.bounds.size.width,
                                                                 self.view.bounds.size.height - 25)];
    self.helpTable.dataSource = self;
    self.helpTable.delegate = self;
    [self.view addSubview:self.helpTable];
    
    self.btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCall.frame = CGRectMake(15, 10, self.view.bounds.size.width - 30, 40);
    self.btnCall.layer.borderColor = [UIColor redColor].CGColor;
    self.btnCall.layer.borderWidth = 2;
    self.btnCall.layer.cornerRadius = 5;
    UILabel *lblCall = [[UILabel alloc]initWithFrame:CGRectMake((self.btnCall.frame.size.width - 90)/2,
                                                               10,90,20)];
    lblCall.text = @"CALL SUPPORT";
    lblCall.font = [UIFont systemFontOfSize:12];
    lblCall.textColor = [UIColor redColor];
    [self.btnCall addSubview:lblCall];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    [footerView addSubview:self.btnCall];
    
    self.helpTable.tableFooterView = footerView;

}

                                        // UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrContent.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.helpTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"WingIcon.png"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"TosTovIcon.png"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"TosSendIcon.png"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"TovFoodIcon.png"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"OtherIcon.png"];
            break;
            
        default:
            break;
    }
    //cell.imageView.image = [UIImage imageNamed:@"UserLogo.png"];
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
    HelpDetailViewController *helpDetail = [[HelpDetailViewController alloc]init];
    helpDetail.view.frame = self.view.bounds;
    helpDetail.title = @"HOW CAN WE HELP YOU?";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:helpDetail];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:true completion:nil];
}


@end
