const std = @import("std");

pub const Message = struct {
    author: []const u8,
    content: []const u8,

    pub fn init(
        author: []const u8,
        content: []const u8,
    ) Message {
        return Message{
            .author = author,
            .content = content,
        };
    }

    pub fn deinit(
        self: *Message,
        allocator: std.mem.Allocator,
    ) void {
        allocator.free(self.author);
        allocator.free(self.content);
    }
};
