/////////////////////////////////////
// Deez Nuts are licensed on GPLv3 //
//  Don't steal my shit. Have fun. //
//                     - Cherry <3 //
/////////////////////////////////////
const std = @import("std");
const http = std.http;
const heap = std.heap;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    const alloc = arena.allocator();

    // our http client, this can make multiple requests (and is even threadsafe, although individual requests are not).
    var client = std.http.Client{
        .allocator = alloc,
    };

    // we can `catch unreachable` here because we can guarantee that this is a valid url.
    const uri = std.Uri.parse("https://example.com") catch unreachable;

    // these are the headers we'll be sending to the server
    var headers = std.http.Headers{ .allocator = alloc };
    defer headers.deinit();

    try headers.append("accept", "*/*"); // tell the server we'll accept anything

    // make the connection and set up the request
    var req = try client.request(.GET, uri, headers, .{});
    defer req.deinit();

    // I'm making a GET request, so do I don't need this, but I'm sure someone will.
    // req.transfer_encoding = .chunked;

    // send the request and headers to the server.
    try req.start();

    // try req.writer().writeAll("Hello, World!\n");
    // try req.finish();

    // wait for the server to send use a response
    try req.wait();

    // read the content-type header from the server, or default to text/plain
    const content_type = req.response.headers.getFirstValue("content-type") orelse "text/plain";
    _ = content_type;

    // read the entire response body, but only allow it to allocate 8kb of memory
    const body = req.reader().readAllAlloc(alloc, 8192) catch unreachable;
    defer alloc.free(body);
    std.debug.print("{s}", .{body});

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

// pub fn rq_get() []u8 {
//     return;
// }

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
