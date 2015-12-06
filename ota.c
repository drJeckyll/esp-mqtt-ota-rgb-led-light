#include <osapi.h>
#include <os_type.h>

#include "ota.h"
#include "rboot-ota.h"
#include "debug.h"

void ICACHE_FLASH_ATTR
OtaUpdate_CallBack(bool result, uint8 rom_slot)
{
	if(result == true) {
		// success
		if (rom_slot == FLASH_BY_ADDR) {
			INFO("Write successful\r\n");
		} else {
			// set to boot new rom and then reboot
			INFO("Firmware updated, rebooting to rom %d...\r\n", rom_slot);
			rboot_set_current_rom(rom_slot);
			system_restart();
		}
	} else {
		// fail
		INFO("Firmware update failed!\r\n");
	}
}

void ICACHE_FLASH_ATTR
OtaUpdate()
{	
	// start the upgrade process
	if (rboot_ota_start((ota_callback)OtaUpdate_CallBack)) {
		uint32_t rom;
		rom = rboot_get_current_rom();
		if (rom == 0) rom = 1; else rom = 0;
		INFO("Updating from http://%s:%d%srom%d.bin\r\n", OTA_HOST, OTA_PORT, OTA_PATH, rom);
	} else {
		INFO("Updating failed!\r\n");
	}
	
}
