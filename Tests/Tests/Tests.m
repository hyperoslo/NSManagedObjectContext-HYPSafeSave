@import XCTest;

#import "DATAStack.h"

#import "NSManagedObjectContext+HYPSafeSave.h"

@interface DATAStack (Private)

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

@interface Tests : XCTestCase

@end

@implementation Tests

- (DATAStack *)dataStack
{
    DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"Tests"
                                                         bundle:[NSBundle bundleForClass:[self class]]
                                                      storeType:DATAStackInMemoryStoreType];

    return dataStack;
}

- (void)testConfinementContext
{
    DATAStack *dataStack = [self dataStack];

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    context.persistentStoreCoordinator = [dataStack persistentStoreCoordinator];

    NSError *error = nil;
    XCTAssertThrowsSpecificNamed([context save:&error],
                                 NSException,
                                 HYPSafeSaveNotRecommendedConcurrencyTypeException);
    if (error) NSLog(@"error: %@", error);
}

- (void)testMainThreadCorrectSave
{
    DATAStack *dataStack = [self dataStack];

    NSError *error = nil;
    XCTAssertThrowsSpecificNamed([dataStack.mainContext save:&error],
                                 NSException,
                                 HYPSafeSaveNotRecommendedSavingInMainThreadException);
    if (error) NSLog(@"error: %@", error);
}

- (void)testBackgroundThreadCorrectSave
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    DATAStack *dataStack = [self dataStack];

    [dataStack performInNewBackgroundContext:^(NSManagedObjectContext *backgroundContext) {
        NSError *error = nil;
        XCTAssertNoThrow([backgroundContext save:&error]);
        if (error) NSLog(@"error: %@", error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testMainThreadSavedInDifferentThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    DATAStack *dataStack = [self dataStack];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error = nil;
        XCTAssertThrowsSpecificNamed([dataStack.mainContext save:&error],
                                     NSException,
                                     HYPSafeSaveNotRecommendedSavingInMainThreadException);
        if (error) NSLog(@"error: %@", error);
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testBackgroundThreadSavedInMainThread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Saving expectations"];

    DATAStack *dataStack = [self dataStack];

    [dataStack performInNewBackgroundContext:^(NSManagedObjectContext *backgroundContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            XCTAssertThrowsSpecificNamed([backgroundContext save:&error],
                                         NSException,
                                         HYPSafeSaveBackgroundThreadSavedInMainThreadException);
            if (error) NSLog(@"error: %@", error);
            [expectation fulfill];
        });
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testSavingADisposableContext
{
    DATAStack *dataStack = [self dataStack];

    NSManagedObjectContext *disposableContext = [dataStack newDisposableMainContext];

    XCTAssertThrowsSpecificNamed([disposableContext save:nil],
                                 NSException,
                                 HYPSafeSaveNotRecommendedSavingInMainThreadException);
}

@end
