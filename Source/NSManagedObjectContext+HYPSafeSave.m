#import "NSManagedObjectContext+HYPSafeSave.h"

@implementation NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error
{
#if TARGET_IPHONE_SIMULATOR
    BOOL wasMainThread = [NSThread isMainThread];

    [self performBlockAndWait:^{
        NSThread *currentThread = [NSThread currentThread];

        if (wasMainThread) {
            if (![currentThread isEqual:[NSThread mainThread]]) {
                [NSException raise:@"HYPSafeSave_MAIN_THREAD_SAVING_EXCEPTION"
                            format:@"Main context saved in a background thread."];
            }
        } else {
            if ([currentThread isEqual:[NSThread mainThread]]) {
                [NSException raise:@"HYPSafeSave_BACKGROUND_THREAD_SAVING_EXCEPTION"
                            format:@"Background context saved in a main thread."];
            }
        }
    }];
#endif
    return [self save:error];
}

@end
