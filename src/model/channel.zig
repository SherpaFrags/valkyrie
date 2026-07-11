const std = @import("std");
const Message = @import("message.zig").Message;

pub const Channel = struct {
    name: []const u8,
    messages: std.ArrayList(Message),

    pub fn init(name: []const u8) Channel {
        return .{
            .name = name,
            .messages = .empty,
        };
    }

    pub fn deinit(
        self: *Channel,
        allocator: std.mem.Allocator,
    ) void {
        for (self.messages.items) |*msg| {
            msg.deinit(allocator);
        }

        self.messages.deinit(allocator);
    }
};
