const std = @import("std");
const input = @embedFile("data/day05.txt");

const Range = @import("common.zig").Range;

const delimiters = &std.ascii.whitespace;

pub fn main() !void {
    const delim = std.mem.find(u8, input, "\n\n") orelse return error.InvalidInput;
    const id_ranges = input[0..delim];
    const ids = input[delim + 2 ..];

    var gpa = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    var id_ranges_tokenizer = std.mem.tokenizeAny(u8, id_ranges, delimiters);
    var ranges_list = std.ArrayList(Range).empty;
    defer ranges_list.deinit(alloc);

    while (id_ranges_tokenizer.next()) |range_str| {
        try ranges_list.append(alloc, try Range.parse(range_str));
    }

    Range.sort(ranges_list.items);

    // PART 1
    {
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
    }

    // PART 2
    {
        var total_part2: usize = 0;
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
}
