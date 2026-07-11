const std = @import("std");
const Channel = @import("channel.zig").Channel;

pub const AppState = struct {
    allocator: std.mem.Allocator,

    channels: std.ArrayList(Channel),
    active_channel: usize,

    pub fn init(
        allocator: std.mem.Allocator,
    ) !AppState {
        var state = AppState{
            .allocator = allocator,
            .channels = .empty,
            .active_channel = 0,
        };

        try state.channels.append(
            allocator,
            Channel.init("general"),
        );

        try state.channels.append(
            allocator,
            Channel.init("random"),
        );

        try state.channels.append(
            allocator,
            Channel.init("development"),
        );

        return state;
    }

    pub fn deinit(
        self: *AppState,
    ) void {
        for (self.channels.items) |*channel| {
            channel.deinit(self.allocator);
        }

        self.channels.deinit(self.allocator);
    }
};
