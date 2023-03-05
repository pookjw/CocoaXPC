//
//  HelperTool.m
//  CocoaXPCHelper
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import "HelperTool.h"
#import "Common.h"

@interface HelperTool () <NSXPCListenerDelegate, HelperToolProtocol>
@property (strong) NSXPCListener *listener;
@end

@implementation HelperTool

- (instancetype)init {
    if (self = [super init]) {
        NSXPCListener *listener = [[NSXPCListener alloc] initWithMachServiceName:@"com.pookjw.CocoaXPC.Helper"];
        listener.delegate = self;
        self.listener = listener;
    }
    
    return self;
}

- (void)run {
    [self.listener resume];
    [NSRunLoop.currentRunLoop run];
}

#pragma mark - NSXPCListenerDelegate

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    assert([listener isEqual:self.listener]);
    assert(newConnection != nil);
    
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperToolProtocol)];
    newConnection.exportedObject = self;
    [newConnection resume];
    
    return YES;
}

#pragma mark - HelperToolProtocol

- (void)connectWithEndpointReply:(void (^)(NSXPCListenerEndpoint *))reply {
    reply([self.listener endpoint]);
}

- (void)getNumberWithReply:(void (^)(NSNumber *))reply {
    reply(@3);
}

@end
