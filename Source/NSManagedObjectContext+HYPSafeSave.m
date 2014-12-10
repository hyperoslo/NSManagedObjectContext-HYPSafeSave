#import "NSManagedObjectContext+HYPSafeSave.h"

@implementation NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error
{
    //#if TARGET_IPHONE_SIMULATOR
    if (self.concurrencyType == NSConfinementConcurrencyType) {
        [NSException raise:HYPSafeSaveNotRecommendedConcurrencyTypeException
                    format:@"This NSManagedObjectContext is using a not recommended concurrencyType, please choose NSPrivateQueueConcurrencyType or NSMainQueueConcurrencyType."];
    } else {
        BOOL isMainThreadType = (self.concurrencyType == NSMainQueueConcurrencyType);

        __block NSThread *currentThread = nil;

        if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
            [self performBlockAndWait:^{
                currentThread = [NSThread currentThread];
            }];
        } else {
            currentThread = [NSThread currentThread];
        }

        if (isMainThreadType) {
            BOOL currentThreadIsDifferentThanMain = (![currentThread isEqual:[NSThread mainThread]]);
            if (currentThreadIsDifferentThanMain) {
                [NSException raise:HYPSafeSaveMainThreadSavedInDifferentThreadException
                            format:@"Main context saved in a background thread."];
            }
        } else {
            if ([currentThread isEqual:[NSThread mainThread]]) {
                [NSException raise:HYPSafeSaveBackgroundThreadSavedInMainThreadException
                            format:@"Background context saved in a main thread."];
            }
        }
    }
    //#endif
    return [self save:error];
}

@end
