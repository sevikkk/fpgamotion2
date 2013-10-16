from unittest import TestCase

from fpgamotion.path_plan import *
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
                for p,v,r,e in result:
                    print "  ", p, v, r, e
            else:
                print result

            self.assertEqual(len(result), exp_r)

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
        txt = format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
            "(0.00, 5.00) at (0.00, 0.00)",
            "(0.00, 9.76) at (0.00, 1.00) r=0.24",
            "(0.07, 9.93) at (0.71, 0.71) r=0.24",
            "(0.24, 10.00) at (1.00, 0.00)",
            "(9.76, 10.00) at (1.00, 0.00) r=0.24",
            "(9.93, 9.93) at (0.71, -0.71) r=0.24",
            "(10.00, 9.76) at (0.00, -1.00)",
            "(10.00, 0.24) at (0.00, -1.00) r=0.24",
            "(9.93, 0.07) at (-0.71, -0.71) r=0.24",
            "(9.76, 0.00) at (-1.00, 0.00)",
            "(0.24, 0.00) at (-1.00, 0.00) r=0.24",
            "(0.07, 0.07) at (-0.71, 0.71) r=0.24",
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
        txt = format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 50.00) at (0.00, 0.00)",
                "(1.57, 49.95) at (1.00, -0.03) r=49.98",
                "(3.14, 49.88) at (1.00, -0.06) r=49.98",
                "(4.70, 49.75) at (1.00, -0.09)",
                "(4.70, 49.75) at (1.00, -0.09) r=49.98",
                "(6.26, 49.58) at (0.99, -0.13) r=49.98",
                "(7.82, 49.36) at (0.99, -0.16)",
                "(7.82, 49.36) at (0.99, -0.16) r=49.98",
                "(9.36, 49.09) at (0.98, -0.19) r=49.98",
                "(10.90, 48.77) at (0.98, -0.22)",
                "(12.43, 48.43) at (0.00, 0.00)"
            ])


    def test_expand_short(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
            ] 

        p = expand_path(path, 0.3)
        txt = format_path(p)
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
        txt = format_path(p)
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
        txt = format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 0.00) at (0.00, 0.00)",
                "(0.00, 19.28) at (0.00, 1.00) r=0.72",
                "(0.21, 19.79) at (0.71, 0.71) r=0.72",
                "(0.72, 20.00) at (1.00, 0.00)",
                "(15.00, 20.00) at (0.00, 0.00)",
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
        txt = format_path(p)
        print "\n".join(txt)
        self.assertEqual(txt, [
                "(0.00, 5.00) at (0.00, 0.00)",
                "(0.00, 9.90) at (0.00, 1.00) r=0.10",
                "(0.03, 9.97) at (0.71, 0.71) r=0.10",
                "(0.10, 10.00) at (1.00, 0.00)",
                "(9.90, 10.00) at (1.00, 0.00) r=0.10",
                "(9.97, 9.97) at (0.71, -0.71) r=0.10",
                "(10.00, 9.90) at (0.00, -1.00)",
                "(10.00, 0.10) at (0.00, -1.00) r=0.10",
                "(9.97, 0.03) at (-0.71, -0.71) r=0.10",
                "(9.90, 0.00) at (-1.00, 0.00)",
                "(0.10, 0.00) at (-1.00, 0.00) r=0.10",
                "(0.03, 0.03) at (-0.71, 0.71) r=0.10",
                "(0.00, 0.10) at (0.00, 1.00)",
                "(0.00, 4.89) at (0.00, 1.00) r=0.01",
                "(0.00, 4.90) at (1.00, 0.05) r=0.01",
                "(0.01, 4.90) at (0.10, -1.00)",
                "(0.50, 0.00) at (0.00, 0.00)",
            ])


    def test_speed_single(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
            ] 

        sp = speed_path(path, 100, 1000, 0.1)
        for s in sp:
            print s
        self.assertEqual(`sp`, '[LinearSegment(s_pos=(0.0, 0.0, 0.0), e_pos=(0.0, 10.0, 0.0), s_v=0, t_v=100, e_v=0)]')


    def test_speed_simple(self):
        path = [
                Point( 0.0,  0.0),
                Point( 0.0, 10.0),
                Point( 10.0, 10.0),
            ] 

        sp = speed_path(path, 100, 1000, 0.1)
        for s in sp:
            print s


    def test_speed_circle(self):
        path = []
        segments = 5
        for i in range(0, segments):
            angle = pi/10 * i / segments
            path.append(Point(sin(angle) * 50, cos(angle) * 50))

        sp = speed_path(path, 100.0, 1000.0, 0.1)
        for s in sp:
            print s

    def test_reverse_circle(self):
        path = []
        segments = 5
        for i in range(0, segments):
            angle = pi/10 * i / segments
            path.append(Point(sin(angle) * 50, cos(angle) * 50))

        sp = speed_path(path, 100.0, 100.0, 0.1)

        for s in sp:
            print s

        reverse_pass(sp, 1000.0)

        for s in sp:
            print s

    def test_max_speed(self):
        n = 0
        ok = 0
        for accel in range(-1000,1000,251):
            for start_speed in range(0,200,25):
                for distance in range(10,200,25):
                    n += 1
                    try:
                        end_speed = max_allowable_speed(accel, start_speed, distance)
                    except ValueError:
                        self.assertLess((1.0*start_speed/-accel)*start_speed/2,distance)
                        continue

                    dt = (end_speed - start_speed)/accel
                    dist = (end_speed + start_speed) / 2 * dt

                    self.assertAlmostEqual(distance, dist)
                    ok += 1

        print n, ok

    def test_acc_dist(self):
        for accel in range(1,1000,251):
            for start_speed in range(0,200,25):
                for end_speed in range(0,200,25):
                    distance = estimate_acceleration_distance(start_speed, end_speed, accel)

                    dt = 1.0 * (end_speed - start_speed)/accel
                    dist = (end_speed + start_speed) / 2.0 * dt

                    self.assertAlmostEqual(distance, dist)

    def test_intersection_dist(self):
        for accel in range(1,1000,251):
            for start_speed in range(0,200,25):
                for end_speed in range(0,200,25):
                    for distance in range(10,200,25):
                        int_distance = intersection_distance(start_speed, end_speed, accel, distance)

                        top_speed = max_allowable_speed(accel, start_speed, int_distance)

                        dt1 = 1.0 * (top_speed - start_speed)/accel
                        dist1 = (top_speed + start_speed) / 2.0 * dt1

                        self.assertAlmostEqual(int_distance, dist1)

                        dt2 = 1.0 * (top_speed - end_speed)/accel
                        dist2 = (top_speed + end_speed) / 2.0 * dt2
                        self.assertAlmostEqual(distance, dist1 + dist2)

    def test_reverse_quad(self):
        for accel in (100, 1000):
            for speed in (100,1000):
                for deviation in (0.1, 1.0):
                    print "=========== CASE %d %d %f =============" % (speed, accel, deviation)
                    path = [
                            Point( 0.0,  50.0),
                            Point( 0.0, 100.0),
                            Point(100.0, 100.0),
                            Point(70.0, 70.0),
                            Point(100.0, 30.0),
                            Point(100.0, 20.0),
                            Point(60.0, 60.0),
                            Point(50.0, 50.0),
                            Point(100.0,  0.0),
                            Point( 0.0,  0.0),
                            Point( 0.0,  50.0)
                    ]

                    print "===== speed ====="
                    sp = speed_path(path, speed, accel, deviation)

                    for s in sp:
                        print s

                    print "===== reverse ====="
                    reverse_pass(sp, accel)

                    for s in sp:
                        print s

                    print "===== forward ====="
                    forward_pass(sp, accel)
                    for s in sp:
                        print s

                    print "===== profile ====="
                    make_profile(sp, Point(accel*1.5, accel, accel/10.0))

                    txt = path_to_svg(sp, 3.0)
                    #open("tests/expected/p_%04d_%05d_%f.svg" % (speed, accel, deviation), "w").write(txt)
                    exp_txt = open("tests/expected/p_%04d_%05d_%f.svg" % (speed, accel, deviation), "r").read()
                    self.assertEqual(txt, exp_txt)

                    txt = []

                    for s in sp:
                        if s.cubics:
                            for t, c_x, c_y, c_z in s.cubics:
                                txt.append("%6.3f | %11.3f %11.3f | %11.3f %11.3f " % (t, c_x.get_a(0), c_x.get_j(0), c_y.get_a(0), c_y.get_j(0)))

                    txt = "\n".join(txt)
                    #open("tests/expected/p_%04d_%05d_%f.profile" % (speed, accel, deviation), "w").write(txt)
                    exp_txt = open("tests/expected/p_%04d_%05d_%f.profile" % (speed, accel, deviation), "r").read()
                    self.assertEqual(txt, exp_txt)







































