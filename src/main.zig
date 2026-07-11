const std = @import("std");
const dvui = @import("dvui");
const SDLBackend = @import("sdl-backend");

const AppState = @import("model/app_state.zig").AppState;
const layout = @import("ui/layout.zig");

var g_backend: ?SDLBackend = null;

pub fn main(init: std.process.Init) !void {
    var backend = try SDLBackend.initWindow(.{
        .io = init.io,
        .environ_map = init.environ_map,

        .size = .{
            .w = 900,
            .h = 600,
        },

        .min_size = .{
            .w = 400,
            .h = 300,
        },

        .vsync = true,

        .title = "Valkyrie",
    });

    g_backend = backend;

    defer backend.deinit();

    var open = true;

    var win = try dvui.Window.init(
        @src(),
        init.gpa,
        backend.backend(),
        .{
            .open_flag = &open,
        },
    );

    defer win.deinit();

    var app = try AppState.init(
        init.gpa,
    );

    defer app.deinit();

    while (open) {
        const nstime = win.beginWait(false);

        try win.begin(nstime);

        try backend.addAllEvents(&win);

        layout.draw(&app);

        _ = try win.end(.{});

        const wait = win.waitTime(0);

        _ = try backend.waitEventTimeout(wait);
    }
}
