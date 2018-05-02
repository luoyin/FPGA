%{
#include "parser.h"
%}

%union{
	uint8_t opcode;
	char *strRef;
	uint16_t imm;
	s_ins *pIns;
	s_ref *pRef;
}

%token <opcode> LRR
%token <opcode> LRM
%token <opcode> LMR
%token <opcode> LRI
%token <opcode> LMI
%token <opcode> INR DCR
%token <opcode> ADR ADM ADI
%token <opcode> ACR ACM ACI
%token <opcode> SUR SUM SUI
%token <opcode> SBR SBM SBI
%token <opcode> NDR NDM NDI
%token <opcode> XRR XRM XRI
%token <opcode> ORR ORM ORI
%token <opcode> CPR CPM CPI
%token <opcode> RLC RRC RAL RAR
%token <opcode> JMP JFC JTC
%token <opcode> CAL CFC CTC
%token <opcode> RET RFC RTC
%token <opcode> RST
%token <opcode> INP OUT
%token <opcode> NOP HLT
%token <imm> IMM
%token <strRef> REF

%token EOL
%token LABEL
%token DEFINE
%token ORG
%token GLOBAL
%token COMMENT
%type <opcode> command0 command_imm command_addr
%type <pIns> stmt_ins
%type <pRef> stmt_ins_ex

%%

stmt:
	| stmt EOL
	| stmt COMMENT EOL
	| stmt stmt_ins EOL						{ AddInstruction($2); }
	| stmt stmt_ins COMMENT EOL				{ AddInstruction($2); }
	| stmt stmt_ins_ex EOL					{ AddRef($2); }
	| stmt stmt_ins_ex COMMENT EOL			{ AddRef($2); }
	| stmt ORG IMM EOL						{ SetPC($3); }
	| stmt ORG IMM COMMENT EOL				{ SetPC($3); }
	;
	
stmt_ins:
	command0 								{ $$=GenIns_Opcode0($1); }
	| command_imm IMM						{ $$=GenIns_Imm($1, $2); }
	| command_imm REF						{ $$=GenIns_Imm_Ref($1, $2); free($2); }
	| command_addr IMM						{ $$=GenIns_Addr($1, $2); }
	| command_addr REF						{ $$=GenIns_Addr_Ref($1, $2); free($2); }
	| RST IMM								{ $$=GenIns_RST($1, $2); }
	;
	
stmt_ins_ex:
	LABEL REF								{ $$=GenRef_Label($2); free($2); }
	| DEFINE REF IMM						{ $$=GenRef_Define($2, $3); free($2); }
	| GLOBAL REF							{ $$=GenRef_Global($2); free($2); }
	;
	
command0:
	LRR
	| LMR
	| LRM
	| INR
	| DCR
	| ADR | ADM
	| ACR | ACM
	| SUR | SUM
	| SBR | SBM
	| NDR | NDM
	| XRR | XRM
	| ORR | ORM
	| CPR | CPM
	| RET | RFC | RTC
	| HLT
	;

command_imm:
	LRI
	| LMI
	| ADI
	| ACI
	| SUI
	| SBI
	| NDI
	| XRI
	| ORI
	| CPI
	;

command_addr:
	JMP
	| JFC
	| JTC
	| CAL
	| CFC
	| CTC
	;


%%
