const std = @import("std");

pub const Grid = struct {
    data: []u8,
    width: usize,
    height: usize,

    pub fn init(input: []u8) !Grid {
        const width = std.mem.findScalar(u8, input, '\n') orelse return error.InvalidInput;
        const height = std.mem.countScalar(u8, input, '\n') + @as(usize, if (input[input.len - 1] != '\n') 1 else 0);
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

pub const Range = struct {
    start: usize,
    end: usize,

    fn lessThan(_: void, lhs: Range, rhs: Range) bool {
        return lhs.start < rhs.start;
    }

    /// Sorts a slice of ranges in-place based on start index.
    pub fn sort(ranges: []Range) void {
        std.mem.sortUnstable(Range, ranges, {}, lessThan);
    }

    pub fn parse(range_str: []const u8) !Range {
        const dash = std.mem.findScalar(u8, range_str, '-') orelse return error.InvalidInput;
        const range_start = try std.fmt.parseUnsigned(usize, range_str[0..dash], 10);
        const range_end = try std.fmt.parseUnsigned(usize, range_str[dash + 1 ..], 10);
        std.debug.assert(range_end >= range_start);
        return Range{
            .start = range_start,
            .end = range_end,
        };
    }

    pub fn format(range: Range, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("{}-{}", .{ range.start, range.end });
    }

    pub fn count(range: Range) usize {
        return range.end - range.start + 1;
    }

    pub fn contains(range: Range, id: usize) bool {
        return id >= range.start and id <= range.end;
    }
};
