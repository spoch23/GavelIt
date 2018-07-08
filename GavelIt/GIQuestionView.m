@import Firebase;
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
    FIRDatabaseReference *_ref;
    UIButton *_shareButtton;
}

- (instancetype)initWithQuestionAnswerModel:(GIQuestionAnswerModel *)qA {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _ref = [[FIRDatabase database] reference];
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
            _shareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_shareButtton setTitle:@"Share" forState:UIControlStateNormal];
            [_shareButtton addTarget:self
                              action:@selector(share)
                    forControlEvents:UIControlEventTouchUpInside];
            [_shareButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:_shareButtton];
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
    _shareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButtton setTitle:@"Share" forState:UIControlStateNormal];
    [_shareButtton addTarget:self
                      action:@selector(share)
            forControlEvents:UIControlEventTouchUpInside];
    [_shareButtton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_shareButtton];
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
            [_shareButtton sizeToFit];
            _shareButtton.frame = CGRectMake((self.frame.size.width - _shareButtton.frame.size.width) / 2, _answersView.frame.size.height + _answersView.frame.origin.y + 20, _shareButtton.frame.size.width, _shareButtton.frame.size.height);
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
    [[[_ref child:@"questions"] child:_qA.UniqueId]
     runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
         NSMutableDictionary *post = currentData.value;
         if (!post || [post isEqual:[NSNull null]]) {
             return [FIRTransactionResult successWithValue:currentData];
         }
         
         if (answerNumber == 1) {
             NSNumber *votes1 = post[@"votes1"];
             uint calculatedVotes = [votes1 unsignedIntValue] + 1;
             post[@"votes1"] = @(calculatedVotes);
         } else {
             NSNumber *votes2 = post[@"votes2"];
             uint calculatedVotes = [votes2 unsignedIntValue] + 1;
             post[@"votes2"] = @(calculatedVotes);
         }
         
         // Set value and report transaction success
         currentData.value = post;
         return [FIRTransactionResult successWithValue:currentData];
     }
     andCompletionBlock:^(NSError * _Nullable error,
                          BOOL committed,
                          FIRDataSnapshot * _Nullable snapshot) {
         // Transaction completed
         if (error) {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
    [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid]
     runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
         NSMutableDictionary *post = currentData.value;
         if (!post || [post isEqual:[NSNull null]]) {
             post = [[NSMutableDictionary alloc] init];
         }
         
         NSMutableArray *votedQuestions = post[@"voted"];
         if (!votedQuestions) {
             votedQuestions = [[NSMutableArray alloc] initWithCapacity:1];
         }
         NSMutableDictionary *questionVotedOn = [[NSMutableDictionary alloc] init];
         questionVotedOn[@"QuestionId"] = _qA.UniqueId;
         if (answerNumber == 1) {
             questionVotedOn[@"Voted"] = @"first";
         } else {
             questionVotedOn[@"Voted"] = @"second";
         }
         [votedQuestions addObject:questionVotedOn];
         post[@"voted"] = votedQuestions;
         
         // Set value and report transaction success
         currentData.value = post;
         return [FIRTransactionResult successWithValue:currentData];
     }
     andCompletionBlock:^(NSError * _Nullable error,
                          BOOL committed,
                          FIRDataSnapshot * _Nullable snapshot) {
         // Transaction completed
         if (error) {
             NSLog(@"%@", error.localizedDescription);
         }
     }];

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

- (void)share {
    [self.delegate shareTappedWithQuestionAnswerModel:_qA];
}

@end
