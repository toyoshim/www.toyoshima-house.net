;
; sample.s - ����炷�ȒP�ȃT���v�� -
;

	.include "header.inc"

	.area	_CODE_
TIMER:
	reti

MAIN:
	; �T�E���h���W�X�^������
	xor	a
	ldh	(NR52),a	; �S�T�E���hOFF
	ldh	(NR51),a	; �`�����l���o��OFF
	dec	a
	ldh	(NR50),a	; SO1/2 ON, �}�X�^�[�{�����[���ő�
	ldh	(NR51),a	; �`�����l���o��ON
	ld	a, #0x8f
	ldh	(NR52),a	; �S�T�E���hON

	; �����o���Ă݂�
	xor	a
	ldh	(NR10),a	; �X�C�[�vOFF
	ld	a,#(2<<6)|0
	ldh	(NR11),a	; �f���[�e�B��1:1 | ����0
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a	; ����15 | �G���x���[�v�^�C�v���� | �G���x���[�vOFF
	ld	a,#0xd6
	ldh	(NR13),a	; ���g���i����8bit�j
	ld	a,#(1<<7)|(0<<6)|0x06
	ldh	(NR14),a	; �Đ��X�^�[�g | �A�����[�h | ���g���i���3bit�j
				; ���g�����W�X�^��0x06d6���ݒ肳�ꂽ�B�����
				; Hz  = 131072 / (2048 - x) ���A��440Hz��\���B

LOOP:
	jr	LOOP
