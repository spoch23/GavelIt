#import <UIKit/UIKit.h>

@protocol GIAnswersDelegate <NSObject>

- (void)answerTapped:(int)answerNumber;

@end

@interface GIAnswersView : UIView

- (instancetype)initWithAnswer1:(NSString *)a1 answer2:(NSString *)a2 delegate:(NSObject<GIAnswersDelegate> *)delegate;

@end
