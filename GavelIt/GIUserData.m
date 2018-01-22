#import "GIUserData.h"

@interface GIUserData ()

//@property(nonatomic) AWSCognitoDataset *personalData;

@end

@implementation GIUserData

- (instancetype)init {
    self = [super init];
    if (self) {
//        _personalData = [[AWSCognito defaultCognito] openOrCreateDataset:@"user"];
//        [_personalData synchronizeOnConnectivity];
    }
    return self;
}

+ (GIUserData *)userData {
    static GIUserData *sharedUserData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserData = [[GIUserData alloc] init];
    });
    return sharedUserData;
}

- (void)addQuestionCreated:(NSString *)uuid {
//    GIUserData *userData = [GIUserData userData];
//    NSMutableArray *createdArray = [userData.personalData valueForKey:@"created"];
//    if (createdArray) {
//        [createdArray addObject:uuid];
//    } else {
//        createdArray = [[NSMutableArray alloc] init];
//        [createdArray addObject:uuid];
//    }
//    [userData.personalData setValue:createdArray forKey:@"created"];
//    [userData.personalData synchronizeOnConnectivity];
}

- (void)addQuestionAnswered:(NSString *)uuid vote:(int)vote {
//    GIUserData *userData = [GIUserData userData];
//    NSMutableArray *answersArray = [userData.personalData mutableArrayValueForKey:@"answered"];
//    if (answersArray) {
//        [answersArray addObject:uuid];
//    } else {
//        answersArray = [[NSMutableArray alloc] init];
//        [answersArray addObject:uuid];
//    }
//    [userData.personalData setValue:[NSNumber numberWithInteger:vote] forKey:uuid];
//    [userData.personalData setValue:answersArray forKey:@"answered"];
//    [userData.personalData synchronizeOnConnectivity];
}


@end
