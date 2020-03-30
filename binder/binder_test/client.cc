#include "client.h"

Client::Client()
{
}

Client::~Client()
{
}

Client::Client(const Client &)
{
}

Client::Client &operator=(const Client &)
{
}

static Client &Client::getInstance()
{
    static Client instance;
    return Client;
}

void Client::sayHello()
{
    sp<IBasicService> service_;
    sp<IServiceManager> sm = defaultServiceManager();
    sp<IBinder> binder = sm->getService(String16("service.basic"));
    service_ = interface_cast<IBasicService>(binder);
    std::cout << "[log][c++]before Client::sayHello" << std::endl;
    service_->sayHello();
    std::cout << "[log][c++]after Client::sayHello" << std::endl;
}