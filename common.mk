# Build path
BUILD=$(BUILDROOT)/Build

# Code Paths
DSPLIB=Libraries/CMSIS/DSP_Lib/Source

# Tool path
TOOLROOT=Tools/gcc-arm-none-eabi-4_9-2015q1/bin

CMSIS=Libraries/CMSIS/Include/

# Tools
CC=$(TOOLROOT)/arm-none-eabi-gcc
CXX=$(TOOLROOT)/arm-none-eabi-g++
LD=$(TOOLROOT)/arm-none-eabi-gcc
AR=$(TOOLROOT)/arm-none-eabi-ar
AS=$(TOOLROOT)/arm-none-eabi-as
RANLIB=$(TOOLROOT)/arm-none-eabi-ranlib
GDB=$(TOOLROOT)/arm-none-eabi-gdb
OBJCOPY=$(TOOLROOT)/arm-none-eabi-objcopy
OBJDUMP=$(TOOLROOT)/arm-none-eabi-objdump

# Set up search path
vpath %.cpp $(BUILDROOT)/Source
vpath %.c $(BUILDROOT)/Source
vpath %.s $(BUILDROOT)/Source
vpath %.c Libraries/syscalls

# Compilation Flags
ARCH_FLAGS = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
# ARCH_FLAGS = -mcpu=cortex-m4 -mthumb -mfloat-abi=soft -msoft-float
# ARCH_FLAGS += -fsingle-precision-constant
DEF_FLAGS = -DUSE_STDPERIPH_DRIVER -DARM_MATH_CM4 -DSTM32F4XX -D__FPU_PRESENT -D__FPU_USED=1
# DEF_FLAGS = -DUSE_STDPERIPH_DRIVER -DARM_MATH_CM4 -DSTM32F4XX
INC_FLAGS = -I$(BUILDROOT)/Libraries -I$(DEVICE) -I$(CMSIS) -I$(PERIPH_FILE)/inc -I$(BUILDROOT)/Source
INC_FLAGS += -I$(DEVICE)/Include -I$(CMSIS)
INC_FLAGS += -I$(USB_DEVICE_FILE)/Core/inc -I$(USB_DEVICE_FILE)/Class/cdc/inc
INC_FLAGS += -I$(USB_OTG_FILE)/inc
CFLAGS += $(ARCH_FLAGS) $(INC_FLAGS) $(DEF_FLAGS)
CFLAGS += -fno-builtin -std=c99
CXXFLAGS += $(ARCH_FLAGS) $(INC_FLAGS) $(DEF_FLAGS)
LDFLAGS += -T$(LDSCRIPT) $(ARCH_FLAGS)

# Build executable 
$(ELF) : $(OBJS) $(LDSCRIPT)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

# compile and generate dependency info
$(BUILD)/%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM -MT"$@" $(CFLAGS) $< > $(@:.o=.d)

$(BUILD)/%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@
	$(CXX) -MM -MT"$@" $(CXXFLAGS) $< > $(@:.o=.d)

$(BUILD)/%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILD)/%.s: %.c
	$(CC) -S $(CFLAGS) $< -o $@

$(BUILD)/%.s: %.cpp
	$(CXX) -S $(CXXFLAGS) $< -o $@

$(BUILD)/%.bin: $(BUILD)/%.elf
	$(OBJCOPY) -O binary $< $@
	@echo Successfully built OWL binary $@

$(BUILD)/%.s: $(BUILD)/%.elf
	$(OBJDUMP) -S $< > $@

clean:
	rm -rf $(BUILD)/*

realclean: clean
	find Libraries/ -name '*.o' -delete

# pull in dependencies
-include $(OBJS:.o=.d) $(SOLO_OBJS:.o=.d) $(MULTI_OBJS:.o=.d)