const std = @import("std");
const input = @embedFile("data/day05.txt");

const delimiters = &std.ascii.whitespace;

const Range = struct {
    start: usize,
    end: usize,

    pub fn lessThan(_: void, lhs: Range, rhs: Range) bool {
        return lhs.start < rhs.start;
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

pub fn main() !void {
    const delim = std.mem.find(u8, input, "\n\n") orelse return error.InvalidInput;
    const id_ranges = input[0..delim];
    const ids = input[delim + 2 ..];

    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var total_part2: usize = 0;
    var id_ranges_tokenizer = std.mem.tokenizeAny(u8, id_ranges, delimiters);
    var ranges_list = std.ArrayList(Range).empty;
    defer ranges_list.deinit(alloc);

    while (id_ranges_tokenizer.next()) |range_str| {
        try ranges_list.append(alloc, try Range.parse(range_str));
    }

    std.mem.sortUnstable(Range, ranges_list.items, {}, Range.lessThan);

    var total_part1: usize = 0;

    var ids_tokenizer = std.mem.tokenizeAny(u8, ids, delimiters);
    while (ids_tokenizer.next()) |id_str| {
        const id = try std.fmt.parseUnsigned(usize, id_str, 10);
        for (ranges_list.items) |range| {
            if (range.contains(id)) {
                total_part1 += 1;
                break;
            }
        }
    }

    std.debug.print("Part 1 solution: {}\n", .{total_part1});

    var range = ranges_list.items[0];
    for (ranges_list.items[1..]) |inner_range| {
        std.debug.assert(inner_range.start >= range.start); // they are already in order
        if (inner_range.start <= range.end) { // overlapping
            range.end = @max(inner_range.end, range.end);
            // std.debug.print("Inner range merged: {f}\n", .{inner_range});
        } else {
            // std.debug.print("Final range merged: {f}\n\n", .{range});
            total_part2 += range.count();
            range = inner_range;
            // std.debug.print("New range       : {f}\n", .{range});
        }
    }

    total_part2 += range.count();
    std.debug.print("Part 2 solution: {}\n", .{total_part2});
}
