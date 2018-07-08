@import Firebase;
#import "GIUserStatsTableViewController.h"
#import "GIQuestionAnswerModel.h"


@interface GIUserStatsTableViewController ()

@end

@implementation GIUserStatsTableViewController {
    FIRDatabaseReference *_ref;
    NSMutableArray<GIQuestionAnswerModel *> *_voted;
    NSMutableArray<GIQuestionAnswerModel *> *_created;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"voteCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"createdCell"];
    _voted = [[NSMutableArray alloc] init];
    _created = [[NSMutableArray alloc] init];
    _ref = [[FIRDatabase database] reference];
    
    [[[_ref child:@"users"] child:[FIRAuth auth].currentUser.uid]  observeEventType:FIRDataEventTypeValue
                                                                          withBlock:
     ^(FIRDataSnapshot * _Nonnull snapshot) {
         NSDictionary *postDict = snapshot.value;
         NSArray *votedArray;
         if ([postDict class] != [NSNull class]) {
             votedArray = postDict[@"voted"];
         }
         for (NSDictionary *vote in votedArray) {
             [[[_ref child:@"questions"] child:vote[@"QuestionId"]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull voteData) {
                 NSMutableDictionary *questionData = voteData.value;
                 GIQuestionAnswerModel *question = [[GIQuestionAnswerModel alloc] init];
                 question.UniqueId = vote[@"QuestionId"];
                 question.Question = questionData[@"questionText"];
                 question.FirstAnswer = questionData[@"answer1"];
                 question.SecondAnswer = questionData[@"answer2"];
                 question.VotestFirst = questionData[@"votes1"];
                 question.VotestSecond = questionData[@"votes2"];
                 BOOL shouldAdd = YES;
                 for (int i = 0; i < _voted.count; i++) {
                     if ([_voted[i].UniqueId isEqualToString:question.UniqueId]) {
                         shouldAdd = NO;
                         _voted[i] = question;
                         break;
                     }
                 }
                 if (shouldAdd) {
                     [_voted addObject:question];
                 }
                 [self.tableView reloadData];
             }];
         }
         NSArray *createdArray;
         if ([postDict class] != [NSNull class]) {
             createdArray = postDict[@"created"];
         }
         for (NSString *createdId in createdArray) {
             [[[_ref child:@"questions"] child:createdId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull voteData) {
                 NSMutableDictionary *questionData = voteData.value;
                 GIQuestionAnswerModel *question = [[GIQuestionAnswerModel alloc] init];
                 question.UniqueId = createdId;
                 question.Question = questionData[@"questionText"];
                 question.FirstAnswer = questionData[@"answer1"];
                 question.SecondAnswer = questionData[@"answer2"];
                 question.VotestFirst = questionData[@"votes1"];
                 question.VotestSecond = questionData[@"votes2"];
                 BOOL shouldAdd = YES;
                 for (int i = 0; i < _created.count; i++) {
                     if ([_created[i].UniqueId isEqualToString:question.UniqueId]) {
                         shouldAdd = NO;
                         _created[i] = question;
                         break;
                     }
                 }
                 if (shouldAdd) {
                     [_created addObject:question];
                 }
                 [self.tableView reloadData];
             }];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numSections = 0;
    if (_voted.count > 0) {
        numSections++;
    }
    if (_created.count > 0) {
        numSections++;
    }
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _voted.count;
    } else {
        return _created.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:indexPath];
        cell.textLabel.text =[NSString stringWithFormat:@"%@ - %@", [_voted objectAtIndex:indexPath.row].Question, [_voted objectAtIndex:indexPath.row].VotestFirst];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"createdCell" forIndexPath:indexPath];
        cell.textLabel.text =[NSString stringWithFormat:@"%@ - %@", [_created objectAtIndex:indexPath.row].Question, [_created objectAtIndex:indexPath.row].VotestFirst];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Voted On:";
    }
    return @"Created:";
}

@end
