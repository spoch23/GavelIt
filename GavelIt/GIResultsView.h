#import <UIKit/UIKit.h>

@protocol GIResultDelegate <NSObject>

- (void)animationDone;

@end

@interface GIResultsView : UIView

@property(nonatomic, weak) NSObject<GIResultDelegate> *delegate;

- (instancetype)initWithCurrentResults:(int)a1 answer2:(int)a2;

- (void)animateResults;

@end
