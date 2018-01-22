#import "GIAnswersView.h"
#import "GIAnswerView.h"

@interface GIAnswersView ()
@property (nonatomic, weak) NSObject<GIAnswersDelegate> *delegate;

@end
@implementation GIAnswersView {
    GIAnswerView *_a1;
    GIAnswerView *_a2;
}

- (instancetype)initWithAnswer1:(NSString *)a1 answer2:(NSString *)a2 delegate:(NSObject<GIAnswersDelegate> *)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _a1 = [[GIAnswerView alloc] initWithBackground:[[UIColor redColor] colorWithAlphaComponent:.7f] answer:a1];
        UITapGestureRecognizer *a1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answer1Tapped)];
        [_a1 addGestureRecognizer:a1Tap];
        _a2 = [[GIAnswerView alloc] initWithBackground:[[UIColor blueColor] colorWithAlphaComponent:.7f] answer:a2];
        UITapGestureRecognizer *a2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answer2Tapped)];
        [_a2 addGestureRecognizer:a2Tap];
        [self addSubview:_a1];
        [self addSubview:_a2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat answerWidth = self.frame.size.width / 2 - 10;
    _a1.frame = CGRectMake(0, 0, self.frame.size.width / 2 - 10, self.frame.size.height);
    _a2.frame = CGRectMake(_a1.frame.size.width + 20, 0, answerWidth, self.frame.size.height);
}

- (void)answer1Tapped {
    [self.delegate answerTapped:1];
}

- (void)answer2Tapped {
    [self.delegate answerTapped:2];
}

@end
