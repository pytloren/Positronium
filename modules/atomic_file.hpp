#pragma once

#include <filesystem>
#include <system_error>

#ifdef _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>
#endif

namespace positronium::file_operations {

// Replace a file without removing the old destination first. On Windows both
// paths are in the same directory, so MoveFileEx performs the replacement on
// the same volume; POSIX rename already has replacement semantics.
inline void atomicReplaceFile(const std::filesystem::path& source,
                              const std::filesystem::path& destination,
                              std::error_code& error) noexcept {
#ifdef _WIN32
    if (::MoveFileExW(source.c_str(), destination.c_str(),
                      MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH)) {
        error.clear();
        return;
    }
    error = std::error_code(static_cast<int>(::GetLastError()),
                            std::system_category());
#else
    std::filesystem::rename(source, destination, error);
#endif
}

} // namespace positronium::file_operations
