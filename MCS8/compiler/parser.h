#ifndef __PARSER_H__
#define __PARSER_H__

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <malloc.h>
#include "as8008.h"

extern int yylineno;
extern FILE *yyin;
void yyerror(char *s, ...);

uint8_t SolveReg(char c);
uint8_t SolveCondCode(char c);

unsigned int SolveIMM_Hex(char *s);
unsigned int SolveIMM_Bin(char *s);

s_ref *GenRef_Label(char *strRef);
s_ref *GenRef_Define(char *strRef, unsigned short imm);
s_ref *GenRef_Global(char *strRef);
s_ins *GenIns_Opcode0(uint8_t opcode);
s_ins *GenIns_Imm(uint8_t opcode, uint16_t imm);
s_ins *GenIns_Imm_Ref(uint8_t opcode, char *strRef);
s_ins *GenIns_Addr(uint8_t opcode, uint16_t imm);
s_ins *GenIns_Addr_Ref(uint8_t opcode, char *strRef);
s_ins *GenIns_RST(uint8_t opcode, uint16_t imm);

void FreeRef(s_ref *pRef);
void FreeIns(s_ins *pIns);
void SetPC(unsigned short imm);

#endif
