//
//  AppDelegate.m
//  CocoaXPC_2
//
//  Created by Jinwoo Kim on 3/5/23.
//

#import "AppDelegate.h"
#import <xpc/xpc.h>

@interface AppDelegate ()
@property (strong) xpc_object_t connection;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    xpc_connection_t connection = xpc_connection_create("com.pookjw.CocoaXPC.Service", dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0));
    xpc_connection_set_event_handler(connection, ^(xpc_object_t object) {
        NSLog(@"Test");
    });
    
    xpc_connection_resume(connection);
    xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_string(dictionary, "test", "test 1");
    
    xpc_connection_send_message(connection, dictionary);
    self.connection = connection;
}

@end
