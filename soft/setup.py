import os
from setuptools import setup

setup(
    name = "fpgamotion",
    version = "0.0.1",
    author = "Vsevolod Lobko",
    author_email = "seva@sevik.org",
    description = ("FPGAMotion utilities"),
    packages=['fpgamotion'],
    install_requires = [
        'recordtype',
        ],
    entry_points = {
        'console_scripts': [
            'fm_talk = fpgamotion.talk:test',
            ]
        }
)
