# CPayPassWordDemo(模仿支付宝密码输入框)

还是先看看效果图哦
![Image](https://github.com/icoder20150719/ICPayPassWordDemo/blob/master/demo/1.gif)
#1:先把ICEBTPayPassWord文件夹导入工程，再#import "ICEBTPayPassWordView.h"
#2:具体操作步骤
[ICEBTPayPassWordView showPassWordViewInView:^(NSString *password) {
        
        /**
           这里模拟网络请求，把输入密码和后台的密码进行比较。这里使用要注意发送一个通知出去,我是根据
           通知来获取最终的验证的结果，如果我们输入密码和后台密码一样，则移除当前密码输入框。否则抖动密码
           输入框提示密码错误。
         ***/
        BOOL result = [password isEqualToString:@"123456"]?YES:NO;
        NSDictionary *dic = @{
                                @"validateResult":@(result)
                              };

            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_ValidatePassWord object:nil userInfo:dic];
        
        
        NSLog(@"password = %@",password);
    }];


