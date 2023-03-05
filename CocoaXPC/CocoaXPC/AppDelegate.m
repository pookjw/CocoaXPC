//
//  AppDelegate.m
//  CocoaXPC
//
//  Created by Jinwoo Kim on 2/21/23.
//

#import "AppDelegate.h"
#import "CocoaXPCFramework.h"
#import "HelperTool.h"

@interface AppDelegate ()
@property (strong) NSXPCConnection *helperToolConnection;
@property (strong) NSXPCConnection *xpcServiceConnection;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self connectToXPCService];
    [(id<CocoaXPCFrameworkProtocol>)self.xpcServiceConnection.remoteObjectProxy conntectWithEndpointReply:^(NSXPCListenerEndpoint *e) {
        [(id<CocoaXPCFrameworkProtocol>)self.xpcServiceConnection.remoteObjectProxy getNumberWithReply:^(NSNumber *number) {
            NSLog(@"%@", number);
        }];
    }];
}

- (void)connectToXPCService {
    assert(NSThread.isMainThread);
    
    if (self.xpcServiceConnection == nil) {
        NSXPCConnection *xpcServiceConnection = [[NSXPCConnection alloc] initWithServiceName:@"com.pookjw.CocoaXPC.Framework"];
        xpcServiceConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(CocoaXPCFrameworkProtocol)];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        // We can ignore the retain cycle warning because a) the retain taken by the
        // invalidation handler block is released by us setting it to nil when the block
        // actually runs, and b) the retain taken by the block passed to -addOperationWithBlock:
        // will be released when that operation completes and the operation itself is deallocated
        // (notably self does not have a reference to the NSBlockOperation).
        xpcServiceConnection.invalidationHandler = ^{
            // If the connection gets invalidated then, on the main thread, nil out our
            // reference to it.  This ensures that we attempt to rebuild it the next time around.
            xpcServiceConnection.invalidationHandler = nil;
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                self.xpcServiceConnection = nil;
            }];
        };
#pragma clang diagnostic pop
        [xpcServiceConnection resume];
        self.xpcServiceConnection = xpcServiceConnection;
    }
}

@end
