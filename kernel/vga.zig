const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const OutStream = std.io.OutStream(void, anyerror, printCallback);

pub var kout = VGA {
    .col = 0,
    .color = VGAColorPair {
        .foreground = VGAColor.Black,
        .background = VGAColor.White,
    }
};

pub const VGAColor = enum(u4) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGrey = 7,
    DarkGrey = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

pub const VGAColorPair = packed struct {
    foreground: VGAColor,
    background: VGAColor,
};

pub const VGAEntry = packed struct {
    char: u8,
    color: VGAColorPair,
};

pub const VGA = struct {
    const height = 25;
    const width = 80;
    const size = height * width;
    const base = 0xB8000; 
    const matrix = @intToPtr(*[height][width] VGAEntry, base);


    col: usize,
    color: VGAColorPair,

    pub fn clear(self: *VGA) void {
        for (matrix) |*row| {
            for (row) |*cell| cell.* = self.entry(' ');
        }    
    }

    pub fn putChar(self: *VGA, c: u8) void {

        switch (c) {
            '\n' => {
                self.putNewline();
            },
            else => {
                matrix[height - 1][self.col] = self.entry(c);
                self.col += 1;
                
                if(width == self.col) {
                    self.putNewline();
                }
            }
        }
    }

    pub fn putString(self: *VGA, string: []const u8) void {
        for (string) |c| self.putChar(c);
    }

    pub fn setColor(self: *VGA, color: VGAColorPair) void {
        self.color = color;
    }

    fn putNewline(self: *VGA) void {
        const first_line = width;
        const last_line = size - width;
        
        for (matrix[0..height-1]) |*row, row_index| {
            for (row[0..width]) |*cell, col_index| cell.* = matrix[row_index + 1][col_index];
        }

        for (matrix[height-1]) |*cell| cell.* = self.entry(' ');

        self.col = 0;
    }

    fn entry(self: *VGA, c: u8) VGAEntry {
        return VGAEntry {
            .char = c,
            .color = self.color,
        };
    }
};

pub inline fn println(comptime format: []const u8, args: var) void {
    print(format ++ "\n", args);
}

pub fn print(comptime format: []const u8, args: var) void {
    fmt.format(OutStream{ .context = {} }, format, args) catch {};
}

fn printCallback(context: void, string: []const u8) anyerror!usize {
    kout.putString(string);
    return string.len;
}

