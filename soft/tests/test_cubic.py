from unittest import TestCase

from fpgamotion.cubic import Cubic

class BasicTestCase(TestCase):
    def test1(self):
        c = Cubic(0, 0, 0.5, 1, 1)
        self.assertEqual(c.a, 0)
        self.assertEqual(c.b, 0.5)
        self.assertEqual(c.c, 0)
        self.assertEqual(c.d, 0)
        a = c.get_max_a(1)
        v = c.get_max_v(1)
        self.assertEqual(a, 1.0)
        self.assertEqual(v, 1.0)

    def test2(self):
        c = Cubic(0, 0, 1, 0, 1)
        self.assertEqual(c.a, -2.0)
        self.assertEqual(c.b, 3.0)
        self.assertEqual(c.c, 0)
        self.assertEqual(c.d, 0)

        a0 = c.get_a(0)
        at = c.get_a(1)
        am = c.get_a(0.5)
        vm = c.get_v(0.5)

        a = c.get_max_a(1)
        v = c.get_max_v(1)

        self.assertEqual(a, 6.0)
        self.assertEqual(v, 1.5)
        self.assertEqual(a0, 6.0)
        self.assertEqual(am, 0)
        self.assertEqual(at, -6.0)
        self.assertEqual(vm, 1.5)

