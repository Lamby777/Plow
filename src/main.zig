/////////////////////////////////////
// Deez Nuts are licensed on GPLv3 //
//  Don't steal my shit. Have fun. //
//                     - Cherry <3 //
/////////////////////////////////////
const std = @import("std");
const util = @import("util.zig");
const defs = @import("defs.zig");
const spiget = @import("spiget.zig");
const httpGet = util.httpGet;
const heap = std.heap;
const mem = std.mem;
const log = std.log;
const fmt = std.fmt;

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer {
        const st = gpa.deinit();
        if (st == .leak) {
            std.debug.print("leaked (bruh)", .{});
        }
    }

    const ally = gpa.allocator();

    const _args = try std.process.argsAlloc(ally);
    defer std.process.argsFree(ally, _args);

    if (_args.len <= 1) {
        util.showHelp();
        return;
    }

    const subcommand = util.parseSubcommand(_args[1]) orelse {
        std.debug.print("Invalid subcommand {s}\n", .{_args[1]});
        util.showHelp();
        return;
    };

    const args: [][:0]u8 = _args[2..];

    switch (subcommand) {
        .Install => {
            util.assertArgMinN(args.len, 1);

            for (args) |target| {
                try install(ally, target);
            }
        },
    }
}

fn install(ally: mem.Allocator, target: []const u8) !void {
    log.info("Resolving target `{s}`...", .{target});

    // TODO make this return a struct that tells us
    // where to download the package from
    const url = util.resolveTarget(target);
    _ = url;

    log.info("Getting package...", .{});

    var pkg = defs.PackageInfo{
        .name = target,
        .version = "deez nuts",
    };

    const res = try spiget.downloadPackage(ally, &pkg);

    defer ally.free(res);
    log.info("Installing package...", .{});
}
