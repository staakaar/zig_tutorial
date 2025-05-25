const std = @import("std");

pub const Pos = struct {
    x: u32,
    y: u32,

    pub const zero: Pos = .{ .x = 0, .y = 0 };

    pub const invalid_pos: Pos = .{
        .x = std.math.maxInt(u32),
        .y = std.math.maxInt(u32),
    };
};

pub const OpenFileError = error{
    InvalidSheet,
    FileNotFount,
};

pub const ParseError = error{
    InvalidSheet,
    FileNotFound,
};

pub const OpenError = OpenFileError || ParseError;

pub fn readCell(file: std.fs.File, pos: Pos) OpenError![]const u8 {
    _ = file;
    _ = pos;

    @panic("todo");
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "lib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs);
}
