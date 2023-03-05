//
//  main.m
//  CocoaXPCService
//
//  Created by Jinwoo Kim on 3/5/23.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

static void new_connection_handler(xpc_connection_t peer) {
    xpc_connection_set_event_handler(peer, ^(xpc_object_t  _Nonnull event) {
        xpc_type_t type = xpc_get_type(event);
        
        if (type == XPC_TYPE_DICTIONARY) {
            const char *value = xpc_dictionary_get_string(event, "test");
            NSLog(@"%s", value);
            
            xpc_object_t test = xpc_dictionary_create(NULL, NULL, 0);
            xpc_dictionary_set_string(test, "test", "test");
//            xpc_connection_send_message(peer, test);
            
            xpc_connection_t connection = xpc_connection_create_mach_service("com.pookjw.CocoaXPC.Helper", NULL, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
            xpc_connection_set_event_handler(connection, ^(xpc_object_t object) {
                xpc_connection_send_message(peer, object);
                //            const char *error = xpc_dictionary_get_string(reply, XPC_ERROR_KEY_DESCRIPTION);
                //            NSLog(@"%s", error);
            });
            
            xpc_connection_resume(xpc_retain(connection));
            xpc_connection_send_message(connection, test);
        }
    });
    
    // xpc_retain is not available on ARC.
    xpc_connection_resume(xpc_retain(peer));
//    xpc_connection_resume(peer);
}

int main(int argc, const char *argv[]) {
    xpc_main(new_connection_handler);
    return EXIT_FAILURE;
}
