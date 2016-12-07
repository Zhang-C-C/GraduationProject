//
//  NSNull+IsNull.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/7.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "NSNull+IsNull.h"

@implementation NSNull (IsNull)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    
    if(sig == nil) {
        
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

@end
