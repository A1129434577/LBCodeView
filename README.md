# LBCodeView
```objc
LBCodeView *codeView = [[LBCodeView alloc] initWithFrame:CGRectMake(20, 200, CGRectGetWidth(self.view.frame)-20*2, 60) numbersCount:6 space:15];
[codeView.codeShowButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    obj.backgroundColor = [UIColor cyanColor];
}];
```
![](https://github.com/A1129434577/LBCodeView/blob/master/LBCodeView.gif?raw=true)
