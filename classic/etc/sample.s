;
; sample.s - 音を鳴らす簡単なサンプル -
;

	.include "header.inc"

	.area	_CODE_
TIMER:
	reti

MAIN:
	; サウンドレジスタ初期化
	xor	a
	ldh	(NR52),a	; 全サウンドOFF
	ldh	(NR51),a	; チャンネル出力OFF
	dec	a
	ldh	(NR50),a	; SO1/2 ON, マスターボリューム最大
	ldh	(NR51),a	; チャンネル出力ON
	ld	a, #0x8f
	ldh	(NR52),a	; 全サウンドON

	; 音を出してみる
	xor	a
	ldh	(NR10),a	; スイープOFF
	ld	a,#(2<<6)|0
	ldh	(NR11),a	; デューティ比1:1 | 音長0
	ld	a,#(15<<4)|(1<<3)|0
	ldh	(NR12),a	; 音量15 | エンベロープタイプ減衰 | エンベロープOFF
	ld	a,#0xd6
	ldh	(NR13),a	; 周波数（下位8bit）
	ld	a,#(1<<7)|(0<<6)|0x06
	ldh	(NR14),a	; 再生スタート | 連続モード | 周波数（上位3bit）
				; 周波数レジスタは0x06d6が設定された。これは
				; Hz  = 131072 / (2048 - x) より、約440Hzを表す。

LOOP:
	jr	LOOP
