
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#-------------------------------------------------------------------------------
# VMVX sample, float
#-------------------------------------------------------------------------------

if(IREE_HAL_EXECUTABLE_LOADER_VMVX_MODULE)

  add_executable(mobilenet_vmvx_sync "")

  target_sources(mobilenet_vmvx_sync
    PRIVATE
      mobilenet_float.c
      device_vmvx_sync.c
  )

  set(_COMPILE_ARGS)
  list(APPEND _COMPILE_ARGS "--iree-input-type=mhlo")
  list(APPEND _COMPILE_ARGS "--iree-mlir-to-vm-bytecode-module")
  list(APPEND _COMPILE_ARGS "--iree-hal-target-backends=vmvx")
  list(APPEND _COMPILE_ARGS "${CMAKE_CURRENT_SOURCE_DIR}/model_fix_name.mlir")
  list(APPEND _COMPILE_ARGS "-o")
  list(APPEND _COMPILE_ARGS "model_fix_name_bytecode_module_vmvx.vmfb")

  add_custom_command(
    OUTPUT "model_fix_name_bytecode_module_vmvx.vmfb"
    COMMAND ${_COMPILE_TOOL_EXECUTABLE} ${_COMPILE_ARGS}
  )

  set(_GEN_EMBED_ARGS)
  list(APPEND _GEN_EMBED_ARGS "--output_header=model_fix_name_bytecode_module_vmvx_c.h")
  list(APPEND _GEN_EMBED_ARGS "--output_impl=model_fix_name_bytecode_module_vmvx_c.c")
  list(APPEND _GEN_EMBED_ARGS "--identifier=iree_samples_model_fix_name_module_vmvx")
  list(APPEND _GEN_EMBED_ARGS "--flatten")
  list(APPEND _GEN_EMBED_ARGS "model_fix_name_bytecode_module_vmvx.vmfb")

  add_custom_command(
    OUTPUT
      "model_fix_name_bytecode_module_vmvx_c.h"
      "model_fix_name_bytecode_module_vmvx_c.c"
    COMMAND generate_embed_data ${_GEN_EMBED_ARGS}
    DEPENDS generate_embed_data model_fix_name_bytecode_module_vmvx.vmfb
  )

  add_library(model_fix_name_bytecode_module_vmvx STATIC "")
  target_sources(model_fix_name_bytecode_module_vmvx
    PRIVATE
      model_fix_name_bytecode_module_vmvx_c.c
      model_fix_name_bytecode_module_vmvx_c.h
  )

  set_target_properties(mobilenet_vmvx_sync PROPERTIES OUTPUT_NAME mobilenet_vmvx_sync)

  target_include_directories(mobilenet_vmvx_sync
    PRIVATE
      ${CMAKE_CURRENT_BINARY_DIR}
  )

  target_link_libraries(mobilenet_vmvx_sync
    PRIVATE
      model_fix_name_bytecode_module_vmvx
      iree::base
      iree::hal
      iree::hal::drivers::local_sync::sync_driver
      iree::hal::local
      iree::hal::local::loaders::vmvx_module_loader
      iree::modules::hal
      iree::vm
      iree::vm::bytecode_module
      ${CONDITIONAL_DEP}
      utils
  )

  add_binary(mobilenet_vmvx_sync)
  add_ihex(mobilenet_vmvx_sync)

  add_executable(int_mobilenet_vmvx_sync "")

  target_sources(int_mobilenet_vmvx_sync
    PRIVATE
      mobilenet_int.c
      device_int_vmvx_sync.c
  )

  set(_COMPILE_ARGS)
  list(APPEND _COMPILE_ARGS "--iree-input-type=tosa")
  list(APPEND _COMPILE_ARGS "--iree-mlir-to-vm-bytecode-module")
  list(APPEND _COMPILE_ARGS "--iree-hal-target-backends=vmvx")
  list(APPEND _COMPILE_ARGS "${CMAKE_CURRENT_SOURCE_DIR}/model_tosa_fix_name.mlir")
  list(APPEND _COMPILE_ARGS "-o")
  list(APPEND _COMPILE_ARGS "model_tosa_fix_name_bytecode_module_vmvx.vmfb")

  add_custom_command(
    OUTPUT "model_tosa_fix_name_bytecode_module_vmvx.vmfb"
    COMMAND ${_COMPILE_TOOL_EXECUTABLE} ${_COMPILE_ARGS}
  )

  set(_GEN_EMBED_ARGS)
  list(APPEND _GEN_EMBED_ARGS "--output_header=model_tosa_fix_name_bytecode_module_vmvx_c.h")
  list(APPEND _GEN_EMBED_ARGS "--output_impl=model_tosa_fix_name_bytecode_module_vmvx_c.c")
  list(APPEND _GEN_EMBED_ARGS "--identifier=iree_samples_model_tosa_fix_name_module_vmvx")
  list(APPEND _GEN_EMBED_ARGS "--flatten")
  list(APPEND _GEN_EMBED_ARGS "model_tosa_fix_name_bytecode_module_vmvx.vmfb")

  add_custom_command(
    OUTPUT
      "model_tosa_fix_name_bytecode_module_vmvx_c.h"
      "model_tosa_fix_name_bytecode_module_vmvx_c.c"
    COMMAND generate_embed_data ${_GEN_EMBED_ARGS}
    DEPENDS generate_embed_data model_tosa_fix_name_bytecode_module_vmvx.vmfb
  )

  add_library(model_tosa_fix_name_bytecode_module_vmvx STATIC "")
  target_sources(model_tosa_fix_name_bytecode_module_vmvx
    PRIVATE
      model_tosa_fix_name_bytecode_module_vmvx_c.c
      model_tosa_fix_name_bytecode_module_vmvx_c.h
  )

  set_target_properties(int_mobilenet_vmvx_sync PROPERTIES OUTPUT_NAME int_mobilenet_vmvx_sync)

  target_include_directories(int_mobilenet_vmvx_sync
    PRIVATE
      ${CMAKE_CURRENT_BINARY_DIR}
  )

  target_link_libraries(int_mobilenet_vmvx_sync
    PRIVATE
      model_tosa_fix_name_bytecode_module_vmvx
      iree::base
      iree::hal
      iree::hal::drivers::local_sync::sync_driver
      iree::hal::local
      iree::hal::local::loaders::vmvx_module_loader
      iree::modules::hal
      iree::vm
      iree::vm::bytecode_module
      ${CONDITIONAL_DEP}
      utils
  )

  add_binary(int_mobilenet_vmvx_sync)
  add_ihex(int_mobilenet_vmvx_sync)

endif()
