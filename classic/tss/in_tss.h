#ifndef __in_tss_h__
#define	__in_tss_h__

void DSP_WRITE(void *bufeer, unsigned int size);
BOOL PlayMusicBuffer(char *data, int length);
BOOL PlayMusic(char *filename);
void StopMusic();

#endif // __in_tss_h__
