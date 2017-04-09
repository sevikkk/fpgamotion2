#include <stdio.h>
#include <stdint.h>

FILE *f;
uint8_t buf[512];
int buf_used;
int buf_idx;
int eof = 0;

uint8_t pop8() {
	if (eof) return 0;

	if (buf_idx >= buf_used) {
		buf_used = fread(buf, 1, 512, f);
		buf_idx = 0;
		if (buf_used == 0) {
			eof = 1;
			return 0;
		};
	};
	return buf[buf_idx++];
};


int16_t pop16() {
	union {
		int16_t a;
		struct {
			uint8_t data[2];
		} b;
	} shared;
	shared.b.data[0] = pop8();
	shared.b.data[1] = pop8();
	return shared.a;
};

int32_t pop32() {
	union {
		int32_t a;
		struct {
			uint8_t data[4];
		} b;
	} shared;
	shared.b.data[0] = pop8();
	shared.b.data[1] = pop8();
	shared.b.data[2] = pop8();
	shared.b.data[3] = pop8();
	return shared.a;
}

void
parse_tool(void) {
	uint8_t idx, cmd, len;
	int16_t temp;

	idx = pop8();
	cmd = pop8();
	len = pop8();
	if (idx != 0) {
		printf("Unknown tool idx: %d\n", idx);
		eof = 1;
		return;
	};
	switch (cmd) {
		case 3: 
			temp = pop16();
			printf("Set temp to %d\n", temp);
			break;
		case 4: 
			cmd = pop8();
			printf("Set fan pwm to %d\n", cmd);
			break;
		case 27: 
			cmd = pop8();
			printf("Toggle ABP to %d\n", cmd);
			break;
		case 31: 
			temp = pop16();
			printf("Set platform temp to %d\n", temp);
			break;
		case 10: 
			cmd = pop8();
			printf("Set fan to %d\n", cmd);
			break;
		default:
			printf("Unknown tool command: %d\n", cmd);
			eof = 1;
			break;
	};

};

int main(int *argc, char **argv) {
	uint8_t cmd;
	int16_t feedrate;
	int32_t time, x, y, z, a, b;
	char *dir;

	printf("bubu\n");

	f = fopen("/home/seva/box_15.s3g", "rb");
	while (1) {
		cmd = pop8();
		if (eof)
			break;

		switch (cmd) {
			case 131:
			case 132:
				if (cmd == 131) {
					dir = "min";
				} else {
					dir = "max";
				};

				cmd = pop8();
				feedrate = pop16();
				time = pop32();
				printf("Home %s on axes: %d %d %d %d (%x) with feed: %d timeout: %d\n", dir, cmd&1, cmd&2, cmd&4, cmd&8, cmd, feedrate, time);
				break;
			case 133:
				time = pop32();
				printf("Wait for %d\n", time);
				break;
			case 134:
				cmd = pop8();
				printf("Switch to tool %d\n", cmd);
				break;
			case 135:
			case 141:
				if (cmd == 135) {
					dir = "tool";
				} else {
					dir = "platform";
				};
				cmd = pop8();
				feedrate = pop16();
				time = pop16();
				printf("Wait for %s %d for %ds\n", dir, cmd, time);
				break;
			case 136:
				parse_tool();
				break;
			case 137:
				cmd = pop8();
				printf("Enable axes: %d %d %d %d %d %d %d %d (%x)\n", cmd&1, cmd&2, cmd&4, cmd&8, cmd%16, cmd&32, cmd&64, cmd&128, (unsigned int)cmd);
				break;
			case 139:
				x = pop32();
				y = pop32();
				z = pop32();
				a = pop32();
				b = pop32();
				time = pop32();
				printf("Abs move to: %d %d %d %d %d at dda %d\n", x, y, z, a, b, time);
				break;
			case 140:
				x = pop32();
				y = pop32();
				z = pop32();
				a = pop32();
				b = pop32();
				printf("Set position: %d %d %d %d %d\n", x, y, z, a, b);
				break;
			case 142:
				x = pop32();
				y = pop32();
				z = pop32();
				a = pop32();
				b = pop32();
				time = pop32();
				cmd = pop8();
				printf("Move to (%d, %d, %d, %d, %d) in %d rel: %d\n", x, y, z, a, b, time, cmd);
				break;
			case 144:
				cmd = pop8();
				printf("Recall home on axes: %d %d %d %d %d (%x)\n", cmd&1, cmd&2, cmd&4, cmd&8, cmd&16, (unsigned int)cmd);
				break;
			default:
				printf("Unknown command: %d\n", cmd);
				eof = 1;
				break;
		};
	};
}

