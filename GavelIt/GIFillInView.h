#import <UIKit/UIKit.h>

@protocol GIFillDelegate <NSObject>

- (void)nextTappedWithResult:(NSString *)text;

@end

@interface GIFillInView : UIView

@property(nonatomic, weak) NSObject<GIFillDelegate> *delegate;

- (instancetype)initWithDescription:(NSString *)descriptionFill buttonText:(NSString *)text;

@end
