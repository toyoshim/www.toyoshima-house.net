	.section	.bss

.include	"address.def"

reg86:
	.fill	12,2,0

	.global		_main
	.global		_InitRupAPI
	.global		_EndRupAPI

	.section	.text
	.global		_start
	.global		_exit

_start:
	jmp	Startup
	nop
	nop
	nop

	.fill	128,1,0

Startup:

	mov	_edata,a0
	mov	_end,a1

	cmp	a0,a1
	beqx	L0

	sub	d0,d0

L1:
	movb	d0,(a0)
	add	1,a0
	cmp	a0,a1
	bnex	L1

L0:
	jsr	_InitRupAPI
	jsr	_main
_exit:
	jsr	_EndRupAPI

	mov	0x0b18,d0
	mov	0x0001,d1

	add	-4,a3
	mov	a2,(0, a3)
	mov	A_SWINTENT,a2
	jsr	(a2)

	mov	reg86,a0
	mov	0x4c,d0
	movb	d0,(1,a0)

	mov	20,d0
	add	-4, a3
	mov	a2, (0, a3)
	mov	A_SWINTENT, a2
	jsr	(a2)

		.section ._stack
_stack: .long	1

