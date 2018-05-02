#ifndef __AS8008_H__
#define __AS8008_H__

#include <inttypes.h>
#include <limits.h>

typedef enum _output_type
{
	OUTPUT_RAW,
	OUTPUT_BIN,
	OUTPUT_HEX
} e_output_type;

typedef enum _list_data_type
{
	LIST_DATA_HEAD,
	LIST_DATA_TAIL,
	LIST_DATA_FILE,
	LIST_DATA_REF,
	LIST_DATA_IMM,
	LIST_DATA_DEFINE,
	LIST_DATA_ADDR,
	LIST_DATA_GLOBAL,
	LIST_DATA_INS,
} e_list_data_type;

typedef enum _oprand_type
{
	OPRAND_NULL,
	OPRAND_IMM,
	OPRAND_ADDR14,
} e_oprand_type;

typedef enum _ref_type
{
	REF_GLOBAL,
	REF_LABEL,
	REF_DEFINE,
} e_ref_type;

typedef struct _list_elem
{
	e_list_data_type typeData;
	void *ptr;
	struct _list_elem *prev;
	struct _list_elem *next;
} s_list_elem;

typedef struct _list
{
	s_list_elem *pHead;
	s_list_elem *pTail;
} s_list;

typedef struct _ins
{
	uint32_t lineno;				// 行号
	uint32_t address;				// 地址
	uint32_t length;				// 指令长度
	uint8_t data[3];				// 指令编码
	e_oprand_type oprandType;		// oprand类型
	char *oprandString;
} s_ins;

typedef struct _ref
{
	uint32_t lineno;
	e_ref_type refType;
	char *refString;
	uint32_t value;
	int bGlobal;
	void *ptrFile;
} s_ref;

typedef struct _file
{
	char filename[PATH_MAX];			// 文件名
	uint32_t lineno;					// 行号
	s_list *pSymbolTable;
	s_list *pSymbolTableGlobal;
	s_list *pListIns;					// list of instruction
} s_file;

typedef struct _global_data
{
	s_list *pListFile;					// list of s_file
	s_list *pSymbolTableGlobal;			// Global Symbol Table
	s_file *pFileCurrent;
	char pOutputFile[PATH_MAX];
	char pMapFile[PATH_MAX];
	uint32_t pc;
	uint32_t sizeROM;
	e_output_type typeOutput;
	unsigned char *pOutput;
} s_global_data;

extern unsigned int gPC;
extern int D;
extern s_global_data *gData;

void SolveCommandLine(int argc, char **argv);
void InitGlobalData();
void AddNewFile(const char *filename);
void Compile();
void CompileFile_II(s_file *pFile);
void CompileFile_III(s_file *pFile);
void DumpCommandLine();

s_list *ListNew();
void ListAppend(s_list *pList, e_list_data_type type, void *ptr);
void AddInstruction(s_ins *pIns);

/**
 * @brief		Reference处理函数 (包含LABEL, DEFINE和GLOBAL)
 * @param		pRef 待添加的reference变量
 * @return 		void
 * @attention	本函数仅处理当前源文件内的reference, 多文件处理时调用SymbolMap_UpdateGlobal()函数
 */
void AddRef(s_ref *pRef);
int SymbolMap_AddRef(s_list *pMap, s_ref *pRef);
s_ref *SymbolMap_FindRef(s_list *pMap, char *strKey);
void SymbolMap_Debug_Dump(s_list *pMap);

/**
 * @brief		更新全局符号表
 * @param		pFile 待更新的文件变量
 * @return		void
 * @attention	本函数为文件内的符号表更新全局标志, 并将全局符号加入到全局符号表中
 */
void SymbolMap_UpdateGlobal(s_file *pFile);

void Debug_DumpListIns(s_list *pList);
void Debug_DumpFile_SymbolTable(s_file * pFile);

void Output_Raw();
void Output_Hex();
void Output_Bin();
void ConvertToBin(char *pStr, unsigned char v);

#endif
