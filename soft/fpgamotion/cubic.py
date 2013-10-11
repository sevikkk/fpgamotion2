from math import sin, cos, pi, sqrt
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
            t0 = -b/(3.0 * a)
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

