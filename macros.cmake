cmake_minimum_required(VERSION 2.8)

macro(setup_source_groups src_files)
    foreach(FILE ${src_files}) 
        get_filename_component(PARENT_DIR "${FILE}" PATH)

        # skip src or include and changes /'s to \\'s
        string(REGEX REPLACE "(\\./)?(src|include)/?" "" GROUP "${PARENT_DIR}")
        string(REPLACE "/" "\\" GROUP "${GROUP}")

        # group into "Source Files" and "Header Files"
        if (${FILE} MATCHES ".*/.+[.]cpp")
            set(GROUP "Source Files\\\\${GROUP}")
        elseif(${FILE} MATCHES ".*/.+[.]hpp")
            set(GROUP "Header Files\\\\${GROUP}")
        endif()

        source_group("${GROUP}" FILES "${FILE}")
    endforeach()
endmacro()