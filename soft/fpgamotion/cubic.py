EPS = 0.000001


class Cubic(object):
    def __init__(self, x0, v0, xn, vn, deltaT):
        d = x0
        c = v0
        b = 3.0 * (xn - x0) / (deltaT * deltaT) - (2.0 * v0 + vn) / deltaT
        a = (vn - v0) / (3.0 * (deltaT * deltaT)) - (2.0 * b) / (3.0 * deltaT)
        self.a = a
        self.b = b
        self.c = c
        self.d = d

    def get_x(self, t):
        a, b, c, d = self.a, self.b, self.c, self.d
        return a * (t * t * t) + b * (t * t) + c * t + d

    def get_v(self, t):
        a, b, c, d = self.a, self.b, self.c, self.d
        return 3.0 * a * (t * t) + 2.0 * b * t + c

    def get_max_v(self, t):
        a, b, c, d = self.a, self.b, self.c, self.d

        v0 = 0
        if abs(a) > EPS and abs(b) > EPS:
            t0 = -b / (3.0 * a)
            if t0 > 0 and t0 < t:
                v0 = abs(self.get_v(t0))
        v1 = abs(self.get_v(0))
        v2 = abs(self.get_v(t))

        return max(v0, v1, v2)

    def get_a(self, t):
        a, b, c, d = self.a, self.b, self.c, self.d
        return 6.0 * a * t + 2.0 * b

    def get_max_a(self, t):
        a1 = abs(self.get_a(0))
        a2 = abs(self.get_a(t))
        return max(a1, a2)

    def get_j(self, t):
        a, b, c, d = self.a, self.b, self.c, self.d
        return 6.0 * a

    def __str__(self):
        return "Cubic(a=%f,b=%f,c=%f,d=%f)" % (self.a, self.b, self.c, self.d)


class HwCubic(Cubic):
    steps_per_unit = 80
    step_bit = 39
    step_hz = 25000000
    acc_hz = 1000

    def calc_hw_coefs(self, dt):
        self.bit_k = (1 << self.step_bit) * self.steps_per_unit * 1.0
        self.hw_x0 = int(round(self.get_x(0) * self.bit_k))
        self.hw_v0 = int(round(self.get_v(0) * self.bit_k / self.step_hz))
        self.hw_a0 = int(round(self.get_a(0) * self.bit_k / self.step_hz / self.acc_hz))
        self.hw_j0 = int(round(self.get_j(0) * self.bit_k / self.step_hz / self.acc_hz / self.acc_hz))

        self.hw_t = int(round(dt * self.acc_hz))

    def emu(self):
        j = self.hw_j0
        a = self.hw_a0
        v = self.hw_v0
        x = self.hw_x0
        print "x: %f v: %f, a: %f, j: %f" % (x, v, a, j)

        t = 0
        max_int = 1 << 31 - 1

        while t < self.hw_t:
            t += 1
            x += (v + a / 2) * (self.step_hz / self.acc_hz)
            v += (a + j / 2)
            a += j

            if v < -max_int:
                raise ValueError, "v is out of range at %d: %d" % (t, v)

            if v > max_int:
                raise ValueError, "v is out of range at %d: %d" % (t, v)

            if a < -max_int:
                raise ValueError, "a is out of range at %d: %d" % (t, a)

            if a > max_int:
                raise ValueError, "a is out of range at %d: %d" % (t, a)

            #print "sim:", t * 1.0/self.acc_hz, x / self.bit_k, self.get_x(t * 1.0/self.acc_hz), v / self.bit_k * self.step_hz, self.get_v(t * 1.0/self.acc_hz), a / self.bit_k * self.step_hz * self.acc_hz, self.get_a(t * 1.0/self.acc_hz), j / self.bit_k * self.step_hz * self.acc_hz, self.get_j(t * 1.0/self.acc_hz)
            yield t * 1.0 / self.acc_hz, x / self.bit_k, v / self.bit_k * self.step_hz

    def get_last(self):
        last = list(self.emu())[-1]
        t, x, v = last

        if abs(x - self.get_x(t)) > 0.15:
            raise ValueError, "Hardware simulation divergence is too big, hw x: %f cubic x: %f" % (x, self.get_x(t))

        if abs(v - self.get_v(t)) > 0.15:
            raise ValueError, "Hardware simulation divergence is too big, hw v: %f cubic v: %f" % (v, self.get_v(t))

        return last
        


