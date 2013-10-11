#!/usr/bin/env python
from vector3 import Vector3 as Point
from math import sqrt, pow

EPS = 0.000001


def make_junction(p1, p2, p3, deviation, target_r = None):
    v1 = (p2 - p1).getNormalized()
    v2 = (p3 - p2).getNormalized()

    cos_theta = -v1.x * v2.x -v1.y * v2.y -v1.z * v2.z 
    if 1.0 - abs(cos_theta) < EPS:
        print "straight"
        return []

    sin_theta_d2 = sqrt(0.5*(1.0-cos_theta))

    print "cos_theta:", cos_theta
    print "sin_theta_d2:", sin_theta_d2
    r = deviation * sin_theta_d2/(1.0-sin_theta_d2)
    print "r:", r
    seg = sqrt(pow(r+deviation,2) - r*r)
    print "seg:", seg

    avail_seg = min(abs(p2-p1), abs(p3-p2))/2
    if seg > avail_seg:
        k = avail_seg/seg

        r *= k
        deviation *= k
        seg *= k

    if target_r and (r > target_r):
        k = target_r / r

        r *= k
        deviation *= k
        seg *= k

    pr1 = p2 - v1 * seg
    vm = (v2 - v1)/2
    vt = (v1 + v2)/2
    pr2 = p2 + vm * deviation
    pr3 = p2 + v2 * seg

    return [(pr1, v1, r), (pr2, vt, r), (pr3, v2, None)]

def expand_path(points, deviation, target_r = None):
    num_points = len(points)
    cur_point = 2
    path = [(points[0], Point(0,0,0), None)]

    for i in range(1, num_points - 1):
        add_points = make_junction(
                points[i - 1],
                points[i],
                points[i + 1],
                deviation,
                target_r
        )

        path += add_points

    path += [(points[-1], Point(0,0,0), None)]

    return path

class Segment(object):
    def __init__(self, start_pos = None, end_pos = None, start_speed = None, top_speed = None, end_speed = None, kind = None):
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.start_speed = start_speed
        self.top_speed = top_speed
        self.end_speed = end_speed
        self.kind = kind

    def __repr__(self):
        return "Segment(%s, %s, %s, %s, %s, %s)" % (self.kind, self.start_pos, self.end_pos, self.start_speed, self.top_speed, self.end_speed)

def speed_path(path, speed, acceleration):
    num_points = len(path)
    cur_point = 0
    new_path = []

    s_pos, s_v, s_r  = path[0]

    for i in range(1, num_points):
        e_pos, e_v, e_r  = path[i]
        s_r = s_r or path[i - 1][2]

        if abs(e_pos - s_pos) < EPS:
            continue

        if s_r is None:
            t_v = (e_pos - s_pos).getNormalized() * speed
            kind = 'l'
            if e_r is None:
                e_linear_v = speed
            else:
                e_linear_v = min(speed, sqrt(acceleration * e_r))
        else:
            kind = 'r'
            t_v = None
            s_linear_v = min(speed, sqrt(acceleration * s_r))
            if e_r is None:
                e_linear_v = s_linear_v
            else:
                e_linear_v = min(speed, sqrt(acceleration * e_r))

        e_v *= e_linear_v

        new_path.append(Segment(s_pos, e_pos, s_v, t_v, e_v, kind))

        s_pos, s_v, s_r = e_pos, e_v, e_r 

    return new_path
        
