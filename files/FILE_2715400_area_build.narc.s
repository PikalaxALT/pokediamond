	.include "asm/macros.inc"
	.text
	; NARC header
	.ascii "NARC"
	.short 0xFFFE ; byte order
	.short 0x0100 ; version
	.word 0x00001274 ; size
	.short 0x0010 ; chunk size
	.short 3 ; number following chunks

	; BTAF header
	.ascii "BTAF"
	.word 0x000001C4 ; chunk size
	.short 55 ; number of files
	.balign 4
	.word 0x00000000, 0x00000042
	.word 0x00000044, 0x000000F2
	.word 0x000000F4, 0x0000020A
	.word 0x0000020C, 0x00000238
	.word 0x00000238, 0x00000272
	.word 0x00000274, 0x000002A0
	.word 0x000002A0, 0x000002D0
	.word 0x000002D0, 0x000002F8
	.word 0x000002F8, 0x0000031C
	.word 0x0000031C, 0x00000344
	.word 0x00000344, 0x00000368
	.word 0x00000368, 0x00000394
	.word 0x00000394, 0x000003B0
	.word 0x000003B0, 0x000003C8
	.word 0x000003C8, 0x000003EC
	.word 0x000003EC, 0x0000040E
	.word 0x00000410, 0x000004A4
	.word 0x000004A4, 0x000004EE
	.word 0x000004F0, 0x00000558
	.word 0x00000558, 0x00000566
	.word 0x00000568, 0x0000057C
	.word 0x0000057C, 0x00000582
	.word 0x00000584, 0x0000058A
	.word 0x0000058C, 0x0000059A
	.word 0x0000059C, 0x000005A4
	.word 0x000005A4, 0x000005BA
	.word 0x000005BC, 0x000005DE
	.word 0x000005E0, 0x00000684
	.word 0x00000684, 0x0000073C
	.word 0x0000073C, 0x000007FA
	.word 0x000007FC, 0x000008C2
	.word 0x000008C4, 0x0000097C
	.word 0x0000097C, 0x00000996
	.word 0x00000998, 0x00000A52
	.word 0x00000A54, 0x00000B0E
	.word 0x00000B10, 0x00000BD6
	.word 0x00000BD8, 0x00000BF4
	.word 0x00000BF4, 0x00000CAC
	.word 0x00000CAC, 0x00000D68
	.word 0x00000D68, 0x00000D70
	.word 0x00000D70, 0x00000D76
	.word 0x00000D78, 0x00000D88
	.word 0x00000D88, 0x00000D96
	.word 0x00000D98, 0x00000D9A
	.word 0x00000D9C, 0x00000E6E
	.word 0x00000E70, 0x00000E82
	.word 0x00000E84, 0x00000EA2
	.word 0x00000EA4, 0x00000EA8
	.word 0x00000EA8, 0x00000EB0
	.word 0x00000EB0, 0x00000EBA
	.word 0x00000EBC, 0x00000ECC
	.word 0x00000ECC, 0x00000ED4
	.word 0x00000ED4, 0x00000FA4
	.word 0x00000FA4, 0x00000FB2
	.word 0x00000FB4, 0x00001086

	; BTNF header
	.ascii "BTNF"
	.word 0x00000010 ; chunk size
	.word 0x00000004 ; offset to first dir
	.short 0 ; first file
	.short 1 ; number of directories

	; GMIF header
	.ascii "GMIF"
	.word 0x00001090 ; chunk size
	.incbin "baserom.nds", 0x27155EC, 0x1088
	.balign 512, 255