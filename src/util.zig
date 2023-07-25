const std = @import("std");
const defs = @import("defs.zig");
const mem = std.mem;
const fmt = std.fmt;

const PLUGIN_DL_LIMIT = 1_000_000;

pub fn resolveTarget(target: []const u8) []const u8 {
    return target;
}

// https://zig.news/nameless/coming-soon-to-a-zig-near-you-http-client-5b81
pub fn rq_get(alloc: mem.Allocator, url: []const u8) ![]const u8 {
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

    // TODO why do we need a download limit? should be optional
    return req.reader().readAllAlloc(alloc, PLUGIN_DL_LIMIT) catch unreachable;
}

pub const Range = struct {
    min: usize = 0,
    max: ?usize = null,
};

pub fn assertArgMinN(len: usize, comptime min: usize) void {
    // Really, man? https://github.com/ziglang/zig/issues/484
    assertArgLen(len, Range{ .min = min });
}

pub fn assertArgLenN(len: usize, comptime min: usize, comptime max: ?usize) void {
    // ughhhhhhhh cmon andrew, let me use default values already!
    assertArgLen(len, Range{ .min = min, .max = max });
}

pub fn assertArgLen(len: usize, comptime range: Range) void {
    // more short-circuit evaluation clownery <3
    const under = len < range.min;
    const over = (range.max != null) and (len > range.max.?);

    if (!(over or under)) {
        return; // congrats
    }

    // display-formatted expected range
    const expectedRange = fmt.comptimePrint("{} to {s}", .{
        range.min,
        if (range.max) |v| fmt.comptimePrint("{}", .{v}) else "...",
    });

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
