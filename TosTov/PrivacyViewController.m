//
//  PrivacyViewController.m
//  TosTov
//
//  Created by Charlie on 11/8/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()
@property (nonatomic, strong) UIButton *btnEnglish;
@property (nonatomic, strong) UIButton *btnKhmer;
@property (nonatomic, strong) UILabel *englishTitle;
@property (nonatomic, strong) UILabel *khmerTitle;
@property (nonatomic, strong) UILabel *englishContent;
@property (nonatomic, strong) UILabel *khmerContent;
@property (nonatomic, strong) UILabel *lblKhmer;
@property (nonatomic, strong) UILabel *lblEnglish;
@property (nonatomic, strong) UIView *khLine;
@property (nonatomic, strong) UIView *englishLine;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
    
}

                                        /** Functionality **/

// Show English content
-(void)clickOnEnglish{
    [self.englishTitle setHidden:false];
    [self.englishContent setHidden:false];
    self.lblEnglish.textColor = [UIColor redColor];
    self.englishLine.backgroundColor = [UIColor redColor];
    self.lblKhmer.textColor = [UIColor grayColor];
    self.khLine.backgroundColor = [UIColor grayColor];
}

// Show Khmer content
-(void)clickOnKhmer{
    [self.englishTitle setHidden:true];
    [self.englishContent setHidden:true];
    self.lblEnglish.textColor = [UIColor grayColor];
    self.englishLine.backgroundColor = [UIColor grayColor];
    self.lblKhmer.textColor = [UIColor redColor];
    self.khLine.backgroundColor = [UIColor redColor];
}

// Go back to sign up view
-(void)backToSignUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Get max height of text
- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}

                                        /** View Decoration **/
-(void)addComponents{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add back button
    UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToSignUp)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    // add top background
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 170);
    topView.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovCoverBackground.png"]];
    topImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, 170);
    [topView addSubview:topImage];
    [self.view addSubview:topView];
    
    // add label title Tos Tov
//    UILabel *lblTosTov = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 140) / 2 ,
//                                                                  (topView.frame.size.height-30) / 2, 140, 30)];
//    lblTosTov.textColor = [UIColor whiteColor];
//    lblTosTov.text = @"TOS @ TOV";
//    lblTosTov.font = [UIFont systemFontOfSize:25];
//    //lblTosTov.center = topView.center;
//    //[topView addSubview:lblTosTov];
//    [self.view addSubview:lblTosTov];
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBigLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 175) / 2 ,(topView.frame.size.height-45) / 2, 175, 45);
    [self.view addSubview:tosTovLogo];
    
    
    
    // add khmer button
    self.btnKhmer = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnKhmer.frame = CGRectMake(0, topView.frame.origin.y + topView.frame.size.height,
                                     self.view.bounds.size.width / 2, 30);
    self.khLine = [[UIView alloc]initWithFrame:CGRectMake(0, 28, self.btnKhmer.bounds.size.width, 2)];
    self.khLine.backgroundColor = [UIColor grayColor];
    [self.btnKhmer addSubview: self.khLine];
    self.lblKhmer = [[UILabel alloc]initWithFrame:CGRectMake((self.btnKhmer.frame.size.width-45) / 2,
                                                               5, 45, 20)];
    self.lblKhmer.text = @"Khmer";
    self.lblKhmer.font = [UIFont systemFontOfSize:12];
    self.lblKhmer.textColor = [UIColor grayColor];
    [self.btnKhmer addSubview:self.lblKhmer];
    [self.btnKhmer addTarget:self action:@selector(clickOnKhmer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.btnKhmer];
    
    // add english button
    self.btnEnglish = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnEnglish.frame = CGRectMake(self.btnKhmer.frame.origin.x + self.btnKhmer.frame.size.width,
                                       topView.frame.origin.y + topView.frame.size.height,
                                       self.view.bounds.size.width / 2, 30);
    self.englishLine = [[UIView alloc]initWithFrame:CGRectMake(0, 28, self.btnEnglish.bounds.size.width, 2)];
    self.englishLine.backgroundColor = [UIColor redColor];
    [self.btnEnglish addSubview:self.englishLine];
    self.lblEnglish = [[UILabel alloc]initWithFrame:CGRectMake((self.btnEnglish.frame.size.width-45) / 2,
                                                                 5, 45, 20)];
    self.lblEnglish.text = @"English";
    self.lblEnglish.font = [UIFont systemFontOfSize:12];
    self.lblEnglish.textColor = [UIColor redColor];
    [self.btnEnglish addSubview:self.lblEnglish];
    [self.btnEnglish addTarget:self action:@selector(clickOnEnglish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.btnEnglish];
    
    // add title
    self.englishTitle = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120) / 2,
                                                                self.btnKhmer.frame.origin.y + self.btnKhmer.frame.size.height + 20,
                                                                 120, 20)];
    self.englishTitle.text = @"PRIVACY POLICY";
    self.englishTitle.textColor = [UIColor redColor];
    self.englishTitle.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.englishTitle];
    
    // add content english
    NSString *englishStr = @"The following Privacy Policy explains how we collect, use transfer, disclose and protect your personalitly identifyable information obtained through your application (as defined below). Please review it carefully to make sure you understand our privacy practise. \n\n The Privacy Policy is incoperated as part of our Terms of use. \n This privacy policy cover the following : \n\n Definitions \n Information we collect \n Using the information we collect \n Sharing the information we collect \n Retaining teh infromation we collect \n Security \n Changes to this Privacy Policy \n Acknowledgement and Consent \n Unsubscribe from e-mail database ";
    CGFloat heigthMax = [self measureTextHeight:englishStr constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000.0f) fontSize:10.0f];
    self.englishContent = [[UILabel alloc]initWithFrame:CGRectMake(2,
                                                                   self.englishTitle.frame.origin.y + self.englishTitle.frame.size.height + 20,
                                                                   self.view.bounds.size.width - 4, heigthMax)];
    self.englishContent.text = englishStr;
    self.englishContent.numberOfLines = 0;
    self.englishContent.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.englishContent];
}

@end
