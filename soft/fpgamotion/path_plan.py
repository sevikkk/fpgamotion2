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

def format_path(path):
    txt = []
    for p in path:
        if len(p)>2 and p[2]:
            txt.append("(%.2f, %.2f) at (%.2f, %.2f) r=%.2f" % (p[0].x, p[0].y, p[1].x, p[1].y, p[2]))
        else:
            txt.append("(%.2f, %.2f) at (%.2f, %.2f)" % (p[0].x, p[0].y, p[1].x, p[1].y))

    return txt

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

class LinearSegment(object):
    def __init__(self, start_pos, end_pos, start_speed, top_speed, end_speed):
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.start_speed = start_speed
        self.top_speed = top_speed
        self.end_speed = end_speed
        self.kind = "l"

    def __repr__(self):
        return "LinearSegment(s_pos=%s, e_pos=%s, s_v=%s, t_v=%s, e_v=%s)" % (self.start_pos, self.end_pos, self.start_speed, self.top_speed, self.end_speed)

    def set_start_speed(self, speed):
        self.start_speed = speed

    def adjust_end_speed(self, speed):
        self.end_speed = min(speed, self.end_speed)

    def to_svg(self, scale = 10.0):
        return '<path d="M%.2f,%.2f L%.2f,%.2f" stroke="blue" fill="none" stroke-width="3"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                self.end_pos.x * scale, self.end_pos.y * scale,
            )
        

class RadiusSegment(object):
    def __init__(self, start_pos, end_pos, start_vec, end_vec, speed):
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.start_vec = start_vec
        self.end_vec = end_vec
        self.speed = speed
        self.kind = "r"

    def __repr__(self):
        return "RadiusSegment(s_pos=%s, e_pos=%s, s_v=%s, e_v=%s, speed=%s)" % (self.start_pos, self.end_pos, self.start_vec, self.end_vec, self.speed)

    def set_start_speed(self, speed):
        self.speed = speed

    def adjust_end_speed(self, speed):
        self.speed = min(speed, self.speed)

    def to_svg(self, scale = 10.0):
        k = abs(self.start_pos - self.end_pos)/2
        c1 = self.start_pos + self.start_vec * k
        c2 = self.end_pos - self.end_vec * k

        txt = '<path d="M%.4f,%.4f C %.4f,%.4f %.4f,%.4f %.4f,%.4f" stroke="green" fill="none" stroke-width="3"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                c1.x * scale, c1.y * scale,
                c2.x * scale, c2.y * scale,
                self.end_pos.x * scale, self.end_pos.y * scale,
            )

        txt += '<path d="M%.4f,%.4f L%.4f,%.4f" stroke="gray" fill="none" stroke-width="1"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                c1.x * scale, c1.y * scale,
            )

        txt += '<path d="M%.4f,%.4f L%.4f,%.4f" stroke="black" fill="none" stroke-width="1"/>' % (
                self.end_pos.x * scale, self.end_pos.y * scale,
                c2.x * scale, c2.y * scale,
            )

        return txt

def path_to_svg(sp, scale=10.0):

    txt = [
        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
        '<script xlink:href="SVGPan.js"/>',
        '<g id="viewport" transform="translate(200,200)">',
    ]

    min_x = sp[0].start_pos.x
    max_x = sp[0].start_pos.x
    min_y = sp[0].start_pos.y
    max_y = sp[0].start_pos.y

    txt1 = []

    for s in sp:
        txt1.append(s.to_svg(scale))
        min_x = min(min_x, s.start_pos.x)
        min_x = min(min_x, s.end_pos.x)
        max_x = max(max_x, s.start_pos.x)
        max_x = max(max_x, s.end_pos.x)

        min_y = min(min_y, s.start_pos.y)
        min_y = min(min_y, s.end_pos.y)
        max_y = max(max_y, s.start_pos.y)
        max_y = max(max_y, s.end_pos.y)

    min_x -= 10
    min_y -= 10
    max_x += 10
    max_y += 10

    min_x = int(min_x/10) * 10
    max_x = int((max_x + 9.9)/10) * 10
    min_y = int(min_y/10) * 10
    max_y = int((max_y + 9.9)/10) * 10

    for x in range(min_x, max_x + 10, 10):
        txt.append(
            '<path d="M%.2f,%.2f L%.2f,%.2f" stroke="gray" fill="none" stroke-width="1"/>' % (x * scale, min_y * scale, x * scale, max_y * scale)
        )

    for y in range(min_y, max_y + 10, 10):
        txt.append(
            '<path d="M%.2f,%.2f L%.2f,%.2f" stroke="gray" fill="none" stroke-width="1"/>' % (min_x * scale, y * scale, max_x * scale, y * scale)
        )

    txt += txt1
    txt.append('</g>')
    txt.append('</svg>')

    return "\n".join(txt)

def speed_path(path, speed, acceleration, deviation):

    target_radius = speed * speed / acceleration
    print "target_radius:", target_radius

    path = expand_path(path, deviation, target_radius)
    print "\n".join(format_path(path))

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
            if abs(s_v)<EPS:
                start_speed = 0
            else:
                start_speed = speed

            if abs(e_v)<EPS:
                end_speed = 0
            else:
                end_speed = speed

            new_path.append(LinearSegment(s_pos, e_pos, start_speed, speed, end_speed))
        else:
            linear_v = min(speed, sqrt(acceleration * s_r))
            new_path.append(RadiusSegment(s_pos, e_pos, s_v, e_v, linear_v))

        s_pos, s_v, s_r = e_pos, e_v, e_r 

    return new_path

def reverse_pass(path, acceleration):
    num_points = len(path)
    for i in range(num_points - 1, -1, -1):
        cur = path[i]
        if i>0:
            prev = path[i-1]
        else:
            prev = None
        #print i, cur, prev

        if cur.kind == 'l':
            dt = abs(cur.end_speed - cur.start_speed)/acceleration
            dx = (cur.start_speed + cur.end_speed) * dt / 2.0
            real_dx = abs(cur.end_pos - cur.start_pos)

            if real_dx < dx:
                if cur.end_speed < cur.start_speed:
                    speed = sqrt(cur.end_speed * cur.end_speed + 2 * acceleration * real_dx)
                    print "need slowdown for decel, ss=%s, es=%s, dt=%s, dx=%s, rdx=%s, ms=%s" % ( cur.start_speed, cur.end_speed, dt, dx, real_dx, speed)
                    cur.start_speed = speed
                    if prev:
                        prev.adjust_end_speed(speed)
        else:
            if prev:
                prev.adjust_end_speed(cur.speed)


def forward_pass(path, acceleration):
    num_points = len(path)
    for i in range(0, num_points - 1):
        cur = path[i]
        if i < num_points - 1:
            next = path[i+1]
        else:
            next = None

        #print i, cur, next

        if cur.kind == 'l':
            dt = abs(cur.end_speed - cur.start_speed)/acceleration
            dx = (cur.start_speed + cur.end_speed) * dt / 2.0
            real_dx = abs(cur.end_pos - cur.start_pos)

            if real_dx < dx:
                if cur.end_speed > cur.start_speed:
                    speed = sqrt(cur.start_speed * cur.start_speed + 2 * acceleration * real_dx)
                    print "need slowdown for accel, ss=%s, es=%s, dt=%s, dx=%s, rdx=%s, ms=%s" % ( cur.start_speed, cur.end_speed, dt, dx, real_dx, speed)
                    cur.end_speed = speed
                    if next:
                        next.set_start_speed(speed)
        else:
            if next:
                next.set_start_speed(cur.speed)

