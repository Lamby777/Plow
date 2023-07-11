/////////////////////////////////////
// Deez Nuts are licensed on GPLv3 //
//  Don't steal my shit. Have fun. //
//                     - Cherry <3 //
/////////////////////////////////////
const std = @import("std");
const hzzp = @import("hzzp");
const heap = std.heap;
const mem = std.mem;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    const alloc = arena.allocator();

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

// https://zig.news/nameless/coming-soon-to-a-zig-near-you-http-client-5b81
pub fn rq_get(alloc: mem.Allocator, url: []const u8) ![]u8 {
    var client = std.http.Client{
        .allocator = alloc,
    };

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
    const body = req.reader().readAllAlloc(alloc, 8192) catch unreachable;

    return body;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
