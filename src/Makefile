FLUX_REPO=       "https://github.com/niess/atmospheric-muon-flux.git"
FLUX_VERSION=    "825f5d512668c19374918457dfc25932ae902155"
FLUX_DATA=       "yfm-gsf-usstd"

GULL_REPO=       "https://github.com/niess/gull.git"
GULL_VERSION=    "286ace553a4328a4c61448817e40a799bd8fc50a"

INSPECT_REPO=    "https://github.com/kikito/inspect.lua.git"
INSPECT_VERSION= "b611db6bfa9c12ce35dd4972032fbbd2ad5ba965"

LFS_REPO=        "https://github.com/keplerproject/luafilesystem.git"
LFS_VERSION=     "7c6e1b013caec0602ca4796df3b1d7253a2dd258"

LUAJIT_REPO=     "https://github.com/openresty/luajit2.git"
LUAJIT_VERSION=  "v2.1-20200102"

PUMAS_REPO=      "https://github.com/niess/pumas.git"
PUMAS_VERSION=   "656d209b65f0cafe325a316afe1dd99dc262f361"

TURTLE_REPO=     "https://github.com/niess/turtle.git"
TURTLE_VERSION=  "2c2ecdf89bfc341d64f0ec981008f5fc5c498861"

CC=     gcc
CFLAGS= -O3 -fPIC

JFLAGS= -g
ifdef CROSS
JFLAGS+= -o Windows
endif

BUILD_DIR=       $(PWD)/build
LUAJIT_OPTIONS=  BUILDMODE=static CFLAGS=-DLUAJIT_ENABLE_LUA52COMPAT

LUAJIT_SRC=        $(BUILD_DIR)/src/luajit
LUAJIT_INC=        $(BUILD_DIR)/include/luajit-2.1
LUAJIT_EXE=        $(BUILD_DIR)/bin/luajit
LUAJIT_NATIVE_LIB= $(BUILD_DIR)/lib/libluajit-5.1.a
LUAJIT_LIB=        $(BUILD_DIR)/lib/libluajit-$(CROSS)5.1.a

define git_fetch #([$1] = destination, [$2] = url, [$3] = tag)
	if [ ! -d "$1" ]; then \
	    echo "FETCH     $$(basename $1)" && \
	    mkdir -p "$1" && \
	    cd "$1" && \
	    git init -q . && \
	    git remote add origin "$2" && \
	    git fetch -q --depth 1 origin "$3" && \
	    git reset -q --hard FETCH_HEAD ; \
	fi
endef

define jit_compile #([$1] = name, [$2] = source.lua, [$3] = object.o)
	echo "JIT       $$(basename $@)"
	$(LUAJIT_EXE) -b $(JFLAGS) -n $1 $2 $3
endef

ifeq ($(OS),Windows_NT)
LINESEP= "\\r\\n"
LIBEXT= dll
else
LINESEP = "\\n"
LIBEXT= so
endif

define wrap_header #([$1] = header.h, [$2] = header.lua)
	echo "WRAP      $$(basename $2)"
	mkdir -p "$$(dirname $(2))"
	$(eval __wrap_script := "\
	local f = io.open('$(1)'); \
	local include = f:read '*a'; \
	f:close(); \
	include = include \
	    :gsub('[ ]*/[*].-[*]/ *[\r\n]+', '') \
	    :gsub('\#ifdef __cplusplus[\r\n]+}[\r\n]+\#endif[\r\n]+', '') \
	    :gsub('\#[%w%p ]*[\r\n]+', '') \
	    :gsub('PUMAS_API[ ]+', '') \
	    :gsub('TURTLE_API[ ]+', '') \
	    :gsub('extern \"C\" {[\r\n]+', '') \
	    :gsub('FILE[ ]*[*]', 'struct FILE *') \
	    :gsub('MT_PERIOD', '624'); \
	f = io.open('$(2)', 'w+'); \
	f:write('require(\"ffi\").cdef([[$(LINESEP)' .. include .. ']])'); \
	f:close() \
	")
	$(LUAJIT_EXE) -e $(__wrap_script)
endef

define wrap_data #([$1] = data.ext, [$2] = data.lua)
	echo "WRAP      $$(basename $2)"
	$(eval __wrap_script := "\
	local f = io.open('$(1)'); \
	local data = f:read '*a'; \
	f:close(); \
	f = io.open('$(2)', 'w+'); \
	f:write('return [[$(LINESEP)' .. data .. ']]'); \
	f:close() \
	")
	$(LUAJIT_EXE) -e $(__wrap_script)
endef

.PHONY: clean

RUNTIME_EXE= $(BUILD_DIR)/bin/$(CROSS)luajit-pumas
RUNTIME_VERSION= $(shell \
    git describe --match=NeVeRmAtCh --always --abbrev=7 --dirty)

CORE_LIB=pumas/libpumas_extended.$(LIBEXT)

all: $(RUNTIME_EXE) $(CORE_LIB)

clean:
	@$(MAKE) --quiet -C $(LUAJIT_SRC)/src clean
	@cd $(BUILD_DIR) && \
	rm -rf bin include lib objs share pumas/*.h.lua

$(LUAJIT_SRC):
	@$(call git_fetch,$@,$(LUAJIT_REPO),$(LUAJIT_VERSION))

$(LUAJIT_EXE) $(LUAJIT_NATIVE_LIB): $(LUAJIT_SRC)
	@$(MAKE) -C $< PREFIX=$(BUILD_DIR) CROSS= $(LUAJIT_OPTIONS)
	@$(MAKE) --quiet -C $< install PREFIX=$(BUILD_DIR) CROSS= $(LUAJIT_OPTIONS)
	@$(MAKE) --quiet -C $(LUAJIT_SRC)/src clean

ifdef CROSS
$(LUAJIT_LIB): $(LUAJIT_SRC)
	@cd $</src && \
	$(MAKE) CROSS=$(CROSS) TARGET_SYS=Windows $(LUAJIT_OPTIONS) && \
	echo "INSTALL   $$(basename $@)" && \
	mkdir -p $(BUILD_DIR)/lib && \
	mv libluajit.a $@
	@$(MAKE) --quiet -C $(LUAJIT_SRC)/src clean
endif

OBJS_DIR= $(BUILD_DIR)/objs

$(OBJS_DIR):
	@echo "MKDIR     $$(basename $@)"
	@mkdir -p $@

LFS_SRC= $(BUILD_DIR)/src/lfs
LFS_OBJ= $(OBJS_DIR)/$(CROSS)lfs.c.o

$(LFS_SRC)/src/lfs.c $(LFS_SRC)/src/lfs.h:
	@$(call git_fetch,$(LFS_SRC),$(LFS_REPO),$(LFS_VERSION))

$(LFS_OBJ): $(LFS_SRC)/src/lfs.c $(LFS_SRC)/src/lfs.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(LUAJIT_INC) -c $(CFLAGS) $<

GULL_SRC= $(BUILD_DIR)/src/gull
GULL_INC= $(GULL_SRC)/include
GULL_OBJ= $(OBJS_DIR)/$(CROSS)gull.c.o
GULL_DAT= $(GULL_SRC)/share/data

$(GULL_SRC)/src/gull.c $(GULL_INC)/gull.h $(GULL_DAT)/IGRF13.COF:
	@$(call git_fetch,$(GULL_SRC),$(GULL_REPO),$(GULL_VERSION))

$(GULL_OBJ): $(GULL_SRC)/src/gull.c $(GULL_INC)/gull.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(GULL_INC) -c $(CFLAGS) $<

PUMAS_SRC= $(BUILD_DIR)/src/pumas
PUMAS_INC= $(PUMAS_SRC)/include
PUMAS_OBJ= $(OBJS_DIR)/$(CROSS)pumas.c.o

$(PUMAS_SRC)/src/pumas.c $(PUMAS_INC)/pumas.h:
	@$(call git_fetch,$(PUMAS_SRC),$(PUMAS_REPO),$(PUMAS_VERSION))

$(PUMAS_OBJ): $(PUMAS_SRC)/src/pumas.c $(PUMAS_INC)/pumas.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(PUMAS_INC) -c $(CFLAGS) $<

TURTLE_SRC= $(BUILD_DIR)/src/turtle
TURTLE_INC= $(TURTLE_SRC)/include
TURTLE_OBJS= $(OBJS_DIR)/$(CROSS)deps_jsmn.c.o \
	     $(OBJS_DIR)/$(CROSS)deps_tinydir.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_client.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_ecef.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_error.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io_asc.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io_geotiff16.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io_grd.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io_hgt.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_io_png16.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_list.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_map.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_projection.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_stack.c.o \
	     $(OBJS_DIR)/$(CROSS)turtle_stepper.c.o

.PRECIOUS: $(TURTLE_SRC)/src/deps/%.c $(TURTLE_SRC)/src/deps/%.h \
           $(TURTLE_SRC)/src/turtle/%.c $(TURTLE_SRC)/src/turtle/%.h \
           $(TURTLE_SRC)/src/turtle/io/%.c $(TURTLE_INC)/turtle.h

$(TURTLE_SRC)/src/deps/%.c $(TURTLE_SRC)/src/deps/%.h \
$(TURTLE_SRC)/src/turtle/%.c $(TURTLE_SRC)/src/turtle/%.h \
$(TURTLE_SRC)/src/turtle/io/%.c $(TURTLE_INC)/%.h:
	@$(call git_fetch,$(TURTLE_SRC),$(TURTLE_REPO),$(TURTLE_VERSION))

$(OBJS_DIR)/$(CROSS)deps_%.c.o: $(TURTLE_SRC)/src/deps/%.c \
	                        $(TURTLE_SRC)/src/deps/%.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -c $(CFLAGS) $<

$(OBJS_DIR)/$(CROSS)turtle_%.c.o: $(TURTLE_SRC)/src/turtle/%.c \
	                          $(TURTLE_INC)/turtle.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(TURTLE_INC) -I$(TURTLE_SRC)/src \
                       -c $(CFLAGS) $<

$(OBJS_DIR)/$(CROSS)turtle_io_%.c.o: $(TURTLE_SRC)/src/turtle/io/%.c \
	                             $(TURTLE_INC)/turtle.h | $(OBJS_DIR)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(TURTLE_INC) -I$(TURTLE_SRC)/src \
	               -c $(CFLAGS) $<

EXTENSIONS_OBJ= $(OBJS_DIR)/$(CROSS)pumas_extensions.c.o

FLUX_SRC= $(BUILD_DIR)/src/atmospheric-muon-flux

$(FLUX_SRC)/scripts/wrap-flux.lua $(FLUX_SRC)/data/simulated/flux-mceq-$(FLUX_DATA).table:
	@$(call git_fetch,$(FLUX_SRC),$(FLUX_REPO),$(FLUX_VERSION))

flux_mceq.c: $(FLUX_SRC)/data/simulated/flux-mceq-$(FLUX_DATA).table $(FLUX_SRC)/scripts/wrap-flux.lua $(LUAJIT_EXE) 
	@echo "WRAP      $$(basename $<)"
	@$(LUAJIT_EXE) $(FLUX_SRC)/scripts/wrap-flux.lua $< $@

$(EXTENSIONS_OBJ): pumas_extensions.c flux_mceq.c pumas_extensions.h | \
	           $(OBJS_DIR) $(GULL_INC)/gull.h $(PUMAS_INC)/pumas.h \
                   $(TURTLE_INC)/turtle.h
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -I$(GULL_INC) -I$(PUMAS_INC) -I$(TURTLE_INC) \
                       -c $(CFLAGS) $<

INSPECT_SRC= $(BUILD_DIR)/src/inspect

$(INSPECT_SRC)/inspect.lua:
	@$(call git_fetch,$(INSPECT_SRC),$(INSPECT_REPO),$(INSPECT_VERSION))

$(OBJS_DIR)/$(CROSS)inspect.lua.o: $(INSPECT_SRC)/inspect.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,inspect,$<,$@)

$(OBJS_DIR)/$(CROSS)%.lua.o: %.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_%.lua.o: pumas/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_coordinates_%.lua.o: pumas/coordinates/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.coordinates.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_data_%.lua.o: pumas/data/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.data.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_geometry_%.lua.o: pumas/geometry/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.geometry.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_header_%.lua.o: pumas/header/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.header.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_medium_%.lua.o: pumas/medium/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.medium.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas_physics_%.lua.o: pumas/physics/%.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas.physics.$*,$<,$@)

$(OBJS_DIR)/$(CROSS)pumas.lua.o: pumas.lua $(LUAJIT_EXE) | $(OBJS_DIR)
	@$(call jit_compile,pumas,$<,$@)

.PRECIOUS: pumas/header/api.lua
pumas/header/api.lua: $(PUMAS_INC)/pumas.h | $(LUAJIT_EXE) $(PUMAS_OBJ)
	@$(call wrap_header,$<,$@)

.PRECIOUS: pumas/header/gull.lua
pumas/header/gull.lua: $(GULL_INC)/gull.h | $(LUAJIT_EXE) $(GULL_OBJ)
	@$(call wrap_header,$<,$@)

.PRECIOUS: pumas/data/igrf13.lua
pumas/data/igrf13.lua: $(GULL_DAT)/IGRF13.COF | $(LUAJIT_EXE) $(GULL_OBJ)
	@$(call wrap_data,$<,$@)

.PRECIOUS: pumas/header/extensions.lua
pumas/header/extensions.lua: pumas_extensions.h | $(LUAJIT_EXE)
	@$(call wrap_header,$<,$@)

.PRECIOUS: pumas/header/turtle.lua
pumas/header/turtle.lua: $(TURTLE_INC)/turtle.h | $(LUAJIT_EXE) $(TURTLE_OBJS)
	@$(call wrap_header,$<,$@)

CORE_OBJS= $(GULL_OBJ) \
	   $(PUMAS_OBJ) \
	   $(TURTLE_OBJS) \
	   $(EXTENSIONS_OBJ)

RUNTIME_OBJS= $(CORE_OBJS) \
	      $(LFS_OBJ) \
	      $(OBJS_DIR)/$(CROSS)inspect.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_call.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_clib.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_constants.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_compat.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_context.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_coordinates.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_coordinates_frame.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_coordinates_transform.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_coordinates_type.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_data_elements.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_data_igrf13.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_data_materials.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_element.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_enum.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_error.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_flux.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_base.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_earth.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_infinite.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_layer.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_polyhedron.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_geometry_topography.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_header_api.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_header_gull.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_header_extensions.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_header_turtle.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_material.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_medium.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_medium_base.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_medium_gradient.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_medium_transparent.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_medium_uniform.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_metatype.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_os.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_pdg.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics_build.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics_composite.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics_physics.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics_tabulated.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_physics_utils.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_readonly.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_recorder.lua.o \
	      $(OBJS_DIR)/$(CROSS)pumas_state.lua.o \
	      $(OBJS_DIR)/$(CROSS)runtime.lua.o
RUNTIME_LIB=  $(BUILD_DIR)/lib/libruntime-$(CROSS)5.1.a

$(RUNTIME_LIB): $(RUNTIME_OBJS)
	@echo "AR        $$(basename $@)"
	@$(CROSS)ar rcs $@ $^

MAIN_OBJ= $(OBJS_DIR)/$(CROSS)runtime_main.o

$(MAIN_OBJ): runtime_main.c | $(OBJS_DIR) $(LUAJIT_EXE)
	@echo "CC        $$(basename $@)"
	@$(CROSS)$(CC) -o $@ -c -I$(LUAJIT_INC) $(CFLAGS) \
	               -DRUNTIME_VERSION="\"$(RUNTIME_VERSION)\"" $<

ifdef CROSS
EXPORT_SYMBOLS= -Wl,--export-all-symbols
else
EXPORT_SYMBOLS= -rdynamic
endif

ifeq ($(shell uname -s),Linux)
WHOLE_ARCHIVE=    -Wl,--whole-archive
NO_WHOLE_ARCHIVE= -Wl,--no-whole-archive
FORCE_LOAD=
else
WHOLE_ARCHIVE=
NO_WHOLE_ARCHIVE=
FORCE_LOAD=       -Wl,-force_load
endif

LDFLAGS+= $(WHOLE_ARCHIVE) $(EXPORT_SYMBOLS) \
          $(FORCE_LOAD) $(LUAJIT_LIB) \
          $(FORCE_LOAD) $(RUNTIME_LIB) \
          $(NO_WHOLE_ARCHIVE)

ifdef CROSS
LDLIBS+= -lws2_32
else
LDLIBS+= -ldl -lm
endif

$(RUNTIME_EXE): $(MAIN_OBJ) $(LUAJIT_LIB) $(RUNTIME_LIB)
	@echo "LINK      $$(basename $@)"
	@$(CROSS)$(CC) -o $@ $< $(LDFLAGS) $(LDLIBS)

$(CORE_LIB): $(CORE_OBJS)
	@echo "LINK      $$(basename $@)"
	@mkdir -p "$$(dirname $@)"
	@$(CROSS)$(CC) -o $@ -shared $(EXPORT_SYMBOLS) $^ $(LDLIBS)
