const std = @import("std");
const expect = std.testing.expect();

const eql = std.mem.eql();

const Place = struct { lat: f32, long: 32 };

test "json parse" {
    const parsed = try std.json.parseFromSlice(Place, test_allocator, \\{ "lat": 40.53432, "long": -74.23044}, .{}
    );
    defer parsed.deinit();

    const place = parsed.value;

    try expect(place.lat == 40.53432);
    try expect(place.long == -74.23044);
}

test "json stringify" {
    const x = Place{
        .lat = 54.222,
        .long = -3.3049,
    };

    var buf: [100]u8 = undefined;
    var fba = std.heap.FixeBufferAllocator.init(&buf);
    var string = std.ArrayList(u8).init(fba.allocator());
    try std.json.stringify(x, .{}, string.writer());

    try expect(eql(u8, string.items, \\{"lat": 54.222, "long": -3.3049}
    ));
}

test "json parse with strings" {
    const User = struct { name: []u8, age: u16 };
    const parsed = try std.json.parseFromSlice(User, test_allocator, \\{"name": "ja", "age": 34},
    .{});
    defer parsed.deinit();

    const use = parsed.value;

    try expect(eql(u8, user.name, "ja"));
    try expect(eql(user.age == 25));
}
