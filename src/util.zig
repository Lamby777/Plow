const std = @import("std");
const defs = @import("defs.zig");
const mem = std.mem;
const fmt = std.fmt;

const PLUGIN_DL_LIMIT = 1_000_000;

pub fn resolveTarget(target: []const u8) []const u8 {
    return target;
}

// https://zig.news/nameless/coming-soon-to-a-zig-near-you-http-client-5b81
pub fn rq_get(alloc: mem.Allocator, url: []const u8) ![]u8 {
    var client = std.http.Client{
        .allocator = alloc,
    };
    defer client.deinit();

    const uri = std.Uri.parse(url) catch unreachable;
    var headers = std.http.Headers{ .allocator = alloc };
    defer headers.deinit();

    try headers.append("accept", "*/*"); // tell the server we'll accept anything
    var req = try client.request(.GET, uri, headers, .{});
    defer req.deinit();

    // req.transfer_encoding = .chunked;
    try req.start();

    // try req.writer().writeAll("Hello, World!\n");
    // try req.finish();

    // wait for the server to send use a response
    try req.wait();

    // TODO just return this?
    const body = req.reader().readAllAlloc(alloc, PLUGIN_DL_LIMIT) catch unreachable;

    return body;
}

pub fn assertArgLen(len: usize, comptime min: ?usize, comptime max: ?usize) void {
    // more short-circuit evaluation clownery <3
    const limMin = (min != null);
    const limMax = (max != null);
    const under = limMin and (len < min.?);
    const over = limMax and (len > max.?);

    if (!(over or under)) {
        return; // congrats
    }

    // display-formatted expected range
    const expectedRange = makeRangeStr: {
        const minD = if (limMin) fmt.comptimePrint("{?}", .{min}) else "";
        const maxD = if (limMax) fmt.comptimePrint("{?}", .{max}) else "";

        break :makeRangeStr fmt.comptimePrint("{s}...{s}", .{ minD, maxD });
    };

    const complaint = if (over) "Too many" else "Not enough";
    std.debug.print("{s} arguments ({}) given! Expected {s}\n\n", .{ complaint, len, expectedRange });
    std.os.exit(2);
}

pub fn showHelp() void {
    std.debug.print("<help text>\n", .{});
}

pub fn parseSubcommand(cmdStr: []const u8) ?defs.RunModes {
    const cmd =
        std.meta.stringToEnum(defs.Cmds, cmdStr) orelse
        return null;

    // map commands (and aliases) to run modes
    return switch (cmd) {
        .install, .i => .Install,
    };
}
