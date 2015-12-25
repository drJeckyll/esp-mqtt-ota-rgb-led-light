# esp-mqtt-ota-rgb-led-light
ESP8266 MQTT control of RGB Led strip with OTA updates

Code was written for this product: http://www.aliexpress.com/item/rgb-strip-WiFi-controller-1-port-control-15-rgb-lights-communicate-with-Android-phone-to-dim/32301423622.html

Settings for WIFI, MQTT and OTA are in Makefile, or you can set them via env:
```
DEVICE=test WIFI_SSID=Test make
```
You must set DEVICE since it is used both OTA and MQTT.

Each color is controled via separate MQTT topic. You can change all colors in same time, all white colors in same time and all in same time. You can also change PWM period between (1000 and 10000).

All topics can be adjusted via config/user_config.h

```
MQTT_PREFIX"period" - for period
MQTT_PREFIX"all"    - for all colors & white
MQTT_PREFIX"colors" - for colors only
MQTT_PREFIX"white"  - for white only
MQTT_PREFIX"r"      - RED
MQTT_PREFIX"g"      - GREEN
MQTT_PREFIX"b"      - BLUE
MQTT_PREFIX"cw"     - Cool White
MQTT_PREFIX"ww"     - Warm White
```

Settings are saved after each change. When device is rebooted settings are restored. After each change and after restart you will recive new settings via MQTT_PREFIX"settings/reply" topic in JSON format. To get settings just send something to MQTT_PREFIX"settings"

When all colors are set to 0 or max, PWM will be turned OFF. In every other case PWM will be ON. This is ESP8266 PWM limitation. Max can be calculated like this: period * 1000 / 45. When you change period it will change max.

To reboot ESP8266 just send something to MQTT_PREFIX"restart".

To perform OTA update, first compile rom0.bin and rom1.bin. Put them on web server which can be accessed by http://OTA_HOST:OTA_PORT/OTA_PATH. For example:
```
OTA_HOST="192.168.1.1"
OTA_PORT=80
OTA_PATH="/firmware/"
```
For web server root use "/". Always put trailing slash!

Then just send someting to MQTT_PREFIX"update". After 10-15 seconds update will be done. 

There is no version control of bin files. Update is performed every time no matter if it is old ot new bin file.

If you use BOOT_CONFIG_CHKSUM and BOOT_IROM_CHKSUM (and you should - see warning bellow) and update failed device will return with old bin. You can check which bin is loaded by check settings and see rom:0 (for example). After update succes it will be rom:1. Else it will be rom:0 again, so you must perform update again.

You need:
* rboot boot loader: https://github.com/raburton/rboot
* esptool2: https://github.com/raburton/esptool2

**WARNING:** rboot must be compiled with BOOT_CONFIG_CHKSUM and BOOT_IROM_CHKSUM in rboot.h or it will not boot.

You can remove -iromchksum from FW_USER_ARGS in Makefile and use default settings but OTA update will be unrealible - corrupt roms & etc.

If BOOT_CONFIG_CHKSUM and BOOT_IROM_CHKSUM are enabled then rBoot wi-iromchksumll recover from last booted rom and OTA update is much more stable.

This code was tested with esp-open-sdk (SDK 1.4.0). Flash size 1MB (8Mbit) or more.
