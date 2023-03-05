//
//  Common.h
//  CocoaXPC
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import <Foundation/Foundation.h>

@protocol HelperToolProtocol <NSObject>
- (void)connectWithEndpointReply:(void (^)(NSXPCListenerEndpoint *))reply;
- (void)getNumberWithReply:(void (^)(NSNumber *))reply;
@end
