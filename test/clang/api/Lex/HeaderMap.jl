using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

# `CreateHeaderMap` already handed the map out; here it is finally asked something. The
# .hmap below is written by hand because clang only ever reads the format, never writes it:
# a 24-byte header, a power-of-two bucket array of 12-byte entries, then a string pool that
# every bucket field indexes relative to StringsOffset. Offset 0 of the pool is reserved,
# since a zero key means "empty bucket".

"clang's HashHMapKey: the lowercased bytes, each times 13, summed mod 2^32."
hmap_hash(s) = foldl((a, c) -> a + UInt32(lowercase(c)) * UInt32(13), s; init=UInt32(0))

@testset "HeaderMap | lookup, reverse lookup and enumeration" begin
    dir = mktempdir()
    path = joinpath(dir, "hm-probe.hmap")

    key = "Probe.h"
    prefix = "/probe/dir/"
    numbuckets = UInt32(2)
    strings_offset = UInt32(24 + 12 * numbuckets)
    # pool: [0] NUL (reserved), [1] key, [1 + len(key) + 1] prefix. The suffix reuses the
    # key's bytes, so a lookup rebuilds prefix * key.
    key_off = UInt32(1)
    prefix_off = UInt32(1 + ncodeunits(key) + 1)
    bucket = hmap_hash(key) & (numbuckets - UInt32(1))

    open(path, "w") do io
        write(io, UInt32(0x686d6170))                 # magic
        write(io, UInt16(1))                          # version
        write(io, UInt16(0))                          # reserved
        write(io, strings_offset)
        write(io, UInt32(1))                          # entry count
        write(io, numbuckets)
        write(io, UInt32(ncodeunits(prefix) + ncodeunits(key)))  # longest value
        for b = UInt32(0):(numbuckets - UInt32(1))
            if b == bucket
                write(io, key_off, prefix_off, key_off)
            else
                write(io, UInt32(0), UInt32(0), UInt32(0))
            end
        end
        write(io, UInt8(0))                           # pool[0], the reserved slot
        write(io, key)
        write(io, UInt8(0))
        write(io, prefix)
        write(io, UInt8(0))
    end

    I = create_interpreter(String[])
    ci = get_instance(I)
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(ci))
    fm = CC.getFileMgr(hs)
    fer = CC.getFileRef(fm, path)
    hm = CC.CreateHeaderMap(hs, fer)
    @test !CC.is_null_handle(hm)

    # the map names itself by the path it was loaded from
    @test endswith(CC.getFileName(hm), "hm-probe.hmap")

    # the entry: the key maps to prefix * suffix, which is what an #include of it resolves to
    @test CC.lookupFilename(hm, key) == prefix * key
    # the match is case insensitive, exactly as clang's own probe is
    @test CC.lookupFilename(hm, lowercase(key)) == prefix * key
    # a miss is the empty string rather than a garbage path
    @test CC.lookupFilename(hm, "Absent.h") == ""

    # and the inverse turns a resolved path back into the spelling a user would have written
    @test CC.reverseLookupFilename(hm, prefix * key) == key
    @test CC.reverseLookupFilename(hm, "/nowhere/Absent.h") == ""

    # the enumeration sees the one real bucket and skips the empty one
    @test CC.getKeys(hm) == [key]

    # dump goes to stderr and answers nothing; it must at least not throw
    @test CC.dump(hm) === nothing

    dispose(fer)
    dispose(I)
end
