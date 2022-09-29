#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

typedef void (*DW)(void*, unsigned int);
typedef BOOL (*PMB)(char *, int);
typedef BOOL (*PM)(char *);
typedef void (*SM)(void);

static DW dw = NULL;
static PMB pmb = NULL;
static PM pm = NULL;
static SM sm = NULL;

static HMODULE dll = NULL;

/*
 * 最初に呼び出す
 */
int
LoadDll
(void)
{
	dll = LoadLibrary("in_tss.dll");
	if (NULL == dll) return 1;
	dw = (DW)GetProcAddress(dll, "DSP_WRITE");
	if (NULL == dw) return 2;
	pmb = (PMB)GetProcAddress(dll, "PlayMusicBuffer");
	if (NULL == pmb) return 3;
	pm = (PM)GetProcAddress(dll, "PlayMusic");
	if (NULL == pm) return 4;
	sm = (SM)GetProcAddress(dll, "StopMusic");
	if (NULL == sm) return 5;

	return 0;
}

/*
 * 最後に呼び出す
 */
BOOL
UnloadDll
(void)
{
	BOOL result;
	result = FreeLibrary(dll);
	dll = NULL;
	return result;
}

/*
 * 再生データをバッファ上に吐き出す。sizeはバイト単位なので、4の倍数。
 */
void
DSP_WRITE
(void *buffer, unsigned int size)
{
	if (NULL == dw) return;
	dw(buffer, size);
}

/*
 * 再生するTSSデータをセットする。TSSかTSDのメモリイメージを渡せば良い。
 */
BOOL
PlayMusicBuffer
(char *data, int length)
{
	if (NULL == pmb) return FALSE;
	return pmb(data, length);
}

/*
 * 再生するTSSデータをセットする。TSSかTSDのファイル名を渡せば良い。
 */
BOOL
PlayMusic
(char *filename)
{
	if (NULL == pm) return FALSE;
	return pm(filename);
}

/*
 * セットされたデータを破棄する。
 */
void
StopMusic
(void)
{
	if (NULL == sm) return;
	sm();
}

/* for test
int
main
(int argc, char **argv)
{
	LoadDll();
}
*/
