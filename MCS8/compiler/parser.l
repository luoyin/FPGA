%{
#include "parser.h"
#include "parser.tab.h"
%}

REG							("A"|"B"|"C"|"D"|"E"|"H"|"L")
REG2						("B"|"C"|"D"|"E"|"H"|"L")
HEX_NUM						([0-9A-Fa-f]+)
DEC_NUM						([0-9]+)
BIN_NUM						([01]+)
COND						("C"|"Z"|"S"|"P")

%%

"L"{REG}{REG}				{ yylval.opcode=0xC0|(SolveReg(yytext[1])<<3)|(SolveReg(yytext[2])<<0); return LRR; }
"L"{REG}"M"					{ yylval.opcode=0xC7|(SolveReg(yytext[1])<<3); return LRM; }
"LM"{REG}					{ yylval.opcode=0xF8|(SolveReg(yytext[2])<<0); return LMR; }
"L"{REG}"I"					{ yylval.opcode=0x06|(SolveReg(yytext[1])<<3); return LRI; }
"LMI"						{ yylval.opcode=0x3E; return LMI; }
"IN"{REG2}					{ yylval.opcode=0x00|(SolveReg(yytext[2])<<3); return INR; }
"DC"{REG2}					{ yylval.opcode=0x01|(SolveReg(yytext[2])<<3); return DCR; }
"AD"{REG}					{ yylval.opcode=0x80|(SolveReg(yytext[2])<<0); return ADR; }
"ADM"						{ yylval.opcode=0x87; return ADM; }
"ADI"						{ yylval.opcode=0x04; return ADI; }
"AC"{REG}					{ yylval.opcode=0x88|(SolveReg(yytext[2])<<0); return ACR; }
"ACM"						{ yylval.opcode=0x8F; return ACM; }
"ACI"						{ yylval.opcode=0x0C; return ACI; }
"SU"{REG}					{ yylval.opcode=0x90|(SolveReg(yytext[2])<<0); return SUR; }
"SUM"						{ yylval.opcode=0x97; return SUM; }
"SUI"						{ yylval.opcode=0x14; return SUI; }
"SB"{REG}					{ yylval.opcode=0x98|(SolveReg(yytext[2])<<0); return SBR; }
"SBM"						{ yylval.opcode=0x9F; return SBM; }
"SBI"						{ yylval.opcode=0x1C; return SBI; }
"ND"{REG}					{ yylval.opcode=0xA0|(SolveReg(yytext[2])<<0); return NDR; }
"NDM"						{ yylval.opcode=0xA7; return NDM; }
"NDI"						{ yylval.opcode=0x24; return NDI; }
"XR"{REG}					{ yylval.opcode=0xA8|(SolveReg(yytext[2])<<0); return XRR; }
"XRM"						{ yylval.opcode=0xAF; return XRM; }
"XRI"						{ yylval.opcode=0x2C; return XRI; }
"OR"{REG}					{ yylval.opcode=0xB0|(SolveReg(yytext[2])<<0); return ORR; }
"ORM"						{ yylval.opcode=0xB7; return ORM; }
"ORI"						{ yylval.opcode=0x34; return ORI; }
"CP"{REG}					{ yylval.opcode=0xB8|(SolveReg(yytext[2])<<0); return CPR; }
"CPM"						{ yylval.opcode=0xBF; return CPM; }
"CPI"						{ yylval.opcode=0x3C; return CPI; }
"RLC"						{ yylval.opcode=0x02; return RLC; }
"RRC"						{ yylval.opcode=0x0A; return RRC; }
"RAL"						{ yylval.opcode=0x12; return RAL; }
"RAR"						{ yylval.opcode=0x1A; return RAR; }
"JMP"						{ yylval.opcode=0x44; return JMP; }
"JF"{COND}					{ yylval.opcode=0x40|(SolveCondCode(yytext[2])<<3); return JFC; }
"JT"{COND}					{ yylval.opcode=0x60|(SolveCondCode(yytext[2])<<3); return JTC; }
"CAL"						{ yylval.opcode=0x46; return CAL; }
"CF"{COND}					{ yylval.opcode=0x42|(SolveCondCode(yytext[2])<<3); return CFC; }
"CT"{COND}					{ yylval.opcode=0x62|(SolveCondCode(yytext[2])<<3); return CTC; }
"RET"						{ yylval.opcode=0x07; return RET; }
"RF"{COND}					{ yylval.opcode=0x03|(SolveCondCode(yytext[2])<<3); return RFC; }
"RT"{COND}					{ yylval.opcode=0x23|(SolveCondCode(yytext[2])<<3); return RTC; }
"RST"						{ yylval.opcode=0x05; return RST; }
"INP"						{ yylval.opcode=0x41; return INP; }
"OUT"						{ yylval.opcode=0x41; return OUT; }
"NOP"						{ yylval.opcode=0x00; return NOP; }
"HLT"						{ yylval.opcode=0xFF; return HLT; }
"#0"(X|x){HEX_NUM}			{ yylval.imm=SolveIMM_Hex(yytext+3); return IMM; }
"#0"(D|d){DEC_NUM}			{ yylval.imm=atoi(yytext+3); return IMM; }
"#0"(B|b){BIN_NUM}			{ yylval.imm=SolveIMM_Bin(yytext+3); return IMM; }
".LABEL"					{ return LABEL; }
".DEFINE"					{ return DEFINE; }
".ORG"						{ return ORG; }
".GLOBAL"					{ return GLOBAL; }
";".*						{ return COMMENT; }
[A-Za-z_][A-Za-z0-9_]*		{ 
								yylval.strRef=(char *)malloc(sizeof(strlen(yytext)+1));
								strcpy(yylval.strRef, yytext);
								return REF; 
							}
\n							{ gData->pFileCurrent->lineno++; return EOL; }
[ \t]						
.							{ yyerror("Mystery Character %x", yytext[0]); }

%%
