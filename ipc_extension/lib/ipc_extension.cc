#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "include/dart_api.h"
#include "include/dart_native_api.h"
#include "client-sdk/displayServiceClient.h"
#include <iostream>

#define HandleError(handle)          \
    if (Dart_IsError(handle))        \
    {                                \
        Dart_PropagateError(handle); \
    }                                


Dart_NativeFunction ResolveName(Dart_Handle name,
                                int argc,
                                bool *auto_setup_scope);

DART_EXPORT Dart_Handle ipc_extension_Init(Dart_Handle parent_library)
{
    if (Dart_IsError(parent_library))
    {
        return parent_library;
    }

    Dart_Handle result_code =
        Dart_SetNativeResolver(parent_library, ResolveName, NULL);
    if (Dart_IsError(result_code))
    {
        return result_code;
    }

    return Dart_Null();
}

// Dart_Handle HandleError(Dart_Handle handle)
// {
//     if (Dart_IsError(handle))
//     {
//         Dart_PropagateError(handle);
//     }
//     return handle;
// }


void setDesktopWindow(Dart_NativeArguments arguments)
{
    Dart_EnterScope();
    
    std::cout << "setDesktopWindow" << std::endl;

    const char *title;

    HandleError(Dart_StringToCString(arguments[0], &title));

    // setDesktopWindow(title);
    Dart_ExitScope();
}

void setDrawerWindow(Dart_NativeArguments arguments)
{
    Dart_EnterScope();
    std::cout << "setDrawerWindow" << std::endl;
    //   Dart_Handle result = HandleError(Dart_NewInteger(rand()));
    //   Dart_SetReturnValue(arguments, result);
    Dart_ExitScope();
}

void setWindowSource(Dart_NativeArguments arguments)
{
    Dart_EnterScope();
    std::cout << "setWindowSource" << std::endl;
    //   Dart_Handle result = HandleError(Dart_NewInteger(rand()));
    //   Dart_SetReturnValue(arguments, result);
    Dart_ExitScope();
}

void flush(Dart_NativeArguments arguments)
{
    Dart_EnterScope();
    std::cout << "flush" << std::endl;
    Dart_Handle result = HandleError(Dart_NewInteger(0));
    Dart_SetReturnValue(arguments, result);
    Dart_ExitScope();
}

struct FunctionLookup
{
    const char *name;
    Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
    {"setDesktopWindow", setDesktopWindow},
    {"setDrawerWindow", setDrawerWindow},
    {"setWindowSource", setWindowSource},
    {"flush", flush},
    {NULL, NULL}};

FunctionLookup no_scope_function_list[] = {
    {NULL, NULL}};

Dart_NativeFunction ResolveName(Dart_Handle name,
                                int argc,
                                bool *auto_setup_scope)
{
    if (!Dart_IsString(name))
    {
        return NULL;
    }
    Dart_NativeFunction result = NULL;
    if (auto_setup_scope == NULL)
    {
        return NULL;
    }

    Dart_EnterScope();
    const char *cname;
    HandleError(Dart_StringToCString(name, &cname));

    for (int i = 0; function_list[i].name != NULL; ++i)
    {
        if (strcmp(function_list[i].name, cname) == 0)
        {
            *auto_setup_scope = true;
            result = function_list[i].function;
            break;
        }
    }

    if (result != NULL)
    {
        Dart_ExitScope();
        return result;
    }

    for (int i = 0; no_scope_function_list[i].name != NULL; ++i)
    {
        if (strcmp(no_scope_function_list[i].name, cname) == 0)
        {
            *auto_setup_scope = false;
            result = no_scope_function_list[i].function;
            break;
        }
    }

    Dart_ExitScope();
    return result;
}
