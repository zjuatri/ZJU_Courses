/*
 * @Author: igcxl acer5502@gmail.com
 * @Date: 2024-07-28 20:41:08
 * @LastEditors: igcxl acer5502@gmail.com

 */
#ifndef _DDSM210_H
#define _DDSM210_H

#include "Arduino.h"


#define DDSM_BAUDRATE 115200

#define TYPE_DDSM115  1
#define TYPE_DDSM210  2
#define TIME_BETWEEN_CMD 4
#define TIME0UT 4


class DDSM_CTRL{
public:
	DDSM_CTRL();

	virtual void clear_ddsm_buffer();
	virtual uint8_t crc8_update(uint8_t crc, uint8_t data);
	virtual int set_ddsm_type(int inputType);
	virtual int ddsm_id_check();
	virtual int ddsm_change_id(uint8_t id);
	virtual void ddsm_change_mode(uint8_t id, uint8_t mode);
	virtual void ddsm_ctrl(uint8_t id, int cmd, uint8_t act);
	//sun add 控制四个210电机
	virtual void ddsm210_ctrl_4( int cmd1, int cmd2,int cmd3,int cmd4,uint8_t act=3);
	virtual void ddsm210_ctrl_3( int cmd1, int cmd2,int cmd3,uint8_t act=3);
	//sun add 控制2个210电机
	virtual void ddsm210_ctrl_2( int cmd1, int cmd2,uint8_t act=3);
	virtual void ddsm_get_info(uint8_t id);
	virtual void ddsm_stop(uint8_t id);
	virtual int ddsm210_fb();
	virtual int ddsm115_fb();

private:
	const size_t packet_length;   
	uint8_t packet_move[10];
	uint8_t ddsm_type;
	bool get_info_flag;

public:
	HardwareSerial *pSerial;
	
	int speed_data;  // 115 210
	int speed_data_4[4];
	int current;     // 210
	int acceleration_time; // 210
	int temperature; // 115[info] 210

	int ddsm_mode;   // 115
	int ddsm_torque; // 115
	int ddsm_u8;     // 115[info]

	int32_t mileage; // 210[info]
	int ddsm_pos;    // 115 210[info]

	int fault_code;  // 115 210
};

#endif