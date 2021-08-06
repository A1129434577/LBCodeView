//
//  LBCodeView.m
//  Driver
//
//  Created by 刘彬 on 2019/5/7.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBCodeView.h"

@interface LBCodeTextField : UITextField

@end
@implementation LBCodeTextField
- (void)setText:(NSString *)text{
    [super setText:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
}

@end

@interface LBCodeView ()<UITextFieldDelegate>
@property (nonatomic,assign)NSUInteger count;
@property (nonatomic,strong)UIView *cursorView;//模拟光标
@end

@implementation LBCodeView

- (instancetype)initWithFrame:(CGRect)frame numbersCount:(NSUInteger)count space:(CGFloat)space
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = count;
        _codeShowButtons = [[NSMutableArray alloc] init];
        
        _hiddenTextField = [[LBCodeTextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), 0)];
        _hiddenTextField.delegate = self;
        _hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
        _hiddenTextField.font = [UIFont boldSystemFontOfSize:20];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTextFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:_hiddenTextField];
        [self addSubview:_hiddenTextField];
        
        [_hiddenTextField addObserver:self forKeyPath:NSStringFromSelector(@selector(textColor)) options:NSKeyValueObservingOptionNew context:nil];
        [_hiddenTextField addObserver:self forKeyPath:NSStringFromSelector(@selector(font)) options:NSKeyValueObservingOptionNew context:nil];
                
        CGFloat showButtonWidth = (CGRectGetWidth(frame)-space*(count-1))/count;
        UIButton *codeShowButton;
        for (NSUInteger i = 0; i < count; i ++) {
            codeShowButton = [[UIButton alloc] initWithFrame:CGRectMake(i*(showButtonWidth+space), 0, showButtonWidth, CGRectGetHeight(frame))];
            codeShowButton.titleLabel.font = _hiddenTextField.font;
            [codeShowButton setTitleColor:_hiddenTextField.textColor forState:UIControlStateNormal];
            [codeShowButton addTarget:self action:@selector(editBegain) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:codeShowButton];
            [(NSMutableArray *)_codeShowButtons addObject:codeShowButton];
        }
        
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.5, _hiddenTextField.font.lineHeight)];
        _cursorView.center = CGPointMake(CGRectGetWidth(codeShowButton.bounds)/2, CGRectGetHeight(codeShowButton.bounds)/2);
        _cursorView.backgroundColor = self.tintColor;
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
            if (weakSelf.hiddenTextField.secureTextEntry) {
                [btn setTitle:@"●" forState:UIControlStateNormal];
            }else{
                [btn setTitle:[weakSelf.hiddenTextField.text substringWithRange:NSMakeRange(idx, 1)] forState:UIControlStateNormal];
            }
        }else{
            [btn setTitle:nil forState:UIControlStateNormal];
        }
    }];
    
    if (_hiddenTextField.text.length < _codeShowButtons.count) {
        _cursorView.hidden = NO;
        UIButton *btn = _codeShowButtons[_hiddenTextField.text.length];
        CGRect cursorViewFrame = _cursorView.frame;
        cursorViewFrame.origin.x = (CGRectGetWidth(btn.bounds)-CGRectGetWidth(_cursorView.bounds))/2;
        cursorViewFrame.origin.y = (CGRectGetHeight(btn.bounds)-btn.titleLabel.font.lineHeight)/2;
        _cursorView.frame = cursorViewFrame;
        [btn addSubview:_cursorView];
    }else _cursorView.hidden = YES;
    
    if (_hiddenTextField.text.length == _count) {
        weakSelf.codeInputFinish?
        weakSelf.codeInputFinish(weakSelf.hiddenTextField.text):NULL;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length < _codeShowButtons.count) {
        _cursorView.hidden = NO;
        UIButton *btn = _codeShowButtons[textField.text.length];
        CGRect cursorViewFrame = _cursorView.frame;
        cursorViewFrame.origin.x = (CGRectGetWidth(btn.bounds)-CGRectGetWidth(_cursorView.bounds))/2;
        cursorViewFrame.origin.y = (CGRectGetHeight(btn.bounds)-btn.titleLabel.font.lineHeight)/2;
        _cursorView.frame = cursorViewFrame;
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _hiddenTextField) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(textColor))]) {
            UIColor *textColor = change[NSKeyValueChangeNewKey];
            [self.codeShowButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleColor:textColor forState:UIControlStateNormal];
            }];
        }
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(font))]) {
            UIFont *font = change[NSKeyValueChangeNewKey];
            [self.codeShowButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.titleLabel.font = font;
            }];
            
            CGRect cursorViewFrame = _cursorView.frame;
            cursorViewFrame.origin.y = (CGRectGetHeight(self.codeShowButtons.firstObject.bounds)-_hiddenTextField.font.lineHeight)/2;
            cursorViewFrame.size.height = _hiddenTextField.font.lineHeight;
            _cursorView.frame = cursorViewFrame;
        }
    }
}
-(void)dealloc{
    [_hiddenTextField removeObserver:self forKeyPath:NSStringFromSelector(@selector(textColor))];
    [_hiddenTextField removeObserver:self forKeyPath:NSStringFromSelector(@selector(font))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
