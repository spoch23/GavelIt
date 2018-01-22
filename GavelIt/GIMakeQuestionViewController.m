#import "GIMakeQuestionViewController.h"

#import "GIFillInView.h"
#import "GIMakeAnswerOneViewController.h"

@interface GIMakeQuestionViewController ()<GIFillDelegate>

@end

@implementation GIMakeQuestionViewController

- (void)loadView {
    self.view = [[GIFillInView alloc] initWithDescription:@"Question" buttonText:@"Next"];
    ((GIFillInView *)self.view).delegate = self;
}

- (void)nextTappedWithResult:(NSString *)text {
    [self.navigationController pushViewController:[[GIMakeAnswerOneViewController alloc] initWithQuestionResult:text] animated:YES];
}

@end
