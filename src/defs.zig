// Type definitions (and other stuff)
pub const Cmds = enum { install, i };
pub const RunModes = enum { Install };
pub const PackageInfo = struct { name: []const u8, version: []const u8 };
