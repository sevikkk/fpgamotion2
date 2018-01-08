from vector3 import Vector3 as Point


class Segment:
    def __init__(self, pos, speed, e_val):
        self.pos, self.speed, self.e_val = pos, speed, e_val

    def __repr__(self):
        return "<Segment([%.3f, %.3f, %.3f], %.3f, %.3f)>" % (
            self.pos.x, self.pos.y, self.pos.z, self.speed, self.e_val)


class Parser:

    ignored_codes = ["T0"]

    def __init__(self):
        self.segments = []
        self.mode = "abs"
        self.pos = Point(0, 0, 0)
        self.epos = 0
        self.speed = 600
        self.metric = 1.0
        self.mcodes = {}

    def parse_file(self, filename):
        for line in open(filename):
            #print line
            self.parse_line(line)

    def parse_line(self, line, line_number=None):
        s = line.strip().split()
        if len(s) < 1:
            return

        s1 = []
        for ss in s:
            if ss[0] in ["(", ';']:
                print s
                break
            s1.append(ss)

        if not s1:
            return

        s0 = s1[0]
        if s0 in self.ignored_codes:
            return

        proc = getattr(self, "do_" + s0, None)

        if proc:
            #noinspection PyCallingNonCallable
            proc(s1)
        else:
            if s0.startswith("M"):
                self.mcodes[s0] = 1
                return

            raise RuntimeError, "unsupported command: %s in line '%s'(%d)" % (s0, line, line_number or 0)

    def do_G21(self, args):
        self.metric = 1.0

    def do_G28(self, args):
        print "do homing"

    def do_G90(self, args):
        self.mode = "abs"

    def do_G91(self, args):
        self.mode = "rel"

    def do_G92(self, args):
        print "set_pos", `args`

    def do_G0(self, args):
        #print "G0", `args`
        pass

    def do_G1(self, args):
        #print "G1", `args`
        pass

    def do_M84(self, args):
        pass

    def do_M92(self, args):
        pass

    def do_M104(self, args):
        pass

    def do_M106(self, args):
        pass

    def do_M107(self, args):
        pass

    def do_M109(self, args):
        pass

    def do_M117(self, args):
        pass

    def do_M140(self, args):
        pass

    def do_M190(self, args):
        pass

