#include "parser.h"
#include <string.h>

unsigned char SolveReg(char c)
{
	switch(c)
	{
		case 'A':
			return 0;
		case 'B':
			return 1;
		case 'C':
			return 2;
		case 'D':
			return 3;
		case 'E':
			return 4;
		case 'H':
			return 5;
		case 'L':
			return 6;
		default:
			return 7;
	}
}

uint8_t SolveCondCode(char c)
{
	switch(c)
	{
		case 'C':
			return 0x00;
		case 'Z':
			return 0x01;
		case 'S':
			return 0x02;
		case 'P':
			return 0x03;
		default:
			return 0x00;
	}
}

unsigned int SolveIMM_Hex(char *s)
{
	int i;
	char c;
	unsigned int value=0;
	for(i=0; i<strlen(s); i++)
	{
		c=s[i];
		if(c>='A' && c<='F')
			value=value*16+(c-'A'+10);
		else if(c>='a' && c<='f')
			value=value*16+(c-'a'+10);
		else
			value=value*16+(c-'0');
	}
	return value;
}

unsigned int SolveIMM_Bin(char *s)
{
	int i;
	char c;
	unsigned int value=0;
	for(i=0; i<strlen(s); i++)
	{
		c=s[i];
		value=value*2+(c-'0');
	}
	return value;
}

s_ref *GenRef_Label(char *strRef)
{
	s_ref *pRef;
	
	pRef=(s_ref *)malloc(sizeof(s_ref));
	pRef->refType=REF_LABEL;
	pRef->refString=(char *)malloc(strlen(strRef)+1);
	pRef->value=gData->pc;
	strcpy(pRef->refString, strRef);
	
	if(D)
	{
		printf("New Label: %s=0x%03x\n", pRef->refString, pRef->value);
	}
	
	return pRef;
}

s_ref *GenRef_Define(char *strRef, unsigned short imm)
{
	s_ref *pRef;
	
	pRef=(s_ref *)malloc(sizeof(s_ref));
	pRef->refType=REF_DEFINE;
	pRef->refString=(char *)malloc(strlen(strRef)+1);
	strcpy(pRef->refString, strRef);
	pRef->value=imm;
	
	return pRef;
}

s_ref *GenRef_Global(char *strRef)
{
	s_ref *pRef;
	
	pRef=(s_ref *)malloc(sizeof(s_ref));
	pRef->refType=REF_GLOBAL;
	pRef->refString=(char *)malloc(strlen(strRef)+1);
	strcpy(pRef->refString, strRef);
	pRef->value=0;
	pRef->bGlobal=0;
	
	return pRef;
}

s_ins *GenIns_Opcode0(uint8_t opcode)
{
	s_ins *pIns;
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=1;
	pIns->data[0]=opcode;
	pIns->oprandType=OPRAND_NULL;
	pIns->oprandString=NULL;
	
	return pIns;
}

s_ins *GenIns_Imm(uint8_t opcode, uint16_t imm)
{
	s_ins *pIns;
	
	if(imm>0xFF)
	{
		yyerror("Warning: imm>0xFF, trunctated\n");
		imm=imm&0xFF;
	}
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=2;
	pIns->data[0]=opcode;
	pIns->data[1]=imm;
	pIns->oprandType=OPRAND_NULL;
	pIns->oprandString=NULL;
	
	return pIns;
}

s_ins *GenIns_Imm_Ref(uint8_t opcode, char *strRef)
{
	s_ins *pIns;
	
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=2;
	pIns->data[0]=opcode;
	pIns->data[1]=0;
	pIns->oprandType=OPRAND_IMM;
	pIns->oprandString=(char *)malloc(strlen(strRef)+1);
	strcpy(pIns->oprandString, strRef);
	
	return pIns;
}

s_ins *GenIns_Addr(uint8_t opcode, uint16_t imm)
{
	s_ins *pIns;
	
	if(imm>0x3FFF)
	{
		yyerror("Warning: addr>0x3FFF, trunctated\n");
		imm=imm&0x3FFF;
	}
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=3;
	pIns->data[0]=opcode;
	pIns->data[1]=imm&0x00FF;
	pIns->data[2]=(imm&0x3F00)>>8;
	pIns->oprandType=OPRAND_NULL;
	pIns->oprandString=NULL;
	
	return pIns;
}

s_ins *GenIns_Addr_Ref(uint8_t opcode, char *strRef)
{
	s_ins *pIns;
	
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=3;
	pIns->data[0]=opcode;
	pIns->data[1]=0;
	pIns->data[2]=0;
	pIns->oprandType=OPRAND_ADDR14;
	pIns->oprandString=(char *)malloc(strlen(strRef)+1);
	strcpy(pIns->oprandString, strRef);
	
	return pIns;
}

s_ins *GenIns_RST(uint8_t opcode, uint16_t imm)
{
	s_ins *pIns;
	
	if(imm>0x07)
	{
		yyerror("Warning: imm>0x07, trunctated\n");
		imm=imm&0x07;
	}
	pIns=(s_ins *)malloc(sizeof(s_ins));
	pIns->lineno=0;
	pIns->address=0;
	pIns->length=1;
	pIns->data[0]=opcode | ((imm&0x07)<<3);
	pIns->oprandType=OPRAND_NULL;
	
	return pIns;
}

void FreeRef(s_ref *pRef)
{
	
}

void SetPC(unsigned short imm)
{
	if(imm>0x3FFF)
	{
		yyerror("Warning: addr>0x3FFF, trunctated\n");
		imm=imm&0x3FFF;
	}
	
	gData->pc=imm;
	if(D)
	{
		printf("PC=0x%03x\n", imm);
	}
}

void yyerror(char *s, ...)
{
	va_list ap;
	va_start(ap, s);
	
	fprintf(stderr, "%s (%d) ", gData->pFileCurrent->filename, gData->pFileCurrent->lineno);
	vfprintf(stderr, s, ap);
	fprintf(stderr, "\n");
}

