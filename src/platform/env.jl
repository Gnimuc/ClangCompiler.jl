const JLL_ENV_TRIPLES = String[
    "aarch64-apple-darwin20",
    "aarch64-linux-gnu",           # Tier 1
    "aarch64-linux-musl",
    "armv7l-linux-gnueabihf",
    "armv7l-linux-musleabihf",
    "i686-linux-gnu",              # Tier 1
    "i686-linux-musl",
    "i686-w64-mingw32",            # Tier 2
    "powerpc64le-linux-gnu",
    "x86_64-apple-darwin14",       # Tier 1
    "x86_64-linux-gnu",            # Tier 1
    "x86_64-linux-musl",
    "x86_64-unknown-freebsd",      # Tier 1
    "x86_64-w64-mingw32",          # Tier 1
]

const HOST_TRIPLE = "x86_64-linux-musl"
const GCC_SHARD_NAME = "GCCBootstrap"
const SYSTEM_SHARD_NAME = "PlatformSupport"

const JLL_ENV_PLATFORMS = [
    Platform("aarch64", "macos"),
    Platform("aarch64", "linux"),                # Tier 1
    Platform("x86_64", "linux"; libc="musl"),
    Platform("armv7l", "linux"),
    Platform("armv7l", "linux"; libc="musl"),
    Platform("i686", "linux"),                   # Tier 1
    Platform("i686", "linux"; libc="musl"),
    Platform("i686", "windows"),                 # Tier 2
    Platform("powerpc64le", "linux"),
    Platform("x86_64", "macos"),                 # Tier 1
    Platform("x86_64", "linux"),                 # Tier 1
    Platform("x86_64", "linux"; libc="musl"),
    Platform("x86_64", "freebsd"),
    Platform("x86_64", "windows"),               # Tier 1
]

get_gcc_shard_key(p::Platform, version::VersionNumber=GCC_MIN_VER) = "$GCC_SHARD_NAME-$(__triplet(p)).v$version.$HOST_TRIPLE.unpacked"
get_gcc_shard_key(triple::String, version::VersionNumber=GCC_MIN_VER) = get_gcc_shard_key(parse(Platform, triple), version)

function get_system_shard_key(p::Platform)
    platform_keys = filter(collect(keys(SHARDS))) do key
        startswith(key, "$SYSTEM_SHARD_NAME-$(__triplet(p)).") &&
        endswith(key, "$HOST_TRIPLE.unpacked")
    end
    return platform_keys[]
end
get_system_shard_key(triple::String) = get_system_shard_key(parse(Platform, triple))

function get_environment_info(p::Platform, version::VersionNumber=GCC_MIN_VER)
    gcc = SHARDS[get_gcc_shard_key(p, version)][]
    sys = SHARDS[get_system_shard_key(p)][]
    gcc_download = gcc["download"][]
    sys_download = sys["download"][]
    info = [
        (id=gcc["git-tree-sha1"], url=gcc_download["url"], chk=gcc_download["sha256"]),
        (id=sys["git-tree-sha1"], url=sys_download["url"], chk=sys_download["sha256"]),
    ]
    return info
end
get_environment_info(triple::String, version::VersionNumber=GCC_MIN_VER) = get_environment_info(parse(Platform, triple), version)
