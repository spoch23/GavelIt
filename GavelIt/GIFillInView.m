#import "GIFillInView.h"

@implementation GIFillInView {
    UILabel *_descriptionLabel;
    UITextView *_textView;
    UIButton *_nextButton;
}

- (instancetype)initWithDescription:(NSString *)descriptionFill buttonText:(NSString *)text {
    self = [super init];
    if (self) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.text = descriptionFill;
        _descriptionLabel.numberOfLines = 0;
        [self addSubview:_descriptionLabel];
        _textView = [[UITextView alloc] init];
        [self addSubview:_textView];
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:text forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextTapped) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.7];
        [self addSubview:_nextButton];
        [_nextButton sizeToFit];
        _nextButton.frame = CGRectMake(0, 0, _nextButton.frame.size.width + 20, _nextButton.frame.size.height);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_descriptionLabel sizeToFit];
    
    _descriptionLabel.frame = CGRectMake(self.frame.size.width / 2 - _descriptionLabel.frame.size.width / 2, 120, _descriptionLabel.frame.size.width, _descriptionLabel.frame.size.height);
    _textView.frame = CGRectMake(20, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 12, self.frame.size.width - 40, 60);
    _textView.layer.cornerRadius = 2;
    _textView.clipsToBounds = YES;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 1;
    _nextButton.frame = CGRectMake(_textView.frame.origin.x + _textView.frame.size.width - _nextButton.frame.size.width, _textView.frame.origin.y + _textView.frame.size.height + 12, _nextButton.frame.size.width, _nextButton.frame.size.height);
}

- (void)nextTapped {
    [self.delegate nextTappedWithResult:_textView.text];
}

@end
