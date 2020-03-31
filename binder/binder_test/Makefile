# 生成供 dart 调用的动态链接库
# 提供 binder ipc 能力

# 构建出来的动态库名字
LIB_NAME=binder_test
# 在 build 目录下生成构建产物
OUT_DIR=build
# 动态链接库存放的目录
LIB_DIR=$${HOME}/lib
# include 目录
INCLUDE_DIRS= $(CURDIR) \
	$(CURDIR)/binder-for-linux-kernel-5/src/libs/include
# binder library
BINDER_LIB_NAME=binder
# pthread library
PTHREAD_LIB_NAME=pthread
# 源文件
SOURCES= client.cc \
	IBasicService.cc
# .o 文件目录
OBJ_DIR=$(OUT_DIR)/obj

# Build settings
CXX=clang++
CXXFLAGS=-std=c++14 -Wall -Werror -fPIC -fvisibility=hidden
CPPFLAGS=$(patsubst %,-I%,$(INCLUDE_DIRS))
LDFLAGS=-shared -L$(LIB_DIR) -l$(BINDER_LIB_NAME) -l$(PTHREAD_LIB_NAME)

# 构建输出动态库文件
LIBRARY_OUT=$(OUT_DIR)/lib$(LIB_NAME).so

# 将 SOURCES 文件列表的 .cc 后缀替换为 .o 后缀
OBJ_FILES=$(SOURCES:%.cc=$(OBJ_DIR)/%.o)
# .d 依赖文件
DEPENDENCY_FILES=$(OBJ_FILES:%.o=%.d)

.PHONY: all
all: $(LIBRARY_OUT) install

$(LIBRARY_OUT): $(OBJ_FILES)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $^ $(LDFLAGS) -o $@

-include $(DEPENDENCY_FILES)

# -MMD 参数，生成 .d 文件
$(OBJ_DIR)/%.o : %.cc
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MMD -c $< -o $@

.PHONY: clean
clean:
	rm -rf $(OUT_DIR);

.PHONY: install
install:
	cp $(LIBRARY_OUT) $(LIB_DIR)

.PHONY: uninstall
uninstall:
	rm $(LIBRARY_OUT)
