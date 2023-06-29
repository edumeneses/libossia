find_path(FFTW3_INCLUDEDIR fftw3.h)
if(FFTW3_INCLUDEDIR)
  find_library(FFTW3_LIBRARY fftw3)
  find_library(FFTW3F_LIBRARY fftw3f)
  if(FFTW3_LIBRARY)
    set(OSSIA_FFT FFTW_DOUBLE CACHE INTERNAL "")
    set(OSSIA_FFT_FFTW 1 CACHE INTERNAL "")
    set(OSSIA_FFTW_DOUBLE_ONLY 1 CACHE INTERNAL "")

    add_library(fftw3 INTERFACE IMPORTED GLOBAL)
    add_library(fftw::fftw3 ALIAS fftw3)
    target_include_directories(fftw3 INTERFACE $<BUILD_INTERFACE:${FFTW3_INCLUDEDIR}>)
    target_link_libraries(fftw3 INTERFACE $<BUILD_INTERFACE:${FFTW3_LIBRARY}>)
  elseif(FFTW3F_LIBRARY)
    set(OSSIA_FFT FFTW_SINGLE CACHE INTERNAL "")
    set(OSSIA_FFT_FFTW 1 CACHE INTERNAL "")
    set(OSSIA_FFTW_SINGLE_ONLY 1 CACHE INTERNAL "")

    add_library(fftw3 INTERFACE IMPORTED GLOBAL)
    add_library(fftw::fftw3 ALIAS fftw3)
    target_include_directories(fftw3 INTERFACE $<BUILD_INTERFACE:${FFTW3_INCLUDEDIR}>)
    target_link_libraries(fftw3 INTERFACE $<BUILD_INTERFACE:${FFTW3F_LIBRARY}>)
  endif()
endif()
