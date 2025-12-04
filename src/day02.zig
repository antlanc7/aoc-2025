const std = @import("std");
const input = @embedFile("data/day02.txt");

const delimiters = std.ascii.whitespace ++ ",";

fn isSequenceRepeatedPart1(id: usize) bool {
    var buf: [32]u8 = undefined;
    const token = std.fmt.bufPrint(&buf, "{d}", .{id}) catch unreachable;
    if (token.len % 2 > 0) return false;
    const half = token.len / 2;
    return std.mem.eql(u8, token[0..half], token[half..]);
}

fn isSequenceRepeatedPart2(id: usize) bool {
    var buf: [32]u8 = undefined;
    const token = std.fmt.bufPrint(&buf, "{d}", .{id}) catch unreachable;
    for (1..token.len) |i| {
        if (token.len % i == 0) {
            const part = token[0..i];
            var repeated = true;
            for (1..(token.len / i)) |j| {
                if (!std.mem.eql(u8, part, token[j * i .. (j + 1) * i])) {
                    repeated = false;
                    break;
                }
            }
            if (repeated) {
                // std.debug.print("repeated -> ID: {}, part: {s}\n", .{ id, part });
                return true;
            }
        }
    }
    return false;
}

pub fn main() !void {
    var total_part1: usize = 0;
    var total_part2: usize = 0;

    var elems = std.mem.tokenizeAny(u8, input, delimiters);

    while (elems.next()) |elem| {
        const dash = std.mem.indexOfScalar(u8, elem, '-') orelse continue;
        const firstId = try std.fmt.parseUnsigned(usize, elem[0..dash], 10);
        const secondId = try std.fmt.parseUnsigned(usize, elem[dash + 1 ..], 10);
        for (firstId..secondId + 1) |id| {
            if (isSequenceRepeatedPart1(id)) total_part1 += id;
            if (isSequenceRepeatedPart2(id)) total_part2 += id;
        }
    }

    std.debug.print("Part 1 solution: {}\n", .{total_part1});
    std.debug.print("Part 2 solution: {}\n", .{total_part2});
}
