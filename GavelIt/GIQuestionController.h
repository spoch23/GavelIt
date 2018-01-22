#import <Foundation/Foundation.h>
#import "GIQuestionAnswerModel.h"

@protocol GIQuestionDisplay <NSObject>

- (void)receivedQuestion:(GIQuestionAnswerModel *)nextQuestion;

@end

@interface GIQuestionController : NSObject

+ (instancetype)questionController;

- (GIQuestionAnswerModel *)nextQuestionQuestionDisplay:(NSObject<GIQuestionDisplay> *)questionDisplayer;

@end
