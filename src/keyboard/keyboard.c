#include "../boot.h"
#include "keyboard_map.h"

#define ROWS 25
#define COLS 80

int cursor_pos = 0;

void handle_keyboard_interrupt() {
	// Write end of interrupt (EOI)
	ioport_out(PIC1_COMMAND_PORT, 0x20);

	unsigned char status = ioport_in(KEYBOARD_STATUS_PORT);
	// Lowest bit of status will be set if buffer not empty
	// (thanks mkeykernel)
	if (status & 0x1) {
		char keycode = ioport_in(KEYBOARD_DATA_PORT);
		if (keycode < 0 || keycode >= 128) return; // how did they know keycode is signed?
		print_char_with_asm(keyboard_map[keycode],0,cursor_pos);
		cursor_pos++;
	}
}

void kb_init() {
	// 0xFD = 1111 1101 in binary. enables only IRQ1
	// Why IRQ1? Remember, IRQ0 exists, it's 0-based
	ioport_out(PIC1_DATA_PORT, 0xFD);
}

void print_message() {
	// Fill the screen with 'x'
	int i, j;
	for (i = 0; i < COLS; i++) {
		for (j = 0; j < ROWS; j++) {
			print_char_with_asm('*',j,i);
		}
	}
	print_char_with_asm('-',0,0);
	print_char_with_asm('P',0,1);
	print_char_with_asm('K',0,2);
	print_char_with_asm('O',0,3);
	print_char_with_asm('S',0,4);
	print_char_with_asm('-',0,5);
}
