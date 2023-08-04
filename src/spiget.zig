////////////////////////////////////////
// Ergonomic access to the SpiGET API //
////////////////////////////////////////

const std = @import("std");
const util = @import("util.zig");
const PackageInfo = @import("defs.zig").PackageInfo;
const httpGetH = util.httpGetH;

const api_endpoints = .{
    .download = "https://api.spiget.org/v2/resources/{s}/download",
};

pub fn downloadPackage(ally: std.mem.Allocator, package: *const PackageInfo) ![]const u8 {
    // Create a Headers object that sets the user agent
    var headers = std.http.Headers{ .allocator = ally };
    defer headers.deinit();

    try headers.append("accept", "*/*");
    try headers.append("user-agent", "Sussy Gussy");

    // format package info into url
    const url = try std.fmt.allocPrint(ally, api_endpoints.download, .{package.name});

    return httpGetH(ally, url, headers);
}
