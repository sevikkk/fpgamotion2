from unittest import TestCase

from fpgamotion.path_plan import Point


class BasicTestCase(TestCase):
    def test_no_args(self):
        p = Point()
        print p
        self.assertEqual(p.x, 0.0)
        self.assertEqual(p.y, 0.0)
        self.assertEqual(p.z, 0.0)

    def test_pos(self):
        p = Point(1)
        print p
        self.assertEqual(p.x, 1)
        self.assertEqual(p.y, 0.0)

    def test_kw(self):
        p = Point(y=1)
        print p
        self.assertEqual(p.y, 1)
        self.assertEqual(p.x, 0.0)
