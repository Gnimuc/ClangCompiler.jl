# The import and export tables of a PE image (a Windows DLL), read from the file: what it
# asks other DLLs for by name, and what it offers. The loader answers the first from the
# second at load time, so a build can answer it in advance, against the copies of those
# DLLs that will actually be loaded. Nothing here needs a tool on PATH or a Windows host.

struct PEImage
    io::IOBuffer
    sections::Vector{NTuple{3,UInt32}}   # (VirtualAddress, SizeOfRawData, PointerToRawData)
    datadirs::Vector{Tuple{UInt32,UInt32}}  # (VirtualAddress, Size): 1 = export, 2 = import
    plus::Bool                           # PE32+ (64-bit): 8-byte thunks, wider optional header
end

function PEImage(path::AbstractString)
    io = IOBuffer(read(path))
    seek(io, 0x3c)
    pe = read(io, UInt32)                # e_lfanew: where the PE signature sits
    seek(io, pe)
    read(io, UInt32) == 0x00004550 || error("$path is not a PE image")
    seek(io, pe + 6)
    nsections = read(io, UInt16)
    seek(io, pe + 20)
    optsize = read(io, UInt16)
    opt = pe + 24
    seek(io, opt)
    magic = read(io, UInt16)
    plus = magic == 0x20b
    plus || magic == 0x10b || error("$path has an optional header of unknown magic $magic")
    seek(io, opt + (plus ? 108 : 92))    # NumberOfRvaAndSizes, then the directories
    ndirs = read(io, UInt32)
    datadirs = [(read(io, UInt32), read(io, UInt32)) for _ = 1:ndirs]
    sections = map(0:(nsections - 1)) do i
        seek(io, opt + optsize + 40i + 8)  # past the 8-byte name
        _vsize, vaddr, rawsize, rawptr = read(io, UInt32), read(io, UInt32), read(io, UInt32), read(io, UInt32)
        (vaddr, rawsize, rawptr)
    end
    return PEImage(io, sections, datadirs, plus)
end

# A relative virtual address, as the tables spell every pointer, to its offset in the file.
# Only bytes the file holds qualify: a section's zero-filled tail past SizeOfRawData does not.
function fileoffset(pe::PEImage, rva::Integer)
    for (vaddr, size, rawptr) in pe.sections
        vaddr <= rva < vaddr + size && return rawptr + (rva - vaddr)
    end
    error("RVA $rva is backed by no file data")
end

function cstring(pe::PEImage, rva::Integer)
    seek(pe.io, fileoffset(pe, rva))
    bytes = UInt8[]
    while (b = read(pe.io, UInt8)) != 0
        push!(bytes, b)
    end
    return String(bytes)
end

"""
    pe_exports(path) -> Vector{String}

The names the image exports.
"""
function pe_exports(path::AbstractString)
    pe = PEImage(path)
    length(pe.datadirs) >= 1 || return String[]
    rva, _ = pe.datadirs[1]
    rva == 0 && return String[]
    dir = fileoffset(pe, rva)
    seek(pe.io, dir + 24)                # NumberOfNames
    nnames = read(pe.io, UInt32)
    seek(pe.io, dir + 32)                # AddressOfNames
    names_rva = read(pe.io, UInt32)
    seek(pe.io, fileoffset(pe, names_rva))
    name_rvas = [read(pe.io, UInt32) for _ = 1:nnames]
    return [cstring(pe, r) for r in name_rvas]
end

"""
    pe_imports(path) -> Dict{String,Vector{String}}

The names the image imports, keyed by the DLL it imports them from. Imports by ordinal
carry no name and are left out.
"""
function pe_imports(path::AbstractString)
    pe = PEImage(path)
    imports = Dict{String,Vector{String}}()
    length(pe.datadirs) >= 2 || return imports
    rva, _ = pe.datadirs[2]
    rva == 0 && return imports
    base = fileoffset(pe, rva)
    width = pe.plus ? 8 : 4
    ordinal_bit = UInt64(1) << (8width - 1)
    for i = 0:typemax(Int)
        seek(pe.io, base + 20i)          # one IMAGE_IMPORT_DESCRIPTOR per DLL, zero-terminated
        lookup = read(pe.io, UInt32)
        skip(pe.io, 8)
        name = read(pe.io, UInt32)
        address = read(pe.io, UInt32)
        name == 0 && break
        names = String[]
        offset = fileoffset(pe, lookup == 0 ? address : lookup)
        while true
            seek(pe.io, offset)
            entry = pe.plus ? read(pe.io, UInt64) : UInt64(read(pe.io, UInt32))
            entry == 0 && break
            entry & ordinal_bit == 0 && push!(names, cstring(pe, (entry & ~ordinal_bit) + 2))  # past the hint
            offset += width
        end
        imports[cstring(pe, name)] = names
    end
    return imports
end

"""
    check_imports(lib, bindir=Sys.BINDIR)

Raise unless every name `lib` imports from a DLL that sits in `bindir` is one that DLL
exports, whatever the import libraries it was linked against promised. Julia opens `lib`
with `LOAD_WITH_ALTERED_SEARCH_PATH`, whose search order has no step for the program's own
directory; what makes the copies in `bindir` the ones bound is that the loader reuses a
module already loaded under the imported name, without searching, and julia has loaded its
own libgcc_s, libwinpthread, libstdc++ and libLLVM from `bindir` before any package loads
anything. A DLL in `bindir` that julia has not loaded is outside that: the loader searches
for it, and can bind a copy other than the one checked here.
"""
function check_imports(lib::AbstractString, bindir::AbstractString=Sys.BINDIR)
    shipped = Dict(lowercase(f) => joinpath(bindir, f) for f in readdir(bindir))
    for (dll, names) in pe_imports(lib)
        haskey(shipped, lowercase(dll)) || continue
        absent = setdiff(names, pe_exports(shipped[lowercase(dll)]))
        isempty(absent) || error("$(basename(lib)) imports from $dll what the copy in $bindir does not export: \
                                 $(join(sort(absent), ", ")). Loading it there would fail at those names.")
    end
    return nothing
end
