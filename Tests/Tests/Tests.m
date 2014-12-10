@import XCTest;

#import "ANDYDataManager.h"

#import "NSManagedObjectContext+HYPSafeSave.h"

@interface Tests : XCTestCase

@end

@implementation Tests

+ (void)setUp
{
    [super setUp];

    [ANDYDataManager setModelBundle:[NSBundle bundleForClass:[self class]]];

    [ANDYDataManager setModelName:@"Model"];
}

- (void)testSafeSaveCorrectThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    [ANDYDataManager performInBackgroundContext:^(NSManagedObjectContext *context) {
        NSError *error = nil;
        XCTAssertNoThrow([context hyp_save:&error]);
        if (error) NSLog(@"error: %@", error);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

- (void)testSafeSaveWrongThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    [ANDYDataManager performInBackgroundContext:^(NSManagedObjectContext *context) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            XCTAssertThrowsSpecificNamed([context hyp_save:&error], NSException, HYPSafeSaveBackgroundThreadSavedInMainThreadException);
            if (error) NSLog(@"error: %@", error);

            [expectation fulfill];
        });
    }];

    [self waitForExpectationsWithTimeout:10.0f handler:nil];
}

@end
