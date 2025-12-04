const std = @import("std");

pub const Grid = struct {
    data: []u8,
    width: usize,
    height: usize,

    pub fn init(input: []u8) !Grid {
        const width = std.mem.indexOfScalar(u8, input, '\n') orelse return error.InvalidInput;
        const height = std.mem.count(u8, input, "\n") + @as(usize, if (input[input.len - 1] != '\n') 1 else 0);
        return .{
            .data = input,
            .width = width,
            .height = height,
        };
    }

    pub fn at(self: Grid, x: usize, y: usize) u8 {
        return self.data[y * (self.width + 1) + x];
    }

    pub fn at_checked(self: Grid, x: isize, y: isize) ?u8 {
        if (x < 0 or y < 0) return null;
        if (x >= self.width or y >= self.height) return null;
        return self.at(@intCast(x), @intCast(y));
    }

    pub fn set(self: *Grid, x: usize, y: usize, value: u8) void {
        self.data[y * (self.width + 1) + x] = value;
    }
};
