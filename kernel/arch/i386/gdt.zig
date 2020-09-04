// GDT Segment selectors
pub const KERNEL_CODE = 0x08;
pub const KERNEL_DATA = 0x10;
pub const USER_CODE = 0x18;
pub const USER_DATA = 0x20;

// GDT Access
// TODO: Consider switching to enum?
const KERNEL = 0x90;
const USER = 0xF0;
const CODE = 0x0A;
const DATA = 0x02;

// Segment flags.
const PROTECTED = (1 << 2);
const BLOCKS_4K = (1 << 3);

var gdt align(4) = [_]GDTEntry{
    makeEntry(0, 0, 0, 0), // Null Segment
    makeEntry(0, 0xFFFFFF, KERNEL | CODE, PROTECTED | BLOCKS_4K), // Kernel code
    makeEntry(0, 0xFFFFFF, KERNEL | DATA, PROTECTED | BLOCKS_4K), // Kernel data
    makeEntry(0, 0xFFFFFF, USER | CODE, PROTECTED | BLOCKS_4K), // User code
    makeEntry(0, 0xFFFFFF, USER | DATA, PROTECTED | BLOCKS_4K), // User data
};

var gdt_ptr = GDTRegister{
    .limit = @as(u16, @sizeOf(@TypeOf(gdt))) - 1,
    .base = &gdt[0],
};

const GDTEntry = packed struct {
    limit_low: u16,
    base_low: u16,
    base_middle: u8,
    access: u8,
    limit_high: u4,
    flags: u4,
    base_high: u8,
};

const GDTRegister = packed struct {
    limit: u16,
    base: *const GDTEntry,
};

fn makeEntry(base: usize, limit: usize, access: u8, flags: u4) GDTEntry {
    return GDTEntry{
        .limit_low = @truncate(u16, limit),
        .limit_high = @truncate(u4, limit >> 16),

        .base_low = @truncate(u16, base),
        .base_middle = @truncate(u8, base >> 16),
        .base_high = @truncate(u8, base >> 24),

        .flags = flags,
        .access = access,
    };
}

extern fn loadGDT(*GDTRegister) void;

pub fn initialize() void {

    loadGDT(&gdt_ptr);
}
