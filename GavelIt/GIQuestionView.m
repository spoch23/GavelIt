#import "GIQuestionView.h"
#import "GIAnswersView.h"
#import "GIResultsView.h"
#import "GIUserData.h"

@interface GIQuestionView ()<GIAnswersDelegate, GIResultDelegate>
@end

@implementation GIQuestionView {
    NSString *_a1;
    NSString *_a2;
    NSString *_question;
    UILabel *_questionLabel;
    UIView *_questionHolder;
    GIAnswersView *_answersView;
    GIResultsView *_resultView;
    BOOL _animating;
    GIQuestionAnswerModel *_qA;
    UIActivityIndicatorView *_spinner;
}

- (instancetype)initWithQuestionAnswerModel:(GIQuestionAnswerModel *)qA {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (qA) {
            _qA = qA;
            _question = qA.Question;
            _a1 = qA.FirstAnswer;
            _a2 = qA.SecondAnswer;
            _questionHolder = [[UIView alloc] init];
            _questionLabel = [[UILabel alloc] init];
            _questionLabel.text = _question;
            [self addSubview:_questionHolder];
            [_questionHolder addSubview:_questionLabel];
            _answersView = [[GIAnswersView alloc] initWithAnswer1:_a1 answer2:_a2 delegate:self];
            [self addSubview:_answersView];
        }
    }
    return self;
}

- (void)setQuestionAnswer:(GIQuestionAnswerModel *)qA {
    _qA = qA;
    _question = qA.Question;
    _a1 = qA.FirstAnswer;
    _a2 = qA.SecondAnswer;
    _questionHolder = [[UIView alloc] init];
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.text = _question;
    [self addSubview:_questionHolder];
    [_questionHolder addSubview:_questionLabel];
    self.backgroundColor = [UIColor whiteColor];
    _answersView = [[GIAnswersView alloc] initWithAnswer1:_a1 answer2:_a2 delegate:self];
    [self addSubview:_answersView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_qA) {
        if (!_spinner) {
            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self addSubview:_spinner];
            _spinner.center = self.center;
            [_spinner startAnimating];
        }
    } else {
        if (_spinner) {
            [_spinner removeFromSuperview];
            _spinner = nil;
        }
        _questionHolder.frame = CGRectMake(20, 60, self.frame.size.width - 40, 200);
        _questionHolder.backgroundColor = [UIColor lightGrayColor];
        _questionHolder.layer.cornerRadius = 2;
        _questionHolder.clipsToBounds = YES;
        CGSize size = [_questionLabel sizeThatFits:CGSizeMake(_questionHolder.frame.size.width - 20, _questionHolder.frame.size.height - 20)];
        if (!_animating) {
            _questionLabel.frame = CGRectMake((_questionHolder.frame.size.width - size.width) / 2, (_questionHolder.frame.size.height - size.height) / 2, size.width, size.height);
            _answersView.frame = CGRectMake(20, _questionHolder.frame.size.height + _questionHolder.frame.origin.y + 40, self.frame.size.width - 40, 250);
        }
    }
}

- (void)animationDone {
    [self.delegate nextQuestion];
}

- (void)answerTapped:(int)answerNumber {
    int val1 = (int)[_qA.VotestFirst integerValue];
    int val2 = (int)[_qA.VotestSecond integerValue];
    if (answerNumber == 1) {
        val1++;
        _qA.VotestFirst = [NSNumber numberWithInteger:val1];
    } else {
        val2++;
        _qA.VotestSecond = [NSNumber numberWithInteger:val2];
    }
//    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//    [[dynamoDBObjectMapper save:_qA]
//     continueWithBlock:^id(AWSTask *task) {
//         if (task.error) {
//             NSLog(@"The request failed. Error: [%@]", task.error);
//         } else {
//             //Do something with task.result or perform other operations.
//         }
//         return nil;
//     }];
//    [[GIUserData userData] addQuestionAnswered:_qA.UniqueId vote:answerNumber];
    
    _resultView = [[GIResultsView alloc] initWithCurrentResults:val1 answer2:val2];
    _resultView.delegate = self;
    [self addSubview:_resultView];
    _resultView.frame = CGRectMake(self.frame.size.width + 20,
                                   _questionHolder.frame.size.height + _questionHolder.frame.origin.y + 40,
                                   self.frame.size.width - 40, 240);
    CGFloat xS = -1 * self.frame.size.width;
    CGFloat yS = _answersView.frame.origin.y;
    CGFloat wS = _answersView.frame.size.width;
    CGFloat hS = _answersView.frame.size.height;
    CGFloat xR = 20;
    CGFloat yR = _questionHolder.frame.size.height + _questionHolder.frame.origin.y + 40;
    CGFloat wR = self.frame.size.width - 40;
    CGFloat hR = 240;
    _animating = YES;
    [UIView animateWithDuration:1 animations:^{
        _answersView.frame = CGRectMake(xS, yS, wS, hS);
        _resultView.frame = CGRectMake(xR, yR, wR, hR);
    } completion:^(BOOL finished) {
        _animating = NO;
        [_answersView removeFromSuperview];
        [_resultView animateResults];
    }];
}

@end
