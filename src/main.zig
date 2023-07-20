/////////////////////////////////////
// Deez Nuts are licensed on GPLv3 //
//  Don't steal my shit. Have fun. //
//                     - Cherry <3 //
/////////////////////////////////////
const std = @import("std");
const lyte = @import("lyte");
const util = @import("util.zig");
const rq_get = util.rq_get;
const heap = std.heap;
const mem = std.mem;
const log = std.log;

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer {
        const st = gpa.deinit();
        if (st == .leak) {
            std.debug.print("leaked (bruh)", .{});
        }
    }

    const alloc = gpa.allocator();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    for (args) |arg| {
        std.debug.print("{s}\n", .{arg});
    }

    log.info("Getting package...", .{});
    var res = try rq_get(alloc, "https://sparklet.org/");
    defer alloc.free(res);
    log.info("Installing package...", .{});
}
