# Makefile to build Pokemon Diamond image

include config.mk

HOSTCC = $(CC)
HOSTCXX = $(CXX)
HOSTCFLAGS = $(CFLAGS)
HOSTCXXFLAGS = $(CXXFLAGS)
HOST_VARS := CC=$(HOSTCC) CXX=$(HOSTCXX) CFLAGS='$(HOSTCFLAGS)' CXXFLAGS='$(HOSTCXXFLAGS)'

.PHONY: clean tidy all default patch_mwasmarm

# Try to include devkitarm if installed
TOOLCHAIN := $(DEVKITARM)

ifneq (,$(wildcard $(TOOLCHAIN)/base_tools))
include $(TOOLCHAIN)/base_tools
endif

### Default TARGET ###

default: all

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
else
EXE :=
WINE := wine
endif

ifeq ($(NOWINE),1)
WINE :=
endif

# Compare result of arm9, arm7, and ROM to sha1 hash(s)
COMPARE ?= 1

################ Target Executable and Sources ###############

BUILD_DIR := build/$(TARGET)

ROM := $(BUILD_DIR)/$(TARGET).nds
ELF := $(BUILD_DIR)/$(TARGET).elf
LD_SCRIPT := $(TARGET).lcf

# Directories containing source files
SRC_DIRS := src
ASM_DIRS := asm data files

C_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
S_FILES := $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.s))

# Object files
O_FILES := $(foreach file,$(C_FILES),$(BUILD_DIR)/$(file:.c=.o)) \
           $(foreach file,$(S_FILES),$(BUILD_DIR)/$(file:.s=.o)) \

ARM9SBIN := arm9/$(BUILD_DIR)/arm9.sbin
ARM7SBIN := arm7/$(BUILD_DIR)/arm7.sbin

BINFILES = \
	arm9/$(BUILD_DIR)/arm9.bin \
	arm9/$(BUILD_DIR)/arm9_table.bin \
	arm9/$(BUILD_DIR)/arm9_defs.bin \
	arm7/$(BUILD_DIR)/arm7.bin \
	arm9/$(BUILD_DIR)/MODULE_00.bin \
	arm9/$(BUILD_DIR)/MODULE_01.bin \
	arm9/$(BUILD_DIR)/MODULE_02.bin \
	arm9/$(BUILD_DIR)/MODULE_03.bin \
	arm9/$(BUILD_DIR)/MODULE_04.bin \
	arm9/$(BUILD_DIR)/MODULE_05.bin \
	arm9/$(BUILD_DIR)/MODULE_06.bin \
	arm9/$(BUILD_DIR)/MODULE_07.bin \
	arm9/$(BUILD_DIR)/MODULE_08.bin \
	arm9/$(BUILD_DIR)/MODULE_09.bin \
	arm9/$(BUILD_DIR)/MODULE_10.bin \
	arm9/$(BUILD_DIR)/MODULE_11.bin \
	arm9/$(BUILD_DIR)/MODULE_12.bin \
	arm9/$(BUILD_DIR)/MODULE_13.bin \
	arm9/$(BUILD_DIR)/MODULE_14.bin \
	arm9/$(BUILD_DIR)/MODULE_15.bin \
	arm9/$(BUILD_DIR)/MODULE_16.bin \
	arm9/$(BUILD_DIR)/MODULE_17.bin \
	arm9/$(BUILD_DIR)/MODULE_18.bin \
	arm9/$(BUILD_DIR)/MODULE_19.bin \
	arm9/$(BUILD_DIR)/MODULE_20.bin \
	arm9/$(BUILD_DIR)/MODULE_21.bin \
	arm9/$(BUILD_DIR)/MODULE_22.bin \
	arm9/$(BUILD_DIR)/MODULE_23.bin \
	arm9/$(BUILD_DIR)/MODULE_24.bin \
	arm9/$(BUILD_DIR)/MODULE_25.bin \
	arm9/$(BUILD_DIR)/MODULE_26.bin \
	arm9/$(BUILD_DIR)/MODULE_27.bin \
	arm9/$(BUILD_DIR)/MODULE_28.bin \
	arm9/$(BUILD_DIR)/MODULE_29.bin \
	arm9/$(BUILD_DIR)/MODULE_30.bin \
	arm9/$(BUILD_DIR)/MODULE_31.bin \
	arm9/$(BUILD_DIR)/MODULE_32.bin \
	arm9/$(BUILD_DIR)/MODULE_33.bin \
	arm9/$(BUILD_DIR)/MODULE_34.bin \
	arm9/$(BUILD_DIR)/MODULE_35.bin \
	arm9/$(BUILD_DIR)/MODULE_36.bin \
	arm9/$(BUILD_DIR)/MODULE_37.bin \
	arm9/$(BUILD_DIR)/MODULE_38.bin \
	arm9/$(BUILD_DIR)/MODULE_39.bin \
	arm9/$(BUILD_DIR)/MODULE_40.bin \
	arm9/$(BUILD_DIR)/MODULE_41.bin \
	arm9/$(BUILD_DIR)/MODULE_42.bin \
	arm9/$(BUILD_DIR)/MODULE_43.bin \
	arm9/$(BUILD_DIR)/MODULE_44.bin \
	arm9/$(BUILD_DIR)/MODULE_45.bin \
	arm9/$(BUILD_DIR)/MODULE_46.bin \
	arm9/$(BUILD_DIR)/MODULE_47.bin \
	arm9/$(BUILD_DIR)/MODULE_48.bin \
	arm9/$(BUILD_DIR)/MODULE_49.bin \
	arm9/$(BUILD_DIR)/MODULE_50.bin \
	arm9/$(BUILD_DIR)/MODULE_51.bin \
	arm9/$(BUILD_DIR)/MODULE_52.bin \
	arm9/$(BUILD_DIR)/MODULE_53.bin \
	arm9/$(BUILD_DIR)/MODULE_54.bin \
	arm9/$(BUILD_DIR)/MODULE_55.bin \
	arm9/$(BUILD_DIR)/MODULE_56.bin \
	arm9/$(BUILD_DIR)/MODULE_57.bin \
	arm9/$(BUILD_DIR)/MODULE_58.bin \
	arm9/$(BUILD_DIR)/MODULE_59.bin \
	arm9/$(BUILD_DIR)/MODULE_60.bin \
	arm9/$(BUILD_DIR)/MODULE_61.bin \
	arm9/$(BUILD_DIR)/MODULE_62.bin \
	arm9/$(BUILD_DIR)/MODULE_63.bin \
	arm9/$(BUILD_DIR)/MODULE_64.bin \
	arm9/$(BUILD_DIR)/MODULE_65.bin \
	arm9/$(BUILD_DIR)/MODULE_66.bin \
	arm9/$(BUILD_DIR)/MODULE_67.bin \
	arm9/$(BUILD_DIR)/MODULE_68.bin \
	arm9/$(BUILD_DIR)/MODULE_69.bin \
	arm9/$(BUILD_DIR)/MODULE_70.bin \
	arm9/$(BUILD_DIR)/MODULE_71.bin \
	arm9/$(BUILD_DIR)/MODULE_72.bin \
	arm9/$(BUILD_DIR)/MODULE_73.bin \
	arm9/$(BUILD_DIR)/MODULE_74.bin \
	arm9/$(BUILD_DIR)/MODULE_75.bin \
	arm9/$(BUILD_DIR)/MODULE_76.bin \
	arm9/$(BUILD_DIR)/MODULE_77.bin \
	arm9/$(BUILD_DIR)/MODULE_78.bin \
	arm9/$(BUILD_DIR)/MODULE_79.bin \
	arm9/$(BUILD_DIR)/MODULE_80.bin \
	arm9/$(BUILD_DIR)/MODULE_81.bin \
	arm9/$(BUILD_DIR)/MODULE_82.bin \
	arm9/$(BUILD_DIR)/MODULE_83.bin \
	arm9/$(BUILD_DIR)/MODULE_84.bin \
	arm9/$(BUILD_DIR)/MODULE_85.bin \
	arm9/$(BUILD_DIR)/MODULE_86.bin

SBINFILES = $(BINFILES:%.bin=%.sbin)

##################### Compiler Options #######################

MWCCVERSION = 2.0/base

CROSS   := arm-none-eabi-

MWCCARM  = tools/mwccarm/$(MWCCVERSION)/mwccarm.exe
# Argh... due to EABI version shenanigans, we can't use GNU LD to link together
# MWCC built objects and GNU built ones. mwldarm, however, doesn't care, so we
# have to use mwldarm for now.
# TODO: Is there a hack workaround to let us go back to GNU LD? Ideally, the
# only dependency should be MWCCARM.
KNARC = tools/knarc/knarc$(EXE)
MWLDARM  = tools/mwccarm/$(MWCCVERSION)/mwldarm.exe
MWASMARM = tools/mwccarm/$(MWCCVERSION)/mwasmarm.exe
NARCCOMP = tools/narccomp/narccomp$(EXE)
SCANINC = tools/scaninc/scaninc$(EXE)

AS      = $(WINE) $(MWASMARM)
CC      = $(WINE) $(MWCCARM)
CPP     := cpp -P
LD      = $(WINE) $(MWLDARM)
AR      := $(CROSS)ar
OBJDUMP := $(CROSS)objdump
OBJCOPY := $(CROSS)objcopy

# ./tools/mwccarm/2.0/base/mwasmarm.exe -proc arm5te asm/arm9_thumb.s -o arm9.o
ASFLAGS = -proc arm5te
CFLAGS = -O4,p -proc arm946e -fp soft -lang c99 -Cpp_exceptions off -i include -ir include-mw -ir arm9/lib/include -W all
LDFLAGS = -map -nodead -w off -proc v5te -interworking -map -symtab -m _start

####################### Other Tools #########################

# DS TOOLS
TOOLS_DIR = tools
SHA1SUM = sha1sum
JSONPROC = $(TOOLS_DIR)/jsonproc/jsonproc
GFX = $(TOOLS_DIR)/nitrogfx/nitrogfx
MWASMARM_PATCHER = $(TOOLS_DIR)/mwasmarm_patcher/mwasmarm_patcher$(EXE) -q
MAKEBANNER = $(WINE) $(TOOLS_DIR)/bin/makebanner.exe
MAKEROM    = $(WINE) $(TOOLS_DIR)/bin/makerom.exe

TOOLDIRS = $(filter-out $(TOOLS_DIR)/mwccarm $(TOOLS_DIR)/bin,$(wildcard $(TOOLS_DIR)/*))
TOOLBASE = $(TOOLDIRS:$(TOOLS_DIR)/%=%)
TOOLS = $(foreach tool,$(TOOLBASE),$(TOOLS_DIR)/$(tool)/$(tool)$(EXE))

export LM_LICENSE_FILE := $(TOOLS_DIR)/mwccarm/license.dat
export MWCIncludes := arm9/lib/include
export MWLibraries := arm9/lib

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
.PHONY: all libs clean mostlyclean tidy tools $(TOOLDIRS) patch_mwasmarm arm9 arm7

MAKEFLAGS += --no-print-directory

all: $(ROM)
ifeq ($(COMPARE),1)
	@$(SHA1SUM) -c roms.sha1
endif

clean: mostlyclean
	$(MAKE) -C arm9 clean
	$(MAKE) -C arm7 clean
	$(MAKE) -C tools/mwasmarm_patcher clean
	$(RM) $(filter-out files/poketool/personal/pms.narc,$(filter %.narc %.arc,$(HOSTFS_FILES)))
	$(MAKE) -C files/poketool/personal/growtbl clean

mostlyclean: tidy
	$(MAKE) -C arm9 mostlyclean
	$(MAKE) -C arm7 mostlyclean
	find . \( -iname '*.1bpp' -o -iname '*.4bpp' -o -iname '*.8bpp' -o -iname '*.gbapal' -o -iname '*.lz' \) -exec $(RM) {} +

tidy:
	$(MAKE) -C arm9 tidy
	$(MAKE) -C arm7 tidy
	$(RM) -r $(BUILD_DIR)

tools: $(TOOLDIRS)

$(TOOLDIRS):
	@$(HOST_VARS) $(MAKE) -C $@

$(MWASMARM): patch_mwasmarm
	@:

patch_mwasmarm:
	$(MWASMARM_PATCHER) $(MWASMARM)

ALL_DIRS := $(BUILD_DIR) $(addprefix $(BUILD_DIR)/,$(SRC_DIRS) $(ASM_DIRS))

ifeq (,$(NODEP))
$(BUILD_DIR)/%.o: dep = $(shell $(SCANINC) -I include -I include-mw -I arm9/lib/include $(filter $*.c,$(C_FILES)) $(filter $*.cpp,$(CXX_FILES)) $(filter $*.s,$(S_FILES)))
else
$(BUILD_DIR)/%.o: dep :=
endif

$(BUILD_DIR)/%.o: %.c $$(dep)
	$(CC) -c $(CFLAGS) -o $@ $<

$(BUILD_DIR)/%.o: %.s $$(dep)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(LD_SCRIPT): $(LD_SCRIPT)
	$(CPP) $(VERSION_CFLAGS) -MMD -MP -MT $@ -MF $@.d -I include/ -I . -DBUILD_DIR=$(BUILD_DIR) -o $@ $<

$(SBINFILES): arm9 arm7

arm9:
	$(MAKE) -C arm9 COMPARE=$(COMPARE)

arm7:
	$(MAKE) -C arm7 COMPARE=$(COMPARE)

$(BINFILES): %.bin: %.sbin
	@cp $< $@

$(ELF): $(BUILD_DIR)/$(LD_SCRIPT) $(O_FILES) $(BINFILES) $(BUILD_DIR)/$(TARGET)_bnr.bin
	# Hack because mwldarm doesn't like the sbin suffix
	$(LD) $(LDFLAGS) -o $@ $^

#$(ROM): $(ELF)
#	$(OBJCOPY) -O binary --gap-fill=0xFF --pad-to=0x04000000 $< $@

# TODO: Rules for Pearl
# FIXME: Computed secure area CRC in header is incorrect due to first 8 bytes of header not actually being "encryObj"
$(ROM): pokedp.rsf $(BUILD_DIR)/$(TARGET)_bnr.bin $(SBINFILES) $(HOSTFS_FILES)
	$(MAKEROM) -DBUILD_DIR="$(BUILD_DIR)" -DTARGET="$(TARGET)" -DNITROFS_FILES="$(NITROFS_FILES)" -DGAME_TITLE="$(GAME_TITLE)" -DGAME_CODE="$(GAME_CODE)" $< $@

# Make sure build directory exists before compiling anything
DUMMY != mkdir -p $(ALL_DIRS)

include filesystem.mk

%.4bpp: %.png
	$(GFX) $< $@

%.gbapal: %.png
	$(GFX) $< $@

%.gbapal: %.pal
	$(GFX) $< $@

%.lz: %
	$(GFX) $< $@

%.png: ;
%.pal: ;

######################## Misc #######################

$(BUILD_DIR)/$(TARGET)_bnr.bin: $(TARGET).bsf graphics/icon.4bpp graphics/icon.gbapal
	$(MAKEBANNER) $< $@

symbols_$(TARGET).csv: arm9 arm7
	(echo "Name,Location"; grep -P " *[0-9A-F]{8} [0-9A-F]{8} \S+ +\w+\t\(\w+\.o\)" arm9/$(BUILD_DIR)/arm9.elf.xMAP arm7/$(BUILD_DIR)/arm7.elf.xMAP | sed -r 's/ *([0-9A-F]{8}) [0-9A-F]{8} \S+ +(\w+)\t\(\w+\.o\)/\2,\1/g' | cut -d: -f2) > $@

################### Other targets ###################

diamond: ; @$(MAKE) GAME_VERSION=DIAMOND
pearl:   ; @$(MAKE) GAME_VERSION=PEARL

### Debug Print ###

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true
