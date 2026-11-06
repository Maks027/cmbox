cmake_minimum_required(VERSION 3.22)

project(cmbox C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)          # gnu11 (needed for __asm etc.)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------------- CMSIS -----
set(CMSIS_CORE   ${CMAKE_SOURCE_DIR}/third_party/CMSIS_6/CMSIS/Core)
set(CMSIS_DEVICE ${CMAKE_SOURCE_DIR}/third_party/cmsis-device-f4)

if(NOT EXISTS ${CMSIS_DEVICE}/Include/stm32f4xx.h OR NOT EXISTS ${CMSIS_CORE}/Include/core_cm4.h)
    message(FATAL_ERROR "CMSIS not found. Run: git submodule update --init --depth 1")
endif()

set(CMSIS_SOURCES
    ${CMSIS_DEVICE}/Source/Templates/system_stm32f4xx.c
    ${CMSIS_DEVICE}/Source/Templates/gcc/startup_stm32f401xc.s
)
# Vendor code: don't drown our own warnings in theirs
set_source_files_properties(${CMSIS_SOURCES} PROPERTIES COMPILE_OPTIONS "-w")

# ----------------------------------------------------------- firmware -----
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/linker/STM32F401CCUx_FLASH.ld)

add_executable(${PROJECT_NAME}
    src/main.c
    src/syscalls.c
    ${CMSIS_SOURCES}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    SUFFIX ".elf"
    LINK_DEPENDS ${LINKER_SCRIPT}
)

target_compile_definitions(${PROJECT_NAME} PRIVATE STM32F401xC)

target_include_directories(${PROJECT_NAME} PRIVATE src)
target_include_directories(${PROJECT_NAME} SYSTEM PRIVATE
    ${CMSIS_DEVICE}/Include
    ${CMSIS_CORE}/Include
)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall -Wextra -Wshadow
    -ffunction-sections -fdata-sections
)

target_link_options(${PROJECT_NAME} PRIVATE
    -T${LINKER_SCRIPT}
    -Wl,--gc-sections
    -Wl,-Map=$<TARGET_FILE_DIR:${PROJECT_NAME}>/${PROJECT_NAME}.map,--cref
    -Wl,--print-memory-usage
    -Wl,--no-warn-rwx-segments
)

# .hex / .bin + size report after every build
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJECT_NAME}>
    VERBATIM
)

# ------------------------------------------------------------- flash ------
find_program(OPENOCD openocd)
if(OPENOCD)
    add_custom_target(flash
        COMMAND ${OPENOCD} -f ${CMAKE_SOURCE_DIR}/openocd.cfg
                -c "program $<TARGET_FILE:${PROJECT_NAME}> verify reset exit"
        DEPENDS ${PROJECT_NAME}
        USES_TERMINAL
        VERBATIM
    )
endif()
