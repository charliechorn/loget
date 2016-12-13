//
//  PasscodeViewController.m
//  TosTov
//
//  Created by Charlie on 11/4/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "PasscodeViewController.h"
#import "NewPasswordViewController.h"
#import "Reachability.h"
#import "MyManager.h"
#import "WSSignUp.h"

@interface PasscodeViewController ()

@property (nonatomic, strong) UITextField *txtPasscode1;
@property (nonatomic, strong) UITextField *txtPasscode2;
@property (nonatomic, strong) UITextField *txtPasscode3;
@property (nonatomic, strong) UITextField *txtPasscode4;
@property (nonatomic, strong) UITextField *txtPasscode5;
@property (nonatomic, strong) UITextField *txtPasscode6;


@property (nonatomic, strong) UIImageView *passCodeSelect1;
@property (nonatomic, strong) UIImageView *passCodeSelect2;
@property (nonatomic, strong) UIImageView *passCodeSelect3;
@property (nonatomic, strong) UIImageView *passCodeSelect4;
@property (nonatomic, strong) UIImageView *passCodeSelect5;
@property (nonatomic, strong) UIImageView *passCodeSelect6;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation PasscodeViewController{
    int StringCount;
    NSString *passcode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponents];
    passcode = @"";
    [self.txtPasscode1 becomeFirstResponder];
    NSLog(@"%@,%@,%@",_accName,_phone,_password);
}

                                        /** Functionality **/

-(id)initWithAccName:(NSString *)accName phoneNumber:(NSString *)phone andPassword:(NSString *)password{
    if (self = [super init]) {
        _accName = accName;
        _phone = phone;
        _password = password;
    }
    return self;
}

// Validate passcode numbers
-(void)checkPasscode :(NSString*) str{
    if ([str isEqualToString:@"123456"]) {
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        if ([[standardUserDefault objectForKey:@"status"]isEqualToString:@"signUp"]){
            //
            [self signUp];
            
        }
        else {
            NewPasswordViewController *newPassCon = [[NewPasswordViewController alloc]init];
            newPassCon.view.frame = [self.view bounds];
            [self.navigationController pushViewController:newPassCon animated:YES];
        }
        
        
    }
    else {
        [self alertBoxWithMessage:@"Invalid Code" message:@"Please resend code"];
        passcode = @"";
    }
}


// Sign up
-(void)signUp{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
        //connection unavailable
        [self alertBoxWithMessage:@"No Internet!" message:@"Please check internet connection."];
    }
    else{
        [self.spinner startAnimating];
        [self.view addSubview:self.spinner];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:self.accName forKey:@"accName"];
        [parameters setObject:self.phone forKey:@"phone"];
        [parameters setObject:self.password forKey:@"password"];
        
        __weak PasscodeViewController *weakSelf = self;
        WSSignUp *signUpService = [[WSSignUp alloc]init];
        signUpService.postBody = parameters;
        
        signUpService.onSuccess = ^(id contr, id result) {
            NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
            [[MyManager sharedManager] setUserId:[response objectForKey:@"userId"] ];
            [[MyManager sharedManager] setSessionId:[response objectForKey:@"sessionId"]];
            [[MyManager sharedManager] setPhone:[response objectForKey:@"phone"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                [self.view endEditing:true];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NofMain" object:nil];
            });
            
        };
        
        signUpService.onError = ^(id contr, id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner removeFromSuperview];
                NSDictionary *response = [[NSDictionary alloc]initWithDictionary:result];
                [weakSelf alertBoxWithMessage:@"Error" message:[NSString stringWithFormat:@"%@",[response objectForKey:@"error"]]];
            });
            
        };
        
        [signUpService callRequest];
    }
}


// Resend new passcode
-(void)resendCode{
    [self alertBoxWithMessage:@"" message:@"Your code has been reset. Your confirmation code has just sent. You'll receive it shortly."];
}

// Go back to sign up view
-(void)backToSignUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Alert any message with title
-(void)alertBoxWithMessage : (NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOk];
    [self presentViewController:alert animated:true completion:nil];
}


                                        /** View Decoration **/
-(void)addComponents{
    
    // Force navigation bar not to hide any top view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // add spinner
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25,self.view.frame.size.height/2-25,50,50)];
    
    self.spinner.color = [UIColor redColor];
    
    //self.view.backgroundColor = [UIColor grayColor];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    // add back button
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    if ([[standardUserDefault objectForKey:@"status"]isEqualToString:@"signUp"]) {
        UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToSignUp)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }else {
        UIImage *backIcon = [[UIImage imageNamed:@"BackIcon.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(backToSignUp)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    
    
    
    
    // add label title Tos Tov
//    UILabel *lblTosTov = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 140) / 2 , 60, 140, 50)];
//    lblTosTov.textColor = [UIColor whiteColor];
//    lblTosTov.text = @"TOS @ TOV";
//    lblTosTov.font = [UIFont systemFontOfSize:25];
//    [self.view addSubview:lblTosTov];
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 10, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add label message
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 170) / 2,
                                                                   tosTovLogo.frame.origin.y + tosTovLogo.frame.size.height+15,
                                                                   170, 20)];
    lblMessage.text = @"Enter Confirmation Code";
    lblMessage.font = [UIFont systemFontOfSize:15];
    lblMessage.textColor = [UIColor whiteColor];
    [self.view addSubview:lblMessage];
    
    
    self.txtPasscode1 = [[UITextField alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 180) / 2,
                                                                    lblMessage.frame.origin.y + 50,
                                                                    30, 30)];
    
    [self.txtPasscode1 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode1.secureTextEntry = YES;
    self.txtPasscode1.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode1.delegate = self;
    [self.view addSubview:self.txtPasscode1];
    self.txtPasscode1.alpha = -1;
    UIImageView *pass1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass1.frame = self.txtPasscode1.frame;
    [self.view addSubview:pass1];
    
    
    self.txtPasscode2 = [[UITextField alloc]initWithFrame:CGRectMake(self.txtPasscode1.frame.origin.x + self.txtPasscode1.frame.size.width,lblMessage.frame.origin.y + 50, 30, 30)];
    
    [self.txtPasscode2 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode2.secureTextEntry = YES;
    self.txtPasscode2.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode2.delegate = self;
    [self.view addSubview:self.txtPasscode2];
    self.txtPasscode2.alpha = -1;
    UIImageView *pass2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass2.frame = self.txtPasscode2.frame;
    [self.view addSubview:pass2];
    
    
    self.txtPasscode3 = [[UITextField alloc]initWithFrame:CGRectMake(self.txtPasscode2.frame.origin.x + self.txtPasscode2.frame.size.width,lblMessage.frame.origin.y + 50, 30, 30)];
    
    [self.txtPasscode3 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode3.secureTextEntry = YES;
    self.txtPasscode3.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode3.delegate = self;
    [self.view addSubview:self.txtPasscode3];
    self.txtPasscode3.alpha = -1;
    UIImageView *pass3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass3.frame = self.txtPasscode3.frame;
    [self.view addSubview:pass3];
    
    self.txtPasscode4 = [[UITextField alloc]initWithFrame:CGRectMake(self.txtPasscode3.frame.origin.x + self.txtPasscode3.frame.size.width, lblMessage.frame.origin.y + 50, 30, 30)];
    
    [self.txtPasscode4 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode4.secureTextEntry = YES;
    self.txtPasscode4.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode4.delegate = self;
    [self.view addSubview:self.txtPasscode4];
    self.txtPasscode4.alpha = -1;
    UIImageView *pass4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass4.frame = self.txtPasscode4.frame;
    [self.view addSubview:pass4];
    
    self.txtPasscode5 = [[UITextField alloc]initWithFrame:CGRectMake(self.txtPasscode4.frame.origin.x + self.txtPasscode4.frame.size.width,lblMessage.frame.origin.y+50,30,30)];
    
    [self.txtPasscode5 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode5.secureTextEntry = YES;
    self.txtPasscode5.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode5.delegate = self;
    [self.view addSubview:self.txtPasscode5];
    self.txtPasscode5.alpha = -1;
    UIImageView *pass5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass5.frame = self.txtPasscode5.frame;
    [self.view addSubview:pass5];
    
    self.txtPasscode6 = [[UITextField alloc]initWithFrame:CGRectMake(self.txtPasscode5.frame.origin.x + self.txtPasscode5.frame.size.width,
                                                                     lblMessage.frame.origin.y + 50,
                                                                     30,30)];
    
    [self.txtPasscode6 setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtPasscode6.secureTextEntry = YES;
    self.txtPasscode6.textAlignment = NSTextAlignmentCenter;
    self.txtPasscode6.delegate = self;
    [self.view addSubview:self.txtPasscode6];
    self.txtPasscode6.alpha = -1;
    UIImageView *pass6 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon1.png"]];
    pass6.frame = self.txtPasscode6.frame;
    [self.view addSubview:pass6];
    
    
    // add label message
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 222) / 2,
                                                                   self.txtPasscode1.frame.origin.y + self.txtPasscode1.frame.size.height+10,
                                                                   180,15)];
    lbl1.text = @"Enter Confirmation Code sent to your";
    lbl1.font = [UIFont systemFontOfSize:10];
    lbl1.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl1];
    
    // add lable register
    UILabel *lblReg = [[UILabel alloc]initWithFrame:CGRectMake(lbl1.frame.origin.x + lbl1.frame.size.width + 4,
                                                             self.txtPasscode1.frame.origin.y + self.txtPasscode1.frame.size.height + 10,
                                                             38,15)];
    //lblReg.text = @"register";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"register"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    lblReg.attributedText = [attributeString copy];
    lblReg.font = [UIFont systemFontOfSize:10];
    lblReg.textColor = [UIColor whiteColor];
    [self.view addSubview:lblReg];
    
    // add label phone num
    UILabel *lblPhoneNum = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 70) / 2,
                                                             lbl1.frame.origin.y + lbl1.frame.size.height,
                                                             70,15)];
    lblPhoneNum.text = @"phone number";
    lblPhoneNum.font = [UIFont systemFontOfSize:10];
    lblPhoneNum.textColor = [UIColor whiteColor];
    [self.view addSubview:lblPhoneNum];
    
    // add label message
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 216) / 2,
                                                             lblPhoneNum.frame.origin.y + lblPhoneNum.frame.size.height + 10,
                                                             151,15)];
    lbl2.text = @"Haven't received any code yet?";
    lbl2.font = [UIFont systemFontOfSize:10];
    lbl2.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl2];
    
    // add label sign in
    UILabel *lblReCode = [[UILabel alloc]initWithFrame:CGRectMake(lbl2.frame.origin.x + lbl2.frame.size.width+3,
                                                             lblPhoneNum.frame.origin.y + lblPhoneNum.frame.size.height + 10,
                                                             63,15)];
    lblReCode.text = @"Resend code";
    lblReCode.textColor = [UIColor redColor];
    lblReCode.font = [UIFont systemFontOfSize:10];
    lblReCode.textColor = [UIColor redColor];
    // add gesture tap to forget password
    UITapGestureRecognizer *tapToResend = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resendCode)];
    tapToResend.numberOfTapsRequired = 1;
    lblReCode.userInteractionEnabled = YES;
    [lblReCode addGestureRecognizer:tapToResend];
    [self.view addSubview:lblReCode];
    
    
}
-(void)checkBackSpaceWithTextField:(UITextField *)textField withString:(NSString *)str{
    if (textField == self.txtPasscode1) {
        BOOL isPressedBackspaceAfterSingleSpaceSymbol = [str isEqualToString:@""];
        if (isPressedBackspaceAfterSingleSpaceSymbol) {
            NSLog(@"YES ");
        }
    }
}


                                        /** UITextField Delegate **/

// Make passcode numbe run from one text field to other textfield
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==self.txtPasscode1) {
        if (textField.text.length==0 && range.length==0) {
        
            // add bullet
            self.passCodeSelect1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect1.frame = self.txtPasscode1.frame;
            [self.view addSubview:self.passCodeSelect1];
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode2 becomeFirstResponder];
            return NO;
        }
    }
    else if (textField==self.txtPasscode2){
        if (textField.text.length==0 && range.length==0) {
           
            // add bullet
            self.passCodeSelect2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect2.frame = self.txtPasscode2.frame;
            [self.view addSubview:self.passCodeSelect2];
            
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode3 becomeFirstResponder];
            return NO;
        }
    }
    else if (textField==self.txtPasscode3){
        if (textField.text.length==0 && range.length==0) {
            // add bullet
            self.passCodeSelect3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect3.frame = self.txtPasscode3.frame;
            [self.view addSubview:self.passCodeSelect3];
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode4 becomeFirstResponder];
            return NO;
        }
    }
    else if (textField==self.txtPasscode4){
        if (textField.text.length==0 && range.length==0) {
            // add bullet
            self.passCodeSelect4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect4.frame = self.txtPasscode4.frame;
            [self.view addSubview:self.passCodeSelect4];
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode5 becomeFirstResponder];
            return NO;
        }
    }
    else if (textField==self.txtPasscode5 && range.length==0){
        if (textField.text.length==0) {
            // add bullet
            self.passCodeSelect5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect5.frame = self.txtPasscode5.frame;
            [self.view addSubview:self.passCodeSelect5];
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode6 becomeFirstResponder];
            return NO;
        }
    }
    else if (textField==self.txtPasscode6 && range.length==0){
        if (textField.text.length==0) {
            // add bullet
            self.passCodeSelect6 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PassCodeIcon2.png"]];
            self.passCodeSelect6.frame = self.txtPasscode6.frame;
            [self.view addSubview:self.passCodeSelect6];
            passcode=[passcode stringByAppendingString:string];
            [textField resignFirstResponder];
            [self.txtPasscode1 becomeFirstResponder];
            [self checkPasscode:passcode];
            return NO;
        }
    }
    return YES;
    
    /**
    if (textField.text.length == 5 && range.length==0){
        NSString *str = [[self.txtPasscode.text substringToIndex:5] stringByAppendingString:string];
        [self checkPasscode:str];
        return NO;
        }
    else{
        return YES;
    }
     **/
    
}





@end
