#!/usr/bin/env python
from vector3 import Vector3 as Point
from math import sqrt, pow, acos, pi
from cubic import HwCubic

EPS = 0.000001


def make_junction(p1, p2, p3, deviation, target_r = None):
    v1 = (p2 - p1).getNormalized()
    v2 = (p3 - p2).getNormalized()

    cos_theta = -v1.x * v2.x -v1.y * v2.y -v1.z * v2.z 
    if 1.0 - abs(cos_theta) < EPS:
        print "straight"
        return []

    sin_theta_d2 = sqrt(0.5*(1.0-cos_theta))
    print "----"

    print "cos_theta:", cos_theta
    print "sin_theta_d2:", sin_theta_d2
    arc_angle = acos(sin_theta_d2)
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

    arc_len = arc_angle * r
    print "arc_angle:", arc_angle / pi * 180
    print "arc_len:", arc_len
    print "k * r:", r
    print "k * deviation:", deviation
    print "k * seg:", seg
    pr1 = p2 - v1 * seg
    vm = ((v2 - v1)/2).getNormalized()
    vt = ((v1 + v2)/2).getNormalized()
    pr2 = p2 + vm * deviation
    pr3 = p2 + v2 * seg
    print "delta:", abs(pr1-pr2)
    print "delta:", abs(pr3-pr2)

    return [(pr1, v1, r, arc_len), (pr2, vt, r, arc_len), (pr3, v2, None, 0)]

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
    path = [(points[0], Point(0,0,0), None, None)]

    for i in range(1, num_points - 1):
        add_points = make_junction(
                points[i - 1],
                points[i],
                points[i + 1],
                deviation,
                target_r
        )

        path += add_points

    path += [(points[-1], Point(0,0,0), None, None)]

    return path

class LinearSegment(object):
    def __init__(self, start_pos, end_pos, start_speed, top_speed, end_speed):
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.start_speed = start_speed
        self.top_speed = top_speed
        self.end_speed = end_speed
        self.kind = "l"
        self.cubics = None
        self.profile_points = None

    def __repr__(self):
        return "LinearSegment(s_pos=%s, e_pos=%s, s_v=%s, t_v=%s, e_v=%s)" % (self.start_pos, self.end_pos, self.start_speed, self.top_speed, self.end_speed)

    def set_start_speed(self, speed):
        self.start_speed = speed

    def adjust_end_speed(self, speed):
        self.end_speed = min(speed, self.end_speed)

    def to_svg(self, scale = 10.0, t = 0.0):
        txt = ['<path d="M%.2f,%.2f L%.2f,%.2f" stroke="blue" fill="none" stroke-width="3"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                self.end_pos.x * scale, self.end_pos.y * scale,
            )]

        if self.cubics:
            print "AAAA", self.cubics
            for dt, c_x, c_y, c_z in self.cubics:
                emu_x = list(c_x.emu())
                emu_y = list(c_y.emu())
                print "EEEE", emu_x, emu_y

                for i in range(len(emu_x)):
                    print "BBB", i, t
                    if (int(t) % 10) != 0:
                        t+=1
                        continue
                    print "CCC", i, t
                    
                    x = emu_x[i][1]
                    y = emu_y[i][1]

                    a_x = c_x.get_a(emu_x[i][0])
                    a_y = c_y.get_a(emu_x[i][0])

                    if abs(a_x) + abs(a_y) > 10:
                        color = "red"
                    else:
                        color = "yellow"

                    txt.append('<circle cx="%.2f" cy="%.2f" r="0.5" fill="%s" stroke="%s" stroke-width="0.5"/>' % (x * scale,y * scale, color, color))
                    t += 1

        return "\n".join(txt), t

class RadiusSegment(object):
    def __init__(self, start_pos, end_pos, start_vec, end_vec, speed, eq_len):
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.start_vec = start_vec
        self.end_vec = end_vec
        self.speed = speed
        self.eq_len = eq_len
        self.kind = "r"
        self.cubics = None
        self.profile_points = None

    def __repr__(self):
        return "RadiusSegment(s_pos=%s, e_pos=%s, s_v=%s, e_v=%s, speed=%s, eq_len=%s)" % (self.start_pos, self.end_pos, self.start_vec, self.end_vec, self.speed, self.eq_len)

    def set_start_speed(self, speed):
        self.speed = speed

    def adjust_end_speed(self, speed):
        self.speed = min(speed, self.speed)

    def to_svg(self, scale = 10.0, t = 0.0):
        k = abs(self.start_pos - self.end_pos)/2
        c1 = self.start_pos + self.start_vec * k
        c2 = self.end_pos - self.end_vec * k

        txt = ['<path d="M%.4f,%.4f C %.4f,%.4f %.4f,%.4f %.4f,%.4f" stroke="green" fill="none" stroke-width="3"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                c1.x * scale, c1.y * scale,
                c2.x * scale, c2.y * scale,
                self.end_pos.x * scale, self.end_pos.y * scale,
            )]

        txt.append('<path d="M%.4f,%.4f L%.4f,%.4f" stroke="gray" fill="none" stroke-width="1"/>' % (
                self.start_pos.x * scale, self.start_pos.y * scale,
                c1.x * scale, c1.y * scale,
            ))

        txt.append('<path d="M%.4f,%.4f L%.4f,%.4f" stroke="black" fill="none" stroke-width="1"/>' % (
                self.end_pos.x * scale, self.end_pos.y * scale,
                c2.x * scale, c2.y * scale,
            ))


        print "RRRR", self.cubics
        if self.cubics:
            print "FFFF", self.cubics
            for dt, c_x, c_y, c_z in self.cubics:
                emu_x = list(c_x.emu())
                emu_y = list(c_y.emu())
                print "JJJJ", emu_x, emu_y

                for i in range(len(emu_x)):
                    if (int(t) % 10) != 0:
                        t+=1
                        continue
                    print "ZZZZ", emu_x, emu_y
                    
                    x = emu_x[i][1]
                    y = emu_y[i][1]

                    a_x = c_x.get_a(t)
                    a_y = c_y.get_a(t)

                    if abs(a_x) + abs(a_y) > EPS:
                        color = "red"
                    else:
                        color = "yellow"

                    txt.append('<circle cx="%.2f" cy="%.2f" r="0.5" fill="%s" stroke="%s" stroke-width="0.5"/>' % (x * scale,y * scale, color, color))
                    t += 1

        return "\n".join(txt), t

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
    
    t = 0.0

    for s in sp:
        xml, t = s.to_svg(scale, t)
        txt1.append(xml)
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
    s_pos, s_v, s_r, s_el  = path[0]

    for i in range(1, num_points):
        e_pos, e_v, e_r, e_el  = path[i]
        s_r = s_r or path[i - 1][2]
        s_el = s_el or path[i - 1][3]

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
            new_path.append(RadiusSegment(s_pos, e_pos, s_v, e_v, linear_v, s_el))

        s_pos, s_v, s_r, s_el = e_pos, e_v, e_r, e_el

    return new_path

def max_allowable_speed(acceleration, target_speed, distance):
    """ Maximum reachable for given acceleration and distance """

    return sqrt(target_speed * target_speed + 2.0 * acceleration * distance)

def estimate_acceleration_distance(initial_speed, target_speed, acceleration):
    """ Distance to reach given speed with given acceleration """

    return (1.0 * target_speed * target_speed - initial_speed * initial_speed) / (2 * acceleration)

def intersection_distance(initial_speed, target_speed, acceleration, distance):
    """Constant acceleration distance for non plateau trapezoid"""

    return (2.0 * acceleration * distance - initial_speed * initial_speed + target_speed * target_speed) / (4 * acceleration)

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
            if cur.end_speed < cur.start_speed:
                dx = estimate_acceleration_distance(cur.end_speed, cur.start_speed, acceleration)
                real_dx = abs(cur.end_pos - cur.start_pos)
                #print cur.start_speed, cur.end_speed, acceleration, dx, real_dx

                if real_dx < dx:
                    speed = max_allowable_speed(acceleration, cur.end_speed, real_dx)
                    print "need slowdown for decel, ss=%s, es=%s, dx=%s, rdx=%s, ms=%s" % ( cur.start_speed, cur.end_speed, dx, real_dx, speed)
                    cur.start_speed = speed
                    if prev:
                        prev.adjust_end_speed(speed)
        else:
            if prev:
                prev.adjust_end_speed(cur.speed)


def forward_pass(path, acceleration):
    num_points = len(path)
    for i in range(0, num_points):
        cur = path[i]
        if i < num_points - 1:
            next = path[i+1]
        else:
            next = None

        #print i, cur, next

        if cur.kind == 'l':
            if cur.end_speed > cur.start_speed:
                dx = estimate_acceleration_distance(cur.start_speed, cur.end_speed, acceleration)
                real_dx = abs(cur.end_pos - cur.start_pos)
                #print cur.start_speed, cur.end_speed, acceleration, dx, real_dx

                if real_dx < dx:
                    speed = max_allowable_speed(acceleration, cur.start_speed, real_dx)
                    print "need slowdown for accel, ss=%s, es=%s, dx=%s, rdx=%s, ms=%s" % ( cur.start_speed, cur.end_speed, dx, real_dx, speed)
                    cur.end_speed = speed
                    if next:
                        next.set_start_speed(speed)
        else:
            if next:
                next.set_start_speed(cur.speed)

def make_profile(path, accels):
    profile = []
    last_x = None
    last_v = None

    for s in path:
        if s.kind == 'l':
            print "------- linear ---------"
            s_pos = s.start_pos
            e_pos = s.end_pos

            vec = (e_pos - s_pos).getNormalized()

            s_v = vec * s.start_speed
            e_v = vec * s.end_speed
            t_v = vec * s.top_speed
           
            main_v = -1
            main_axis = None
            
            for axis in range(3):
                if abs(vec[axis]) > main_v:
                    main_v = abs(vec[axis])
                    main_axis = axis

            main_accel = accels[main_axis]
            working_accels = Point()

            k = 1.0

            for axis in range(3):
                working_accels[axis] = main_accel / main_v * abs(vec[axis])
                if working_accels[axis] > accels[axis]:
                    k = min(k, accels[axis]/working_accels[axis])

            for axis in range(3):
                working_accels[axis] *= k
            
            axis = main_axis
            axis_name = ["X", "Y", "Z"][axis]

            x_0 = s_pos[axis]
            x_n = e_pos[axis]

            v_0 = abs(s_v[axis])
            v_n = abs(e_v[axis])
            v_t = abs(t_v[axis])

            a = working_accels[axis]

            print "%s:" % axis_name, x_0, x_n, v_0, v_n, a

            dx = abs(x_n - x_0)
            if dx < EPS:
                print "idle"
                continue

            dx_accel = estimate_acceleration_distance(v_0, v_t, a)
            dx_decel = estimate_acceleration_distance(v_t, v_n, -a)

            dx_plato = dx - dx_accel - dx_decel
            if dx_plato>0:
                print "full profile", dx_accel, dx_plato, dx_decel
                top_speed = v_t
                dt_accel = (v_t - v_0)/a
                dt_decel = (v_t - v_n)/a
                dt_plato = dx_plato/v_t
            else:
                dx_accel = intersection_distance(v_0, v_n, a, dx)
                print "partial profile", v_0, v_n, a, dx, dx_accel
                top_speed = max_allowable_speed(a, v_0, dx_accel)
                dt_accel = (top_speed - v_0)/a
                dt_decel = (top_speed - v_n)/a
                dt_plato = 0
                dx_decel = dx - dx_accel
                dx_plato = 0

            t0 = 0
            p0 = s_pos
            v0 = s_v

            t1 = dt_accel
            p1 = s_pos + vec * (dx_accel/main_v)
            v1 = vec * top_speed / main_v

            t2 = dt_accel + dt_plato
            p2 = e_pos - vec * (dx_decel/main_v)
            v2 = vec * top_speed / main_v

            t3 = dt_accel + dt_plato + dt_decel
            p3 = e_pos
            v3 = e_v

            points = [[t0, p0, v0]]

            if dt_accel>EPS:
                points.append([t1, p1, v1])

            if dt_plato>EPS:
                points.append([t2, p2, v2])

            if dt_decel>EPS:
                points.append([t3, p3, v3])

        else:
            print "------- radial ---------"
            s_pos = s.start_pos
            e_pos = s.end_pos

            s_v = s.start_vec * s.speed
            e_v = s.end_vec * s.speed

            dt = s.eq_len / s.speed
            print abs(e_pos - s_pos), s.eq_len

            points = [
                    [0, s_pos, s_v],
                    [dt, e_pos, e_v]
                ]

        s.profile_points = points

        cubics = []
        i = 0
        for t, x, v in points:
            print "%.3f: (%.3f, %.3f, %.3f) (%.3f, %.3f, %.3f)" % (t, x.x, x.y, x.z, v.x, v.y, v.z)
            if i < len(points)-1:
                n_t, n_x, n_v = points[i+1]

                if not last_x:
                    last_x = x
                    last_v = v

                try:
                    c_x = HwCubic(last_x.x, last_v.x, n_x.x, n_v.x, n_t - t)
                    print "%8.2f %8.2f %s" % (c_x.get_max_v(n_t - t), c_x.get_max_a(n_t - t), c_x)
                    c_y = HwCubic(last_x.y, last_v.y, n_x.y, n_v.y, n_t - t)
                    print "%8.2f %8.2f %s" % (c_y.get_max_v(n_t - t), c_y.get_max_a(n_t - t), c_y)
                    c_z = HwCubic(last_x.z, last_v.z, n_x.z, n_v.z, n_t - t)
                    print "%8.2f %8.2f %s" % (c_z.get_max_v(n_t - t), c_z.get_max_a(n_t - t), c_z)

                    c_x.calc_hw_coefs(n_t - t)
                    c_y.calc_hw_coefs(n_t - t)
                    c_z.calc_hw_coefs(n_t - t)

                    _, rx_x, rv_x = c_x.get_last()
                    _, rx_y, rv_y = c_y.get_last()
                    _, rx_z, rv_z = c_z.get_last()

                    last_x = Point(rx_x, rx_y, rx_z)
                    last_v = Point(rv_x, rv_y, rv_z)

                except Exception, e:
                    raise
                cubics.append([n_t - t, c_x, c_y, c_z])
                profile.append([n_t - t, c_x, c_y, c_z])
                i += 1

        s.cubics = cubics
        print s.cubics

    return profile




