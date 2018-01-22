#import "ViewController.h"
#import "GIQuestionView.h"
#import "GIMakeQuestionViewController.h"
#import "GIQuestionController.h"

@interface ViewController ()<GIQuestionDelegate, GIQuestionDisplay>

@end

@implementation ViewController

- (void)loadView {
    GIQuestionAnswerModel *question = [[GIQuestionController questionController] nextQuestionQuestionDisplay:self];
    self.view = [[GIQuestionView alloc] initWithQuestionAnswerModel:question];
    ((GIQuestionView *)self.view).delegate = self;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(makeNewQuestion)];
}

- (void)makeNewQuestion {
    [self.navigationController pushViewController:[[GIMakeQuestionViewController alloc] init] animated:YES];
}

- (void)nextQuestion {
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}

- (void)receivedQuestion:(GIQuestionAnswerModel *)nextQuestion {
    [(GIQuestionView *)self.view setQuestionAnswer:nextQuestion];
}

@end
