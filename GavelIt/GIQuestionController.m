@import Firebase;
#import "GIQuestionController.h"

@implementation GIQuestionController {
    NSMutableArray<GIQuestionAnswerModel *> *_questions;
    NSObject<GIQuestionDisplay> *_questionDisplayer;
    BOOL _currentlyFetching;
    FIRDatabaseReference *_ref;
}

+ (instancetype)questionController {
    static GIQuestionController *questionController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        questionController = [[self alloc] init];
    });
    return questionController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _questions = [[NSMutableArray alloc] init];
        _ref = [[FIRDatabase database] reference];
        [self loadMoreQuestions];
    }
    return self;
}

- (GIQuestionAnswerModel *)nextQuestionQuestionDisplay:(NSObject<GIQuestionDisplay> *)questionDisplayer {
    _questionDisplayer = questionDisplayer;
    if (_questions.count > 0) {
        GIQuestionAnswerModel *question = [_questions firstObject];
        [_questions removeObjectAtIndex:0];
        return question;
    } else {
        if (!_currentlyFetching) {
            [self loadMoreQuestions];
        }
        return nil;
    }
}

- (void)loadMoreQuestions {
    _currentlyFetching = YES;
    [[_ref child:@"questions"]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        for (int i = 0; i < [postDict allKeys].count; i++) {
            NSString *currentKey = [postDict allKeys][i];
            NSMutableDictionary *questionData = postDict[currentKey];
            GIQuestionAnswerModel *question = [[GIQuestionAnswerModel alloc] init];
            question.UniqueId = currentKey;
            question.Question = questionData[@"questionText"];
            question.FirstAnswer = questionData[@"answer1"];
            question.SecondAnswer = questionData[@"answer2"];
            question.VotestFirst = questionData[@"votes1"];
            question.VotestSecond = questionData[@"votes2"];
            BOOL updatedQuestion = NO;
            for (int i = 0; i < _questions.count; i++) {
                if ([_questions[i].UniqueId isEqualToString:question.UniqueId]) {
                    _questions[i] = question;
                    updatedQuestion = YES;
                    break;
                }
            }
            if (!updatedQuestion) {
                [_questions addObject:question];
            }
        }
        _currentlyFetching = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
             [_questionDisplayer receivedQuestion:[_questions firstObject]];
             [_questions removeObjectAtIndex:0];
         });
    }];
}

@end
