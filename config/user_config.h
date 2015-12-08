#ifndef _USER_CONFIG_H_
#define _USER_CONFIG_H_

#define CFG_HOLDER	0x00FF55A1	/* Change this value to load default configurations */
//#define CFG_LOCATION 0x7e		/* After first rom - you can use this or next one */
#define CFG_LOCATION 0xfc		/* After second rom - this will be aresed with blank4.bin after flashing */

//#define CLIENT_SSL_ENABLE

#define MQTT_RECONNECT_TIMEOUT 	5	/*second*/
#define MQTT_BUF_SIZE		1024
#define MQTT_KEEPALIVE		120	 /*second*/
#define DEFAULT_SECURITY	0
#define QUEUE_BUFFER_SIZE		 		2048

#define MQTT_TOPIC_PERIOD			MQTT_PREFIX"period"
#define MQTT_TOPIC_ALL				MQTT_PREFIX"all"
#define MQTT_TOPIC_ALL_COLORS		MQTT_PREFIX"colors"
#define MQTT_TOPIC_ALL_WHITE		MQTT_PREFIX"white"
#define MQTT_TOPIC_RED				MQTT_PREFIX"r"
#define MQTT_TOPIC_GREEN			MQTT_PREFIX"g"
#define MQTT_TOPIC_BLUE				MQTT_PREFIX"b"
#define MQTT_TOPIC_COLD_WHITE		MQTT_PREFIX"cw"
#define MQTT_TOPIC_WARM_WHITE		MQTT_PREFIX"ww"

#define MQTT_TOPIC_SETTINGS			MQTT_PREFIX"settings"
#define MQTT_TOPIC_SETTINGS_REPLY	MQTT_PREFIX"settings/reply"

#define MQTT_TOPIC_UPDATE			MQTT_PREFIX"update"

#define PROTOCOL_NAMEv31	/*MQTT version 3.1 compatible with Mosquitto v0.15*/
//#define PROTOCOL_NAMEv311			/*MQTT version 3.11 compatible with https://eclipse.org/paho/clients/testing/*/

// PWM levels
#define PWM_DEPTH 255
// 1 second
#define PWM_1S 1000000

/*Define the channel number of PWM*/
/*In this demo, we can set 3 for 3 PWM channels: RED, GREEN, BLUE*/
/*Or , we can choose 5 channels : RED,GREEN,BLUE,COLD-WHITE,WARM-WHITE*/
#define PWM_CHANNEL	5  //  5:5channel ; 3:3channel

/* PWM period Hz */
#define PWM_PERIOD 1000

#define LIGHT_RED			0
#define LIGHT_GREEN			1
#define LIGHT_BLUE			2
#define LIGHT_COLD_WHITE	3
#define LIGHT_WARM_WHITE	4

/*Definition of GPIO PIN params, for GPIO initialization*/
// R - 15
#define PWM_0_OUT_IO_MUX PERIPHS_IO_MUX_MTDO_U
#define PWM_0_OUT_IO_NUM 15
#define PWM_0_OUT_IO_FUNC  FUNC_GPIO15
// G - 13
#define PWM_1_OUT_IO_MUX PERIPHS_IO_MUX_MTCK_U
#define PWM_1_OUT_IO_NUM 13
#define PWM_1_OUT_IO_FUNC  FUNC_GPIO13
// B - 12
#define PWM_2_OUT_IO_MUX PERIPHS_IO_MUX_MTDI_U
#define PWM_2_OUT_IO_NUM 12
#define PWM_2_OUT_IO_FUNC  FUNC_GPIO12
// CW - 14
#define PWM_3_OUT_IO_MUX PERIPHS_IO_MUX_MTMS_U
#define PWM_3_OUT_IO_NUM 14
#define PWM_3_OUT_IO_FUNC  FUNC_GPIO14
// WW - 4
#define PWM_4_OUT_IO_MUX PERIPHS_IO_MUX_GPIO4_U
#define PWM_4_OUT_IO_NUM 4
#define PWM_4_OUT_IO_FUNC  FUNC_GPIO4

// red LED - 5
// green LED - 1

#endif
