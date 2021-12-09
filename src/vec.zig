const std = @import("std");

const expect = std.testing.expect;

pub const Vec3 = Vector3(f32);
pub const Point3 = Vector3(f32);
pub const Color = Vector3(f32);

fn Vector3(comptime T: type) type {
    return struct {
        const Self = @This();

        x: T,
        y: T,
        z: T,

        pub fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }

        pub fn initAll(x: T) Self {
            return Self.init(x, x, x);
        }

        // Vector arithmetic

        pub fn add(a: Self, b: Self) Self {
            return Self.init(a.x + b.x, a.y + b.y, a.z + b.z);
        }

        pub fn sub(a: Self, b: Self) Self {
            return Self.init(a.x - b.x, a.y - b.y, a.z - b.z);
        }

        pub fn dot(a: Self, b: Self) T {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }

        pub fn cross(a: Self, b: Self) Self {
            return Self.init(
                a.y * b.z - a.z * b.y,
                a.z * b.x - a.x * b.z,
                a.x * b.y - a.y * b.x,
            );
        }

        // Scalar arithmetic

        pub fn scale(a: Self, b: T) Self {
            return Self.init(a.x * b, a.y * b, a.z * b);
        }

        pub fn div(a: Self, b: T) Self {
            return a.scale(@as(T, 1) / b);
        }

        pub fn len2(a: Self) T {
            return dot(a, a);
        }

        pub fn len(a: Self) T {
            return @sqrt(len2(a));
        }

        pub fn normalize(a: Self) Self {
            return a.div(len(a));
        }

        pub fn eql(a: Self, b: Self) bool {
            return std.meta.eql(a, b);
        }

        pub fn lerp(a: Self, b: Self, t: f32) Self {
            return a.scale(1.0 - t).add(b.scale(t));
        }
    };
}

test "add" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(4, 5, 6);

    try expect(a.add(b).eql(Vec3.init(5, 7, 9)));
}

test "sub" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(4, 5, 6);

    try expect(a.sub(b).eql(Vec3.init(-3, -3, -3)));
}
test "dot" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(4, 5, 6);

    try expect(a.dot(b) == 32);
}

test "cross" {
    const a = Vec3.init(1, 2, 3);
    const b = Vec3.init(4, 5, 6);

    try expect(a.cross(b).eql(Vec3.init(-3, 6, -3)));
}

test "scale" {
    const a = Vec3.init(1, 2, 3);
    const b = 10.0;

    try expect(a.scale(b).eql(Vec3.init(10, 20, 30)));
}

test "norm" {
    const a = Vec3.init(1, 2, 3);

    try expect(a.len() == @sqrt(14.0));
}

test "normalize" {
    const a = Vec3.init(10, 0, 0);

    try expect(a.normalize().eql(Vec3.init(1, 0, 0)));
}
