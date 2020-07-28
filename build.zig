const Builder = @import("std").build.Builder;
const builtin = @import("builtin");
const std = @import("std");

pub fn build(b: *Builder) void {
    const kernel = b.addExecutable("kernel", "kernel/main.zig");
    kernel.setOutputDir("build");

    kernel.addAssemblyFile("kernel/arch/i386/boot.S");
    kernel.addAssemblyFile("kernel/arch/i386/gdt.S");
    kernel.addAssemblyFile("kernel/arch/i386/isr.S");

    kernel.setBuildMode(b.standardReleaseOptions());
    kernel.setTarget(std.zig.CrossTarget{
        .cpu_arch = .i386,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.x86.cpu._i686},
    });
    kernel.setLinkerScriptPath("kernel.ld");
    b.default_step.dependOn(&kernel.step);
}
