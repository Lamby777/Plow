/////////////////////////////////////
// Deez Nuts are licensed on GPLv3 //
//  Don't steal my shit. Have fun. //
//                     - Cherry <3 //
/////////////////////////////////////
const std = @import("std");
const util = @import("util.zig");
const rq_get = util.rq_get;
const heap = std.heap;
const mem = std.mem;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer {
        const st = gpa.deinit();
        if (st == .leak) {
            std.debug.print("leaked (bruh)", .{});
        }
    }

    const alloc = gpa.allocator();

    var res = try rq_get(alloc, "https://sparklet.org/");
    defer alloc.free(res);
    std.debug.print("{s}", .{res});

    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}
