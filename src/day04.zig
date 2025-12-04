const std = @import("std");
const input = @embedFile("data/day04.txt");

const delimiters = &std.ascii.whitespace;

const Grid = @import("common.zig").Grid;

pub fn main() !void {
    var total_part1: usize = 0;
    var total_part2: usize = 0;

    var mut_input = input.*;
    var grid = try Grid.init(&mut_input);

    std.debug.print("Grid size: {} {}\n", .{ grid.width, grid.height });

    while (true) {
        var removed: usize = 0;
        const isPart1 = total_part1 == 0;
        for (0..grid.height) |y| {
            const iy: isize = @intCast(y);
            for (0..grid.width) |x| {
                const ix: isize = @intCast(x);
                if (grid.at(x, y) != '@') continue;
                var count: usize = 0;
                var dy: i3 = -1;
                while (dy <= 1) : (dy += 1) {
                    var dx: i3 = -1;
                    while (dx <= 1) : (dx += 1) {
                        if (dx == 0 and dy == 0) continue;
                        if (grid.at_checked(ix + dx, iy + dy)) |v| {
                            if (v == '@' or v == 'X') count += 1;
                        }
                    }
                }

                if (count < 4) {
                    if (isPart1) total_part1 += 1;
                    removed += 1;
                    grid.set(x, y, 'X');
                    // std.debug.print("{} {}\n", .{ x, y });
                }
            }
        }
        std.mem.replaceScalar(u8, grid.data, 'X', '.');
        total_part2 += removed;
        if (removed == 0) break;
    }

    std.debug.print("Part 1 solution: {}\n", .{total_part1});
    std.debug.print("Part 2 solution: {}\n", .{total_part2});
}
