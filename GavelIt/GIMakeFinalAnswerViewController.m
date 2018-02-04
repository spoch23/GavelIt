#import "GIMakeFinalAnswerViewController.h"

@import Firebase;

#import "ViewController.h"
#import "GIFillInView.h"
#import "GIQuestionAnswerModel.h"
#import "GIUserData.h"

@interface GIMakeFinalAnswerViewController ()<GIFillDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation GIMakeFinalAnswerViewController {
    NSString *_questionText;
    NSString *_answerText;
}

- (instancetype)initWithQuestionResult:(NSString *)question answerOne:(NSString *)answerOne {
    self = [super init];
    if (self) {
        _questionText = question;
        _answerText = answerOne;
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

- (void)loadView {
    self.view = [[GIFillInView alloc] initWithDescription:@"Answer Two" buttonText:@"Submit"];
    ((GIFillInView *)self.view).delegate = self;
}

- (void)nextTappedWithResult:(NSString *)text {
    NSMutableDictionary *questionModel = [[NSMutableDictionary alloc] init];
    questionModel[@"questionText"] = _questionText;
    questionModel[@"answer1"] = _answerText;
    questionModel[@"answer2"] = text;
    questionModel[@"votes1"] = @(0);
    questionModel[@"votes2"] = @(0);
    NSString *uniqueId = [[[self.ref child:@"questions"] childByAutoId] key];
    [[[self.ref child:@"questions"] child:uniqueId] setValue:questionModel];
    [[[self.ref child:@"users"] child:[FIRAuth auth].currentUser.uid]
     runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            post = [[NSMutableDictionary alloc] init];
        }
        
        NSMutableArray *createdQuestions = post[@"created"];
        if (!createdQuestions) {
            createdQuestions = [[NSMutableArray alloc] initWithCapacity:1];
        }
         [createdQuestions addObject:uniqueId];
        post[@"created"] = createdQuestions;
        
        // Set value and report transaction success
        currentData.value = post;
        return [FIRTransactionResult successWithValue:currentData];
     }
     andCompletionBlock:^(NSError * _Nullable error,
                        BOOL committed,
                        FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error) {
           NSLog(@"%@", error.localizedDescription);
        }
     }];
    
    
    //    [[GIUserData userData] addQuestionCreated:qA.UniqueId];
    
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}

@end
