const idt = @import("idt.zig");
const gdt = @import("gdt.zig");

extern fn isr0() void;
extern fn isr1() void;
extern fn isr2() void;
extern fn isr3() void;
extern fn isr4() void;
extern fn isr5() void;
extern fn isr6() void;
extern fn isr7() void;
extern fn isr8() void;
extern fn isr9() void;
extern fn isr10() void;
extern fn isr11() void;
extern fn isr12() void;
extern fn isr13() void;
extern fn isr14() void;
extern fn isr15() void;
extern fn isr16() void;
extern fn isr17() void;
extern fn isr18() void;
extern fn isr19() void;
extern fn isr20() void;
extern fn isr21() void;
extern fn isr22() void;
extern fn isr23() void;
extern fn isr24() void;
extern fn isr25() void;
extern fn isr26() void;
extern fn isr27() void;
extern fn isr28() void;
extern fn isr29() void;
extern fn isr30() void;
extern fn isr31() void;

pub const InterruptContext = packed struct {
    ds: u32,
    edi: u32,
    esi: u32,
    ebp: u32,
    esp: u32,
    ebx: u32,
    edx: u32,
    ecx: u32,
    eax: u32,
    int_no: u32,
    err_code: u32,
    eip: u32,
    cs: u32,
    eflags: u32,
    useresp: u32,
    ss: u32,
};

const vga = @import("../../vga.zig");

export fn isrHandler(context: *InterruptContext) void {
    vga.println("Interrupt: {}", .{ context.int_no });
}

pub fn installExceptions() void {
    // Exceptions.
    idt.setEntry(0, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr0);
    idt.setEntry(1, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr1);
    idt.setEntry(2, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr2);
    idt.setEntry(3, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr3);
    idt.setEntry(4, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr4);
    idt.setEntry(5, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr5);
    idt.setEntry(6, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr6);
    idt.setEntry(7, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr7);
    idt.setEntry(8, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr8);
    idt.setEntry(9, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr9);
    idt.setEntry(10, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr10);
    idt.setEntry(11, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr11);
    idt.setEntry(12, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr12);
    idt.setEntry(13, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr13);
    idt.setEntry(14, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr14);
    idt.setEntry(15, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr15);
    idt.setEntry(16, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr16);
    idt.setEntry(17, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr17);
    idt.setEntry(18, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr18);
    idt.setEntry(19, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr19);
    idt.setEntry(20, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr20);
    idt.setEntry(21, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr21);
    idt.setEntry(22, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr22);
    idt.setEntry(23, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr23);
    idt.setEntry(24, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr24);
    idt.setEntry(25, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr25);
    idt.setEntry(26, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr26);
    idt.setEntry(27, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr27);
    idt.setEntry(28, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr28);
    idt.setEntry(29, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr29);
    idt.setEntry(30, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr30);
    idt.setEntry(31, idt.INTERRUPT_GATE, gdt.KERNEL_CODE, isr31);
}
