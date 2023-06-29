if(NOT (OSSIA_CI AND (UNIX AND NOT APPLE)))
  find_package(PortAudio QUIET)
  if(NOT PortAudio_FOUND)
    find_package(portaudio QUIET)
  endif()
endif()

if(NOT TARGET PortAudio::PortAudio)
  find_library(PORTAUDIO_LIBRARY NAMES libportaudio.so portaudio)
  find_path(PORTAUDIO_INCLUDE_DIR portaudio.h)

  if(PORTAUDIO_LIBRARY AND PORTAUDIO_INCLUDE_DIR)
    add_library(PortAudio IMPORTED INTERFACE GLOBAL)
    add_library(PortAudio::PortAudio ALIAS PortAudio)
    target_include_directories(PortAudio INTERFACE ${PORTAUDIO_INCLUDE_DIR})
    target_link_libraries(PortAudio INTERFACE ${PORTAUDIO_LIBRARY})
  endif()
endif()
