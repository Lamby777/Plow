////////////////////////////////////////
// Ergonomic access to the SpiGET API //
////////////////////////////////////////

const std = @import("std");
const util = @import("util.zig");
const PackageInfo = @import("defs.zig").PackageInfo;

const api_endpoints = .{
    .download = "https://api.spiget.org/v2/resources/{s}/download",
};

pub fn downloadPackage(ally: std.mem.Allocator, package: *const PackageInfo) ![]const u8 {
    // format package info into url
    const url = try std.fmt.allocPrint(ally, api_endpoints.download, .{package.name});
    defer ally.free(url);

    return util.httpGet(ally, url);
}
