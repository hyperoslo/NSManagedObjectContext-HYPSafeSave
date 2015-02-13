#import "NSManagedObjectContext+HYPSafeSave.h"

@implementation NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error
{
#if TARGET_IPHONE_SIMULATOR
    if (self.concurrencyType == NSConfinementConcurrencyType) {
        [NSException raise:HYPSafeSaveNotRecommendedConcurrencyTypeException
                    format:@"This NSManagedObjectContext is using a not recommended concurrencyType, please choose NSPrivateQueueConcurrencyType or NSMainQueueConcurrencyType."];
    } else if (self.concurrencyType == NSMainQueueConcurrencyType) {
        [NSException raise:HYPSafeSaveNotRecommendedSavingInMainThreadException
                    format:@"Main context was saved, saving is recommended in a backgroung thread, please make update in background thread and return an main thread updated version of your model."];
    } else {
        __block NSThread *currentThread = nil;

        if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
            [self performBlockAndWait:^{
                currentThread = [NSThread currentThread];
            }];
        } else {
            currentThread = [NSThread currentThread];
        }

        if ([currentThread isEqual:[NSThread mainThread]]) {
            [NSException raise:HYPSafeSaveBackgroundThreadSavedInMainThreadException
                        format:@"Background context saved in a main thread."];
        }
    }
#endif
    return [self save:error];
}

@end
