# Toolchain file for GNU Arm Embedded (arm-none-eabi-gcc), Cortex-M4F
set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(TOOLCHAIN_PREFIX arm-none-eabi-)
set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}objcopy CACHE FILEPATH "")
set(CMAKE_SIZE         ${TOOLCHAIN_PREFIX}size    CACHE FILEPATH "")

# Can't run/link test executables for a bare-metal target
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# STM32F401: Cortex-M4 with single-precision FPU
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

set(CMAKE_C_FLAGS_INIT   "${MCU_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${MCU_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT "${MCU_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${MCU_FLAGS} --specs=nano.specs --specs=nosys.specs")

set(CMAKE_C_FLAGS_DEBUG_INIT            "-Og -g3")
set(CMAKE_C_FLAGS_RELEASE_INIT          "-Os -g -DNDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-Os -g -DNDEBUG")
set(CMAKE_ASM_FLAGS_DEBUG_INIT          "-g3")
set(CMAKE_ASM_FLAGS_RELEASE_INIT        "-g")

# Search headers/libs only in the target environment, programs on the host
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
