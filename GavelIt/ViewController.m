#import "ViewController.h"
#import "GIQuestionView.h"
#import "GIMakeQuestionViewController.h"
#import "GIQuestionController.h"
#import "GIUserStatsTableViewController.h"
#import "GIQuestionAnswerModel.h"

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"User"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(seeUserStats)];
}

- (void)makeNewQuestion {
    [self.navigationController pushViewController:[[GIMakeQuestionViewController alloc] init] animated:YES];
}

- (void)seeUserStats {
    [self.navigationController pushViewController:[[GIUserStatsTableViewController alloc] initWithStyle:UITableViewStylePlain] animated:YES];
}

- (void)nextQuestion {
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}

- (void)shareTappedWithQuestionAnswerModel:(GIQuestionAnswerModel *)qA {
    NSMutableString *shareString = [NSMutableString stringWithString:@"http://www.gavelitapp.com/"];
    [shareString appendString:qA.UniqueId];
    NSURL *shareURL = [NSURL URLWithString:shareString];
    NSString *shareText = [NSString stringWithFormat:@"I found this great question on gavelIt: %@ What's your answer? %@", qA.Question, shareURL];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:@[shareText]
                                                                                             applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

- (void)receivedQuestion:(GIQuestionAnswerModel *)nextQuestion {
    [(GIQuestionView *)self.view setQuestionAnswer:nextQuestion];
}

@end
