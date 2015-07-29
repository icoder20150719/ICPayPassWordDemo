//
//  ViewController.m
//  ICPayPassWordDemo
//
//  Created by MJ on 15/7/29.
//  Copyright (c) 2015年 com.csst.www. All rights reserved.
//

#import "ViewController.h"
#import "ICEBTPayPassWordView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(UIButton *)sender
{
    
    
    [ICEBTPayPassWordView showPassWordViewInView:^(NSString *password) {
        
        /**
         这里是模拟网络请求，把输入密码和后台的密码进行比较。我是根据
         广播通知来获取最终的验证的结果，如果我们输入密码和后台密码一样，则移除当前密码输入框。否则抖动密码
         输入框提示密码错误。ps:骚年请记得发一个通知偶。
         ***/
        BOOL result = [password isEqualToString:@"123456"]?YES:NO;
        NSDictionary *dic = @{
                              @"validateResult":@(result)
                              };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_ValidatePassWord object:nil userInfo:dic];
        
        
        NSLog(@"password = %@",password);
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
