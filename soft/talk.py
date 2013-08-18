#!/usr/bin/env python

from makerbot_driver.s3g import s3g
from threading import Condition
import time
from traceback import print_exc
import logging
import struct
import makerbot_driver.Encoder

class FPGAMotion(s3g):
    def FM_reg_write(self, reg, value):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """
        payload = struct.pack(
            '<BBi',
            60, 
            reg,
            value
        )

        response = self.writer.send_query_payload(payload)
        [response_code] = makerbot_driver.Encoder.unpack_response(
            '<B', response)
        # TODO: check response_code
        return response_code

    def FM_reg_read(self, reg):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """
        payload = struct.pack(
            '<BB',
            61, 
            reg
        )

        response = self.writer.send_query_payload(payload)
        [response_code, value] = makerbot_driver.Encoder.unpack_response(
            '<BI', response)
        # TODO: check response_code
        return value

    def FM_stb_write(self, value):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """
        payload = struct.pack(
            '<BI',
            62, 
            value
        )

        response = self.writer.send_query_payload(payload)
        [response_code] = makerbot_driver.Encoder.unpack_response(
            '<B', response)
        # TODO: check response_code
        return response_code

def reg63_cnt(bot):
        cv = bot.FM_reg_read(63)
        print "read 63: %08X" % cv
        while 1:
            cv += 1
            v = bot.FM_reg_write(63, cv)
            #print "write 63: %02X" % v
        v = bot.FM_reg_read(63)
        print "read 63: %08X" % v

def test():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    bot = FPGAMotion.from_filename("/dev/ttyS1", Condition(), baudrate=921600)
    bot.open()
    try:
        v = bot.get_version()
        print "Bot version: %X" % v
        while 1:
            print 1
            bot.FM_reg_write(1, 100000) # 1kHz Acceleration clock
            bot.FM_reg_write(2, 500) # 0.5 seconds cycle

            # motor step gen
            bot.FM_reg_write(27, 1000) # 1 + 3 + 1 us pulse
            bot.FM_reg_write(28, 2000) # 0.5 seconds cycle
            bot.FM_reg_write(29, 3000) # 0.5 seconds cycle

            #x profile
            bot.FM_reg_write(5, 0) # 100 Hz step rate
            bot.FM_reg_write(6, 10990*3) # a = 0
            bot.FM_reg_write(7, 0) # j = 0
            bot.FM_reg_write(8, 10990) # abort_a = 0.1s for full stop

            #y profile
            bot.FM_reg_write(11, 0) # 100 Hz step rate
            bot.FM_reg_write(12, 10990*30) # a = 0
            bot.FM_reg_write(13, -3800) # j = 0
            bot.FM_reg_write(14, 10990*20) # abort_a = 0.1s for full stop

            bot.FM_reg_write(0, 15 + 
                    (1 << 5) + (1<<6) + (1<<7) + 
                    (1 << 9) + (1<<10) + (1<<11) + 
                    (40<<20)) # set dt, steps, x_v, x_a, x_j, reset dt, reset_steps, step_bit = 40
            bot.FM_stb_write(1) # load
            time.sleep(1.6)
    except:
        print_exc()

if __name__ == "__main__":
    test()
