from math import sin, cos, pi, sqrt

import canvas
import console


size_x = 1600
size_y = 900

center_x = 0.0
center_y = 10.0
full_x = 70.0

speed = 100.0
ax_max = 2500.0
ay_max = 1500.0
part_max = 0.2
delta_max = 0.5

full_y = full_x / size_x * size_y

min_x = center_x - full_x / 2
max_x = center_x + full_x / 2
min_y = center_y - full_y / 2
max_y = center_y + full_y / 2

grid = 1.0


def t_c_x(x):
    return (x - min_x) / (max_x - min_x) * size_x


def t_c_y(y):
    return (y - min_y) / (max_y - min_y) * size_y


def draw_grid():
    console.clear()
    canvas.set_size(size_x, size_y)
    canvas.begin_updates()
    canvas.set_line_width(1)
    canvas.set_stroke_color(0.7, 0.7, 0.7)
    #Draw vertical grid lines:
    x = grid
    while x <= max(abs(min_x), abs(max_x)):
        cx = t_c_x(x)
        if cx > 0 and cx < size_x:
            canvas.draw_line(cx, 0, cx, size_y)

        cx = t_c_x(-x)
        if cx > 0 and cx < size_x:
            canvas.draw_line(cx, 0, cx, size_y)

        x += grid

    y = grid
    while y <= max(abs(min_y), abs(max_y)):
        cy = t_c_y(y)
        if cy > 0 and cy < size_y:
            canvas.draw_line(0, cy, size_x, cy)

        cy = t_c_y(-y)
        if cy > 0 and cy < size_y:
            canvas.draw_line(0, cy, size_x, cy)

        y += grid

    canvas.set_stroke_color(0, 0, 0)
    cx = t_c_x(0)
    if cx > 0 and cx < size_x:
        canvas.draw_line(cx, 0, cx, size_y)
    cy = t_c_y(0)
    if cy > 0 and cy < size_y:
        canvas.draw_line(0, cy, size_x, cy)
    canvas.end_updates()


def line(x1, y1, x2, y2):
    canvas.draw_line(t_c_x(x1), t_c_y(y1), t_c_x(x2), t_c_y(y2))


def circle(x1, y1, c=10):
    canvas.draw_ellipse(t_c_x(x1) - c / 2, t_c_y(y1) - c / 2, c, c)


def main():
    draw_grid()
    canvas.set_stroke_color(0.7, 0.3, 0.3)
    canvas.set_line_width(5)
    x = 5.0
    y = -3.0
    path = []
    last_a = 0
    for l, delta_a in [(10, 30), (10, 20), (10, 150), (10, -90), (10, 20), (10, 45), (10, 160)]:
        last_a += delta_a
        a1 = last_a / 180.0 * pi
        dx = l * cos(a1)
        dy = l * sin(a1)
        dt = l / speed
        #print dx,dy, sin(a1), cos(a1)
        line(x, y, x + dx, y + dy)
        path.append([x, y, x + dx, y + dy, dt, 'i'])
        x += dx
        y += dy

    path.append([x, y, x, y, 1, 'l'])

    path[0][5] = 'f'

    print path
    x, y = path[0][:2]
    vx = 0.0
    vy = 0.0
    need_slow = 1
    k_slow = 1.0

    while need_slow:
        need_slow = 0
        points = []
        last_dt = 0
        for (x1, y1, x2, y2, dt, fli) in path:
            dt = dt * k_slow
            nvx = (x2 - x1) / dt
            nvy = (y2 - y1) / dt
            dvx = nvx - vx
            dvy = nvy - vy
            dta = max(abs(dvx / ax_max), abs(dvy / ay_max))

            if fli == "i":
                dta = dta / 2
                ka = dta / dt
            else:
                ka = dta / dt / 2

            #print fli, dvx, dvy, dt, dta, dta/dt
            last_ka = dta / (last_dt or 1)

            if fli == "f":
                points.append((x1, y1, 0, 0, 0))
                points.append((x1 + (x2 - x1) * ka, y1 + (y2 - y1) * ka, nvx, nvy, dta))
                dta = dta / 2
            elif fli == "i":
                points.append((last_x2 - (last_x2 - last_x1) * last_ka,
                               last_y2 - (last_y2 - last_y1) * last_ka,
                               vx, vy, last_dt - last_dta - dta))
                points.append((x1 + (x2 - x1) * ka,
                               y1 + (y2 - y1) * ka,
                               nvx, nvy, dta * 2))
            elif fli == "l":
                points.append((last_x2 - (last_x2 - last_x1) * last_ka / 2,
                               last_y2 - (last_y2 - last_y1) * last_ka / 2,
                               vx, vy, last_dt - last_dta - dta / 2))
                points.append((x2, y2,
                               0, 0, dta))

            if fli == "i":
                if ka > part_max:
                    need_slow = 1
                if last_dt and last_ka > part_max:
                    need_slow = 1

                x0, y0, vx0, vy0, _ = points[-2]
                xn, yn, vxn, vyn, sdt = points[-1]
                coefs_x = cubic_coeff(x0, vx0, xn, vxn, sdt)
                coefs_y = cubic_coeff(y0, vy0, yn, vyn, sdt)

                xm = cubic_x(coefs_x, sdt / 2)
                ym = cubic_x(coefs_y, sdt / 2)
                delta = sqrt((xm - x1) * (xm - x1) + (ym - y1) * (ym - y1))
                print delta

                if delta > delta_max:
                    need_slow = 1
            else:
                if ka > 0.5:
                    need_slow = 1
                if last_dt and last_ka > 0.5:
                    need_slow = 1

            last_x1 = x1
            last_y1 = y1
            last_x2 = x2
            last_y2 = y2
            last_dt = dt
            last_dta = dta
            vx = nvx
            vy = nvy

        #need_slow = 0
        if need_slow:
            k_slow = k_slow * 1.1
            print "need slowdown, new k =", k_slow, "speed = ", speed / k_slow

    print points

    last_p = points[0]
    for p in points[1:]:
        x0, y0, vx0, vy0, _ = last_p
        x1, y1, vx1, vy1, dt = p

        canvas.set_stroke_color(0.3, 0.7, 0.3)
        canvas.set_line_width(3)

        line(x0, y0, x1, y1)
        circle(x1, y1)

        coefs_x = cubic_coeff(x0, vx0, x1, vx1, dt)
        coefs_y = cubic_coeff(y0, vy0, y1, vy1, dt)
        print "x:", coefs_x, cubic_a(coefs_x, 0), cubic_a(coefs_x, dt)
        print "y:", coefs_y, cubic_a(coefs_y, 0), cubic_a(coefs_y, dt)
        t = 0.0
        step = dt / 10
        canvas.set_stroke_color(0, 0, 0)
        canvas.set_line_width(3)
        while 1:
            x = cubic_x(coefs_x, t)
            y = cubic_x(coefs_y, t)
            vx = cubic_v(coefs_x, t)
            vy = cubic_v(coefs_y, t)
            print sqrt(vx * vx + vy * vy)
            circle(x, y, 2)
            t += step
            if t > dt:
                break

        last_p = p

    #for i in range(20):
    #	print

    #console.clear()


def cubic_coeff(x0, v0, xn, vn, deltaT):
    d = x0
    c = v0
    b = 3 * (xn - x0) / (deltaT * deltaT) - (2 * v0 + vn) / deltaT
    a = (vn - v0) / (3.0 * (deltaT * deltaT)) - (2.0 * b) / (3.0 * deltaT)
    return (a, b, c, d)


def cubic_x(coefs, t):
    a, b, c, d = coefs

    return a * (t * t * t) + b * (t * t) + c * t + d


def cubic_v(coefs, t):
    a, b, c, d = coefs
    return 3.0 * a * (t * t) + 2.0 * b * t + c


def cubic_a(coefs, t):
    a, b, c, d = coefs
    return 6.0 * a * t + 2.0 * b


main()

