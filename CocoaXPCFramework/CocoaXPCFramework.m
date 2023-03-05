//
//  CocoaXPCFramework.m
//  CocoaXPCFramework
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import "CocoaXPCFramework.h"
#import "Common.h"

@interface CocoaXPCFramework () <NSXPCListenerDelegate, CocoaXPCFrameworkProtocol>
@property (strong) NSXPCListener *listener;
@property (strong) NSOperationQueue *queue;
@property (strong) NSXPCConnection *helperToolConnection; // only accessed or modified by operations on self.queue
@end

@implementation CocoaXPCFramework

- (instancetype)init {
    if (self = [super init]) {
        NSXPCListener *listener = [NSXPCListener serviceListener];
        listener.delegate = self;
        self.listener = listener;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 1;
        self.queue = queue;
    }
    
    return self;
}

- (void)run {
    [self.listener resume];
}

#pragma mark - NSXPCListenerDelegate

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    assert([listener isEqual:self.listener]);
    assert(newConnection != nil);
    
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(CocoaXPCFrameworkProtocol)];
    newConnection.exportedObject = self;
    [newConnection resume];
    
    return YES;
}

#pragma mark - CocoaXPCFrameworkProtocol

- (void)conntectWithEndpointReply:(void (^)(NSXPCListenerEndpoint *))reply {
    [self.queue addOperationWithBlock:^{
        NSXPCConnection *helperToolConnection;
        
        if (self.helperToolConnection) {
            helperToolConnection = self.helperToolConnection;
        } else {
            helperToolConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.pookjw.CocoaXPC.Helper" options:NSXPCConnectionPrivileged];
            helperToolConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperToolProtocol)];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
            // We can ignore the retain cycle warning because a) the retain taken by the
            // invalidation handler block is released by us setting it to nil when the block
            // actually runs, and b) the retain taken by the block passed to -addOperationWithBlock:
            // will be released when that operation completes and the operation itself is deallocated
            // (notably self does not have a reference to the NSBlockOperation).
            helperToolConnection.invalidationHandler = ^{
                helperToolConnection.invalidationHandler = nil;
                [self.queue addOperationWithBlock:^{
                    self.helperToolConnection = nil;
                }];
            };
#pragma clang diagnostic pop
            
            [helperToolConnection resume];
            self.helperToolConnection = helperToolConnection;
        }
        
        //
        
        id<HelperToolProtocol> remoteObject = [helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.userInfo);
            reply(nil);
        }];
        
        [remoteObject connectWithEndpointReply:reply];
    }];
}

- (void)getNumberWithReply:(void (^)(NSNumber *))reply {
    [(id<HelperToolProtocol>)self.helperToolConnection.remoteObjectProxy getNumberWithReply:reply];
}

@end
