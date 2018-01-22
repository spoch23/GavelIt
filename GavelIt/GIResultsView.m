#import "GIResultsView.h"

@implementation GIResultsView{
    UIView *_a1Result;
    UIView *_a2Result;
    UILabel *_a1Label;
    UILabel *_a2Label;
    int _a1Val;
    int _a2Val;
    BOOL _animating;
    double _a1ValIncrease;
    double _a1CurrentVal;
    double _a2CurrentVal;
    CGFloat _a1finalVal;
    double _a2ValIncrease;
    NSTimer *_timer;
}

- (instancetype)initWithCurrentResults:(int)a1 answer2:(int)a2 {
    self = [super init];
    if (self) {
        _a1Val = a1;
        _a2Val = a2;
        _a1Result = [[UIView alloc] init];
        _a1Result.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.7];
        _a2Result = [[UIView alloc] init];
        _a2Result.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.7];
        _a1Label = [[UILabel alloc] init];
        _a1Label.text = @"50%";
        _a1Label.textColor = [[UIColor redColor] colorWithAlphaComponent:.7];
        _a2Label = [[UILabel alloc] init];
        _a2Label.text = @"50%";
        _a2Label.textColor = [[UIColor blueColor] colorWithAlphaComponent:.7];
        [self addSubview:_a1Label];
        [self addSubview:_a2Label];
        [self addSubview:_a2Result];
        [self addSubview:_a1Result];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_animating) {
        _a2Result.frame = CGRectMake(0, self.frame.size.height / 2 - 40, self.frame.size.width, 80);
        _a1Result.frame = CGRectMake(0, self.frame.size.height / 2 - 40, self.frame.size.width / 2, 80);
        [_a1Label sizeToFit];
        [_a2Label sizeToFit];
        _a1Label.frame = CGRectMake(self.frame.size.width / 4 - _a1Label.frame.size.width / 2, self.frame.size.height / 2 - 40 - _a1Label.frame.size.height - 10, _a1Label.frame.size.width, _a1Label.frame.size.height);
        _a2Label.frame = CGRectMake(self.frame.size.width * 3 / 4 - _a2Label.frame.size.width / 2, self.frame.size.height / 2 - 40 - _a2Label.frame.size.height - 10, _a2Label.frame.size.width, _a2Label.frame.size.height);
    }
}

- (void)redoLabels {
    _a1CurrentVal += _a1ValIncrease;
    BOOL done = NO;
    if ((_a1ValIncrease > 0 && _a1CurrentVal >= _a1finalVal) || (_a1ValIncrease < 0 && _a1CurrentVal <= _a1finalVal) ) {
        _a1CurrentVal = _a1finalVal;
        done = YES;
    }
    NSString * allDigits = [NSString stringWithFormat:@"%f", _a1CurrentVal];
    NSString * topDigits = [allDigits substringToIndex:4];
    topDigits = [topDigits stringByAppendingString:@"%"];
    double leftOverDouble = 100 - [topDigits doubleValue];
    _a1Label.text = topDigits;
    [_a1Label sizeToFit];
    NSString * allDigits2 = [NSString stringWithFormat:@"%f", leftOverDouble];
    NSString * topDigits2 = [allDigits2 substringToIndex:4];
    topDigits2 = [topDigits2 stringByAppendingString:@"%"];
    _a2Label.text = topDigits2;
    [_a2Label sizeToFit];
    if (done) {
        [_timer invalidate];
    }
}

- (void)animateResults {
    CGFloat percentage = ((CGFloat)_a1Val) / ((CGFloat)(_a1Val + _a2Val));
    CGFloat width = self.frame.size.width * percentage;
    _a1finalVal = percentage * 100;
    _a1ValIncrease = (_a1finalVal - 50.0f) / 20.0f;
    _a2ValIncrease = ((100.0f - _a1finalVal) - 50.0f) / 20.0f;
    _a1CurrentVal = 50.0f;
    _a2CurrentVal = 50.0f;
    _animating = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(redoLabels) userInfo:nil repeats:YES];
    [_timer fire];
    [UIView animateWithDuration:2 animations:^{
        _a1Result.frame = CGRectMake(0, self.frame.size.height / 2 - 40, width, 80);
    } completion:^(BOOL finished) {
        _animating = NO;
        [self performSelector:@selector(animationFinished) withObject:nil afterDelay:1];
    }];
}

- (void)animationFinished {
    [self.delegate animationDone];
}

@end
