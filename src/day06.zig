const std = @import("std");
const input = @embedFile("data/day06.txt");

const test_input =
    \\123 328  51 64 
    \\ 45 64  387 23 
    \\  6 98  215 314
    \\*   +   *   +  
;

const delimiters = &std.ascii.whitespace;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    var lines_iter = std.mem.tokenizeAny(u8, input, "\r\n");
    var lines = std.ArrayList([]const u8).empty;
    defer lines.deinit(alloc);

    while (lines_iter.next()) |line| {
        try lines.append(alloc, line);
    }

    const op_line = lines.pop() orelse return error.InvalidInput;

    // PART 1
    {
        var total_part1: usize = 0;
        var line_tokenizers = try std.ArrayList(std.mem.TokenIterator(u8, .scalar)).initCapacity(alloc, lines.items.len);
        defer line_tokenizers.deinit(alloc);
        for (lines.items) |line| {
            line_tokenizers.appendAssumeCapacity(std.mem.tokenizeScalar(u8, line, ' '));
        }
        var op_iterator = std.mem.tokenizeScalar(u8, op_line, ' ');
        while (op_iterator.next()) |op| {
            var res: usize = if (op[0] == '*') 1 else 0;
            for (line_tokenizers.items) |*line_tokenizer| {
                const token = line_tokenizer.next() orelse return error.InvalidInput;
                const val = try std.fmt.parseUnsigned(usize, token, 10);
                res = if (op[0] == '*') res * val else res + val;
            }
            total_part1 += res;
        }
        std.debug.print("Part 1 solution: {}\n", .{total_part1});
    }

    // PART 2
    {
        var total_part2: usize = 0;
        const len = lines.items[0].len;
        var current_result_sum: usize = 0;
        var current_result_prod: usize = 1;
        var index: usize = 0;
        while (index < len) : (index += 1) {
            var current_number: usize = 0;
            const i = len - index - 1;
            const op = op_line[i];
            for (lines.items) |line| {
                const char = line[i];
                if (std.ascii.isDigit(char)) {
                    current_number = current_number * 10 + (char - '0');
                }
            }
            // std.debug.print("{} {c}\n", .{ current_number, op });
            current_result_sum += current_number;
            current_result_prod *= current_number;
            switch (op) {
                '+' => {
                    // std.debug.print("sum: {}\n", .{current_result_sum});
                    total_part2 += current_result_sum;
                    current_result_sum = 0;
                    current_result_prod = 1;
                    index += 1; // skip space column
                },
                '*' => {
                    // std.debug.print("prod: {}\n", .{current_result_prod});
                    total_part2 += current_result_prod;
                    current_result_sum = 0;
                    current_result_prod = 1;
                    index += 1; // skip space column
                },
                else => {},
            }
        }
        std.debug.print("Part 2 solution: {}\n", .{total_part2});
    }
}
