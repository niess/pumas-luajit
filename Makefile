PREFIX=     /usr/local
BUILD_TYPE= release

export BUILD_DIR= $(PWD)/build-$(BUILD_TYPE)
RUNTIME_EXE= $(BUILD_DIR)/bin/luajit-pumas

ifeq ($(BUILD_TYPE), release)
CFLAGS+= -O3
ifeq ($(shell uname -s),Linux)
  INSTALL_EXE= install -s
  else
  INSTALL_EXE= install
endif
else ifeq ($(BUILD_TYPE), debug)
CFLAGS+= -O0 -g3
INSTALL_EXE= install
else
$(error invalid BUILD_TYPE $(BUILD_TYPE))
endif
CFLAGS+= -fPIC
export CFLAGS

FORCE:

$(RUNTIME_EXE): FORCE
	@echo "==== Building luajit-pumas ===="
	@$(MAKE) -e -C src
	@echo "==== Successfully built luajit-pumas ===="

install: $(RUNTIME_EXE)
	@echo "==== Installing luajit-pumas to $(PREFIX) ===="
	@install -d $(PREFIX)/bin
	@$(INSTALL_EXE) -m 0755 $(RUNTIME_EXE) $(PREFIX)/bin/luajit-pumas
	@echo "==== Successfully installed luajit-pumas to $(PREFIX) ===="
