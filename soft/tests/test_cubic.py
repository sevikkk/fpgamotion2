from unittest import TestCase

from fpgamotion.cubic import Cubic, HwCubic

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

class HwTestCase(TestCase):
    def test_basic(self):
        c = HwCubic(0, 0, 5, 100, 0.1) # 1000 mm/s^2
        c.calc_hw_coefs(0.1)
        print "bit_k:", c.bit_k
        print "t:", c.hw_t
        print "x:", c.hw_x0
        print "v:", c.hw_v0
        print "a:", c.hw_a0
        print "j:", c.hw_j0

        for t,x, v in c.emu():
            print t, x, x - c.get_x(t), v, v - c.get_v(t)

        last = c.get_last()
        print last
        self.assertAlmostEqual(last[0], 0.1)
        self.assertAlmostEqual(last[1], 5.0, places = 2)
        self.assertAlmostEqual(last[2], 100.0, places = 2)

    def test_out_of_range(self):
        c = HwCubic(0, 0, 5, 100, 0.1) # 1000 mm/s^2
        c.step_bit = 50
        c.acc_hz = 100
        c.calc_hw_coefs(0.1)

        self.assertRaises(ValueError, c.get_last)

    def test_big_error(self):
        c = HwCubic(0, 0, 5, 100, 0.1) # 1000 mm/s^2
        c.step_bit = 20
        c.acc_hz = 100
        c.calc_hw_coefs(0.1)

        for t,x, v in c.emu():
            print t, x, x - c.get_x(t), v, v - c.get_v(t)

        self.assertRaises(ValueError, c.get_last)

