//
//  CocoaXPCFramework.h
//  CocoaXPCFramework
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import <Foundation/Foundation.h>

@protocol CocoaXPCFrameworkProtocol <NSObject>
- (void)conntectWithEndpointReply:(void (^)(NSXPCListenerEndpoint *))reply;
- (void)getNumberWithReply:(void (^)(NSNumber *))reply;
@end

@interface CocoaXPCFramework : NSObject
- (void)run;
@end
