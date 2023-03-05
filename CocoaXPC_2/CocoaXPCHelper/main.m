//
//  main.m
//  CocoaXPCHelper
//
//  Created by Jinwoo Kim on 3/5/23.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

int main(int argc, const char * argv[]) {
    xpc_connection_t listener = xpc_connection_create_mach_service("com.pookjw.CocoaXPC.Helper", NULL, XPC_CONNECTION_MACH_SERVICE_LISTENER);

    xpc_connection_set_event_handler(listener, ^(xpc_object_t  _Nonnull event) {
        
        xpc_connection_set_event_handler((xpc_connection_t)event, ^(xpc_object_t  _Nonnull object) {
            xpc_type_t type = xpc_get_type(object);

            if (type == XPC_TYPE_DICTIONARY) {
                xpc_connection_t source = xpc_dictionary_get_remote_connection(object);
                xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
                xpc_dictionary_set_string(dictionary, "test", "GOOD");
                xpc_connection_send_message(source, dictionary);
            }
        });
        
        xpc_connection_resume(xpc_retain(event));
    });

    xpc_connection_resume(xpc_retain(listener));
    dispatch_main();

    return EXIT_FAILURE;
}
