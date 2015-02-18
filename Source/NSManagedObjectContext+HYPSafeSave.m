#import "NSManagedObjectContext+HYPSafeSave.h"
#import <objc/runtime.h>

@implementation NSManagedObjectContext (HYPSafeSave)

- (BOOL)hyp_save:(NSError * __autoreleasing *)error
{
#if TARGET_IPHONE_SIMULATOR
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
#endif
    return [self hyp_save:error];
}

+ (void)load
{
    [super load];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleClass:[self class] originalSelector:@selector(save:) swizzledSelector:@selector(hyp_save:) instanceMethod:YES];
    });
}

+ (void)swizzleClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector instanceMethod:(BOOL)instanceMethod
{
    if (class) {
        Method originalMethod;
        Method swizzledMethod;
        if (instanceMethod) {
            originalMethod = class_getInstanceMethod(class, originalSelector);
            swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        } else {
            originalMethod = class_getClassMethod(class, originalSelector);
            swizzledMethod = class_getClassMethod(class, swizzledSelector);
        }

        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

@end
