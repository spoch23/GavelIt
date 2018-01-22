#import <Foundation/Foundation.h>

@interface GIUserData : NSObject

+ (GIUserData *)userData;

- (void)addQuestionCreated:(NSString *)uuid;

- (void)addQuestionAnswered:(NSString *)uuid vote:(int)vote;

@end
