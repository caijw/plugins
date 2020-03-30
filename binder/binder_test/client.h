#ifndef BINDER_TEST_CLIENT_H
#define BINDER_TEST_CLIENT_H

#include "IBasicService.h"
#include <iostream>

class Client {
private:
    Client();
    ~Client();
    Client(const Client&);
    Client& operator=(const Client&);
public:
    static Client& getInstance();
    void sayHello();
}

#endif

