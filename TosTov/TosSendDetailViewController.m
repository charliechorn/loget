//
//  TosSendDetailViewController.m
//  TosTov
//
//  Created by Charlie on 12/19/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "TosSendDetailViewController.h"

@interface TosSendDetailViewController ()

@property (nonatomic, strong) UITextField *txtWeightSize;
@property (nonatomic, strong) UITextField *txtUnit;
@property (nonatomic, strong) UITextField *txtDescription;
@property (nonatomic, strong) UITextField *txtReceiverPhone;
@property (nonatomic, strong) UITextField *txtRefCode;
@property (nonatomic, strong) UIImageView *imgInsurance;
@property (nonatomic, strong) UIImageView *imgPrepaid;
@property (nonatomic, strong) UIImageView *imgPostPaid;


@end

@implementation TosSendDetailViewController{
    bool isInsurance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isInsurance = false;
    [self addComponents];
}



                                        /** View Decoratoin **/
-(void)addComponents{
    
    self.title = @"TOS SEND";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // add label deliver details
    UILabel *deliverDetails = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 25)];
    deliverDetails.text = @"Deliver Details";
    
    [self.view addSubview:deliverDetails];
    
    // add item image
    UIImageView *itemImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ItemIcon.png"]];
    itemImage.frame = CGRectMake(5, 50, 30, 34);
    [self.view addSubview:itemImage];
    
    // add textfield weight/size
    self.txtWeightSize = [[UITextField alloc]initWithFrame:CGRectMake(40, 50, self.view.bounds.size.width - 80, 30)];
    [self setTextFieldAttr:self.txtWeightSize withFont:13 withPlaceHolder:@"Weight/Size*"];
    [self.view addSubview:self.txtWeightSize];
    
    // add line
    [self.view addSubview:[self addLineWithTextfield:self.txtWeightSize]];
    
    // add textfield unit
    self.txtUnit = [[UITextField alloc]initWithFrame:CGRectMake(self.txtWeightSize.frame.origin.x, self.txtWeightSize.frame.origin.y + self.txtWeightSize.bounds.size.height + 5, self.txtWeightSize.bounds.size.width, 30)];
    [self setTextFieldAttr:self.txtUnit withFont:13 withPlaceHolder:@"Unit"];
    [self.view addSubview:self.txtUnit];
    
    // add line
    [self.view addSubview:[self addLineWithTextfield:self.txtUnit]];
    
    // add textfield description
    self.txtDescription = [[UITextField alloc]initWithFrame:CGRectMake(self.txtUnit.frame.origin.x, self.txtUnit.frame.origin.y + self.txtUnit.bounds.size.height + 5, self.txtUnit.bounds.size.width, 30)];
    [self setTextFieldAttr:self.txtDescription withFont:13 withPlaceHolder:@"Description"];
    [self.view addSubview:self.txtDescription];
    
    // add line
    [self.view addSubview:[self addLineWithTextfield:self.txtDescription]];
    
    // add image receiver
    UIImageView *imgReceiver = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReceiverIcon.png"]];
    imgReceiver.frame = CGRectMake(5, self.txtDescription.frame.origin.y + self.txtDescription.bounds.size.height + 5, 30, 30);
    [self.view addSubview:imgReceiver];
    
    // add textfield receiver's phone
    self.txtReceiverPhone = [[UITextField alloc]initWithFrame:CGRectMake(self.txtDescription.frame.origin.x, self.txtDescription.frame.origin.y + self.txtDescription.bounds.size.height + 5, self.txtDescription.bounds.size.width, 30)];
    [self setTextFieldAttr:self.txtReceiverPhone withFont:13 withPlaceHolder:@"Receiver's Phone #"];
    [self.view addSubview:self.txtReceiverPhone];
    
    // add line
    [self.view addSubview:[self addLineWithTextfield:self.txtReceiverPhone]];
    
    // add textfield ref code
    self.txtRefCode = [[UITextField alloc]initWithFrame:CGRectMake(self.txtReceiverPhone.frame.origin.x, self.txtReceiverPhone.frame.origin.y + self.txtReceiverPhone.bounds.size.height + 5, self.txtReceiverPhone.bounds.size.width, 30)];
    [self setTextFieldAttr:self.txtRefCode withFont:13 withPlaceHolder:@"Ref. Code"];
    [self.view addSubview:self.txtRefCode];
    
    // add line
    [self.view addSubview:[self addLineWithTextfield:self.txtRefCode]];
    
    // add bullet insurance
    UIImageView *bulletLogoInsurance = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BulletIcon.png"]];
    bulletLogoInsurance.frame = CGRectMake(15, self.txtRefCode.frame.origin.y + self.txtRefCode.bounds.size.height + 20, 15,15);
    bulletLogoInsurance.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bulletLogoInsurance];
    
    // add label insurance
    UILabel *lblInsurance = [[UILabel alloc]initWithFrame:CGRectMake(self.txtRefCode.frame.origin.x, bulletLogoInsurance.frame.origin.y, 100, 15)];
    lblInsurance.text = @"Insurance";
    lblInsurance.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lblInsurance];
    
    
    CGFloat sectionSpace = 50;
    if (IS_IPHONE_6) {
        sectionSpace = 90;
    }
    if (IS_IPHONE_6P) {
        sectionSpace = 140;
    }
    // add image payment
    UIImageView *imgPayment = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PayIcon.png"]];
    imgPayment.frame = CGRectMake(5, bulletLogoInsurance.frame.origin.y + 15 + sectionSpace, 35, 20);
    [self.view addSubview:imgPayment];
    
    // add label payment method
    UILabel *lblPaymentMethod = [[UILabel alloc]initWithFrame:CGRectMake(lblInsurance.frame.origin.x, imgPayment.frame.origin.y, 200, 25)];
    lblPaymentMethod.text = @"Payment Method";
    
    [self.view addSubview:lblPaymentMethod];
    
    // add bullet pre-paid
    self.imgPrepaid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BulletIcon.png"]];
    self.imgPrepaid.frame = CGRectMake(15, imgPayment.frame.origin.y + imgPayment.bounds.size.height + 20, 15,15);
    self.imgPrepaid.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imgPrepaid];
    
    // add label pre-paid
    UILabel *lblPrePaid = [[UILabel alloc]initWithFrame:CGRectMake(lblPaymentMethod.frame.origin.x, self.imgPrepaid.frame.origin.y, 100, 15)];
    lblPrePaid.text = @"Pre-Paid";
    lblPrePaid.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lblPrePaid];
    
    // add bullet post-paid
    self.imgPostPaid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BulletIcon.png"]];
    self.imgPostPaid.frame = CGRectMake(15, self.imgPrepaid.frame.origin.y + self.imgPrepaid.bounds.size.height + 20, 15,15);
    self.imgPostPaid.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imgPostPaid];
    
    // add label post-paid
    UILabel *lblPostPaid = [[UILabel alloc]initWithFrame:CGRectMake(lblPaymentMethod.frame.origin.x, self.imgPostPaid.frame.origin.y, 100, 15)];
    lblPostPaid.text = @"Post-Paid";
    lblPostPaid.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lblPostPaid];
    
    // add button next
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(0, self.view.bounds.size.height - 94, self.view.bounds.size.width, 30);
    btnNext.backgroundColor = [UIColor greenColor];
    
    UILabel *lblNext = [[UILabel alloc]initWithFrame:CGRectMake((btnNext.bounds.size.width-15) / 2,
                                                               5, 15, 20)];
    lblNext.text = @"NEXT";
    lblNext.font = [UIFont systemFontOfSize:12];
    lblNext.textColor = [UIColor whiteColor];
    
    btnNext.layer.borderWidth = 1;
    btnNext.layer.borderColor = [UIColor blackColor].CGColor;
    [btnNext addSubview:lblNext];
    
    [self.view addSubview:btnNext];
    
}


-(UIView *) addLineWithTextfield : (UITextField *)txt{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(txt.frame.origin.x, txt.frame.origin.y + txt.bounds.size.height + 1, txt.bounds.size.width, 1)];
    line.backgroundColor = [UIColor blackColor];
    return line;
}

-(void)setTextFieldAttr : (UITextField *)txt withFont:(int)size withPlaceHolder:(NSString *)str{
    txt.font = [UIFont systemFontOfSize:size];
    txt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
}
-(void)checkIsInsurance{
    
}


@end
