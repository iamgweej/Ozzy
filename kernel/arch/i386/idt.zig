const instructions = @import("instructions.zig");
const isr = @import("isr.zig");
const interrupt = @import("interrupt.zig");

var idt: [256]IDTEntry = undefined;

pub const INTERRUPT_GATE = 0x8E;

const idtr = IDTRegister{
    .limit = @as(u16, @sizeOf(@TypeOf(idt))) - 1,
    .base = &idt,
};

const IDTEntry = packed struct {
    offset_low: u16,
    selector: u16,
    zero: u8,
    flags: u8,
    offset_high: u16,
};

const IDTRegister = packed struct {
    limit: u16,
    base: *[256]IDTEntry,
};

pub fn setEntry(n: u8, flags: u8, selector: u16, f: extern fn () void) void {
    const offset = @ptrToInt(f);

    idt[n].offset_low = @truncate(u16, offset);
    idt[n].offset_high = @truncate(u16, offset >> 16);
    idt[n].flags = flags;
    idt[n].zero = 0;
    idt[n].selector = selector;
}

pub fn initialize() void {
    // Consider moving this to another place?
    isr.installExceptions();

    instructions.lidt(@ptrToInt(&idtr));
}
