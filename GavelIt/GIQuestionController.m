#import "GIQuestionController.h"


@implementation GIQuestionController {
    NSMutableArray<GIQuestionAnswerModel *> *_questions;
    NSObject<GIQuestionDisplay> *_questionDisplayer;
    BOOL _currentlyFetching;
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
        GIQuestionAnswerModel *question = [[GIQuestionAnswerModel alloc] init];
        question.UniqueId = @"123";
        question.TimeCreated = @(1);
        question.Question = @"Should I play assasins creed?";
        question.FirstAnswer = @"Yes, it is your game. Go play.";
        question.SecondAnswer = @"No. Get a life you loser this is actually work.";
        question.VotestFirst = @(50);
        question.VotestSecond = @(50);
        return question;
    }
}

- (void)loadMoreQuestions {
    _currentlyFetching = YES;
//    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
//
//    [[dynamoDBObjectMapper scan:[GIQuestionAnswerModel class]
//                 expression:scanExpression]
//    continueWithBlock:^id(AWSTask *task) {
//        _currentlyFetching = NO;
//         if (task.error) {
//             NSLog(@"The request failed. Error: [%@]", task.error);
//         } else {
//             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
//             _questions = [NSMutableArray arrayWithArray:paginatedOutput.items];
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [_questionDisplayer receivedQuestion:[_questions firstObject]];
//                 [_questions removeObjectAtIndex:0];
//             });
//         }
//         return nil;
//     }];
}

@end
