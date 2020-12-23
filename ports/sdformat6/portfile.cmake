vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO osrf/sdformat
    REF c6748a3de64d548e95f1690720904e06afc935ef
    SHA512 7558d6ac6daa3cb0ff08bffcee1e014f8a08f8416ffba3125e229f9a2421b137761da418b308cff12d490feb25cd8effe7c9c6e72df8ccee3227317249b305bd
    HEAD_REF sdf6
)

# Ruby is required by the sdformat build process
vcpkg_find_acquire_program(RUBY)
get_filename_component(RUBY_PATH ${RUBY} DIRECTORY)
set(_path $ENV{PATH})
vcpkg_add_to_path(${RUBY_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_TESTING=OFF
            -DUSE_EXTERNAL_URDF=ON
            -DUSE_EXTERNAL_TINYXML=ON
)

vcpkg_install_cmake()

# Restore original path
set(ENV{PATH} ${_path})

# Move location of sdformat.dll from lib to bin
if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/sdformat.dll)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/sdformat.dll
                ${CURRENT_PACKAGES_DIR}/bin/sdformat.dll)
endif()

if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/lib/sdformat.dll)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/sdformat.dll
                ${CURRENT_PACKAGES_DIR}/debug/bin/sdformat.dll)
endif()

# Fix cmake targets location
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/sdformat")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/lib/cmake
                    ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
