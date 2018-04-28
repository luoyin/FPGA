cmake_minimum_required(VERSION 2.6)

include_directories(. ${CMAKE_CURRENT_BINARY_DIR})

set(PARSER_DIR ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(
	GenSource_parser_as8008
	DEPENDS ${GEN_SOURCES}
)

set(GEN_SOURCES
	${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
	${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h
	${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
)

set_source_files_properties(${GEN_SOURCES} GENERATED)

add_custom_command(
	SOURCE ${PARSER_DIR}/parser.y
	COMMAND bison -d ${PARSER_DIR}/parser.y
	TARGET GenSource_parser_as8008
	OUTPUTS ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h
	WORKING_DIRECTORY ${PARSER_DIR}
)

add_custom_command(
	SOURCE ${PARSER_DIR}/parser.l
	COMMAND flex ${PARSER_DIR}/parser.l
	TARGET GenSource_parser_as8008
	OUTPUTS ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
	WORKING_DIRECTORY ${PARSER_DIR}
)

add_executable(as8008
	${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
	${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
	parser.c
	as8008.c
)

add_dependencies(as8008
	GenSource_parser_as8008
)

target_link_libraries(as8008
	-lfl
)

install(TARGETS as8008 RUNTIME DESTINATION bin)