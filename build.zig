const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "valkyrie",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // 1. Fetch the DVUI dependency from build.zig.zon
    // Pass the backend option (sdl3, raylib, etc.)
    const dvui_dep = b.dependency("dvui", .{
        .target = target,
        .optimize = optimize,
        .backend = .sdl3,
    });

    // 2. Add the main DVUI module to your executable
    exe.root_module.addImport("dvui", dvui_dep.module("dvui_sdl3"));

    // 3. (Optional but recommended) Add the explicit backend import
    // This allows LazyVim/ZLS to provide autocomplete for backend features
    exe.root_module.addImport("sdl-backend", dvui_dep.module("sdl3"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
