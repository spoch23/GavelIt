#import "GIAnswerView.h"

@implementation GIAnswerView {
    UILabel *_answerLabel;
}

- (instancetype)initWithBackground:(UIColor *)bg answer:(NSString *)answer {
    self = [super init];
    if (self) {
        self.backgroundColor = bg;
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.text = answer;
        [self addSubview:_answerLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    _answerLabel.numberOfLines = 0;
    CGSize size = [_answerLabel sizeThatFits:CGSizeMake(self.frame.size.width - 20, self.frame.size.height - 20)];
    _answerLabel.frame = CGRectMake((self.frame.size.width - size.width) / 2, (self.frame.size.height - size.height) / 2, size.width, size.height);
}

@end
