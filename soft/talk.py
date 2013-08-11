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
            '<BBI',
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

def test():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    bot = FPGAMotion.from_filename("/dev/ttyS1", Condition(), baudrate=921600)
    bot.open()
    try:
        v = bot.get_version()
        print "Bot version: %X" % v
        cv = bot.FM_reg_read(13)
        print "read 13: %08X" % cv
        while 1:
            cv += 1
            v = bot.FM_reg_write(13, cv)
            #print "write 13: %02X" % v
        v = bot.FM_reg_read(13)
        print "read 13: %08X" % v
    except:
        print_exc()

if __name__ == "__main__":
    test()
