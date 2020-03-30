cmake_minimum_required(VERSION 3.10)

project(Libbinder)

set(CMAKE_CXX_STANDARD 11)

set(BINDER_SRCS 
    ${CMAKE_CURRENT_SOURCE_DIR}/binder/AppOpsManager.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/binder/Binder.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/BpBinder.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/BufferedTextOutput.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/Debug.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IAppOpsCallback.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IAppOpsService.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IBatteryStats.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IInterface.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IMemory.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IPCThreadState.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IPermissionController.cpp 
    ${CMAKE_CURRENT_SOURCE_DIR}/binder/IProcessInfoService.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/IServiceManager.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/MemoryBase.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/MemoryDealer.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/MemoryHeapBase.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/Parcel.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/PermissionCache.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/ProcessInfoService.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/ProcessState.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/Static.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/binder/TextOutput.cpp)


set(CUTILS_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/ashmem-dev.c 
	${CMAKE_CURRENT_SOURCE_DIR}/cutils/atomic.c 
	${CMAKE_CURRENT_SOURCE_DIR}/cutils/native_handle.c 
#	${CMAKE_CURRENT_SOURCE_DIR}/cutils/process_name.c 
    #${CMAKE_CURRENT_SOURCE_DIR}/cutils/properties.c 
	${CMAKE_CURRENT_SOURCE_DIR}/cutils/safe_iop.c 
	${CMAKE_CURRENT_SOURCE_DIR}/cutils/sched_policy.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/socket_inaddr_any_server.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/socket_local_client.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/socket_local_server.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/socket_loopback_client.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/socket_loopback_server.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/sockets.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/cutils/strlcpy.c 
	${CMAKE_CURRENT_SOURCE_DIR}/cutils/threads.c)

set(UTILS_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/BasicHashtable.cpp 
	#${CMAKE_CURRENT_SOURCE_DIR}/utils/BlobCache.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/CallStack.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/FileMap.cpp 
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/JenkinsHash.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/LinearTransform.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Log.cpp 
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/Looper.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/misc.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/NativeHandle.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Printer.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/ProcessCallStack.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/PropertyMap.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/RefBase.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/SharedBuffer.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Static.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/StopWatch.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/String16.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/String8.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/SystemClock.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Threads.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Timers.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Tokenizer.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/Unicode.cpp 
	${CMAKE_CURRENT_SOURCE_DIR}/utils/VectorImpl.cpp)

add_library(binder SHARED
    ${CUTILS_SRCS} 
    ${UTILS_SRCS} 
    ${BINDER_SRCS} 
    )
target_link_libraries(binder c)
target_include_directories(binder PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_compile_definitions(binder PUBLIC HAVE_PTHREADS HAVE_SYS_UIO_H HAVE_ENDIAN_H HAVE_ANDROID_OS )
