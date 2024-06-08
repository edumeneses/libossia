if(OSSIA_USE_SYSTEM_LIBRARIES)
    find_path(LIBCOAP_INCLUDEDIR coap3/libcoap.h)
    find_library(LIBCOAP_GNUTLS_LIBRARIES coap-3-gnutls)
    find_library(LIBCOAP_LIBRARIES coap-3)

    if(LIBCOAP_INCLUDEDIR AND (LIBCOAP_LIBRARIES OR LIBCOAP_GNUTLS_LIBRARIES))
        add_library(coap-3 IMPORTED SHARED GLOBAL)
        add_library(libcoap::coap-3 ALIAS coap-3)
        target_include_directories(coap-3 INTERFACE "${LIBCOAP_INCLUDEDIR}")
        if(LIBCOAP_GNUTLS_LIBRARIES)
          set_target_properties(coap-3 PROPERTIES IMPORTED_LOCATION "${LIBCOAP_GNUTLS_LIBRARIES}")
          target_link_libraries(coap-3 INTERFACE gnutls)
        else()
          set_target_properties(coap-3 PROPERTIES IMPORTED_LOCATION "${LIBCOAP_LIBRARIES}")
        endif()
    endif()
endif()

if(NOT TARGET libcoap::coap-3)
    include(FetchContent)
    FetchContent_Declare(
      libcoap
      GIT_REPOSITORY "https://github.com/obgm/libcoap"
      GIT_TAG develop
      GIT_PROGRESS true
    )

    set(_oldmode ${BUILD_SHARED_LIBS})
    set(BUILD_SHARED_LIBS OFF)

    set(ENABLE_DTLS OFF)
    set(ENABLE_DTLS OFF CACHE INTERNAL "")
    set(ENABLE_EXAMPLES OFF)
    set(ENABLE_EXAMPLES OFF CACHE INTERNAL "")
    set(ENABLE_DOCS OFF)
    set(ENABLE_DOCS OFF CACHE INTERNAL "")
    set(ENABLE_OSCORE OFF)
    set(ENABLE_OSCORE OFF CACHE INTERNAL "")
    set(ENABLE_SERVER_MODE OFF)
    set(ENABLE_SERVER_MODE OFF CACHE INTERNAL "")
    set(MAX_LOGGING_LEVEL "0")
    set(MAX_LOGGING_LEVEL "0" CACHE INTERNAL "")
    FetchContent_MakeAvailable(libcoap)

    set(BUILD_SHARED_LIBS ${_oldmode})
endif()

