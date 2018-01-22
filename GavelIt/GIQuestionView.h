#import <UIKit/UIKit.h>

#import "GIQuestionAnswerModel.h"

@protocol GIQuestionDelegate <NSObject>

- (void)nextQuestion;

@end

@interface GIQuestionView : UIView

@property(nonatomic, weak) NSObject<GIQuestionDelegate> *delegate;

- (instancetype)initWithQuestionAnswerModel:(GIQuestionAnswerModel *)qA;

- (void)setQuestionAnswer:(GIQuestionAnswerModel *)qA;

@end
