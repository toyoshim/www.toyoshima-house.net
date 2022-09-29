;
; pardio.s - 着メロを再生する -
;

; ワークエリア定義
WORK_TOP	= 0xff80
DATA_PTR	= WORK_TOP+0
DATA_PTR_L	= WORK_TOP+0
DATA_PTR_H	= WORK_TOP+1
COUNTER		= WORK_TOP+2
DIVIDER		= WORK_TOP+3

	.include "header.inc"

	.area	_CODE_
TIMER:	; 割り込みで呼ばれる
	push	af

	ldh	a,(DIVIDER)
	dec	a
	jr	z,_TIMER_NEXT
	ldh	(DIVIDER),a
	pop	af
	reti
_TIMER_NEXT:
	ld	a,#2
	ldh	(DIVIDER),a

	ldh	a,(COUNTER)
	dec	a
	jr	z,_CH_EXEC
	ldh	(COUNTER),a

	pop	af
	reti

_CH_EXEC:
	push	bc
	push	de
	push	hl

	ldh	a,(DATA_PTR_L)
	ld	l,a
	ldh	a,(DATA_PTR_H)
	ld	h,a		; HLにデータアドレスを読み出す。
_TONE:
	ld	a,(hl+)		; 音階データの取り出し
	cp	#0
	jr	nz,_TONE_NEXT
	ld	hl,#SOUND_DATA+1
	ld	a,(hl+)		; 最後まで演奏したので最初に戻る

_TONE_NEXT:
	sub	a,#'0		; 文字を数値に変換

	cp	#0
	jr	nz,_NOT_R

_R:	; 休符
	ld	a,#(0<<4)|(1<<3)|0
	ldh	(NR12),a	; 音を消す
	ld	a,(hl+)
	ld	c,a
	jr	_LENGTH

_NOT_R:
	cp	#8
	jr	nz,_NOT_TAI
_TAI:
	ld	a,(hl+)
	ld	c,a
	jr	_LENGTH

_NOT_TAI:
	ld	de,#NUM_TO_TONE
	dec	a
	add	a,e
	ld	e,a
	ld	a,#0
	adc	a,d
	ld	d,a
	ld	a,(de)		; 音階番号に変換
	ld	b,a		; 保存

	ld	a,(hl+)
_SHARP:
	cp	#'#
	jr	nz,_OCT
	inc	b		; シャープがあったら音階番号に1を加える

	ld	a,(hl+)
_OCT:
	cp	#'*
	jr	nz,_SET_TONE
	ld	a,(hl+)
	cp	#'*
	jr	nz,_OCT_H
_OCT_L:
	ld	a,b
	sub	a,#12
	ld	b,a		; *が2つあったのでオクターブを下げる

	ld	a,(hl+)
	jr	_SET_TONE

_OCT_H:
	ld	c,a
	ld	a,b
	add	a,#12
	ld	b,a		; *があったのでオクターブを上げる
	ld	a,c

_SET_TONE:
	ld	de,#FREQ_TABLE
	ld	c,a		; 音長データを退避
	ld	a,b
	add	a,a
	add	a,e
	ld	e,a
	ld	a,#0
	adc	a,d
	ld	d,a
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a
	ld	a,(de)		; 音階番号を周波数レジスタ用のデータに変換
	ldh	(NR13),a	; 下位周波数データを設定
	inc	de
	ld	a,(de)
	or	#(1<<7)|(0<<6)
	ldh	(NR14),a	; 上位周波数データを設定し再生スタート

_LENGTH:
	ld	a,c
	sub	a,#'0		; 文字を数字に変換
	ld	de,#LENGTH_TABLE
	add	a,e
	ld	e,a
	ld	a,#0
	adc	a,d
	ld	d,a
	ld	a,(de)
	ldh	(COUNTER),a

_TIMER_END:
	ld	a,l
	ldh	(DATA_PTR_L),a
	ld	a,h
	ldh	(DATA_PTR_H),a

	pop	hl
	pop	de
	pop	bc
	pop	af

	reti

MAIN:
	ld	sp, #0xfffe	; スタック初期化
	di
	xor	a
	ld	(IE),a		; 割り込みOFF
	ei

	; サウンドレジスタ初期化
	ldh	(NR52),a	; 全サウンドOFF
	ldh	(NR51),a	; チャンネル出力OFF
	dec	a
	ldh	(NR50),a	; SO1/2 ON, マスターボリューム最大
	ldh	(NR51),a	; チャンネル出力ON
	ld	a,#0x8f
	ldh	(NR52),a	; 全サウンドON

	; チャンネル1初期化
	xor	a
	ldh	(NR10),a	; スイープOFF
	ld	a,#(2<<6)|0
	ldh	(NR11),a	; デューティ比1:1 | 音長0
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a	; 音量15 | エンベロープタイプ減衰 | エンベロープOFF

	; ワークエリアの初期化
	ld	hl,#SOUND_DATA
	ld	a,(hl+)
	ld	c,a		; テンポを退避
	ld	a,l
	ldh	(DATA_PTR_L),a
	ld	a,h
	ldh	(DATA_PTR_H),a	; データの位置を登録
	ld	a,#1
	ldh	(COUNTER),a	; カウンタに1を代入
	ld	a,#2
	ldh	(DIVIDER),a	; 分周カウンタに2を代入

	; 演奏開始
	di
	ld	a,c
	sub	a,#'0
	ld	de,#TEMPO_TABLE
	add	a,e
	ld	e,a
	ld	a,#0
	adc	a,d
	ld	d,a
	ld	a,(de)		; 4096 / (t / 60 * 12) / 2
	ld	b,a
	xor	a
	sub	a,b
	ldh	(TMA),a
	ld	a,#(1<<2)|0
	ldh	(TAC),a		; 4096HzをTMAで分周
	ld	a,#4
	ldh	(IE),a		; タイマー割り込み許可
	ei
LOOP:
	jr	LOOP

TEMPO_TABLE:
	.byte	171, 142, 122, 107, 95, 90, 81, 74, 68, 61

NUM_TO_TONE:	; 数字を音階番号（0～35の値。標準のドは12）に変換
	.byte	12, 14, 16, 17, 19, 21, 23

FREQ_TABLE:	; 音階に対応する周波数レジスタの値
	.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	; - - - -
	.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xb1, 0x06	; - - - GL
	.byte	0xc4, 0x06, 0xd6, 0x06, 0xe6, 0x06, 0xf6, 0x06	; G#L AL A#L BL

	.byte	0x05, 0x07, 0x13, 0x07, 0x20, 0x07, 0x2d, 0x07	; CM C#M DM D#M
	.byte	0x39, 0x07, 0x44, 0x07, 0x4e, 0x07, 0x58, 0x07	; EM FM F#M GM
	.byte	0x62, 0x07, 0x6b, 0x07, 0x73, 0x07, 0x7b, 0x07	; G#M AM A#M BM

	.byte	0x82, 0x07, 0x89, 0x07, 0x90, 0x07, 0x96, 0x07	; CH C#H DH D#H
	.byte	0x9c, 0x07, 0xa2, 0x07, 0xa7, 0x07, 0xac, 0x07	; EH FH F#H GH
	.byte	0xb1, 0x07, 0xb5, 0x07, 0xb9, 0x07, 0xbd, 0x07	; G#H AH A#H BH

LENGTH_TABLE:	; 音長に対するカウント値
	.byte	48, 3, 6, 9, 12, 18, 24, 36, 4, 8

SOUND_DATA:	; 演奏データ（サンプル）
	.asciz	"76#6556#46#**26#**26#**2122#2422#26#6556#0825#4542#4125#5542#4126#**6821*56#082"
