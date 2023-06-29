if(OSSIA_SUBMODULE_AUTOUPDATE)
  message(STATUS "Update general libossia dependencies :")
  set(OSSIA_SUBMODULES
      concurrentqueue
      compile-time-regular-expressions
      Flicks
      fmt
      mdspan
      nano-signal-slot
      rapidfuzz-cpp
      rapidjson
      readerwriterqueue
      re2
      rnd
      Servus
      SmallFunction
      span
      spdlog
      unordered_dense
      verdigris
      weakjack
      websocketpp
      whereami
      ../cmake/cmake-modules
      ios-cmake
  )

  if(OSSIA_DATAFLOW)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} exprtk dr_libs rubberband libsamplerate kfr)
  endif()

  if(OSSIA_DNSSD)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} Servus)
  endif()

  if(OSSIA_PROTOCOL_MIDI)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} libremidi)
  endif()

  if (OSSIA_PROTOCOL_OSC OR OSSIA_PROTOCOL_MINUIT OR OSSIA_PROTOCOL_OSCQUERY)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} oscpack)
  endif()

  if(OSSIA_PROTOCOL_ARTNET)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} libartnet)
  endif()

  if(OSSIA_PROTOCOL_WIIMOTE)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} wiiuse)
  endif()

  if(OSSIA_TESTING)
    set(OSSIA_SUBMODULES ${OSSIA_SUBMODULES} Catch2)
  endif()

  execute_process(COMMAND git submodule sync --recursive
                  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

  foreach(submodule ${OSSIA_SUBMODULES})
      message(" -> ${OSSIA_3RDPARTY_FOLDER}/${submodule}")
      execute_process(COMMAND git submodule update --init --recursive -- ${OSSIA_3RDPARTY_FOLDER}/${submodule}
                      WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
  endforeach()

  message(STATUS "...done")
  set(OSSIA_SUBMODULE_AUTOUPDATE OFF CACHE BOOL "Auto update submodule" FORCE)
endif()

# Download various dependencies
set(BOOST_MINOR_MINIMAL 81)
set(BOOST_MINOR_LATEST 82)

find_package(Boost 1.${BOOST_MINOR_MINIMAL} QUIET GLOBAL)

if (NOT Boost_FOUND)
  set(OSSIA_MUST_INSTALL_BOOST 1 CACHE INTERNAL "")
  set(BOOST_VERSION "boost_1_${BOOST_MINOR_LATEST}_0" CACHE INTERNAL "")

  if(NOT EXISTS "${OSSIA_3RDPARTY_FOLDER}/${BOOST_VERSION}/")
    message(STATUS "Downloading boost to ${OSSIA_3RDPARTY_FOLDER}/${BOOST_VERSION}.tar.gz")
    set(BOOST_URL https://github.com/ossia/sdk/releases/download/sdk28/${BOOST_VERSION}.tar.gz)
    set(BOOST_ARCHIVE ${BOOST_VERSION}.tar.gz)

    file(DOWNLOAD "${BOOST_URL}" "${OSSIA_3RDPARTY_FOLDER}/${BOOST_ARCHIVE}")

    execute_process(
      COMMAND "${CMAKE_COMMAND}" -E tar xzf "${BOOST_ARCHIVE}"
      WORKING_DIRECTORY "${OSSIA_3RDPARTY_FOLDER}"
    )
  endif()
  set(BOOST_ROOT "${OSSIA_3RDPARTY_FOLDER}/${BOOST_VERSION}" CACHE INTERNAL "")
  set(Boost_INCLUDE_DIR "${BOOST_ROOT}")
  find_package(Boost 1.${BOOST_MINOR_LATEST} REQUIRED GLOBAL)
endif()

add_library(boost INTERFACE IMPORTED)
set_property(TARGET boost PROPERTY
             INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIR}")

if(OSSIA_USE_SYSTEM_LIBRARIES)
  find_package(ctre 3.7 CONFIG GLOBAL)
  find_package(rapidfuzz CONFIG REQUIRED GLOBAL)
  find_package(RapidJSON 1.2 CONFIG GLOBAL)

  find_package(fmt 10 CONFIG GLOBAL)
  if(TARGET fmt::fmt)
    find_package(spdlog CONFIG REQUIRED GLOBAL)
  endif()

  # Re2
  find_library(RE2_LIBRARY NAMES re2)
  find_path(RE2_INCLUDE_DIR re2/re2.h)

  if(NOT RE2_LIBRARY OR NOT RE2_INCLUDE_DIR)
    message(FATAL_ERROR "re2 is required")
  endif()
  add_library(re2 INTERFACE IMPORTED)
  target_include_directories(re2 INTERFACE ${RE2_INCLUDE_DIR})
  target_link_libraries(re2 INTERFACE ${RE2_LIBRARY})

  # KFR
  if(OSSIA_ENABLE_KFR)
    find_library(KFR_LIBRARY NAMES kfr_dft)
    find_path(KFR_INCLUDE_DIR kfr/version.hpp)

    if(KFR_LIBRARY AND KFR_INCLUDE_DIR)
      add_library(kfr INTERFACE IMPORTED)
      add_library(kfr_dft ALIAS kfr)
      target_include_directories(kfr INTERFACE ${KFR_INCLUDE_DIR})
      target_link_libraries(kfr INTERFACE ${KFR_LIBRARY})
    endif()
  endif()

  # ExprTK
  find_path(EXPRTK_INCLUDE_DIR exprtk.hpp)
else()
  include(re2)
endif()

if(OSSIA_ENABLE_KFR)
  if(NOT TARGET kfr)
    add_subdirectory("${OSSIA_3RDPARTY_FOLDER}/kfr" "${CMAKE_CURRENT_BINARY_DIR}/kfr_build")
  endif()
endif()

if(NOT TARGET ctre::ctre)
  add_library(ctre INTERFACE IMPORTED)
  add_library(ctre::ctre ALIAS ctre)
  target_include_directories(ctre INTERFACE "$<BUILD_INTERFACE:${OSSIA_3RDPARTY_FOLDER}/compile-time-regular-expressions/include>")
endif()

if(NOT TARGET fmt::fmt)
  if(NOT TARGET fmt)
    add_definitions(-DFMT_HEADER_ONLY=1)
  endif()
endif()

if(NOT TARGET rapidfuzz::rapidfuzz)
  add_library(rapidfuzz INTERFACE IMPORTED)
  add_library(rapidfuzz::rapidfuzz ALIAS rapidfuzz)
  target_include_directories(rapidfuzz INTERFACE "${OSSIA_3RDPARTY_FOLDER}/rapidfuzz-cpp")
endif()

if(NOT EXPRTK_INCLUDE_DIR)
  set(EXPRTK_INCLUDE_DIR "${OSSIA_3RDPARTY_FOLDER}/exprtk")
endif()

if(OSSIA_PROTOCOL_MIDI)
  set(LIBREMIDI_EXAMPLES OFF CACHE "" INTERNAL)
  set(LIBREMIDI_TESTS OFF CACHE "" INTERNAL)
  if(EMSCRIPTEN)
    set(LIBREMIDI_HEADER_ONLY ON CACHE "" INTERNAL)
  else()
    set(LIBREMIDI_HEADER_ONLY OFF CACHE "" INTERNAL)
  endif()
  set(WEAKJACK_FOLDER "${OSSIA_3RDPARTY_FOLDER}")
  add_subdirectory("${OSSIA_3RDPARTY_FOLDER}/libremidi" EXCLUDE_FROM_ALL)
endif()

if(OSSIA_DATAFLOW)
  if(OSSIA_USE_SYSTEM_LIBRARIES)
    find_package(SampleRate CONFIG REQUIRED GLOBAL)

    # RubberBand
    find_library(RUBBERBAND_LIBRARY NAMES rubberband)
    find_path(RUBBERBAND_INCLUDE_DIR rubberband/RubberBandStretcher.h)

    if(RUBBERBAND_LIBRARY AND RUBBERBAND_INCLUDE_DIR)
      add_library(rubberband INTERFACE)
      target_include_directories(rubberband INTERFACE ${RUBBERBAND_INCLUDE_DIR})
      target_link_libraries(rubberband INTERFACE ${RUBBERBAND_LIBRARY})
    endif()
  else()
    set(_oldmode ${BUILD_SHARED_LIBS})
    set(BUILD_SHARED_LIBS 0)
    add_subdirectory("${OSSIA_3RDPARTY_FOLDER}/libsamplerate" EXCLUDE_FROM_ALL)
    add_subdirectory("${OSSIA_3RDPARTY_FOLDER}/rubberband" EXCLUDE_FROM_ALL)
    set(BUILD_SHARED_LIBS ${_oldmode})
  endif()
endif()

if(OSSIA_PROTOCOL_OSC OR OSSIA_PROTOCOL_MINUIT OR OSSIA_PROTOCOL_OSCQUERY)
  add_subdirectory(3rdparty/oscpack EXCLUDE_FROM_ALL)
endif()

if(OSSIA_DNSSD)
  add_subdirectory(3rdparty/Servus EXCLUDE_FROM_ALL)
endif()

if(OSSIA_PROTOCOL_WIIMOTE)
  if(OSSIA_USE_SYSTEM_LIBRARIES)
    find_library(WIIUSE_LIBRARY NAMES wiiuse)
    find_path(WIIUSE_INCLUDE_DIR wiiuse.h)

    if(WIIUSE_LIBRARY AND WIIUSE_INCLUDE_DIR)
      add_library(wiiuse INTERFACE)
      target_include_directories(wiiuse INTERFACE ${WIIUSE_INCLUDE_DIR})
      target_link_libraries(wiiuse INTERFACE ${WIIUSE_LIBRARY})
    endif()
  else()
    set(WIIUSE_INSTALL_RULES "${OSSIA_INSTALL_STATIC_DEPENDENCIES}" CACHE INTERNAL "" FORCE)
    set(WIIUSE_DIR "${OSSIA_3RDPARTY_FOLDER}/wiiuse")
    add_subdirectory("${WIIUSE_DIR}" wiiuse)
  endif()

  if(NOT TARGET wiiuse)
    set(OSSIA_PROTOCOL_WIIMOTE FALSE CACHE INTERNAL "" FORCE)
  endif()
endif()

if(OSSIA_PROTOCOL_LIBMAPPER)
  find_package(Libmapper REQUIRED)
endif()

if(NOT (OSSIA_CI AND (UNIX AND NOT APPLE)))
  find_package(PortAudio QUIET)
  if(NOT PortAudio_FOUND)
    find_package(portaudio QUIET)
  endif()
endif()


if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  add_definitions(-D_SCL_SECURE_NO_WARNINGS)
endif()


