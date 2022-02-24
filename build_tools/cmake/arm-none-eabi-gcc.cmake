# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

cmake_minimum_required (VERSION 3.13.4)

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm CACHE STRING "" FORCE)

set(ARM_TOOLCHAIN_NAME gcc-arm-none-eabi)

set(ARM_TOOLCHAIN_ROOT "" CACHE PATH "ARM compiler path")
set(CMAKE_FIND_ROOT_PATH ${ARM_TOOLCHAIN_ROOT})
list(APPEND CMAKE_PREFIX_PATH "${ARM_TOOLCHAIN_ROOT}")

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_EXE_LINKER_FLAGS "-specs=nosys.specs" CACHE INTERNAL "")


set(CMAKE_C_COMPILER "${ARM_TOOLCHAIN_ROOT}/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${ARM_TOOLCHAIN_ROOT}/bin/arm-none-eabi-g++")
set(CMAKE_AR "${ARM_TOOLCHAIN_ROOT}/bin/arm-none-eabi-ar")
set(CMAKE_RANLIB "${ARM_TOOLCHAIN_ROOT}/bin/arm-none-eabi-ranlib")
set(CMAKE_STRIP "${ARM_TOOLCHAIN_ROOT}/bin/arm-none-eabi-strip")
set(CMAKE_SYSTEM_LIBRARY_PATH "${ARM_TOOLCHAIN_ROOT}/arm-none-eabi/usr/lib")

set(ARM_COMPILER_FLAGS)
set(ARM_COMPILER_FLAGS_CXX)
set(ARM_COMPILER_FLAGS_DEBUG)
set(ARM_COMPILER_FLAGS_RELEASE)

# Use the preprocessor on the generic linker script
string(TOUPPER "${ARM_TARGET}" ARM_TARGET)
if(ARM_TARGET STREQUAL "CORSTONE-300")
  set(PROCESSED_LINKER_SCRIPT "corstone-300-plattform.ld")
  add_custom_command(
    OUTPUT ${PROCESSED_LINKER_SCRIPT}
    COMMAND ${CMAKE_C_COMPILER} ARGS -E -P -x c -o ${PROCESSED_LINKER_SCRIPT} ${LINKER_SCRIPT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Preprocessing linker script"
  )
  #set(${LINKER_SCRIPT} ${PROCESSED_LINKER_SCRIPT})
endif()

set(ARM_LINKER_FLAGS "-lc -lm ${CUSTOM_ARM_LINKER_FLAGS} -T ${LINKER_SCRIPT}")
set(ARM_LINKER_FLAGS_EXE)

if(ARM_CPU STREQUAL "cortex-m4")
  list(APPEND ARM_COMPILER_FLAGS "-mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DIREE_TIME_NOW_FN=\"\{ return 0; \}\" -Wl,--gc-sections -ffunction-sections -fdata-sections")
elseif(ARM_CPU STREQUAL "cortex-m7" OR ARM_CPU STREQUAL "cortex-m7-sp")
  # Single-precision FPU
  list(APPEND ARM_COMPILER_FLAGS "-mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv5-sp-d16 -DIREE_TIME_NOW_FN=\"\{ return 0; \}\" -Wl,--gc-sections -ffunction-sections -fdata-sections")
elseif(ARM_CPU STREQUAL "cortex-m7-dp")
  # Single- and double-precision FPU
  list(APPEND ARM_COMPILER_FLAGS "-mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv5-d16 -DIREE_TIME_NOW_FN=\"\{ return 0; \}\" -Wl,--gc-sections -ffunction-sections -fdata-sections")
elseif(ARM_CPU STREQUAL "cortex-m55")
  list(APPEND ARM_COMPILER_FLAGS "-mthumb -march=armv8.1-m -mfloat-abi=hard -mfpu=auto -DIREE_TIME_NOW_FN=\"\{ return 0; \}\" -Wl,--gc-sections -ffunction-sections -fdata-sections")
endif()

set(CMAKE_C_FLAGS             "${ARM_COMPILER_FLAGS} ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS           "${ARM_COMPILER_FLAGS} ${ARM_COMPILER_FLAGS_CXX} ${CMAKE_CXX_FLAGS}")
set(CMAKE_ASM_FLAGS           "${ARM_COMPILER_FLAGS} ${CMAKE_ASM_FLAGS}")
set(CMAKE_C_FLAGS_DEBUG       "${ARM_COMPILER_FLAGS_DEBUG} ${CMAKE_C_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_DEBUG     "${ARM_COMPILER_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_ASM_FLAGS_DEBUG     "${ARM_COMPILER_FLAGS_DEBUG} ${CMAKE_ASM_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE     "${ARM_COMPILER_FLAGS_RELEASE} ${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_RELEASE   "${ARM_COMPILER_FLAGS_RELEASE} ${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_ASM_FLAGS_RELEASE   "${ARM_COMPILER_FLAGS_RELEASE} ${CMAKE_ASM_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS "${ARM_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS "${ARM_LINKER_FLAGS} ${CMAKE_MODULE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS    "${ARM_LINKER_FLAGS} ${ARM_LINKER_FLAGS_EXE} ${CMAKE_EXE_LINKER_FLAGS}")
