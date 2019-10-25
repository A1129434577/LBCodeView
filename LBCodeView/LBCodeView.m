//
//  LBCodeView.m
//  Driver
//
//  Created by 刘彬 on 2019/5/7.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBCodeView.h"

@interface LBCodeView ()<UITextFieldDelegate>
@property (nonatomic,assign)NSUInteger count;
@property (nonatomic,strong)UIView *cursorView;
@end

@implementation LBCodeView

- (instancetype)initWithFrame:(CGRect)frame numbersCount:(NSUInteger)count space:(CGFloat)space
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = count;
        _codeShowButtons = [[NSMutableArray alloc] init];
        
        _hiddenTextField = [[UITextField alloc] init];
        _hiddenTextField.delegate = self;
        _hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTextFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:_hiddenTextField];
        [self addSubview:_hiddenTextField];
        
        CGFloat showButtonSide = (CGRectGetWidth(frame)-space*(count-1))/count;
        for (NSUInteger i = 0; i < count; i ++) {
            UIButton *codeShowButton = [[UIButton alloc] initWithFrame:CGRectMake(i*(showButtonSide+space), (CGRectGetHeight(frame)-showButtonSide)/2, showButtonSide, showButtonSide)];
            codeShowButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [codeShowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [codeShowButton addTarget:self action:@selector(editBegain) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:codeShowButton];
            [(NSMutableArray *)_codeShowButtons addObject:codeShowButton];
        }
        
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake((showButtonSide-1.5)/2, 10, 1.5, showButtonSide-10*2)];
        _cursorView.backgroundColor = [UIColor magentaColor];
        
    }
    return self;
}
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    _cursorView.backgroundColor = tintColor;
}
-(void)editBegain{
    [_hiddenTextField becomeFirstResponder];
}

-(BOOL)becomeFirstResponder{
    return [_hiddenTextField becomeFirstResponder];
}
-(void)hiddenTextFieldTextDidChange{
    typeof(self) __weak weakSelf = self;
    [_codeShowButtons enumerateObjectsUsingBlock:^(__weak UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < weakSelf.hiddenTextField.text.length) {
            [btn setTitle:[weakSelf.hiddenTextField.text substringWithRange:NSMakeRange(idx, 1)] forState:UIControlStateNormal];
        }else{
            [btn setTitle:nil forState:UIControlStateNormal];
        }
    }];
    
    if (_hiddenTextField.text.length < _codeShowButtons.count) {
        _cursorView.hidden = NO;
        UIButton *btn = _codeShowButtons[_hiddenTextField.text.length];
        [btn addSubview:_cursorView];
    }else _cursorView.hidden = YES;
    
    if (_hiddenTextField.text.length == _count) {
        [self endEditing:YES];
        weakSelf.codeInputFinish?
        weakSelf.codeInputFinish(weakSelf.hiddenTextField.text):NULL;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length < _codeShowButtons.count) {
        _cursorView.hidden = NO;
        UIButton *btn = _codeShowButtons[textField.text.length];
        [btn addSubview:_cursorView];
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
            self.cursorView.alpha = 0;
        } completion:nil];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _cursorView.hidden = YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length) {
        if (textField.text.length > _count-1) {
            return NO;
        }
    }
    return YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
