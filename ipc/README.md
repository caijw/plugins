# ipc package

## TODO

这个包是手写的，后面弄个工具自动生成

## WARNING

1. only for linux
2. 只有调用`flush()`才会发送实际的请求给`server`

## HOW TO USE

1. 设置so目录的环境变量`weos_client_sdk_path`

比如`export weos_client_sdk_path='/home/jingweicai/Documents/code/client-sdk'`

2. 项目中引入改package

```yml
  ipc:
    git:
      url: https://github.com/caijw/plugins
      path: binder
      ref: master
```
