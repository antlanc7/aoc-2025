const std = @import("std");
const input = @embedFile("data/day03.txt");

const delimiters = &std.ascii.whitespace;

fn evalBank(bank: []const u8, digits: usize) usize {
    std.debug.assert(bank.len >= digits);
    var val: usize = 0;
    var idx: usize = 0;
    for (0..digits) |i| {
        const curr_bank = bank[idx..(bank.len - (digits - i - 1))];
        const i_max = std.mem.findMax(u8, curr_bank);
        val *= 10;
        val += curr_bank[i_max] - '0';
        idx += i_max + 1;
    }
    return val;
}

pub fn main() !void {
    var total_part1: usize = 0;
    var total_part2: usize = 0;

    var banks = std.mem.tokenizeAny(u8, input, delimiters);

    while (banks.next()) |bank| {
        total_part1 += evalBank(bank, 2);
        total_part2 += evalBank(bank, 12);
    }

    std.debug.print("Part 1 solution: {}\n", .{total_part1});
    std.debug.print("Part 2 solution: {}\n", .{total_part2});
}
