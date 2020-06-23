PREFIX=     /usr/local
BUILD_TYPE= release

export BUILD_DIR= $(PWD)/build-$(BUILD_TYPE)
RUNTIME_EXE= $(BUILD_DIR)/bin/pumas-luajit

ifeq ($(BUILD_TYPE), release)
CFLAGS+= -O3
INSTALL_EXE= install -s
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
	@echo "==== Building pumas-luajit ===="
	@$(MAKE) -e -C src
	@echo "==== Successfully built pumas ===="

install: $(RUNTIME_EXE)
	@echo "==== Installing pumas-luajit to $(PREFIX) ===="
	@install -d $(PREFIX)/bin
	@$(INSTALL_EXE) -m 0755 $(RUNTIME_EXE) $(PREFIX)/bin/pumas-luajit
	@echo "==== Successfully installed pumas-luajit to $(PREFIX) ===="
