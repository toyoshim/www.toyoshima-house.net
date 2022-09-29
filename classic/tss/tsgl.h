#ifndef	__tsgl_h__
#define	__tsgl_h__

#ifdef	__cplusplus__
extern "C" {
#endif	/* __cplusplus__ */


void	TSGL_Init(HWND hwnd);
void	TSGL_Trash();


void	TSGL_PlayMusicBuffer(char *data, int length);
void	TSGL_PlayMusic(char *filename);
void	TSGL_StopMusic();


void	TSGL_PlaySound(int channel, char *data, long size,
				long bytesPerSample, long channelCount, long samplingRate);
void	TSGL_StopSound(int);

		/* auto channel select */
void	TSGL_PlaySoundAuto(char *data, long size,
				long bytesPerSample, long channelCount, long samplingRate);
void	TSGL_StopSoundAll();

		/* now playing ? */
int		TSGL_Check(int channel);

		/* copy data to local memory and play */
void	TSGL_PlaySoundLocal(char *data, long size,
				long bytesPerSample, long channelCount, long samplingRate);
void	TSGL_StopSoundLocal();


#ifdef	__cplusplus__
}
#endif	/* __cplusplus__ */

#endif	/* __tsgl_h__ */
