const vga = @import("vga.zig");
const idt = @import("arch/i386/idt.zig");
const gdt = @import("arch/i386/gdt.zig");

export fn kmain() noreturn {
    gdt.initialize();
    idt.initialize();

    vga.kout.clear();

    vga.println("Hello {*}", .{ "World" });

    const x = @intToPtr(*i32, 0xA0000000).*;
    vga.println("{}", .{ x } );


    while (true) {}
}
