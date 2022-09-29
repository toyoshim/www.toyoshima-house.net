;
; pardio.s - ���������Đ����� -
;

; ���[�N�G���A��`
WORK_TOP	= 0xff80
DATA_PTR	= WORK_TOP+0
DATA_PTR_L	= WORK_TOP+0
DATA_PTR_H	= WORK_TOP+1
COUNTER		= WORK_TOP+2
DIVIDER		= WORK_TOP+3

	.include "header.inc"

	.area	_CODE_
TIMER:	; ���荞�݂ŌĂ΂��
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
	ld	h,a		; HL�Ƀf�[�^�A�h���X��ǂݏo���B
_TONE:
	ld	a,(hl+)		; ���K�f�[�^�̎��o��
	cp	#0
	jr	nz,_TONE_NEXT
	ld	hl,#SOUND_DATA+1
	ld	a,(hl+)		; �Ō�܂ŉ��t�����̂ōŏ��ɖ߂�

_TONE_NEXT:
	sub	a,#'0		; �����𐔒l�ɕϊ�

	cp	#0
	jr	nz,_NOT_R

_R:	; �x��
	ld	a,#(0<<4)|(1<<3)|0
	ldh	(NR12),a	; ��������
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
	ld	a,(de)		; ���K�ԍ��ɕϊ�
	ld	b,a		; �ۑ�

	ld	a,(hl+)
_SHARP:
	cp	#'#
	jr	nz,_OCT
	inc	b		; �V���[�v���������特�K�ԍ���1��������

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
	ld	b,a		; *��2�������̂ŃI�N�^�[�u��������

	ld	a,(hl+)
	jr	_SET_TONE

_OCT_H:
	ld	c,a
	ld	a,b
	add	a,#12
	ld	b,a		; *���������̂ŃI�N�^�[�u���グ��
	ld	a,c

_SET_TONE:
	ld	de,#FREQ_TABLE
	ld	c,a		; �����f�[�^��ޔ�
	ld	a,b
	add	a,a
	add	a,e
	ld	e,a
	ld	a,#0
	adc	a,d
	ld	d,a
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a
	ld	a,(de)		; ���K�ԍ������g�����W�X�^�p�̃f�[�^�ɕϊ�
	ldh	(NR13),a	; ���ʎ��g���f�[�^��ݒ�
	inc	de
	ld	a,(de)
	or	#(1<<7)|(0<<6)
	ldh	(NR14),a	; ��ʎ��g���f�[�^��ݒ肵�Đ��X�^�[�g

_LENGTH:
	ld	a,c
	sub	a,#'0		; �����𐔎��ɕϊ�
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
	ld	sp, #0xfffe	; �X�^�b�N������
	di
	xor	a
	ld	(IE),a		; ���荞��OFF
	ei

	; �T�E���h���W�X�^������
	ldh	(NR52),a	; �S�T�E���hOFF
	ldh	(NR51),a	; �`�����l���o��OFF
	dec	a
	ldh	(NR50),a	; SO1/2 ON, �}�X�^�[�{�����[���ő�
	ldh	(NR51),a	; �`�����l���o��ON
	ld	a,#0x8f
	ldh	(NR52),a	; �S�T�E���hON

	; �`�����l��1������
	xor	a
	ldh	(NR10),a	; �X�C�[�vOFF
	ld	a,#(2<<6)|0
	ldh	(NR11),a	; �f���[�e�B��1:1 | ����0
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a	; ����15 | �G���x���[�v�^�C�v���� | �G���x���[�vOFF

	; ���[�N�G���A�̏�����
	ld	hl,#SOUND_DATA
	ld	a,(hl+)
	ld	c,a		; �e���|��ޔ�
	ld	a,l
	ldh	(DATA_PTR_L),a
	ld	a,h
	ldh	(DATA_PTR_H),a	; �f�[�^�̈ʒu��o�^
	ld	a,#1
	ldh	(COUNTER),a	; �J�E���^��1����
	ld	a,#2
	ldh	(DIVIDER),a	; �����J�E���^��2����

	; ���t�J�n
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
	ldh	(TAC),a		; 4096Hz��TMA�ŕ���
	ld	a,#4
	ldh	(IE),a		; �^�C�}�[���荞�݋���
	ei
LOOP:
	jr	LOOP

TEMPO_TABLE:
	.byte	171, 142, 122, 107, 95, 90, 81, 74, 68, 61

NUM_TO_TONE:	; ���������K�ԍ��i0�`35�̒l�B�W���̃h��12�j�ɕϊ�
	.byte	12, 14, 16, 17, 19, 21, 23

FREQ_TABLE:	; ���K�ɑΉ�������g�����W�X�^�̒l
	.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	; - - - -
	.byte	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xb1, 0x06	; - - - GL
	.byte	0xc4, 0x06, 0xd6, 0x06, 0xe6, 0x06, 0xf6, 0x06	; G#L AL A#L BL

	.byte	0x05, 0x07, 0x13, 0x07, 0x20, 0x07, 0x2d, 0x07	; CM C#M DM D#M
	.byte	0x39, 0x07, 0x44, 0x07, 0x4e, 0x07, 0x58, 0x07	; EM FM F#M GM
	.byte	0x62, 0x07, 0x6b, 0x07, 0x73, 0x07, 0x7b, 0x07	; G#M AM A#M BM

	.byte	0x82, 0x07, 0x89, 0x07, 0x90, 0x07, 0x96, 0x07	; CH C#H DH D#H
	.byte	0x9c, 0x07, 0xa2, 0x07, 0xa7, 0x07, 0xac, 0x07	; EH FH F#H GH
	.byte	0xb1, 0x07, 0xb5, 0x07, 0xb9, 0x07, 0xbd, 0x07	; G#H AH A#H BH

LENGTH_TABLE:	; �����ɑ΂���J�E���g�l
	.byte	48, 3, 6, 9, 12, 18, 24, 36, 4, 8

SOUND_DATA:	; ���t�f�[�^�i�T���v���j
	.asciz	"76#6556#46#**26#**26#**2122#2422#26#6556#0825#4542#4125#5542#4126#**6821*56#082"
