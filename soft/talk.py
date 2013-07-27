#!/usr/bin/env python

from makerbot_driver.s3g import s3g
from threading import Condition
import time
from traceback import print_exc
import logging

def test():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    bot = s3g.from_filename("/dev/ttyS1", Condition(), baudrate=921600)
    bot.open()
    try:
        v = bot.get_version()
        print "Bot version: %X" % v
    except:
        print_exc()

if __name__ == "__main__":
    test()
