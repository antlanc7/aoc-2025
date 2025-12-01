const std = @import("std");
const input = @embedFile("input.txt");

pub fn part1() !void {
    var pos: isize = 50;
    var count: usize = 0;

    var lines = std.mem.tokenizeAny(u8, input, &std.ascii.whitespace);

    while (lines.next()) |line| {
        const direction: i2 = if (line[0] == 'R') 1 else -1;
        const steps = try std.fmt.parseUnsigned(isize, line[1..], 10) * direction;
        const new_pos = pos + steps;
        pos = @mod(new_pos, 100);
        if (pos == 0) {
            count += 1;
        }
        // std.debug.print("{} {}\n", .{ pos, count });
    }

    std.debug.print("Part 1 solution: {}\n", .{count});
}

pub fn part2() !void {
    var pos: isize = 50;
    var count: usize = 0;

    var lines = std.mem.tokenizeAny(u8, input, &std.ascii.whitespace);

    while (lines.next()) |line| {
        // const old_pos = pos;
        const direction: i2 = if (line[0] == 'R') 1 else -1;
        const steps = try std.fmt.parseUnsigned(isize, line[1..], 10) * direction;
        const new_pos = pos + steps;
        const crossed_zero = @intFromBool(new_pos * pos < 0 or new_pos == 0);
        const zero_passes: usize = crossed_zero + @abs(@divTrunc(new_pos, 100));
        pos = @mod(new_pos, 100);
        count += zero_passes;
        // std.debug.print("{} {} {} {} {} {}\n", .{ old_pos, steps, new_pos, zero_passes, pos, count });
    }

    std.debug.print("Part 2 solution: {}\n", .{count});
}

pub fn main() !void {
    try part1();
    try part2();
}
