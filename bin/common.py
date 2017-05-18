#! /usr/bin/env python
"""
    Common functionality for logging, exiting, etc.
"""
from logging.handlers import RotatingFileHandler
import logging
import time


LOGGER = logging.getLogger("Rotating Log")
LOGGER.setLevel(logging.INFO)
HANDLER = RotatingFileHandler('logs/build.log', maxBytes=10*1024, backupCount=5)
LOGGER.addHandler(HANDLER)


def log(MSG):
    print time.strftime("%y-%m-%d:%H-%M: ") + MSG
    LOGGER.info(time.strftime("%y-%m-%d:%H-%M: ")+ MSG)