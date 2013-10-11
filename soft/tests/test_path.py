from unittest import TestCase

from fpgamotion.path_plan import make_junction, Point, expand_path, speed_path
from math import sin, cos, pi

class BasicTestCase(TestCase):
    def test_junction(self):
        p1 = Point(0,0,0)
        print abs(p1)
        p2 = Point(0,2,0)
        print abs(p2)
        p3 = Point(2,2,0)
        print abs(p3)
        pm = Point(0,1,0)
        pm1 = Point(0.1,1,0)
        pm2 = Point(0.00000001, 1,0)
        p2a = Point(0.0000001, 2.0, 0)

        n = (p3 - p2).getNormalized()
        self.assertEqual(n, Point(1,0,0))

        for descr, b, m, e, dev, exp_r in [
                    ("straight 1", p1, pm, p2, 0.1, 0),
                    ("straight 2", p1, pm2, p2, 0.1, 0),
                    ("straight 3", p1, pm, p2a, 0.1, 0),
                    ("90", p1, p2, p3, 0.1, 3),
                    ("45", p1, p3, p2, 0.1, 3),
                    ("almost straight", p1, pm1, p2, 0.1, 3),
                ]:

            print "----- %s -----" % descr
            print "b:", b
            print "m:", m
            print "e:", e
            result = make_junction(b,m,e, dev)
            if result:
                for p,v,r in result:
                    print "  ", p, v, r
            else:
                print result

            self.assertEqual(len(result), exp_r)

    def format_path(self, path):
        txt = []
        for p in path:
            if len(p)>2 and p[2]:
                txt.append("(%.2f, %.2f) at (%.2f, %.2f) r=%.2f" % (p[0].x, p[0].y, p[1].x, p[1].y, p[2]))
            else:
                txt.append("(%.2f, %.2f) at (%.2f, %.2f)" % (p[0].x, p[0].y, p[1].x, p[1].y))

        return txt

    def test_expand1(self):
        path = [
                Point( 0.0,  5.0),
                Point( 0.0, 10.0),
                Point(10.0, 10.0),
                Point(10.0,  0.0),
                Point( 0.0,  0.0),
                Point( 0.0,  5.0)
        ]

        p = expand_path(path, 0.1)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 5.00) at (0.00, 0.00)",
                "(0.00, 9.76) at (0.00, 1.00) r=0.24",
                "(0.05, 9.95) at (0.50, 0.50) r=0.24",
                "(0.24, 10.00) at (1.00, 0.00)",
                "(9.76, 10.00) at (1.00, 0.00) r=0.24",
                "(9.95, 9.95) at (0.50, -0.50) r=0.24",
                "(10.00, 9.76) at (0.00, -1.00)",
                "(10.00, 0.24) at (0.00, -1.00) r=0.24",
                "(9.95, 0.05) at (-0.50, -0.50) r=0.24",
                "(9.76, 0.00) at (-1.00, 0.00)",
                "(0.24, 0.00) at (-1.00, 0.00) r=0.24",
                "(0.05, 0.05) at (-0.50, 0.50) r=0.24",
                "(0.00, 0.24) at (0.00, 1.00)",
                "(0.00, 5.00) at (0.00, 0.00)"
            ])

    def test_expand_circle(self):
        path = [] 
        segments = 5
        for i in range(0, segments):
            angle = pi/10 * i / segments
            path.append(Point(sin(angle) * 50, cos(angle) * 50))

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 50.00) at (0.00, 0.00)",
                "(1.57, 49.95) at (1.00, -0.03) r=49.98",
                "(3.14, 49.90) at (1.00, -0.06) r=49.98",
                "(4.70, 49.75) at (1.00, -0.09)",
                "(4.70, 49.75) at (1.00, -0.09) r=49.98",
                "(6.27, 49.60) at (0.99, -0.13) r=49.98",
                "(7.82, 49.36) at (0.99, -0.16)",
                "(7.82, 49.36) at (0.99, -0.16) r=49.98",
                "(9.37, 49.11) at (0.98, -0.19) r=49.98",
                "(10.90, 48.77) at (0.98, -0.22)",
                "(12.43, 48.43) at (0.00, 0.00)"
            ])


    def test_expand_short(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
            ] 

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 10.00) at (0.00, 0.00)"
            ])


    def test_expand_straight(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
                Point( 0.0, 20.0),
            ] 

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 20.00) at (0.00, 0.00)"
            ])


    def test_expand_straight_long(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
                Point( 0.0, 15.0),
                Point( 0.0, 20.0),
                Point( 5.0, 20.0),
                Point( 15.0, 20.0),
            ] 

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 19.28) at (0.00, 1.00) r=0.72",
                "(0.15, 19.85) at (0.50, 0.50) r=0.72",
                "(0.72, 20.00) at (1.00, 0.00)",
                "(15.00, 20.00) at (0.00, 0.00)"
            ])

    def test_expand_target_r(self):
        path = [
                Point( 0.0,  5.0),
                Point( 0.0, 10.0),
                Point(10.0, 10.0),
                Point(10.0,  0.0),
                Point( 0.0,  0.0),
                Point( 0.0,  5.0),
                Point( 0.5,  0.0)
        ]

        p = expand_path(path, 0.1, 0.1)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 5.00) at (0.00, 0.00)",
                "(0.00, 9.90) at (0.00, 1.00) r=0.10",
                "(0.02, 9.98) at (0.50, 0.50) r=0.10",
                "(0.10, 10.00) at (1.00, 0.00)",
                "(9.90, 10.00) at (1.00, 0.00) r=0.10",
                "(9.98, 9.98) at (0.50, -0.50) r=0.10",
                "(10.00, 9.90) at (0.00, -1.00)",
                "(10.00, 0.10) at (0.00, -1.00) r=0.10",
                "(9.98, 0.02) at (-0.50, -0.50) r=0.10",
                "(9.90, 0.00) at (-1.00, 0.00)",
                "(0.10, 0.00) at (-1.00, 0.00) r=0.10",
                "(0.02, 0.02) at (-0.50, 0.50) r=0.10",
                "(0.00, 0.10) at (0.00, 1.00)",
                "(0.00, 4.89) at (0.00, 1.00) r=0.01",
                "(0.00, 4.90) at (0.05, 0.00) r=0.01",
                "(0.01, 4.90) at (0.10, -1.00)",
                "(0.50, 0.00) at (0.00, 0.00)"
            ])


    def test_speed_single(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
            ] 

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 10.00) at (0.00, 0.00)"
            ])

        sp = speed_path(p, 100, 1000)
        print sp
        self.assertEqual(`sp`, '[Segment(l, (0.0, 0.0, 0.0), (0.0, 10.0, 0.0), (0, 0, 0), (0.0, 100.0, 0.0), (0, 0, 0))]')


    def test_speed_simple(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
                Point( 10.0, 10.0),
            ] 

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 9.28) at (0.00, 1.00) r=0.72",
                "(0.15, 9.85) at (0.50, 0.50) r=0.72",
                "(0.72, 10.00) at (1.00, 0.00)",
                "(10.00, 10.00) at (0.00, 0.00)",
            ])

        sp = speed_path(p, 100, 1000)
        for s in sp:
            print s


    def test_speed_circle(self):
        path = []
        segments = 5
        for i in range(0, segments):
            angle = pi/10 * i / segments
            path.append(Point(sin(angle) * 50, cos(angle) * 50))

        p = expand_path(path, 0.3)
        txt = self.format_path(p)
        print "\n".join(txt)

        sp = speed_path(p, 100, 1000)
        for s in sp:
            print s











