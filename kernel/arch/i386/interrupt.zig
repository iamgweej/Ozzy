const instructions = @import("instructions.zig"); 

// PIC ports.
const PIC1_CMD = 0x20;
const PIC1_DATA = 0x21;
const PIC2_CMD = 0xA0;
const PIC2_DATA = 0xA1;
// PIC commands:
const ISR_READ = 0x0B; // Read the In-Service Register.
const ACK = 0x20; // Acknowledge interrupt.
// Initialization Control Words commands.
const ICW1_INIT = 0x10;
const ICW1_ICW4 = 0x01;
const ICW4_8086 = 0x01;
// write 0 to wait
const WAIT_PORT = 0x80;
// PIT Channels
const PIT_CHAN0 = 0x40;
const PIT_CHAN1 = 0x41;
const PIT_CHAN2 = 0x42;
const PIT_CMD = 0x43;
// Interrupt Vector offsets of exceptions.
const EXCEPTION_0 = 0;
const EXCEPTION_31 = EXCEPTION_0 + 31;
// Interrupt Vector offsets of IRQs.
const IRQ_0 = EXCEPTION_31 + 1;
const IRQ_15 = IRQ_0 + 15;

inline fn picwait() void {
    instructions.outb(WAIT_PORT, 0);
}

pub fn remapPIC() void {
    // ICW1: start initialization sequence.
    instructions.outb(PIC1_CMD, ICW1_INIT | ICW1_ICW4);
    picwait();
    instructions.outb(PIC2_CMD, ICW1_INIT | ICW1_ICW4);
    picwait();

    // ICW2: Interrupt Vector offsets of IRQs.
    instructions.outb(PIC1_DATA, IRQ_0); // IRQ 0..7  -> Interrupt 32..39
    picwait();
    instructions.outb(PIC2_DATA, IRQ_0 + 8); // IRQ 8..15 -> Interrupt 40..47
    picwait();

    // ICW3: IRQ line 2 to connect master to slave PIC.
    instructions.outb(PIC1_DATA, 1 << 2);
    picwait();
    instructions.outb(PIC2_DATA, 2);
    picwait();

    // ICW4: 80x86 mode.
    instructions.outb(PIC1_DATA, ICW4_8086);
    picwait();
    instructions.outb(PIC2_DATA, ICW4_8086);
    picwait();

    // Mask all IRQs.
    instructions.outb(PIC1_DATA, 0xFF);
    picwait();
    instructions.outb(PIC2_DATA, 0xFF);
    picwait();
}

// configures the chan0 with a rate generator, which will trigger irq0
pub const divisor = 2685;
pub const tick = 2251; // f = 1.193182 MHz, TODO: turn into a function
pub fn configurePIT() void {
    const chanNum = 0;
    const chan = PIT_CHAN0;
    const LOHI = 0b11; // bit4 | bit5
    const PITMODE_RATE_GEN = 0x2;
    instructions.outb(PIT_CMD, chanNum << 6 | LOHI << 4 | PITMODE_RATE_GEN << 1);
    instructions.outb(PIT_CHAN0, divisor & 0xff);
    instructions.outb(PIT_CHAN0, divisor >> 8);
}

