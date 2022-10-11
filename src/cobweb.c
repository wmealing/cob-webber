/* Credit where credit is due, this is stolen from:
   https://github.com/cloudflare/cobweb/ */

#include <stddef.h> 
#include <libcob.h>
#include <emscripten.h>

// CobWeb runtime with JavaScript implementations
#define set_http_status js_set_http_status
#define set_http_body js_set_http_body
#define append_http_body js_append_http_body
#define get_http_form js_get_http_form
/* TODO:  need to add the lumen functions */


#define cob_nop() do {} while(0)
// #define likely(x)       __builtin_expect((x),1)
// #define unlikely(x)     __builtin_expect((x),0)


EM_JS(int, js_set_http_status, (void* code), {
    const get_string = Module.cwrap('get_string', 'string', ['number']);
    globalThis.response.status = parseInt(get_string(code));
});

EM_JS(int, js_append_http_body, (void* body), {
    const get_string = Module.cwrap('get_string', 'string', ['number']);
    globalThis.response.body += get_string(body);
});

EM_JS(int, js_set_http_body, (void* body), {
    const get_string = Module.cwrap('get_string', 'string', ['number']);
    globalThis.response.body = get_string(body);
});

EM_JS(int, js_get_http_form, (void* name), {
    const get_string = Module.cwrap('get_string', 'string', ['number']);
    const v = globalThis.request.params[get_string(name)];
    if (v === undefined) {
        return 0;
    } else {
        return v;
    }
});

const char* get_string(void* ptr) {
    return ptr;
}

#include "generated.c"

// program entry point
int entry()
{
    cob_init(0, NULL);
    HELLO_WORLD();
    return 0;
}
