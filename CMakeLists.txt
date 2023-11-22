cmake_minimum_required(VERSION 3.15)
project(lcm-example
    VERSION
        1.0
    DESCRIPTION
        "An LCM project example"
    LANGUAGES
        CXX
)

find_package(lcm REQUIRED)
include(${LCM_USE_FILE})

# Add python bindings
find_package(PythonInterp)
find_package(Java)

if(PYTHONINTERP_FOUND)
  set(python_args PYTHON_SOURCES python_install_sources)
endif()

if(JAVA_FOUND)
  set(java_args JAVA_SOURCES java_sources)
endif()


# Put all message definition files in the type directory in one list
FILE(GLOB glob_message_definitions "msg/*.lcm")

MESSAGE(${CMAKE_CURRENT_LIST_DIR})

# Generate headers from message definition
lcm_wrap_types(
  C_EXPORT lcm_example_type
  C_SOURCES c_sources
  C_HEADERS c_headers
  CPP_HEADERS cpp_headers
  ${python_args}
  ${java_args}
  ${glob_message_definitions}
)

# Create library from all the messages
lcm_add_library(lcm_example_type-cpp CPP ${cpp_headers})
target_include_directories(lcm_example_type-cpp INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

# Create executables for the two example programs, linking all of them to our
# messages library and lcm
add_executable(lcm_example_publisher src/lcm_example_publisher.cpp)
lcm_target_link_libraries(lcm_example_publisher lcm_example_type-cpp ${LCM_NAMESPACE}lcm)

add_executable(lcm_example_subscriber src/lcm_example_subscriber.cpp)
lcm_target_link_libraries(lcm_example_subscriber lcm_example_type-cpp ${LCM_NAMESPACE}lcm)