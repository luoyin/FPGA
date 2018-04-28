/**
 * @file		as8008.c
 * @author		LUO YIN
 * @version		V1.0
 * @date		2018/03/31
 * @brief		as8008编译器主文件
 * ****************
 * @attention
 */

#include "parser.h"
#include "as8008.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

// 全局数据
unsigned int gPC;
int D=1;				// 调试变量
s_global_data *gData;

int main(int argc, char **argv)
{
	InitGlobalData();
	SolveCommandLine(argc, argv);
	gData->pOutput=(unsigned char *)malloc(gData->sizeROM);
	memset(gData->pOutput, 0, gData->sizeROM);
	if(D!=0)
	{
		DumpCommandLine();
	}
	if(gData->sizeROM>0x4000)
	{
		fprintf(stderr, "Error: ROM Size must not exceed 0x4000\n");
		return -1;
	}
	Compile();
	// 生成
	switch(gData->typeOutput)
	{
		case OUTPUT_RAW:
			Output_Raw();
			break;
		case OUTPUT_BIN:
			Output_Bin();
			break;
		case OUTPUT_HEX:
			Output_Hex();
			break;
		default:
			fprintf(stderr, "Unsupport output type\n");
			break;
	}
	free(gData->pOutput);
	
	return 0;
}

void SolveCommandLine(int argc, char **argv)
{
	int i;
	
	for(i=1; i<argc;)
	{
		if(argv[i][0]=='-')
		{
			if(i==argc-1)
			{
				fprintf(stderr, "Error: invalid command line parameters\n");
				exit(0);
			}
			if(strcmp(argv[i], "-o")==0)
			{
				strcpy(gData->pOutputFile, argv[i+1]);
				i+=2;
			}
			else if(strcmp(argv[i], "-m")==0)
			{
				strcpy(gData->pMapFile, argv[i+1]);
				i+=2;
			}
			else if(strcmp(argv[i], "-t")==0)
			{
				if(strcmp(argv[i+1], "RAW")==0)
					gData->typeOutput=OUTPUT_RAW;
				else if(strcmp(argv[i+1], "BIN")==0)
					gData->typeOutput=OUTPUT_BIN;
				else if(strcmp(argv[i+1], "HEX")==0)
					gData->typeOutput=OUTPUT_HEX;
				i+=2;
			}
			else if(strcmp(argv[i], "-s")==0)
			{
				if(strncmp(argv[i+1], "0x", 2)==0)
					gData->sizeROM=SolveIMM_Hex(argv[i+1]+2);
				else
					gData->sizeROM=atoi(argv[i+1]);
			}
		}
		else
		{
			AddNewFile(argv[i]);
			i+=1;
		}
	}
	
	if(gData->pListFile->pHead->next==gData->pListFile->pTail)
	{
		fprintf(stderr, "Error: no input file\n");
		exit(0);
	}
}

void DumpCommandLine()
{
	s_list_elem *pListFile;
	
	printf("Command Line Parameters: \n");
	printf("Input Files: ");
	pListFile=gData->pListFile->pHead->next;
	while(pListFile!=gData->pListFile->pTail)
	{
		printf("%s ", ((s_file *)pListFile->ptr)->filename);
		pListFile=pListFile->next;
	}
	printf("\n");
	printf("Map File: %s\n", gData->pMapFile);
	printf("Output File: %s\n", gData->pOutputFile);
}

void InitGlobalData()
{
	gData=(s_global_data *)malloc(sizeof(s_global_data));
	gData->pListFile=ListNew();
	gData->pFileCurrent=NULL;
	strcpy(gData->pMapFile, "");
	strcpy(gData->pOutputFile, "");
	
	gData->pSymbolTableGlobal=ListNew();
	gData->sizeROM=0x4000;
	gData->typeOutput=OUTPUT_RAW;
}

void AddNewFile(const char *filename)
{
	s_file *pFile;
	
	pFile=(s_file *)malloc(sizeof(s_file));
	strcpy(pFile->filename, filename);
	pFile->lineno=1;
	pFile->pSymbolTable=ListNew();
	pFile->pSymbolTableGlobal=ListNew();
	pFile->pListIns=ListNew();
	
	ListAppend(gData->pListFile, LIST_DATA_FILE, pFile);
}

s_list* ListNew()
{
	s_list *pList;
	
	pList=(s_list *)malloc(sizeof(s_list));
	pList->pHead=(s_list_elem *)malloc(sizeof(s_list_elem));
	pList->pTail=(s_list_elem *)malloc(sizeof(s_list_elem));
	pList->pHead->typeData=LIST_DATA_HEAD;
	pList->pHead->ptr=NULL;
	pList->pHead->prev=NULL;
	pList->pHead->next=pList->pTail;
	pList->pTail->typeData=LIST_DATA_TAIL;
	pList->pTail->ptr=NULL;
	pList->pTail->prev=pList->pHead;
	pList->pTail->next=NULL;
	
	return pList;
}

void ListAppend(s_list *pList, e_list_data_type type, void *ptr)
{
	s_list_elem *pElem, *pTail;
	
	pTail=pList->pTail;
	pElem=(s_list_elem *)malloc(sizeof(s_list_elem));
	pElem->typeData=type;
	pElem->ptr=ptr;
	pElem->prev=pTail->prev;
	pElem->next=pTail;
	pTail->prev->next=pElem;
	pTail->prev=pElem;
}

void Compile()
{
	s_list_elem *pListFile;
	s_file *pFile;
	FILE *fp;
	
	// 一次扫描
	pListFile=gData->pListFile->pHead->next;
	while(pListFile!=gData->pListFile->pTail)
	{
		pFile=(s_file*)pListFile->ptr;
		if(D!=0)
		{
			printf("Compile File: %s\n", pFile->filename);
		}
		gData->pFileCurrent=pFile;
		fp=fopen(pFile->filename, "r");
		yyin=fp;
		yyparse();
		if(D!=0)
		{
			Debug_DumpListIns(pFile->pListIns);
		}
		pListFile=pListFile->next;
	}
	
	// 二次扫描
	pListFile=gData->pListFile->pHead->next;
	while(pListFile!=gData->pListFile->pTail)
	{
		pFile=(s_file*)pListFile->ptr;
		SymbolMap_UpdateGlobal(pFile);
		pListFile=pListFile->next;
	}
	
	// 三次扫描: 代码生成
	pListFile=gData->pListFile->pHead->next;
	while(pListFile!=gData->pListFile->pTail)
	{
		pFile=(s_file*)pListFile->ptr;
		
		pListFile=pListFile->next;
	}
}

void AddInstruction(s_ins *pIns)
{
	pIns->lineno=yylineno;
	pIns->address=gData->pc;
	gData->pc+=pIns->length;
	
	ListAppend(gData->pFileCurrent->pListIns, LIST_DATA_INS, pIns);
}

void AddRef(s_ref *pRef)
{
	s_ref *pRefFound;
	s_file *pFile;
	
	pFile=gData->pFileCurrent;
	// Ref类型判断
	switch(pRef->refType)
	{
		case REF_GLOBAL:
			// Global标记
			pRefFound=SymbolMap_FindRef(pFile->pSymbolTableGlobal, pRef->refString);
			if(pRefFound!=NULL)
			{
				// LABEL已存在, 报错, 退出
				yyerror("Symbol %s has been already defined in file %s (line %d)",
					pRef->refString,
					pFile->filename,
					pRef->lineno
				);
			}
			else
			{
				// LABEL不存在, 新增
				SymbolMap_AddRef(pFile->pSymbolTableGlobal, pRef);
			}
			break;
		case REF_LABEL:
			// .LABEL标记
		case REF_DEFINE:
			// .DEFINE标记
			pRefFound=SymbolMap_FindRef(pFile->pSymbolTable, pRef->refString);
			if(pRefFound!=NULL)
			{
				// LABEL已存在, 报错, 退出
				yyerror("Symbol %s has been already defined in file %s (line %d)", 
					pRef->refString, 
					pFile->filename,
					pRef->lineno
				);
				exit(0);
			}
			else
			{
				// LABEL不存在, 新增
				SymbolMap_AddRef(pFile->pSymbolTable, pRef);
			}
			break;
		default:
			break;
	}
}

void Debug_DumpListIns(s_list *pList)
{
	s_list_elem *pListHead, *pListTail;
	s_list_elem *pListElem;
	s_ins *pIns;
	
	printf("Instruction:\n");
	pListHead=pList->pHead;
	pListTail=pList->pTail;
	pListElem=pListHead->next;
	while(pListElem!=pListTail)
	{
		pIns=(s_ins *)pListElem->ptr;
		printf("line=%d, address=0x%04x, length=%d, opcode=0x%02x\n", pIns->lineno, pIns->address, pIns->length, pIns->data[0]);
		pListElem=pListElem->next;
	}
	printf("\n");
}

int SymbolMap_AddRef(s_list *pMap, s_ref *pRef)
{
	s_ref *pRefFound;
	s_list *pElem;
	
	pRefFound=SymbolMap_FindRef(pMap, pRef->refString);
	if(pRefFound!=NULL)
		return -1;
	ListAppend(pMap, LIST_DATA_REF, pRef);
	
	return 0;
}

s_ref *SymbolMap_FindRef(s_list *pMap, char *strKey)
{
	s_list_elem *pElem;
	s_ref *pRef;
	
	pElem=pMap->pHead->next;
	while(pElem!=pMap->pTail)
	{
		pRef=(s_ref *)pElem->ptr;
		if(strcmp(pRef->refString, strKey)==0)
			return pRef;
		pElem=pElem->next;
	}
	
	return NULL;
}

void SymbolMap_Debug_Dump(s_list* pMap)
{
	
}

void SymbolMap_UpdateGlobal(s_file *pFile)
{
	s_list_elem *pElem;
	s_ref *pRef, *pRefFound;
	s_file *pFileFound;
	
	// 更新全局标志
	pElem=pFile->pSymbolTableGlobal->pHead->next;
	while(pElem!=pFile->pSymbolTableGlobal->pTail)
	{void Output_Raw();
void Output_Hex();
void Output_Bin();
		pRef=(s_ref *)pElem->ptr;
		pRefFound=SymbolMap_FindRef(pFile->pSymbolTable, pRef->refString);
		if(pRefFound!=NULL)
		{
			pRefFound->bGlobal=1;
		}
		else
		{
			fprintf(stderr, "Warning: Global Symbol %s not defined\n", pRef->refString);
		}
		pElem=pElem->next;
	}
	
	// 添加全局符号表
	pElem=pFile->pSymbolTable->pHead->next;
	while(pElem!=pFile->pSymbolTable->pTail)
	{
		pRef=(s_ref *)pElem->ptr;
		pRefFound=SymbolMap_FindRef(gData->pSymbolTableGlobal, pRef->refString);
		if(pRefFound!=NULL)
		{
			pFileFound=(s_file *)pRefFound->ptrFile;
			fprintf(stderr, "Error: Global Symbol %s has been defined in file %s (line %d)",
				pFileFound->filename, pRefFound->lineno
			);
		}
		else
		{
			SymbolMap_AddRef(gData->pSymbolTableGlobal, pRef);
		}
		pElem=pElem->next;
	}
}

void Output_Raw()
{
	FILE *fout;
	
	if(strlen(gData->pOutputFile)==0)
	{
		fprintf(stderr, "Error: no output file\n");
		return;
	}
	fout=fopen(gData->pOutputFile, "wb");
	fwrite(gData->pOutput, 1, gData->sizeROM, fout);
	fclose(fout);
}

void Output_Hex()
{
	FILE *fout;
	unsigned int i, j;
	
	if(strlen(gData->pOutputFile)==0)
	{
		fprintf(stderr, "Error: no output file\n");
		return;
	}
	fout=fopen(gData->pOutputFile, "w");
	
	for(i=0; i<gData->sizeROM; i+=8)
	{
		fprintf(fout, "@%04x    ", i);
		for(j=i; j<gData->sizeROM && j<i+8; j++)
		{
			fprintf(fout, "%02x ", gData->pOutput[j]);
		}
		fprintf(fout, "\n");
	}
	fclose(fout);
}

void Output_Bin()
{
	
}
