
vcpkg_download_distfile(ARCHIVE
    URLS "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
    FILENAME "SDL_image-1.2.12.tar.gz"
    SHA512 0e71b280abc2a7f15755e4480a3c1b52d41f9f8b0c9216a6f5bd9fc0e939456fb5d6c10419e1d1904785783f9a1891ead278c03e88b0466fecc6871c3ca40136
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
)

file(MAKE_DIRECTORY ${SOURCE_PATH}/cmake_modules)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/cmake_modules/FindWebP.cmake DESTINATION ${SOURCE_PATH}/cmake_modules)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# # Moves all .cmake files from /debug/share/sdl1-image/ to /share/sdl1-image/
# # See /docs/maintainers/vcpkg_fixup_cmake_targets.md for more details
# vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/sdl1-image)

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/sdl1-image RENAME copyright)

# # Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME sdl1-image)
