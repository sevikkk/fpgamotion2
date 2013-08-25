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

        value = self.list_to_val(value)

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

    def list_to_val(self, value):
        if type(value) == list:
            v = 0
            for i in value:
                v |= 1 << i

            value = v

        return value

    def FM_ints_clear(self, value):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """

        value = self.list_to_val(value)

        payload = struct.pack(
            '<BI',
            63, 
            value
        )

        response = self.writer.send_query_payload(payload)
        [response_code] = makerbot_driver.Encoder.unpack_response(
            '<B', response)
        # TODO: check response_code
        return response_code

    def FM_ints_mask(self, value):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """

        value = self.list_to_val(value)

        payload = struct.pack(
            '<BI',
            64, 
            value
        )

        response = self.writer.send_query_payload(payload)
        [response_code] = makerbot_driver.Encoder.unpack_response(
            '<B', response)
        # TODO: check response_code
        return response_code

    def format_cmd(self, cmd, *args):
        code = 0
        arg = 0
        if cmd == "WRITE":
            code = 0x40 + args[0]
            arg = args[1]
        elif cmd == "NOP":
            code = 0x80
        elif cmd == "STB":
            code = 0x81
            arg = self.list_to_val(args[0])
        elif cmd == "WAIT_ALL":
            code = 0x82
            arg = self.list_to_val(args[0])
        elif cmd == "WAIT_ANY":
            code = 0x83
            arg = self.list_to_val(args[0])
        elif cmd == "CLEAR":
            code = 0x84
            arg = self.list_to_val(args[0])
        elif cmd == "DONE":
            code = 0xBF
            if len(args)>0:
                arg = args[0]
            else:
                arg = 127
        else:
            raise RuntimeError, "bad command"

        return code, arg

    def FM_write_buffer(self, addr, values):
        """
        Get the firmware version number of the connected machine
        @return Version number
        """

        l = len(values)

        payload = struct.pack(
            '<BBH',
            65, 
            l,
            addr
        )

        for c,a in values:
            print c
            print a
            payload += struct.pack('<iB', a, c)

        response = self.writer.send_query_payload(payload)
        [response_code, addr, error, pc] = makerbot_driver.Encoder.unpack_response(
            '<BHBH', response)
        # TODO: check response_code
        return response_code, addr, error, pc

def reg63_cnt(bot):
        cv = bot.FM_reg_read(63)
        print "read 63: %08X" % cv
        while 1:
            cv += 1
            v = bot.FM_reg_write(63, cv)
            #print "write 63: %02X" % v
        v = bot.FM_reg_read(63)
        print "read 63: %08X" % v

def acc_simple(bot):
        while 1:
            print 1
            bot.FM_reg_write(1, 100000) # 1kHz Acceleration clock
            bot.FM_reg_write(2, 500) # 0.5 seconds cycle

            # motor step gen
            bot.FM_reg_write(27, 1000) # 1 + 1 + 1 us stepper pulse
            bot.FM_reg_write(28, 2000) # 
            bot.FM_reg_write(29, 3000) #

            #x profile
            bot.FM_reg_write(5, 0) # Vx = 0
            bot.FM_reg_write(6, 10990*3) # Ax = 3rpm/s/s
            bot.FM_reg_write(7, 0) # j = 0
            bot.FM_reg_write(8, 10990) # abort_a = 1rpm/s/s

            #y profile
            bot.FM_reg_write(11, 0) # Vy = 0
            bot.FM_reg_write(12, 10990*30) # Ay = 30rpm/s/s
            bot.FM_reg_write(13, -3800) # Jy = XXX
            bot.FM_reg_write(14, 10990*20) # abort_a = 20rpm/s/s

            bot.FM_reg_write(0, 15 + 
                    (1 << 5) + (1<<6) + (1<<7) + 
                    (1 << 9) + (1<<10) + (1<<11) + 
                    (40<<20)) # set dt, steps, x_v, x_a, x_j, y_x, y_a, y_j, reset dt, reset_steps, step_bit = 40
            bot.FM_stb_write([0]) # load
            time.sleep(1.6)

def buf_exec_simple(bot):
    r = bot.FM_write_buffer(0, [
            bot.format_cmd("WRITE", 1, 100000), # 1kHz Acceleration clock
            bot.format_cmd("WRITE", 2, 500) ,# 0.5 seconds cycle

            # motor step gen
            bot.format_cmd("WRITE", 27, 1000), # 1 + 1 + 1 us stepper pulse
            bot.format_cmd("WRITE", 28, 2000), # 
            bot.format_cmd("WRITE", 29, 3000), #

            #x profile
            bot.format_cmd("WRITE", 5, 0), # Vx = 0
            bot.format_cmd("WRITE", 6, 10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 7, 0), # j = 0
            bot.format_cmd("WRITE", 8, 10990), # abort_a = 1rpm/s/s

            #y profile
            bot.format_cmd("WRITE", 11, 0), # Vy = 0
            bot.format_cmd("WRITE", 12, 10990*30), # Ay = 30rpm/s/s
            bot.format_cmd("WRITE", 13, -3800), # Jy = XXX
            bot.format_cmd("WRITE", 14, 10990*20), # abort_a = 20rpm/s/s

            bot.format_cmd("WRITE", 0, 15 + 
                    (1 << 5) + (1<<6) + (1<<7) + 
                    (1 << 9) + (1<<10) + (1<<11) + 
                    (40<<20)), # set dt, steps, x_v, x_a, x_j, y_x, y_a, y_j, reset dt, reset_steps, step_bit = 40
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("WRITE", 2, 1500) ,# 0.5 seconds cycle
            bot.format_cmd("WRITE", 6, -10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 12, 10990*10), # Jy = XXX
            bot.format_cmd("WRITE", 13, 0), # Jy = XXX
            bot.format_cmd("WRITE", 0, 10 + (1<<6) + (1<<7) + (1<<10) + (1<<11) + (40<<20)),
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("WRITE", 6, 10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 12, -10990*10), # Jy = XXX
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("WRITE", 6, -10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 12, 10990*30), # Jy = XXX
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("WRITE", 6, 10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 12, -10990*30), # Jy = XXX
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("WRITE", 6, -10990*3), # Ax = 3rpm/s/s
            bot.format_cmd("WRITE", 12, 10990*30), # Jy = XXX
            bot.format_cmd("STB", [0]), # load
            bot.format_cmd("WAIT_ALL", [0]), # wait
            bot.format_cmd("CLEAR", [0]), # wait

            bot.format_cmd("DONE"), # wait
    ])
    print r
    bot.FM_reg_write(62, 0) # abort_a = 20rpm/s/s
    bot.FM_stb_write([30]) # load
    t = time.time()
    while 1:
        r = bot.FM_write_buffer(0, [])
        print r
        if (r[2] == 127) or (time.time() - t > 10):
            break
        time.sleep(0.3)

    print "done"
    time.sleep(3)

def test():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    bot = FPGAMotion.from_filename("/dev/ttyS1", Condition(), baudrate=921600)
    bot.open()
    try:
        v = bot.get_version()
        print "Bot version: %X" % v
        buf_exec_simple(bot)
    except:
        print_exc()

    print "\ndisabling motors"
    bot.FM_stb_write([29]) # abort executor
    bot.FM_reg_write(0, ((1<<26) | (1<<27) | (1<<28) | (1<<29))) # disable motors

if __name__ == "__main__":
    test()
