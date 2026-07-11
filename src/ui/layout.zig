const dvui = @import("dvui");
const AppState = @import("../model/app_state.zig").AppState;

pub fn draw(state: *AppState) void {
    var root = dvui.box(
        @src(),
        .{
            .dir = .horizontal,
        },
        .{
            .expand = .both,
            .background = true,
        },
    );
    defer root.deinit();

    //Server sidebar

    var servers = dvui.box(
        @src(),
        .{
            .dir = .vertical,
        },
        .{
            .min_size_content = .{
                .w = 70,
            },
            .background = true,
        },
    );
    defer servers.deinit();

    _ = dvui.label(
        @src(),
        "V",
        .{},
        .{},
    );

    _ = dvui.button(
        @src(),
        "+",
        .{},
        .{},
    );

    //Channel sidebar

    var channel_panel = dvui.box(
        @src(),
        .{
            .dir = .vertical,
        },
        .{
            .min_size_content = .{
                .w = 220,
            },
            .background = true,
        },
    );
    defer channel_panel.deinit();

    _ = dvui.label(
        @src(),
        "CHANNELS",
        .{},
        .{},
    );

    for (state.channels.items, 0..) |channel, i| {
        if (dvui.button(
            @src(),
            channel.name,
            .{},
            .{
                .id_extra = i,
            },
        )) {
            state.active_channel = i;
        }
    }

    //Chat area

    var chat = dvui.box(
        @src(),
        .{
            .dir = .vertical,
        },
        .{
            .expand = .both,
            .background = true,
        },
    );
    defer chat.deinit();

    if (state.channels.items.len > 0) {
        const channel =
            state.channels.items[state.active_channel];

        _ = dvui.label(
            @src(),
            "{s}",
            .{channel.name},
            .{},
        );

        var messages = dvui.scrollArea(
            @src(),
            .{},
            .{
                .expand = .both,
            },
        );
        defer messages.deinit();

        for (channel.messages.items, 0..) |msg, i| {
            _ = dvui.label(
                @src(),
                "{s}",
                .{msg.content},
                .{
                    .id_extra = i,
                },
            );
        }

        _ = dvui.button(
            @src(),
            "Type a message...",
            .{},
            .{},
        );
    }
}
