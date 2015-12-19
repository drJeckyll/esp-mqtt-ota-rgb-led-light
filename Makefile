#
# Makefile
# ! IMPORTANT !
# Compile rBoot with:
# BOOT_CONFIG_CHKSUM and BOOT_IROM_CHKSUM
# or remove -iromchksum from FW_USER_ARGS bellow
# This will make OTA update unrealible - corrupt roms & etc
# If BOOT_CONFIG_CHKSUM and BOOT_IROM_CHKSUM are enabled
# then rBoot will recover from last booted rom

# CONFIGURATION
# DEVICE must be set to unique name for OTA and MQTT
# By default DEVICE and MQTT_CLIENT_ID are the same
# uncomment next line and set DEVICE
#DEVICE ?= ""
# WIFI settings
WIFI_SSID ?= ""
WIFI_PASS  ?= ""
# AUTH_OPEN, AUTH_WPA2_PSK
WIFI_TYPE ?= AUTH_OPEN
# MQTT setting
MQTT_HOST ?= ""
MQTT_PORT ?= 1883
MQTT_CLIENT_ID ?= $(DEVICE)
MQTT_USER ?= ""
MQTT_PASS ?= ""
MQTT_SECURITY ?= 0
MQTT_PREFIX ?= "/"
# OTA
OTA_HOST ?= ""
OTA_PORT ?= 80
OTA_PATH ?= "/firmware/$(DEVICE)/"
### end user config ###



SDK_BASE   ?= ../esp-open-sdk/sdk
SDK_LIBDIR  = lib
SDK_INCDIR  = include

ESPTOOL		 ?= ../esptool/esptool.py
ESPPORT      ?= /dev/ttyUSB0
ESPTOOL2     ?= ../esp8266/esptool2/esptool2
RBOOT_FW     ?= ../esp8266/rboot/firmware/rboot.bin
FW_SECTS      = .text .data .rodata
FW_USER_ARGS  = -quiet -bin -boot2 -iromchksum

ET_FS         = 8m
ET_FF        ?= 40m

ifndef XTENSA_BINDIR
CC := xtensa-lx106-elf-gcc
LD := xtensa-lx106-elf-gcc
else
CC := $(addprefix $(XTENSA_BINDIR)/,xtensa-lx106-elf-gcc)
LD := $(addprefix $(XTENSA_BINDIR)/,xtensa-lx106-elf-gcc)
endif

BUILD_DIR = build
FIRMW_BASE_DIR = firmware
FIRMW_DIR  = firmware/$(DEVICE)

SDK_LIBDIR := $(addprefix $(SDK_BASE)/,$(SDK_LIBDIR))
SDK_INCDIR := $(addprefix -I$(SDK_BASE)/,$(SDK_INCDIR))

LIBS    = c gcc hal phy net80211 lwip wpa main pp ssl pwm
CFLAGS  = -Os -g -O2 -Wpointer-arith -Wundef -Werror -Wno-implicit -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls  -mtext-section-literals  -D__ets__ -DICACHE_FLASH
LDFLAGS = -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static

SRC		:= $(wildcard *.c)
OBJ		:= $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC))
LIBS	:= $(addprefix -l,$(LIBS))

CFLAGS += -DDEVICE=\"$(DEVICE)\"

CFLAGS += -DWIFI_SSID=\"$(WIFI_SSID)\"
CFLAGS += -DWIFI_PASS=\"$(WIFI_PASS)\"
CFLAGS += -DWIFI_TYPE=$(WIFI_TYPE)

CFLAGS += -DMQTT_HOST=\"$(MQTT_HOST)\"
CFLAGS += -DMQTT_PORT=$(MQTT_PORT)
CFLAGS += -DMQTT_CLIENT_ID=\"$(MQTT_CLIENT_ID)\"
CFLAGS += -DMQTT_USER=\"$(MQTT_USER)\"
CFLAGS += -DMQTT_PASS=\"$(MQTT_PASS)\"
CFLAGS += -DMQTT_SECURITY=$(MQTT_SECURITY)
CFLAGS += -DMQTT_PREFIX=\"$(MQTT_PREFIX)\"

CFLAGS += -DOTA_HOST=\"$(OTA_HOST)\"
CFLAGS += -DOTA_PORT=$(OTA_PORT)
CFLAGS += -DOTA_PATH=\"$(OTA_PATH)\"

.SECONDARY:
.PHONY: all clean

C_FILES = $(wildcard *.c)
O_FILES = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_FILES))

all: checkdevice showbuild $(BUILD_DIR) $(FIRMW_DIR) $(FIRMW_DIR)/rom0.bin $(FIRMW_DIR)/rom1.bin

$(BUILD_DIR)/%.o: %.c %.h
	@echo "CC $<"
	@$(CC) -I. -Iconfig $(SDK_INCDIR) $(CFLAGS) -o $@ -c $<

$(BUILD_DIR)/%.elf: $(O_FILES)
	@echo "LD $(notdir $@)"
	@$(LD) -L$(SDK_LIBDIR) -Tld/$(notdir $(basename $@)).ld $(LDFLAGS) -Wl,--start-group $(LIBS) $^ -Wl,--end-group -o $@

$(FIRMW_DIR)/%.bin: $(BUILD_DIR)/%.elf
	@echo "FW $(notdir $@)"
	@$(ESPTOOL2) $(FW_USER_ARGS) $^ $@ $(FW_SECTS)

$(BUILD_DIR):
	@mkdir -p $@

$(FIRMW_DIR):
	@mkdir -p $@

#	$(Q) $(ESPTOOL) -p $(ESPPORT) write_flash -fs $(ET_FS) -ff $(ET_FF) \
#  -ff $(ET_FF) 

flash:
	$(Q) $(ESPTOOL) -p $(ESPPORT) write_flash -fs $(ET_FS) \
		0x00000 $(RBOOT_FW) \
		0x02000 $(FIRMW_DIR)/rom0.bin \
		0x82000 $(FIRMW_DIR)/rom1.bin \
		0xfc000 blank/blank4.bin

clean:
	@echo "RM $(BUILD_DIR) $(FIRMW_BASE_DIR)"
	@rm -rf $(BUILD_DIR)
	@rm -rf $(FIRMW_BASE_DIR)

check-var-defined = $(if $(strip $($1)),,$(error "$1" is not defined. Check settings on top of Makefile or specify them via ENV))

checkdevice:
	$(call check-var-defined,DEVICE)

showbuild:
	@echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
	@echo "This build is for device: $(DEVICE)"
	@echo "WIFI: SSID \"$(WIFI_SSID)\", PASS \"$(WIFI_PASS)\""
	@echo "MQTT: HOST \"$(MQTT_HOST)\", PORT \"$(MQTT_PORT)\", CLIENT_ID \"$(MQTT_CLIENT_ID)\", USER \"$(MQTT_USER)\", PASS \"$(MQTT_PASS)\", SECURITY \"$(MQTT_SECURITY)\", PREFIX \"$(MQTT_PREFIX)\""
	@echo "OTA: HOST \"$(OTA_HOST)\", PORT \"$(OTA_PORT)\", PATH \"$(OTA_PATH)\""
	@echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

$(foreach bdir,$(BUILD_DIR),$(eval $(call compile-objects,$(bdir))))
