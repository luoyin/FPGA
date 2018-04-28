/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LRR = 258,
     LRM = 259,
     LMR = 260,
     LRI = 261,
     LMI = 262,
     INR = 263,
     DCR = 264,
     ADR = 265,
     ADM = 266,
     ADI = 267,
     ACR = 268,
     ACM = 269,
     ACI = 270,
     SUR = 271,
     SUM = 272,
     SUI = 273,
     SBR = 274,
     SBM = 275,
     SBI = 276,
     NDR = 277,
     NDM = 278,
     NDI = 279,
     XRR = 280,
     XRM = 281,
     XRI = 282,
     ORR = 283,
     ORM = 284,
     ORI = 285,
     CPR = 286,
     CPM = 287,
     CPI = 288,
     RLC = 289,
     RRC = 290,
     RAL = 291,
     RAR = 292,
     JMP = 293,
     JFC = 294,
     JTC = 295,
     CAL = 296,
     CFC = 297,
     CTC = 298,
     RET = 299,
     RFC = 300,
     RTC = 301,
     RST = 302,
     INP = 303,
     OUT = 304,
     NOP = 305,
     HLT = 306,
     IMM = 307,
     REF = 308,
     EOL = 309,
     LABEL = 310,
     DEFINE = 311,
     ORG = 312,
     GLOBAL = 313,
     COMMENT = 314
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2058 of yacc.c  */
#line 5 "/disk1/projects/FPGA.github/MCS8/compiler/parser.y"

	uint8_t opcode;
	char *strRef;
	uint16_t imm;
	s_ins *pIns;
	s_ref *pRef;


/* Line 2058 of yacc.c  */
#line 125 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
