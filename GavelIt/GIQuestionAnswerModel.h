#import <Foundation/Foundation.h>

@interface GIQuestionAnswerModel : NSObject

@property (nonatomic, strong) NSString *UniqueId;
@property (nonatomic, strong) NSNumber *TimeCreated;
@property (nonatomic, strong) NSString *Question;
@property (nonatomic, strong) NSString *FirstAnswer;
@property (nonatomic, strong) NSString *SecondAnswer;
@property (nonatomic, strong) NSNumber *VotestFirst;
@property (nonatomic, strong) NSNumber *VotestSecond;

@end
