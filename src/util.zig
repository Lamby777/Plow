const std = @import("std");
const heap = std.heap;
const mem = std.mem;
const ArrayList = std.ArrayList;

const PLUGIN_DL_LIMIT = 1_000_000;

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
    const body = req.reader().readAllAlloc(alloc, PLUGIN_DL_LIMIT) catch unreachable;

    return body;
}
