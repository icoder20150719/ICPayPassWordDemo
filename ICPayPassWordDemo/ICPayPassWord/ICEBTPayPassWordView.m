//
//  EBTPayPassWordView.m
//  EBTPayPassWordDemo
//
//  Created by MJ on 15/7/28.
//  Copyright (c) 2015年 com.csst.www. All rights reserved.
//

#import "ICEBTPayPassWordView.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define kTextFieldMargin 1.f
/**广播通知名名称常用赋值*/
 NSString *const KNotification_ValidatePassWord = @"Notification_ValidatePassWord";
@interface ICEBTPayPassWordView ()
{
    UITextField *textFieldHiden; //用来调用键盘接收输入数字
    UITextField *textFieldFirst; //第一个密码框
    UITextField *textFieldTwo;  //第二个密码框
    UITextField *textFieldThree; //第三个密码框
    UITextField *textFieldFour; //第四个密码框
    UITextField *textFieldFive; //第五个密码框
    UITextField *textFieldSix; //第六个密码框
    UIView *contentView;  //用来添加5个密码框、线条、 标题、textFieldView
    UIView *lineView;  //线条view
    UILabel *lblTitle; //标题
    UIButton *btnCancel; //取消按钮
    UIButton *btnOK; //确定按钮
    UIView *textFieldView; //用来添加5个文本框密码框
    NSMutableArray *textFieldArray; //用来保存5个文本框密码框
    NSString *passWord;//用来保存用户输入的密码
}
@end
@implementation ICEBTPayPassWordView
+ (ICEBTPayPassWordView *)shareInstance
{
    static ICEBTPayPassWordView *myInstance = nil;
    static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       
       myInstance = [[ICEBTPayPassWordView alloc]init];
       
   });
    return myInstance;

}
- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = UIColorFromRGB(0x7a7a7c);
        self.frame = [UIScreen mainScreen].bounds;
       
        [self setUp];
        
    }
    return self;
}
- (void)setUp
{
    /**创建对话框view*/
    contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(20, 84, SCREENWIDTH-40, 120);
    contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    contentView.layer.cornerRadius = 3.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
//*****************************************创建lbltitle标题***********************************//
    /**创建标题用自动布局*/
    lblTitle = [[UILabel alloc]init];
    lblTitle.text = @"请输入支付密码";
    lblTitle.font = [UIFont systemFontOfSize:12.f];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.tintColor = [UIColor lightGrayColor];
    lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:lblTitle];
    /**垂直方向约束*/
    NSArray *lblTitle_V = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-5-[lblTitle(18)]"
                           options:0
                           metrics:nil
                           views:NSDictionaryOfVariableBindings(lblTitle)
                           ];
    /**水平方向约束*/
    NSArray *lblTitle_H = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:[lblTitle(100)]"
                           options:0
                           metrics:nil
                           views:NSDictionaryOfVariableBindings(lblTitle)
                           ];
    /**水平居中对齐约束*/
    NSLayoutConstraint *lblTitle_CenterX = [NSLayoutConstraint constraintWithItem:lblTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [contentView addConstraint:lblTitle_CenterX];
    [contentView addConstraints:lblTitle_H];
    [contentView addConstraints:lblTitle_V];
    
//*****************************************创建lineView线条***********************************//
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:lineView];
    NSArray *lineView_H = [ NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|-10-[lineView]-10-|"
                           options:0
                           metrics:nil
                           views:NSDictionaryOfVariableBindings(lineView)
                           ];
     NSArray *lineView_V = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"V:|-5-[lblTitle]-5-[lineView(0.5)]" options:0
                            metrics:nil
                            views:NSDictionaryOfVariableBindings(lineView,lblTitle)
                            ];
    [contentView addConstraints:lineView_H];
    [contentView addConstraints:lineView_V];
    
   
//********************************创建textFieldView**********************************//
    
    textFieldView = [[UIView alloc]init];
    textFieldView.backgroundColor = [UIColor clearColor];
    textFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    textFieldView.layer.cornerRadius = 3.f;
    textFieldView.layer.masksToBounds = YES;
    [contentView addSubview:textFieldView];
    NSArray *textFieldView_H = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-10-[textFieldView]-10-|" options:0
                                metrics:nil
                                views:NSDictionaryOfVariableBindings(textFieldView)
                                ];
    
       NSArray *textFieldView_V = [NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-5-[lblTitle]-5-[lineView]-10-[textFieldView(35)]"
                                   options:0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(textFieldView,lineView,lblTitle)
                                   ];
    
    [contentView addConstraints:textFieldView_H];
    [contentView addConstraints:textFieldView_V];
    
    
    
//**************************************创建取消按钮****************************************//
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.backgroundColor = UIColorFromRGB(0xfbfbfb);
    btnCancel.tag = 100;
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.layer.cornerRadius = 3.f;
    btnCancel.layer.masksToBounds = YES;
    btnCancel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:btnCancel];
    NSArray *btnCancel_V = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"V:[btnCancel(30)]-5-|"
                            options:0
                            metrics:nil
                            views:NSDictionaryOfVariableBindings(btnCancel)];
    [contentView addConstraints:btnCancel_V];
    
//**************************************创建确定按钮****************************************//
    
    btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnOK.backgroundColor = UIColorFromRGB(0x3b7bf6);
    btnOK.tag = 101;
    [btnOK addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.translatesAutoresizingMaskIntoConstraints = NO;
    btnOK.layer.cornerRadius = 3.f;
    btnOK.layer.masksToBounds = YES;
    [contentView addSubview:btnOK];
    NSArray *btnOK_V = [NSLayoutConstraint
                        constraintsWithVisualFormat:@"V:[btnOK(30)]-5-|"
                        options:0
                        metrics:nil
                        views:NSDictionaryOfVariableBindings(btnOK)];
    [contentView addConstraints:btnOK_V];
    /**对确定和取消两个按钮实现等宽布局约束*/
    NSArray *btnAll_H = [NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|-10-[btnCancel]-10-[btnOK(btnCancel)]-10-|"
                         options:0
                         metrics:nil
                         views:NSDictionaryOfVariableBindings(btnCancel,btnOK)
                         ];
    [contentView addConstraints:btnAll_H];
    
    
//***********************************创建textFieldFirst************************************//
    
    textFieldFirst = [[UITextField alloc]init];
    textFieldFirst.secureTextEntry = YES;
    textFieldFirst.enabled = NO;
    textFieldFirst.keyboardType = UIKeyboardTypeNumberPad;
    textFieldFirst.borderStyle = UITextBorderStyleLine;
    textFieldFirst.textAlignment = NSTextAlignmentCenter;
    textFieldFirst.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldFirst];
    NSArray *textFieldFirst_V = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|[textFieldFirst]|"
                                 options:0
                                 metrics:nil
                                 views:NSDictionaryOfVariableBindings(textFieldFirst)
                                 ];
    [textFieldView addConstraints:textFieldFirst_V];
    
//***********************************创建textFieldTwo************************************//
    
    textFieldTwo = [[UITextField alloc]init];
    textFieldTwo.secureTextEntry = YES;
    textFieldTwo.enabled = NO;
    textFieldTwo.keyboardType = UIKeyboardTypeNumberPad;
    textFieldTwo.borderStyle = UITextBorderStyleLine;
    textFieldTwo.textAlignment = NSTextAlignmentCenter;
    textFieldTwo.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldTwo];
    NSArray *textFieldTwo_V = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[textFieldTwo]|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(textFieldTwo)
                               ];
    [textFieldView addConstraints:textFieldTwo_V];
    
//***********************************创建textFieldThree************************************//
    
    textFieldThree = [[UITextField alloc]init];
    textFieldThree.secureTextEntry = YES;
    textFieldThree.enabled = NO;
    textFieldThree.keyboardType = UIKeyboardTypeNumberPad;
    textFieldThree.borderStyle = UITextBorderStyleLine;
    textFieldThree.textAlignment = NSTextAlignmentCenter;
    textFieldThree.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldThree];
    NSArray *textFieldThree_V = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|[textFieldThree]|"
                                 options:0
                                 metrics:nil
                                 views:NSDictionaryOfVariableBindings(textFieldThree)
                                 ];
    [textFieldView addConstraints:textFieldThree_V];
    
//***********************************创建textFieldFour************************************//
    
    textFieldFour = [[UITextField alloc]init];
    textFieldFour.secureTextEntry = YES;
    textFieldFour.enabled = NO;
    textFieldFour.keyboardType = UIKeyboardTypeNumberPad;
    textFieldFour.borderStyle = UITextBorderStyleLine;
    textFieldFour.textAlignment = NSTextAlignmentCenter;
    textFieldFour.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldFour];
    NSArray *textFieldFour_V = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[textFieldFour]|"
                                options:0
                                metrics:nil
                                views:NSDictionaryOfVariableBindings(textFieldFour)
                                ];
    [textFieldView addConstraints:textFieldFour_V];
    
//***********************************创建textFieldFive************************************//
    textFieldFive = [[UITextField alloc]init];
    textFieldFive.secureTextEntry = YES;
    textFieldFive.enabled = NO;
    textFieldFive.keyboardType = UIKeyboardTypeNumberPad;
    textFieldFive.borderStyle = UITextBorderStyleLine;
    textFieldFive.textAlignment = NSTextAlignmentCenter;
    textFieldFive.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldFive];
    NSArray *textFieldFive_V = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[textFieldFive]|"
                                options:0
                                metrics:nil
                                views:NSDictionaryOfVariableBindings(textFieldFive)
                                ];
    [textFieldView addConstraints:textFieldFive_V];
    
//***********************************创建textFieldSix************************************//
    textFieldSix = [[UITextField alloc]init];
    textFieldSix.secureTextEntry = YES;
    textFieldSix.enabled = NO;
    textFieldSix.keyboardType = UIKeyboardTypeNumberPad;
    textFieldSix.borderStyle = UITextBorderStyleLine;
    textFieldSix.textAlignment = NSTextAlignmentCenter;
    textFieldSix.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldView addSubview:textFieldSix];
    NSArray *textFieldSix_V = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[textFieldSix]|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(textFieldSix)
                               ];
    [textFieldView addConstraints:textFieldSix_V];
    
    /**绑定6个文本框密码框*/
    NSDictionary *dic_bindsAll = NSDictionaryOfVariableBindings(textFieldFirst,
                                                                textFieldTwo,
                                                                textFieldThree,
                                                                textFieldFour,
                                                                textFieldFive,
                                                                textFieldSix);
    
    /**实现6个文本框等宽*/
    NSDictionary *dic_Constraint = @{
                                      @"margin":@(kTextFieldMargin)
                                     };
    NSArray *allTextField_H = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[textFieldFirst]-margin-[textFieldTwo(textFieldFirst)]-margin-[textFieldThree(textFieldTwo)]-margin-[textFieldFour(textFieldThree)]-margin-[textFieldFive(textFieldFour)]-margin-[textFieldSix(textFieldFive)]-0-|" options:0
                               metrics:dic_Constraint
                               views:dic_bindsAll
                               ];
    
    [textFieldView addConstraints:allTextField_H];
    
//***********************************textFieldArray保存六个文本框对象************************************//
    textFieldArray = [NSMutableArray arrayWithArray:@[textFieldFirst,
                                                      textFieldTwo,
                                                      textFieldThree,
                                                      textFieldFour,
                                                      textFieldFive,
                                                      textFieldSix]];
//******************************textFieldHiden(主要是这个文本框来实现数字入)************************************//
    textFieldHiden = [[UITextField alloc]init];
    textFieldHiden.returnKeyType = UIReturnKeyDefault;
    textFieldHiden.borderStyle = UITextBorderStyleNone;
    textFieldHiden.clearButtonMode = UITextFieldViewModeNever;
    textFieldHiden.keyboardType = UIKeyboardTypeNumberPad;
    textFieldHiden.translatesAutoresizingMaskIntoConstraints = NO;
    [textFieldHiden addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:textFieldHiden];
    NSArray *textFieldHiden_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textFieldHiden]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textFieldHiden)];
    NSArray *textFieldHiden_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textFieldHiden]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textFieldHiden)];
    [self addConstraints:textFieldHiden_H];
    [self addConstraints:textFieldHiden_V];
    
//******************************添加通知************************************//
/**
     这里用通知主要是用于:输入密码后单击确定按钮，然后输入密码要于后台服务器的密码进行验证。如果密码相等则移除该对话框。否则对对话框进行抖动提示密码错误
 
 **/
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatePassWordResult:) name:KNotification_ValidatePassWord object:nil];
    
}
/**文本框添加方法*/
- (void)textFieldEditingChanged:(UITextField *)textField
{
    
    NSString *passWordText = textFieldHiden.text;
    
    if (passWordText.length == textFieldArray.count)
    {
        [textField resignFirstResponder];
    }
    for (NSInteger i = 0; i < textFieldArray.count; i++)
    {
        UITextField *textField = textFieldArray[i];
        
        NSString *pwdChar;
        if (i < passWordText.length)
        pwdChar = [passWordText substringWithRange:NSMakeRange(i, 1)];
        textField.text = pwdChar;
        
    }
    if (passWordText.length == 6)
    {
        passWord = passWordText;
        textFieldHiden.text = @"";
    }
  
}
/**两个按钮添加事件方法*/
- (void)btnAction:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        [self dismissPayPassWordView];
    }
    else
    {
      if(myCompleteHandler)
      {
          myCompleteHandler(passWord);
         
      }
    }
}
/**显示输入密码对话框*/
- (void)showPassWordViewInView:(CompleteHandler)completeHandler
{
    myCompleteHandler = completeHandler;
    [self clearTextField];
    [self showPayPassWordView];

}
+ (void)showPassWordViewInView:(CompleteHandler)completeHandler
{
    [[ICEBTPayPassWordView shareInstance] showPassWordViewInView:completeHandler];
}
/**显示对话框*/
- (void)showPayPassWordView
{
    UIWindow *keyWindow=[[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self];
    contentView.alpha=0;
    contentView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 0.75;
        contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
}
/**移除对话框*/
- (void)dismissPayPassWordView
{
    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 0;
        contentView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/**
 *  设置文本框颜色、清空内容
 */
- (void)clearTextField
{
     [textFieldHiden becomeFirstResponder];
    [textFieldFirst setTextColor:UIColorFromRGB(0x000000)];
    [textFieldTwo setTextColor:UIColorFromRGB(0x000000)];
    [textFieldThree setTextColor:UIColorFromRGB(0x000000)];
    [textFieldFour setTextColor:UIColorFromRGB(0x000000)];
    [textFieldFive setTextColor:UIColorFromRGB(0x000000)];
    [textFieldSix setTextColor:UIColorFromRGB(0x000000)];
     textFieldFirst.text = @"";
     textFieldTwo.text = @"";
     textFieldThree.text = @"";
     textFieldFour.text = @"";
     textFieldFive.text = @"";
     textFieldSix.text = @"";
    
}
/**
 *  如果输入密码的正确则移除对话框，否则抖动对话框
 *
 *  @param notification 参数
 */
- (void)validatePassWordResult:(NSNotification *)notification
{
    NSDictionary *resultDic = [notification userInfo];
    if ([resultDic[@"validateResult"] integerValue]==1) {
        [self dismissPayPassWordView];
    }
    else
    {
        [self shakeContentViewWithAnimate];
        [self clearTextField];
        
    }
}
/**
 *  给对话框添加抖动动画
 */
- (void)shakeContentViewWithAnimate
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyAnimation.values = @[@0,@12,@-12,@12,@0];
    keyAnimation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    keyAnimation.duration = 0.5;
    keyAnimation.additive = YES;
    [contentView.layer addAnimation:keyAnimation forKey:@"shakeAnimate"];
}
/**
 *  移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_ValidatePassWord object:nil];
}
@end
