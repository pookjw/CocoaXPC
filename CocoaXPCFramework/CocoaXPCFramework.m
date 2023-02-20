//
//  CocoaXPCFramework.m
//  CocoaXPCFramework
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import "CocoaXPCFramework.h"

@implementation CocoaXPCFramework

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
