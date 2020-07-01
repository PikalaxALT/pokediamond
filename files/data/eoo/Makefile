HOSTCC = $(CC)
HOSTCXX = $(CXX)
HOSTCFLAGS = $(CFLAGS)
HOSTCXXFLAGS = $(CXXFLAGS)
HOST_VARS := CC=$(HOSTCC) CXX=$(HOSTCXX) CFLAGS='$(HOSTCFLAGS)' CXXFLAGS='$(HOSTCXXFLAGS)'

# Try to include devkitarm if installed
TOOLCHAIN := $(DEVKITARM)

ifneq (,$(wildcard $(TOOLCHAIN)/base_tools))
include $(TOOLCHAIN)/base_tools
endif

# If you are using WSL, it is recommended you build with NOWINE=1.
WSLENV ?= no
ifeq ($(WSLENV),)
NOWINE = 1
else
NOWINE = 0
endif

ifeq ($(OS),Windows_NT)
EXE := .exe
WINE :=
GREP := grep -P
SED := sed -r
else
EXE :=
WINE := wine
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
GREP := grep -E
SED := perl -p -e
else
GREP := grep -P
SED := sed -r
endif
endif

ifeq ($(NOWINE),1)
WINE :=
endif

TOOLS_DIR := $(CURDIR:%/files/data/eoo=%/tools)

TARGET := eoo

BUILD_DIR := build

ROM := $(CURDIR)/../$(TARGET).dat

##################### Compiler Options #######################

MWCCVERSION = 2.0/sp1

CROSS   := arm-none-eabi-

MWCCARM  = $(TOOLS_DIR)/mwccarm/$(MWCCVERSION)/mwccarm.exe
MWLDARM  = $(TOOLS_DIR)/mwccarm/$(MWCCVERSION)/mwldarm.exe
MWASMARM = $(TOOLS_DIR)/mwccarm/$(MWCCVERSION)/mwasmarm.exe

AS      = $(WINE) $(MWASMARM)
CC      = $(WINE) $(MWCCARM)
CPP     := cpp -P
LD      = $(WINE) $(MWLDARM)
AR      := $(CROSS)ar
OBJDUMP := $(CROSS)objdump
OBJCOPY := $(CROSS)objcopy

ASFLAGS = -proc arm5te
CFLAGS = -O4,p -gccext,on -proc arm946e -fp soft -lang c99 -Cpp_exceptions off -i include -ir include-mw -ir arm9/lib/include -W all
LDFLAGS = -map -nodead -w off -proc v5te -interworking -map -symtab -m _start

DUMMY != mkdir -p $(BUILD_DIR)

####################### Other Tools #########################

# DS TOOLS
TOOLS_DIR = tools
SHA1SUM = sha1sum
CSV2BIN = $(TOOLS_DIR)/csv2bin/csv2bin$(EXE)
JSONPROC = $(TOOLS_DIR)/jsonproc/jsonproc$(EXE)
O2NARC = $(TOOLS_DIR)/o2narc/o2narc$(EXE)
GFX = $(TOOLS_DIR)/nitrogfx/nitrogfx$(EXE)
MWASMARM_PATCHER = $(TOOLS_DIR)/mwasmarm_patcher/mwasmarm_patcher$(EXE) -q
MAKEBANNER = $(WINE) $(TOOLS_DIR)/bin/makebanner.exe
MAKEROM    = $(WINE) $(TOOLS_DIR)/bin/makerom.exe
FIXROM     = $(TOOLS_DIR)/fixrom/fixrom$(EXE)
NTRCOMP    = $(WINE) $(TOOLS_DIR)/bin/ntrcomp.exe

TOOLDIRS = $(filter-out $(TOOLS_DIR)/mwccarm $(TOOLS_DIR)/bin,$(wildcard $(TOOLS_DIR)/*))
TOOLBASE = $(TOOLDIRS:$(TOOLS_DIR)/%=%)
TOOLS = $(foreach tool,$(TOOLBASE),$(TOOLS_DIR)/$(tool)/$(tool)$(EXE))

export LM_LICENSE_FILE := $(TOOLS_DIR)/mwccarm/license.dat
export MWCIncludes := arm9/lib/include
export MWLibraries := arm9/lib

MAKEROMFLAGS := -DTOOLS_DIR=$(TOOLS_DIR) -D

######################### Targets ###########################

infoshell = $(foreach line, $(shell $1 | sed "s/ /__SPACE__/g"), $(info $(subst __SPACE__, ,$(line))))

# Build tools when building the rom
# Disable dependency scanning for clean/tidy/tools
ifeq (,$(filter-out all,$(MAKECMDGOALS)))
$(call infoshell, $(HOST_VARS) $(MAKE) tools patch_mwasmarm)
else
NODEP := 1
endif

.SECONDARY:
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.PHONY: all clean mostlyclean tidy arm9 arm7 filesystem patch_mwasmarm

MAKEFLAGS += --no-print-directory

all: $(ROM)
ifeq ($(COMPARE),1)
	@$(SHA1SUM) -c $(TARGET).sha1
endif

clean: mostlyclean

mostlyclean: tidy

## Stubs
arm9 arm7:
	$(MAKE) -C $@

arm9/build/arm9.sbin: arm9
arm7/build/arm7.sbin: arm7

filesystem: ;

tidy:
	$(RM) $(BUILD_DIR) $(ROM)

tools: $(TOOLDIRS)

$(TOOLDIRS):
	@$(HOST_VARS) $(MAKE) -C $@

$(MWASMARM): patch_mwasmarm
	@:

patch_mwasmarm:
	$(MWASMARM_PATCHER) $(MWASMARM)

$(ROM):	rom.rsf arm9 arm7 filesystem
	$(MAKEROM) $(MAKEROMFLAGS) $< $@

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true

