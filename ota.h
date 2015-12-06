
#ifndef OTA_H_
#define OTA_H_
static os_timer_t network_timer;

void ICACHE_FLASH_ATTR OtaUpdate_CallBack(bool result, uint8 rom_slot);
void ICACHE_FLASH_ATTR OtaUpdate();
#endif
