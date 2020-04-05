

LIB_NAME=ipc_extension

INCLUDE_DIRS= $(CURDIR)

LIB_DIR=$(CURDIR)/client-sdk

SDK_LIB_NAME=displayServiceSDK

SOURCES= ipc_extension.cc

# .o 文件目录
OBJ_DIR=$(CURDIR)/obj

# 将 SOURCES 文件列表的 .cc 后缀替换为 .o 后缀
OBJ_FILES=$(SOURCES:%.cc=$(OBJ_DIR)/%.o)

# .d 依赖文件
DEPENDENCY_FILES=$(OBJ_FILES:%.o=%.d)

# 构建输出动态库文件
LIBRARY_OUT=lib$(LIB_NAME).so

CXX=g++
CXXFLAGS=-fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB
CPPFLAGS=$(patsubst %,-I%,$(INCLUDE_DIRS))
LDFLAGS=-shared -L$(LIB_DIR) -l$(SDK_LIB_NAME)

# g++ -fPIC -m64 -I/usr/lib/dart -DDART_SHARED_LIB -c sample_extension.cc

# g++ -shared -m64 -Wl,-soname,libsample_extension.so -o libsample_extension.so sample_extension.o

.PHONY: all
all: $(LIBRARY_OUT)

$(LIBRARY_OUT): $(OBJ_FILES)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Wl,-soname,$(LIBRARY_OUT) $^ $(LDFLAGS) -o $@

-include $(DEPENDENCY_FILES)

# -MMD 参数，生成 .d 文件
$(OBJ_DIR)/%.o : %.cc
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MMD -c $< -o $@