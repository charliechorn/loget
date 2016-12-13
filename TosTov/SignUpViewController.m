//
//  SignUpViewController.m
//  TosTov
//
//  Created by Pichzz on 11/7/16.
//  Copyright © 2016 Chhaly. All rights reserved.
//

#import "SignUpViewController.h"
#import "PasscodeViewController.h"
#import "PrivacyViewController.h"
#import "TermViewController.h"
#import "Reachability.h"


@interface SignUpViewController ()

@property (nonatomic, strong) UITextField *txtAcc;
@property (nonatomic, strong) UITextField *txtPhoneNum;
@property (nonatomic, strong) UITextField *txtPassword;
@property (nonatomic, strong) UITextField *txtConfirmPassword;
@property (nonatomic, strong) UIButton *btnSignIn;
@property (nonatomic, strong) UIButton *btnShowPassimage;
@property (nonatomic, strong) UILabel *lblSignIn;

@end

@implementation SignUpViewController{
    bool isShownPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShownPassword=false;
    [self addComponents];
}

                                        /** Functionality **/

// Register new account
-(void)registerNewAcc{
    
    // check blank
    if ([self.txtPhoneNum.text isEqualToString:@""] || [self.txtPhoneNum.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""] || [self.txtConfirmPassword.text isEqualToString:@""]) {
        [self alertBoxWithMessage:@"" message:@"Please input information"];
        return;
    }
    // check phone number
    if (self.txtPhoneNum.text.length < 9) {
        [self alertBoxWithMessage:@"Invalid Phone Number" message:@"Please check your phone number"];
        return;
    }
    // validate password
    //int numOfChars = 0;
    BOOL lowerCaseLetter = 0;
    BOOL uppercaseLetter = 0;
    BOOL digitChar =0;
    if (self.txtConfirmPassword.text.length >= 6) {
        for(int i=0; i<self.txtConfirmPassword.text.length ;i++){
            unichar c = [self.txtConfirmPassword.text characterAtIndex:i];
            if(!lowerCaseLetter){
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!uppercaseLetter){
                uppercaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if (!digitChar) {
                digitChar = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        if (lowerCaseLetter && uppercaseLetter && digitChar) {
            
            [self.view endEditing:true];
            NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
            [standardUserDefault setObject:@"signUp" forKey:@"status"];
            PasscodeViewController *passcodeVC = [[PasscodeViewController alloc]initWithAccName:self.txtAcc.text phoneNumber:self.txtPhoneNum.text andPassword:self.txtPassword.text];
            passcodeVC.view.frame = self.view.bounds;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:passcodeVC];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                   nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                                   self.view.bounds.size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [nav.navigationBar addSubview:line];
            
            //nav.navigationBar.barTintColor = [UIColor grayColor];
            nav.navigationBar.translucent = NO;
            [self presentViewController:nav animated:true completion:nil];
            
        }
        else{
            [self alertBoxWithMessage:@"" message:@"Password must be at least 6 characters (mininum 1 uppercase, 1 lowercase, 1 number))"];
        }
    }
    else {
        [self alertBoxWithMessage:@"" message:@"Password must be at least 6 characters (mininum 1 uppercase, 1 lowercase, 1 number))"];
    }
    
    
}


// Go back to sign in view
-(void)backToSignIn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NofLogin" object:nil];
}

// Go to privacy policy view
-(void)gotoPolicyView{
    PrivacyViewController *privacyView = [[PrivacyViewController alloc]init];
    privacyView.view.frame = self.view.bounds;
    privacyView.title = @"PRIVACY POLICY";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:privacyView];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                           nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [nav.navigationBar addSubview:line];

    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:true completion:nil];
}

// Go to terms of service view
-(void)gotoTermView{
    TermViewController *termView = [[TermViewController alloc]init];
    termView.view.frame = self.view.bounds;
    termView.title = @"TERMS OF SERVICE";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:termView];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBackground.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                           nav.navigationBar.frame.origin.y + nav.navigationBar.bounds.size.height,
                                                           self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [nav.navigationBar addSubview:line];

    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:true completion:nil];
}

// Show hidden secured password
-(void)showPassword{
    if (isShownPassword) {
        [self.txtPassword setSecureTextEntry:true];
        isShownPassword = false;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    }
    else {
        [self.txtPassword setSecureTextEntry:false];
        isShownPassword = true;
        [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeActionLogo.png"] forState:UIControlStateNormal];
    }
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
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovBackgroundAll.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.frame = self.view.bounds;
    [self.view insertSubview:backgroundView atIndex:0];
    
    // add gesture to main view
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:areaTap];
    
    // add logo tos tov
    UIImageView *tosTovLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TosTovLogo.png"]];
    tosTovLogo.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 60, 150, 35);
    [self.view addSubview:tosTovLogo];
    
    // add logo user
    UIImageView *userLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UserLogo.png"]];
    userLogo.frame = CGRectMake(30,
                                 tosTovLogo.frame.origin.y + 100,
                                 30, 30);
    userLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:userLogo];
    
    // add textfield account
    self.txtAcc = [[UITextField alloc]initWithFrame:CGRectMake(userLogo.frame.origin.x + userLogo.frame.size.width + 20,
                                                               userLogo.frame.origin.y,
                                                               self.view.bounds.size.width - 110, 30)];
    self.txtAcc.borderStyle = UITextBorderStyleNone;
    self.txtAcc.textColor = [UIColor whiteColor];
    self.txtAcc.font = [UIFont systemFontOfSize:12];
    self.txtAcc.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtAcc.delegate = self;
    [self.view addSubview:self.txtAcc];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(userLogo.frame.origin.x + userLogo.frame.size.width + 20,
                                                           self.txtAcc.frame.origin.y + self.txtAcc.bounds.size.height + 3,
                                                            self.txtAcc.bounds.size.width, 1)];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    
    // add logo phone number
    UIImageView *phoneLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PhoneLogo.png"]];
    phoneLogo.frame = CGRectMake(30,
                                self.txtAcc.frame.origin.y + 50,
                                30, 30);
    phoneLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:phoneLogo];
    
    // add textfield phone number
    self.txtPhoneNum = [[UITextField alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                                    phoneLogo.frame.origin.y,
                                                                    self.view.bounds.size.width - 110,30)];
    self.txtPhoneNum.borderStyle = UITextBorderStyleNone;
    [self.txtPhoneNum setKeyboardType: UIKeyboardTypeNumberPad];
    self.txtPhoneNum.textColor = [UIColor whiteColor];
    self.txtPhoneNum.font = [UIFont systemFontOfSize:12];
    self.txtPhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtPhoneNum.delegate = self;
    [self.view addSubview:self.txtPhoneNum];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(phoneLogo.frame.origin.x + phoneLogo.frame.size.width + 20,
                                                           self.txtPhoneNum.frame.origin.y + self.txtPhoneNum.bounds.size.height + 3,
                                                            self.txtPhoneNum.bounds.size.width, 1)];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];

    // add logo lock
    UIImageView *lockLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockLogo.png"]];
    lockLogo.frame = CGRectMake(30,
                                 self.txtPhoneNum.frame.origin.y + 50,
                                 30, 30);
    lockLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:lockLogo];
    
    // add textfield password
    self.txtPassword = [[UITextField alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                                    lockLogo.frame.origin.y,
                                                                    self.view.bounds.size.width - 110, 30)];
    self.txtPassword.borderStyle = UITextBorderStyleNone;
    [self.txtPassword setSecureTextEntry:YES];
    self.txtPassword.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtPassword.delegate = self;
    [self.view addSubview:self.txtPassword];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(lockLogo.frame.origin.x + lockLogo.frame.size.width + 20,
                                                           self.txtPassword.frame.origin.y + self.txtPassword.bounds.size.height + 3,
                                                            self.txtPassword.bounds.size.width, 1)];
    line3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line3];
    
    // add show password button
    self.btnShowPassimage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnShowPassimage.frame = CGRectMake(0, 0, 25, 15);
    [self.btnShowPassimage setBackgroundImage:[UIImage imageNamed:@"EyeLogo.png"] forState:UIControlStateNormal];
    [self.btnShowPassimage addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
    self.txtPassword.rightViewMode = UITextFieldViewModeAlways;
    self.txtPassword.rightView = self.btnShowPassimage;
    
    // add logo lock
    UIImageView *lockLogo1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockLogo.png"]];
    lockLogo1.frame = CGRectMake(30,
                                self.txtPassword.frame.origin.y + 50,
                                30, 30);
    lockLogo1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:lockLogo1];
    
    // add textfield confirm password
    self.txtConfirmPassword = [[UITextField alloc]initWithFrame:CGRectMake(lockLogo1.frame.origin.x + lockLogo1.frame.size.width + 20,
                                                                    lockLogo1.frame.origin.y,
                                                                    self.view.bounds.size.width - 110, 30)];
    self.txtConfirmPassword.borderStyle = UITextBorderStyleNone;
    [self.txtConfirmPassword setSecureTextEntry:YES];
    self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    self.txtConfirmPassword.delegate = self;
    [self.view addSubview:self.txtConfirmPassword];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(lockLogo1.frame.origin.x + lockLogo1.frame.size.width + 20,
                                                           self.txtConfirmPassword.frame.origin.y + self.txtConfirmPassword.bounds.size.height + 3,
                                                            self.txtConfirmPassword.bounds.size.width, 1)];
    line4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line4];
    
    
    // add button sign in
    self.btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSignIn.frame = CGRectMake(30,
                                      self.txtConfirmPassword.frame.origin.y + 100,
                                      self.view.bounds.size.width - 60,
                                      30);
    
    self.btnSignIn.backgroundColor = [UIColor redColor];
    UILabel *signin = [[UILabel alloc]initWithFrame:CGRectMake((self.btnSignIn.frame.size.width - 45) / 2,
                                                               5, 45, 20)];
    signin.text = @"SIGN IN";
    signin.font = [UIFont systemFontOfSize:12];
    signin.textColor = [UIColor whiteColor];
    
    [self.btnSignIn addSubview:signin];
    [self.btnSignIn addTarget:self action:@selector(registerNewAcc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSignIn];

    
    // add label message
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 134) / 2,
                                                             self.btnSignIn.frame.origin.y + self.btnSignIn.frame.size.height + 15,
                                                             134, 15)];
    lbl1.text = @"By singing up I agree to the";
    lbl1.font = [UIFont systemFontOfSize:10];
    lbl1.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl1];
    
    // add label term of servie
    UILabel *lblTerm = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 178) / 2,
                                                                lbl1.frame.origin.y + lbl1.frame.size.height,
                                                                82, 15)];
    lblTerm.text = @"Terms of Service";
    lblTerm.font = [UIFont systemFontOfSize:10];
    lblTerm.textColor = [UIColor redColor];
    // add gesture to term of service
    UITapGestureRecognizer *tapTerm = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoTermView)];
    tapTerm.numberOfTapsRequired = 1;
    lblTerm.userInteractionEnabled = YES;
    [lblTerm addGestureRecognizer:tapTerm];

    [self.view addSubview:lblTerm];
    
    // add label and
    UILabel *lblAnd = [[UILabel alloc]initWithFrame:CGRectMake(lblTerm.frame.origin.x + lblTerm.frame.size.width + 5,
                                                                lbl1.frame.origin.y + lbl1.frame.size.height,
                                                                18,15)];
    lblAnd.text = @"and";
    lblAnd.font = [UIFont systemFontOfSize:10];
    lblAnd.textColor = [UIColor whiteColor];
    [self.view addSubview:lblAnd];
    
    // add label privacy policy
    UILabel *lblPrivacy = [[UILabel alloc]initWithFrame:CGRectMake(lblAnd.frame.origin.x + lblAnd.frame.size.width + 5,
                                                                  lbl1.frame.origin.y + lbl1.frame.size.height,
                                                                  68,15)];
    lblPrivacy.text = @"Privacy Policy";
    lblPrivacy.font = [UIFont systemFontOfSize:10];
    lblPrivacy.textColor = [UIColor redColor];
    // add gesture to privac policy
    UITapGestureRecognizer *tapPolicy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPolicyView)];
    tapPolicy.numberOfTapsRequired = 1;
    lblPrivacy.userInteractionEnabled = YES;
    [lblPrivacy addGestureRecognizer:tapPolicy];
    [self.view addSubview:lblPrivacy];
    
    // add footer view
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    footer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footer];
    
    // add label Don't have an account
    UILabel *haveAcc = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 175) / 2,
                                                                    15, 125, 20)];
    haveAcc.text = @"Already have an account?";
    haveAcc.textColor = [UIColor blackColor];
    haveAcc.font = [UIFont systemFontOfSize:10];
    [footer addSubview:haveAcc];
    
    // add sign up label
    self.lblSignIn = [[UILabel alloc]initWithFrame:CGRectMake(haveAcc.frame.origin.x + haveAcc.frame.size.width ,
                                                           15, 50, 20)];
    self.lblSignIn.text = @"SIGN IN";
    self.lblSignIn.textColor = [UIColor redColor];
    self.lblSignIn.font = [UIFont systemFontOfSize:10];
    // add gesture tap to sign up
    UITapGestureRecognizer *tapForSignIn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToSignIn)];
    tapForSignIn.numberOfTapsRequired = 1;
    self.lblSignIn.userInteractionEnabled = YES;
    [self.lblSignIn addGestureRecognizer:tapForSignIn];
    
    [footer addSubview:self.lblSignIn];
    
    // add gesture tap to sign up
    UITapGestureRecognizer *tapForSignIn2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToSignIn)];
    tapForSignIn2.numberOfTapsRequired = 1;
    
    footer.userInteractionEnabled = YES;
    [footer addGestureRecognizer:tapForSignIn2];
}

// UITextfield Delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.txtAcc) {
        if (textField.text.length > 25 && range.length == 0) {
            [self alertBoxWithMessage:@"Invalid Account Name" message:@"Account name must be below 25 characters"];
            return NO;
        }
    }
    if (textField==self.txtPhoneNum) {
        if (textField.text.length >16 && range.length == 0) {
            [self alertBoxWithMessage:@"Invalid Phone Number" message:@"Please check your phone number"];
            return NO;
        }
    }
    if (textField==self.txtPassword || textField==self.txtConfirmPassword) {
        if (textField.text.length >15 && range.length == 0) {
            [self alertBoxWithMessage:@"Invalid Password" message:@"Password must be below 15 characters"];
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardWillShowNotification object:nil];
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:true];
    return true;
}


-(void)keyboardDidShow{
    self.view.frame = CGRectMake(0, -120, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)keyboardDidHide{
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

-(void)dismissKeyboard{
    [self.view endEditing:true];
    [self keyboardDidHide];
}


@end
