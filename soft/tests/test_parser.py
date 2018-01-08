from unittest import TestCase

from fpgamotion.parse import Parser



class BasicTestCase(TestCase):
    def test_G90(self):
        p = Parser()
        p.parse_line("G90")
        self.assertEqual(p.mode, "abs")

    def test_file(self):
        p = Parser()
        p.parse_file('tests/data/derzh.gcode')
        for m in sorted(p.mcodes.keys()):
            print "def do_%s(self, args): pass" % m

