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
const log = std.log;

const Subcommand = enum { install };

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer {
        const st = gpa.deinit();
        if (st == .leak) {
            std.debug.print("leaked (bruh)", .{});
        }
    }

    const alloc = gpa.allocator();

    const _args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, _args);

    if (_args.len <= 1) {
        showHelp();
        return;
    }

    const subcommand = std.meta.stringToEnum(Subcommand, _args[1]) orelse {
        std.debug.print("Invalid subcommand {s}\n", .{_args[1]});
        showHelp();
        return;
    };
    _ = subcommand;

    const args: [][:0]u8 = _args[2..];
    _ = args;

    log.info("Getting package...", .{});
    var res = try rq_get(alloc, "https://sparklet.org/");
    defer alloc.free(res);
    log.info("Installing package...", .{});
}

fn showHelp() void {
    std.debug.print("<help text>\n", .{});
}
