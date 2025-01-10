
set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")
cmake_minimum_required(VERSION 3.16)
project(rotation_ip C CXX)
set(CMAKE_CXX_COMPILER_LAUNCHER ccache)
set(PROJ_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS_DEBUG   "-O0 -g " )
set(CMAKE_CXX_FLAGS_RELEASE "-O2    ")

## Find Verilator
find_package(verilator REQUIRED)
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()
## SystemC dependencies
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
## Find SystemC using SystemC's CMake integration
find_package(SystemCLanguage QUIET)


## arguments be passed to verilator
set(VERILATOR_ARGS -Wno-STMTDLY -Wno-style -Wno-lint -Wno-TIMESCALEMOD --sc -O3 --coverage --timing --assert)
if(TRACE_FLAG)
  list(APPEND VERILATOR_ARGS --trace-fst)
endif(TRACE_FLAG)

add_executable(Vout color_mapping_3dlut_tb.cpp)
set_property(
  TARGET Vout
  PROPERTY CXX_STANDARD ${SystemC_CXX_STANDARD}
)

verilate(
  Vout SYSTEMC
  TOP_MODULE color_mapping_3dlut
  PREFIX Vcolor_mapping_3dlut
  INCLUDE_DIRS "../../" "../../frame_buffer_512"
  SOURCES  ../../color_mapping_3dlut.sv
  VERILATOR_ARGS ${VERILATOR_ARGS}
)

verilator_link_systemc(Vout)
