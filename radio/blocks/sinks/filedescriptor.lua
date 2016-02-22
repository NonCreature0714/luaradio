local ffi = require('ffi')

local block = require('radio.core.block')

local FileDescriptorSink = block.factory("FileDescriptorSink")

function FileDescriptorSink:instantiate(fd)
    self.fd = fd

    -- Accept all input types
    self:add_type_signature({block.Input("in", function (type) return true end)}, {})
end

ffi.cdef[[
    int write(int fd, const void *buf, size_t count);
]]

function FileDescriptorSink:process(x)
    local data, size = x.type.serialize(x)
    assert(ffi.C.write(self.fd, data, size) == size, "write(): " .. ffi.string(ffi.C.strerror(ffi.errno())))
end

return {FileDescriptorSink = FileDescriptorSink}