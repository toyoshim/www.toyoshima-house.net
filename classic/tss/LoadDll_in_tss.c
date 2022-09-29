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
 * �ŏ��ɌĂяo��
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
 * �Ō�ɌĂяo��
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
 * �Đ��f�[�^���o�b�t�@��ɓf���o���Bsize�̓o�C�g�P�ʂȂ̂ŁA4�̔{���B
 */
void
DSP_WRITE
(void *buffer, unsigned int size)
{
	if (NULL == dw) return;
	dw(buffer, size);
}

/*
 * �Đ�����TSS�f�[�^���Z�b�g����BTSS��TSD�̃������C���[�W��n���Ηǂ��B
 */
BOOL
PlayMusicBuffer
(char *data, int length)
{
	if (NULL == pmb) return FALSE;
	return pmb(data, length);
}

/*
 * �Đ�����TSS�f�[�^���Z�b�g����BTSS��TSD�̃t�@�C������n���Ηǂ��B
 */
BOOL
PlayMusic
(char *filename)
{
	if (NULL == pm) return FALSE;
	return pm(filename);
}

/*
 * �Z�b�g���ꂽ�f�[�^��j������B
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
