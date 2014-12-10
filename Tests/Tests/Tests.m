@import XCTest;

#import "ANDYDataManager.h"

#import "NSManagedObjectContext+HYPSafeSave.h"

@interface ANDYDataManager (Private)

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

@interface Tests : XCTestCase

@end

@implementation Tests

+ (void)setUp
{
    [super setUp];

    [ANDYDataManager setModelBundle:[NSBundle bundleForClass:[self class]]];

    [ANDYDataManager setModelName:@"Model"];
}

- (void)testConfinementContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    context.persistentStoreCoordinator = [[ANDYDataManager sharedManager] persistentStoreCoordinator];

    NSError *error = nil;
    XCTAssertThrowsSpecificNamed([context hyp_save:&error],
                                 NSException,
                                 HYPSafeSaveNotRecommendedConcurrencyTypeException);
    if (error) NSLog(@"error: %@", error);
}

- (void)testMainThreadCorrectSave
{
    NSManagedObjectContext *context = [[ANDYDataManager sharedManager] mainContext];

    NSError *error = nil;
    XCTAssertNoThrow([context hyp_save:&error]);
    if (error) NSLog(@"error: %@", error);
}

- (void)testBackgroundThreadCorrectSave
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    [ANDYDataManager performInBackgroundContext:^(NSManagedObjectContext *context) {

        NSError *error = nil;
        XCTAssertNoThrow([context hyp_save:&error]);
        if (error) NSLog(@"error: %@", error);
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testMainThreadSavedInDifferentThread
{
    NSManagedObjectContext *context = [[ANDYDataManager sharedManager] mainContext];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSError *error = nil;
        XCTAssertThrowsSpecificNamed([context hyp_save:&error],
                                     NSException,
                                     HYPSafeSaveMainThreadSavedInDifferentThreadException);
        if (error) NSLog(@"error: %@", error);
        [expectation fulfill];

    });

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testBackgroundThreadSavedInMainThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    [ANDYDataManager performInBackgroundContext:^(NSManagedObjectContext *context) {
        dispatch_async(dispatch_get_main_queue(), ^{

            NSError *error = nil;
            XCTAssertThrowsSpecificNamed([context hyp_save:&error],
                                         NSException,
                                         HYPSafeSaveBackgroundThreadSavedInMainThreadException);
            if (error) NSLog(@"error: %@", error);
            [expectation fulfill];

        });
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

@end
