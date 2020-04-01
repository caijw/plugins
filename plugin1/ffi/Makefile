
TARGET=libffi.so

SOURCES=ffi.cc

OBJ_DIR=$(CURDIR)/obj

OBJ_FILES=$(SOURCES:%.cc=$(OBJ_DIR)/%.o)

DEPENDENCY_FILES=$(OBJ_FILES:%.o=%.d)

CXX=clang++

INCLUDE_DIRS=$(CURDIR)

CXXFLAGS=-std=c++14 -Wall -Werror -fPIC -fvisibility=hidden

CPPFLAGS=$(patsubst %,-I%,$(INCLUDE_DIRS))

LDFLAGS=-shared



.PHONY: all
all: $(TARGET)

$(TARGET) : $(OBJ_FILES)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $^ $(LDFLAGS) -o $@

-include $(DEPENDENCY_FILES)

$(OBJ_DIR)/%.o : %.cc
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MMD -c $< -o $@

.PHONY: clean
clean:
	rm -r $(OBJ_DIR); \
	rm $(TARGET)