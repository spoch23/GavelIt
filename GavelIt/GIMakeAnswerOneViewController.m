#import "GIMakeAnswerOneViewController.h"

#import "GIFillInView.h"
#import "GIMakeFinalAnswerViewController.h"

@interface GIMakeAnswerOneViewController ()<GIFillDelegate>

@end

@implementation GIMakeAnswerOneViewController {
    NSString *_questionText;
}

- (instancetype)initWithQuestionResult:(NSString *)question {
    self = [super init];
    if (self) {
        _questionText = question;
    }
    return self;
}

- (void)loadView {
    self.view = [[GIFillInView alloc] initWithDescription:@"Answer One" buttonText:@"Next"];
    ((GIFillInView *)self.view).delegate = self;
}

- (void)nextTappedWithResult:(NSString *)text {
    [self.navigationController pushViewController:[[GIMakeFinalAnswerViewController alloc] initWithQuestionResult:_questionText answerOne:text] animated:YES];
}

@end
