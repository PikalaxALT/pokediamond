
	arm_func_start _start
_start: @ 0x02004800
	mov ip, #0x4000000
	str ip, [ip, #0x208]
_02004808:
	ldrh r0, [ip, #6]
	cmp r0, #0
	bne _02004808
	bl init_cp15
	mov r0, #0x13
	msr cpsr_c, r0
	ldr r0, _02004918 @ =0x027E0000
	add r0, r0, #0x3fc0
	mov sp, r0
	mov r0, #0x12
	msr cpsr_c, r0
	ldr r0, _02004918 @ =0x027E0000
	add r0, r0, #0x3fc0
	sub r0, r0, #0x40
	sub sp, r0, #4
	tst sp, #4
	subeq sp, sp, #4
	ldr r1, _0200491C @ =0x00000800
	sub r1, r0, r1
	mov r0, #0x1f
	msr cpsr_fsxc, r0
	sub sp, r1, #4
	mov r0, #0
	ldr r1, _02004918 @ =0x027E0000
	mov r2, #0x4000
	bl INITi_CpuClear32
	mov r0, #0
	ldr r1, _02004920 @ =0x05000000
	mov r2, #0x400
	bl INITi_CpuClear32
	mov r0, #0x200
	ldr r1, _02004924 @ =0x07000000
	mov r2, #0x400
	bl INITi_CpuClear32
	ldr r1, _02004928 @ =0x02004B68
	ldr r0, [r1, #0x14]
	bl MIi_UncompressBackward
	bl do_autoload
	ldr r0, _02004928 @ =0x02004B68
	ldr r1, [r0, #0xc]
	ldr r2, [r0, #0x10]
	mov r3, r1
	mov r0, #0
_020048B4:
	cmp r1, r2
	strlo r0, [r1], #4
	blo _020048B4
	bic r1, r3, #0x1f
_020048C4:
	mcr p15, #0, r0, c7, c10, #4
	mcr p15, #0, r1, c7, c5, #1
	mcr p15, #0, r1, c7, c14, #1
	add r1, r1, #0x20
	cmp r1, r2
	blt _020048C4
	ldr r1, _0200492C @ =0x027FFF9C
	str r0, [r1]
	ldr r1, _02004918 @ =0x027E0000
	add r1, r1, #0x3fc0
	add r1, r1, #0x3c
	ldr r0, _02004930 @ =0x01FF8000
	str r0, [r1]
	bl FUN_02313CFC
	bl NitroStartUp
	bl FUN_02313D00
	ldr r1, _02004934 @ =NitroMain
	ldr lr, _02004938 @ =0xFFFF0000
	tst sp, #4
	subne sp, sp, #4
	bx r1
	.align 2, 0
_02004918: .4byte 0x027E0000
_0200491C: .4byte 0x00000800
_02004920: .4byte 0x05000000
_02004924: .4byte 0x07000000
_02004928: .4byte 0x02004B68
_0200492C: .4byte 0x027FFF9C
_02004930: .4byte 0x01FF8000
_02004934: .4byte NitroMain
_02004938: .4byte 0xFFFF0000
	arm_func_end _start

	arm_func_start INITi_CpuClear32
INITi_CpuClear32: @ 0x0200493C
	add ip, r1, r2
_02004940:
	cmp r1, ip
	stmlt r1!, {r0}
	blt _02004940
	bx lr
	arm_func_end INITi_CpuClear32

	arm_func_start MIi_UncompressBackward
MIi_UncompressBackward: @ 0x02004950
	cmp r0, #0
	beq _020049F8
	push {r4, r5, r6, r7}
	ldmdb r0, {r1, r2}
	add r2, r0, r2
	sub r3, r0, r1, lsr #24
	bic r1, r1, #0xff000000
	sub r1, r0, r1
	mov r4, r2
_02004974:
	cmp r3, r1
	ble _020049D4
	ldrb r5, [r3, #-1]!
	mov r6, #8
_02004984:
	subs r6, r6, #1
	blt _02004974
	tst r5, #0x80
	bne _020049A0
	ldrb r0, [r3, #-1]!
	strb r0, [r2, #-1]!
	b _020049C8
_020049A0:
	ldrb ip, [r3, #-1]!
	ldrb r7, [r3, #-1]!
	orr r7, r7, ip, lsl #8
	bic r7, r7, #0xf000
	add r7, r7, #2
	add ip, ip, #0x20
_020049B8:
	ldrb r0, [r2, r7]
	strb r0, [r2, #-1]!
	subs ip, ip, #0x10
	bge _020049B8
_020049C8:
	cmp r3, r1
	lsl r5, r5, #1
	bgt _02004984
_020049D4:
	mov r0, #0
	bic r3, r1, #0x1f
_020049DC:
	mcr p15, #0, r0, c7, c10, #4
	mcr p15, #0, r3, c7, c5, #1
	mcr p15, #0, r3, c7, c14, #1
	add r3, r3, #0x20
	cmp r3, r4
	blt _020049DC
	pop {r4, r5, r6, r7}
_020049F8:
	bx lr
	arm_func_end MIi_UncompressBackward

	arm_func_start do_autoload
do_autoload: @ 0x020049FC
	ldr r0, _02004A70 @ =0x02004B68
	ldr r1, [r0]
	ldr r2, [r0, #4]
	ldr r3, [r0, #8]
_02004A0C:
	cmp r1, r2
	beq _02004A6C
	ldr r5, [r1], #4
	ldr r7, [r1], #4
	add r6, r5, r7
	mov r4, r5
_02004A24:
	cmp r4, r6
	ldrmi r7, [r3], #4
	strmi r7, [r4], #4
	bmi _02004A24
	ldr r7, [r1], #4
	add r6, r4, r7
	mov r7, #0
_02004A40:
	cmp r4, r6
	strlo r7, [r4], #4
	blo _02004A40
	bic r4, r5, #0x1f
_02004A50:
	mcr p15, #0, r7, c7, c10, #4
	mcr p15, #0, r4, c7, c5, #1
	mcr p15, #0, r4, c7, c14, #1
	add r4, r4, #0x20
	cmp r4, r6
	blt _02004A50
	b _02004A0C
_02004A6C:
	b _02004A74
	.align 2, 0
_02004A70: .4byte 0x02004B68
_02004A74:
	bx lr
	arm_func_end do_autoload

	arm_func_start init_cp15
init_cp15: @ 0x02004A78
	mrc p15, #0, r0, c1, c0, #0
	ldr r1, _02004B30 @ =0x000F9005
	bic r0, r0, r1
	mcr p15, #0, r0, c1, c0, #0
	mov r0, #0
	mcr p15, #0, r0, c7, c5, #0
	mcr p15, #0, r0, c7, c6, #0
	mcr p15, #0, r0, c7, c10, #4
	ldr r0, _02004B34 @ =0x04000033
	mcr p15, #0, r0, c6, c0, #0
	ldr r0, _02004B38 @ =0x0200002D
	mcr p15, #0, r0, c6, c1, #0
	ldr r0, _02004B3C @ =0x027E0021
	mcr p15, #0, r0, c6, c2, #0
	ldr r0, _02004B40 @ =0x08000035
	mcr p15, #0, r0, c6, c3, #0
	ldr r0, _02004B44 @ =0x027E0000
	orr r0, r0, #0x1a
	orr r0, r0, #1
	mcr p15, #0, r0, c6, c4, #0
	ldr r0, _02004B48 @ =0x0100002F
	mcr p15, #0, r0, c6, c5, #0
	ldr r0, _02004B4C @ =0xFFFF001D
	mcr p15, #0, r0, c6, c6, #0
	ldr r0, _02004B50 @ =0x027FF017
	mcr p15, #0, r0, c6, c7, #0
	mov r0, #0x20
	mcr p15, #0, r0, c9, c1, #1
	ldr r0, _02004B44 @ =0x027E0000
	orr r0, r0, #0xa
	mcr p15, #0, r0, c9, c1, #0
	mov r0, #0x42
	mcr p15, #0, r0, c2, c0, #1
	mov r0, #0x42
	mcr p15, #0, r0, c2, c0, #0
	mov r0, #2
	mcr p15, #0, r0, c3, c0, #0
	ldr r0, _02004B54 @ =0x05100011
	mcr p15, #0, r0, c5, c0, #3
	ldr r0, _02004B58 @ =0x15111011
	mcr p15, #0, r0, c5, c0, #2
	mrc p15, #0, r0, c1, c0, #0
	ldr r1, _02004B5C @ =0x0005707D
	orr r0, r0, r1
	mcr p15, #0, r0, c1, c0, #0
	bx lr
	.align 2, 0
_02004B30: .4byte 0x000F9005
_02004B34: .4byte 0x04000033
_02004B38: .4byte 0x0200002D
_02004B3C: .4byte 0x027E0021
_02004B40: .4byte 0x08000035
_02004B44: .4byte 0x027E0000
_02004B48: .4byte 0x0100002F
_02004B4C: .4byte 0xFFFF001D
_02004B50: .4byte 0x027FF017
_02004B54: .4byte 0x05100011
_02004B58: .4byte 0x15111011
_02004B5C: .4byte 0x0005707D
	arm_func_end init_cp15

	arm_func_start OSi_ReferSymbol
OSi_ReferSymbol: @ 0x02004B60
	bx lr
	arm_func_end OSi_ReferSymbol

	arm_func_start NitroStartUp
NitroStartUp: @ 0x02004B64
	bx lr
	arm_func_end NitroStartUp
_02004B68:
	.byte 0x20, 0x20, 0x02, 0x02, 0x50, 0x20, 0x02, 0x02
	.byte 0xC0, 0x4B, 0x00, 0x02, 0xC0, 0x4B, 0x00, 0x02, 0xC0, 0x4B, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x31, 0x75, 0x02, 0x03, 0x21, 0x06, 0xC0, 0xDE, 0xDE, 0xC0, 0x06, 0x21, 0x00, 0x3D, 0x31, 0x02
	.byte 0x2D, 0x00, 0x00, 0x00, 0x00, 0x01, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

	arm_func_start FUN_02004BC0
FUN_02004BC0: @ 0x02004BC0
	push {r4, lr}
	ldr r1, _02004C34 @ =0x0231EFE0
	mov r0, #0
	add r2, r1, #0x21000
	mov r3, #1
	bl FUN_020091D4
	mov r1, r0
	mov r0, #0
	bl FUN_02008D30
	ldr r1, _02004C34 @ =0x0231EFE0
	mov r0, #0
	add r1, r1, #0x21000
	bl FUN_02008D44
	mov r0, #0
	bl FUN_02008F88
	mov r4, r0
	mov r0, #0
	bl FUN_02008F74
	mov r1, r0
	mov r2, r4
	mov r0, #0
	bl FUN_02009134
	movs r4, r0
	bpl _02004C24
	bl FUN_02009D48
_02004C24:
	mov r1, r4
	mov r0, #0
	bl FUN_02009290
	pop {r4, pc}
	.align 2, 0
_02004C34: .4byte 0x0231EFE0
	arm_func_end FUN_02004BC0

	arm_func_start FUN_02004C38
FUN_02004C38: @ 0x02004C38
	ldr r0, _02004C50 @ =0x027E0000
	add r0, r0, #0x3000
	ldr r1, [r0, #0xff8]
	orr r1, r1, #1
	str r1, [r0, #0xff8]
	bx lr
	.align 2, 0
_02004C50: .4byte 0x027E0000
	arm_func_end FUN_02004C38

	arm_func_start FUN_02004C54
FUN_02004C54: @ 0x02004C54
	ldr r0, _02004C68 @ =0x0231CF80
	mov r1, #1
	str r1, [r0, #0xc]
	mov r0, #0
	bx lr
	.align 2, 0
_02004C68: .4byte 0x0231CF80
	arm_func_end FUN_02004C54

	arm_func_start FUN_02004C6C
FUN_02004C6C: @ 0x02004C6C
	ldr r1, _02004CB4 @ =0x04000130
	ldr r0, _02004CB8 @ =0x027FFFA8
	ldrh r3, [r1]
	ldrh r2, [r0]
	ldr r1, _02004CBC @ =0x023142C8
	ldr r0, _02004CC0 @ =0x00002FFF
	orr r2, r3, r2
	eor r2, r2, r0
	and r0, r2, r0
	lsl r0, r0, #0x10
	ldrh r2, [r1, #2]
	lsr r3, r0, #0x10
	eor r2, r2, r0, lsr #16
	and r0, r2, r0, lsr #16
	lsl r0, r0, #0x10
	strh r3, [r1, #2]
	lsr r0, r0, #0x10
	bx lr
	.align 2, 0
_02004CB4: .4byte 0x04000130
_02004CB8: .4byte 0x027FFFA8
_02004CBC: .4byte 0x023142C8
_02004CC0: .4byte 0x00002FFF
	arm_func_end FUN_02004C6C

	arm_func_start FUN_02004CC4
FUN_02004CC4: @ 0x02004CC4
	push {r3, lr}
	bl FUN_0200F410
	ldr r1, _02004CF8 @ =0x023142C8
	ldr r1, [r1, #4]
	cmp r1, r0
	beq _02004CE8
	bl FUN_0200F410
	ldr r1, _02004CF8 @ =0x023142C8
	str r0, [r1, #4]
_02004CE8:
	ldr r0, _02004CF8 @ =0x023142C8
	ldr r0, [r0, #4]
	bl FUN_02006BCC
	pop {r3, pc}
	.align 2, 0
_02004CF8: .4byte 0x023142C8
	arm_func_end FUN_02004CC4

	arm_func_start FUN_02004CFC
FUN_02004CFC: @ 0x02004CFC
	push {r3, r4, r5, lr}
	mov r5, r0
	mov r4, #0
	cmp r5, #0
	pople {r3, r4, r5, pc}
_02004D10:
	bl FUN_02009B0C
	add r4, r4, #1
	cmp r4, r5
	blt _02004D10
	pop {r3, r4, r5, pc}
	arm_func_end FUN_02004CFC

	arm_func_start FUN_02004D24
FUN_02004D24: @ 0x02004D24
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0x3c
	sub sp, sp, #0x800
	ldr r1, _02005A90 @ =0x027FF000
	ldr r0, _02005A94 @ =0x0231CF38
	mov r4, #0
	str r1, [r0]
	bl FUN_02008CE0
	bl FUN_02008438
	bl FUN_02009918
	bl FUN_020099B4
	bl FUN_0200D8F4
	bl FUN_0200A3C0
	ldr r0, _02005A98 @ =0x027E0022
	bl FUN_020095C8
	mov r0, r4
	bl FUN_02081C14
	bl FUN_02004BC0
	mvn r0, #0
	bl FUN_0200BEA0
	bl FUN_0200BE90
	cmp r0, #0
	bne _02004D88
	bl FUN_02009D48
	b _02004E18
_02004D88:
	ldr r0, _02005A9C @ =0x027FF00C
	ldr r0, [r0]
	cmp r0, #0
	bne _02004DC8
	bl FUN_0200DE30
	ldr r0, _02005AA0 @ =0x027FFE00
	mov r2, #0x160
	sub r1, r0, #0xe00
	bl FUN_0200A1D8
	ldr r0, _02005AA0 @ =0x027FFE00
	mov r2, #0x160
	sub r1, r0, #0x380
	bl FUN_0200A1D8
	ldr r1, _02005AA4 @ =0x4A414441
	ldr r0, _02005A9C @ =0x027FF00C
	str r1, [r0]
_02004DC8:
	ldr r0, _02005AA8 @ =0x0231416C
	mov r1, #3
	bl FUN_0200B654
	ldr r3, _02005A90 @ =0x027FF000
	ldr r1, _02005AA4 @ =0x4A414441
	ldr r2, [r3, #0x48]
	str r2, [r0, #0x2c]
	ldr r2, [r3, #0x4c]
	str r2, [r0, #0x30]
	ldr r2, [r3, #0x40]
	str r2, [r0, #0x34]
	ldr r2, [r3, #0x44]
	str r2, [r0, #0x38]
	ldr r0, [r3, #0xc]
	cmp r0, r1
	ldrheq r1, [r3, #0x10]
	ldreq r0, _02005AAC @ =0x00003130
	cmpeq r1, r0
	beq _02004E18
	bl FUN_02009D48
_02004E18:
	bl FUN_02007B74
	lsl r2, r0, #0x10
	mov r0, #0
	mov r1, r0
	lsr r5, r2, #0x10
	bl FUN_0200BEDC
	mov r1, r0
	cmp r1, #0x2000
	ldr r0, _02005AB0 @ =0x0231CFD0
	bhs _02004E44
	bl FUN_0200BEDC
_02004E44:
	bl FUN_02006460
	ldr r3, _02005AB4 @ =0x04000208
	ldr r1, _02005AB8 @ =0x02300078
	ldrh r0, [r3]
	mov r2, #0
	mov r0, #1
	strh r2, [r3]
	bl FUN_02007AC0
	mov r0, #1
	bl FUN_02007A08
	mov r0, #0x40000
	bl FUN_02007A08
	mov r0, #1
	bl FUN_02006F68
	ldr r2, _02005AB4 @ =0x04000208
	mov r0, #1
	ldrh r1, [r2]
	strh r0, [r2]
	bl FUN_02009A7C
	bl FUN_02009B0C
	bl FUN_02006ED4
	ldr r3, _02005ABC @ =0x04001000
	mov r1, #0x6200
	ldr r2, [r3]
	mov r0, #0x5000000
	orr r2, r2, #0x10000
	str r2, [r3]
	ldr r6, _02005AC0 @ =0x0400006C
	strh r1, [r0]
	mov r7, #0
_02004EBC:
	bl FUN_02009B0C
	mov r0, r6
	sub r1, r7, #0x10
	bl FUN_02006E34
	add r0, r6, #0x1000
	sub r1, r7, #0x10
	bl FUN_02006E34
	add r7, r7, #1
	cmp r7, #0x10
	ble _02004EBC
	bl FUN_02005B28
	mov r0, #0xf
	bl FUN_0200C870
	ldr r0, _02005AC4 @ =OSi_ReferSymbol
	ldr r1, _02005AC8 @ =0x0231CF90
	bic r6, r0, #1
	mov r0, r6
	mov r2, #0x10
	bl FUN_0200A1D8
	ldr r0, _02005ACC @ =0x02300094
	bl FUN_0200E8CC
	bl FUN_020063B8
	ldr r3, _02005AD0 @ =0x02313DF2
	add ip, sp, #0xf2
	mov r2, #0xc
_02004F20:
	ldrh r1, [r3]
	ldrh r0, [r3, #2]
	add r3, r3, #4
	strh r1, [ip]
	strh r0, [ip, #2]
	add ip, ip, #4
	subs r2, r2, #1
	bne _02004F20
	ldrh r0, [r3]
	add r7, sp, #0x400
	ldr r3, _02005AD4 @ =0x02313EA8
	add r7, r7, #0x6e
	strh r0, [ip]
	mov r2, #0x18
_02004F58:
	ldrh r1, [r3]
	ldrh r0, [r3, #2]
	add r3, r3, #4
	strh r1, [r7]
	strh r0, [r7, #2]
	add r7, r7, #4
	subs r2, r2, #1
	bne _02004F58
	ldrh r0, [r3]
	ldr r3, _02005AD8 @ =0x02313DC4
	add lr, sp, #0xc4
	strh r0, [r7]
	mov r2, #0xb
_02004F8C:
	ldrh r1, [r3]
	ldrh r0, [r3, #2]
	add r3, r3, #4
	strh r1, [lr]
	strh r0, [lr, #2]
	add lr, lr, #4
	subs r2, r2, #1
	bne _02004F8C
	ldr r0, _02005ADC @ =0x02313D5C
	add r7, sp, #0xb4
	ldrh ip, [r3]
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	add r3, sp, #0x400
	ldr r7, _02005AE0 @ =0x02313F6E
	add r3, r3, #0xa
	strh ip, [lr]
	mov r2, #0x19
_02004FD4:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02004FD4
	ldr r0, _02005AE4 @ =0x02313D6C
	add r7, sp, #0xa4
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	ldr r7, _02005AE8 @ =0x02313E24
	add r3, sp, #0x68
	mov r2, #0xf
_02005010:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005010
	ldr r0, _02005AEC @ =0x02313D7C
	add r7, sp, #0x58
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	add r3, sp, #0x300
	ldr r7, _02005AF0 @ =0x02313FD2
	add r3, r3, #0xa6
	mov r2, #0x19
_02005050:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005050
	ldr r0, _02005AF4 @ =0x02313D8C
	add r7, sp, #0x48
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	add r3, sp, #0x300
	ldr r7, _02005AF8 @ =0x02314036
	add r3, r3, #0x26
	mov r2, #0x20
_02005090:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005090
	ldr r0, _02005AFC @ =0x02313D3C
	add r7, sp, #0x38
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	add r3, sp, #0x200
	ldr r7, _02005B00 @ =0x02313F0A
	add r3, r3, #0xc2
	mov r2, #0x19
_020050D0:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020050D0
	ldr r0, _02005B04 @ =0x02313D4C
	add r7, sp, #0x28
	ldm r0, {r0, r1, r2, r3}
	stm r7, {r0, r1, r2, r3}
	add r3, sp, #0x200
	ldr r7, _02005B08 @ =0x02313E60
	add r3, r3, #0x7a
	mov r2, #0x12
_02005110:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005110
	ldr r7, _02005B0C @ =0x02313D9C
	add r3, sp, #0
	mov r2, #0xa
_0200513C:
	ldrh r1, [r7]
	ldrh r0, [r7, #2]
	add r7, r7, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _0200513C
_0200515C:
	bl FUN_02009B0C
	bl FUN_020063FC
	cmp r4, r0
	beq _02005184
	bl FUN_020063FC
	movs r4, r0
	beq _02005180
	bl FUN_020063A4
	b _02005184
_02005180:
	bl FUN_020063E8
_02005184:
	bl FUN_02006368
	bl FUN_020063FC
	cmp r0, #0
	movne r7, #0
	bne _020051A0
	bl FUN_02004C6C
	mov r7, r0
_020051A0:
	ldr r1, _02005B10 @ =0x0231CF80
	ldr r0, _02005B14 @ =0x023142C8
	ldrb r3, [r1]
	ldrb r2, [r0]
	cmp r2, r3
	strbne r3, [r0]
	movne r0, #0
	ldreq r0, [r1, #8]
	addeq r0, r0, #1
	str r0, [r1, #8]
	cmp r3, #0xd
	addls pc, pc, r3, lsl #2
	b _02005A54
_020051D4: @ jump table
	b _0200520C @ case 0
	b _0200520C @ case 1
	b _02005230 @ case 2
	b _020052F8 @ case 3
	b _020053B4 @ case 4
	b _02005460 @ case 5
	b _02005500 @ case 6
	b _020055A4 @ case 7
	b _0200563C @ case 8
	b _020056E4 @ case 9
	b _02005784 @ case 10
	b _020058A4 @ case 11
	b _020059C8 @ case 12
	b _020059D4 @ case 13
_0200520C:
	ldr r0, _02005AC8 @ =0x0231CF90
	mov r1, r6
	mov r2, #0x10
	bl FUN_0200A1D8
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	bl FUN_02005B7C
	b _02005A58
_02005230:
	add r3, sp, #0xf2
	add ip, sp, #0x248
	mov r2, #0xc
_0200523C:
	ldrh r1, [r3]
	ldrh r0, [r3, #2]
	add r3, r3, #4
	strh r1, [ip]
	strh r0, [ip, #2]
	add ip, ip, #4
	subs r2, r2, #1
	bne _0200523C
	ldrh r3, [r3]
	add r1, sp, #0x200
	add r0, sp, #0x248
	add r1, r1, #0x16
	mov r2, #0x32
	strh r3, [ip]
	bl FUN_0200A0B0
	ldr r1, _02005B10 @ =0x0231CF80
	ldr r0, _02005B18 @ =0x88888889
	ldr r3, [r1, #8]
	ldr r2, _02005B1C @ =0xAAAAAAAB
	umull r1, r0, r3, r0
	lsr r0, r0, #4
	umull r1, ip, r0, r2
	lsr ip, ip, #1
	mov r3, #3
	umull r1, r2, r3, ip
	add r2, sp, #0x200
	rsb ip, r1, r0
	add r2, r2, #0x16
	ldr r1, _02005B20 @ =0x0000FFFF
	add r0, r2, ip, lsl #1
	strh r1, [r0, #0x2c]
	bl FUN_020069B8
	add r3, sp, #0x200
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, r3, #0x16
	bl FUN_020069D4
	bl FUN_02005C88
	bl FUN_02004CC4
	tst r7, #2
	beq _02005A58
	bl FUN_02005C28
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xa
	strb r1, [r0]
	b _02005A58
_020052F8:
	add r3, sp, #0x400
	add r7, sp, #0x700
	add r3, r3, #0x6e
	add r7, r7, #0xda
	mov r2, #0x18
_0200530C:
	ldrh r1, [r3]
	ldrh r0, [r3, #2]
	add r3, r3, #4
	strh r1, [r7]
	strh r0, [r7, #2]
	add r7, r7, #4
	subs r2, r2, #1
	bne _0200530C
	ldrh r3, [r3]
	add r0, sp, #0x700
	add r1, sp, #0x700
	add r0, r0, #0xda
	add r1, r1, #0x78
	mov r2, #0x62
	strh r3, [r7]
	bl FUN_0200A0B0
	ldr r1, _02005B10 @ =0x0231CF80
	ldr r0, _02005B18 @ =0x88888889
	ldr r2, [r1, #8]
	ldr r1, _02005B1C @ =0xAAAAAAAB
	umull r0, r3, r2, r0
	lsr r3, r3, #4
	umull r0, r7, r3, r1
	lsr r7, r7, #1
	mov r2, #3
	umull r0, r1, r2, r7
	add r1, sp, #0x700
	add r1, r1, #0x78
	rsb r7, r0, r3
	ldr r2, _02005B20 @ =0x0000FFFF
	add r0, r1, r7, lsl #1
	strh r2, [r0, #0x5c]
	bl FUN_020069B8
	add r3, sp, #0x700
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, r3, #0x78
	bl FUN_020069D4
	bl FUN_02005E4C
	bl FUN_02004CC4
	b _02005A58
_020053B4:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _02005420
	add ip, sp, #0xc4
	add r3, sp, #0x1e8
	mov r2, #0xb
_020053D0:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020053D0
	ldrh r1, [ip]
	mvn r0, #0
	strh r1, [r3]
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, sp, #0x1e8
	bl FUN_020069D4
_02005420:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0xb4
	ldr r0, [r0, #8]
	add lr, sp, #0x1d8
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #5
	strb r1, [r0]
	b _02005A58
_02005460:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _020054C0
	add ip, sp, #0x400
	add r3, sp, #0x700
	add ip, ip, #0xa
	add r3, r3, #0x14
	mov r2, #0x19
_02005484:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005484
	bl FUN_020069B8
	add r3, sp, #0x700
	add r3, r3, #0x14
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	bl FUN_020069D4
_020054C0:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0xa4
	ldr r0, [r0, #8]
	add lr, sp, #0x1c8
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xa
	strb r1, [r0]
	b _02005A58
_02005500:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _02005564
	add ip, sp, #0x68
	add r3, sp, #0x18c
	mov r2, #0xf
_0200551C:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _0200551C
	mvn r0, #0
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, sp, #0x18c
	bl FUN_020069D4
_02005564:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0x58
	ldr r0, [r0, #8]
	add lr, sp, #0x17c
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #7
	strb r1, [r0]
	b _02005A58
_020055A4:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _020055FC
	add ip, sp, #0x300
	add ip, ip, #0xa6
	add r3, sp, #0x6b0
	mov r2, #0x19
_020055C4:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020055C4
	bl FUN_020069B8
	add r3, sp, #0x6b0
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	bl FUN_020069D4
_020055FC:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0x48
	ldr r0, [r0, #8]
	add lr, sp, #0x16c
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xa
	strb r1, [r0]
	b _02005A58
_0200563C:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _020056A4
	add ip, sp, #0x300
	add ip, ip, #0x26
	add r3, sp, #0x630
	mov r2, #0x20
_0200565C:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _0200565C
	mvn r0, #0
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, sp, #0x630
	bl FUN_020069D4
_020056A4:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0x38
	ldr r0, [r0, #8]
	add lr, sp, #0x15c
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #9
	strb r1, [r0]
	b _02005A58
_020056E4:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _02005744
	add ip, sp, #0x200
	add r3, sp, #0x500
	add ip, ip, #0xc2
	add r3, r3, #0xcc
	mov r2, #0x19
_02005708:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _02005708
	bl FUN_020069B8
	add r3, sp, #0x500
	add r3, r3, #0xcc
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	bl FUN_020069D4
_02005744:
	ldr r0, _02005B10 @ =0x0231CF80
	add r1, sp, #0x28
	ldr r0, [r0, #8]
	add lr, sp, #0x14c
	lsr r0, r0, #3
	and ip, r0, #3
	ldm r1, {r0, r1, r2, r3}
	stm lr, {r0, r1, r2, r3}
	ldr r0, [lr, ip, lsl #2]
	bl FUN_02006A54
	tst r7, #1
	beq _02005A58
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xa
	strb r1, [r0]
	b _02005A58
_02005784:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _02005804
	add ip, sp, #0x200
	add r3, sp, #0x500
	add ip, ip, #0x7a
	add r3, r3, #0x84
	mov r2, #0x12
_020057A8:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020057A8
	mvn r0, #0
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #2
	bl FUN_020066B4
	ldr r1, _02005B10 @ =0x0231CF80
	mov r0, #0
	str r0, [r1, #4]
	bl FUN_02006AE0
	add r3, sp, #0x500
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, r3, #0x84
	bl FUN_020069D4
_02005804:
	tst r7, #1
	beq _0200582C
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r1, [r0, #4]
	cmp r1, #0
	movne r1, #0xb
	strbne r1, [r0]
	bne _02005A58
	bl FUN_02005B4C
	b _02005A58
_0200582C:
	tst r7, #2
	beq _02005858
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #5
	bl FUN_02004CFC
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xb
	strb r1, [r0]
	b _02005A58
_02005858:
	tst r7, #0x80
	beq _02005880
	ldr r1, _02005B10 @ =0x0231CF80
	ldr r0, [r1, #4]
	cmp r0, #0
	bne _02005A58
	mov r0, #1
	str r0, [r1, #4]
	bl FUN_02006AE0
	b _02005A58
_02005880:
	tst r7, #0x40
	ldrne r1, _02005B10 @ =0x0231CF80
	ldrne r0, [r1, #4]
	cmpne r0, #0
	beq _02005A58
	mov r0, #0
	str r0, [r1, #4]
	bl FUN_02006AE0
	b _02005A58
_020058A4:
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _02005918
	add ip, sp, #0
	add r3, sp, #0x124
	mov r2, #0xa
_020058C0:
	ldrh r1, [ip]
	ldrh r0, [ip, #2]
	add ip, ip, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020058C0
	mvn r0, #0
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #2
	bl FUN_020066B4
	ldr r1, _02005B10 @ =0x0231CF80
	mov r0, #1
	str r0, [r1, #4]
	bl FUN_02006AE0
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x98
	add r3, sp, #0x124
	bl FUN_020069D4
_02005918:
	tst r7, #1
	beq _02005950
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r1, [r0, #4]
	cmp r1, #0
	moveq r1, #0xc
	movne r1, #0xa
	strb r1, [r0]
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #5
	bl FUN_02004CFC
	b _02005A58
_02005950:
	tst r7, #2
	beq _0200597C
	bl FUN_020069B8
	mov r0, #0
	bl FUN_020066B4
	mov r0, #5
	bl FUN_02004CFC
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xa
	strb r1, [r0]
	b _02005A58
_0200597C:
	tst r7, #0x80
	beq _020059A4
	ldr r1, _02005B10 @ =0x0231CF80
	ldr r0, [r1, #4]
	cmp r0, #0
	bne _02005A58
	mov r0, #1
	str r0, [r1, #4]
	bl FUN_02006AE0
	b _02005A58
_020059A4:
	tst r7, #0x40
	ldrne r1, _02005B10 @ =0x0231CF80
	ldrne r0, [r1, #4]
	cmpne r0, #0
	beq _02005A58
	mov r0, #0
	str r0, [r1, #4]
	bl FUN_02006AE0
	b _02005A58
_020059C8:
	bl FUN_0200CB2C
_020059CC:
	bl FUN_02009D48
	b _020059CC
_020059D4:
	ldr r4, _02005B24 @ =0x023140B6
	add r3, sp, #0x4d0
	mov r2, #0x2d
_020059E0:
	ldrh r1, [r4]
	ldrh r0, [r4, #2]
	add r4, r4, #4
	strh r1, [r3]
	strh r0, [r3, #2]
	add r3, r3, #4
	subs r2, r2, #1
	bne _020059E0
	mvn r0, #0
	bl FUN_02006BCC
	bl FUN_020069B8
	mov r0, #1
	bl FUN_020066B4
	add r3, sp, #0x4d0
	mov r0, #1
	mov r1, #0x10
	mov r2, #0x68
	bl FUN_020069D4
	bl FUN_020063FC
	cmp r0, #0
	beq _02005A38
	bl FUN_0200CB2C
_02005A38:
	mov r4, #0
_02005A3C:
	bl FUN_02009B0C
	add r4, r4, #1
	cmp r4, #0x3c
	blt _02005A3C
_02005A4C:
	bl FUN_02009D48
	b _02005A4C
_02005A54:
	bl FUN_02009D48
_02005A58:
	mov r0, r5
	bl FUN_0200DAC8
	bl FUN_0200E7B8
	mov r0, r5
	bl FUN_0200DAA8
	ldr r0, _02005B10 @ =0x0231CF80
	ldr r0, [r0, #0xc]
	cmp r0, #0
	beq _0200515C
	bl FUN_02005C28
	ldr r0, _02005B10 @ =0x0231CF80
	mov r1, #0xd
	strb r1, [r0]
	b _0200515C
	.align 2, 0
_02005A90: .4byte 0x027FF000
_02005A94: .4byte 0x0231CF38
_02005A98: .4byte 0x027E0022
_02005A9C: .4byte 0x027FF00C
_02005AA0: .4byte 0x027FFE00
_02005AA4: .4byte 0x4A414441
_02005AA8: .4byte 0x0231416C
_02005AAC: .4byte 0x00003130
_02005AB0: .4byte 0x0231CFD0
_02005AB4: .4byte 0x04000208
_02005AB8: .4byte 0x02300078
_02005ABC: .4byte 0x04001000
_02005AC0: .4byte 0x0400006C
_02005AC4: .4byte OSi_ReferSymbol
_02005AC8: .4byte 0x0231CF90
_02005ACC: .4byte 0x02300094
_02005AD0: .4byte 0x02313DF2
_02005AD4: .4byte 0x02313EA8
_02005AD8: .4byte 0x02313DC4
_02005ADC: .4byte 0x02313D5C
_02005AE0: .4byte 0x02313F6E
_02005AE4: .4byte 0x02313D6C
_02005AE8: .4byte 0x02313E24
_02005AEC: .4byte 0x02313D7C
_02005AF0: .4byte 0x02313FD2
_02005AF4: .4byte 0x02313D8C
_02005AF8: .4byte 0x02314036
_02005AFC: .4byte 0x02313D3C
_02005B00: .4byte 0x02313F0A
_02005B04: .4byte 0x02313D4C
_02005B08: .4byte 0x02313E60
_02005B0C: .4byte 0x02313D9C
_02005B10: .4byte 0x0231CF80
_02005B14: .4byte 0x023142C8
_02005B18: .4byte 0x88888889
_02005B1C: .4byte 0xAAAAAAAB
_02005B20: .4byte 0x0000FFFF
_02005B24: .4byte 0x023140B6
	arm_func_end FUN_02004D24

	arm_func_start FUN_02005B28
FUN_02005B28: @ 0x02005B28
	ldr r1, _02005B44 @ =0x0231CF80
	mov r3, #1
	ldr r0, _02005B48 @ =0x0233FFE0
	mov r2, #0
	strb r3, [r1]
	str r2, [r0, #4]
	bx lr
	.align 2, 0
_02005B44: .4byte 0x0231CF80
_02005B48: .4byte 0x0233FFE0
	arm_func_end FUN_02005B28

	arm_func_start FUN_02005B4C
FUN_02005B4C: @ 0x02005B4C
	ldr r1, _02005B74 @ =0x0233FFE0
	mov r2, #0
	str r2, [r1, #8]
	ldr r0, _02005B78 @ =0x0231CF80
	str r2, [r1, #0xc]
	mov r2, #1
	strb r2, [r0]
	mov r0, #0x3c
	str r0, [r1, #4]
	bx lr
	.align 2, 0
_02005B74: .4byte 0x0233FFE0
_02005B78: .4byte 0x0231CF80
	arm_func_end FUN_02005B4C

	arm_func_start FUN_02005B7C
FUN_02005B7C: @ 0x02005B7C
	stmdb sp!, {lr}
	sub sp, sp, #0x54
	add r0, sp, #4
	bl FUN_02009BE0
	ldrh r1, [sp, #0x1c]
	ldr r0, _02005C10 @ =0x02340000
	add r3, sp, #8
	str r1, [sp]
	ldrb r1, [sp, #5]
	mov r2, #0
	bl FUN_02006100
	ldr r2, _02005C14 @ =0x0233FFE0
	mov r3, #3
	ldrh ip, [r2]
	ldr r0, _02005C18 @ =0x023400FC
	ldr r1, _02005C10 @ =0x02340000
	add ip, ip, #1
	strh ip, [r2]
	str r3, [sp]
	ldrh r3, [r2]
	ldr r2, _02005C1C @ =0x00400286
	bl FUN_02012DBC
	ldr r0, _02005C20 @ =0x02301398
	bl FUN_020101CC
	bl FUN_02013074
	cmp r0, #0
	ldr r2, _02005C14 @ =0x0233FFE0
	mov r3, #0
	ldr r1, _02005C24 @ =0x0231CF80
	mov r0, #2
	strb r0, [r1]
	str r3, [r2, #8]
	str r3, [r2, #0xc]
	movne r0, #4
	strbne r0, [r1]
	add sp, sp, #0x54
	ldm sp!, {pc}
	.align 2, 0
_02005C10: .4byte 0x02340000
_02005C14: .4byte 0x0233FFE0
_02005C18: .4byte 0x023400FC
_02005C1C: .4byte 0x00400286
_02005C20: .4byte 0x02301398
_02005C24: .4byte 0x0231CF80
	arm_func_end FUN_02005B7C

	arm_func_start FUN_02005C28
FUN_02005C28: @ 0x02005C28
	push {r3, lr}
	ldr r0, _02005C84 @ =0x0231CF80
	ldrb r1, [r0]
	cmp r1, #1
	beq _02005C50
	cmp r1, #2
	beq _02005C5C
	cmp r1, #3
	beq _02005C70
	pop {r3, pc}
_02005C50:
	mov r1, #4
	strb r1, [r0]
	pop {r3, pc}
_02005C5C:
	bl FUN_02013220
	ldr r0, _02005C84 @ =0x0231CF80
	mov r1, #4
	strb r1, [r0]
	pop {r3, pc}
_02005C70:
	bl FUN_02013220
	ldr r0, _02005C84 @ =0x0231CF80
	mov r1, #8
	strb r1, [r0]
	pop {r3, pc}
	.align 2, 0
_02005C84: .4byte 0x0231CF80
	arm_func_end FUN_02005C28

	arm_func_start FUN_02005C88
FUN_02005C88: @ 0x02005C88
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	bl FUN_02010FC4
	ldr r1, _02005D9C @ =0x0233FFE0
	mov r8, r0
	ldr r0, [r1, #4]
	cmp r0, #0
	ble _02005CBC
	bl FUN_02009B0C
	ldr r0, _02005D9C @ =0x0233FFE0
	ldr r1, [r0, #4]
	sub r1, r1, #1
	str r1, [r0, #4]
	pop {r4, r5, r6, r7, r8, sb, sl, pc}
_02005CBC:
	mov sb, #0
	ldr r4, _02005DA0 @ =0x00400286
	mov sl, r8
	str sb, [r1, #4]
	mov r5, sb
	mov r7, #1
_02005CD4:
	ldrh r0, [r8, #2]
	tst r0, r7, lsl sb
	beq _02005D40
	ldr r0, [sl, #0x514]
	cmp r0, r4
	beq _02005D20
	bl FUN_02009A90
	add r1, sl, #0x500
	strh r5, [r1, #0x9a]
	mov r6, r0
	ldrh r1, [r8]
	mvn r0, r7, lsl sb
	and r1, r1, r0
	mov r0, sb
	strh r1, [r8]
	bl FUN_02011B10
	mov r0, r6
	bl FUN_02009AA4
	b _02005D40
_02005D20:
	mov r0, sb
	bl FUN_020100AC
	cmp r0, #0
	bne _02005D40
	ldr r0, _02005DA4 @ =0x0231CF80
	mov r1, #3
	strb r1, [r0]
	pop {r4, r5, r6, r7, r8, sb, sl, pc}
_02005D40:
	add sb, sb, #1
	cmp sb, #0x10
	add sl, sl, #0x590
	blt _02005CD4
	ldr r0, _02005D9C @ =0x0233FFE0
	ldr r1, [r0, #0xc]
	cmp r1, #0xe10
	movge r1, #0
	strge r1, [r0, #0xc]
	ldr r0, _02005D9C @ =0x0233FFE0
	ldr r1, [r0, #0xc]
	add r1, r1, #1
	str r1, [r0, #0xc]
	cmp r1, #0xe10
	poplt {r4, r5, r6, r7, r8, sb, sl, pc}
	bl FUN_02013220
	ldr r1, _02005D9C @ =0x0233FFE0
	mov r3, #0
	ldr r0, _02005DA4 @ =0x0231CF80
	mov r2, #4
	str r3, [r1, #0xc]
	strb r2, [r0]
	pop {r4, r5, r6, r7, r8, sb, sl, pc}
	.align 2, 0
_02005D9C: .4byte 0x0233FFE0
_02005DA0: .4byte 0x00400286
_02005DA4: .4byte 0x0231CF80
	arm_func_end FUN_02005C88

	arm_func_start FUN_02005DA8
FUN_02005DA8: @ 0x02005DA8
	push {r3, r4, r5, lr}
	sub sp, sp, #0x40
	cmp r1, #0
	cmpne r2, #0
	mov r5, r0
	mov r4, r3
	addeq sp, sp, #0x40
	moveq r0, #0
	popeq {r3, r4, r5, pc}
	cmp r4, #0
	ldrne r0, [sp, #0x50]
	cmpne r0, #0
	addeq sp, sp, #0x40
	moveq r0, #0
	popeq {r3, r4, r5, pc}
	ldr r0, [sp, #0x54]
	cmp r0, #0
	ldrne r0, [sp, #0x58]
	cmpne r0, #0
	addeq sp, sp, #0x40
	moveq r0, #0
	popeq {r3, r4, r5, pc}
	add r0, sp, #0
	bl FUN_0201430C
	ldr r2, [sp, #0x50]
	add r0, sp, #0x14
	mov r1, r4
	bl FUN_0201430C
	ldr r1, [sp, #0x54]
	ldr r2, [sp, #0x58]
	add r0, sp, #0x28
	bl FUN_0201430C
	ldr r3, [sp, #0x5c]
	add r1, sp, #0
	mov r0, r5
	mov r2, #0x40
	str r3, [sp, #0x3c]
	bl FUN_0201430C
	mov r0, #1
	add sp, sp, #0x40
	pop {r3, r4, r5, pc}
	arm_func_end FUN_02005DA8

	arm_func_start FUN_02005E4C
FUN_02005E4C: @ 0x02005E4C
	push {r4, r5, lr}
	sub sp, sp, #0x24
	ldr r0, _02005F44 @ =0x0233FFE0
	ldr r1, [r0, #0x14]
	add r1, r1, #1
	str r1, [r0, #0x14]
	bl FUN_020101F4
	ldr r0, _02005F44 @ =0x0233FFE0
	ldr r0, [r0, #8]
	cmp r0, #1
	addne sp, sp, #0x24
	popne {r4, r5, pc}
	ldr r3, _02005F48 @ =0x023FE840
	add r0, sp, #0x10
	ldr r1, [r3, #0x24]
	str r1, [sp]
	ldr r1, [r3, #0x2c]
	str r1, [sp, #4]
	ldr r1, [r3, #0x34]
	str r1, [sp, #8]
	ldr r1, [r3, #0xc0]
	str r1, [sp, #0xc]
	ldr r1, [r3, #0xc]
	ldr r2, [r3, #0x14]
	ldr r3, [r3, #0x1c]
	bl FUN_02005DA8
	cmp r0, #0
	bne _02005ED0
	ldr r0, _02005F4C @ =0x0231CF80
	mov r1, #8
	strb r1, [r0]
	add sp, sp, #0x24
	pop {r4, r5, pc}
_02005ED0:
	ldr r1, _02005F48 @ =0x023FE840
	ldr r2, _02005F50 @ =0x02314170
	add r0, sp, #0x10
	add r1, r1, #0x40
	bl FUN_020143E0
	cmp r0, #0
	bne _02005F00
	ldr r0, _02005F4C @ =0x0231CF80
	mov r1, #8
	strb r1, [r0]
	add sp, sp, #0x24
	pop {r4, r5, pc}
_02005F00:
	bl FUN_02009B0C
	ldr r4, _02005F54 @ =0x0400006C
	mov r5, #0
_02005F0C:
	mov r0, r4
	mov r1, r5
	bl FUN_02006E34
	mov r1, r5
	add r0, r4, #0x1000
	bl FUN_02006E34
	bl FUN_02009B0C
	add r5, r5, #1
	cmp r5, #0x10
	ble _02005F0C
	bl FUN_02081BC0
	bl FUN_02081D0C
	add sp, sp, #0x24
	pop {r4, r5, pc}
	.align 2, 0
_02005F44: .4byte 0x0233FFE0
_02005F48: .4byte 0x023FE840
_02005F4C: .4byte 0x0231CF80
_02005F50: .4byte 0x02314170
_02005F54: .4byte 0x0400006C
	arm_func_end FUN_02005E4C

	arm_func_start FUN_02005F58
FUN_02005F58: @ 0x02005F58
	push {r4, lr}
	mov r4, r1
	cmp r0, #0x13
	addls pc, pc, r0, lsl #2
	pop {r4, pc}
_02005F6C: @ jump table
	pop {r4, pc} @ case 0
	pop {r4, pc} @ case 1
	pop {r4, pc} @ case 2
	pop {r4, pc} @ case 3
	pop {r4, pc} @ case 4
	pop {r4, pc} @ case 5
	b _02005FBC @ case 6
	b _02005FD0 @ case 7
	b _02006020 @ case 8
	b _02006034 @ case 9
	pop {r4, pc} @ case 10
	b _02006090 @ case 11
	b _0200603C @ case 12
	pop {r4, pc} @ case 13
	b _020060A0 @ case 14
	pop {r4, pc} @ case 15
	pop {r4, pc} @ case 16
	pop {r4, pc} @ case 17
	pop {r4, pc} @ case 18
	b _020060B4 @ case 19
_02005FBC:
	bl FUN_02013220
	ldr r0, _020060F4 @ =0x0231CF80
	mov r1, #6
	strb r1, [r0]
	pop {r4, pc}
_02005FD0:
	bl FUN_02010214
	cmp r4, #0
	popeq {r4, pc}
	ldr r1, _020060F8 @ =0x02340018
	mov r0, r4
	mov r2, #0xe4
	bl FUN_0200A1D8
	mov r3, #0
	ldr r0, _020060FC @ =0x0233FFE0
	add ip, r4, #0xc
	str r3, [r0, #0x10]
	mov r2, r3
_02006000:
	ldr r1, [ip, #8]
	add r3, r3, #1
	add r2, r2, r1
	str r2, [r0, #0x10]
	cmp r3, #3
	add ip, ip, #0x10
	blt _02006000
	pop {r4, pc}
_02006020:
	bl FUN_020097E0
	ldr r2, _020060FC @ =0x0233FFE0
	str r0, [r2, #0x18]
	str r1, [r2, #0x1c]
	pop {r4, pc}
_02006034:
	bl FUN_020097E0
	pop {r4, pc}
_0200603C:
	ldr r0, _020060F4 @ =0x0231CF80
	ldrb r0, [r0]
	cmp r0, #0xb
	addls pc, pc, r0, lsl #2
	b _02006080
_02006050: @ jump table
	b _02006080 @ case 0
	b _02006080 @ case 1
	b _02006080 @ case 2
	b _02006080 @ case 3
	pop {r4, pc} @ case 4
	b _02006080 @ case 5
	pop {r4, pc} @ case 6
	b _02006080 @ case 7
	b _02006080 @ case 8
	b _02006080 @ case 9
	pop {r4, pc} @ case 10
	pop {r4, pc} @ case 11
_02006080:
	ldr r0, _020060F4 @ =0x0231CF80
	mov r1, #8
	strb r1, [r0]
	pop {r4, pc}
_02006090:
	ldr r0, _020060FC @ =0x0233FFE0
	mov r1, #1
	str r1, [r0, #8]
	pop {r4, pc}
_020060A0:
	bl FUN_02013220
	ldr r0, _020060F4 @ =0x0231CF80
	mov r1, #6
	strb r1, [r0]
	pop {r4, pc}
_020060B4:
	ldrh r0, [r4]
	cmp r0, #9
	addls pc, pc, r0, lsl #2
	pop {r4, pc}
_020060C4: @ jump table
	pop {r4, pc} @ case 0
	pop {r4, pc} @ case 1
	pop {r4, pc} @ case 2
	pop {r4, pc} @ case 3
	pop {r4, pc} @ case 4
	pop {r4, pc} @ case 5
	pop {r4, pc} @ case 6
	pop {r4, pc} @ case 7
	pop {r4, pc} @ case 8
	b _020060EC @ case 9
_020060EC:
	bl FUN_02013220
	pop {r4, pc}
	.align 2, 0
_020060F4: .4byte 0x0231CF80
_020060F8: .4byte 0x02340018
_020060FC: .4byte 0x0233FFE0
	arm_func_end FUN_02005F58

	arm_func_start FUN_02006100
FUN_02006100: @ 0x02006100
	push {r3, r4, r5, lr}
	mov r4, r0
	ldrb lr, [r4]
	and r0, r1, #0xf
	ldrh ip, [sp, #0x10]
	bic r1, lr, #0xf
	orr r0, r1, r0
	strb r0, [r4]
	mov r5, r2
	mov r0, r3
	strb ip, [r4, #1]
	add r1, r4, #2
	lsl r2, ip, #1
	bl FUN_0200A1D8
	ldrb r1, [r4]
	lsl r0, r5, #0x1c
	bic r1, r1, #0xf0
	orr r0, r1, r0, lsr #24
	strb r0, [r4]
	pop {r3, r4, r5, pc}
	arm_func_end FUN_02006100

	arm_func_start FUN_02006150
FUN_02006150: @ 0x02006150
	push {r4, r5, lr}
	sub sp, sp, #0xc
	mov r5, r0
	mov r4, r1
	mov r2, #0
	add r0, sp, #8
	add r1, sp, #4
	str r2, [r5]
	bl FUN_0200CA9C
	cmp r0, #0
	bne _020061C4
	ldr r0, [sp, #8]
	ldr r1, [r5]
	cmp r0, #1
	moveq r0, #1
	movne r0, #0
	and r0, r0, #1
	bic r1, r1, #1
	orr r0, r1, r0
	str r0, [r5]
	ldr r0, [sp, #4]
	ldr r1, [r5]
	cmp r0, #1
	moveq r0, #1
	movne r0, #0
	lsl r0, r0, #0x1f
	bic r1, r1, #2
	orr r0, r1, r0, lsr #30
	b _020061EC
_020061C4:
	cmp r4, #0
	movne r3, #1
	ldr r0, [r5]
	moveq r3, #0
	and r1, r3, #1
	bic r0, r0, #1
	orr r2, r0, r1
	bic r0, r2, #2
	lsl r1, r3, #0x1f
	orr r0, r0, r1, lsr #30
_020061EC:
	str r0, [r5]
	bl FUN_0200C900
	cmp r0, #1
	moveq r0, #1
	ldr r1, [r5]
	movne r0, #0
	lsl r0, r0, #0x1f
	bic r1, r1, #4
	orr r1, r1, r0, lsr #29
	add r0, sp, #0
	str r1, [r5]
	bl FUN_0200CA5C
	cmp r0, #0
	bne _02006250
	ldr r0, [sp]
	ldr r1, [r5]
	cmp r0, #1
	moveq r0, #1
	movne r0, #0
	lsl r0, r0, #0x1f
	bic r1, r1, #8
	orr r0, r1, r0, lsr #28
	add sp, sp, #0xc
	str r0, [r5]
	pop {r4, r5, pc}
_02006250:
	cmp r4, #0
	movne r0, #1
	moveq r0, #0
	ldr r1, [r5]
	lsl r0, r0, #0x1f
	bic r1, r1, #8
	orr r0, r1, r0, lsr #28
	str r0, [r5]
	add sp, sp, #0xc
	pop {r4, r5, pc}
	arm_func_end FUN_02006150

	arm_func_start FUN_02006278
FUN_02006278: @ 0x02006278
	push {r4, lr}
	mov r4, r0
	ldr r0, [r4]
	lsl r1, r0, #0x1f
	lsrs r1, r1, #0x1f
	beq _020062AC
	lsl r0, r0, #0x1e
	lsrs r0, r0, #0x1f
	beq _020062AC
	mov r0, #2
	mov r1, #1
	bl FUN_0200CC18
	b _02006310
_020062AC:
	cmp r1, #0
	bne _020062D4
	ldr r0, [r4]
	lsl r0, r0, #0x1e
	lsrs r0, r0, #0x1f
	bne _020062D4
	mov r0, #2
	mov r1, #0
	bl FUN_0200CC18
	b _02006310
_020062D4:
	cmp r1, #0
	movne r1, #1
	moveq r1, #0
	mov r0, #0
	bl FUN_0200CC18
	cmp r0, #0
	mvnne r0, #0
	popne {r4, pc}
	ldr r0, [r4]
	lsl r0, r0, #0x1e
	lsrs r0, r0, #0x1f
	movne r1, #1
	moveq r1, #0
	mov r0, #1
	bl FUN_0200CC18
_02006310:
	cmp r0, #0
	mvnne r0, #0
	popne {r4, pc}
	ldr r0, [r4]
	lsl r0, r0, #0x1d
	lsrs r0, r0, #0x1f
	movne r0, #1
	moveq r0, #0
	bl FUN_0200C91C
	cmp r0, #0
	mvneq r0, #0
	popeq {r4, pc}
	ldr r0, [r4]
	lsl r0, r0, #0x1c
	lsrs r0, r0, #0x1f
	movne r0, #1
	moveq r0, #0
	bl FUN_0200CB14
	cmp r0, #0
	mvnne r0, #0
	moveq r0, #0
	pop {r4, pc}
	arm_func_end FUN_02006278

	arm_func_start FUN_02006368
FUN_02006368: @ 0x02006368
	push {r3, lr}
	ldr r0, _0200639C @ =0x023460FC
	ldr r1, [r0]
	ldr r0, [r0, #4]
	cmp r1, r0
	popeq {r3, pc}
	ldr r0, _020063A0 @ =0x02346100
	bl FUN_02006278
	cmp r0, #0
	ldreq r0, _0200639C @ =0x023460FC
	ldreq r1, [r0, #4]
	streq r1, [r0]
	pop {r3, pc}
	.align 2, 0
_0200639C: .4byte 0x023460FC
_020063A0: .4byte 0x02346100
	arm_func_end FUN_02006368

	arm_func_start FUN_020063A4
FUN_020063A4: @ 0x020063A4
	ldr r0, _020063B4 @ =0x023460FC
	mov r1, #0
	str r1, [r0, #4]
	bx lr
	.align 2, 0
_020063B4: .4byte 0x023460FC
	arm_func_end FUN_020063A4

	arm_func_start FUN_020063B8
FUN_020063B8: @ 0x020063B8
	push {r3, lr}
	ldr r0, _020063E0 @ =0x023460FC
	mov r1, #1
	bl FUN_02006150
	ldr r0, _020063E4 @ =0x023460FC
	ldr r1, [r0]
	str r1, [r0, #4]
	str r1, [sp]
	str r1, [r0, #0xc]
	pop {r3, pc}
	.align 2, 0
_020063E0: .4byte 0x023460FC
_020063E4: .4byte 0x023460FC
	arm_func_end FUN_020063B8

	arm_func_start FUN_020063E8
FUN_020063E8: @ 0x020063E8
	ldr r0, _020063F8 @ =0x023460FC
	ldr r1, [r0, #0xc]
	str r1, [r0, #4]
	bx lr
	.align 2, 0
_020063F8: .4byte 0x023460FC
	arm_func_end FUN_020063E8

	arm_func_start FUN_020063FC
FUN_020063FC: @ 0x020063FC
	ldr r2, _02006458 @ =0x027FFFA8
	ldrh r0, [r2]
	and r0, r0, #0x8000
	asrs r0, r0, #0xf
	beq _02006444
	ldr r0, _0200645C @ =0x023460FC
	ldr r1, [r0, #8]
	cmp r1, #0
	beq _02006438
	ldr r0, [r2, #-0x36c]
	sub r0, r0, r1
	cmp r0, #0xf
	blo _02006450
	mov r0, #1
	bx lr
_02006438:
	ldr r1, [r2, #-0x36c]
	str r1, [r0, #8]
	b _02006450
_02006444:
	ldr r0, _0200645C @ =0x023460FC
	mov r1, #0
	str r1, [r0, #8]
_02006450:
	mov r0, #0
	bx lr
	.align 2, 0
_02006458: .4byte 0x027FFFA8
_0200645C: .4byte 0x023460FC
	arm_func_end FUN_020063FC

	arm_func_start FUN_02006460
FUN_02006460: @ 0x02006460
	push {r3, lr}
	ldr r0, _02006670 @ =0x0231CF14
	mov r1, #1
	str r1, [r0]
	bl FUN_02006F98
	bl FUN_02006F20
	ldr r3, _02006674 @ =0x04001000
	ldr r0, _02006678 @ =0x0400006C
	ldr r2, [r3]
	mvn r1, #0xf
	bic r2, r2, #0x10000
	str r2, [r3]
	bl FUN_02006E34
	ldr r0, _0200667C @ =0x0400106C
	mvn r1, #0xf
	bl FUN_02006E34
	ldr r0, _02006680 @ =0x000001FF
	bl FUN_02007294
	mov r0, #0
	mov r1, #0x6800000
	mov r2, #0xa4000
	bl FUN_0200A0F8
	bl FUN_0200719C
	mov r0, #0xc0
	mov r1, #0x7000000
	mov r2, #0x400
	bl FUN_0200A0F8
	mov r0, #0
	mov r1, #0x5000000
	mov r2, #0x400
	bl FUN_0200A0F8
	mov r0, #0xc0
	ldr r1, _02006684 @ =0x07000400
	mov r2, #0x400
	bl FUN_0200A0F8
	mov r0, #0
	ldr r1, _02006688 @ =0x05000400
	mov r2, #0x400
	bl FUN_0200A0F8
	mov r0, #1
	bl FUN_020072B4
	ldr r0, _0200668C @ =0x04000008
	ldrh r1, [r0]
	and r1, r1, #0x43
	orr r1, r1, #0xc00
	strh r1, [r0]
	ldrh r1, [r0]
	bic r1, r1, #3
	strh r1, [r0]
	ldrh r1, [r0]
	bic r1, r1, #0x40
	strh r1, [r0]
	ldrh r1, [r0, #2]
	and r1, r1, #0x43
	orr r1, r1, #0x208
	orr r1, r1, #0xc00
	strh r1, [r0, #2]
	ldrh r1, [r0, #2]
	bic r1, r1, #3
	orr r1, r1, #1
	strh r1, [r0, #2]
	ldrh r1, [r0, #2]
	bic r1, r1, #0x40
	strh r1, [r0, #2]
	mov r1, #0
	mov r2, r1
	mov r0, #1
	bl FUN_02006E60
	mov r3, #0x4000000
	ldr r1, [r3]
	ldr r0, _02006690 @ =0x023142D0
	bic r1, r1, #0x1f00
	orr ip, r1, #0x300
	mov r1, #0x20
	mov r2, #0x120
	str ip, [r3]
	bl FUN_020076F4
	ldr r0, _02006694 @ =0x023145F0
	mov r1, #0x140
	mov r2, #0x240
	bl FUN_020076F4
	ldr r0, _02006698 @ =0x0231CCF0
	mov r1, #0x380
	mov r2, #0x200
	bl FUN_020076F4
	mov r1, #0x20
	ldr r0, _0200669C @ =0x023143F0
	mov r2, r1
	bl FUN_0200775C
	ldr r0, _020066A0 @ =0x02314830
	mov r1, #0x40
	mov r2, #0x20
	bl FUN_0200775C
	ldr r0, _020066A4 @ =0x0231CEF0
	mov r1, #0x60
	mov r2, #0x20
	bl FUN_0200775C
	mov r1, #0
	mov r3, #0x5000000
	ldr r2, _020066A8 @ =0x00007FFF
	strh r1, [r3]
	strh r2, [r3, #2]
	ldr r0, _020066AC @ =0x00002D6A
	ldr r2, _020066B0 @ =0x000062F5
	strh r0, [r3, #4]
	strh r0, [r3, #6]
	strh r2, [r3, #8]
	mov r0, #3
	mov r2, #4
	bl FUN_02006C30
	bl FUN_020076C0
	mov r2, #0
_02006620:
	lsl r1, r2, #1
	strh r2, [r0, r1]
	add r2, r2, #1
	cmp r2, #0x300
	blt _02006620
	bl FUN_0200768C
	mov r2, #0
	mov r3, r2
_02006640:
	lsl r1, r2, #1
	add r2, r2, #1
	strh r3, [r0, r1]
	cmp r2, #0x300
	blt _02006640
	ldr r2, _02006674 @ =0x04001000
	mov r0, #0x5000000
	ldr r1, [r2]
	bic r1, r1, #0x1f00
	str r1, [r2]
	strh r3, [r0]
	pop {r3, pc}
	.align 2, 0
_02006670: .4byte 0x0231CF14
_02006674: .4byte 0x04001000
_02006678: .4byte 0x0400006C
_0200667C: .4byte 0x0400106C
_02006680: .4byte 0x000001FF
_02006684: .4byte 0x07000400
_02006688: .4byte 0x05000400
_0200668C: .4byte 0x04000008
_02006690: .4byte 0x023142D0
_02006694: .4byte 0x023145F0
_02006698: .4byte 0x0231CCF0
_0200669C: .4byte 0x023143F0
_020066A0: .4byte 0x02314830
_020066A4: .4byte 0x0231CEF0
_020066A8: .4byte 0x00007FFF
_020066AC: .4byte 0x00002D6A
_020066B0: .4byte 0x000062F5
	arm_func_end FUN_02006460

	arm_func_start FUN_020066B4
FUN_020066B4: @ 0x020066B4
	push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
	mov r7, r0
	bl FUN_0200768C
	cmp r7, #1
	moveq r2, #0xc
	movne r2, #6
	rsb r1, r2, #0x18
	lsl r6, r1, #5
	cmp r6, #0x40
	mov r5, #0x40
	ble _020066F8
	mov r4, #0
_020066E4:
	lsl r3, r5, #1
	add r5, r5, #1
	strh r4, [r0, r3]
	cmp r5, r6
	blt _020066E4
_020066F8:
	cmp r7, #2
	bne _02006788
	mov r8, #0
	sub lr, r2, #1
	mov r3, #2
	mov r4, #1
	mov ip, r8
	mov r5, r8
_02006718:
	cmp r8, #0
	moveq r6, r5
	beq _02006730
	cmp r8, lr
	movlt r6, #1
	movge r6, #2
_02006730:
	add r6, r6, r6, lsl #1
	add sb, r8, #0xc
	add r6, r6, #1
	lsl sb, sb, #5
	add r7, r6, #0x1000
	mov r6, #0
	add sl, r0, sb, lsl #1
_0200674C:
	cmp r6, #0
	moveq sb, ip
	beq _02006764
	cmp r6, #7
	movlt sb, r4
	movge sb, r3
_02006764:
	add fp, sb, r7
	add sb, sl, r6, lsl #1
	strh fp, [sb, #0x30]
	add r6, r6, #1
	cmp r6, #8
	blt _0200674C
	add r8, r8, #1
	cmp r8, #6
	blt _02006718
_02006788:
	mov r6, #0
	cmp r2, #0
	pople {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	sub lr, r2, #1
	mov r3, #2
	mov ip, #1
	mov r4, r6
	mov r8, #6
_020067A8:
	cmp r6, #0
	moveq r7, r4
	beq _020067C0
	cmp r6, lr
	movlt r7, ip
	movge r7, #2
_020067C0:
	mul r5, r7, r8
	add r5, r5, #0xa
	lsl sb, r1, #5
	mov r7, #0
	add r5, r5, #0x2000
	add sb, r0, sb, lsl #1
_020067D8:
	cmp r7, #2
	movlt sl, r7
	blt _020067F0
	cmp r7, #0x1d
	movlt sl, r3
	subge sl, r7, #0x1a
_020067F0:
	add fp, sl, r5
	lsl sl, r7, #1
	strh fp, [sl, sb]
	add r7, r7, #1
	cmp r7, #0x20
	blt _020067D8
	add r6, r6, #1
	cmp r6, r2
	add r1, r1, #1
	blt _020067A8
	pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	arm_func_end FUN_020066B4

	arm_func_start FUN_0200681C
FUN_0200681C: @ 0x0200681C
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x8c
	mov r5, r2
	str r1, [sp]
	mov r4, r0
	add r1, sp, #0xc
	mov r0, r5
	bl FUN_02006CE8
	add r1, sp, #0x4c
	add r0, r5, #0x10
	bl FUN_02006CE8
	add r1, sp, #0x2c
	add r0, r5, #0x20
	bl FUN_02006CE8
	add r1, sp, #0x6c
	add r0, r5, #0x30
	bl FUN_02006CE8
	lsr r1, r4, #0x1f
	rsb r0, r1, r4, lsl #30
	add r0, r1, r0, ror #30
	lsl r7, r0, #2
	lsl r0, r4, #1
	and r1, r0, #0x1f0
	asr r0, r4, #2
	and r0, r0, #1
	mov r6, #0
	add r2, r4, #4
	orr r3, r1, r0
	lsl r0, r2, #1
	and r1, r0, #0x1f0
	asr r0, r2, #2
	and r0, r0, #1
	add fp, r4, #8
	orr r2, r1, r0
	lsl r0, fp, #1
	and r1, r0, #0x1f0
	asr r0, fp, #2
	and r0, r0, #1
	orr r1, r1, r0
	add sl, r4, #0xc
	lsl r0, sl, #1
	add r5, r4, #0x10
	and r4, r0, #0x1f0
	asr r0, sl, #2
	and r0, r0, #1
	orr r0, r4, r0
	lsl r4, r5, #1
	and sl, r4, #0x1f0
	asr r4, r5, #2
	and r4, r4, #1
	orr sl, sl, r4
	lsl r0, r0, #1
	str r0, [sp, #4]
	lsl r0, sl, #1
	mov r8, r6
	rsb sb, r7, #0x10
	lsl r5, r3, #1
	lsl r4, r2, #1
	lsl fp, r1, #1
	str r0, [sp, #8]
_0200690C:
	ldr r0, [sp]
	add sl, r0, r6
	bl FUN_02007658
	lsl r1, sl, #1
	asr r2, sl, #3
	and r1, r1, #0xe
	orr r1, r1, r2, lsl #9
	add r2, r0, r1, lsl #1
	add r0, sp, #0xc
	lsl r1, r8, #1
	add r3, sp, #0xc
	add r0, r0, r8, lsl #1
	ldrh sl, [r5, r2]
	ldrh r3, [r3, r1]
	add r6, r6, #1
	add r8, r8, #2
	orr r3, sl, r3, lsl r7
	strh r3, [r5, r2]
	add r3, sp, #0xc
	ldrh r1, [r3, r1]
	ldrh r3, [r0, #2]
	cmp r6, #0x10
	orr r1, r1, r3, lsl #16
	lsr r1, r1, sb
	strh r1, [r4, r2]
	ldrh r3, [r0, #0x40]
	ldrh r1, [r0, #2]
	orr r1, r1, r3, lsl #16
	lsr r1, r1, sb
	strh r1, [fp, r2]
	ldrh r3, [r0, #0x42]
	ldrh r1, [r0, #0x40]
	orr r1, r1, r3, lsl #16
	lsr r3, r1, sb
	ldr r1, [sp, #4]
	strh r3, [r1, r2]
	ldrh r0, [r0, #0x42]
	lsr r1, r0, sb
	ldr r0, [sp, #8]
	strh r1, [r0, r2]
	blt _0200690C
	add sp, sp, #0x8c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	arm_func_end FUN_0200681C

	arm_func_start FUN_020069B8
FUN_020069B8: @ 0x020069B8
	push {r3, lr}
	bl FUN_02007658
	mov r1, r0
	mov r0, #0
	mov r2, #0x6000
	bl FUN_0200A098
	pop {r3, pc}
	arm_func_end FUN_020069B8

	arm_func_start FUN_020069D4
FUN_020069D4: @ 0x020069D4
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov r7, r3
	ldrh r0, [r7]
	ldr sl, _02006A48 @ =0x0000FFFF
	mov sb, r1
	ldr r4, _02006A4C @ =0x02314BB0
	ldr r5, _02006A50 @ =0x0231CAF0
	mov r8, r2
	mov r6, sb
	cmp r0, sl
	popeq {r4, r5, r6, r7, r8, sb, sl, pc}
_02006A00:
	cmp r0, #0xe000
	moveq sb, r6
	addeq r8, r8, #0x10
	addeq r7, r7, #2
	beq _02006A38
	sub r2, r0, #1
	mov r0, sb
	mov r1, r8
	add r2, r4, r2, lsl #6
	bl FUN_0200681C
	ldrh r0, [r7], #2
	add r0, r5, r0
	ldrb r0, [r0, #-1]
	add sb, sb, r0
_02006A38:
	ldrh r0, [r7]
	cmp r0, sl
	bne _02006A00
	pop {r4, r5, r6, r7, r8, sb, sl, pc}
	.align 2, 0
_02006A48: .4byte 0x0000FFFF
_02006A4C: .4byte 0x02314BB0
_02006A50: .4byte 0x0231CAF0
	arm_func_end FUN_020069D4

	arm_func_start FUN_02006A54
FUN_02006A54: @ 0x02006A54
	push {r4, r5, r6, r7, r8, lr}
	ldr r1, _02006ADC @ =0x02314A30
	mov r6, #0
	mov r7, r6
	add r5, r1, r0, lsl #7
	mov r4, r6
_02006A6C:
	bl FUN_02007658
	add r1, r6, #0x15
	lsl r1, r1, #5
	add r2, r1, #0x1d
	add r2, r0, r2, lsl #5
	mov r1, r4
	mov r3, r4
	add r0, r5, r7, lsl #1
_02006A8C:
	lsl r8, r3, #1
	ldrh ip, [r8, r0]
	add r8, r2, r3, lsl #1
	add lr, r0, r3, lsl #1
	strh ip, [r8, #2]
	ldrh ip, [lr, #2]
	add r1, r1, #1
	cmp r1, #8
	strh ip, [r8, #0x20]
	ldrh ip, [lr, #0x20]
	add r3, r3, #2
	strh ip, [r8, #0x22]
	ldrh ip, [lr, #0x22]
	strh ip, [r8, #0x40]
	blt _02006A8C
	add r6, r6, #1
	cmp r6, #2
	add r7, r7, #0x20
	blt _02006A6C
	pop {r4, r5, r6, r7, r8, pc}
	.align 2, 0
_02006ADC: .4byte 0x02314A30
	arm_func_end FUN_02006A54

	arm_func_start FUN_02006AE0
FUN_02006AE0: @ 0x02006AE0
	push {r3, r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0x14
	ldr r1, _02006BC4 @ =0x023141F0
	mov r6, r0
	ldrh r2, [r1, #2]
	ldrh r3, [r1]
	ldr r5, _02006BC8 @ =0x00000199
	strh r2, [sp, #0x10]
	strh r3, [sp, #0xe]
	ldrh r2, [r1, #0xa]
	ldrh r0, [r1, #0xc]
	mov r4, #0xc
	mov r8, #0
	strh r2, [sp, #6]
	strh r0, [sp, #8]
	ldrh r2, [r1, #0xe]
	ldrh r0, [r1, #0x10]
	mov r7, #0x20
	strh r2, [sp, #0xa]
	strh r0, [sp, #0xc]
	ldrh r2, [r1, #4]
	ldrh r0, [r1, #6]
	strh r2, [sp]
	strh r0, [sp, #2]
	ldrh r0, [r1, #8]
	strh r0, [sp, #4]
_02006B48:
	bl FUN_02007658
	add r1, r0, r5, lsl #5
	mov r0, r8
	mov r2, r7
	bl FUN_0200A098
	add r4, r4, #1
	cmp r4, #0x12
	add r5, r5, #0x20
	blt _02006B48
	cmp r6, #0
	add r3, sp, #0xe
	mov r0, #0
	mov r1, #0xc8
	bne _02006B8C
	mov r2, #0x68
	bl FUN_020069D4
	b _02006B94
_02006B8C:
	mov r2, #0x78
	bl FUN_020069D4
_02006B94:
	add r3, sp, #6
	mov r0, #0
	mov r1, #0xd0
	mov r2, #0x68
	bl FUN_020069D4
	add r3, sp, #0
	mov r0, #0
	mov r1, #0xd0
	mov r2, #0x78
	bl FUN_020069D4
	add sp, sp, #0x14
	pop {r3, r4, r5, r6, r7, r8, pc}
	.align 2, 0
_02006BC4: .4byte 0x023141F0
_02006BC8: .4byte 0x00000199
	arm_func_end FUN_02006AE0

	arm_func_start FUN_02006BCC
FUN_02006BCC: @ 0x02006BCC
	push {r4, lr}
	mov r4, r0
	bl FUN_0200768C
	cmp r4, #0
	bge _02006BF8
	mov r1, #0
	strh r1, [r0, #0x3c]
	strh r1, [r0, #0x3e]
	strh r1, [r0, #0x7c]
	strh r1, [r0, #0x7e]
	pop {r4, pc}
_02006BF8:
	lsl r3, r4, #2
	add r1, r3, #0x1c
	add ip, r1, #0x3000
	add r1, r3, #0x1d
	add r2, r3, #0x1e
	strh ip, [r0, #0x3c]
	add r1, r1, #0x3000
	strh r1, [r0, #0x3e]
	add r1, r2, #0x3000
	add r3, r3, #0x1f
	strh r1, [r0, #0x7c]
	add r1, r3, #0x3000
	strh r1, [r0, #0x7e]
	pop {r4, pc}
	arm_func_end FUN_02006BCC

	arm_func_start FUN_02006C30
FUN_02006C30: @ 0x02006C30
	push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x10
	ldr r3, _02006CE0 @ =0x0234610C
	mov r7, #0
	strh r1, [r3, #2]
	strh r0, [r3]
	strh r2, [r3, #4]
	str r2, [sp, #8]
	ldr sb, _02006CE4 @ =0x02346112
	mov lr, r7
	str r7, [sp]
	str r0, [sp, #4]
	str r1, [sp, #0xc]
	add r2, sp, #0
	mov r3, r7
	mov ip, r7
_02006C70:
	ldr r8, [r2, lr, lsl #2]
	mov r4, #0
_02006C78:
	ldr r0, [r2, r4, lsl #2]
	mov r5, ip
_02006C80:
	ldr r1, [r2, r5, lsl #2]
	mov r6, r3
_02006C88:
	ldr fp, [r2, r6, lsl #2]
	lsl sl, r7, #1
	lsl fp, fp, #0xc
	orr fp, fp, r1, lsl #8
	orr fp, fp, r0, lsl #4
	orr fp, r8, fp
	strh fp, [sb, sl]
	add r6, r6, #1
	cmp r6, #4
	add r7, r7, #1
	blt _02006C88
	add r5, r5, #1
	cmp r5, #4
	blt _02006C80
	add r4, r4, #1
	cmp r4, #4
	blt _02006C78
	add lr, lr, #1
	cmp lr, #4
	blt _02006C70
	add sp, sp, #0x10
	pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	.align 2, 0
_02006CE0: .4byte 0x0234610C
_02006CE4: .4byte 0x02346112
	arm_func_end FUN_02006C30

	arm_func_start FUN_02006CE8
FUN_02006CE8: @ 0x02006CE8
	ldrh r3, [r0]
	ldr r2, _02006E30 @ =0x02346112
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1]
	ldrh r3, [r0]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #2]
	ldrh r3, [r0, #2]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #4]
	ldrh r3, [r0, #2]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #6]
	ldrh r3, [r0, #4]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #8]
	ldrh r3, [r0, #4]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #0xa]
	ldrh r3, [r0, #6]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #0xc]
	ldrh r3, [r0, #6]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #0xe]
	ldrh r3, [r0, #8]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x10]
	ldrh r3, [r0, #8]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x12]
	ldrh r3, [r0, #0xa]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x14]
	ldrh r3, [r0, #0xa]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x16]
	ldrh r3, [r0, #0xc]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x18]
	ldrh r3, [r0, #0xc]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x17
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x1a]
	ldrh r3, [r0, #0xe]
	lsr r3, r3, #8
	lsl r3, r3, #1
	ldrh r3, [r2, r3]
	strh r3, [r1, #0x1c]
	ldrh r0, [r0, #0xe]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x17
	ldrh r0, [r2, r0]
	strh r0, [r1, #0x1e]
	bx lr
	.align 2, 0
_02006E30: .4byte 0x02346112
	arm_func_end FUN_02006CE8

	arm_func_start FUN_02006E34
FUN_02006E34: @ 0x02006E34
	cmp r1, #0
	moveq r1, #0
	strheq r1, [r0]
	bxeq lr
	cmp r1, #0
	orrgt r1, r1, #0x4000
	strhgt r1, [r0]
	rsble r1, r1, #0
	orrle r1, r1, #0x8000
	strhle r1, [r0]
	bx lr
	arm_func_end FUN_02006E34

	arm_func_start FUN_02006E60
FUN_02006E60: @ 0x02006E60
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r3, _02006EC8 @ =0x0231CF10
	mov lr, #0x4000000
	ldrh ip, [r3]
	ldr lr, [lr]
	ldr r3, _02006ECC @ =0x02346318
	cmp ip, #0
	strh r0, [r3]
	ldr r3, _02006ED0 @ =0xFFF0FFF0
	moveq r0, #0
	and r3, lr, r3
	orr r0, r3, r0, lsl #16
	orr r0, r1, r0
	orr r1, r0, r2, lsl #3
	mov ip, #0x4000000
	ldr r0, _02006ECC @ =0x02346318
	str r1, [ip]
	ldrh r0, [r0]
	cmp r0, #0
	ldreq r0, _02006EC8 @ =0x0231CF10
	moveq r1, #0
	strheq r1, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02006EC8: .4byte 0x0231CF10
_02006ECC: .4byte 0x02346318
_02006ED0: .4byte 0xFFF0FFF0
	arm_func_end FUN_02006E60

	arm_func_start FUN_02006ED4
FUN_02006ED4: @ 0x02006ED4
	ldr r0, _02006F18 @ =0x02346318
	ldr r1, _02006F1C @ =0x0231CF10
	ldrh r2, [r0]
	mov r0, #1
	strh r0, [r1]
	cmp r2, #0
	moveq r1, #0x4000000
	ldreq r0, [r1]
	orreq r0, r0, #0x10000
	streq r0, [r1]
	bxeq lr
	mov r1, #0x4000000
	ldr r0, [r1]
	bic r0, r0, #0x30000
	orr r0, r0, r2, lsl #16
	str r0, [r1]
	bx lr
	.align 2, 0
_02006F18: .4byte 0x02346318
_02006F1C: .4byte 0x0231CF10
	arm_func_end FUN_02006ED4

	arm_func_start FUN_02006F20
FUN_02006F20: @ 0x02006F20
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov lr, #0x4000000
	ldr ip, [lr]
	ldr r1, _02006F60 @ =0x0231CF10
	and r2, ip, #0x30000
	mov r3, #0
	ldr r0, _02006F64 @ =0x02346318
	lsr r2, r2, #0x10
	strh r3, [r1]
	strh r2, [r0]
	bic r0, ip, #0x30000
	str r0, [lr]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02006F60: .4byte 0x0231CF10
_02006F64: .4byte 0x02346318
	arm_func_end FUN_02006F20

	arm_func_start FUN_02006F68
FUN_02006F68: @ 0x02006F68
	ldr r2, _02006F94 @ =0x04000004
	cmp r0, #0
	ldrh r0, [r2]
	ldrhne r1, [r2]
	and r0, r0, #8
	orrne r1, r1, #8
	strhne r1, [r2]
	ldrheq r1, [r2]
	biceq r1, r1, #8
	strheq r1, [r2]
	bx lr
	.align 2, 0
_02006F94: .4byte 0x04000004
	arm_func_end FUN_02006F68

	arm_func_start FUN_02006F98
FUN_02006F98: @ 0x02006F98
	push {r4, r5, r6, lr}
	ldr r3, _020070D8 @ =0x04000304
	ldr r0, _020070DC @ =0xFFFFFDF1
	ldrh r2, [r3]
	ldr r1, _020070E0 @ =0x0000020E
	orr r2, r2, #0x8000
	strh r2, [r3]
	ldrh r2, [r3]
	and r0, r2, r0
	orr r0, r0, r1
	strh r0, [r3]
	ldrh r0, [r3]
	orr r0, r0, #1
	strh r0, [r3]
	bl FUN_0200711C
	ldr r5, _020070E4 @ =0x02346314
	ldrh r0, [r5]
	cmp r0, #0
	bne _0200700C
	mvn r4, #2
_02006FE8:
	bl FUN_02007B74
	mov r6, r0
	cmp r6, r4
	bne _02006FFC
	bl FUN_02009D48
_02006FFC:
	strh r6, [r5]
	ldrh r0, [r5]
	cmp r0, #0
	beq _02006FE8
_0200700C:
	ldr r0, _020070E8 @ =0x04000004
	mov r2, #0
	strh r2, [r0]
	mov r1, #0x4000000
	ldr r0, _020070EC @ =0x0231CF14
	str r2, [r1]
	ldr r0, [r0]
	mvn r1, #0
	cmp r0, r1
	beq _02007064
	ldr r1, _020070F0 @ =0x04000008
	mov r3, #0x60
	bl FUN_0200A008
	ldr r1, _020070F4 @ =0x0400006C
	mov r2, #0
	ldr r0, _020070EC @ =0x0231CF14
	strh r2, [r1]
	ldr r0, [r0]
	ldr r1, _020070F8 @ =0x04001000
	mov r3, #0x70
	bl FUN_0200A008
	b _0200708C
_02007064:
	ldr r1, _020070F0 @ =0x04000008
	mov r0, r2
	mov r2, #0x60
	bl FUN_0200A0CC
	ldr r3, _020070F4 @ =0x0400006C
	mov r0, #0
	ldr r1, _020070F8 @ =0x04001000
	mov r2, #0x70
	strh r0, [r3]
	bl FUN_0200A0CC
_0200708C:
	ldr r1, _020070FC @ =0x04000020
	mov r2, #0x100
	ldr r0, _02007100 @ =0x04000026
	strh r2, [r1]
	ldr r1, _02007104 @ =0x04000030
	strh r2, [r0]
	ldr r0, _02007108 @ =0x04000036
	strh r2, [r1]
	ldr r1, _0200710C @ =0x04001020
	strh r2, [r0]
	ldr r0, _02007110 @ =0x04001026
	strh r2, [r1]
	ldr r1, _02007114 @ =0x04001030
	strh r2, [r0]
	ldr r0, _02007118 @ =0x04001036
	strh r2, [r1]
	strh r2, [r0]
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_020070D8: .4byte 0x04000304
_020070DC: .4byte 0xFFFFFDF1
_020070E0: .4byte 0x0000020E
_020070E4: .4byte 0x02346314
_020070E8: .4byte 0x04000004
_020070EC: .4byte 0x0231CF14
_020070F0: .4byte 0x04000008
_020070F4: .4byte 0x0400006C
_020070F8: .4byte 0x04001000
_020070FC: .4byte 0x04000020
_02007100: .4byte 0x04000026
_02007104: .4byte 0x04000030
_02007108: .4byte 0x04000036
_0200710C: .4byte 0x04001020
_02007110: .4byte 0x04001026
_02007114: .4byte 0x04001030
_02007118: .4byte 0x04001036
	arm_func_end FUN_02006F98

	arm_func_start FUN_0200711C
FUN_0200711C: @ 0x0200711C
	ldr r0, _02007184 @ =0x0234631C
	mov r3, #0
	ldr r2, _02007188 @ =0x04000240
	strh r3, [r0]
	strh r3, [r0, #2]
	strh r3, [r0, #4]
	strh r3, [r0, #6]
	strh r3, [r0, #8]
	strh r3, [r0, #0xa]
	strh r3, [r0, #0xc]
	strh r3, [r0, #0xe]
	strh r3, [r0, #0x10]
	strh r3, [r0, #0x12]
	strh r3, [r0, #0x14]
	strh r3, [r0, #0x16]
	strh r3, [r0, #0x18]
	ldr r1, _0200718C @ =0x04000244
	str r3, [r2]
	ldr r0, _02007190 @ =0x04000245
	strb r3, [r1]
	ldr r1, _02007194 @ =0x04000246
	strb r3, [r0]
	ldr r0, _02007198 @ =0x04000248
	strb r3, [r1]
	strh r3, [r0]
	bx lr
	.align 2, 0
_02007184: .4byte 0x0234631C
_02007188: .4byte 0x04000240
_0200718C: .4byte 0x04000244
_02007190: .4byte 0x04000245
_02007194: .4byte 0x04000246
_02007198: .4byte 0x04000248
	arm_func_end FUN_0200711C

	arm_func_start FUN_0200719C
FUN_0200719C: @ 0x0200719C
	ldr ip, _020071A8 @ =0x023025F0
	ldr r0, _020071AC @ =0x0234631C
	bx ip
	.align 2, 0
_020071A8: .4byte 0x023025F0
_020071AC: .4byte 0x0234631C
	arm_func_end FUN_0200719C

	arm_func_start FUN_020071B0
FUN_020071B0: @ 0x020071B0
	push {r4, lr}
	ldrh r4, [r0]
	mov r1, #0
	strh r1, [r0]
	ands r0, r4, #1
	ldrne r0, _0200726C @ =0x04000240
	strbne r1, [r0]
	ands r0, r4, #2
	ldrne r0, _02007270 @ =0x04000241
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #4
	ldrne r0, _02007274 @ =0x04000242
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #8
	ldrne r0, _02007278 @ =0x04000243
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #0x10
	ldrne r0, _0200727C @ =0x04000244
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #0x20
	ldrne r0, _02007280 @ =0x04000245
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #0x40
	ldrne r0, _02007284 @ =0x04000246
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #0x80
	ldrne r0, _02007288 @ =0x04000248
	movne r1, #0
	strbne r1, [r0]
	ands r0, r4, #0x100
	ldrne r0, _0200728C @ =0x04000249
	movne r1, #0
	strbne r1, [r0]
	ldr r1, _02007290 @ =0x02346314
	lsl r0, r4, #0x10
	ldrh r1, [r1]
	lsr r0, r0, #0x10
	bl FUN_02009C80
	mov r0, r4
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200726C: .4byte 0x04000240
_02007270: .4byte 0x04000241
_02007274: .4byte 0x04000242
_02007278: .4byte 0x04000243
_0200727C: .4byte 0x04000244
_02007280: .4byte 0x04000245
_02007284: .4byte 0x04000246
_02007288: .4byte 0x04000248
_0200728C: .4byte 0x04000249
_02007290: .4byte 0x02346314
	arm_func_end FUN_020071B0

	arm_func_start FUN_02007294
FUN_02007294: @ 0x02007294
	ldr r1, _020072AC @ =0x0234631C
	ldr ip, _020072B0 @ =0x023029AC
	ldrh r2, [r1]
	orr r2, r2, r0
	strh r2, [r1]
	bx ip
	.align 2, 0
_020072AC: .4byte 0x0234631C
_020072B0: .4byte 0x023029AC
	arm_func_end FUN_02007294

	arm_func_start FUN_020072B4
FUN_020072B4: @ 0x020072B4
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200754C @ =0x0234631C
	mvn ip, r0
	ldrh r2, [r1, #2]
	ldrh r3, [r1]
	cmp r0, #0x40
	strh r0, [r1, #2]
	orr r2, r3, r2
	and r2, ip, r2
	strh r2, [r1]
	bgt _02007390
	cmp r0, #0x40
	bge _02007528
	cmp r0, #0x20
	bgt _02007384
	cmp r0, #0
	addge pc, pc, r0, lsl #2
	b _02007534
_02007300: @ jump table
	b _02007534 @ case 0
	b FUN_02007430 @ case 1
	b FUN_020073FC @ case 2
	b FUN_02007424 @ case 3
	b FUN_020073D4 @ case 4
	b FUN_02007474 @ case 5
	b FUN_020073F0 @ case 6
	b FUN_02007418 @ case 7
	b FUN_020073B8 @ case 8
	b FUN_02007490 @ case 9
	b FUN_020074AC @ case 10
	b FUN_02007440 @ case 11
	b FUN_020073C8 @ case 12
	b FUN_02007468 @ case 13
	b FUN_020073E4 @ case 14
	b FUN_0200740C @ case 15
	b FUN_020074E0 @ case 16
	b _02007534 @ case 17
	b _02007534 @ case 18
	b _02007534 @ case 19
	b _02007534 @ case 20
	b _02007534 @ case 21
	b _02007534 @ case 22
	b _02007534 @ case 23
	b _02007534 @ case 24
	b _02007534 @ case 25
	b _02007534 @ case 26
	b _02007534 @ case 27
	b _02007534 @ case 28
	b _02007534 @ case 29
	b _02007534 @ case 30
	b _02007534 @ case 31
	b FUN_02007518 @ case 32
_02007384:
	cmp r0, #0x30
	beq _020074D4
	b _02007534
_02007390:
	cmp r0, #0x60
	bgt _020073AC
	cmp r0, #0x60
	bge _0200750C
	cmp r0, #0x50
	beq _020074F0
	b _02007534
_020073AC:
	cmp r0, #0x70
	beq _020074C8
	b _02007534
	arm_func_end FUN_020072B4

	arm_func_start FUN_020073B8
FUN_020073B8: @ 0x020073B8
	ldr r0, _02007550 @ =0x04000243
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_020073B8

	arm_func_start FUN_020073C8
FUN_020073C8: @ 0x020073C8
	ldr r0, _02007550 @ =0x04000243
	mov r1, #0x89
	strb r1, [r0]
	ldr r0, _02007554 @ =0x04000242
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_020073C8

	arm_func_start FUN_020073E4
FUN_020073E4: @ 0x020073E4
	ldr r0, _02007550 @ =0x04000243
	mov r1, #0x91
	strb r1, [r0]
	ldr r0, _02007554 @ =0x04000242
	mov r1, #0x89
	strb r1, [r0]
	ldr r0, _02007558 @ =0x04000241
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_020073E4

	arm_func_start FUN_0200740C
FUN_0200740C: @ 0x0200740C
	ldr r0, _02007550 @ =0x04000243
	mov r1, #0x99
	strb r1, [r0]
	ldr r0, _02007554 @ =0x04000242
	mov r1, #0x91
	strb r1, [r0]
	ldr r0, _02007558 @ =0x04000241
	mov r1, #0x89
	strb r1, [r0]
	ldr r0, _0200755C @ =0x04000240
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_0200740C

	arm_func_start FUN_02007440
FUN_02007440: @ 0x02007440
	ldr r0, _0200755C @ =0x04000240
	mov r2, #0x81
	ldr r1, _02007558 @ =0x04000241
	strb r2, [r0]
	mov r2, #0x89
	ldr r0, _02007550 @ =0x04000243
	strb r2, [r1]
	mov r1, #0x91
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_02007440

	arm_func_start FUN_02007468
FUN_02007468: @ 0x02007468
	ldr r0, _02007550 @ =0x04000243
	mov r1, #0x91
	strb r1, [r0]
	ldr r1, _0200755C @ =0x04000240
	mov r2, #0x81
	ldr r0, _02007554 @ =0x04000242
	strb r2, [r1]
	mov r1, #0x89
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_02007468

	arm_func_start FUN_02007490
FUN_02007490: @ 0x02007490
	ldr r1, _0200755C @ =0x04000240
	mov r2, #0x81
	ldr r0, _02007550 @ =0x04000243
	strb r2, [r1]
	mov r1, #0x89
	strb r1, [r0]
	b _02007534
	arm_func_end FUN_02007490

	arm_func_start FUN_020074AC
FUN_020074AC: @ 0x020074AC
	ldr r1, _02007558 @ =0x04000241
	mov r2, #0x81
	ldr r0, _02007550 @ =0x04000243
	strb r2, [r1]
	mov r1, #0x89
	strb r1, [r0]
	b _02007534
_020074C8:
	ldr r0, _02007560 @ =0x04000246
	mov r1, #0x99
	strb r1, [r0]
_020074D4:
	ldr r0, _02007564 @ =0x04000245
	mov r1, #0x91
	strb r1, [r0]
	ldr r0, _02007568 @ =0x04000244
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
_020074F0:
	ldr r1, _02007560 @ =0x04000246
	mov r2, #0x91
	ldr r0, _02007568 @ =0x04000244
	strb r2, [r1]
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
_0200750C:
	ldr r0, _02007560 @ =0x04000246
	mov r1, #0x89
	strb r1, [r0]
	ldr r0, _02007564 @ =0x04000245
	mov r1, #0x81
	strb r1, [r0]
	b _02007534
_02007528:
	ldr r0, _02007560 @ =0x04000246
	mov r1, #0x81
	strb r1, [r0]
_02007534:
	ldr r0, _0200754C @ =0x0234631C
	ldrh r0, [r0]
	bl FUN_0200756C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200754C: .4byte 0x0234631C
_02007550: .4byte 0x04000243
_02007554: .4byte 0x04000242
_02007558: .4byte 0x04000241
_0200755C: .4byte 0x04000240
_02007560: .4byte 0x04000246
_02007564: .4byte 0x04000245
_02007568: .4byte 0x04000244
	arm_func_end FUN_020074AC

	arm_func_start FUN_0200756C
FUN_0200756C: @ 0x0200756C
	ands r1, r0, #1
	ldrne r1, _02007600 @ =0x04000240
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #2
	ldrne r1, _02007604 @ =0x04000241
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #4
	ldrne r1, _02007608 @ =0x04000242
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #8
	ldrne r1, _0200760C @ =0x04000243
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #0x10
	ldrne r1, _02007610 @ =0x04000244
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #0x20
	ldrne r1, _02007614 @ =0x04000245
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #0x40
	ldrne r1, _02007618 @ =0x04000246
	movne r2, #0x80
	strbne r2, [r1]
	ands r1, r0, #0x80
	ldrne r1, _0200761C @ =0x04000248
	movne r2, #0x80
	strbne r2, [r1]
	ands r0, r0, #0x100
	ldrne r0, _02007620 @ =0x04000249
	movne r1, #0x80
	strbne r1, [r0]
	bx lr
	.align 2, 0
_02007600: .4byte 0x04000240
_02007604: .4byte 0x04000241
_02007608: .4byte 0x04000242
_0200760C: .4byte 0x04000243
_02007610: .4byte 0x04000244
_02007614: .4byte 0x04000245
_02007618: .4byte 0x04000246
_0200761C: .4byte 0x04000248
_02007620: .4byte 0x04000249
	arm_func_end FUN_0200756C

	arm_func_start FUN_02007624
FUN_02007624: @ 0x02007624
	ldr r1, _02007654 @ =0x0400000A
	mov r0, #0x4000000
	ldrh r1, [r1]
	ldr r0, [r0]
	and r0, r0, #0x7000000
	lsr r0, r0, #0x18
	and r1, r1, #0x3c
	lsl r0, r0, #0x10
	asr r1, r1, #2
	add r0, r0, #0x6000000
	add r0, r0, r1, lsl #14
	bx lr
	.align 2, 0
_02007654: .4byte 0x0400000A
	arm_func_end FUN_02007624

	arm_func_start FUN_02007658
FUN_02007658: @ 0x02007658
	ldr r1, _02007688 @ =0x04000008
	mov r0, #0x4000000
	ldrh r1, [r1]
	ldr r0, [r0]
	and r0, r0, #0x7000000
	lsr r0, r0, #0x18
	and r1, r1, #0x3c
	lsl r0, r0, #0x10
	asr r1, r1, #2
	add r0, r0, #0x6000000
	add r0, r0, r1, lsl #14
	bx lr
	.align 2, 0
_02007688: .4byte 0x04000008
	arm_func_end FUN_02007658

	arm_func_start FUN_0200768C
FUN_0200768C: @ 0x0200768C
	ldr r1, _020076BC @ =0x0400000A
	mov r0, #0x4000000
	ldrh r1, [r1]
	ldr r0, [r0]
	and r0, r0, #0x38000000
	lsr r0, r0, #0x1b
	and r1, r1, #0x1f00
	lsl r0, r0, #0x10
	asr r1, r1, #8
	add r0, r0, #0x6000000
	add r0, r0, r1, lsl #11
	bx lr
	.align 2, 0
_020076BC: .4byte 0x0400000A
	arm_func_end FUN_0200768C

	arm_func_start FUN_020076C0
FUN_020076C0: @ 0x020076C0
	ldr r1, _020076F0 @ =0x04000008
	mov r0, #0x4000000
	ldrh r1, [r1]
	ldr r0, [r0]
	and r0, r0, #0x38000000
	lsr r0, r0, #0x1b
	and r1, r1, #0x1f00
	lsl r0, r0, #0x10
	asr r1, r1, #8
	add r0, r0, #0x6000000
	add r0, r0, r1, lsl #11
	bx lr
	.align 2, 0
_020076F0: .4byte 0x04000008
	arm_func_end FUN_020076C0

	arm_func_start FUN_020076F4
FUN_020076F4: @ 0x020076F4
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	mov r4, r2
	bl FUN_02007624
	ldr r1, _02007758 @ =0x0231CF14
	mov ip, r0
	ldr r0, [r1]
	mvn r1, #0
	cmp r0, r1
	beq _02007740
	cmp r4, #0x30
	bls _02007740
	mov r1, r6
	mov r3, r4
	add r2, ip, r5
	bl FUN_02009F8C
	pop {r4, r5, r6, lr}
	bx lr
_02007740:
	mov r0, r6
	mov r2, r4
	add r1, ip, r5
	bl FUN_0200A0E0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_02007758: .4byte 0x0231CF14
	arm_func_end FUN_020076F4

	arm_func_start FUN_0200775C
FUN_0200775C: @ 0x0200775C
	push {r4, lr}
	ldr r3, _020077B4 @ =0x0231CF14
	mov r4, r0
	ldr r0, [r3]
	mvn ip, #0
	mov lr, r1
	mov r3, r2
	cmp r0, ip
	beq _0200779C
	cmp r3, #0x1c
	bls _0200779C
	mov r1, r4
	add r2, lr, #0x5000000
	bl FUN_02009F14
	pop {r4, lr}
	bx lr
_0200779C:
	mov r0, r4
	mov r2, r3
	add r1, lr, #0x5000000
	bl FUN_0200A0B0
	pop {r4, lr}
	bx lr
	.align 2, 0
_020077B4: .4byte 0x0231CF14
	arm_func_end FUN_0200775C

	arm_func_start FUN_020077B8
FUN_020077B8: @ 0x020077B8
	push {r4, r5, r6, lr}
	mov r5, r0
	mov r4, r1
	bl FUN_02009A90
	cmp r5, #0
	beq _020077E8
	ldr r1, _0200782C @ =0x027E0000
	mvn r2, r4
	add r1, r1, #0x3000
	ldr r3, [r1, #0xff8]
	and r2, r3, r2
	str r2, [r1, #0xff8]
_020077E8:
	bl FUN_02009AA4
	ldr r1, _0200782C @ =0x027E0000
	add r0, r1, #0x3000
	ldr r0, [r0, #0xff8]
	ands r0, r4, r0
	popne {r4, r5, r6, lr}
	bxne lr
	ldr r0, _02007830 @ =0x00003FF8
	add r6, r1, r0
	ldr r5, _02007834 @ =0x027E0060
_02007810:
	mov r0, r5
	bl FUN_0200819C
	ldr r0, [r6]
	ands r0, r4, r0
	beq _02007810
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200782C: .4byte 0x027E0000
_02007830: .4byte 0x00003FF8
_02007834: .4byte 0x027E0060
	arm_func_end FUN_020077B8

	arm_func_start FUN_02007838
FUN_02007838: @ 0x02007838
	ldr ip, _02007844 @ =0x02302CF8
	mov r0, #7
	bx ip
	.align 2, 0
_02007844: .4byte 0x02302CF8
	arm_func_end FUN_02007838

	arm_func_start FUN_02007848
FUN_02007848: @ 0x02007848
	ldr ip, _02007854 @ =0x02302CF8
	mov r0, #6
	bx ip
	.align 2, 0
_02007854: .4byte 0x02302CF8
	arm_func_end FUN_02007848

	arm_func_start FUN_02007858
FUN_02007858: @ 0x02007858
	ldr ip, _02007864 @ =0x02302CF8
	mov r0, #5
	bx ip
	.align 2, 0
_02007864: .4byte 0x02302CF8
	arm_func_end FUN_02007858

	arm_func_start FUN_02007868
FUN_02007868: @ 0x02007868
	ldr ip, _02007874 @ =0x02302CF8
	mov r0, #4
	bx ip
	.align 2, 0
_02007874: .4byte 0x02302CF8
	arm_func_end FUN_02007868

	arm_func_start FUN_02007878
FUN_02007878: @ 0x02007878
	ldr ip, _02007884 @ =0x02302CF8
	mov r0, #3
	bx ip
	.align 2, 0
_02007884: .4byte 0x02302CF8
	arm_func_end FUN_02007878

	arm_func_start FUN_02007888
FUN_02007888: @ 0x02007888
	ldr ip, _02007894 @ =0x02302CF8
	mov r0, #2
	bx ip
	.align 2, 0
_02007894: .4byte 0x02302CF8
	arm_func_end FUN_02007888

	arm_func_start FUN_02007898
FUN_02007898: @ 0x02007898
	ldr ip, _020078A4 @ =0x02302CF8
	mov r0, #1
	bx ip
	.align 2, 0
_020078A4: .4byte 0x02302CF8
	arm_func_end FUN_02007898

	arm_func_start FUN_020078A8
FUN_020078A8: @ 0x020078A8
	ldr ip, _020078B4 @ =0x02302CF8
	mov r0, #0
	bx ip
	.align 2, 0
_020078B4: .4byte 0x02302CF8
	arm_func_end FUN_020078A8

	arm_func_start FUN_020078B8
FUN_020078B8: @ 0x020078B8
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r1, #0xc
	mul r4, r0, r1
	ldr r2, _02007940 @ =0x02346338
	ldr r3, _02007944 @ =0x0231CF18
	lsl r0, r0, #1
	ldr r1, [r2, r4]
	ldrh r3, [r3, r0]
	mov r5, #1
	mov r0, #0
	str r0, [r2, r4]
	cmp r1, #0
	lsl r5, r5, r3
	beq _02007900
	ldr r0, _02007948 @ =0x02346340
	ldr r0, [r0, r4]
	.word 0xE12FFF31
_02007900:
	ldr r0, _0200794C @ =0x027E0000
	ldr r1, _02007950 @ =0x0234633C
	add r0, r0, #0x3000
	ldr r2, [r0, #0xff8]
	orr r2, r2, r5
	str r2, [r0, #0xff8]
	ldr r0, [r1, r4]
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	mov r0, r5
	bl FUN_020079C0
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02007940: .4byte 0x02346338
_02007944: .4byte 0x0231CF18
_02007948: .4byte 0x02346340
_0200794C: .4byte 0x027E0000
_02007950: .4byte 0x0234633C
	arm_func_end FUN_020078B8

	arm_func_start FUN_02007954
FUN_02007954: @ 0x02007954
	bx lr
	arm_func_end FUN_02007954

	arm_func_start FUN_02007958
FUN_02007958: @ 0x02007958
	ldr ip, _0200797C @ =0x027E0000
	ldr r3, _02007980 @ =0xFDDB597D
	add r0, ip, #0x3000
	ldr r2, _02007984 @ =0x7BF9DD5B
	ldr r1, _02007988 @ =0x00000800
	str r3, [r0, #0xf7c]
	add r0, ip, #0x3f80
	str r2, [r0, -r1]
	bx lr
	.align 2, 0
_0200797C: .4byte 0x027E0000
_02007980: .4byte 0xFDDB597D
_02007984: .4byte 0x7BF9DD5B
_02007988: .4byte 0x00000800
	arm_func_end FUN_02007958

	arm_func_start FUN_0200798C
FUN_0200798C: @ 0x0200798C
	ldr ip, _020079B8 @ =0x04000208
	mov r1, #0
	ldrh r3, [ip]
	ldr r2, _020079BC @ =0x04000214
	strh r1, [ip]
	ldr r1, [r2]
	str r0, [r2]
	ldrh r0, [ip]
	mov r0, r1
	strh r3, [ip]
	bx lr
	.align 2, 0
_020079B8: .4byte 0x04000208
_020079BC: .4byte 0x04000214
	arm_func_end FUN_0200798C

	arm_func_start FUN_020079C0
FUN_020079C0: @ 0x020079C0
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr lr, _02007A00 @ =0x04000208
	mov r3, #0
	ldrh ip, [lr]
	ldr r2, _02007A04 @ =0x04000210
	mvn r1, r0
	strh r3, [lr]
	ldr r0, [r2]
	and r1, r0, r1
	str r1, [r2]
	ldrh r1, [lr]
	strh ip, [lr]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02007A00: .4byte 0x04000208
_02007A04: .4byte 0x04000210
	arm_func_end FUN_020079C0

	arm_func_start FUN_02007A08
FUN_02007A08: @ 0x02007A08
	ldr ip, _02007A38 @ =0x04000208
	mov r1, #0
	ldrh r3, [ip]
	ldr r2, _02007A3C @ =0x04000210
	strh r1, [ip]
	ldr r1, [r2]
	orr r0, r1, r0
	str r0, [r2]
	ldrh r0, [ip]
	mov r0, r1
	strh r3, [ip]
	bx lr
	.align 2, 0
_02007A38: .4byte 0x04000208
_02007A3C: .4byte 0x04000210
	arm_func_end FUN_02007A08

	arm_func_start FUN_02007A40
FUN_02007A40: @ 0x02007A40
	ldr ip, _02007A6C @ =0x04000208
	mov r1, #0
	ldrh r3, [ip]
	ldr r2, _02007A70 @ =0x04000210
	strh r1, [ip]
	ldr r1, [r2]
	str r0, [r2]
	ldrh r0, [ip]
	mov r0, r1
	strh r3, [ip]
	bx lr
	.align 2, 0
_02007A6C: .4byte 0x04000208
_02007A70: .4byte 0x04000210
	arm_func_end FUN_02007A40

	arm_func_start FUN_02007A74
FUN_02007A74: @ 0x02007A74
	push {r4, lr}
	mov r3, #0xc
	mul r4, r0, r3
	ldr ip, _02007AB4 @ =0x02346368
	add r0, r0, #3
	mov r3, #1
	lsl r0, r3, r0
	ldr r3, _02007AB8 @ =0x02346370
	str r1, [ip, r4]
	str r2, [r3, r4]
	bl FUN_02007A08
	ldr r0, _02007ABC @ =0x0234636C
	mov r1, #1
	str r1, [r0, r4]
	pop {r4, lr}
	bx lr
	.align 2, 0
_02007AB4: .4byte 0x02346368
_02007AB8: .4byte 0x02346370
_02007ABC: .4byte 0x0234636C
	arm_func_end FUN_02007A74

	arm_func_start FUN_02007AC0
FUN_02007AC0: @ 0x02007AC0
	push {r4, r5, r6, r7, r8, lr}
	mov r8, #0
	ldr lr, _02007B48 @ =0x027E0000
	ldr r5, _02007B4C @ =0x02346338
	mov r6, r8
	mov ip, r8
	mov r3, #1
	mov r2, #0xc
_02007AE0:
	ands r4, r0, #1
	beq _02007B30
	mov r7, r6
	cmp r8, #8
	blt _02007B04
	cmp r8, #0xb
	suble r4, r8, #8
	mlale r7, r4, r2, r5
	ble _02007B20
_02007B04:
	cmp r8, #3
	blt _02007B1C
	cmp r8, #6
	addle r4, r8, #1
	mlale r7, r4, r2, r5
	ble _02007B20
_02007B1C:
	str r1, [lr, r8, lsl #2]
_02007B20:
	cmp r7, #0
	strne r1, [r7]
	strne ip, [r7, #8]
	strne r3, [r7, #4]
_02007B30:
	add r8, r8, #1
	cmp r8, #0x16
	lsr r0, r0, #1
	blt _02007AE0
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_02007B48: .4byte 0x027E0000
_02007B4C: .4byte 0x02346338
	arm_func_end FUN_02007AC0

	arm_func_start FUN_02007B50
FUN_02007B50: @ 0x02007B50
	ldr r0, _02007B64 @ =0x027E0060
	mov r1, #0
	str r1, [r0, #4]
	str r1, [r0]
	bx lr
	.align 2, 0
_02007B64: .4byte 0x027E0060
	arm_func_end FUN_02007B50

	arm_func_start FUN_02007B68
FUN_02007B68: @ 0x02007B68
	ldr r1, _02007B70 @ =FUN_023030CC
	bx r1
	.align 2, 0
_02007B70: .4byte FUN_023030CC
	arm_func_end FUN_02007B68

	arm_func_start FUN_02007B74
FUN_02007B74: @ 0x02007B74
	ldr r3, _02007BC4 @ =0x027FFFB0
	ldr r1, [r3]
	clz r2, r1
	cmp r2, #0x20
	movne r0, #0x40
	bne _02007BA8
	add r3, r3, #4
	ldr r1, [r3]
	clz r2, r1
	cmp r2, #0x20
	ldr r0, _02007BC8 @ =0xFFFFFFFD
	bxeq lr
	mov r0, #0x60
_02007BA8:
	add r0, r0, r2
	mov r1, #0x80000000
	lsr r1, r1, r2
	ldr r2, [r3]
	bic r2, r2, r1
	str r2, [r3]
	bx lr
	.align 2, 0
_02007BC4: .4byte 0x027FFFB0
_02007BC8: .4byte 0xFFFFFFFD
	arm_func_end FUN_02007B74

	arm_func_start FUN_02007BCC
FUN_02007BCC: @ 0x02007BCC
	ldrh r0, [r0, #4]
	bx lr
	arm_func_end FUN_02007BCC

	arm_func_start FUN_02007BD4
FUN_02007BD4: @ 0x02007BD4
	ldr r1, _02007BE8 @ =0x04000204
	ldrh r0, [r1]
	orr r0, r0, #0x800
	strh r0, [r1]
	bx lr
	.align 2, 0
_02007BE8: .4byte 0x04000204
	arm_func_end FUN_02007BD4

	arm_func_start FUN_02007BEC
FUN_02007BEC: @ 0x02007BEC
	ldr r1, _02007C00 @ =0x04000204
	ldrh r0, [r1]
	bic r0, r0, #0x800
	strh r0, [r1]
	bx lr
	.align 2, 0
_02007C00: .4byte 0x04000204
	arm_func_end FUN_02007BEC

	arm_func_start FUN_02007C04
FUN_02007C04: @ 0x02007C04
	ldr ip, _02007C14 @ =0x0230316C
	ldr r1, _02007C18 @ =0x027FFFE0
	ldr r2, _02007C1C @ =0x02303014
	bx ip
	.align 2, 0
_02007C14: .4byte 0x0230316C
_02007C18: .4byte 0x027FFFE0
_02007C1C: .4byte 0x02303014
	arm_func_end FUN_02007C04

	arm_func_start FUN_02007C20
FUN_02007C20: @ 0x02007C20
	ldr ip, _02007C30 @ =0x0230320C
	ldr r1, _02007C34 @ =0x027FFFE0
	ldr r2, _02007C38 @ =0x0230302C
	bx ip
	.align 2, 0
_02007C30: .4byte 0x0230320C
_02007C34: .4byte 0x027FFFE0
_02007C38: .4byte 0x0230302C
	arm_func_end FUN_02007C20

	arm_func_start FUN_02007C3C
FUN_02007C3C: @ 0x02007C3C
	ldr r1, _02007C50 @ =0x04000204
	ldrh r0, [r1]
	orr r0, r0, #0x80
	strh r0, [r1]
	bx lr
	.align 2, 0
_02007C50: .4byte 0x04000204
	arm_func_end FUN_02007C3C

	arm_func_start FUN_02007C54
FUN_02007C54: @ 0x02007C54
	ldr r1, _02007C68 @ =0x04000204
	ldrh r0, [r1]
	bic r0, r0, #0x80
	strh r0, [r1]
	bx lr
	.align 2, 0
_02007C68: .4byte 0x04000204
	arm_func_end FUN_02007C54

	arm_func_start FUN_02007C6C
FUN_02007C6C: @ 0x02007C6C
	ldr ip, _02007C80 @ =0x023030EC
	ldr r1, _02007C84 @ =0x027FFFE8
	ldr r2, _02007C88 @ =0x02303094
	mov r3, #1
	bx ip
	.align 2, 0
_02007C80: .4byte 0x023030EC
_02007C84: .4byte 0x027FFFE8
_02007C88: .4byte 0x02303094
	arm_func_end FUN_02007C6C

	arm_func_start FUN_02007C8C
FUN_02007C8C: @ 0x02007C8C
	ldr ip, _02007CA0 @ =0x0230317C
	ldr r1, _02007CA4 @ =0x027FFFE8
	ldr r2, _02007CA8 @ =0x0230307C
	mov r3, #1
	bx ip
	.align 2, 0
_02007CA0: .4byte 0x0230317C
_02007CA4: .4byte 0x027FFFE8
_02007CA8: .4byte 0x0230307C
	arm_func_end FUN_02007C8C

	arm_func_start FUN_02007CAC
FUN_02007CAC: @ 0x02007CAC
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	movs r6, r3
	mov sb, r0
	mov r8, r1
	mov r7, r2
	beq _02007CD4
	bl FUN_02009ABC
	mov r5, r0
	b _02007CDC
_02007CD4:
	bl FUN_02009A90
	mov r5, r0
_02007CDC:
	mov r0, sb
	mov r1, r8
	bl FUN_0200A308
	movs r4, r0
	bne _02007D00
	cmp r7, #0
	beq _02007CFC
	.word 0xE12FFF37
_02007CFC:
	strh sb, [r8, #4]
_02007D00:
	cmp r6, #0
	beq _02007D14
	mov r0, r5
	bl FUN_02009AD0
	b _02007D1C
_02007D14:
	mov r0, r5
	bl FUN_02009AA4
_02007D1C:
	mov r0, r4
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_02007CAC

	arm_func_start FUN_02007D2C
FUN_02007D2C: @ 0x02007D2C
	ldr ip, _02007D38 @ =0x0230317C
	mov r3, #0
	bx ip
	.align 2, 0
_02007D38: .4byte 0x0230317C
	arm_func_end FUN_02007D2C

	arm_func_start FUN_02007D3C
FUN_02007D3C: @ 0x02007D3C
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r1
	ldrh r1, [r7, #4]
	mov r6, r2
	mov r5, r3
	cmp r0, r1
	addne sp, sp, #4
	mvnne r0, #1
	popne {r4, r5, r6, r7, lr}
	bxne lr
	cmp r5, #0
	beq _02007D7C
	bl FUN_02009ABC
	mov r4, r0
	b _02007D84
_02007D7C:
	bl FUN_02009A90
	mov r4, r0
_02007D84:
	mov r0, #0
	strh r0, [r7, #4]
	cmp r6, #0
	beq _02007D98
	.word 0xE12FFF36
_02007D98:
	mov r0, #0
	str r0, [r7]
	cmp r5, #0
	beq _02007DB4
	mov r0, r4
	bl FUN_02009AD0
	b _02007DBC
_02007DB4:
	mov r0, r4
	bl FUN_02009AA4
_02007DBC:
	mov r0, #0
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02007D3C

	arm_func_start FUN_02007DCC
FUN_02007DCC: @ 0x02007DCC
	ldr ip, _02007DD8 @ =0x0230321C
	mov r3, #0
	bx ip
	.align 2, 0
_02007DD8: .4byte 0x0230321C
	arm_func_end FUN_02007DCC

	arm_func_start FUN_02007DDC
FUN_02007DDC: @ 0x02007DDC
	push {r4, r5, r6, r7, r8, lr}
	mov r8, r0
	mov r7, r1
	mov r6, r2
	mov r5, r3
	bl FUN_02007CAC
	cmp r0, #0
	pople {r4, r5, r6, r7, r8, lr}
	bxle lr
	mov r4, #0x400
_02007E04:
	mov r0, r4
	blx SVC_WaitByLoop
	mov r0, r8
	mov r1, r7
	mov r2, r6
	mov r3, r5
	bl FUN_02007CAC
	cmp r0, #0
	bgt _02007E04
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_02007DDC

	arm_func_start FUN_02007E30
FUN_02007E30: @ 0x02007E30
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r0, _02007F08 @ =0x02346398
	ldr r1, [r0]
	cmp r1, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	mov r2, #1
	ldr r1, _02007F0C @ =0x027FFFF0
	str r2, [r0]
	mov r2, #0
	mov r0, #0x7e
	str r2, [r1]
	bl FUN_02007DCC
	ldr r5, _02007F0C @ =0x027FFFF0
	ldrh r0, [r5, #6]
	cmp r0, #0
	beq _02007E94
	mov r4, #0x400
_02007E80:
	mov r0, r4
	blx SVC_WaitByLoop
	ldrh r0, [r5, #6]
	cmp r0, #0
	bne _02007E80
_02007E94:
	ldr r2, _02007F10 @ =0x027FFFB0
	mvn ip, #0
	mov r0, #0x10000
	ldr r3, _02007F14 @ =0x027FFFB4
	ldr r1, _02007F18 @ =0x027FFFC0
	str ip, [r2]
	rsb ip, r0, #0
	mov r0, #0
	mov r2, #0x28
	str ip, [r3]
	bl FUN_0200A0CC
	ldr ip, _02007F1C @ =0x04000204
	ldr r1, _02007F0C @ =0x027FFFF0
	ldrh r3, [ip]
	mov r0, #0x7e
	mov r2, #0
	orr r3, r3, #0x800
	strh r3, [ip]
	ldrh r3, [ip]
	orr r3, r3, #0x80
	strh r3, [ip]
	bl FUN_02007D2C
	ldr r1, _02007F0C @ =0x027FFFF0
	mov r0, #0x7f
	mov r2, #0
	bl FUN_02007DCC
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02007F08: .4byte 0x02346398
_02007F0C: .4byte 0x027FFFF0
_02007F10: .4byte 0x027FFFB0
_02007F14: .4byte 0x027FFFB4
_02007F18: .4byte 0x027FFFC0
_02007F1C: .4byte 0x04000204
	arm_func_end FUN_02007E30

	arm_func_start FUN_02007F20
FUN_02007F20: @ 0x02007F20
	str r1, [r0, #0xb4]
	bx lr
	arm_func_end FUN_02007F20

	arm_func_start FUN_02007F28
FUN_02007F28: @ 0x02007F28
	push {r4, lr}
	bl FUN_02009A90
	ldr r1, _02007F5C @ =0x023463A0
	mov r4, #0
	ldr r3, [r1]
	cmp r3, #0
	subne r2, r3, #1
	movne r4, r3
	strne r2, [r1]
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, lr}
	bx lr
	.align 2, 0
_02007F5C: .4byte 0x023463A0
	arm_func_end FUN_02007F28

	arm_func_start FUN_02007F60
FUN_02007F60: @ 0x02007F60
	push {r4, lr}
	bl FUN_02009A90
	ldr r2, _02007F94 @ =0x023463A0
	mvn r1, #0
	ldr r3, [r2]
	cmp r3, r1
	addlo r1, r3, #1
	movlo r4, r3
	strlo r1, [r2]
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, lr}
	bx lr
	.align 2, 0
_02007F94: .4byte 0x023463A0
	arm_func_end FUN_02007F60

	arm_func_start FUN_02007F98
FUN_02007F98: @ 0x02007F98
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_02009A7C
_02007FA4:
	bl FUN_02009D3C
	b _02007FA4
	arm_func_end FUN_02007F98

	arm_func_start FUN_02007FAC
FUN_02007FAC: @ 0x02007FAC
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	bl FUN_02009A90
	ldr r1, _02007FDC @ =0x023463B4
	ldr r4, [r1, #0xc]
	str r5, [r1, #0xc]
	bl FUN_02009AA4
	mov r0, r4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02007FDC: .4byte 0x023463B4
	arm_func_end FUN_02007FAC

	arm_func_start FUN_02007FE0
FUN_02007FE0: @ 0x02007FE0
	ldr r0, [r0, #0x70]
	bx lr
	arm_func_end FUN_02007FE0

	arm_func_start FUN_02007FE8
FUN_02007FE8: @ 0x02007FE8
	push {r4, r5, r6, r7, r8, lr}
	ldr r2, _02008094 @ =0x023463B4
	mov r6, r0
	mov r5, r1
	ldr r8, [r2, #8]
	mov r7, #0
	bl FUN_02009A90
	mov r4, r0
	b _02008014
_0200800C:
	mov r7, r8
	ldr r8, [r8, #0x68]
_02008014:
	cmp r8, #0
	beq _02008024
	cmp r8, r6
	bne _0200800C
_02008024:
	cmp r8, #0
	beq _02008038
	ldr r0, _02008098 @ =0x023463C4
	cmp r8, r0
	bne _0200804C
_02008038:
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #0
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0200804C:
	ldr r0, [r8, #0x70]
	cmp r0, r5
	beq _02008080
	cmp r7, #0
	ldreq r1, [r6, #0x68]
	ldreq r0, _02008094 @ =0x023463B4
	streq r1, [r0, #8]
	ldrne r0, [r6, #0x68]
	strne r0, [r7, #0x68]
	mov r0, r6
	str r5, [r6, #0x70]
	bl FUN_020086C8
	bl FUN_02008594
_02008080:
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #1
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_02008094: .4byte 0x023463B4
_02008098: .4byte 0x023463C4
	arm_func_end FUN_02007FE8

	arm_func_start FUN_0200809C
FUN_0200809C: @ 0x0200809C
	push {r4, lr}
	bl FUN_02009A90
	mov r4, r0
	bl FUN_02008594
	mov r0, r4
	bl FUN_02009AA4
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200809C

	arm_func_start FUN_020080BC
FUN_020080BC: @ 0x020080BC
	ldr r0, _020080E4 @ =0x023463B4
	ldr r0, [r0, #8]
	b _020080CC
_020080C8:
	ldr r0, [r0, #0x68]
_020080CC:
	cmp r0, #0
	bxeq lr
	ldr r1, [r0, #0x64]
	cmp r1, #1
	bne _020080C8
	bx lr
	.align 2, 0
_020080E4: .4byte 0x023463B4
	arm_func_end FUN_020080BC

	arm_func_start FUN_020080E8
FUN_020080E8: @ 0x020080E8
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	bl FUN_02009A90
	mov r1, #1
	mov r4, r0
	str r1, [r5, #0x64]
	bl FUN_02008594
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_020080E8

	arm_func_start FUN_0200811C
FUN_0200811C: @ 0x0200811C
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r5, r0
	bl FUN_02009A90
	ldr r1, [r5]
	mov r4, r0
	cmp r1, #0
	beq _02008188
	cmp r1, #0
	beq _02008174
	mov r7, #1
	mov r6, #0
_0200814C:
	mov r0, r5
	bl FUN_020087B4
	str r7, [r0, #0x64]
	str r6, [r0, #0x78]
	str r6, [r0, #0x80]
	ldr r1, [r0, #0x80]
	str r1, [r0, #0x7c]
	ldr r0, [r5]
	cmp r0, #0
	bne _0200814C
_02008174:
	mov r0, #0
	str r0, [r5, #4]
	ldr r0, [r5, #4]
	str r0, [r5]
	bl FUN_02008594
_02008188:
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200811C

	arm_func_start FUN_0200819C
FUN_0200819C: @ 0x0200819C
	push {r4, r5, r6, lr}
	mov r6, r0
	bl FUN_02009A90
	ldr r1, _020081EC @ =0x023463AC
	mov r5, r0
	ldr r0, [r1]
	cmp r6, #0
	ldr r4, [r0]
	beq _020081D0
	mov r0, r6
	mov r1, r4
	str r6, [r4, #0x78]
	bl FUN_020087E8
_020081D0:
	mov r0, #0
	str r0, [r4, #0x64]
	bl FUN_02008594
	mov r0, r5
	bl FUN_02009AA4
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_020081EC: .4byte 0x023463AC
	arm_func_end FUN_0200819C

	arm_func_start FUN_020081F0
FUN_020081F0: @ 0x020081F0
	push {r4, lr}
	ldr r0, _0200824C @ =0x023463AC
	ldr r0, [r0]
	ldr r4, [r0]
	bl FUN_02007F60
	mov r0, r4
	bl FUN_02008BC4
	ldr r0, [r4, #0x78]
	cmp r0, #0
	beq _02008220
	mov r1, r4
	bl FUN_02008760
_02008220:
	mov r0, r4
	bl FUN_02008680
	mov r1, #2
	add r0, r4, #0x9c
	str r1, [r4, #0x64]
	bl FUN_0200811C
	bl FUN_02007F28
	bl FUN_0200809C
	bl FUN_02009D48
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200824C: .4byte 0x023463AC
	arm_func_end FUN_020081F0

	arm_func_start FUN_02008250
FUN_02008250: @ 0x02008250
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _02008290 @ =0x023463AC
	ldr r1, [r1]
	ldr r3, [r1]
	ldr r2, [r3, #0xb4]
	cmp r2, #0
	beq _02008280
	mov r1, #0
	str r1, [r3, #0xb4]
	.word 0xE12FFF32
	bl FUN_02009A90
_02008280:
	bl FUN_020081F0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02008290: .4byte 0x023463AC
	arm_func_end FUN_02008250

	arm_func_start FUN_02008294
FUN_02008294: @ 0x02008294
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r2, _020082FC @ =0x0234639C
	mov r5, r0
	ldr r2, [r2]
	mov r4, r1
	cmp r2, #0
	beq _020082E8
	ldr r1, _02008300 @ =0x02303690
	bl FUN_02008878
	str r4, [r5, #4]
	ldr r1, [r5]
	mov r0, r5
	orr r1, r1, #0x80
	str r1, [r5]
	mov r1, #1
	str r1, [r5, #0x64]
	bl FUN_02008930
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
_020082E8:
	mov r0, r4
	bl FUN_02008250
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_020082FC: .4byte 0x0234639C
_02008300: .4byte 0x02303690
	arm_func_end FUN_02008294

	arm_func_start FUN_02008304
FUN_02008304: @ 0x02008304
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_02009A90
	ldr r0, _0200832C @ =0x023463B4
	mov r1, #0
	ldr r0, [r0, #4]
	bl FUN_02008294
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200832C: .4byte 0x023463B4
	arm_func_end FUN_02008304

	arm_func_start FUN_02008330
FUN_02008330: @ 0x02008330
	push {r4, r5, r6, r7, r8, lr}
	mov r8, r0
	mov r5, r1
	mov r7, r2
	mov r6, r3
	bl FUN_02009A90
	mov r4, r0
	bl FUN_02008860
	ldr r2, [sp, #0x1c]
	mov r1, #0
	str r2, [r8, #0x70]
	str r0, [r8, #0x6c]
	str r1, [r8, #0x64]
	str r1, [r8, #0x74]
	mov r0, r8
	bl FUN_020086C8
	mov r1, r5
	str r6, [r8, #0x94]
	ldr r0, [sp, #0x18]
	mov ip, #0
	sub r5, r6, r0
	sub r2, r6, #4
	str r5, [r8, #0x90]
	str ip, [r8, #0x98]
	ldr r3, _0200842C @ =0xFDDB597D
	ldr r0, [r8, #0x94]
	ldr r6, _02008430 @ =0x7BF9DD5B
	str r3, [r0, #-4]
	ldr r3, [r8, #0x90]
	mov r0, r8
	str r6, [r3]
	str ip, [r8, #0xa0]
	ldr r3, [r8, #0xa0]
	str r3, [r8, #0x9c]
	bl FUN_02008878
	str r7, [r8, #4]
	add r1, r5, #4
	ldr r2, _02008434 @ =0x02303744
	mov r0, #0
	str r2, [r8, #0x3c]
	ldr r2, [sp, #0x18]
	sub r2, r2, #8
	bl FUN_0200A0CC
	mov r1, #0
	str r1, [r8, #0x84]
	str r1, [r8, #0x88]
	str r1, [r8, #0x8c]
	mov r0, r8
	bl FUN_02007F20
	mov r0, #0
	str r0, [r8, #0x78]
	str r0, [r8, #0x80]
	ldr r2, [r8, #0x80]
	add r1, r8, #0xa4
	str r2, [r8, #0x7c]
	mov r2, #0xc
	bl FUN_0200A0CC
	mov r0, r4
	mov r1, #0
	str r1, [r8, #0xb0]
	bl FUN_02009AA4
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200842C: .4byte 0xFDDB597D
_02008430: .4byte 0x7BF9DD5B
_02008434: .4byte 0x02303744
	arm_func_end FUN_02008330

	arm_func_start FUN_02008438
FUN_02008438: @ 0x02008438
	push {r4, r5, r6, lr}
	sub sp, sp, #8
	ldr r3, _02008558 @ =0x023463B0
	ldr r0, [r3]
	cmp r0, #0
	addne sp, sp, #8
	popne {r4, r5, r6, lr}
	bxne lr
	ldr ip, _0200855C @ =0x00000400
	ldr r1, _02008560 @ =0x02346484
	mov lr, #0
	ldr r0, _02008564 @ =0x023463B4
	mov r6, #1
	mov r4, #0x10
	str r1, [r0, #8]
	str r1, [r0, #4]
	cmp ip, #0
	ldrle r0, _02008568 @ =0x027E0080
	str r4, [r1, #0x70]
	suble r4, r0, ip
	str lr, [r1, #0x6c]
	str r6, [r1, #0x64]
	str lr, [r1, #0x68]
	str lr, [r1, #0x74]
	ldrgt r1, _0200856C @ =0x027E0000
	ldrgt r0, _02008570 @ =0x00000800
	addgt r1, r1, #0x3f80
	subgt r0, r1, r0
	subgt r4, r0, ip
	ldr r1, _0200856C @ =0x027E0000
	ldr r5, _02008574 @ =0x023463B8
	ldr r2, _02008578 @ =0x023463AC
	ldr r0, _02008570 @ =0x00000800
	str r5, [r2]
	ldr r2, _02008560 @ =0x02346484
	add r1, r1, #0x3f80
	str r6, [r3]
	sub r3, r1, r0
	mov r0, #0
	ldr r1, _0200857C @ =0xFDDB597D
	str r3, [r2, #0x94]
	str r4, [r2, #0x90]
	str r0, [r2, #0x98]
	str r1, [r3, #-4]
	ldr r3, [r2, #0x90]
	ldr ip, _02008580 @ =0x7BF9DD5B
	ldr r1, _02008564 @ =0x023463B4
	str ip, [r3]
	ldr r3, _02008584 @ =0x027FFFA0
	str r0, [r2, #0xa0]
	str r0, [r2, #0x9c]
	strh r0, [r1]
	strh r0, [r1, #2]
	str r1, [r3]
	bl FUN_02007FAC
	mov r2, #0xc8
	str r2, [sp]
	mov ip, #0x1f
	ldr r0, _02008588 @ =0x023463C4
	ldr r1, _0200858C @ =0x023033D8
	ldr r3, _02008590 @ =0x0234660C
	mov r2, #0
	str ip, [sp, #4]
	bl FUN_02008330
	ldr r0, _02008588 @ =0x023463C4
	mov r2, #0x20
	mov r1, #1
	str r2, [r0, #0x70]
	str r1, [r0, #0x64]
	add sp, sp, #8
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_02008558: .4byte 0x023463B0
_0200855C: .4byte 0x00000400
_02008560: .4byte 0x02346484
_02008564: .4byte 0x023463B4
_02008568: .4byte 0x027E0080
_0200856C: .4byte 0x027E0000
_02008570: .4byte 0x00000800
_02008574: .4byte 0x023463B8
_02008578: .4byte 0x023463AC
_0200857C: .4byte 0xFDDB597D
_02008580: .4byte 0x7BF9DD5B
_02008584: .4byte 0x027FFFA0
_02008588: .4byte 0x023463C4
_0200858C: .4byte 0x023033D8
_02008590: .4byte 0x0234660C
	arm_func_end FUN_02008438

	arm_func_start FUN_02008594
FUN_02008594: @ 0x02008594
	push {r4, r5, r6, lr}
	ldr r0, _02008670 @ =0x023463A0
	ldr r0, [r0]
	cmp r0, #0
	popne {r4, r5, r6, lr}
	bxne lr
	ldr r4, _02008674 @ =0x023463B4
	ldrh r0, [r4, #2]
	cmp r0, #0
	bne _020085C8
	bl FUN_02009AF4
	cmp r0, #0x12
	bne _020085D8
_020085C8:
	mov r0, #1
	strh r0, [r4]
	pop {r4, r5, r6, lr}
	bx lr
_020085D8:
	ldr r0, _02008678 @ =0x023463AC
	ldr r0, [r0]
	ldr r6, [r0]
	bl FUN_020080BC
	mov r5, r0
	cmp r6, r5
	popeq {r4, r5, r6, lr}
	bxeq lr
	cmp r5, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	ldr r0, [r6, #0x64]
	cmp r0, #2
	beq _02008624
	mov r0, r6
	bl FUN_020088E4
	cmp r0, #0
	popne {r4, r5, r6, lr}
	bxne lr
_02008624:
	ldr r0, _0200867C @ =0x023463A8
	ldr r2, [r0]
	cmp r2, #0
	beq _02008640
	mov r0, r6
	mov r1, r5
	.word 0xE12FFF32
_02008640:
	ldr r2, [r4, #0xc]
	cmp r2, #0
	beq _02008658
	mov r0, r6
	mov r1, r5
	.word 0xE12FFF32
_02008658:
	ldr r1, _02008674 @ =0x023463B4
	mov r0, r5
	str r5, [r1, #4]
	bl FUN_02008930
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_02008670: .4byte 0x023463A0
_02008674: .4byte 0x023463B4
_02008678: .4byte 0x023463AC
_0200867C: .4byte 0x023463A8
	arm_func_end FUN_02008594

	arm_func_start FUN_02008680
FUN_02008680: @ 0x02008680
	ldr r1, _020086C4 @ =0x023463B4
	mov r2, #0
	ldr r1, [r1, #8]
	b _02008698
_02008690:
	mov r2, r1
	ldr r1, [r1, #0x68]
_02008698:
	cmp r1, #0
	beq _020086A8
	cmp r1, r0
	bne _02008690
_020086A8:
	cmp r2, #0
	ldreq r1, [r0, #0x68]
	ldreq r0, _020086C4 @ =0x023463B4
	streq r1, [r0, #8]
	ldrne r0, [r0, #0x68]
	strne r0, [r2, #0x68]
	bx lr
	.align 2, 0
_020086C4: .4byte 0x023463B4
	arm_func_end FUN_02008680

	arm_func_start FUN_020086C8
FUN_020086C8: @ 0x020086C8
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200872C @ =0x023463B4
	mov ip, #0
	ldr r3, [r1, #8]
	mov lr, r3
	b _020086EC
_020086E4:
	mov ip, lr
	ldr lr, [lr, #0x68]
_020086EC:
	cmp lr, #0
	beq _02008704
	ldr r2, [lr, #0x70]
	ldr r1, [r0, #0x70]
	cmp r2, r1
	blo _020086E4
_02008704:
	cmp ip, #0
	ldreq r1, _0200872C @ =0x023463B4
	streq r3, [r0, #0x68]
	streq r0, [r1, #8]
	ldrne r1, [ip, #0x68]
	strne r1, [r0, #0x68]
	strne r0, [ip, #0x68]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200872C: .4byte 0x023463B4
	arm_func_end FUN_020086C8

	arm_func_start FUN_02008730
FUN_02008730: @ 0x02008730
	ldr r2, [r0]
	cmp r2, #0
	beq _02008758
	ldr r1, [r2, #0x10]
	str r1, [r0]
	cmp r1, #0
	movne r0, #0
	strne r0, [r1, #0x14]
	moveq r1, #0
	streq r1, [r0, #4]
_02008758:
	mov r0, r2
	bx lr
	arm_func_end FUN_02008730

	arm_func_start FUN_02008760
FUN_02008760: @ 0x02008760
	ldr r2, [r0]
	mov ip, r2
	cmp r2, #0
	beq _020087AC
_02008770:
	cmp ip, r1
	ldr r3, [ip, #0x80]
	bne _020087A0
	cmp r2, ip
	ldr r2, [ip, #0x7c]
	streq r3, [r0]
	strne r3, [r2, #0x80]
	ldr r1, [r0, #4]
	cmp r1, ip
	streq r2, [r0, #4]
	strne r2, [r3, #0x7c]
	b _020087AC
_020087A0:
	mov ip, r3
	cmp r3, #0
	bne _02008770
_020087AC:
	mov r0, ip
	bx lr
	arm_func_end FUN_02008760

	arm_func_start FUN_020087B4
FUN_020087B4: @ 0x020087B4
	ldr r2, [r0]
	cmp r2, #0
	beq _020087E0
	ldr r1, [r2, #0x80]
	str r1, [r0]
	cmp r1, #0
	movne r0, #0
	strne r0, [r1, #0x7c]
	moveq r1, #0
	streq r1, [r0, #4]
	streq r1, [r2, #0x78]
_020087E0:
	mov r0, r2
	bx lr
	arm_func_end FUN_020087B4

	arm_func_start FUN_020087E8
FUN_020087E8: @ 0x020087E8
	ldr ip, [r0]
	b _020087FC
_020087F0:
	cmp ip, r1
	bxeq lr
	ldr ip, [ip, #0x80]
_020087FC:
	cmp ip, #0
	beq _02008814
	ldr r3, [ip, #0x70]
	ldr r2, [r1, #0x70]
	cmp r3, r2
	bls _020087F0
_02008814:
	cmp ip, #0
	bne _02008840
	ldr r2, [r0, #4]
	cmp r2, #0
	streq r1, [r0]
	strne r1, [r2, #0x80]
	str r2, [r1, #0x7c]
	mov r2, #0
	str r2, [r1, #0x80]
	str r1, [r0, #4]
	bx lr
_02008840:
	ldr r2, [ip, #0x7c]
	cmp r2, #0
	streq r1, [r0]
	strne r1, [r2, #0x80]
	str r2, [r1, #0x7c]
	str ip, [r1, #0x80]
	str r1, [ip, #0x7c]
	bx lr
	arm_func_end FUN_020087E8

	arm_func_start FUN_02008860
FUN_02008860: @ 0x02008860
	ldr r1, _02008874 @ =0x023463A4
	ldr r0, [r1]
	add r0, r0, #1
	str r0, [r1]
	bx lr
	.align 2, 0
_02008874: .4byte 0x023463A4
	arm_func_end FUN_02008860

	arm_func_start FUN_02008878
FUN_02008878: @ 0x02008878
	add r1, r1, #4
	str r1, [r0, #0x40]
	str r2, [r0, #0x44]
	sub r2, r2, #0x40
	tst r2, #4
	subne r2, r2, #4
	str r2, [r0, #0x38]
	ands r1, r1, #1
	movne r1, #0x3f
	moveq r1, #0x1f
	str r1, [r0]
	mov r1, #0
	str r1, [r0, #4]
	str r1, [r0, #8]
	str r1, [r0, #0xc]
	str r1, [r0, #0x10]
	str r1, [r0, #0x14]
	str r1, [r0, #0x18]
	str r1, [r0, #0x1c]
	str r1, [r0, #0x20]
	str r1, [r0, #0x24]
	str r1, [r0, #0x28]
	str r1, [r0, #0x2c]
	str r1, [r0, #0x30]
	str r1, [r0, #0x34]
	str r1, [r0, #0x3c]
	bx lr
	arm_func_end FUN_02008878

	arm_func_start FUN_020088E4
FUN_020088E4: @ 0x020088E4
	push {r0, lr}
	add r0, r0, #0x48
	ldr r1, _0200892C @ =0x02307C34
	.word 0xE12FFF31
	pop {r0, lr}
	add r1, r0, #0
	mrs r2, apsr
	str r2, [r1], #4
	mov r0, #0xd3
	msr cpsr_c, r0
	str sp, [r1, #0x40]
	msr cpsr_c, r2
	mov r0, #1
	stm r1, {r0, r1, r2, r3, r4, r5, r6, r7, r8, sb, sl, fp, ip, sp, lr}
	add r0, pc, #0x8 @ =_0200892C
	str r0, [r1, #0x3c]
	mov r0, #0
	bx lr
	.align 2, 0
_0200892C: .4byte 0x02307C34
	arm_func_end FUN_020088E4

	arm_func_start FUN_02008930
FUN_02008930: @ 0x02008930
	push {r0, lr}
	add r0, r0, #0x48
	ldr r1, _02008970 @ =0x02307C74
	.word 0xE12FFF31
	pop {r0, lr}
	mrs r1, apsr
	bic r1, r1, #0x1f
	orr r1, r1, #0xd3
	msr cpsr_c, r1
	ldr r1, [r0], #4
	msr spsr_fsxc, r1
	ldr sp, [r0, #0x40]
	ldr lr, [r0, #0x3c]
	ldm r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, sb, sl, fp, ip, sp, lr} ^
	mov r0, r0
	subs pc, lr, #4
	.align 2, 0
_02008970: .4byte 0x02307C74
	arm_func_end FUN_02008930

	arm_func_start FUN_02008974
FUN_02008974: @ 0x02008974
	ldr r0, _02008984 @ =0x82000001
	ldr r1, _02008988 @ =0x0231CF28
	str r0, [r1]
	bx lr
	.align 2, 0
_02008984: .4byte 0x82000001
_02008988: .4byte 0x0231CF28
	arm_func_end FUN_02008974

	arm_func_start FUN_0200898C
FUN_0200898C: @ 0x0200898C
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r6, r0
	mov r5, r1
	mov r7, r2
	bl FUN_02009A90
	ldr r1, [r6, #0x14]
	ldr r2, [r6, #0x1c]
	mov r4, r0
	cmp r1, r2
	bgt _020089F4
	and r7, r7, #1
_020089BC:
	cmp r7, #0
	bne _020089DC
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	pop {r4, r5, r6, r7, lr}
	bx lr
_020089DC:
	mov r0, r6
	bl FUN_0200819C
	ldr r1, [r6, #0x14]
	ldr r0, [r6, #0x1c]
	cmp r1, r0
	ble _020089BC
_020089F4:
	ldr r0, [r6, #0x18]
	add r0, r0, r1
	sub r0, r0, #1
	bl FUN_020184CC
	str r1, [r6, #0x18]
	ldr r2, [r6, #0x10]
	ldr r1, [r6, #0x18]
	add r0, r6, #8
	str r5, [r2, r1, lsl #2]
	ldr r1, [r6, #0x1c]
	add r1, r1, #1
	str r1, [r6, #0x1c]
	bl FUN_0200811C
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200898C

	arm_func_start FUN_02008A40
FUN_02008A40: @ 0x02008A40
	push {r4, r5, r6, r7, r8, lr}
	mov r6, r0
	mov r5, r1
	mov r7, r2
	bl FUN_02009A90
	ldr r1, [r6, #0x1c]
	mov r4, r0
	cmp r1, #0
	bne _02008A9C
	and r8, r7, #1
	add r7, r6, #8
_02008A6C:
	cmp r8, #0
	bne _02008A88
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #0
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_02008A88:
	mov r0, r7
	bl FUN_0200819C
	ldr r0, [r6, #0x1c]
	cmp r0, #0
	beq _02008A6C
_02008A9C:
	cmp r5, #0
	ldrne r1, [r6, #0x10]
	ldrne r0, [r6, #0x18]
	ldrne r0, [r1, r0, lsl #2]
	strne r0, [r5]
	ldr r0, [r6, #0x18]
	ldr r1, [r6, #0x14]
	add r0, r0, #1
	bl FUN_020184CC
	str r1, [r6, #0x18]
	ldr r1, [r6, #0x1c]
	mov r0, r6
	sub r1, r1, #1
	str r1, [r6, #0x1c]
	bl FUN_0200811C
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #1
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_02008A40

	arm_func_start FUN_02008AEC
FUN_02008AEC: @ 0x02008AEC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r6, r0
	mov r5, r1
	mov r7, r2
	bl FUN_02009A90
	ldr r2, [r6, #0x1c]
	ldr r1, [r6, #0x14]
	mov r4, r0
	cmp r1, r2
	bgt _02008B54
	and r7, r7, #1
_02008B1C:
	cmp r7, #0
	bne _02008B3C
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	pop {r4, r5, r6, r7, lr}
	bx lr
_02008B3C:
	mov r0, r6
	bl FUN_0200819C
	ldr r2, [r6, #0x1c]
	ldr r1, [r6, #0x14]
	cmp r1, r2
	ble _02008B1C
_02008B54:
	ldr r0, [r6, #0x18]
	add r0, r0, r2
	bl FUN_020184CC
	ldr r2, [r6, #0x10]
	add r0, r6, #8
	str r5, [r2, r1, lsl #2]
	ldr r1, [r6, #0x1c]
	add r1, r1, #1
	str r1, [r6, #0x1c]
	bl FUN_0200811C
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02008AEC

	arm_func_start FUN_02008B94
FUN_02008B94: @ 0x02008B94
	mov ip, #0
	str ip, [r0, #4]
	ldr r3, [r0, #4]
	str r3, [r0]
	str ip, [r0, #0xc]
	ldr r3, [r0, #0xc]
	str r3, [r0, #8]
	str r1, [r0, #0x10]
	str r2, [r0, #0x14]
	str ip, [r0, #0x18]
	str ip, [r0, #0x1c]
	bx lr
	arm_func_end FUN_02008B94

	arm_func_start FUN_02008BC4
FUN_02008BC4: @ 0x02008BC4
	push {r4, r5, r6, lr}
	mov r6, r0
	ldr r0, [r6, #0x88]
	cmp r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	add r5, r6, #0x88
	mov r4, #0
_02008BE4:
	mov r0, r5
	bl FUN_02008730
	str r4, [r0, #0xc]
	str r4, [r0, #8]
	bl FUN_0200811C
	ldr r0, [r6, #0x88]
	cmp r0, #0
	bne _02008BE4
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_02008BC4

	arm_func_start FUN_02008C0C
FUN_02008C0C: @ 0x02008C0C
	mov r2, #0
	str r2, [r0, #4]
	ldr r1, [r0, #4]
	str r1, [r0]
	str r2, [r0, #8]
	str r2, [r0, #0xc]
	bx lr
	arm_func_end FUN_02008C0C

	arm_func_start FUN_02008C28
FUN_02008C28: @ 0x02008C28
	mov ip, #0
	mov r1, #0
_02008C30:
	mov r0, #0
_02008C34:
	orr r2, r1, r0
	mcr p15, #0, ip, c7, c10, #4
	mcr p15, #0, r2, c7, c14, #2
	add r0, r0, #0x20
	cmp r0, #0x400
	blt _02008C34
	add r1, r1, #0x40000000
	cmp r1, #0
	bne _02008C30
	bx lr
	arm_func_end FUN_02008C28

	arm_func_start FUN_02008C5C
FUN_02008C5C: @ 0x02008C5C
	add r1, r1, r0
	bic r0, r0, #0x1f
_02008C64:
	mcr p15, #0, r0, c7, c6, #1
	add r0, r0, #0x20
	cmp r0, r1
	blt _02008C64
	bx lr
	arm_func_end FUN_02008C5C

	arm_func_start FUN_02008C78
FUN_02008C78: @ 0x02008C78
	add r1, r1, r0
	bic r0, r0, #0x1f
_02008C80:
	mcr p15, #0, r0, c7, c10, #1
	add r0, r0, #0x20
	cmp r0, r1
	blt _02008C80
	bx lr
	arm_func_end FUN_02008C78

	arm_func_start FUN_02008C94
FUN_02008C94: @ 0x02008C94
	mov ip, #0
	add r1, r1, r0
	bic r0, r0, #0x1f
_02008CA0:
	mcr p15, #0, ip, c7, c10, #4
	mcr p15, #0, r0, c7, c14, #1
	add r0, r0, #0x20
	cmp r0, r1
	blt _02008CA0
	bx lr
	arm_func_end FUN_02008C94

	arm_func_start FUN_02008CB8
FUN_02008CB8: @ 0x02008CB8
	mov r0, #0
	mcr p15, #0, r0, c7, c10, #4
	bx lr
	arm_func_end FUN_02008CB8

	arm_func_start FUN_02008CC4
FUN_02008CC4: @ 0x02008CC4
	add r1, r1, r0
	bic r0, r0, #0x1f
_02008CCC:
	mcr p15, #0, r0, c7, c5, #1
	add r0, r0, #0x20
	cmp r0, r1
	blt _02008CCC
	bx lr
	arm_func_end FUN_02008CC4

	arm_func_start FUN_02008CE0
FUN_02008CE0: @ 0x02008CE0
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200901C
	bl FUN_0200A3C0
	bl FUN_02007E30
	bl FUN_02008F9C
	bl FUN_02007B50
	bl FUN_02007958
	bl FUN_02009754
	bl FUN_0200A39C
	bl FUN_02009A0C
	bl FUN_02009D08
	bl FUN_02008438
	bl FUN_02009B78
	bl FUN_0201405C
	bl FUN_0200DE30
	bl FUN_0200D058
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02008CE0

	arm_func_start FUN_02008D30
FUN_02008D30: @ 0x02008D30
	lsl r0, r0, #2
	add r0, r0, #0x2700000
	add r0, r0, #0xff000
	str r1, [r0, #0xda0]
	bx lr
	arm_func_end FUN_02008D30

	arm_func_start FUN_02008D44
FUN_02008D44: @ 0x02008D44
	lsl r0, r0, #2
	add r0, r0, #0x2700000
	add r0, r0, #0xff000
	str r1, [r0, #0xdc4]
	bx lr
	arm_func_end FUN_02008D44

	arm_func_start FUN_02008D58
FUN_02008D58: @ 0x02008D58
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #6
	addls pc, pc, r0, lsl #2
	b _02008E18
_02008D6C: @ jump table
	b _02008D88 @ case 0
	b _02008E18 @ case 1
	b _02008D98 @ case 2
	b _02008DD8 @ case 3
	b _02008DE8 @ case 4
	b _02008DF8 @ case 5
	b _02008E08 @ case 6
_02008D88:
	add sp, sp, #4
	ldr r0, _02008E28 @ =FUN_02004BC0
	ldm sp!, {lr}
	bx lr
_02008D98:
	ldr r0, _02008E2C @ =0x02346610
	ldr r0, [r0]
	cmp r0, #0
	beq _02008DB8
	bl FUN_02008974
	and r0, r0, #3
	cmp r0, #1
	bne _02008DC8
_02008DB8:
	add sp, sp, #4
	mov r0, #0
	ldm sp!, {lr}
	bx lr
_02008DC8:
	add sp, sp, #4
	ldr r0, _02008E30 @ =0x02400000
	ldm sp!, {lr}
	bx lr
_02008DD8:
	add sp, sp, #4
	ldr r0, _02008E34 @ =0x01FF82E0
	ldm sp!, {lr}
	bx lr
_02008DE8:
	add sp, sp, #4
	ldr r0, _02008E38 @ =0x027E0080
	ldm sp!, {lr}
	bx lr
_02008DF8:
	add sp, sp, #4
	ldr r0, _02008E3C @ =0x027FF000
	ldm sp!, {lr}
	bx lr
_02008E08:
	add sp, sp, #4
	ldr r0, _02008E40 @ =0x037F8000
	ldm sp!, {lr}
	bx lr
_02008E18:
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02008E28: .4byte FUN_02004BC0
_02008E2C: .4byte 0x02346610
_02008E30: .4byte 0x02400000
_02008E34: .4byte 0x01FF82E0
_02008E38: .4byte 0x027E0080
_02008E3C: .4byte 0x027FF000
_02008E40: .4byte 0x037F8000
	arm_func_end FUN_02008D58

	arm_func_start FUN_02008E44
FUN_02008E44: @ 0x02008E44
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #6
	addls pc, pc, r0, lsl #2
	b _02008F44
_02008E58: @ jump table
	b _02008E74 @ case 0
	b _02008F44 @ case 1
	b _02008E84 @ case 2
	b _02008EC4 @ case 3
	b _02008ED4 @ case 4
	b _02008F24 @ case 5
	b _02008F34 @ case 6
_02008E74:
	add sp, sp, #4
	ldr r0, _02008F54 @ =0x023E0000
	ldm sp!, {lr}
	bx lr
_02008E84:
	ldr r0, _02008F58 @ =0x02346610
	ldr r0, [r0]
	cmp r0, #0
	beq _02008EA4
	bl FUN_02008974
	and r0, r0, #3
	cmp r0, #1
	bne _02008EB4
_02008EA4:
	add sp, sp, #4
	mov r0, #0
	ldm sp!, {lr}
	bx lr
_02008EB4:
	add sp, sp, #4
	mov r0, #0x2700000
	ldm sp!, {lr}
	bx lr
_02008EC4:
	add sp, sp, #4
	mov r0, #0x2000000
	ldm sp!, {lr}
	bx lr
_02008ED4:
	ldr r0, _02008F5C @ =0x027E0000
	ldr r1, _02008F60 @ =0x00000400
	ldr r2, _02008F64 @ =0x00000800
	add r3, r0, #0x3f80
	cmp r1, #0
	sub r2, r3, r2
	bne _02008F08
	ldr r1, _02008F68 @ =0x027E0080
	add sp, sp, #4
	cmp r0, r1
	movlo r0, r1
	ldm sp!, {lr}
	bx lr
_02008F08:
	cmp r1, #0
	ldrlt r0, _02008F68 @ =0x027E0080
	add sp, sp, #4
	sublt r0, r0, r1
	subge r0, r2, r1
	ldm sp!, {lr}
	bx lr
_02008F24:
	add sp, sp, #4
	ldr r0, _02008F6C @ =0x027FF680
	ldm sp!, {lr}
	bx lr
_02008F34:
	add sp, sp, #4
	ldr r0, _02008F70 @ =0x037F8000
	ldm sp!, {lr}
	bx lr
_02008F44:
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02008F54: .4byte 0x023E0000
_02008F58: .4byte 0x02346610
_02008F5C: .4byte 0x027E0000
_02008F60: .4byte 0x00000400
_02008F64: .4byte 0x00000800
_02008F68: .4byte 0x027E0080
_02008F6C: .4byte 0x027FF680
_02008F70: .4byte 0x037F8000
	arm_func_end FUN_02008E44

	arm_func_start FUN_02008F74
FUN_02008F74: @ 0x02008F74
	lsl r0, r0, #2
	add r0, r0, #0x2700000
	add r0, r0, #0xff000
	ldr r0, [r0, #0xda0]
	bx lr
	arm_func_end FUN_02008F74

	arm_func_start FUN_02008F88
FUN_02008F88: @ 0x02008F88
	lsl r0, r0, #2
	add r0, r0, #0x2700000
	add r0, r0, #0xff000
	ldr r0, [r0, #0xdc4]
	bx lr
	arm_func_end FUN_02008F88

	arm_func_start FUN_02008F9C
FUN_02008F9C: @ 0x02008F9C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #2
	bl FUN_02008E44
	mov r1, r0
	mov r0, #2
	bl FUN_02008D44
	mov r0, #2
	bl FUN_02008D58
	mov r1, r0
	mov r0, #2
	bl FUN_02008D30
	ldr r0, _02009010 @ =0x02346610
	ldr r0, [r0]
	cmp r0, #0
	beq _02008FF4
	bl FUN_02008974
	and r0, r0, #3
	cmp r0, #1
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
_02008FF4:
	ldr r0, _02009014 @ =0x0200002B
	bl FUN_020095C0
	ldr r0, _02009018 @ =0x023E0021
	bl FUN_020095C8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009010: .4byte 0x02346610
_02009014: .4byte 0x0200002B
_02009018: .4byte 0x023E0021
	arm_func_end FUN_02008F9C

	arm_func_start FUN_0200901C
FUN_0200901C: @ 0x0200901C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _02009130 @ =0x0234660C
	ldr r0, [r1]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	mov r2, #1
	mov r0, #0
	str r2, [r1]
	bl FUN_02008E44
	mov r1, r0
	mov r0, #0
	bl FUN_02008D44
	mov r0, #0
	bl FUN_02008D58
	mov r1, r0
	mov r0, #0
	bl FUN_02008D30
	mov r0, #2
	mov r1, #0
	bl FUN_02008D30
	mov r0, #2
	mov r1, #0
	bl FUN_02008D44
	mov r0, #3
	bl FUN_02008E44
	mov r1, r0
	mov r0, #3
	bl FUN_02008D44
	mov r0, #3
	bl FUN_02008D58
	mov r1, r0
	mov r0, #3
	bl FUN_02008D30
	mov r0, #4
	bl FUN_02008E44
	mov r1, r0
	mov r0, #4
	bl FUN_02008D44
	mov r0, #4
	bl FUN_02008D58
	mov r1, r0
	mov r0, #4
	bl FUN_02008D30
	mov r0, #5
	bl FUN_02008E44
	mov r1, r0
	mov r0, #5
	bl FUN_02008D44
	mov r0, #5
	bl FUN_02008D58
	mov r1, r0
	mov r0, #5
	bl FUN_02008D30
	mov r0, #6
	bl FUN_02008E44
	mov r1, r0
	mov r0, #6
	bl FUN_02008D44
	mov r0, #6
	bl FUN_02008D58
	mov r1, r0
	mov r0, #6
	bl FUN_02008D30
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009130: .4byte 0x0234660C
	arm_func_end FUN_0200901C

	arm_func_start FUN_02009134
FUN_02009134: @ 0x02009134
	push {r4, r5, r6, lr}
	mov r4, r0
	mov r6, r1
	mov r5, r2
	bl FUN_02009A90
	ldr r2, _020091D0 @ =0x02346614
	add r1, r6, #0x1f
	ldr r2, [r2, r4, lsl #2]
	bic r6, r1, #0x1f
	ldr r3, [r2, #4]
	bic r5, r5, #0x1f
	cmp r3, #0
	mov r4, #0
	ble _020091C0
	ldr ip, [r2, #0x10]
_02009170:
	ldr r1, [ip]
	cmp r1, #0
	bge _020091B0
	sub r1, r5, r6
	str r1, [ip]
	mov r2, #0
	str r2, [r6]
	str r2, [r6, #4]
	ldr r1, [ip]
	str r1, [r6, #8]
	str r6, [ip, #4]
	str r2, [ip, #8]
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, r5, r6, lr}
	bx lr
_020091B0:
	add r4, r4, #1
	cmp r4, r3
	add ip, ip, #0xc
	blt _02009170
_020091C0:
	bl FUN_02009AA4
	mvn r0, #0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_020091D0: .4byte 0x02346614
	arm_func_end FUN_02009134

	arm_func_start FUN_020091D4
FUN_020091D4: @ 0x020091D4
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r6, r1
	mov r5, r2
	mov r4, r3
	bl FUN_02009A90
	ldr r2, _0200928C @ =0x02346614
	mov r1, #0xc
	str r6, [r2, r7, lsl #2]
	add r2, r6, #0x14
	str r2, [r6, #0x10]
	str r4, [r6, #4]
	ldr r2, [r6, #4]
	mul r1, r4, r1
	cmp r2, #0
	mov r7, #0
	ble _02009254
	mov lr, r7
	mov r3, r7
	mvn r4, #0
_02009228:
	ldr r2, [r6, #0x10]
	add r7, r7, #1
	str r4, [r2, lr]
	add ip, r2, lr
	str r3, [ip, #8]
	ldr r2, [ip, #8]
	add lr, lr, #0xc
	str r2, [ip, #4]
	ldr r2, [r6, #4]
	cmp r7, r2
	blt _02009228
_02009254:
	mvn r2, #0
	str r2, [r6]
	ldr r3, [r6, #0x10]
	bic r2, r5, #0x1f
	add r1, r3, r1
	add r1, r1, #0x1f
	bic r1, r1, #0x1f
	str r1, [r6, #8]
	str r2, [r6, #0xc]
	bl FUN_02009AA4
	ldr r0, [r6, #8]
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200928C: .4byte 0x02346614
	arm_func_end FUN_020091D4

	arm_func_start FUN_02009290
FUN_02009290: @ 0x02009290
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r4, r0
	mov r5, r1
	bl FUN_02009A90
	ldr r1, _020092C8 @ =0x02346614
	ldr r1, [r1, r4, lsl #2]
	ldr r4, [r1]
	str r5, [r1]
	bl FUN_02009AA4
	mov r0, r4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_020092C8: .4byte 0x02346614
	arm_func_end FUN_02009290

	arm_func_start FUN_020092CC
FUN_020092CC: @ 0x020092CC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r5, r1
	mov r4, r2
	bl FUN_02009A90
	ldr r1, _0200933C @ =0x02346614
	mov r6, r0
	ldr r0, [r1, r7, lsl #2]
	cmp r5, #0
	ldrlt r5, [r0]
	ldr r1, [r0, #0x10]
	mov r0, #0xc
	mla r7, r5, r0, r1
	sub r4, r4, #0x20
	ldr r0, [r7, #8]
	mov r1, r4
	bl FUN_02009534
	str r0, [r7, #8]
	ldr r0, [r7, #4]
	mov r1, r4
	bl FUN_0200946C
	str r0, [r7, #4]
	mov r0, r6
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200933C: .4byte 0x02346614
	arm_func_end FUN_020092CC

	arm_func_start FUN_02009340
FUN_02009340: @ 0x02009340
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r6, r0
	mov r5, r1
	mov r7, r2
	bl FUN_02009A90
	ldr r1, _02009468 @ =0x02346614
	mov r4, r0
	ldr r1, [r1, r6, lsl #2]
	cmp r1, #0
	bne _02009380
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	pop {r4, r5, r6, r7, lr}
	bx lr
_02009380:
	cmp r5, #0
	ldrlt r5, [r1]
	ldr r1, [r1, #0x10]
	mov r0, #0xc
	mla r6, r5, r0, r1
	ldr r0, [r6, #4]
	add r1, r7, #0x20
	add r1, r1, #0x1f
	mov r5, r0
	cmp r0, #0
	bic r7, r1, #0x1f
	beq _020093C8
_020093B0:
	ldr r1, [r5, #8]
	cmp r7, r1
	ble _020093C8
	ldr r5, [r5, #4]
	cmp r5, #0
	bne _020093B0
_020093C8:
	cmp r5, #0
	bne _020093E8
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	pop {r4, r5, r6, r7, lr}
	bx lr
_020093E8:
	ldr r1, [r5, #8]
	sub r1, r1, r7
	cmp r1, #0x40
	bhs _02009408
	mov r1, r5
	bl FUN_02009534
	str r0, [r6, #4]
	b _02009440
_02009408:
	str r7, [r5, #8]
	add r2, r5, r7
	str r1, [r2, #8]
	ldr r0, [r5]
	str r0, [r5, r7]
	ldr r0, [r5, #4]
	str r0, [r2, #4]
	ldr r0, [r2, #4]
	cmp r0, #0
	strne r2, [r0]
	ldr r0, [r2]
	cmp r0, #0
	strne r2, [r0, #4]
	streq r2, [r6, #4]
_02009440:
	ldr r0, [r6, #8]
	mov r1, r5
	bl FUN_0200955C
	str r0, [r6, #8]
	mov r0, r4
	bl FUN_02009AA4
	add r0, r5, #0x20
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_02009468: .4byte 0x02346614
	arm_func_end FUN_02009340

	arm_func_start FUN_0200946C
FUN_0200946C: @ 0x0200946C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov ip, r0
	cmp r0, #0
	mov lr, #0
	beq _0200949C
_02009484:
	cmp r1, ip
	bls _0200949C
	mov lr, ip
	ldr ip, [ip, #4]
	cmp ip, #0
	bne _02009484
_0200949C:
	str ip, [r1, #4]
	str lr, [r1]
	cmp ip, #0
	beq _020094DC
	str r1, [ip]
	ldr r3, [r1, #8]
	add r2, r1, r3
	cmp r2, ip
	bne _020094DC
	ldr r2, [ip, #8]
	add r2, r3, r2
	str r2, [r1, #8]
	ldr ip, [ip, #4]
	str ip, [r1, #4]
	cmp ip, #0
	strne r1, [ip]
_020094DC:
	cmp lr, #0
	beq _02009524
	str r1, [lr, #4]
	ldr r2, [lr, #8]
	add r3, lr, r2
	cmp r3, r1
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	ldr r1, [r1, #8]
	add sp, sp, #4
	add r1, r2, r1
	str r1, [lr, #8]
	str ip, [lr, #4]
	cmp ip, #0
	strne lr, [ip]
	ldm sp!, {lr}
	bx lr
_02009524:
	mov r0, r1
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200946C

	arm_func_start FUN_02009534
FUN_02009534: @ 0x02009534
	ldr r3, [r1, #4]
	cmp r3, #0
	ldrne r2, [r1]
	strne r2, [r3]
	ldr r2, [r1]
	cmp r2, #0
	ldreq r0, [r1, #4]
	ldrne r1, [r1, #4]
	strne r1, [r2, #4]
	bx lr
	arm_func_end FUN_02009534

	arm_func_start FUN_0200955C
FUN_0200955C: @ 0x0200955C
	str r0, [r1, #4]
	mov r2, #0
	str r2, [r1]
	cmp r0, #0
	strne r1, [r0]
	mov r0, r1
	bx lr
	arm_func_end FUN_0200955C

	arm_func_start FUN_02009578
FUN_02009578: @ 0x02009578
	mrc p15, #0, r0, c9, c1, #0
	ldr r1, _02009588 @ =0xFFFFF000
	and r0, r0, r1
	bx lr
	.align 2, 0
_02009588: .4byte 0xFFFFF000
	arm_func_end FUN_02009578

	arm_func_start FUN_0200958C
FUN_0200958C: @ 0x0200958C
	mrc p15, #0, r0, c1, c0, #0
	orr r0, r0, #1
	mcr p15, #0, r0, c1, c0, #0
	bx lr
	arm_func_end FUN_0200958C

	arm_func_start FUN_0200959C
FUN_0200959C: @ 0x0200959C
	mrc p15, #0, r0, c1, c0, #0
	bic r0, r0, #1
	mcr p15, #0, r0, c1, c0, #0
	bx lr
	arm_func_end FUN_0200959C

	arm_func_start FUN_020095AC
FUN_020095AC: @ 0x020095AC
	mrc p15, #0, r2, c5, c0, #2
	bic r2, r2, r0
	orr r2, r2, r1
	mcr p15, #0, r2, c5, c0, #2
	bx lr
	arm_func_end FUN_020095AC

	arm_func_start FUN_020095C0
FUN_020095C0: @ 0x020095C0
	mcr p15, #0, r0, c6, c1, #0
	bx lr
	arm_func_end FUN_020095C0

	arm_func_start FUN_020095C8
FUN_020095C8: @ 0x020095C8
	mcr p15, #0, r0, c6, c2, #0
	bx lr
	arm_func_end FUN_020095C8

	arm_func_start FUN_020095D0
FUN_020095D0: @ 0x020095D0
	ldr ip, _0200963C @ =0x02346640
	ldr ip, [ip]
	cmp ip, #0
	movne lr, pc
	bxne ip
	ldr ip, _02009640 @ =0x02000000
	stmdb ip!, {r0, r1, r2, r3, sp, lr}
	and r0, sp, #1
	mov sp, ip
	mrs r1, apsr
	and r1, r1, #0x1f
	teq r1, #0x17
	bne _0200960C
	bl FUN_02009644
	b _02009618
_0200960C:
	teq r1, #0x1b
	bne _02009618
	bl FUN_02009644
_02009618:
	ldr ip, _0200963C @ =0x02346640
	ldr ip, [ip]
	cmp ip, #0
_02009624:
	beq _02009624
_02009628:
	mov r0, r0
	b _02009628
	arm_func_end FUN_020095D0

	arm_func_start FUN_02009630
FUN_02009630: @ 0x02009630
	pop {r0, r1, r2, r3, ip, lr}
	mov sp, ip
	bx lr
	.align 2, 0
_0200963C: .4byte 0x02346640
_02009640: .4byte 0x02000000
	arm_func_end FUN_02009630

	arm_func_start FUN_02009644
FUN_02009644: @ 0x02009644
	push {r0, lr}
	bl FUN_02009658
	bl FUN_020096E8
	pop {r0, lr}
	bx lr
	arm_func_end FUN_02009644

	arm_func_start FUN_02009658
FUN_02009658: @ 0x02009658
	ldr r1, _020096E4 @ =0x02346644
	mrs r2, apsr
	str r2, [r1, #0x74]
	str r0, [r1, #0x6c]
	ldr r0, [ip]
	str r0, [r1, #4]
	ldr r0, [ip, #4]
	str r0, [r1, #8]
	ldr r0, [ip, #8]
	str r0, [r1, #0xc]
	ldr r0, [ip, #0xc]
	str r0, [r1, #0x10]
	ldr r2, [ip, #0x10]
	bic r2, r2, #1
	add r0, r1, #0x14
	stm r0, {r4, r5, r6, r7, r8, sb, sl, fp}
	str ip, [r1, #0x70]
	ldr r0, [r2]
	str r0, [r1, #0x64]
	ldr r3, [r2, #4]
	str r3, [r1]
	ldr r0, [r2, #8]
	str r0, [r1, #0x34]
	ldr r0, [r2, #0xc]
	str r0, [r1, #0x40]
	mrs r0, apsr
	orr r3, r3, #0x80
	bic r3, r3, #0x20
	msr cpsr_fsxc, r3
	str sp, [r1, #0x38]
	str lr, [r1, #0x3c]
	mrs r2, spsr
	str r2, [r1, #0x7c]
	msr cpsr_fsxc, r0
	bx lr
	.align 2, 0
_020096E4: .4byte 0x02346644
	arm_func_end FUN_02009658

	arm_func_start FUN_020096E8
FUN_020096E8: @ 0x020096E8
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r0, _02009744 @ =0x02346638
	ldr r0, [r0]
	cmp r0, #0
	addeq sp, sp, #4
	ldmeq sp!, {lr}
	bxeq lr
	mov r0, sp
	ldr r1, _02009748 @ =0x0000009F
	msr cpsr_fsxc, r1
	mov sp, r0
	bl FUN_0200958C
	ldr r1, _0200974C @ =0x0234663C
	ldr r0, _02009744 @ =0x02346638
	ldr r1, [r1]
	ldr r2, [r0]
	ldr r0, _02009750 @ =0x02346644
	.word 0xE12FFF32
	bl FUN_0200959C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009744: .4byte 0x02346638
_02009748: .4byte 0x0000009F
_0200974C: .4byte 0x0234663C
_02009750: .4byte 0x02346644
	arm_func_end FUN_020096E8

	arm_func_start FUN_02009754
FUN_02009754: @ 0x02009754
	ldr r0, _020097B0 @ =0x027FFD9C
	ldr r1, [r0]
	cmp r1, #0x2600000
	blo _02009774
	cmp r1, #0x2800000
	ldrlo r0, _020097B4 @ =0x02346640
	strlo r1, [r0]
	blo _02009780
_02009774:
	ldr r0, _020097B4 @ =0x02346640
	mov r1, #0
	str r1, [r0]
_02009780:
	ldr r0, _020097B4 @ =0x02346640
	ldr r0, [r0]
	cmp r0, #0
	ldreq r2, _020097B8 @ =0x02304A10
	ldreq r1, _020097B0 @ =0x027FFD9C
	ldreq r0, _020097BC @ =0x027E3000
	streq r2, [r1]
	streq r2, [r0, #0xfdc]
	ldr r0, _020097C0 @ =0x02346638
	mov r1, #0
	str r1, [r0]
	bx lr
	.align 2, 0
_020097B0: .4byte 0x027FFD9C
_020097B4: .4byte 0x02346640
_020097B8: .4byte 0x02304A10
_020097BC: .4byte 0x027E3000
_020097C0: .4byte 0x02346638
	arm_func_end FUN_02009754

	arm_func_start FUN_020097C4
FUN_020097C4: @ 0x020097C4
	ldr r1, _020097DC @ =0x023466C4
	mov r2, #1
	ldrh r3, [r1]
	orr r0, r3, r2, lsl r0
	strh r0, [r1]
	bx lr
	.align 2, 0
_020097DC: .4byte 0x023466C4
	arm_func_end FUN_020097C4

	arm_func_start FUN_020097E0
FUN_020097E0: @ 0x020097E0
	stmdb sp!, {lr}
	sub sp, sp, #0xc
	bl FUN_02009A90
	ldr r1, _02009880 @ =0x04000100
	ldr r3, _02009884 @ =0x023466D0
	ldrh ip, [r1]
	ldr r2, _02009888 @ =0x0000FFFF
	mvn r1, #0
	strh ip, [sp]
	ldr ip, [r3]
	ldr r3, [r3, #4]
	and r1, ip, r1
	and r2, r3, r2
	str r1, [sp, #4]
	ldr r1, _0200988C @ =0x04000214
	str r2, [sp, #8]
	ldr r1, [r1]
	ands r1, r1, #8
	beq _02009854
	ldrh r1, [sp]
	ands r1, r1, #0x8000
	bne _02009854
	ldr r3, [sp, #4]
	mov r1, #1
	ldr r2, [sp, #8]
	adds r3, r3, r1
	adc r1, r2, #0
	str r3, [sp, #4]
	str r1, [sp, #8]
_02009854:
	bl FUN_02009AA4
	ldr r2, [sp, #4]
	ldr r1, [sp, #8]
	ldrh r0, [sp]
	lsl r1, r1, #0x10
	orr r1, r1, r2, lsr #16
	orr r1, r1, r0, asr #31
	orr r0, r0, r2, lsl #16
	add sp, sp, #0xc
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009880: .4byte 0x04000100
_02009884: .4byte 0x023466D0
_02009888: .4byte 0x0000FFFF
_0200988C: .4byte 0x04000214
	arm_func_end FUN_020097E0

	arm_func_start FUN_02009890
FUN_02009890: @ 0x02009890
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _02009904 @ =0x023466D0
	ldr r1, _02009908 @ =0x023466CC
	ldr ip, [r2]
	mov r0, #1
	ldr r3, [r2, #4]
	adds ip, ip, r0
	ldr r0, [r1]
	adc r3, r3, #0
	str ip, [r2]
	str r3, [r2, #4]
	cmp r0, #0
	mov r3, #0
	beq _020098E8
	ldr r2, _0200990C @ =0x04000102
	ldr r0, _02009910 @ =0x04000100
	strh r3, [r2]
	strh r3, [r0]
	mov r0, #0xc1
	strh r0, [r2]
	str r3, [r1]
_020098E8:
	mov r0, #0
	ldr r1, _02009914 @ =0x02304CD0
	mov r2, r0
	bl FUN_02007A74
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009904: .4byte 0x023466D0
_02009908: .4byte 0x023466CC
_0200990C: .4byte 0x04000102
_02009910: .4byte 0x04000100
_02009914: .4byte 0x02304CD0
	arm_func_end FUN_02009890

	arm_func_start FUN_02009918
FUN_02009918: @ 0x02009918
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200999C @ =0x023466C8
	ldrh r0, [r1]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	mov r2, #1
	mov r0, #0
	strh r2, [r1]
	bl FUN_020097C4
	ldr r0, _020099A0 @ =0x023466D0
	mov r2, #0
	str r2, [r0]
	ldr r3, _020099A4 @ =0x04000102
	str r2, [r0, #4]
	ldr r0, _020099A8 @ =0x04000100
	strh r2, [r3]
	ldr r1, _020099AC @ =0x02304CD0
	strh r2, [r0]
	mov r2, #0xc1
	mov r0, #8
	strh r2, [r3]
	bl FUN_02007AC0
	mov r0, #8
	bl FUN_02007A08
	ldr r0, _020099B0 @ =0x023466CC
	mov r1, #0
	str r1, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200999C: .4byte 0x023466C8
_020099A0: .4byte 0x023466D0
_020099A4: .4byte 0x04000102
_020099A8: .4byte 0x04000100
_020099AC: .4byte 0x02304CD0
_020099B0: .4byte 0x023466CC
	arm_func_end FUN_02009918

	arm_func_start FUN_020099B4
FUN_020099B4: @ 0x020099B4
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _02009A04 @ =0x023466D8
	ldrh r0, [r1]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	mov r0, #1
	strh r0, [r1]
	bl FUN_020097C4
	ldr r1, _02009A08 @ =0x023466DC
	mov r2, #0
	mov r0, #0x10
	str r2, [r1]
	str r2, [r1, #4]
	bl FUN_020079C0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009A04: .4byte 0x023466D8
_02009A08: .4byte 0x023466DC
	arm_func_end FUN_020099B4

	arm_func_start FUN_02009A0C
FUN_02009A0C: @ 0x02009A0C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _02009A6C @ =0x023466E4
	ldrh r0, [r2]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	ldr r1, _02009A70 @ =0x023466F0
	mov r3, #0
	mov ip, #1
	mov r0, #4
	strh ip, [r2]
	str r3, [r1]
	str r3, [r1, #4]
	bl FUN_020079C0
	ldr r1, _02009A74 @ =0x023466EC
	mov r2, #0
	ldr r0, _02009A78 @ =0x023466E8
	str r2, [r1]
	str r2, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009A6C: .4byte 0x023466E4
_02009A70: .4byte 0x023466F0
_02009A74: .4byte 0x023466EC
_02009A78: .4byte 0x023466E8
	arm_func_end FUN_02009A0C

	arm_func_start FUN_02009A7C
FUN_02009A7C: @ 0x02009A7C
	mrs r0, apsr
	bic r1, r0, #0x80
	msr cpsr_c, r1
	and r0, r0, #0x80
	bx lr
	arm_func_end FUN_02009A7C

	arm_func_start FUN_02009A90
FUN_02009A90: @ 0x02009A90
	mrs r0, apsr
	orr r1, r0, #0x80
	msr cpsr_c, r1
	and r0, r0, #0x80
	bx lr
	arm_func_end FUN_02009A90

	arm_func_start FUN_02009AA4
FUN_02009AA4: @ 0x02009AA4
	mrs r1, apsr
	bic r2, r1, #0x80
	orr r2, r2, r0
	msr cpsr_c, r2
	and r0, r1, #0x80
	bx lr
	arm_func_end FUN_02009AA4

	arm_func_start FUN_02009ABC
FUN_02009ABC: @ 0x02009ABC
	mrs r0, apsr
	orr r1, r0, #0xc0
	msr cpsr_c, r1
	and r0, r0, #0xc0
	bx lr
	arm_func_end FUN_02009ABC

	arm_func_start FUN_02009AD0
FUN_02009AD0: @ 0x02009AD0
	mrs r1, apsr
	bic r2, r1, #0xc0
	orr r2, r2, r0
	msr cpsr_c, r2
	and r0, r1, #0xc0
	bx lr
	arm_func_end FUN_02009AD0

	arm_func_start FUN_02009AE8
FUN_02009AE8: @ 0x02009AE8
	mrs r0, apsr
	and r0, r0, #0x80
	bx lr
	arm_func_end FUN_02009AE8

	arm_func_start FUN_02009AF4
FUN_02009AF4: @ 0x02009AF4
	mrs r0, apsr
	and r0, r0, #0x1f
	bx lr
_02009B00:
	subs r0, r0, #4
	bhs _02009B00
	bx lr
	arm_func_end FUN_02009AF4

	arm_func_start FUN_02009B0C
FUN_02009B0C: @ 0x02009B0C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #1
	blx SVC_WaitByLoop
	mov r0, #1
	mov r1, r0
	bl FUN_020077B8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02009B0C

	arm_func_start FUN_02009B34
FUN_02009B34: @ 0x02009B34
	stmdb sp!, {lr}
	sub sp, sp, #4
	and r0, r1, #0x7f00
	lsl r0, r0, #8
	lsr r0, r0, #0x10
	cmp r0, #0x10
	ldreq r0, _02009B74 @ =0x023466FC
	moveq r1, #1
	strheq r1, [r0]
	addeq sp, sp, #4
	ldmeq sp!, {lr}
	bxeq lr
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02009B74: .4byte 0x023466FC
	arm_func_end FUN_02009B34

	arm_func_start FUN_02009B78
FUN_02009B78: @ 0x02009B78
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r0, _02009BD8 @ =0x023466F8
	ldrh r1, [r0]
	cmp r1, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	mov r1, #1
	strh r1, [r0]
	bl FUN_0200A3C0
	mov r5, #0xc
	mov r4, #1
_02009BAC:
	mov r0, r5
	mov r1, r4
	bl FUN_0200A5A4
	cmp r0, #0
	beq _02009BAC
	ldr r1, _02009BDC @ =0x02304F74
	mov r0, #0xc
	bl FUN_0200A5CC
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02009BD8: .4byte 0x023466F8
_02009BDC: .4byte 0x02304F74
	arm_func_end FUN_02009B78

	arm_func_start FUN_02009BE0
FUN_02009BE0: @ 0x02009BE0
	push {r4, lr}
	ldr ip, _02009C58 @ =0x027FFC80
	mov r4, r0
	ldrh r2, [ip, #0x64]
	add r0, ip, #6
	add r1, r4, #4
	lsl r2, r2, #0x1d
	lsr r2, r2, #0x1d
	strb r2, [r4]
	ldrb r3, [ip, #2]
	mov r2, #0x14
	lsl r3, r3, #0x1c
	lsr r3, r3, #0x1c
	strb r3, [r4, #1]
	ldrb r3, [ip, #3]
	strb r3, [r4, #2]
	ldrb r3, [ip, #4]
	strb r3, [r4, #3]
	ldrb r3, [ip, #0x1a]
	strh r3, [r4, #0x18]
	ldrb r3, [ip, #0x50]
	strh r3, [r4, #0x4e]
	bl FUN_0200A0B0
	ldr r0, _02009C58 @ =0x027FFC80
	add r1, r4, #0x1a
	add r0, r0, #0x1c
	mov r2, #0x34
	bl FUN_0200A0B0
	pop {r4, lr}
	bx lr
	.align 2, 0
_02009C58: .4byte 0x027FFC80
	arm_func_end FUN_02009BE0

	arm_func_start FUN_02009C5C
FUN_02009C5C: @ 0x02009C5C
	ldr ip, _02009C70 @ =0x02305618
	mov r1, r0
	ldr r0, _02009C74 @ =0x027FFCF4
	mov r2, #6
	bx ip
	.align 2, 0
_02009C70: .4byte 0x02305618
_02009C74: .4byte 0x027FFCF4
	arm_func_end FUN_02009C5C

	arm_func_start FUN_02009C78
FUN_02009C78: @ 0x02009C78
	clz r0, r0
	bx lr
	arm_func_end FUN_02009C78

	arm_func_start FUN_02009C80
FUN_02009C80: @ 0x02009C80
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov r5, r0
	mov sl, r1
	bl FUN_02009A90
	ldr r4, _02009CFC @ =0x02346700
	ldr r1, _02009D00 @ =0x000001FF
	ldr r2, [r4]
	mov r8, r0
	and r0, r5, r2
	and sb, r0, r1
	ldr r6, _02009D04 @ =0x02346704
	mov r7, #1
	mov r5, #0
_02009CB4:
	mov r0, sb
	bl FUN_02009C78
	rsbs r2, r0, #0x1f
	bmi _02009CEC
	lsl r1, r2, #1
	ldrh r0, [r6, r1]
	mvn r2, r7, lsl r2
	cmp sl, r0
	ldreq r0, [r4]
	and sb, sb, r2
	andeq r0, r0, r2
	strheq r5, [r6, r1]
	streq r0, [r4]
	b _02009CB4
_02009CEC:
	mov r0, r8
	bl FUN_02009AA4
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	.align 2, 0
_02009CFC: .4byte 0x02346700
_02009D00: .4byte 0x000001FF
_02009D04: .4byte 0x02346704
	arm_func_end FUN_02009C80

	arm_func_start FUN_02009D08
FUN_02009D08: @ 0x02009D08
	ldr r0, _02009D34 @ =0x02346700
	mov r3, #0
	str r3, [r0]
	ldr r0, _02009D38 @ =0x02346704
	mov r2, r3
_02009D1C:
	lsl r1, r3, #1
	add r3, r3, #1
	strh r2, [r0, r1]
	cmp r3, #9
	blt _02009D1C
	bx lr
	.align 2, 0
_02009D34: .4byte 0x02346700
_02009D38: .4byte 0x02346704
	arm_func_end FUN_02009D08

	arm_func_start FUN_02009D3C
FUN_02009D3C: @ 0x02009D3C
	mov r0, #0
	mcr p15, #0, r0, c7, c0, #4
	bx lr
	arm_func_end FUN_02009D3C

	arm_func_start FUN_02009D48
FUN_02009D48: @ 0x02009D48
	stmdb sp!, {lr}
	sub sp, sp, #4
_02009D50:
	bl FUN_02009A90
	bl FUN_02009D3C
	b _02009D50
	arm_func_end FUN_02009D48

	arm_func_start FUN_02009D5C
FUN_02009D5C: @ 0x02009D5C
	ldr r1, _02009D68 @ =0x04000247
	strb r0, [r1]
	bx lr
	.align 2, 0
_02009D68: .4byte 0x04000247
	arm_func_end FUN_02009D5C

	arm_func_start FUN_02009D6C
FUN_02009D6C: @ 0x02009D6C
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	cmp r3, #0
	and r0, r1, #0xff000000
	beq _02009D9C
	cmp r3, #0x800000
	subeq r1, r1, r2
	b _02009DA0
_02009D9C:
	add r1, r1, r2
_02009DA0:
	cmp r0, #0x4000000
	beq _02009DCC
	cmp r0, #0x8000000
	bhs _02009DCC
	and r0, r1, #0xff000000
	cmp r0, #0x4000000
	beq _02009DCC
	cmp r0, #0x8000000
	addlo sp, sp, #4
	ldmlo sp!, {lr}
	bxlo lr
_02009DCC:
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02009D6C

	arm_func_start FUN_02009DDC
FUN_02009DDC: @ 0x02009DDC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	ldr r4, _02009E8C @ =0x040000B8
	mov r7, r0
	mov r6, r1
	mov r5, #0
_02009DF4:
	cmp r5, r7
	beq _02009E70
	ldr r1, [r4]
	ands r0, r1, #0x80000000
	beq _02009E70
	and r0, r1, #0x38000000
	cmp r0, r6
	beq _02009E70
	cmp r0, #0x8000000
	bne _02009E24
	cmp r6, #0x10000000
	beq _02009E70
_02009E24:
	cmp r0, #0x10000000
	bne _02009E34
	cmp r6, #0x8000000
	beq _02009E70
_02009E34:
	cmp r0, #0x18000000
	beq _02009E6C
	cmp r0, #0x20000000
	beq _02009E6C
	cmp r0, #0x28000000
	beq _02009E6C
	cmp r0, #0x30000000
	beq _02009E6C
	cmp r0, #0x38000000
	beq _02009E6C
	cmp r0, #0x8000000
	beq _02009E6C
	cmp r0, #0x10000000
	bne _02009E70
_02009E6C:
	bl FUN_02009D48
_02009E70:
	add r5, r5, #1
	cmp r5, #3
	add r4, r4, #0xc
	blt _02009DF4
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_02009E8C: .4byte 0x040000B8
	arm_func_end FUN_02009DDC

	arm_func_start FUN_02009E90
FUN_02009E90: @ 0x02009E90
	push {r4, lr}
	mov r4, r0
	bl FUN_02009A90
	mov r1, #6
	mul r1, r4, r1
	add r1, r1, #5
	lsl r1, r1, #1
	add r1, r1, #0x4000000
	ldrh r2, [r1, #0xb0]
	cmp r4, #0
	bic r2, r2, #0x3a00
	strh r2, [r1, #0xb0]
	ldrh r2, [r1, #0xb0]
	bic r2, r2, #0x8000
	strh r2, [r1, #0xb0]
	ldrh r2, [r1, #0xb0]
	ldrh r1, [r1, #0xb0]
	bne _02009F00
	mov r1, #0xc
	mul ip, r4, r1
	ldr r1, _02009F0C @ =0x040000B0
	add r2, ip, #0x4000000
	mov r3, #0
	str r3, [r2, #0xb0]
	add r2, ip, r1
	ldr r1, _02009F10 @ =0x81400001
	str r3, [r2, #4]
	str r1, [r2, #8]
_02009F00:
	bl FUN_02009AA4
	pop {r4, lr}
	bx lr
	.align 2, 0
_02009F0C: .4byte 0x040000B0
_02009F10: .4byte 0x81400001
	arm_func_end FUN_02009E90

	arm_func_start FUN_02009F14
FUN_02009F14: @ 0x02009F14
	push {r4, r5, r6, r7, r8, lr}
	movs r5, r3
	mov r8, r0
	mov r7, r1
	mov r6, r2
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r2, r5
	mov r3, #0
	bl FUN_02009D6C
	mov r0, #3
	mul r1, r8, r0
	ldr r0, _02009F88 @ =0x040000B0
	add r1, r1, #2
	add r4, r0, r1, lsl #2
_02009F50:
	ldr r0, [r4]
	ands r0, r0, #0x80000000
	bne _02009F50
	lsr r3, r5, #1
	mov r0, r8
	mov r1, r7
	mov r2, r6
	orr r3, r3, #0x80000000
	bl FUN_01CFCDD4
_02009F74:
	ldr r0, [r4]
	ands r0, r0, #0x80000000
	bne _02009F74
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_02009F88: .4byte 0x040000B0
	arm_func_end FUN_02009F14

	arm_func_start FUN_02009F8C
FUN_02009F8C: @ 0x02009F8C
	push {r4, r5, r6, r7, r8, lr}
	mov r5, r3
	mov r6, r2
	mov r2, r5
	mov r3, #0
	mov r8, r0
	mov r7, r1
	bl FUN_02009D6C
	cmp r5, #0
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r0, #3
	mul r1, r8, r0
	ldr r0, _0200A004 @ =0x040000B0
	add r1, r1, #2
	add r4, r0, r1, lsl #2
_02009FCC:
	ldr r0, [r4]
	ands r0, r0, #0x80000000
	bne _02009FCC
	lsr r3, r5, #2
	mov r0, r8
	mov r1, r7
	mov r2, r6
	orr r3, r3, #0x84000000
	bl FUN_01CFCDD4
_02009FF0:
	ldr r0, [r4]
	ands r0, r0, #0x80000000
	bne _02009FF0
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200A004: .4byte 0x040000B0
	arm_func_end FUN_02009F8C

	arm_func_start FUN_0200A008
FUN_0200A008: @ 0x0200A008
	push {r4, r5, r6, r7, r8, lr}
	movs r4, r3
	mov r8, r0
	mov r7, r1
	mov r6, r2
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r0, #3
	mul r1, r8, r0
	ldr r0, _0200A090 @ =0x040000B0
	add r1, r1, #2
	add r5, r0, r1, lsl #2
_0200A038:
	ldr r0, [r5]
	ands r0, r0, #0x80000000
	bne _0200A038
	bl FUN_02009A90
	ldr r1, _0200A094 @ =0x040000E0
	lsl r2, r8, #2
	lsr r3, r4, #2
	mov r4, r0
	add ip, r2, #0x4000000
	mov r0, r8
	mov r2, r7
	add r1, r1, r8, lsl #2
	orr r3, r3, #0x85000000
	str r6, [ip, #0xe0]
	bl FUN_01CFCD74
	mov r0, r4
	bl FUN_02009AA4
_0200A07C:
	ldr r0, [r5]
	ands r0, r0, #0x80000000
	bne _0200A07C
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200A090: .4byte 0x040000B0
_0200A094: .4byte 0x040000E0
	arm_func_end FUN_0200A008

	arm_func_start FUN_0200A098
FUN_0200A098: @ 0x0200A098
	mov r3, #0
_0200A09C:
	cmp r3, r2
	strhlt r0, [r1, r3]
	addlt r3, r3, #2
	blt _0200A09C
	bx lr
	arm_func_end FUN_0200A098

	arm_func_start FUN_0200A0B0
FUN_0200A0B0: @ 0x0200A0B0
	mov ip, #0
_0200A0B4:
	cmp ip, r2
	ldrhlt r3, [r0, ip]
	strhlt r3, [r1, ip]
	addlt ip, ip, #2
	blt _0200A0B4
	bx lr
	arm_func_end FUN_0200A0B0

	arm_func_start FUN_0200A0CC
FUN_0200A0CC: @ 0x0200A0CC
	add ip, r1, r2
_0200A0D0:
	cmp r1, ip
	stmlt r1!, {r0}
	blt _0200A0D0
	bx lr
	arm_func_end FUN_0200A0CC

	arm_func_start FUN_0200A0E0
FUN_0200A0E0: @ 0x0200A0E0
	add ip, r1, r2
_0200A0E4:
	cmp r1, ip
	ldmlt r0!, {r2}
	stmlt r1!, {r2}
	blt _0200A0E4
	bx lr
	arm_func_end FUN_0200A0E0

	arm_func_start FUN_0200A0F8
FUN_0200A0F8: @ 0x0200A0F8
	push {r4, r5, r6, r7, r8, sb}
	add sb, r1, r2
	lsr ip, r2, #5
	add ip, r1, ip, lsl #5
	mov r2, r0
	mov r3, r2
	mov r4, r2
	mov r5, r2
	mov r6, r2
	mov r7, r2
	mov r8, r2
_0200A124:
	cmp r1, ip
	stmlt r1!, {r0, r2, r3, r4, r5, r6, r7, r8}
	blt _0200A124
_0200A130:
	cmp r1, sb
	stmlt r1!, {r0}
	blt _0200A130
	pop {r4, r5, r6, r7, r8, sb}
	bx lr
	arm_func_end FUN_0200A0F8

	arm_func_start FUN_0200A144
FUN_0200A144: @ 0x0200A144
	cmp r2, #0
	bxeq lr
	tst r0, #1
	beq _0200A170
	ldrh ip, [r0, #-1]
	and ip, ip, #0xff
	orr r3, ip, r1, lsl #8
	strh r3, [r0, #-1]
	add r0, r0, #1
	subs r2, r2, #1
	bxeq lr
_0200A170:
	cmp r2, #2
	blo _0200A1B8
	orr r1, r1, r1, lsl #8
	tst r0, #2
	beq _0200A190
	strh r1, [r0], #2
	subs r2, r2, #2
	bxeq lr
_0200A190:
	orr r1, r1, r1, lsl #16
	bics r3, r2, #3
	beq _0200A1B0
	sub r2, r2, r3
	add ip, r3, r0
_0200A1A4:
	str r1, [r0], #4
	cmp r0, ip
	blo _0200A1A4
_0200A1B0:
	tst r2, #2
	strhne r1, [r0], #2
_0200A1B8:
	tst r2, #1
	bxeq lr
	ldrh r3, [r0]
	and r3, r3, #0xff00
	and r1, r1, #0xff
	orr r1, r1, r3
	strh r1, [r0]
	bx lr
	arm_func_end FUN_0200A144

	arm_func_start FUN_0200A1D8
FUN_0200A1D8: @ 0x0200A1D8
	cmp r2, #0
	bxeq lr
	tst r1, #1
	beq _0200A218
	ldrh ip, [r1, #-1]
	and ip, ip, #0xff
	tst r0, #1
	ldrhne r3, [r0, #-1]
	lsrne r3, r3, #8
	ldrheq r3, [r0]
	orr r3, ip, r3, lsl #8
	strh r3, [r1, #-1]
	add r0, r0, #1
	add r1, r1, #1
	subs r2, r2, #1
	bxeq lr
_0200A218:
	eor ip, r1, r0
	tst ip, #1
	beq _0200A26C
	bic r0, r0, #1
	ldrh ip, [r0], #2
	lsr r3, ip, #8
	subs r2, r2, #2
	blo _0200A250
_0200A238:
	ldrh ip, [r0], #2
	orr ip, r3, ip, lsl #8
	strh ip, [r1], #2
	lsr r3, ip, #0x10
	subs r2, r2, #2
	bhs _0200A238
_0200A250:
	tst r2, #1
	bxeq lr
	ldrh ip, [r1]
	and ip, ip, #0xff00
	orr ip, ip, r3
	strh ip, [r1]
	bx lr
_0200A26C:
	tst ip, #2
	beq _0200A298
	bics r3, r2, #1
	beq _0200A2E4
	sub r2, r2, r3
	add ip, r3, r1
_0200A284:
	ldrh r3, [r0], #2
	strh r3, [r1], #2
	cmp r1, ip
	blo _0200A284
	b _0200A2E4
_0200A298:
	cmp r2, #2
	blo _0200A2E4
	tst r1, #2
	beq _0200A2B8
	ldrh r3, [r0], #2
	strh r3, [r1], #2
	subs r2, r2, #2
	bxeq lr
_0200A2B8:
	bics r3, r2, #3
	beq _0200A2D8
	sub r2, r2, r3
	add ip, r3, r1
_0200A2C8:
	ldr r3, [r0], #4
	str r3, [r1], #4
	cmp r1, ip
	blo _0200A2C8
_0200A2D8:
	tst r2, #2
	ldrhne r3, [r0], #2
	strhne r3, [r1], #2
_0200A2E4:
	tst r2, #1
	bxeq lr
	ldrh r2, [r1]
	ldrh r0, [r0]
	and r2, r2, #0xff00
	and r0, r0, #0xff
	orr r0, r2, r0
	strh r0, [r1]
	bx lr
	arm_func_end FUN_0200A1D8

	arm_func_start FUN_0200A308
FUN_0200A308: @ 0x0200A308
	.word 0xE1010090
	bx lr
	arm_func_end FUN_0200A308

	arm_func_start FUN_0200A310
FUN_0200A310: @ 0x0200A310
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r5, r1
	mov r6, r0
	mov r7, r3
	mvn r1, #0
	mov r4, r2
	bl FUN_02009DDC
	mov r0, r6
	mov r1, r5
	mov r2, r7
	mov r3, #0x1000000
	bl FUN_02009D6C
	cmp r7, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, #3
	mul r1, r6, r0
	ldr r0, _0200A394 @ =0x040000B0
	add r1, r1, #2
	add r1, r0, r1, lsl #2
_0200A368:
	ldr r0, [r1]
	ands r0, r0, #0x80000000
	bne _0200A368
	ldr r3, _0200A398 @ =0xAF000001
	mov r0, r6
	mov r1, r5
	mov r2, r4
	bl FUN_01CFCE48
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200A394: .4byte 0x040000B0
_0200A398: .4byte 0xAF000001
	arm_func_end FUN_0200A310

	arm_func_start FUN_0200A39C
FUN_0200A39C: @ 0x0200A39C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #3
	bl FUN_02009D5C
	mov r0, #0
	bl FUN_02009E90
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200A39C

	arm_func_start FUN_0200A3C0
FUN_0200A3C0: @ 0x0200A3C0
	ldr ip, _0200A3C8 @ =FUN_02305A78
	bx ip
	.align 2, 0
_0200A3C8: .4byte FUN_02305A78
	arm_func_end FUN_0200A3C0

	arm_func_start FUN_0200A3CC
FUN_0200A3CC: @ 0x0200A3CC
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	sub sp, sp, #8
	ldr sl, _0200A4E4 @ =0x04000184
	ldr r5, _0200A4E8 @ =0x0234671C
	ldr r4, _0200A4EC @ =0x04000188
	mov r7, #0x4100000
	mov r6, #0
	mvn r8, #3
	mvn sb, #2
_0200A3F0:
	ldrh r0, [sl]
	ands r0, r0, #0x4000
	ldrhne r0, [sl]
	movne r1, sb
	orrne r0, r0, #0xc000
	strhne r0, [sl]
	bne _0200A438
	bl FUN_02009A90
	ldrh r1, [sl]
	ands r1, r1, #0x100
	beq _0200A428
	bl FUN_02009AA4
	mov r1, r8
	b _0200A438
_0200A428:
	ldr r1, [r7]
	str r1, [sp]
	bl FUN_02009AA4
	mov r1, r6
_0200A438:
	cmp r1, r8
	addeq sp, sp, #8
	popeq {r4, r5, r6, r7, r8, sb, sl, lr}
	bxeq lr
	mvn r0, #2
	cmp r1, r0
	beq _0200A3F0
	ldr r1, [sp]
	lsl r0, r1, #0x1b
	lsrs r0, r0, #0x1b
	beq _0200A3F0
	ldr r3, [r5, r0, lsl #2]
	cmp r3, #0
	beq _0200A484
	lsl r2, r1, #0x1a
	lsr r1, r1, #6
	lsr r2, r2, #0x1f
	.word 0xE12FFF33
	b _0200A3F0
_0200A484:
	lsl r0, r1, #0x1a
	lsrs r0, r0, #0x1f
	bne _0200A3F0
	orr r0, r1, #0x20
	str r0, [sp]
	ldrh r0, [sl]
	ands r0, r0, #0x4000
	ldrhne r0, [sl]
	orrne r0, r0, #0xc000
	strhne r0, [sl]
	bne _0200A3F0
	bl FUN_02009A90
	ldrh r1, [sl]
	ands r1, r1, #2
	beq _0200A4C8
	bl FUN_02009AA4
	b _0200A3F0
_0200A4C8:
	ldr r1, [sp]
	str r1, [r4]
	bl FUN_02009AA4
	b _0200A3F0
	arm_func_end FUN_0200A3CC

	arm_func_start FUN_0200A4D8
FUN_0200A4D8: @ 0x0200A4D8
	add sp, sp, #8
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	.align 2, 0
_0200A4E4: .4byte 0x04000184
_0200A4E8: .4byte 0x0234671C
_0200A4EC: .4byte 0x04000188
	arm_func_end FUN_0200A4D8

	arm_func_start FUN_0200A4F0
FUN_0200A4F0: @ 0x0200A4F0
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r3, [sp]
	and r0, r0, #0x1f
	bic r3, r3, #0x1f
	orr ip, r3, r0
	bic r3, ip, #0x20
	and r0, r2, #1
	orr r3, r3, r0, lsl #5
	str ip, [sp]
	and r2, r3, #0x3f
	bic r0, r1, #0xfc000000
	orr r0, r2, r0, lsl #6
	str r3, [sp]
	ldr r2, _0200A59C @ =0x04000184
	str r0, [sp]
	ldrh r0, [r2]
	ands r0, r0, #0x4000
	ldrhne r1, [r2]
	addne sp, sp, #4
	mvnne r0, #0
	orrne r1, r1, #0xc000
	strhne r1, [r2]
	ldmne sp!, {lr}
	bxne lr
	bl FUN_02009A90
	ldr r1, _0200A59C @ =0x04000184
	ldrh r1, [r1]
	ands r1, r1, #2
	beq _0200A57C
	bl FUN_02009AA4
	add sp, sp, #4
	mvn r0, #1
	ldm sp!, {lr}
	bx lr
_0200A57C:
	ldr r2, [sp]
	ldr r1, _0200A5A0 @ =0x04000188
	str r2, [r1]
	bl FUN_02009AA4
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200A59C: .4byte 0x04000184
_0200A5A0: .4byte 0x04000188
	arm_func_end FUN_0200A4F0

	arm_func_start FUN_0200A5A4
FUN_0200A5A4: @ 0x0200A5A4
	ldr r2, _0200A5C8 @ =0x027FFC00
	mov r3, #1
	add r1, r2, r1, lsl #2
	lsl r2, r3, r0
	ldr r0, [r1, #0x388]
	ands r0, r2, r0
	moveq r3, #0
	mov r0, r3
	bx lr
	.align 2, 0
_0200A5C8: .4byte 0x027FFC00
	arm_func_end FUN_0200A5A4

	arm_func_start FUN_0200A5CC
FUN_0200A5CC: @ 0x0200A5CC
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r4, r0
	mov r5, r1
	bl FUN_02009A90
	ldr r1, _0200A630 @ =0x0234671C
	cmp r5, #0
	str r5, [r1, r4, lsl #2]
	beq _0200A608
	ldr r3, _0200A634 @ =0x027FFC00
	mov r1, #1
	ldr r2, [r3, #0x388]
	orr r1, r2, r1, lsl r4
	str r1, [r3, #0x388]
	b _0200A620
_0200A608:
	ldr r3, _0200A634 @ =0x027FFC00
	mov r1, #1
	mvn r1, r1, lsl r4
	ldr r2, [r3, #0x388]
	and r1, r2, r1
	str r1, [r3, #0x388]
_0200A620:
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200A630: .4byte 0x0234671C
_0200A634: .4byte 0x027FFC00
	arm_func_end FUN_0200A5CC

	arm_func_start FUN_0200A638
FUN_0200A638: @ 0x0200A638
	push {r4, r5, lr}
	sub sp, sp, #4
	bl FUN_02009A90
	ldr r1, _0200A728 @ =0x02346718
	mov r4, r0
	ldrh r0, [r1]
	cmp r0, #0
	bne _0200A714
	mov r2, #1
	ldr r0, _0200A72C @ =0x027FFC00
	strh r2, [r1]
	mov r2, #0
	str r2, [r0, #0x388]
	ldr r0, _0200A730 @ =0x0234671C
	mov r1, r2
_0200A674:
	str r1, [r0, r2, lsl #2]
	add r2, r2, #1
	cmp r2, #0x20
	blt _0200A674
	ldr r2, _0200A734 @ =0x0000C408
	ldr r1, _0200A738 @ =0x04000184
	mov r0, #0x40000
	strh r2, [r1]
	bl FUN_0200798C
	ldr r1, _0200A73C @ =0x0230580C
	mov r0, #0x40000
	bl FUN_02007AC0
	mov r0, #0x40000
	bl FUN_02007A08
	mov ip, #0
	ldr r3, _0200A740 @ =0x04000180
	mov r1, ip
	mov r2, #0x3e8
_0200A6BC:
	ldrh r0, [r3]
	ands lr, r0, #0xf
	lsl r0, lr, #8
	strh r0, [r3]
	bne _0200A6D8
	cmp ip, #4
	bgt _0200A714
_0200A6D8:
	ldrh r0, [r3]
	mov r5, r2
	and r0, r0, #0xf
	cmp r0, lr
	bne _0200A70C
_0200A6EC:
	cmp r5, #0
	movle ip, r1
	ble _0200A70C
	ldrh r0, [r3]
	sub r5, r5, #1
	and r0, r0, #0xf
	cmp r0, lr
	beq _0200A6EC
_0200A70C:
	add ip, ip, #1
	b _0200A6BC
_0200A714:
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200A728: .4byte 0x02346718
_0200A72C: .4byte 0x027FFC00
_0200A730: .4byte 0x0234671C
_0200A734: .4byte 0x0000C408
_0200A738: .4byte 0x04000184
_0200A73C: .4byte 0x0230580C
_0200A740: .4byte 0x04000180
	arm_func_end FUN_0200A638

	arm_func_start FUN_0200A744
FUN_0200A744: @ 0x0200A744
	push {r4, r5, r6, r7, r8, lr}
	mov r8, r0
	ldr r0, [r8, #0xc]
	mov r7, r1
	mov r1, #1
	ldr r5, [r8, #8]
	lsl r4, r1, r7
	ands r0, r0, #4
	moveq r1, #0
	cmp r1, #0
	ldrne r0, [r5, #0x1c]
	orrne r0, r0, #0x200
	strne r0, [r5, #0x1c]
	ldreq r0, [r5, #0x1c]
	orreq r0, r0, #0x100
	streq r0, [r5, #0x1c]
	ldr r0, [r5, #0x58]
	ands r0, r0, r4
	beq _0200A7F4
	ldr r2, [r5, #0x54]
	mov r0, r8
	mov r1, r7
	.word 0xE12FFF32
	mov r6, r0
	cmp r6, #8
	addls pc, pc, r6, lsl #2
	b _0200A7F8
_0200A7B0: @ jump table
	b _0200A7D4 @ case 0
	b _0200A7D4 @ case 1
	b _0200A7F8 @ case 2
	b _0200A7F8 @ case 3
	b _0200A7D4 @ case 4
	b _0200A7F8 @ case 5
	b _0200A7F8 @ case 6
	b _0200A7F8 @ case 7
	b _0200A7DC @ case 8
_0200A7D4:
	str r6, [r8, #0x14]
	b _0200A7F8
_0200A7DC:
	ldr r1, [r5, #0x58]
	mvn r0, r4
	and r0, r1, r0
	str r0, [r5, #0x58]
	mov r6, #7
	b _0200A7F8
_0200A7F4:
	mov r6, #7
_0200A7F8:
	cmp r6, #7
	bne _0200A814
	ldr r1, _0200A8BC @ =0x02314204
	mov r0, r8
	ldr r1, [r1, r7, lsl #2]
	.word 0xE12FFF31
	mov r6, r0
_0200A814:
	cmp r6, #6
	bne _0200A870
	ldr r0, [r8, #0xc]
	ands r0, r0, #4
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	beq _0200A8B0
	bl FUN_02009A90
	ldr r1, [r5, #0x1c]
	mov r4, r0
	ands r0, r1, #0x200
	beq _0200A860
	add r6, r5, #0xc
_0200A84C:
	mov r0, r6
	bl FUN_0200819C
	ldr r0, [r5, #0x1c]
	ands r0, r0, #0x200
	bne _0200A84C
_0200A860:
	mov r0, r4
	ldr r6, [r8, #0x14]
	bl FUN_02009AA4
	b _0200A8B0
_0200A870:
	ldr r0, [r8, #0xc]
	ands r0, r0, #4
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	ldrne r0, [r5, #0x1c]
	bicne r0, r0, #0x200
	strne r0, [r5, #0x1c]
	strne r6, [r8, #0x14]
	bne _0200A8B0
	ldr r1, [r5, #0x1c]
	mov r0, r8
	bic r2, r1, #0x100
	mov r1, r6
	str r2, [r5, #0x1c]
	bl FUN_0200A8C0
_0200A8B0:
	mov r0, r6
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200A8BC: .4byte 0x02314204
	arm_func_end FUN_0200A744

	arm_func_start FUN_0200A8C0
FUN_0200A8C0: @ 0x0200A8C0
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	bl FUN_02009A90
	ldr r1, [r6]
	mov r4, r0
	ldr r0, [r6, #4]
	cmp r1, #0
	strne r0, [r1, #4]
	cmp r0, #0
	strne r1, [r0]
	mov r0, #0
	str r0, [r6]
	ldr r1, [r6]
	add r0, r6, #0x18
	str r1, [r6, #4]
	ldr r1, [r6, #0xc]
	bic r1, r1, #0x4f
	str r1, [r6, #0xc]
	str r5, [r6, #0x14]
	bl FUN_0200811C
	mov r0, r4
	bl FUN_02009AA4
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0200A8C0

	arm_func_start FUN_0200A924
FUN_0200A924: @ 0x0200A924
	mov r0, #0
	bx lr
	arm_func_end FUN_0200A924

	arm_func_start FUN_0200A92C
FUN_0200A92C: @ 0x0200A92C
	ldr r1, [r0, #0x30]
	str r1, [r0, #0x24]
	ldr r1, [r0, #0x30]
	str r1, [r0, #0x2c]
	ldr r1, [r0, #0x34]
	str r1, [r0, #0x28]
	ldr r1, [r0, #0x38]
	str r1, [r0, #0x20]
	mov r0, #0
	bx lr
	arm_func_end FUN_0200A92C

	arm_func_start FUN_0200A954
FUN_0200A954: @ 0x0200A954
	push {r4, r5, lr}
	sub sp, sp, #0x14
	mov r5, r0
	ldr r1, [r5, #8]
	ldr r4, [r5, #0x34]
	ldr r0, [r1, #0x30]
	lsl r2, r4, #3
	cmp r2, r0
	addhs sp, sp, #0x14
	movhs r0, #1
	pophs {r4, r5, lr}
	bxhs lr
	str r1, [sp, #8]
	ldr r1, [r1, #0x2c]
	add r0, sp, #8
	add r3, r1, r2
	add r1, sp, #0
	mov r2, #8
	str r3, [sp, #0xc]
	bl FUN_0200B240
	cmp r0, #0
	addne sp, sp, #0x14
	popne {r4, r5, lr}
	bxne lr
	ldr r1, [sp]
	mov r0, r5
	str r1, [r5, #0x30]
	ldr r2, [sp, #4]
	mov r1, #7
	str r2, [r5, #0x34]
	str r4, [r5, #0x38]
	bl FUN_0200A744
	add sp, sp, #0x14
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200A954

	arm_func_start FUN_0200A9E0
FUN_0200A9E0: @ 0x0200A9E0
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xe4
	mov r4, r0
	ldr r1, [r4, #8]
	add r0, sp, #0x98
	add fp, r4, #0x30
	str r1, [sp]
	bl FUN_0200BE60
	ldr r0, [r4, #8]
	str r0, [sp, #0xa0]
	ldr r0, [r4, #0xc]
	ands r0, r0, #0x20
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	ldrhne r5, [r4, #0x24]
	movne r4, #0x10000
	bne _0200AACC
	ldrh r0, [fp, #8]
	ldr r4, [r4, #0x20]
	cmp r0, #0
	ldrhne r5, [fp, #0xa]
	bne _0200AACC
	mov sl, #0
	mov sb, sl
	mov r5, #0x10000
	add r8, sp, #0x98
	mov r6, #3
	mov r7, #1
_0200AA54:
	mov r0, r8
	mov r1, sl
	bl FUN_0200B20C
	add r2, sp, #4
	cmp sl, #0
	mov r0, r8
	mov r1, r6
	ldreq sb, [sp, #0xc4]
	str r2, [sp, #0xc8]
	str r7, [sp, #0xcc]
	bl FUN_0200A744
	cmp r0, #0
	bne _0200AAB8
_0200AA88:
	ldr r0, [sp, #0x10]
	cmp r0, #0
	bne _0200AAA4
	ldr r0, [sp, #8]
	cmp r0, r4
	ldrheq r5, [sp, #0xbc]
	beq _0200AAB8
_0200AAA4:
	mov r0, r8
	mov r1, r6
	bl FUN_0200A744
	cmp r0, #0
	beq _0200AA88
_0200AAB8:
	cmp r5, #0x10000
	bne _0200AACC
	add sl, sl, #1
	cmp sl, sb
	blo _0200AA54
_0200AACC:
	cmp r5, #0x10000
	moveq r0, #0
	strheq r0, [fp, #8]
	addeq sp, sp, #0xe4
	moveq r0, #1
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldrh r0, [fp, #8]
	cmp r0, #0
	bne _0200ABC8
	ldr r0, [sp]
	mov r1, #0
	ldr r0, [r0]
	cmp r0, #0xff
	addls sb, r1, #1
	bls _0200AB18
	cmp r0, #0xff00
	addls sb, r1, #2
	addhi sb, r1, #3
_0200AB18:
	cmp r4, #0x10000
	ldrne r0, [sp, #0x14]
	add sb, sb, #2
	addne sb, sb, r0
	mov sl, r5
	cmp r5, #0
	beq _0200ABBC
	add r0, sp, #0x98
	mov r1, r5
	bl FUN_0200B20C
	add r8, sp, #0x98
	mov r6, #3
	mov r7, #1
_0200AB4C:
	ldr r1, [sp, #0xc4]
	mov r0, r8
	bl FUN_0200B20C
	add r2, sp, #4
	mov r0, r8
	mov r1, r6
	str r2, [sp, #0xc8]
	str r7, [sp, #0xcc]
	bl FUN_0200A744
	cmp r0, #0
	bne _0200ABB0
_0200AB78:
	ldr r0, [sp, #0x10]
	cmp r0, #0
	beq _0200AB9C
	ldrh r0, [sp, #8]
	cmp r0, sl
	ldreq r0, [sp, #0x14]
	addeq r0, r0, #1
	addeq sb, sb, r0
	beq _0200ABB0
_0200AB9C:
	mov r0, r8
	mov r1, r6
	bl FUN_0200A744
	cmp r0, #0
	beq _0200AB78
_0200ABB0:
	ldrh sl, [sp, #0xbc]
	cmp sl, #0
	bne _0200AB4C
_0200ABBC:
	add r0, sb, #1
	strh r0, [fp, #8]
	strh r5, [fp, #0xa]
_0200ABC8:
	ldr r7, [fp]
	cmp r7, #0
	addeq sp, sp, #0xe4
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldrh r6, [fp, #8]
	ldr r0, [fp, #4]
	cmp r0, r6
	addlo sp, sp, #0xe4
	movlo r0, #1
	poplo {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxlo lr
	ldr r0, [sp]
	mov sb, #0
	ldr r0, [r0]
	cmp r0, #0xff
	movls r8, #1
	bls _0200AC20
	cmp r0, #0xff00
	movls r8, #2
	movhi r8, #3
_0200AC20:
	ldr r0, [sp]
	mov r1, r7
	mov r2, r8
	bl FUN_0200A1D8
	add r1, sb, r8
	ldr r0, _0200AD9C @ =0x0231CF2C
	add r1, r7, r1
	mov r2, #2
	bl FUN_0200A1D8
	add r0, sp, #0x98
	mov r1, r5
	bl FUN_0200B20C
	cmp r4, #0x10000
	beq _0200ACD4
	add r3, sp, #4
	mov r2, #0
	add r0, sp, #0x98
	mov r1, #3
	str r3, [sp, #0xc8]
	str r2, [sp, #0xcc]
	bl FUN_0200A744
	cmp r0, #0
	bne _0200ACB0
	add sb, sp, #0x98
	mov r8, #3
_0200AC84:
	ldr r0, [sp, #0x10]
	cmp r0, #0
	bne _0200AC9C
	ldr r0, [sp, #8]
	cmp r0, r4
	beq _0200ACB0
_0200AC9C:
	mov r0, sb
	mov r1, r8
	bl FUN_0200A744
	cmp r0, #0
	beq _0200AC84
_0200ACB0:
	ldr r0, [sp, #0x14]
	add r1, r7, r6
	add r4, r0, #1
	add r0, sp, #0x18
	mov r2, r4
	sub r1, r1, r4
	bl FUN_0200A1D8
	sub r6, r6, r4
	b _0200ACE4
_0200ACD4:
	add r0, r7, r6
	mov r1, #0
	strb r1, [r0, #-1]
	sub r6, r6, #1
_0200ACE4:
	cmp r5, #0
	beq _0200AD8C
	add sl, sp, #0x98
	add fp, sp, #4
	mov r4, #3
	mov sb, #0
	mov r8, #0x2f
_0200AD00:
	ldr r1, [sp, #0xc4]
	mov r0, sl
	bl FUN_0200B20C
	add r2, r7, r6
	mov r0, sl
	mov r1, r4
	str fp, [sp, #0xc8]
	str sb, [sp, #0xcc]
	strb r8, [r2, #-1]
	sub r6, r6, #1
	bl FUN_0200A744
	cmp r0, #0
	bne _0200AD80
_0200AD34:
	ldr r0, [sp, #0x10]
	cmp r0, #0
	beq _0200AD6C
	ldrh r0, [sp, #8]
	cmp r0, r5
	bne _0200AD6C
	ldr r5, [sp, #0x14]
	add r1, r7, r6
	add r0, sp, #0x18
	mov r2, r5
	sub r1, r1, r5
	bl FUN_0200A1D8
	sub r6, r6, r5
	b _0200AD80
_0200AD6C:
	mov r0, sl
	mov r1, r4
	bl FUN_0200A744
	cmp r0, #0
	beq _0200AD34
_0200AD80:
	ldrh r5, [sp, #0xbc]
	cmp r5, #0
	bne _0200AD00
_0200AD8C:
	mov r0, #0
	add sp, sp, #0xe4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0200AD9C: .4byte 0x0231CF2C
	arm_func_end FUN_0200A9E0

	arm_func_start FUN_0200ADA0
FUN_0200ADA0: @ 0x0200ADA0
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x9c
	mov sl, r0
	ldr r2, [sl, #0x40]
	ldr sb, [sl, #0x3c]
	mov r1, #2
	str r2, [sp]
	bl FUN_0200A744
	ldrb r1, [sb]
	cmp r1, #0
	beq _0200AF90
	mov r0, #2
	add fp, sp, #0x1c
	mov r4, #3
	mov r5, #1
	mov r6, #0
	str r0, [sp, #4]
_0200ADE4:
	mov r7, r6
	b _0200ADF0
_0200ADEC:
	add r7, r7, #1
_0200ADF0:
	ldrb r8, [sb, r7]
	mov r0, r6
	cmp r8, #0
	beq _0200AE10
	cmp r8, #0x2f
	beq _0200AE10
	cmp r8, #0x5c
	movne r0, r5
_0200AE10:
	cmp r0, #0
	bne _0200ADEC
	cmp r8, #0
	bne _0200AE2C
	ldr r0, [sp]
	cmp r0, #0
	beq _0200AE30
_0200AE2C:
	mov r8, r5
_0200AE30:
	cmp r7, #0
	addeq sp, sp, #0x9c
	moveq r0, #1
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	cmp r1, #0x2e
	bne _0200AE9C
	cmp r7, #1
	addeq sb, sb, #1
	beq _0200AF74
	ldrb r0, [sb, #1]
	cmp r7, #2
	moveq r1, r5
	movne r1, r6
	cmp r0, #0x2e
	moveq r0, r5
	movne r0, r6
	ands r0, r1, r0
	beq _0200AE9C
	ldrh r0, [sl, #0x24]
	cmp r0, #0
	beq _0200AE94
	ldr r1, [sl, #0x2c]
	mov r0, sl
	bl FUN_0200B20C
_0200AE94:
	add sb, sb, #2
	b _0200AF74
_0200AE9C:
	cmp r7, #0x7f
	addgt sp, sp, #0x9c
	movgt r0, #1
	popgt {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxgt lr
	add r0, sp, #8
	str r0, [sl, #0x30]
	str r6, [sl, #0x34]
_0200AEBC:
	mov r0, sl
	mov r1, r4
	bl FUN_0200A744
	cmp r0, #0
	addne sp, sp, #0x9c
	movne r0, #1
	popne {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxne lr
	ldr r0, [sp, #0x14]
	cmp r8, r0
	bne _0200AEBC
	ldr r0, [sp, #0x18]
	cmp r7, r0
	bne _0200AEBC
	mov r0, sb
	mov r1, fp
	mov r2, r7
	bl FUN_0200B2EC
	cmp r0, #0
	bne _0200AEBC
	cmp r8, #0
	beq _0200AF38
	add r0, sp, #8
	add r3, sl, #0x30
	ldm r0, {r0, r1, r2}
	stm r3, {r0, r1, r2}
	ldr r1, [sp, #4]
	mov r0, sl
	add sb, sb, r7
	bl FUN_0200A744
	b _0200AF74
_0200AF38:
	ldr r0, [sp]
	cmp r0, #0
	addne sp, sp, #0x9c
	movne r0, #1
	popne {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxne lr
	ldr r3, [sl, #0x44]
	ldr r2, [sp, #8]
	ldr r1, [sp, #0xc]
	add sp, sp, #0x9c
	str r2, [r3]
	str r1, [r3, #4]
	mov r0, #0
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0200AF74:
	ldrb r0, [sb]
	cmp r0, #0
	movne r0, r5
	moveq r0, r6
	ldrb r1, [sb, r0]!
	cmp r1, #0
	bne _0200ADE4
_0200AF90:
	ldr r0, [sp]
	cmp r0, #0
	moveq r0, #1
	addne r0, sl, #0x20
	ldrne r3, [sl, #0x44]
	ldmne r0, {r0, r1, r2}
	stmne r3, {r0, r1, r2}
	movne r0, #0
	add sp, sp, #0x9c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_0200ADA0

	arm_func_start FUN_0200AFBC
FUN_0200AFBC: @ 0x0200AFBC
	push {r4, r5, lr}
	sub sp, sp, #0xc
	mov r5, r0
	ldr r4, [r5, #0x30]
	ldr r1, [r5, #8]
	add r0, sp, #4
	str r1, [sp, #4]
	ldr r3, [r5, #0x28]
	add r1, sp, #0
	mov r2, #1
	str r3, [sp, #8]
	bl FUN_0200B240
	cmp r0, #0
	addne sp, sp, #0xc
	popne {r4, r5, lr}
	bxne lr
	ldrb r1, [sp]
	and r2, r1, #0x7f
	asr r1, r1, #7
	str r2, [r4, #0x10]
	and r1, r1, #1
	str r1, [r4, #0xc]
	ldr r2, [r4, #0x10]
	cmp r2, #0
	addeq sp, sp, #0xc
	moveq r0, #1
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r5, #0x34]
	cmp r1, #0
	bne _0200B068
	add r0, sp, #4
	add r1, r4, #0x14
	bl FUN_0200B240
	cmp r0, #0
	addne sp, sp, #0xc
	popne {r4, r5, lr}
	bxne lr
	ldr r1, [r4, #0x10]
	mov r2, #0
	add r1, r4, r1
	strb r2, [r1, #0x14]
	b _0200B074
_0200B068:
	ldr r1, [sp, #8]
	add r1, r1, r2
	str r1, [sp, #8]
_0200B074:
	ldr r1, [r4, #0xc]
	cmp r1, #0
	beq _0200B0C8
	add r0, sp, #4
	add r1, sp, #2
	mov r2, #2
	bl FUN_0200B240
	cmp r0, #0
	addne sp, sp, #0xc
	popne {r4, r5, lr}
	bxne lr
	ldr r2, [r5, #8]
	ldr r1, _0200B0F8 @ =0x00000FFF
	str r2, [r4]
	ldrh r3, [sp, #2]
	mov r2, #0
	and r1, r3, r1
	strh r1, [r4, #4]
	strh r2, [r4, #6]
	str r2, [r4, #8]
	b _0200B0E4
_0200B0C8:
	ldr r1, [r5, #8]
	str r1, [r4]
	ldrh r1, [r5, #0x26]
	str r1, [r4, #4]
	ldrh r1, [r5, #0x26]
	add r1, r1, #1
	strh r1, [r5, #0x26]
_0200B0E4:
	ldr r1, [sp, #8]
	str r1, [r5, #0x28]
	add sp, sp, #0xc
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200B0F8: .4byte 0x00000FFF
	arm_func_end FUN_0200AFBC

	arm_func_start FUN_0200B0FC
FUN_0200B0FC: @ 0x0200B0FC
	push {r4, r5, r6, lr}
	sub sp, sp, #0x10
	mov r6, r0
	ldr r5, [r6, #8]
	add r4, r6, #0x30
	str r5, [sp, #8]
	ldrh r1, [r4, #4]
	ldr r2, [r5, #0x34]
	add r0, sp, #8
	add r3, r2, r1, lsl #3
	add r1, sp, #0
	mov r2, #8
	str r3, [sp, #0xc]
	bl FUN_0200B240
	movs r3, r0
	bne _0200B188
	add ip, r6, #0x20
	ldm r4, {r0, r1, r2}
	stm ip, {r0, r1, r2}
	ldrh r0, [r4, #6]
	cmp r0, #0
	bne _0200B178
	ldr r0, [r4, #8]
	cmp r0, #0
	bne _0200B178
	ldrh r0, [sp, #4]
	strh r0, [r6, #0x26]
	ldr r1, [r5, #0x34]
	ldr r0, [sp]
	add r0, r1, r0
	str r0, [r6, #0x28]
_0200B178:
	ldrh r1, [sp, #6]
	ldr r0, _0200B198 @ =0x00000FFF
	and r0, r1, r0
	str r0, [r6, #0x2c]
_0200B188:
	mov r0, r3
	add sp, sp, #0x10
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200B198: .4byte 0x00000FFF
	arm_func_end FUN_0200B0FC

	arm_func_start FUN_0200B19C
FUN_0200B19C: @ 0x0200B19C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, [r0, #0x2c]
	ldr r3, [r0, #0x38]
	ldr lr, [r0, #8]
	ldr r1, [r0, #0x30]
	add ip, r2, r3
	str ip, [r0, #0x2c]
	ldr ip, [lr, #0x4c]
	mov r0, lr
	.word 0xE12FFF3C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200B19C

	arm_func_start FUN_0200B1D4
FUN_0200B1D4: @ 0x0200B1D4
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, [r0, #0x2c]
	ldr r3, [r0, #0x38]
	ldr lr, [r0, #8]
	ldr r1, [r0, #0x30]
	add ip, r2, r3
	str ip, [r0, #0x2c]
	ldr ip, [lr, #0x48]
	mov r0, lr
	.word 0xE12FFF3C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200B1D4

	arm_func_start FUN_0200B20C
FUN_0200B20C: @ 0x0200B20C
	ldr r3, [r0, #0xc]
	mov r2, #0
	orr r3, r3, #4
	str r3, [r0, #0xc]
	ldr r3, [r0, #8]
	ldr ip, _0200B23C @ =0x02305B84
	str r3, [r0, #0x30]
	str r2, [r0, #0x38]
	strh r2, [r0, #0x36]
	strh r1, [r0, #0x34]
	mov r1, #2
	bx ip
	.align 2, 0
_0200B23C: .4byte 0x02305B84
	arm_func_end FUN_0200B20C

	arm_func_start FUN_0200B240
FUN_0200B240: @ 0x0200B240
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r0
	ldr r5, [r7]
	mov r6, r2
	ldr r2, [r5, #0x1c]
	mov r0, r5
	orr r2, r2, #0x200
	str r2, [r5, #0x1c]
	ldr r2, [r7, #4]
	ldr r4, [r5, #0x50]
	mov r3, r6
	.word 0xE12FFF34
	cmp r0, #0
	beq _0200B28C
	cmp r0, #1
	beq _0200B28C
	cmp r0, #6
	beq _0200B29C
	b _0200B2D8
_0200B28C:
	ldr r1, [r5, #0x1c]
	bic r1, r1, #0x200
	str r1, [r5, #0x1c]
	b _0200B2D8
_0200B29C:
	bl FUN_02009A90
	ldr r1, [r5, #0x1c]
	mov r4, r0
	ands r0, r1, #0x200
	beq _0200B2C8
	add r8, r5, #0xc
_0200B2B4:
	mov r0, r8
	bl FUN_0200819C
	ldr r0, [r5, #0x1c]
	ands r0, r0, #0x200
	bne _0200B2B4
_0200B2C8:
	mov r0, r4
	bl FUN_02009AA4
	ldr r0, [r5, #0x24]
	ldr r0, [r0, #0x14]
_0200B2D8:
	ldr r1, [r7, #4]
	add r1, r1, r6
	str r1, [r7, #4]
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_0200B240

	arm_func_start FUN_0200B2EC
FUN_0200B2EC: @ 0x0200B2EC
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r2, #0
	mov lr, #0
	bls _0200B340
_0200B300:
	ldrb ip, [r0, lr]
	ldrb r3, [r1, lr]
	sub ip, ip, #0x41
	cmp ip, #0x19
	sub r3, r3, #0x41
	addls ip, ip, #0x20
	cmp r3, #0x19
	addls r3, r3, #0x20
	cmp ip, r3
	addne sp, sp, #4
	subne r0, ip, r3
	ldmne sp!, {lr}
	bxne lr
	add lr, lr, #1
	cmp lr, r2
	blo _0200B300
_0200B340:
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200B2EC

	arm_func_start FUN_0200B350
FUN_0200B350: @ 0x0200B350
	push {r4, r5, r6, lr}
	mov r4, r0
	ldr r0, [r4, #0x1c]
	mov r6, r1
	ands r0, r0, #0x100
	beq _0200B39C
	ldr r2, [r4, #0x1c]
	ldr r0, [r4, #0x24]
	bic r2, r2, #0x100
	str r2, [r4, #0x1c]
	bl FUN_0200A8C0
	mov r0, r4
	bl FUN_0200B984
	cmp r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	bl FUN_0200B8E0
	pop {r4, r5, r6, lr}
	bx lr
_0200B39C:
	ldr r5, [r4, #0x24]
	bl FUN_02009A90
	str r6, [r5, #0x14]
	ldr r1, [r4, #0x1c]
	mov r5, r0
	bic r1, r1, #0x200
	add r0, r4, #0xc
	str r1, [r4, #0x1c]
	bl FUN_0200811C
	mov r0, r5
	bl FUN_02009AA4
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0200B350

	arm_func_start FUN_0200B3D0
FUN_0200B3D0: @ 0x0200B3D0
	cmp r2, #0
	moveq r1, #0
	beq _0200B3E4
	cmp r1, #0
	moveq r2, #0
_0200B3E4:
	str r1, [r0, #0x54]
	str r2, [r0, #0x58]
	bx lr
	arm_func_end FUN_0200B3D0

	arm_func_start FUN_0200B3F0
FUN_0200B3F0: @ 0x0200B3F0
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0x4c
	mov r7, r0
	ldr r3, [r7, #0x30]
	ldr r0, [r7, #0x38]
	mov r6, r1
	add r0, r3, r0
	add r0, r0, #0x20
	add r0, r0, #0x1f
	bic r5, r0, #0x1f
	cmp r5, r2
	bhi _0200B508
	add r1, r6, #0x1f
	add r0, sp, #4
	bic r4, r1, #0x1f
	bl FUN_0200BE60
	ldr r2, [r7, #0x2c]
	mvn r0, #0
	str r0, [sp]
	ldr r3, [r7, #0x30]
	add r0, sp, #4
	mov r1, r7
	add r3, r2, r3
	bl FUN_0200BD80
	cmp r0, #0
	beq _0200B488
	ldr r2, [r7, #0x30]
	add r0, sp, #4
	mov r1, r4
	bl FUN_0200BC58
	cmp r0, #0
	bge _0200B480
	ldr r2, [r7, #0x30]
	mov r0, r4
	mov r1, #0
	bl FUN_0200A144
_0200B480:
	add r0, sp, #4
	bl FUN_0200BD38
_0200B488:
	str r4, [r7, #0x2c]
	ldr ip, [r7, #0x30]
	ldr r2, [r7, #0x34]
	mvn r0, #0
	str r0, [sp]
	ldr r3, [r7, #0x38]
	add r0, sp, #4
	mov r1, r7
	add r3, r2, r3
	add r4, r4, ip
	bl FUN_0200BD80
	cmp r0, #0
	beq _0200B4EC
	ldr r2, [r7, #0x38]
	add r0, sp, #4
	mov r1, r4
	bl FUN_0200BC58
	cmp r0, #0
	bge _0200B4E4
	ldr r2, [r7, #0x38]
	mov r0, r4
	mov r1, #0
	bl FUN_0200A144
_0200B4E4:
	add r0, sp, #4
	bl FUN_0200BD38
_0200B4EC:
	str r4, [r7, #0x34]
	ldr r0, _0200B518 @ =0x02306FBC
	str r6, [r7, #0x44]
	str r0, [r7, #0x50]
	ldr r0, [r7, #0x1c]
	orr r0, r0, #4
	str r0, [r7, #0x1c]
_0200B508:
	mov r0, r5
	add sp, sp, #0x4c
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200B518: .4byte 0x02306FBC
	arm_func_end FUN_0200B3F0

	arm_func_start FUN_0200B51C
FUN_0200B51C: @ 0x0200B51C
	str r1, [r0, #0x28]
	str r3, [r0, #0x30]
	str r2, [r0, #0x3c]
	ldr r1, [r0, #0x3c]
	ldr r2, [sp, #4]
	str r1, [r0, #0x2c]
	str r2, [r0, #0x38]
	ldr r1, [sp]
	ldr r2, [sp, #8]
	str r1, [r0, #0x40]
	ldr r1, [r0, #0x40]
	cmp r2, #0
	str r1, [r0, #0x34]
	ldreq r2, _0200B58C @ =0x0230700C
	ldr r1, [sp, #0xc]
	str r2, [r0, #0x48]
	cmp r1, #0
	ldreq r1, _0200B590 @ =0x02306FE0
	str r1, [r0, #0x4c]
	ldr r2, [r0, #0x48]
	mov r1, #0
	str r2, [r0, #0x50]
	str r1, [r0, #0x44]
	ldr r1, [r0, #0x1c]
	orr r1, r1, #2
	str r1, [r0, #0x1c]
	mov r0, #1
	bx lr
	.align 2, 0
_0200B58C: .4byte 0x0230700C
_0200B590: .4byte 0x02306FE0
	arm_func_end FUN_0200B51C

	arm_func_start FUN_0200B594
FUN_0200B594: @ 0x0200B594
	push {r4, r5, r6, r7, r8, lr}
	mov r6, r1
	mov r5, r2
	mov r7, r0
	mov r8, #0
	bl FUN_02009A90
	mov r4, r0
	mov r0, r6
	mov r1, r5
	bl FUN_0200B654
	cmp r0, #0
	bne _0200B638
	ldr r1, _0200B64C @ =0x0234679C
	ldr r2, [r1]
	cmp r2, #0
	bne _0200B5F4
	ldr r0, _0200B650 @ =0x023467A0
	mov r2, r8
	str r7, [r1]
	str r7, [r0]
	str r2, [r0, #8]
	strh r2, [r0, #6]
	strh r2, [r0, #4]
	b _0200B618
_0200B5F4:
	ldr r0, [r2, #4]
	cmp r0, #0
	beq _0200B610
_0200B600:
	mov r2, r0
	ldr r0, [r0, #4]
	cmp r0, #0
	bne _0200B600
_0200B610:
	str r7, [r2, #4]
	str r2, [r7, #8]
_0200B618:
	mov r0, r6
	mov r1, r5
	bl FUN_0200BBF4
	str r0, [r7]
	ldr r0, [r7, #0x1c]
	mov r8, #1
	orr r0, r0, #1
	str r0, [r7, #0x1c]
_0200B638:
	mov r0, r4
	bl FUN_02009AA4
	mov r0, r8
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200B64C: .4byte 0x0234679C
_0200B650: .4byte 0x023467A0
	arm_func_end FUN_0200B594

	arm_func_start FUN_0200B654
FUN_0200B654: @ 0x0200B654
	push {r4, r5, lr}
	sub sp, sp, #4
	bl FUN_0200BBF4
	mov r5, r0
	bl FUN_02009A90
	ldr r1, _0200B6A0 @ =0x0234679C
	ldr r4, [r1]
	b _0200B678
_0200B674:
	ldr r4, [r4, #4]
_0200B678:
	cmp r4, #0
	beq _0200B68C
	ldr r1, [r4]
	cmp r1, r5
	bne _0200B674
_0200B68C:
	bl FUN_02009AA4
	mov r0, r4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200B6A0: .4byte 0x0234679C
	arm_func_end FUN_0200B654

	arm_func_start FUN_0200B6A4
FUN_0200B6A4: @ 0x0200B6A4
	push {r4, lr}
	mov r1, #0
	mov r2, #0x5c
	mov r4, r0
	bl FUN_0200A144
	mov r1, #0
	str r1, [r4, #0x10]
	ldr r0, [r4, #0x10]
	str r0, [r4, #0xc]
	str r1, [r4, #0x18]
	ldr r0, [r4, #0x18]
	str r0, [r4, #0x14]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200B6A4

	arm_func_start FUN_0200B6DC
FUN_0200B6DC: @ 0x0200B6DC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	ldr r6, [r7, #8]
	mov r2, #1
	str r1, [r7, #0x10]
	mov r0, #2
	str r0, [r7, #0x14]
	ldr r0, [r7, #0xc]
	lsl r5, r2, r1
	orr r0, r0, #1
	str r0, [r7, #0xc]
	bl FUN_02009A90
	ldr r1, [r6, #0x1c]
	mov r4, r0
	ands r0, r1, #0x80
	beq _0200B744
	mov r0, r7
	mov r1, #3
	bl FUN_0200A8C0
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	pop {r4, r5, r6, r7, lr}
	bx lr
_0200B744:
	ands r0, r5, #0x1fc
	ldrne r0, [r7, #0xc]
	add r2, r6, #0x20
	orrne r0, r0, #4
	strne r0, [r7, #0xc]
	ldr r1, [r7]
	ldr r0, [r7, #4]
	cmp r1, #0
	strne r0, [r1, #4]
	cmp r0, #0
	strne r1, [r0]
	ldr r0, [r2, #4]
	cmp r0, #0
	beq _0200B78C
_0200B77C:
	mov r2, r0
	ldr r0, [r0, #4]
	cmp r0, #0
	bne _0200B77C
_0200B78C:
	str r7, [r2, #4]
	str r2, [r7]
	mov r1, #0
	str r1, [r7, #4]
	ldr r0, [r6, #0x1c]
	ands r0, r0, #8
	movne r1, #1
	cmp r1, #0
	bne _0200B838
	ldr r0, [r6, #0x1c]
	ands r0, r0, #0x10
	bne _0200B838
	ldr r1, [r6, #0x1c]
	mov r0, r4
	orr r1, r1, #0x10
	str r1, [r6, #0x1c]
	bl FUN_02009AA4
	ldr r0, [r6, #0x58]
	ands r0, r0, #0x200
	beq _0200B7EC
	ldr r2, [r6, #0x54]
	mov r0, r7
	mov r1, #9
	.word 0xE12FFF32
_0200B7EC:
	bl FUN_02009A90
	ldr r1, [r7, #0xc]
	orr r1, r1, #0x40
	str r1, [r7, #0xc]
	ldr r1, [r7, #0xc]
	ands r1, r1, #4
	movne r1, #1
	moveq r1, #0
	cmp r1, #0
	bne _0200B830
	bl FUN_02009AA4
	mov r0, r7
	bl FUN_0200B8E0
	add sp, sp, #4
	mov r0, #1
	pop {r4, r5, r6, r7, lr}
	bx lr
_0200B830:
	bl FUN_02009AA4
	b _0200B884
_0200B838:
	ldr r0, [r7, #0xc]
	ands r0, r0, #4
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	bne _0200B868
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #1
	pop {r4, r5, r6, r7, lr}
	bx lr
_0200B868:
	add r0, r7, #0x18
	bl FUN_0200819C
	ldr r0, [r7, #0xc]
	ands r0, r0, #0x40
	beq _0200B868
	mov r0, r4
	bl FUN_02009AA4
_0200B884:
	mov r0, r7
	bl FUN_0200B898
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200B6DC

	arm_func_start FUN_0200B898
FUN_0200B898: @ 0x0200B898
	push {r4, lr}
	mov r4, r0
	ldr r1, [r4, #0x10]
	bl FUN_0200A744
	mov r1, r0
	mov r0, r4
	bl FUN_0200A8C0
	ldr r0, [r4, #8]
	bl FUN_0200B984
	cmp r0, #0
	beq _0200B8C8
	bl FUN_0200B8E0
_0200B8C8:
	ldr r0, [r4, #0x14]
	cmp r0, #0
	moveq r0, #1
	movne r0, #0
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200B898

	arm_func_start FUN_0200B8E0
FUN_0200B8E0: @ 0x0200B8E0
	push {r4, r5, r6, r7, r8, lr}
	movs r6, r0
	ldr r5, [r6, #8]
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r7, #0
	mov r8, #1
_0200B8FC:
	bl FUN_02009A90
	ldr r1, [r6, #0xc]
	mov r4, r0
	orr r0, r1, #0x40
	str r0, [r6, #0xc]
	ldr r0, [r6, #0xc]
	ands r0, r0, #4
	movne r0, r8
	moveq r0, r7
	cmp r0, #0
	beq _0200B940
	add r0, r6, #0x18
	bl FUN_0200811C
	mov r0, r4
	bl FUN_02009AA4
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0200B940:
	ldr r1, [r6, #0xc]
	mov r0, r4
	orr r1, r1, #8
	str r1, [r6, #0xc]
	bl FUN_02009AA4
	ldr r1, [r6, #0x10]
	mov r0, r6
	bl FUN_0200A744
	cmp r0, #6
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r0, r5
	bl FUN_0200B984
	movs r6, r0
	bne _0200B8FC
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_0200B8E0

	arm_func_start FUN_0200B984
FUN_0200B984: @ 0x0200B984
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #0x4c
	mov r6, r0
	bl FUN_02009A90
	ldr r1, [r6, #0x1c]
	mov r5, r0
	ands r0, r1, #0x20
	beq _0200BA0C
	ldr r0, [r6, #0x1c]
	bic r0, r0, #0x20
	str r0, [r6, #0x1c]
	ldr r0, [r6, #0x24]
	cmp r0, #0
	beq _0200BA0C
	mov r8, #0
	mov sb, #1
	mov r7, #3
_0200B9C8:
	ldr r1, [r0, #0xc]
	ldr r4, [r0, #4]
	ands r1, r1, #2
	movne r1, sb
	moveq r1, r8
	cmp r1, #0
	beq _0200BA00
	ldr r1, [r6, #0x24]
	cmp r1, r0
	mov r1, r7
	streq r4, [r6, #0x24]
	bl FUN_0200A8C0
	cmp r4, #0
	ldreq r4, [r6, #0x24]
_0200BA00:
	mov r0, r4
	cmp r4, #0
	bne _0200B9C8
_0200BA0C:
	ldr r0, [r6, #0x1c]
	ands r0, r0, #0x40
	bne _0200BAF8
	ldr r0, [r6, #0x1c]
	ands r0, r0, #8
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	bne _0200BAF8
	ldr r4, [r6, #0x24]
	cmp r4, #0
	beq _0200BAF8
	ldr r0, [r6, #0x1c]
	ands r0, r0, #0x10
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	moveq r7, #1
	movne r7, #0
	cmp r7, #0
	ldrne r0, [r6, #0x1c]
	orrne r0, r0, #0x10
	strne r0, [r6, #0x1c]
	mov r0, r5
	bl FUN_02009AA4
	cmp r7, #0
	beq _0200BA94
	ldr r0, [r6, #0x58]
	ands r0, r0, #0x200
	beq _0200BA94
	ldr r2, [r6, #0x54]
	mov r0, r4
	mov r1, #9
	.word 0xE12FFF32
_0200BA94:
	bl FUN_02009A90
	ldr r1, [r4, #0xc]
	mov r5, r0
	orr r0, r1, #0x40
	str r0, [r4, #0xc]
	ldr r0, [r4, #0xc]
	ands r0, r0, #4
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	beq _0200BAE0
	add r0, r4, #0x18
	bl FUN_0200811C
	mov r0, r5
	bl FUN_02009AA4
	add sp, sp, #0x4c
	mov r0, #0
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
_0200BAE0:
	mov r0, r5
	bl FUN_02009AA4
	add sp, sp, #0x4c
	mov r0, r4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
_0200BAF8:
	ldr r0, [r6, #0x1c]
	ands r0, r0, #0x10
	beq _0200BB38
	ldr r0, [r6, #0x1c]
	bic r0, r0, #0x10
	str r0, [r6, #0x1c]
	ldr r0, [r6, #0x58]
	ands r0, r0, #0x400
	beq _0200BB38
	add r0, sp, #0
	bl FUN_0200BE60
	str r6, [sp, #8]
	ldr r2, [r6, #0x54]
	add r0, sp, #0
	mov r1, #0xa
	.word 0xE12FFF32
_0200BB38:
	ldr r0, [r6, #0x1c]
	ands r0, r0, #0x40
	beq _0200BB64
	ldr r1, [r6, #0x1c]
	add r0, r6, #0x14
	bic r1, r1, #0x40
	str r1, [r6, #0x1c]
	ldr r1, [r6, #0x1c]
	orr r1, r1, #8
	str r1, [r6, #0x1c]
	bl FUN_0200811C
_0200BB64:
	mov r0, r5
	bl FUN_02009AA4
	mov r0, #0
	add sp, sp, #0x4c
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_0200B984

	arm_func_start FUN_0200BB7C
FUN_0200BB7C: @ 0x0200BB7C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, r2
	mov r2, r3
	bl FUN_0200A1D8
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200BB7C

	arm_func_start FUN_0200BBA0
FUN_0200BBA0: @ 0x0200BBA0
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr ip, [r0, #0x28]
	mov r0, r1
	add r1, ip, r2
	mov r2, r3
	bl FUN_0200A1D8
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200BBA0

	arm_func_start FUN_0200BBCC
FUN_0200BBCC: @ 0x0200BBCC
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r0, [r0, #0x28]
	add r0, r0, r2
	mov r2, r3
	bl FUN_0200A1D8
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200BBCC

	arm_func_start FUN_0200BBF4
FUN_0200BBF4: @ 0x0200BBF4
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r1, #3
	mov lr, #0
	bgt _0200BC48
	mov ip, lr
	cmp r1, #0
	ble _0200BC48
	mov r3, lr
_0200BC18:
	ldrb r2, [r0, ip]
	cmp r2, #0
	beq _0200BC48
	sub r2, r2, #0x41
	cmp r2, #0x19
	addls r2, r2, #0x61
	addhi r2, r2, #0x41
	add ip, ip, #1
	orr lr, lr, r2, lsl r3
	cmp ip, r1
	add r3, r3, #8
	blt _0200BC18
_0200BC48:
	mov r0, lr
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200BBF4

	arm_func_start FUN_0200BC58
FUN_0200BC58: @ 0x0200BC58
	ldr ip, _0200BC64 @ =0x02307218
	mov r3, #0
	bx ip
	.align 2, 0
_0200BC64: .4byte 0x02307218
	arm_func_end FUN_0200BC58

	arm_func_start FUN_0200BC68
FUN_0200BC68: @ 0x0200BC68
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r6, r0
	mov r5, #0
	bl FUN_02009A90
	ldr r1, [r6, #0xc]
	mov r4, r0
	ands r0, r1, #1
	movne r0, #1
	moveq r0, r5
	cmp r0, #0
	beq _0200BCF8
	ldr r0, [r6, #0xc]
	ands r0, r0, #0x44
	moveq r5, #1
	movne r5, #0
	cmp r5, #0
	beq _0200BCD8
	ldr r0, [r6, #0xc]
	orr r0, r0, #4
	str r0, [r6, #0xc]
	add r7, r6, #0x18
_0200BCC0:
	mov r0, r7
	bl FUN_0200819C
	ldr r0, [r6, #0xc]
	ands r0, r0, #0x40
	beq _0200BCC0
	b _0200BCF8
_0200BCD8:
	add r0, r6, #0x18
	bl FUN_0200819C
	ldr r0, [r6, #0xc]
	ands r0, r0, #1
	movne r0, #1
	moveq r0, #0
	cmp r0, #0
	bne _0200BCD8
_0200BCF8:
	mov r0, r4
	bl FUN_02009AA4
	cmp r5, #0
	beq _0200BD1C
	mov r0, r6
	bl FUN_0200B898
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
_0200BD1C:
	ldr r0, [r6, #0x14]
	cmp r0, #0
	moveq r0, #1
	movne r0, #0
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200BC68

	arm_func_start FUN_0200BD38
FUN_0200BD38: @ 0x0200BD38
	push {r4, lr}
	mov r1, #8
	mov r4, r0
	bl FUN_0200B6DC
	cmp r0, #0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #0xe
	str r0, [r4, #0x10]
	ldr r1, [r4, #0xc]
	mov r0, #1
	bic r1, r1, #0x30
	str r1, [r4, #0xc]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200BD38

	arm_func_start FUN_0200BD80
FUN_0200BD80: @ 0x0200BD80
	push {r4, lr}
	mov r4, r0
	str r1, [r4, #8]
	ldr ip, [sp, #8]
	mov r1, #7
	str ip, [r4, #0x38]
	str r2, [r4, #0x30]
	str r3, [r4, #0x34]
	bl FUN_0200B6DC
	cmp r0, #0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	ldr r1, [r4, #0xc]
	mov r0, #1
	orr r1, r1, #0x10
	str r1, [r4, #0xc]
	ldr r1, [r4, #0xc]
	bic r1, r1, #0x20
	str r1, [r4, #0xc]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200BD80

	arm_func_start FUN_0200BDD8
FUN_0200BDD8: @ 0x0200BDD8
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	ldr r4, [r7, #0x2c]
	ldr r0, [r7, #0x28]
	mov r6, r2
	str r1, [r7, #0x30]
	sub r0, r0, r4
	cmp r6, r0
	movgt r6, r0
	cmp r6, #0
	movlt r6, #0
	str r2, [r7, #0x34]
	mov r5, r3
	str r6, [r7, #0x38]
	cmp r5, #0
	ldreq r0, [r7, #0xc]
	mov r1, #0
	orreq r0, r0, #4
	streq r0, [r7, #0xc]
	mov r0, r7
	bl FUN_0200B6DC
	cmp r5, #0
	bne _0200BE50
	mov r0, r7
	bl FUN_0200BC68
	cmp r0, #0
	ldrne r0, [r7, #0x2c]
	subne r6, r0, r4
	mvneq r6, #0
_0200BE50:
	mov r0, r6
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200BDD8

	arm_func_start FUN_0200BE60
FUN_0200BE60: @ 0x0200BE60
	mov r3, #0
	str r3, [r0]
	ldr r2, [r0]
	mov r1, #0xe
	str r2, [r0, #4]
	str r3, [r0, #0x1c]
	ldr r2, [r0, #0x1c]
	str r2, [r0, #0x18]
	str r3, [r0, #8]
	str r1, [r0, #0x10]
	str r3, [r0, #0xc]
	bx lr
	arm_func_end FUN_0200BE60

	arm_func_start FUN_0200BE90
FUN_0200BE90: @ 0x0200BE90
	ldr r0, _0200BE9C @ =0x023467AC
	ldr r0, [r0]
	bx lr
	.align 2, 0
_0200BE9C: .4byte 0x023467AC
	arm_func_end FUN_0200BE90

	arm_func_start FUN_0200BEA0
FUN_0200BEA0: @ 0x0200BEA0
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200BED8 @ =0x023467AC
	ldr r2, [r1]
	cmp r2, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	mov r2, #1
	str r2, [r1]
	bl FUN_0200BEFC
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200BED8: .4byte 0x023467AC
	arm_func_end FUN_0200BEA0

	arm_func_start FUN_0200BEDC
FUN_0200BEDC: @ 0x0200BEDC
	ldr ip, _0200BEF4 @ =0x02306830
	mov r3, r0
	mov r2, r1
	ldr r0, _0200BEF8 @ =0x023467C8
	mov r1, r3
	bx ip
	.align 2, 0
_0200BEF4: .4byte 0x02306830
_0200BEF8: .4byte 0x023467C8
	arm_func_end FUN_0200BEDC

	arm_func_start FUN_0200BEFC
FUN_0200BEFC: @ 0x0200BEFC
	push {r4, r5, lr}
	sub sp, sp, #0x14
	ldr r1, _0200C060 @ =0x023467B4
	str r0, [r1]
	bl FUN_02007B74
	ldr r3, _0200C064 @ =0x023467B0
	ldr r2, _0200C068 @ =0x023467B8
	mov ip, #0
	ldr r1, _0200C06C @ =0x023467C0
	str r0, [r3]
	str ip, [r2]
	str ip, [r2, #4]
	str ip, [r1]
	str ip, [r1, #4]
	bl FUN_0200DE30
	ldr r0, _0200C070 @ =0x023467C8
	bl FUN_0200B6A4
	ldr r0, _0200C070 @ =0x023467C8
	ldr r1, _0200C074 @ =0x0231CF30
	mov r2, #3
	bl FUN_0200B594
	ldr r0, _0200C078 @ =0x027FFC40
	ldrh r0, [r0]
	cmp r0, #2
	bne _0200BFC4
	ldr ip, _0200C068 @ =0x023467B8
	mvn r2, #0
	ldr r3, _0200C06C @ =0x023467C0
	mov lr, #0
	ldr r0, _0200C070 @ =0x023467C8
	ldr r1, _0200C07C @ =0x023074DC
	str r2, [ip]
	str lr, [ip, #4]
	str r2, [r3]
	str lr, [r3, #4]
	bl FUN_0200B3D0
	mov r1, #0
	str r1, [sp]
	ldr r0, _0200C080 @ =0x023074E4
	str r1, [sp, #4]
	str r0, [sp, #8]
	ldr ip, _0200C084 @ =0x0230757C
	ldr r0, _0200C070 @ =0x023467C8
	mov r2, r1
	mov r3, r1
	str ip, [sp, #0xc]
	bl FUN_0200B51C
	add sp, sp, #0x14
	pop {r4, r5, lr}
	bx lr
_0200BFC4:
	ldr r5, _0200C088 @ =0x027FFE40
	ldr r0, _0200C070 @ =0x023467C8
	ldr r1, _0200C08C @ =0x023074EC
	ldr r2, _0200C090 @ =0x00000602
	ldr r4, _0200C094 @ =0x027FFE48
	bl FUN_0200B3D0
	ldr r1, [r5]
	mvn r0, #0
	cmp r1, r0
	addeq sp, sp, #0x14
	popeq {r4, r5, lr}
	bxeq lr
	cmp r1, #0
	addeq sp, sp, #0x14
	popeq {r4, r5, lr}
	bxeq lr
	ldr r2, [r4]
	cmp r2, r0
	addeq sp, sp, #0x14
	popeq {r4, r5, lr}
	bxeq lr
	cmp r2, #0
	addeq sp, sp, #0x14
	popeq {r4, r5, lr}
	bxeq lr
	str r1, [sp]
	ldr r0, [r5, #4]
	ldr r1, _0200C098 @ =0x02307584
	str r0, [sp, #4]
	ldr r0, _0200C084 @ =0x0230757C
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	ldr r3, [r4, #4]
	ldr r0, _0200C070 @ =0x023467C8
	mov r1, #0
	bl FUN_0200B51C
	add sp, sp, #0x14
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200C060: .4byte 0x023467B4
_0200C064: .4byte 0x023467B0
_0200C068: .4byte 0x023467B8
_0200C06C: .4byte 0x023467C0
_0200C070: .4byte 0x023467C8
_0200C074: .4byte 0x0231CF30
_0200C078: .4byte 0x027FFC40
_0200C07C: .4byte 0x023074DC
_0200C080: .4byte 0x023074E4
_0200C084: .4byte 0x0230757C
_0200C088: .4byte 0x027FFE40
_0200C08C: .4byte 0x023074EC
_0200C090: .4byte 0x00000602
_0200C094: .4byte 0x027FFE48
_0200C098: .4byte 0x02307584
	arm_func_end FUN_0200BEFC

	arm_func_start FUN_0200C09C
FUN_0200C09C: @ 0x0200C09C
	mov r0, #4
	bx lr
	arm_func_end FUN_0200C09C

	arm_func_start FUN_0200C0A4
FUN_0200C0A4: @ 0x0200C0A4
	mov r0, #1
	bx lr
	arm_func_end FUN_0200C0A4

	arm_func_start FUN_0200C0AC
FUN_0200C0AC: @ 0x0200C0AC
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r1, #1
	beq _0200C118
	cmp r1, #9
	beq _0200C0D0
	cmp r1, #0xa
	beq _0200C0F4
	b _0200C128
_0200C0D0:
	ldr r0, _0200C138 @ =0x023467B0
	ldr r0, [r0]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl FUN_0200DAC8
	add sp, sp, #4
	mov r0, #0
	ldm sp!, {lr}
	bx lr
_0200C0F4:
	ldr r0, _0200C138 @ =0x023467B0
	ldr r0, [r0]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl FUN_0200DAA8
	add sp, sp, #4
	mov r0, #0
	ldm sp!, {lr}
	bx lr
_0200C118:
	add sp, sp, #4
	mov r0, #4
	ldm sp!, {lr}
	bx lr
_0200C128:
	mov r0, #8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200C138: .4byte 0x023467B0
	arm_func_end FUN_0200C0AC

	arm_func_start FUN_0200C13C
FUN_0200C13C: @ 0x0200C13C
	mov r0, #1
	bx lr
	arm_func_end FUN_0200C13C

	arm_func_start FUN_0200C144
FUN_0200C144: @ 0x0200C144
	stmdb sp!, {lr}
	sub sp, sp, #0xc
	ldr ip, _0200C188 @ =0x023075D0
	mov lr, r1
	str ip, [sp]
	str r0, [sp, #4]
	mov r1, #1
	ldr r0, _0200C18C @ =0x023467B4
	str r1, [sp, #8]
	mov r1, r2
	ldr r0, [r0]
	mov r2, lr
	bl FUN_0200DEB4
	mov r0, #6
	add sp, sp, #0xc
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200C188: .4byte 0x023075D0
_0200C18C: .4byte 0x023467B4
	arm_func_end FUN_0200C144

	arm_func_start FUN_0200C190
FUN_0200C190: @ 0x0200C190
	push {r4, lr}
	mov r4, r0
	bl FUN_0200E8BC
	cmp r0, #0
	movne r1, #5
	moveq r1, #0
	mov r0, r4
	bl FUN_0200B350
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200C190

	arm_func_start FUN_0200C1B8
FUN_0200C1B8: @ 0x0200C1B8
	push {r0, r1, r2, r3}
	push {r4, r5, r6, lr}
	ldr r0, [sp, #0x10]
	mov r6, r1
	ldr r3, [r0, #0x1c]
	add r5, r0, #0x20
	ands r1, r3, #3
	asr r0, r3, #2
	moveq r1, #0
	streq r1, [r5, r0, lsl #2]
	ldr r2, [sp, #0x10]
	mov r1, #0x80
	add r4, r2, #0x20
	strb r1, [r4, r3]
	add r3, r3, #1
	ands r1, r3, #3
	beq _0200C210
	mov r2, #0
_0200C200:
	strb r2, [r4, r3]
	add r3, r3, #1
	ands r1, r3, #3
	bne _0200C200
_0200C210:
	ldr r1, [sp, #0x10]
	add r0, r0, #1
	ldr r1, [r1, #0x1c]
	cmp r1, #0x38
	blt _0200C25C
	cmp r0, #0x10
	bge _0200C240
	mov r1, #0
_0200C230:
	str r1, [r5, r0, lsl #2]
	add r0, r0, #1
	cmp r0, #0x10
	blt _0200C230
_0200C240:
	ldr r1, _0200C3B0 @ =0x0231CF34
	ldr r0, [sp, #0x10]
	ldr r3, [r1]
	mov r1, r5
	mov r2, #0x40
	.word 0xE12FFF33
	mov r0, #0
_0200C25C:
	cmp r0, #0xe
	bge _0200C278
	mov r1, #0
_0200C268:
	str r1, [r5, r0, lsl #2]
	add r0, r0, #1
	cmp r0, #0xe
	blt _0200C268
_0200C278:
	ldr r0, [sp, #0x10]
	mov r1, r5
	ldr r2, [r0, #0x14]
	ldr r3, _0200C3B0 @ =0x0231CF34
	strb r2, [r4, #0x3f]
	lsr r0, r2, #8
	strb r0, [r4, #0x3e]
	lsr r0, r2, #0x10
	strb r0, [r4, #0x3d]
	lsr r0, r2, #0x18
	strb r0, [r4, #0x3c]
	ldr r0, [sp, #0x10]
	mov r2, #0x40
	ldr r5, [r0, #0x18]
	strb r5, [r4, #0x3b]
	lsr r0, r5, #8
	strb r0, [r4, #0x3a]
	lsr r0, r5, #0x10
	strb r0, [r4, #0x39]
	lsr r0, r5, #0x18
	strb r0, [r4, #0x38]
	ldr r0, [sp, #0x10]
	ldr r3, [r3]
	.word 0xE12FFF33
	ldr r0, [sp, #0x10]
	add r1, sp, #0x10
	ldr r3, [r0]
	mov r0, #0
	lsr r2, r3, #0x18
	strb r2, [r6]
	lsr r2, r3, #0x10
	strb r2, [r6, #1]
	lsr r2, r3, #8
	strb r2, [r6, #2]
	strb r3, [r6, #3]
	ldr r3, [sp, #0x10]
	mov r2, #4
	ldr r4, [r3, #4]
	lsr r3, r4, #0x18
	strb r3, [r6, #4]
	lsr r3, r4, #0x10
	strb r3, [r6, #5]
	lsr r3, r4, #8
	strb r3, [r6, #6]
	strb r4, [r6, #7]
	ldr r3, [sp, #0x10]
	ldr r4, [r3, #8]
	lsr r3, r4, #0x18
	strb r3, [r6, #8]
	lsr r3, r4, #0x10
	strb r3, [r6, #9]
	lsr r3, r4, #8
	strb r3, [r6, #0xa]
	strb r4, [r6, #0xb]
	ldr r3, [sp, #0x10]
	ldr r4, [r3, #0xc]
	lsr r3, r4, #0x18
	strb r3, [r6, #0xc]
	lsr r3, r4, #0x10
	strb r3, [r6, #0xd]
	lsr r3, r4, #8
	strb r3, [r6, #0xe]
	strb r4, [r6, #0xf]
	ldr r3, [sp, #0x10]
	ldr r4, [r3, #0x10]
	lsr r3, r4, #0x18
	strb r3, [r6, #0x10]
	lsr r3, r4, #0x10
	strb r3, [r6, #0x11]
	lsr r3, r4, #8
	strb r3, [r6, #0x12]
	strb r4, [r6, #0x13]
	ldr r3, [sp, #0x10]
	str r0, [r3, #0x1c]
	bl FUN_0200A0CC
	pop {r4, r5, r6, lr}
	add sp, sp, #0x10
	bx lr
	.align 2, 0
_0200C3B0: .4byte 0x0231CF34
	arm_func_end FUN_0200C1B8

	arm_func_start FUN_0200C3B4
FUN_0200C3B4: @ 0x0200C3B4
	push {r4, r5, r6, r7, r8, lr}
	mov r8, r0
	movs r6, r2
	mov r7, r1
	add r5, r8, #0x20
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr r0, [r8, #0x14]
	add r1, r0, r6, lsl #3
	cmp r1, r0
	ldrlo r0, [r8, #0x18]
	addlo r0, r0, #1
	strlo r0, [r8, #0x18]
	ldr r0, [r8, #0x18]
	add r0, r0, r6, lsr #29
	str r0, [r8, #0x18]
	str r1, [r8, #0x14]
	ldr r1, [r8, #0x1c]
	cmp r1, #0
	beq _0200C474
	add r0, r1, r6
	cmp r0, #0x40
	blo _0200C450
	rsb r4, r1, #0x40
	mov r0, r7
	mov r2, r4
	add r1, r5, r1
	bl FUN_0200A1D8
	ldr r1, _0200C50C @ =0x0231CF34
	mov r0, r8
	ldr r3, [r1]
	mov r1, r5
	mov r2, #0x40
	sub r6, r6, r4
	add r7, r7, r4
	.word 0xE12FFF33
	mov r0, #0
	str r0, [r8, #0x1c]
	b _0200C474
_0200C450:
	mov r0, r7
	mov r2, r6
	add r1, r5, r1
	bl FUN_0200A1D8
	ldr r0, [r8, #0x1c]
	add r0, r0, r6
	str r0, [r8, #0x1c]
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0200C474:
	cmp r6, #0x40
	blo _0200C4E4
	bic r4, r6, #0x3f
	sub r6, r6, r4
	ands r0, r7, #3
	bne _0200C4AC
	ldr r1, _0200C50C @ =0x0231CF34
	mov r0, r8
	ldr r3, [r1]
	mov r1, r7
	mov r2, r4
	.word 0xE12FFF33
	add r7, r7, r4
	b _0200C4E4
_0200C4AC:
	mov r0, r7
	mov r1, r5
	mov r2, #0x40
	bl FUN_0200A1D8
	ldr r1, _0200C50C @ =0x0231CF34
	mov r0, r8
	ldr r3, [r1]
	mov r1, r5
	mov r2, #0x40
	add r7, r7, #0x40
	.word 0xE12FFF33
	sub r4, r4, #0x40
	cmp r4, #0
	bgt _0200C4AC
_0200C4E4:
	str r6, [r8, #0x1c]
	cmp r6, #0
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	mov r0, r7
	mov r1, r5
	mov r2, r6
	bl FUN_0200A1D8
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200C50C: .4byte 0x0231CF34
	arm_func_end FUN_0200C3B4

	arm_func_start FUN_0200C510
FUN_0200C510: @ 0x0200C510
	ldr r1, _0200C54C @ =0x67452301
	ldr r2, _0200C550 @ =0xEFCDAB89
	str r1, [r0]
	ldr r1, _0200C554 @ =0x98BADCFE
	str r2, [r0, #4]
	ldr r2, _0200C558 @ =0x10325476
	str r1, [r0, #8]
	ldr r1, _0200C55C @ =0xC3D2E1F0
	str r2, [r0, #0xc]
	str r1, [r0, #0x10]
	mov r1, #0
	str r1, [r0, #0x14]
	str r1, [r0, #0x18]
	str r1, [r0, #0x1c]
	bx lr
	.align 2, 0
_0200C54C: .4byte 0x67452301
_0200C550: .4byte 0xEFCDAB89
_0200C554: .4byte 0x98BADCFE
_0200C558: .4byte 0x10325476
_0200C55C: .4byte 0xC3D2E1F0
_0200C560: .4byte 0x00FF00FF
_0200C564: .4byte 0x5A827999
_0200C568: .4byte 0x6ED9EBA1
_0200C56C: .4byte 0x8F1BBCDC
_0200C570: .4byte 0xCA62C1D6
	arm_func_end FUN_0200C510

	arm_func_start FUN_0200C574
FUN_0200C574: @ 0x0200C574
	push {r4, r5, r6, r7, r8, sb, sl, fp, ip, lr}
	ldm r0, {r3, sb, sl, fp, ip}
	sub sp, sp, #0x84
	str r2, [sp, #0x80]
_0200C584:
	ldr r8, _0200C564 @ =0x5A827999
	ldr r7, _0200C560 @ =0x00FF00FF
	mov r6, sp
	mov r5, #0
_0200C594:
	ldr r4, [r1], #4
	add r2, r8, ip
	add r2, r2, r3, ror #27
	and lr, r4, r7
	and r4, r7, r4, ror #24
	orr r4, r4, lr, ror #8
	str r4, [r6, #0x40]
	str r4, [r6], #4
	add r2, r2, r4
	eor r4, sl, fp
	and r4, r4, sb
	eor r4, r4, fp
	add r2, r2, r4
	ror sb, sb, #2
	mov ip, fp
	mov fp, sl
	mov sl, sb
	mov sb, r3
	mov r3, r2
	add r5, r5, #4
	cmp r5, #0x40
	blt _0200C594
	mov r7, #0
	mov r6, sp
_0200C5F4:
	ldr r2, [r6]
	ldr r5, [r6, #8]
	ldr r4, [r6, #0x20]
	ldr lr, [r6, #0x34]
	eor r2, r2, r5
	eor r4, r4, lr
	eor r2, r2, r4
	ror r2, r2, #0x1f
	str r2, [r6, #0x40]
	str r2, [r6], #4
	add r2, r2, ip
	add r2, r2, r8
	add r2, r2, r3, ror #27
	eor r4, sl, fp
	and r4, r4, sb
	eor r4, r4, fp
	add r2, r2, r4
	ror sb, sb, #2
	mov ip, fp
	mov fp, sl
	mov sl, sb
	mov sb, r3
	mov r3, r2
	add r7, r7, #4
	cmp r7, #0x10
	blt _0200C5F4
	ldr r8, _0200C568 @ =0x6ED9EBA1
	mov r7, #0
_0200C664:
	ldr r2, [r6]
	ldr r4, [r6, #8]
	ldr lr, [r6, #0x20]
	ldr r5, [r6, #0x34]
	eor r2, r2, r4
	eor lr, lr, r5
	eor r2, r2, lr
	ror r2, r2, #0x1f
	str r2, [r6, #0x40]
	str r2, [r6], #4
	add r2, r2, ip
	add r2, r2, r8
	add r2, r2, r3, ror #27
	eor lr, sb, sl
	eor lr, lr, fp
	add r2, r2, lr
	ror sb, sb, #2
	mov ip, fp
	mov fp, sl
	mov sl, sb
	mov sb, r3
	mov r3, r2
	add r7, r7, #1
	cmp r7, #0xc
	moveq r6, sp
	cmp r7, #0x14
	blt _0200C664
	ldr r8, _0200C56C @ =0x8F1BBCDC
	mov r7, #0
_0200C6D8:
	ldr r2, [r6]
	ldr lr, [r6, #8]
	ldr r5, [r6, #0x20]
	ldr r4, [r6, #0x34]
	eor r2, r2, lr
	eor r5, r5, r4
	eor r2, r2, r5
	ror r2, r2, #0x1f
	str r2, [r6, #0x40]
	str r2, [r6], #4
	add r2, r2, ip
	add r2, r2, r8
	add r2, r2, r3, ror #27
	orr r5, sb, sl
	and r5, r5, fp
	and r4, sb, sl
	orr r5, r5, r4
	add r2, r2, r5
	ror sb, sb, #2
	mov ip, fp
	mov fp, sl
	mov sl, sb
	mov sb, r3
	mov r3, r2
	add r7, r7, #1
	cmp r7, #8
	moveq r6, sp
	cmp r7, #0x14
	blt _0200C6D8
	ldr r8, _0200C570 @ =0xCA62C1D6
	mov r7, #0
_0200C754:
	ldr r2, [r6]
	ldr r5, [r6, #8]
	ldr r4, [r6, #0x20]
	ldr lr, [r6, #0x34]
	eor r2, r2, r5
	eor r4, r4, lr
	eor r2, r2, r4
	ror r2, r2, #0x1f
	str r2, [r6, #0x40]
	str r2, [r6], #4
	add r2, r2, ip
	add r2, r2, r8
	add r2, r2, r3, ror #27
	eor r4, sb, sl
	eor r4, r4, fp
	add r2, r2, r4
	ror sb, sb, #2
	mov ip, fp
	mov fp, sl
	mov sl, sb
	mov sb, r3
	mov r3, r2
	add r7, r7, #1
	cmp r7, #4
	moveq r6, sp
	cmp r7, #0x14
	blt _0200C754
	ldm r0, {r2, r4, r6, r7, lr}
	add r3, r3, r2
	add sb, sb, r4
	add sl, sl, r6
	add fp, fp, r7
	add ip, ip, lr
	stm r0, {r3, sb, sl, fp, ip}
	ldr lr, [sp, #0x80]
	subs lr, lr, #0x40
	str lr, [sp, #0x80]
	bgt _0200C584
	add sp, sp, #0x84
	pop {r4, r5, r6, r7, r8, sb, sl, fp, ip, pc}
	arm_func_end FUN_0200C574

	arm_func_start FUN_0200C7F4
FUN_0200C7F4: @ 0x0200C7F4
	ldr r1, _0200C830 @ =0x04000290
	stmdb sp!, {r4}
	ldm r1, {r2, r3, r4, ip}
	stm r0!, {r2, r3, r4, ip}
	ldrh ip, [r1, #-0x10]
	add r1, r1, #0x28
	ldm r1, {r2, r3}
	stm r0!, {r2, r3}
	and ip, ip, #3
	ldrh r2, [r1, #-8]
	strh ip, [r0]
	and r2, r2, #1
	strh r2, [r0, #2]
	ldm sp!, {r4}
	bx lr
	.align 2, 0
_0200C830: .4byte 0x04000290
	arm_func_end FUN_0200C7F4

	arm_func_start FUN_0200C834
FUN_0200C834: @ 0x0200C834
	stmdb sp!, {r4}
	ldr r1, _0200C86C @ =0x04000290
	ldm r0, {r2, r3, r4, ip}
	stm r1, {r2, r3, r4, ip}
	ldrh r2, [r0, #0x18]
	ldrh r3, [r0, #0x1a]
	strh r2, [r1, #-0x10]
	strh r3, [r1, #0x20]
	add r0, r0, #0x10
	add r1, r1, #0x28
	ldm r0, {r2, r3}
	stm r1, {r2, r3}
	ldm sp!, {r4}
	bx lr
	.align 2, 0
_0200C86C: .4byte 0x04000290
	arm_func_end FUN_0200C834

	arm_func_start FUN_0200C870
FUN_0200C870: @ 0x0200C870
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200C8A8 @ =0x023085B0
	add r2, sp, #0
	bl FUN_0200C8AC
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200C8A8: .4byte 0x023085B0
	arm_func_end FUN_0200C870

	arm_func_start FUN_0200C8AC
FUN_0200C8AC: @ 0x0200C8AC
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	mov r4, r2
	bl FUN_0200D1B8
	cmp r0, #0
	moveq r0, #1
	popeq {r4, r5, r6, lr}
	bxeq lr
	ldr r0, _0200C8F8 @ =0x03006600
	ldr r1, _0200C8FC @ =0x02346834
	and r2, r6, #0xff
	orr r0, r2, r0
	str r5, [r1, #4]
	str r4, [r1, #8]
	bl FUN_0200CA2C
	mov r0, #0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200C8F8: .4byte 0x03006600
_0200C8FC: .4byte 0x02346834
	arm_func_end FUN_0200C8AC

	arm_func_start FUN_0200C900
FUN_0200C900: @ 0x0200C900
	ldr r0, _0200C918 @ =0x04000304
	ldrh r0, [r0]
	ands r0, r0, #1
	movne r0, #1
	moveq r0, #0
	bx lr
	.align 2, 0
_0200C918: .4byte 0x04000304
	arm_func_end FUN_0200C900

	arm_func_start FUN_0200C91C
FUN_0200C91C: @ 0x0200C91C
	ldr ip, _0200C938 @ =0x02307D7C
	mov r1, #0
	cmp r0, #1
	movne r0, #0
	mov r2, r1
	mov r3, #1
	bx ip
	.align 2, 0
_0200C938: .4byte 0x02307D7C
	arm_func_end FUN_0200C91C

	arm_func_start FUN_0200C93C
FUN_0200C93C: @ 0x0200C93C
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #0
	beq _0200C9C4
	cmp r0, #1
	bne _0200CA10
	cmp r2, #0
	bne _0200C984
	ldr r2, _0200CA20 @ =0x027FFC3C
	ldr r0, _0200CA24 @ =0x02346830
	ldr r2, [r2]
	ldr r0, [r0]
	sub r0, r2, r0
	cmp r0, #7
	addls sp, sp, #4
	movls r0, #0
	ldmls sp!, {lr}
	bxls lr
_0200C984:
	cmp r1, #0
	beq _0200C9B0
	cmp r3, #0
	beq _0200C9A0
	mov r0, r1
	bl FUN_0200CCE4
	b _0200C9B0
_0200C9A0:
	mov r0, r1
	mov r1, #0
	mov r2, r1
	bl FUN_0200CD20
_0200C9B0:
	ldr r1, _0200CA28 @ =0x04000304
	ldrh r0, [r1]
	orr r0, r0, #1
	strh r0, [r1]
	b _0200CA10
_0200C9C4:
	ldr lr, _0200CA28 @ =0x04000304
	ldr r2, _0200CA20 @ =0x027FFC3C
	ldrh ip, [lr]
	ldr r0, _0200CA24 @ =0x02346830
	cmp r1, #0
	bic ip, ip, #1
	strh ip, [lr]
	ldr r2, [r2]
	str r2, [r0]
	beq _0200CA10
	cmp r3, #0
	beq _0200CA00
	mov r0, r1
	bl FUN_0200CCE4
	b _0200CA10
_0200CA00:
	mov r0, r1
	mov r1, #0
	mov r2, r1
	bl FUN_0200CD20
_0200CA10:
	mov r0, #1
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CA20: .4byte 0x027FFC3C
_0200CA24: .4byte 0x02346830
_0200CA28: .4byte 0x04000304
	arm_func_end FUN_0200C93C

	arm_func_start FUN_0200CA2C
FUN_0200CA2C: @ 0x0200CA2C
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, #8
	mov r4, #0
_0200CA3C:
	mov r0, r5
	mov r1, r6
	mov r2, r4
	bl FUN_0200A4F0
	cmp r0, #0
	bne _0200CA3C
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0200CA2C

	arm_func_start FUN_0200CA5C
FUN_0200CA5C: @ 0x0200CA5C
	push {r4, lr}
	sub sp, sp, #8
	mov r4, r0
	add r1, sp, #0
	mov r0, #2
	bl FUN_0200CE44
	cmp r0, #0
	addne sp, sp, #8
	popne {r4, lr}
	bxne lr
	cmp r4, #0
	ldrhne r1, [sp]
	strne r1, [r4]
	add sp, sp, #8
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200CA5C

	arm_func_start FUN_0200CA9C
FUN_0200CA9C: @ 0x0200CA9C
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r4, r1
	mov r5, r0
	add r1, sp, #0
	mov r0, #0
	bl FUN_0200CE44
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	cmp r5, #0
	beq _0200CAE4
	ldrh r1, [sp]
	ands r1, r1, #8
	movne r1, #1
	moveq r1, #0
	str r1, [r5]
_0200CAE4:
	cmp r4, #0
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	ldrh r1, [sp]
	ands r1, r1, #4
	movne r1, #1
	moveq r1, #0
	str r1, [r4]
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200CA9C

	arm_func_start FUN_0200CB14
FUN_0200CB14: @ 0x0200CB14
	ldr ip, _0200CB28 @ =0x023081C8
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	mov r0, #2
	bx ip
	.align 2, 0
_0200CB28: .4byte 0x023081C8
	arm_func_end FUN_0200CB14

	arm_func_start FUN_0200CB2C
FUN_0200CB2C: @ 0x0200CB2C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r0, _0200CB64 @ =0x023085B0
	add r1, sp, #0
	bl FUN_0200CB68
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CB64: .4byte 0x023085B0
	arm_func_end FUN_0200CB2C

	arm_func_start FUN_0200CB68
FUN_0200CB68: @ 0x0200CB68
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0xc
	mov r7, r0
	ldr r0, _0200CC14 @ =0x00996A00
	mov r6, r1
	bl _02009B00
	bl FUN_0200C900
	cmp r0, #1
	beq _0200CBF8
	add r0, sp, #0
	add r1, sp, #4
	bl FUN_0200CA9C
	ldr r0, [sp]
	cmp r0, #0
	beq _0200CBB0
	mov r0, #0
	mov r1, r0
	bl FUN_0200CC18
_0200CBB0:
	ldr r0, [sp, #4]
	cmp r0, #0
	beq _0200CBC8
	mov r0, #1
	mov r1, #0
	bl FUN_0200CC18
_0200CBC8:
	mov r0, #1
	bl FUN_0200C91C
	cmp r0, #0
	bne _0200CBF8
	ldr r5, _0200CC14 @ =0x00996A00
	mov r4, #1
_0200CBE0:
	mov r0, r5
	bl _02009B00
	mov r0, r4
	bl FUN_0200C91C
	cmp r0, #0
	beq _0200CBE0
_0200CBF8:
	mov r1, r7
	mov r2, r6
	mov r0, #0xe
	bl FUN_0200CEF8
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200CC14: .4byte 0x00996A00
	arm_func_end FUN_0200CB68

	arm_func_start FUN_0200CC18
FUN_0200CC18: @ 0x0200CC18
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _0200CC50 @ =0x023085B0
	add r3, sp, #0
	bl FUN_0200CC54
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CC50: .4byte 0x023085B0
	arm_func_end FUN_0200CC18

	arm_func_start FUN_0200CC54
FUN_0200CC54: @ 0x0200CC54
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #0
	mov ip, #0
	bne _0200CC7C
	cmp r1, #1
	moveq ip, #6
	cmp r1, #0
	moveq ip, #7
	b _0200CCB0
_0200CC7C:
	cmp r0, #1
	bne _0200CC98
	cmp r1, #1
	moveq ip, #4
	cmp r1, #0
	moveq ip, #5
	b _0200CCB0
_0200CC98:
	cmp r0, #2
	bne _0200CCB0
	cmp r1, #1
	moveq ip, #8
	cmp r1, #0
	moveq ip, #9
_0200CCB0:
	cmp ip, #0
	addeq sp, sp, #4
	ldreq r0, _0200CCE0 @ =0x0000FFFF
	ldmeq sp!, {lr}
	bxeq lr
	mov r1, r2
	mov r0, ip
	mov r2, r3
	bl FUN_0200CEF8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CCE0: .4byte 0x0000FFFF
	arm_func_end FUN_0200CC54

	arm_func_start FUN_0200CCE4
FUN_0200CCE4: @ 0x0200CCE4
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200CD1C @ =0x023085B0
	add r2, sp, #0
	bl FUN_0200CD20
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CD1C: .4byte 0x023085B0
	arm_func_end FUN_0200CCE4

	arm_func_start FUN_0200CD20
FUN_0200CD20: @ 0x0200CD20
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #1
	beq _0200CD44
	cmp r0, #2
	beq _0200CD54
	cmp r0, #3
	beq _0200CD4C
	b _0200CD5C
_0200CD44:
	mov r0, #1
	b _0200CD60
_0200CD4C:
	mov r0, #2
	b _0200CD60
_0200CD54:
	mov r0, #3
	b _0200CD60
_0200CD5C:
	mov r0, #0
_0200CD60:
	cmp r0, #0
	addeq sp, sp, #4
	ldreq r0, _0200CD84 @ =0x0000FFFF
	ldmeq sp!, {lr}
	bxeq lr
	bl FUN_0200CEF8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CD84: .4byte 0x0000FFFF
	arm_func_end FUN_0200CD20

	arm_func_start FUN_0200CD88
FUN_0200CD88: @ 0x0200CD88
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _0200CDC0 @ =0x023085B0
	add r3, sp, #0
	bl FUN_0200CDC4
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CDC0: .4byte 0x023085B0
	arm_func_end FUN_0200CD88

	arm_func_start FUN_0200CDC4
FUN_0200CDC4: @ 0x0200CDC4
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r4, r1
	mov r6, r2
	mov r5, r3
	bl FUN_0200D1B8
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #1
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	ldr r0, _0200CE34 @ =0x02006400
	ldr r1, _0200CE38 @ =0x02346834
	and r2, r7, #0xff
	orr r0, r2, r0
	str r6, [r1, #4]
	str r5, [r1, #8]
	bl FUN_0200CA2C
	ldr r0, _0200CE3C @ =0x0000FFFF
	ldr r1, _0200CE40 @ =0x01010000
	and r0, r4, r0
	orr r0, r0, r1
	bl FUN_0200CA2C
	mov r0, #0
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200CE34: .4byte 0x02006400
_0200CE38: .4byte 0x02346834
_0200CE3C: .4byte 0x0000FFFF
_0200CE40: .4byte 0x01010000
	arm_func_end FUN_0200CDC4

	arm_func_start FUN_0200CE44
FUN_0200CE44: @ 0x0200CE44
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _0200CE7C @ =0x023085B0
	add r3, sp, #0
	bl FUN_0200CE80
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_0200D178
	ldr r0, [sp]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200CE7C: .4byte 0x023085B0
	arm_func_end FUN_0200CE44

	arm_func_start FUN_0200CE80
FUN_0200CE80: @ 0x0200CE80
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	mov r4, r3
	bl FUN_0200D1B8
	cmp r0, #0
	moveq r0, #1
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr ip, _0200CEE8 @ =0x0234685C
	ldr r1, _0200CEEC @ =0x02346834
	ldr r0, _0200CEF0 @ =0x03006500
	and r2, r7, #0xff
	lsl lr, r7, #3
	mov r8, #0
	ldr r3, _0200CEF4 @ =0x02346860
	strh r8, [ip, lr]
	orr r0, r2, r0
	str r5, [r1, #4]
	str r4, [r1, #8]
	str r6, [r3, r7, lsl #3]
	bl FUN_0200CA2C
	mov r0, r8
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200CEE8: .4byte 0x0234685C
_0200CEEC: .4byte 0x02346834
_0200CEF0: .4byte 0x03006500
_0200CEF4: .4byte 0x02346860
	arm_func_end FUN_0200CE80

	arm_func_start FUN_0200CEF8
FUN_0200CEF8: @ 0x0200CEF8
	push {r4, r5, r6, lr}
	mov r4, r0
	mov r6, r1
	mov r5, r2
	bl FUN_0200D1B8
	cmp r0, #0
	moveq r0, #1
	popeq {r4, r5, r6, lr}
	bxeq lr
	lsr r2, r4, #0x10
	ldr r1, _0200CF5C @ =0x02346834
	ldr r0, _0200CF60 @ =0x02006300
	and r2, r2, #0xff
	orr r0, r2, r0
	str r6, [r1, #4]
	str r5, [r1, #8]
	bl FUN_0200CA2C
	ldr r0, _0200CF64 @ =0x0000FFFF
	ldr r1, _0200CF68 @ =0x01010000
	and r0, r4, r0
	orr r0, r0, r1
	bl FUN_0200CA2C
	mov r0, #0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200CF5C: .4byte 0x02346834
_0200CF60: .4byte 0x02006300
_0200CF64: .4byte 0x0000FFFF
_0200CF68: .4byte 0x01010000
	arm_func_end FUN_0200CEF8

	arm_func_start FUN_0200CF6C
FUN_0200CF6C: @ 0x0200CF6C
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r2, #0
	beq _0200CF90
	mov r0, #2
	bl FUN_0200D11C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
_0200CF90:
	and r0, r1, #0x7f00
	lsl r0, r0, #8
	and r1, r1, #0xff
	lsr r2, r0, #0x10
	lsl r0, r1, #0x10
	cmp r2, #0x70
	lsr r0, r0, #0x10
	blo _0200CFF0
	cmp r2, #0x74
	bhi _0200CFF0
	ldr r1, _0200D044 @ =0x02346860
	sub r2, r2, #0x70
	and r0, r0, #0xff
	ldr r1, [r1, r2, lsl #3]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r1, #0
	strhne r0, [r1]
	lsl r1, r2, #3
	ldr r0, _0200D048 @ =0x0234685C
	mov r2, #1
	strh r2, [r0, r1]
	mov r0, #0
	b _0200D034
_0200CFF0:
	cmp r2, #0x60
	ldreq r1, _0200D04C @ =0x02346828
	moveq r2, #1
	streq r2, [r1]
	beq _0200D034
	cmp r2, #0x62
	ldreq r1, _0200D050 @ =0x0234682C
	moveq r2, #1
	streq r2, [r1]
	beq _0200D034
	cmp r2, #0x67
	bne _0200D034
	ldr r1, _0200D054 @ =0x02346834
	ldr r1, [r1, #0xc]
	cmp r1, #0
	strne r0, [r1]
	mov r0, #0
_0200D034:
	bl FUN_0200D11C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200D044: .4byte 0x02346860
_0200D048: .4byte 0x0234685C
_0200D04C: .4byte 0x02346828
_0200D050: .4byte 0x0234682C
_0200D054: .4byte 0x02346834
	arm_func_end FUN_0200CF6C

	arm_func_start FUN_0200D058
FUN_0200D058: @ 0x0200D058
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r1, _0200D100 @ =0x02346824
	ldrh r0, [r1]
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	ldr r0, _0200D104 @ =0x02346834
	mov r2, #0
	mov r3, #1
	strh r3, [r1]
	str r2, [r0]
	str r2, [r0, #4]
	bl FUN_0200A3C0
	mov r5, #8
	mov r4, #1
_0200D09C:
	mov r0, r5
	mov r1, r4
	bl FUN_0200A5A4
	cmp r0, #0
	beq _0200D09C
	ldr r1, _0200D108 @ =0x023083AC
	mov r0, #8
	bl FUN_0200A5CC
	mov r3, #0
	ldr r0, _0200D10C @ =0x0234685C
	mov r2, r3
_0200D0C8:
	lsl r1, r3, #3
	add r3, r3, #1
	strh r2, [r0, r1]
	cmp r3, #5
	blt _0200D0C8
	ldr r0, _0200D110 @ =0x02346844
	bl FUN_02008C0C
	ldr r1, _0200D114 @ =0x027FFC3C
	ldr r0, _0200D118 @ =0x02346830
	ldr r1, [r1]
	str r1, [r0]
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200D100: .4byte 0x02346824
_0200D104: .4byte 0x02346834
_0200D108: .4byte 0x023083AC
_0200D10C: .4byte 0x0234685C
_0200D110: .4byte 0x02346844
_0200D114: .4byte 0x027FFC3C
_0200D118: .4byte 0x02346830
	arm_func_end FUN_0200D058

	arm_func_start FUN_0200D11C
FUN_0200D11C: @ 0x0200D11C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r2, _0200D16C @ =0x02346834
	ldr r1, [r2]
	ldr ip, [r2, #4]
	cmp r1, #0
	movne r3, #0
	strne r3, [r2]
	cmp ip, #0
	addeq sp, sp, #4
	ldr r1, [r2, #8]
	ldmeq sp!, {lr}
	bxeq lr
	ldr r2, _0200D16C @ =0x02346834
	mov r3, #0
	str r3, [r2, #4]
	.word 0xE12FFF3C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200D16C: .4byte 0x02346834
	arm_func_end FUN_0200D11C

	arm_func_start FUN_0200D170
FUN_0200D170: @ 0x0200D170
	str r0, [r1]
	bx lr
	arm_func_end FUN_0200D170

	arm_func_start FUN_0200D178
FUN_0200D178: @ 0x0200D178
	push {r4, lr}
	ldr r4, _0200D1B4 @ =0x02346834
	ldr r0, [r4]
	cmp r0, #0
	popeq {r4, lr}
	bxeq lr
_0200D190:
	bl FUN_02009AE8
	cmp r0, #0x80
	bne _0200D1A0
	bl FUN_0200A3CC
_0200D1A0:
	ldr r0, [r4]
	cmp r0, #0
	bne _0200D190
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200D1B4: .4byte 0x02346834
	arm_func_end FUN_0200D178

	arm_func_start FUN_0200D1B8
FUN_0200D1B8: @ 0x0200D1B8
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_02009A90
	ldr r1, _0200D204 @ =0x02346834
	ldr r2, [r1]
	cmp r2, #0
	beq _0200D1E8
	bl FUN_02009AA4
	add sp, sp, #4
	mov r0, #0
	ldm sp!, {lr}
	bx lr
_0200D1E8:
	mov r2, #1
	str r2, [r1]
	bl FUN_02009AA4
	mov r0, #1
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200D204: .4byte 0x02346834
	arm_func_end FUN_0200D1B8

	arm_func_start FUN_0200D208
FUN_0200D208: @ 0x0200D208
	ldr ip, _0200D21C @ =0x02346888
_0200D20C:
	ldr r0, [ip]
	cmp r0, #1
	beq _0200D20C
	bx lr
	.align 2, 0
_0200D21C: .4byte 0x02346888
	arm_func_end FUN_0200D208

	arm_func_start FUN_0200D220
FUN_0200D220: @ 0x0200D220
	ldr r1, _0200D22C @ =0x02346888
	str r0, [r1, #0x20]
	bx lr
	.align 2, 0
_0200D22C: .4byte 0x02346888
	arm_func_end FUN_0200D220

	arm_func_start FUN_0200D230
FUN_0200D230: @ 0x0200D230
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, #0
	mov r3, r5
	mov r2, r5
_0200D244:
	lsr r1, r0, r2
	and r1, r1, #0xf
	cmp r1, #0xa
	addhs sp, sp, #4
	movhs r0, #0
	pophs {r4, r5, lr}
	bxhs lr
	add r3, r3, #1
	cmp r3, #8
	add r2, r2, #4
	blt _0200D244
	mov ip, #0
	mov lr, ip
	mov r4, #1
	mov r2, #0xa
_0200D280:
	lsr r1, r0, lr
	and r3, r1, #0xf
	mul r1, r4, r2
	mla r5, r4, r3, r5
	add ip, ip, #1
	mov r4, r1
	cmp ip, #8
	add lr, lr, #4
	blt _0200D280
	mov r0, r5
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200D230

	arm_func_start FUN_0200D2B4
FUN_0200D2B4: @ 0x0200D2B4
	push {r4, r5, lr}
	sub sp, sp, #4
	cmp r2, #0
	beq _0200D324
	ldr r0, _0200D824 @ =0x02346888
	ldr r2, _0200D824 @ =0x02346888
	ldr r1, [r0, #0x18]
	ldr r4, [r2, #4]
	cmp r1, #0
	movne r1, #0
	strne r1, [r0, #0x18]
	ldr r0, _0200D824 @ =0x02346888
	ldr r1, [r0]
	cmp r1, #0
	movne r1, #0
	strne r1, [r0]
	cmp r4, #0
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r2, #0x10]
	mov r3, #0
	mov r0, #6
	str r3, [r2, #4]
	.word 0xE12FFF34
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
_0200D324:
	and r0, r1, #0x7f00
	lsr r0, r0, #8
	and r0, r0, #0xff
	cmp r0, #0x30
	and r2, r1, #0xff
	bne _0200D364
	ldr r0, _0200D824 @ =0x02346888
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	.word 0xE12FFF30
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
_0200D364:
	cmp r2, #0
	bne _0200D77C
	ldr r0, _0200D824 @ =0x02346888
	mov r5, #0
	ldr r1, [r0, #0x14]
	cmp r1, #0xf
	addls pc, pc, r1, lsl #2
	b _0200D768
_0200D384: @ jump table
	b _0200D3C4 @ case 0
	b _0200D418 @ case 1
	b _0200D468 @ case 2
	b _0200D7C4 @ case 3
	b _0200D7C4 @ case 4
	b _0200D7C4 @ case 5
	b _0200D510 @ case 6
	b _0200D540 @ case 7
	b _0200D564 @ case 8
	b _0200D608 @ case 9
	b _0200D6BC @ case 10
	b _0200D7C4 @ case 11
	b _0200D7C4 @ case 12
	b _0200D7C4 @ case 13
	b _0200D7C4 @ case 14
	b _0200D7C4 @ case 15
_0200D3C4:
	ldr r1, _0200D828 @ =0x027FFDE8
	ldr r4, [r0, #8]
	ldrb r0, [r1]
	bl FUN_0200D230
	ldr r1, _0200D828 @ =0x027FFDE8
	str r0, [r4]
	ldr r0, [r1]
	lsl r0, r0, #0x13
	lsr r0, r0, #0x1b
	bl FUN_0200D230
	ldr r1, _0200D828 @ =0x027FFDE8
	str r0, [r4, #4]
	ldr r0, [r1]
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1a
	bl FUN_0200D230
	str r0, [r4, #8]
	mov r0, r4
	bl FUN_0200D9D0
	str r0, [r4, #0xc]
	b _0200D7C4
_0200D418:
	ldr r1, _0200D82C @ =0x027FFDEC
	ldr r4, [r0, #8]
	ldr r0, [r1]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1a
	bl FUN_0200D230
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4]
	ldr r0, [r1]
	lsl r0, r0, #0x11
	lsr r0, r0, #0x19
	bl FUN_0200D230
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4, #4]
	ldr r0, [r1]
	lsl r0, r0, #9
	lsr r0, r0, #0x19
	bl FUN_0200D230
	str r0, [r4, #8]
	b _0200D7C4
_0200D468:
	ldr r1, _0200D828 @ =0x027FFDE8
	ldr r4, [r0, #8]
	ldr r0, [r1]
	and r0, r0, #0xff
	bl FUN_0200D230
	ldr r1, _0200D828 @ =0x027FFDE8
	str r0, [r4]
	ldr r0, [r1]
	lsl r0, r0, #0x13
	lsr r0, r0, #0x1b
	bl FUN_0200D230
	ldr r1, _0200D828 @ =0x027FFDE8
	str r0, [r4, #4]
	ldr r0, [r1]
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1a
	bl FUN_0200D230
	str r0, [r4, #8]
	mov r0, r4
	bl FUN_0200D9D0
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4, #0xc]
	ldr r0, [r1]
	ldr r1, _0200D824 @ =0x02346888
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1a
	ldr r4, [r1, #0xc]
	bl FUN_0200D230
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4]
	ldr r0, [r1]
	lsl r0, r0, #0x11
	lsr r0, r0, #0x19
	bl FUN_0200D230
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4, #4]
	ldr r0, [r1]
	lsl r0, r0, #9
	lsr r0, r0, #0x19
	bl FUN_0200D230
	str r0, [r4, #8]
	b _0200D7C4
_0200D510:
	ldr r1, _0200D830 @ =0x027FFDEA
	ldr r2, [r0, #8]
	ldrh r0, [r1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	cmp r0, #4
	bne _0200D538
	mov r0, #1
	str r0, [r2]
	b _0200D7C4
_0200D538:
	str r5, [r2]
	b _0200D7C4
_0200D540:
	ldr r1, _0200D830 @ =0x027FFDEA
	ldr r2, [r0, #8]
	ldrh r0, [r1]
	lsl r0, r0, #0x19
	lsrs r0, r0, #0x1f
	movne r0, #1
	strne r0, [r2]
	streq r5, [r2]
	b _0200D7C4
_0200D564:
	ldr r1, _0200D82C @ =0x027FFDEC
	ldr r4, [r0, #8]
	ldr r0, [r1]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	str r0, [r4]
	ldr r0, [r1]
	lsl r0, r0, #0x12
	lsr r0, r0, #0x1a
	bl FUN_0200D230
	ldr r1, _0200D82C @ =0x027FFDEC
	str r0, [r4, #4]
	ldr r0, [r1]
	lsl r0, r0, #9
	lsr r0, r0, #0x19
	bl FUN_0200D230
	str r0, [r4, #8]
	mov r1, r5
	ldr r0, _0200D82C @ =0x027FFDEC
	str r1, [r4, #0xc]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	lsrs r0, r0, #0x1f
	ldrne r0, [r4, #0xc]
	addne r0, r0, #1
	strne r0, [r4, #0xc]
	ldr r0, _0200D82C @ =0x027FFDEC
	ldr r0, [r0]
	lsl r0, r0, #0x10
	lsrs r0, r0, #0x1f
	ldrne r0, [r4, #0xc]
	addne r0, r0, #2
	strne r0, [r4, #0xc]
	ldr r0, _0200D82C @ =0x027FFDEC
	ldr r0, [r0]
	lsl r0, r0, #8
	lsrs r0, r0, #0x1f
	ldrne r0, [r4, #0xc]
	addne r0, r0, #4
	strne r0, [r4, #0xc]
	b _0200D7C4
_0200D608:
	ldr r3, [r0, #0x18]
	cmp r3, #0
	bne _0200D6B4
	ldr r1, [r0, #8]
	ldr r1, [r1]
	cmp r1, #1
	bne _0200D670
	ldr r2, _0200D830 @ =0x027FFDEA
	ldrh r1, [r2]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	cmp r1, #4
	beq _0200D7C4
	add r1, r3, #1
	str r1, [r0, #0x18]
	ldrh r0, [r2]
	bic r0, r0, #0xf
	orr r0, r0, #4
	strh r0, [r2]
	bl FUN_0200D9B0
	cmp r0, #0
	moveq r1, r5
	ldreq r0, _0200D824 @ =0x02346888
	moveq r5, #3
	streq r1, [r0, #0x18]
	b _0200D7C4
_0200D670:
	ldr r2, _0200D830 @ =0x027FFDEA
	ldrh r1, [r2]
	lsl r1, r1, #0x1c
	lsrs r1, r1, #0x1c
	beq _0200D7C4
	add r1, r3, #1
	str r1, [r0, #0x18]
	ldrh r0, [r2]
	bic r0, r0, #0xf
	strh r0, [r2]
	bl FUN_0200D9B0
	cmp r0, #0
	moveq r1, r5
	ldreq r0, _0200D824 @ =0x02346888
	moveq r5, #3
	streq r1, [r0, #0x18]
	b _0200D7C4
_0200D6B4:
	str r5, [r0, #0x18]
	b _0200D7C4
_0200D6BC:
	ldr r3, [r0, #0x18]
	cmp r3, #0
	bne _0200D760
	ldr r1, [r0, #8]
	ldr r1, [r1]
	cmp r1, #1
	bne _0200D71C
	ldr r2, _0200D830 @ =0x027FFDEA
	ldrh r1, [r2]
	lsl r1, r1, #0x19
	lsrs r1, r1, #0x1f
	bne _0200D7C4
	add r1, r3, #1
	str r1, [r0, #0x18]
	ldrh r0, [r2]
	orr r0, r0, #0x40
	strh r0, [r2]
	bl FUN_0200D9B0
	cmp r0, #0
	moveq r1, r5
	ldreq r0, _0200D824 @ =0x02346888
	moveq r5, #3
	streq r1, [r0, #0x18]
	b _0200D7C4
_0200D71C:
	ldr r2, _0200D830 @ =0x027FFDEA
	ldrh r1, [r2]
	lsl r1, r1, #0x19
	lsrs r1, r1, #0x1f
	beq _0200D7C4
	add r1, r3, #1
	str r1, [r0, #0x18]
	ldrh r0, [r2]
	bic r0, r0, #0x40
	strh r0, [r2]
	bl FUN_0200D9B0
	cmp r0, #0
	moveq r1, r5
	ldreq r0, _0200D824 @ =0x02346888
	moveq r5, #3
	streq r1, [r0, #0x18]
	b _0200D7C4
_0200D760:
	str r5, [r0, #0x18]
	b _0200D7C4
_0200D768:
	ldr r0, _0200D824 @ =0x02346888
	mov r1, #0
	str r1, [r0, #0x18]
	mov r5, #4
	b _0200D7C4
_0200D77C:
	ldr r0, _0200D824 @ =0x02346888
	mov r1, #0
	str r1, [r0, #0x18]
	cmp r2, #4
	addls pc, pc, r2, lsl #2
	b _0200D7C0
_0200D794: @ jump table
	b _0200D7C0 @ case 0
	b _0200D7A8 @ case 1
	b _0200D7B0 @ case 2
	b _0200D7B8 @ case 3
	b _0200D7C0 @ case 4
_0200D7A8:
	mov r5, #4
	b _0200D7C4
_0200D7B0:
	mov r5, #5
	b _0200D7C4
_0200D7B8:
	mov r5, #1
	b _0200D7C4
_0200D7C0:
	mov r5, #6
_0200D7C4:
	ldr r0, _0200D824 @ =0x02346888
	ldr r1, [r0, #0x18]
	cmp r1, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	ldr r2, _0200D824 @ =0x02346888
	ldr r1, [r0]
	ldr r4, [r2, #4]
	cmp r1, #0
	movne r1, #0
	strne r1, [r0]
	cmp r4, #0
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r2, #0x10]
	mov r3, #0
	mov r0, r5
	str r3, [r2, #4]
	.word 0xE12FFF34
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200D824: .4byte 0x02346888
_0200D828: .4byte 0x027FFDE8
_0200D82C: .4byte 0x027FFDEC
_0200D830: .4byte 0x027FFDEA
	arm_func_end FUN_0200D2B4

	arm_func_start FUN_0200D834
FUN_0200D834: @ 0x0200D834
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _0200D870 @ =0x02308660
	mov r2, #0
	bl FUN_0200D878
	ldr r1, _0200D874 @ =0x02346888
	cmp r0, #0
	str r0, [r1, #0x20]
	bne _0200D85C
	bl FUN_0200D208
_0200D85C:
	ldr r0, _0200D874 @ =0x02346888
	ldr r0, [r0, #0x20]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200D870: .4byte 0x02308660
_0200D874: .4byte 0x02346888
	arm_func_end FUN_0200D834

	arm_func_start FUN_0200D878
FUN_0200D878: @ 0x0200D878
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	mov r4, r2
	bl FUN_02009A90
	ldr r1, _0200D8F0 @ =0x02346888
	ldr r2, [r1]
	cmp r2, #0
	beq _0200D8AC
	bl FUN_02009AA4
	mov r0, #1
	pop {r4, r5, r6, lr}
	bx lr
_0200D8AC:
	mov r2, #1
	str r2, [r1]
	bl FUN_02009AA4
	ldr r0, _0200D8F0 @ =0x02346888
	mov r2, #1
	mov r1, #0
	str r2, [r0, #0x14]
	str r1, [r0, #0x18]
	str r6, [r0, #8]
	str r5, [r0, #4]
	str r4, [r0, #0x10]
	bl FUN_0200D9C0
	cmp r0, #0
	movne r0, #0
	moveq r0, #3
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200D8F0: .4byte 0x02346888
	arm_func_end FUN_0200D878

	arm_func_start FUN_0200D8F4
FUN_0200D8F4: @ 0x0200D8F4
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r1, _0200D970 @ =0x02346884
	ldrh r0, [r1]
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	ldr r0, _0200D974 @ =0x02346888
	mov r2, #0
	mov r3, #1
	strh r3, [r1]
	str r2, [r0]
	str r2, [r0, #4]
	str r2, [r0, #0x1c]
	str r2, [r0, #8]
	str r2, [r0, #0xc]
	bl FUN_0200A3C0
	mov r5, #5
	mov r4, #1
_0200D944:
	mov r0, r5
	mov r1, r4
	bl FUN_0200A5A4
	cmp r0, #0
	beq _0200D944
	ldr r1, _0200D978 @ =0x023086F4
	mov r0, #5
	bl FUN_0200A5CC
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200D970: .4byte 0x02346884
_0200D974: .4byte 0x02346888
_0200D978: .4byte 0x023086F4
	arm_func_end FUN_0200D8F4

	arm_func_start FUN_0200D97C
FUN_0200D97C: @ 0x0200D97C
	stmdb sp!, {lr}
	sub sp, sp, #4
	lsl r0, r0, #8
	and r1, r0, #0x7f00
	mov r0, #5
	mov r2, #0
	bl FUN_0200A4F0
	cmp r0, #0
	movge r0, #1
	movlt r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200D97C

	arm_func_start FUN_0200D9B0
FUN_0200D9B0: @ 0x0200D9B0
	ldr ip, _0200D9BC @ =0x02308DBC
	mov r0, #0x27
	bx ip
	.align 2, 0
_0200D9BC: .4byte 0x02308DBC
	arm_func_end FUN_0200D9B0

	arm_func_start FUN_0200D9C0
FUN_0200D9C0: @ 0x0200D9C0
	ldr ip, _0200D9CC @ =0x02308DBC
	mov r0, #0x12
	bx ip
	.align 2, 0
_0200D9CC: .4byte 0x02308DBC
	arm_func_end FUN_0200D9C0

	arm_func_start FUN_0200D9D0
FUN_0200D9D0: @ 0x0200D9D0
	push {r4, r5, r6, lr}
	ldr r1, [r0, #4]
	ldr r2, [r0]
	sub r3, r1, #2
	cmp r3, #1
	add lr, r2, #0x7d0
	ldr r4, _0200DA94 @ =0x51EB851F
	sublt lr, lr, #1
	ldr ip, [r0, #8]
	smull r0, r2, r4, lr
	addlt r3, r3, #0xc
	mov r1, #0x1a
	mul r0, r3, r1
	smull r1, r3, r4, lr
	ldr r5, _0200DA98 @ =0x66666667
	sub r0, r0, #2
	smull r4, r1, r5, r0
	lsr r4, lr, #0x1f
	asr r2, r2, #5
	asr r3, r3, #5
	add r3, r4, r3
	ldr r5, _0200DA9C @ =0x00000064
	add r2, r4, r2
	smull r2, r4, r5, r2
	sub r2, lr, r2
	asr r1, r1, #2
	lsr r0, r0, #0x1f
	add r1, r0, r1
	asr r4, r2, #1
	add r0, ip, r1
	add r1, r2, r4, lsr #30
	add r2, r2, r0
	asr r6, r3, #1
	add r0, r3, r6, lsr #30
	add r1, r2, r1, asr #2
	add r1, r1, r0, asr #2
	mov r0, #5
	mla r4, r3, r0, r1
	ldr r3, _0200DAA0 @ =0x92492493
	lsr r1, r4, #0x1f
	smull r2, r0, r3, r4
	add r0, r4, r0
	asr r0, r0, #2
	ldr r2, _0200DAA4 @ =0x00000007
	add r0, r1, r0
	smull r0, r1, r2, r0
	sub r0, r4, r0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200DA94: .4byte 0x51EB851F
_0200DA98: .4byte 0x66666667
_0200DA9C: .4byte 0x00000064
_0200DAA0: .4byte 0x92492493
_0200DAA4: .4byte 0x00000007
	arm_func_end FUN_0200D9D0

	arm_func_start FUN_0200DAA8
FUN_0200DAA8: @ 0x0200DAA8
	push {r4, lr}
	mov r4, r0
	bl FUN_02007C04
	mov r0, r4
	mov r1, #1
	bl FUN_0200DC90
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200DAA8

	arm_func_start FUN_0200DAC8
FUN_0200DAC8: @ 0x0200DAC8
	push {r4, lr}
	mov r4, r0
	mov r1, #1
	bl FUN_0200DD34
	mov r0, r4
	bl FUN_02007C20
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200DAC8

	arm_func_start FUN_0200DAE8
FUN_0200DAE8: @ 0x0200DAE8
	push {r4, r5, r6, lr}
	ldr r6, _0200DB40 @ =0x02346920
	bl FUN_02009A90
	ldr r1, [r6, #0x114]
	mov r5, r0
	ands r0, r1, #4
	beq _0200DB1C
	add r4, r6, #0x10c
_0200DB08:
	mov r0, r4
	bl FUN_0200819C
	ldr r0, [r6, #0x114]
	ands r0, r0, #4
	bne _0200DB08
_0200DB1C:
	mov r0, r5
	bl FUN_02009AA4
	ldr r0, [r6]
	ldr r0, [r0]
	cmp r0, #0
	moveq r0, #1
	movne r0, #0
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200DB40: .4byte 0x02346920
	arm_func_end FUN_0200DAE8

	arm_func_start FUN_0200DB44
FUN_0200DB44: @ 0x0200DB44
	ldr r1, _0200DB50 @ =0x023468AC
	str r0, [r1]
	bx lr
	.align 2, 0
_0200DB50: .4byte 0x023468AC
	arm_func_end FUN_0200DB44

	arm_func_start FUN_0200DB54
FUN_0200DB54: @ 0x0200DB54
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200DB80
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200DB54

	arm_func_start FUN_0200DB80
FUN_0200DB80: @ 0x0200DB80
	ldr r0, _0200DB8C @ =0x023468AC
	ldr r0, [r0]
	bx lr
	.align 2, 0
_0200DB8C: .4byte 0x023468AC
	arm_func_end FUN_0200DB80

	arm_func_start FUN_0200DB90
FUN_0200DB90: @ 0x0200DB90
	push {r4, lr}
	sub sp, sp, #8
	ldr r4, _0200DC70 @ =0x02346920
	ldr r1, _0200DC74 @ =0x023468C0
	mvn r2, #2
	mov r0, #0
	str r2, [r4, #8]
	mov r2, #0x60
	str r0, [r4, #0xc]
	str r0, [r4, #0x18]
	str r1, [r4]
	bl FUN_0200A0F8
	ldr r0, _0200DC74 @ =0x023468C0
	mov r1, #0x60
	bl FUN_02008C94
	ldr r0, _0200DC78 @ =0x027FFC40
	ldrh r0, [r0]
	cmp r0, #2
	beq _0200DBEC
	ldr r0, _0200DC7C @ =0x027FFE00
	ldr r1, _0200DC80 @ =0x027FFA80
	mov r2, #0x160
	bl FUN_0200A1D8
_0200DBEC:
	mov r2, #0
	str r2, [r4, #0x14]
	ldr r0, [r4, #0x14]
	mov r1, #4
	str r0, [r4, #0x10]
	str r2, [r4, #0x110]
	ldr r3, [r4, #0x110]
	mov r0, #0x400
	str r3, [r4, #0x10c]
	str r1, [r4, #0x108]
	str r0, [sp]
	ldr ip, [r4, #0x108]
	ldr r1, _0200DC84 @ =0x02309AE8
	ldr r3, _0200DC88 @ =0x02346F40
	add r0, r4, #0x44
	str ip, [sp, #4]
	bl FUN_02008330
	add r0, r4, #0x44
	bl FUN_020080E8
	ldr r1, _0200DC8C @ =0x02309B44
	mov r0, #0xb
	bl FUN_0200A5CC
	ldr r0, _0200DC78 @ =0x027FFC40
	ldrh r0, [r0]
	cmp r0, #2
	addeq sp, sp, #8
	popeq {r4, lr}
	bxeq lr
	mov r0, #1
	bl FUN_0200DB44
	add sp, sp, #8
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200DC70: .4byte 0x02346920
_0200DC74: .4byte 0x023468C0
_0200DC78: .4byte 0x027FFC40
_0200DC7C: .4byte 0x027FFE00
_0200DC80: .4byte 0x027FFA80
_0200DC84: .4byte 0x02309AE8
_0200DC88: .4byte 0x02346F40
_0200DC8C: .4byte 0x02309B44
	arm_func_end FUN_0200DB90

	arm_func_start FUN_0200DC90
FUN_0200DC90: @ 0x0200DC90
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	ldr r5, _0200DD30 @ =0x02346920
	mov r7, r0
	mov r6, r1
	bl FUN_02009A90
	mov r1, r5
	mov r4, r0
	ldr r0, [r1, #8]
	cmp r0, r7
	bne _0200DCC8
	ldr r0, [r5, #0xc]
	cmp r0, #0
	bne _0200DCD0
_0200DCC8:
	bl FUN_02009D48
	b _0200DD10
_0200DCD0:
	ldr r0, [r5, #0x18]
	cmp r0, r6
	beq _0200DCE0
	bl FUN_02009D48
_0200DCE0:
	ldr r0, [r5, #0xc]
	sub r0, r0, #1
	str r0, [r5, #0xc]
	ldr r0, [r5, #0xc]
	cmp r0, #0
	bne _0200DD10
	mvn r0, #2
	str r0, [r5, #8]
	mov r1, #0
	add r0, r5, #0x10
	str r1, [r5, #0x18]
	bl FUN_0200811C
_0200DD10:
	ldr r1, [r5]
	mov r2, #0
	mov r0, r4
	str r2, [r1]
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200DD30: .4byte 0x02346920
	arm_func_end FUN_0200DC90

	arm_func_start FUN_0200DD34
FUN_0200DD34: @ 0x0200DD34
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	ldr r5, _0200DDCC @ =0x02346920
	mov r7, r0
	mov r6, r1
	bl FUN_02009A90
	ldr r1, [r5, #8]
	mov r4, r0
	cmp r1, r7
	bne _0200DD70
	ldr r0, [r5, #0x18]
	cmp r0, r6
	beq _0200DDA0
	bl FUN_02009D48
	b _0200DDA0
_0200DD70:
	ldr r0, [r5, #8]
	mvn r8, #2
	cmp r0, r8
	beq _0200DD98
	add sb, r5, #0x10
_0200DD84:
	mov r0, sb
	bl FUN_0200819C
	ldr r0, [r5, #8]
	cmp r0, r8
	bne _0200DD84
_0200DD98:
	str r7, [r5, #8]
	str r6, [r5, #0x18]
_0200DDA0:
	ldr r1, [r5, #0xc]
	mov r0, r4
	add r1, r1, #1
	str r1, [r5, #0xc]
	ldr r1, [r5]
	mov r2, #0
	str r2, [r1]
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	.align 2, 0
_0200DDCC: .4byte 0x02346920
	arm_func_end FUN_0200DD34

	arm_func_start FUN_0200DDD0
FUN_0200DDD0: @ 0x0200DDD0
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r4, _0200DE14 @ =0x02346920
	mov r5, r0
	ldr r1, [r4, #0x108]
	add r0, r4, #0x44
	bl FUN_02007FE8
	add r0, r4, #0x44
	str r0, [r4, #0x104]
	str r5, [r4, #0x40]
	ldr r1, [r4, #0x114]
	orr r1, r1, #8
	str r1, [r4, #0x114]
	bl FUN_020080E8
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200DE14: .4byte 0x02346920
	arm_func_end FUN_0200DDD0

	arm_func_start FUN_0200DE18
FUN_0200DE18: @ 0x0200DE18
	ldr r0, _0200DE20 @ =0x02309604
	bx lr
	.align 2, 0
_0200DE20: .4byte 0x02309604
	arm_func_end FUN_0200DE18

	arm_func_start FUN_0200DE24
FUN_0200DE24: @ 0x0200DE24
	ldr ip, _0200DE2C @ =FUN_02308F28
	bx ip
	.align 2, 0
_0200DE2C: .4byte FUN_02308F28
	arm_func_end FUN_0200DE24

	arm_func_start FUN_0200DE30
FUN_0200DE30: @ 0x0200DE30
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr ip, _0200DEA8 @ =0x02346920
	ldr r0, [ip, #0x114]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	mov r0, #1
	str r0, [ip, #0x114]
	mov r3, #0
	str r3, [ip, #0x24]
	ldr r0, [ip, #0x24]
	mvn r1, #0
	str r0, [ip, #0x20]
	ldr r2, [ip, #0x20]
	ldr r0, _0200DEAC @ =0x02346F40
	str r2, [ip, #0x1c]
	str r1, [ip, #0x28]
	str r3, [ip, #0x38]
	str r3, [ip, #0x3c]
	str r3, [r0]
	bl FUN_0200DB90
	bl FUN_0200DE18
	ldr r1, _0200DEB0 @ =0x02346F60
	str r0, [r1]
	bl FUN_0200E95C
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200DEA8: .4byte 0x02346920
_0200DEAC: .4byte 0x02346F40
_0200DEB0: .4byte 0x02346F60
	arm_func_end FUN_0200DE30

	arm_func_start FUN_0200DEB4
FUN_0200DEB4: @ 0x0200DEB4
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	ldr r6, _0200DFC8 @ =0x02346920
	mov sl, r0
	mov sb, r1
	mov r8, r2
	mov r7, r3
	ldr fp, _0200DFCC @ =0x02346F60
	bl FUN_0200DB54
	bl FUN_02009A90
	ldr r1, [r6, #0x114]
	mov r5, r0
	ands r0, r1, #4
	beq _0200DF04
	add r4, r6, #0x10c
_0200DEF0:
	mov r0, r4
	bl FUN_0200819C
	ldr r0, [r6, #0x114]
	ands r0, r0, #4
	bne _0200DEF0
_0200DF04:
	ldr r1, [r6, #0x114]
	ldr r0, [sp, #0x28]
	orr r1, r1, #4
	str r1, [r6, #0x114]
	ldr r1, [sp, #0x2c]
	str r0, [r6, #0x38]
	mov r0, r5
	str r1, [r6, #0x3c]
	bl FUN_02009AA4
	ldr r0, _0200DFD0 @ =0x02346F40
	str sl, [r6, #0x28]
	ldr r0, [r0]
	cmp sl, #3
	add r0, sb, r0
	str r0, [r6, #0x1c]
	str r8, [r6, #0x20]
	str r7, [r6, #0x24]
	bhi _0200DF54
	mov r0, sl
	bl FUN_02009E90
_0200DF54:
	mov r0, fp
	bl FUN_0200E2C4
	cmp r0, #0
	beq _0200DF88
	ldr r0, [sp, #0x30]
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxne lr
	bl FUN_0200DE24
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0200DF88:
	ldr r0, [sp, #0x30]
	cmp r0, #0
	beq _0200DFA8
	ldr r0, _0200DFD4 @ =0x0230941C
	bl FUN_0200DDD0
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0200DFA8:
	ldr r1, _0200DFD8 @ =0x023463B4
	mov r0, r6
	ldr r1, [r1, #4]
	str r1, [r6, #0x104]
	bl FUN_0200DFDC
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0200DFC8: .4byte 0x02346920
_0200DFCC: .4byte 0x02346F60
_0200DFD0: .4byte 0x02346F40
_0200DFD4: .4byte 0x0230941C
_0200DFD8: .4byte 0x023463B4
	arm_func_end FUN_0200DEB4

	arm_func_start FUN_0200DFDC
FUN_0200DFDC: @ 0x0200DFDC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	ldr r4, _0200E080 @ =0x02346F60
	mov r0, r4
	bl FUN_0200E610
	cmp r0, #0
	beq _0200E004
	ldr r1, [r4]
	mov r0, r4
	.word 0xE12FFF31
_0200E004:
	ldr r7, _0200E084 @ =0x02346920
	bl FUN_0200E15C
	bl FUN_0200E7D4
	ldr r0, [r7]
	mov r1, #0
	str r1, [r0]
	ldr r6, [r7, #0x38]
	ldr r5, [r7, #0x3c]
	bl FUN_02009A90
	ldr r1, [r7, #0x114]
	mov r4, r0
	bic r0, r1, #0x4c
	str r0, [r7, #0x114]
	add r0, r7, #0x10c
	bl FUN_0200811C
	ldr r0, [r7, #0x114]
	ands r0, r0, #0x10
	beq _0200E054
	add r0, r7, #0x44
	bl FUN_020080E8
_0200E054:
	mov r0, r4
	bl FUN_02009AA4
	cmp r6, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, r5
	.word 0xE12FFF36
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200E080: .4byte 0x02346F60
_0200E084: .4byte 0x02346920
	arm_func_end FUN_0200DFDC

	arm_func_start FUN_0200E088
FUN_0200E088: @ 0x0200E088
	push {r4, r5, r6, r7, r8, lr}
	ldr r5, _0200E158 @ =0x02346920
	bl FUN_02009A90
	ldr r1, [r5, #0x114]
	mov r4, r0
	ands r0, r1, #4
	beq _0200E0BC
	add r6, r5, #0x10c
_0200E0A8:
	mov r0, r6
	bl FUN_0200819C
	ldr r0, [r5, #0x114]
	ands r0, r0, #4
	bne _0200E0A8
_0200E0BC:
	ldr r0, [r5, #0x114]
	mov r1, #0
	orr r0, r0, #4
	str r0, [r5, #0x114]
	str r1, [r5, #0x38]
	mov r0, r4
	str r1, [r5, #0x3c]
	bl FUN_02009AA4
	bl FUN_0200E15C
	ldr r7, _0200E158 @ =0x02346920
	mov r8, r0
	bl FUN_0200E15C
	bl FUN_0200E7D4
	ldr r0, [r7]
	mov r1, #0
	str r1, [r0]
	ldr r6, [r7, #0x38]
	ldr r5, [r7, #0x3c]
	bl FUN_02009A90
	ldr r1, [r7, #0x114]
	mov r4, r0
	bic r0, r1, #0x4c
	str r0, [r7, #0x114]
	add r0, r7, #0x10c
	bl FUN_0200811C
	ldr r0, [r7, #0x114]
	ands r0, r0, #0x10
	beq _0200E134
	add r0, r7, #0x44
	bl FUN_020080E8
_0200E134:
	mov r0, r4
	bl FUN_02009AA4
	cmp r6, #0
	beq _0200E14C
	mov r0, r5
	.word 0xE12FFF36
_0200E14C:
	mov r0, r8
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200E158: .4byte 0x02346920
	arm_func_end FUN_0200E088

	arm_func_start FUN_0200E15C
FUN_0200E15C: @ 0x0200E15C
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #0xb8000000
	mov r1, #0
	bl FUN_0200E570
	ldr r1, _0200E1B8 @ =0x0231CF38
	mov r0, #0x2000
	ldr r1, [r1]
	rsb r0, r0, #0
	ldr r2, [r1, #0x60]
	ldr r1, _0200E1BC @ =0x040001A4
	bic r2, r2, #0x7000000
	orr r2, r2, #0xa7000000
	and r0, r2, r0
	str r0, [r1]
_0200E198:
	ldr r0, [r1]
	ands r0, r0, #0x800000
	beq _0200E198
	ldr r0, _0200E1C0 @ =0x04100010
	ldr r0, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200E1B8: .4byte 0x0231CF38
_0200E1BC: .4byte 0x040001A4
_0200E1C0: .4byte 0x04100010
	arm_func_end FUN_0200E15C

	arm_func_start FUN_0200E1C4
FUN_0200E1C4: @ 0x0200E1C4
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	mov sl, r0
	ldr sb, _0200E2B8 @ =0x02346920
	add r7, sl, #0x20
	ldr r5, _0200E2BC @ =0x04100010
	ldr r6, _0200E2C0 @ =0x040001A4
	mov fp, #0
	mov r0, #0x200
	rsb r4, r0, #0
_0200E1EC:
	ldr r0, [sb, #0x1c]
	and r1, r0, r4
	cmp r1, r0
	bne _0200E214
	ldr r8, [sb, #0x20]
	ands r0, r8, #3
	bne _0200E214
	ldr r0, [sb, #0x24]
	cmp r0, #0x200
	bhs _0200E21C
_0200E214:
	mov r8, r7
	str r1, [sl, #8]
_0200E21C:
	lsr r0, r1, #8
	orr r0, r0, #0xb7000000
	lsl r1, r1, #0x18
	bl FUN_0200E570
	ldr r1, [sl, #4]
	mov r0, fp
	str r1, [r6]
_0200E238:
	ldr r2, [r6]
	ands r1, r2, #0x800000
	beq _0200E254
	ldr r1, [r5]
	cmp r0, #0x200
	strlo r1, [r8, r0, lsl #2]
	addlo r0, r0, #1
_0200E254:
	ands r1, r2, #0x80000000
	bne _0200E238
	ldr r0, [sb, #0x20]
	cmp r8, r0
	bne _0200E29C
	ldr r2, [sb, #0x1c]
	ldr r1, [sb, #0x20]
	ldr r0, [sb, #0x24]
	add r2, r2, #0x200
	add r1, r1, #0x200
	subs r0, r0, #0x200
	str r2, [sb, #0x1c]
	str r1, [sb, #0x20]
	str r0, [sb, #0x24]
	bne _0200E1EC
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0200E29C:
	mov r0, sl
	bl FUN_0200E610
	cmp r0, #0
	bne _0200E1EC
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0200E2B8: .4byte 0x02346920
_0200E2BC: .4byte 0x04100010
_0200E2C0: .4byte 0x040001A4
	arm_func_end FUN_0200E1C4

	arm_func_start FUN_0200E2C4
FUN_0200E2C4: @ 0x0200E2C4
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	ldr fp, _0200E424 @ =0x02346920
	mov r7, #0
	ldr sb, [fp, #0x20]
	mov sl, r0
	mov r6, r7
	mov r5, r7
	mov r1, r7
	ands r4, sb, #0x1f
	ldr r8, [fp, #0x24]
	bne _0200E300
	ldr r0, [fp, #0x28]
	cmp r0, #3
	movls r1, #1
_0200E300:
	cmp r1, #0
	beq _0200E354
	bl FUN_02009578
	ldr r1, _0200E428 @ =0x01FF8000
	add r2, sb, r8
	cmp r2, r1
	mov r3, #1
	mov r1, #0
	bls _0200E32C
	cmp sb, #0x2000000
	movlo r1, r3
_0200E32C:
	cmp r1, #0
	bne _0200E34C
	cmp r0, r2
	bhs _0200E348
	add r0, r0, #0x4000
	cmp r0, sb
	bhi _0200E34C
_0200E348:
	mov r3, #0
_0200E34C:
	cmp r3, #0
	moveq r5, #1
_0200E354:
	cmp r5, #0
	beq _0200E370
	ldr r1, [fp, #0x1c]
	ldr r0, _0200E42C @ =0x000001FF
	orr r1, r1, r8
	ands r0, r1, r0
	moveq r6, #1
_0200E370:
	cmp r6, #0
	beq _0200E380
	cmp r8, #0
	movne r7, #1
_0200E380:
	ldr r0, _0200E430 @ =0x0231CF38
	cmp r7, #0
	ldr r0, [r0]
	ldr r0, [r0, #0x60]
	bic r0, r0, #0x7000000
	orr r0, r0, #0xa1000000
	str r0, [sl, #4]
	beq _0200E414
	bl FUN_02009A90
	mov r5, r0
	mov r0, sb
	mov r1, r8
	bl FUN_02008CC4
	cmp r4, #0
	beq _0200E3DC
	sub sb, sb, r4
	mov r0, sb
	mov r1, #0x20
	bl FUN_02008C78
	add r0, sb, r8
	mov r1, #0x20
	bl FUN_02008C78
	add r8, r8, #0x20
_0200E3DC:
	mov r0, sb
	mov r1, r8
	bl FUN_02008C5C
	bl FUN_02008CB8
	ldr r1, _0200E434 @ =0x02309878
	mov r0, #0x80000
	bl FUN_02007AC0
	mov r0, #0x80000
	bl FUN_0200798C
	mov r0, #0x80000
	bl FUN_02007A08
	mov r0, r5
	bl FUN_02009AA4
	bl FUN_0200E518
_0200E414:
	mov r0, r7
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0200E424: .4byte 0x02346920
_0200E428: .4byte 0x01FF8000
_0200E42C: .4byte 0x000001FF
_0200E430: .4byte 0x0231CF38
_0200E434: .4byte 0x02309878
	arm_func_end FUN_0200E2C4

	arm_func_start FUN_0200E438
FUN_0200E438: @ 0x0200E438
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	ldr r0, _0200E514 @ =0x02346920
	ldr r0, [r0, #0x28]
	bl FUN_02009E90
	ldr r0, _0200E514 @ =0x02346920
	ldr r3, [r0, #0x1c]
	ldr r2, [r0, #0x20]
	ldr r1, [r0, #0x24]
	add r3, r3, #0x200
	add r2, r2, #0x200
	subs r1, r1, #0x200
	str r3, [r0, #0x1c]
	str r2, [r0, #0x20]
	str r1, [r0, #0x24]
	bne _0200E504
	mov r0, #0x80000
	bl FUN_020079C0
	mov r0, #0x80000
	bl FUN_0200798C
	ldr r7, _0200E514 @ =0x02346920
	bl FUN_0200E15C
	bl FUN_0200E7D4
	ldr r0, [r7]
	mov r1, #0
	str r1, [r0]
	ldr r6, [r7, #0x38]
	ldr r5, [r7, #0x3c]
	bl FUN_02009A90
	ldr r1, [r7, #0x114]
	mov r4, r0
	bic r0, r1, #0x4c
	str r0, [r7, #0x114]
	add r0, r7, #0x10c
	bl FUN_0200811C
	ldr r0, [r7, #0x114]
	ands r0, r0, #0x10
	beq _0200E4D8
	add r0, r7, #0x44
	bl FUN_020080E8
_0200E4D8:
	mov r0, r4
	bl FUN_02009AA4
	cmp r6, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, r5
	.word 0xE12FFF36
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
_0200E504:
	bl FUN_0200E518
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0200E514: .4byte 0x02346920
	arm_func_end FUN_0200E438

	arm_func_start FUN_0200E518
FUN_0200E518: @ 0x0200E518
	push {r4, lr}
	ldr r4, _0200E560 @ =0x02346920
	ldr r1, _0200E564 @ =0x04100010
	ldr r0, [r4, #0x28]
	ldr r2, [r4, #0x20]
	mov r3, #0x200
	bl FUN_0200A310
	ldr r1, [r4, #0x1c]
	lsr r0, r1, #8
	orr r0, r0, #0xb7000000
	lsl r1, r1, #0x18
	bl FUN_0200E570
	ldr r0, _0200E568 @ =0x02346F60
	ldr r1, _0200E56C @ =0x040001A4
	ldr r0, [r0, #4]
	str r0, [r1]
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200E560: .4byte 0x02346920
_0200E564: .4byte 0x04100010
_0200E568: .4byte 0x02346F60
_0200E56C: .4byte 0x040001A4
	arm_func_end FUN_0200E518

	arm_func_start FUN_0200E570
FUN_0200E570: @ 0x0200E570
	ldr r3, _0200E5E8 @ =0x040001A4
_0200E574:
	ldr r2, [r3]
	ands r2, r2, #0x80000000
	bne _0200E574
	ldr r3, _0200E5EC @ =0x040001A1
	mov ip, #0xc0
	ldr r2, _0200E5F0 @ =0x040001A8
	strb ip, [r3]
	lsr ip, r0, #0x18
	ldr r3, _0200E5F4 @ =0x040001A9
	strb ip, [r2]
	lsr ip, r0, #0x10
	ldr r2, _0200E5F8 @ =0x040001AA
	strb ip, [r3]
	lsr ip, r0, #8
	ldr r3, _0200E5FC @ =0x040001AB
	strb ip, [r2]
	ldr r2, _0200E600 @ =0x040001AC
	strb r0, [r3]
	lsr r3, r1, #0x18
	ldr r0, _0200E604 @ =0x040001AD
	strb r3, [r2]
	lsr r3, r1, #0x10
	ldr r2, _0200E608 @ =0x040001AE
	strb r3, [r0]
	lsr r3, r1, #8
	ldr r0, _0200E60C @ =0x040001AF
	strb r3, [r2]
	strb r1, [r0]
	bx lr
	.align 2, 0
_0200E5E8: .4byte 0x040001A4
_0200E5EC: .4byte 0x040001A1
_0200E5F0: .4byte 0x040001A8
_0200E5F4: .4byte 0x040001A9
_0200E5F8: .4byte 0x040001AA
_0200E5FC: .4byte 0x040001AB
_0200E600: .4byte 0x040001AC
_0200E604: .4byte 0x040001AD
_0200E608: .4byte 0x040001AE
_0200E60C: .4byte 0x040001AF
	arm_func_end FUN_0200E570

	arm_func_start FUN_0200E610
FUN_0200E610: @ 0x0200E610
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r5, _0200E6A4 @ =0x02346920
	mov r1, #0x200
	ldr r3, [r5, #0x1c]
	rsb r1, r1, #0
	ldr r2, [r0, #8]
	and r3, r3, r1
	cmp r3, r2
	bne _0200E688
	ldr r2, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	sub r3, r2, r3
	rsb r4, r3, #0x200
	cmp r4, r1
	movhi r4, r1
	add r0, r0, #0x20
	ldr r1, [r5, #0x20]
	mov r2, r4
	add r0, r0, r3
	bl FUN_0200A1D8
	ldr r0, [r5, #0x1c]
	add r0, r0, r4
	str r0, [r5, #0x1c]
	ldr r0, [r5, #0x20]
	add r0, r0, r4
	str r0, [r5, #0x20]
	ldr r0, [r5, #0x24]
	sub r0, r0, r4
	str r0, [r5, #0x24]
_0200E688:
	ldr r0, [r5, #0x24]
	cmp r0, #0
	movne r0, #1
	moveq r0, #0
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200E6A4: .4byte 0x02346920
	arm_func_end FUN_0200E610

	arm_func_start FUN_0200E6A8
FUN_0200E6A8: @ 0x0200E6A8
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	ldr r5, _0200E700 @ =0x02346920
	mov r6, #0
	add r7, r5, #0x44
_0200E6BC:
	bl FUN_02009A90
	ldr r1, [r5, #0x114]
	mov r4, r0
	ands r0, r1, #8
	bne _0200E6E8
_0200E6D0:
	mov r0, r6
	str r7, [r5, #0x104]
	bl FUN_0200819C
	ldr r0, [r5, #0x114]
	ands r0, r0, #8
	beq _0200E6D0
_0200E6E8:
	mov r0, r4
	bl FUN_02009AA4
	ldr r1, [r5, #0x40]
	mov r0, r5
	.word 0xE12FFF31
	b _0200E6BC
	.align 2, 0
_0200E700: .4byte 0x02346920
	arm_func_end FUN_0200E6A8

	arm_func_start FUN_0200E704
FUN_0200E704: @ 0x0200E704
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r0, #0xb
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	cmp r2, #0
	addeq sp, sp, #4
	ldmeq sp!, {lr}
	bxeq lr
	ldr r1, _0200E750 @ =0x02346920
	ldr r0, [r1, #0x114]
	bic r0, r0, #0x20
	str r0, [r1, #0x114]
	ldr r0, [r1, #0x104]
	bl FUN_020080E8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200E750: .4byte 0x02346920
	arm_func_end FUN_0200E704

	arm_func_start FUN_0200E754
FUN_0200E754: @ 0x0200E754
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r6, r1
	mov r1, r7
	mov r0, #0xe
	mov r2, #0
	bl FUN_0200A4F0
	cmp r0, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r5, #0xe
	mov r4, #0
_0200E78C:
	mov r0, r6
	blx SVC_WaitByLoop
	mov r0, r5
	mov r1, r7
	mov r2, r4
	bl FUN_0200A4F0
	cmp r0, #0
	bne _0200E78C
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200E754

	arm_func_start FUN_0200E7B8
FUN_0200E7B8: @ 0x0200E7B8
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200E088
	bl FUN_0200E7D4
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_0200E7B8

	arm_func_start FUN_0200E7D4
FUN_0200E7D4: @ 0x0200E7D4
	push {r4, lr}
	sub sp, sp, #8
	ldr r1, _0200E838 @ =0x027FFC10
	ldrh r1, [r1]
	cmp r1, #0
	ldreq r1, _0200E83C @ =0x027FF800
	ldrne r1, _0200E840 @ =0x027FFC00
	ldr r1, [r1]
	str r1, [sp]
	ldr r1, [sp]
	cmp r0, r1
	addeq sp, sp, #8
	popeq {r4, lr}
	bxeq lr
	bl FUN_02009A90
	mov r4, r0
	mov r0, #0xe
	mov r1, #0x11
	mov r2, #0
	bl FUN_0200E8DC
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #8
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200E838: .4byte 0x027FFC10
_0200E83C: .4byte 0x027FF800
_0200E840: .4byte 0x027FFC00
	arm_func_end FUN_0200E7D4

	arm_func_start FUN_0200E844
FUN_0200E844: @ 0x0200E844
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r0, _0200E8B4 @ =0x027FFFA8
	mov r5, #1
	ldrh r0, [r0]
	and r0, r0, #0x8000
	asrs r0, r0, #0xf
	beq _0200E890
	bl FUN_0200CB2C
	cmp r0, #4
	bne _0200E888
	ldr r4, _0200E8B8 @ =0x000A3A47
_0200E874:
	mov r0, r4
	bl _02009B00
	bl FUN_0200CB2C
	cmp r0, #4
	beq _0200E874
_0200E888:
	cmp r0, #0
	moveq r5, #0
_0200E890:
	cmp r5, #0
	beq _0200E8A4
	mov r0, #1
	mov r1, r0
	bl FUN_0200E754
_0200E8A4:
	bl FUN_02009D48
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_0200E8B4: .4byte 0x027FFFA8
_0200E8B8: .4byte 0x000A3A47
	arm_func_end FUN_0200E844

	arm_func_start FUN_0200E8BC
FUN_0200E8BC: @ 0x0200E8BC
	ldr r0, _0200E8C8 @ =0x02347180
	ldr r0, [r0]
	bx lr
	.align 2, 0
_0200E8C8: .4byte 0x02347180
	arm_func_end FUN_0200E8BC

	arm_func_start FUN_0200E8CC
FUN_0200E8CC: @ 0x0200E8CC
	ldr r1, _0200E8D8 @ =0x02347184
	str r0, [r1]
	bx lr
	.align 2, 0
_0200E8D8: .4byte 0x02347184
	arm_func_end FUN_0200E8CC

	arm_func_start FUN_0200E8DC
FUN_0200E8DC: @ 0x0200E8DC
	stmdb sp!, {lr}
	sub sp, sp, #4
	and r0, r1, #0x3f
	cmp r0, #0x11
	bne _0200E944
	ldr r2, _0200E954 @ =0x02347180
	ldr r0, [r2]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	ldr r1, _0200E958 @ =0x02347184
	mov r0, #1
	ldr r1, [r1]
	str r0, [r2]
	cmp r1, #0
	beq _0200E924
	.word 0xE12FFF31
_0200E924:
	cmp r0, #0
	addeq sp, sp, #4
	ldmeq sp!, {lr}
	bxeq lr
	bl FUN_0200E844
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
_0200E944:
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200E954: .4byte 0x02347180
_0200E958: .4byte 0x02347184
	arm_func_end FUN_0200E8DC

	arm_func_start FUN_0200E95C
FUN_0200E95C: @ 0x0200E95C
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200A3C0
	ldr r1, _0200E98C @ =0x02309D1C
	mov r0, #0xe
	bl FUN_0200A5CC
	ldr r0, _0200E990 @ =0x02347184
	mov r1, #0
	str r1, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200E98C: .4byte 0x02309D1C
_0200E990: .4byte 0x02347184
	arm_func_end FUN_0200E95C

	arm_func_start FUN_0200E994
FUN_0200E994: @ 0x0200E994
	push {r4, lr}
	bl FUN_02009A90
	ldr r1, _0200E9C4 @ =0x0234718C
	ldr r1, [r1]
	cmp r1, #0
	ldrne r4, [r1, #0x14c]
	moveq r4, #0
	bl FUN_02009AA4
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200E9C4: .4byte 0x0234718C
	arm_func_end FUN_0200E994

	arm_func_start FUN_0200E9C8
FUN_0200E9C8: @ 0x0200E9C8
	push {r4, lr}
	bl FUN_02009A90
	ldr r1, _0200E9F8 @ =0x0234718C
	ldr r1, [r1]
	cmp r1, #0
	addne r1, r1, #0x100
	ldrhne r4, [r1, #0x50]
	moveq r4, #0
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200E9F8: .4byte 0x0234718C
	arm_func_end FUN_0200E9C8

	arm_func_start FUN_0200E9FC
FUN_0200E9FC: @ 0x0200E9FC
	ldr r1, _0200EA14 @ =0x027FFF96
	ldrh r0, [r1]
	ands r2, r0, #1
	bicne r0, r0, #1
	strhne r0, [r1]
	bx lr
	.align 2, 0
_0200EA14: .4byte 0x027FFF96
	arm_func_end FUN_0200E9FC

	arm_func_start FUN_0200EA18
FUN_0200EA18: @ 0x0200EA18
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xc
	ldr r0, _0200EDE0 @ =0x0234718C
	cmp r2, #0
	ldr r8, [r0]
	mov sl, r1
	addne sp, sp, #0xc
	popne {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxne lr
	ldr r0, [r8, #0x10]
	mov r1, #0x100
	bl FUN_02008C5C
	ldrh r0, [r8, #0x16]
	cmp r0, #0
	bne _0200EA60
	ldr r0, [r8, #4]
	mov r1, #0x800
	bl FUN_02008C5C
_0200EA60:
	ldr r0, [r8, #0x10]
	cmp sl, r0
	beq _0200EA78
	mov r0, sl
	mov r1, #0x100
	bl FUN_02008C5C
_0200EA78:
	ldrh r0, [sl]
	cmp r0, #0x2c
	blo _0200EB30
	cmp r0, #0x80
	bne _0200EAB4
	ldrh r0, [sl, #2]
	cmp r0, #0x13
	bne _0200EA9C
	bl FUN_02009D48
_0200EA9C:
	ldr r1, [r8, #0xc8]
	cmp r1, #0
	beq _0200ED98
	mov r0, sl
	.word 0xE12FFF31
	b _0200ED98
_0200EAB4:
	cmp r0, #0x82
	bne _0200EB08
	ldrh r0, [sl, #6]
	add r1, r8, r0, lsl #2
	ldr r0, [r1, #0xcc]
	cmp r0, #0
	beq _0200ED98
	ldr r0, [r1, #0x10c]
	str r0, [sl, #0x1c]
	ldr r0, [r8, #0x14c]
	strh r0, [sl, #0x22]
	ldr r1, [r8, #4]
	ldr r0, [sl, #8]
	ldrh r1, [r1, #0x72]
	bl FUN_02008C5C
	ldrh r1, [sl, #6]
	mov r0, sl
	add r1, r8, r1, lsl #2
	ldr r1, [r1, #0xcc]
	.word 0xE12FFF31
	b _0200ED98
_0200EB08:
	cmp r0, #0x81
	bne _0200ED98
	mov r0, #0xf
	strh r0, [sl]
	ldr r1, [sl, #0x1c]
	cmp r1, #0
	beq _0200ED98
	mov r0, sl
	.word 0xE12FFF31
	b _0200ED98
_0200EB30:
	cmp r0, #0xe
	bne _0200EB70
	ldrh r1, [sl, #4]
	ldr r0, _0200EDE4 @ =0x0000FFF5
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r0, #1
	bhi _0200EB70
	ldrh r0, [sl, #2]
	cmp r0, #0
	bne _0200EB70
	ldr r1, [r8, #4]
	ldr r0, [sl, #8]
	ldrh r1, [r1, #0x72]
	bl FUN_02008C5C
_0200EB70:
	ldrh r1, [sl]
	cmp r1, #2
	bne _0200EBB8
	ldrh r0, [sl, #2]
	cmp r0, #0
	bne _0200EBB8
	add r0, r8, r1, lsl #2
	ldr r4, [r0, #0x18]
	bl FUN_0200F0E8
	cmp r4, #0
	addeq sp, sp, #0xc
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	mov r0, sl
	.word 0xE12FFF34
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0200EBB8:
	add r0, r8, r1, lsl #2
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq _0200EBE8
	mov r0, sl
	.word 0xE12FFF31
	ldr r0, _0200EDE8 @ =0x02347188
	ldrh r0, [r0]
	cmp r0, #0
	addeq sp, sp, #0xc
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
_0200EBE8:
	ldrh r0, [sl]
	cmp r0, #8
	beq _0200EBFC
	cmp r0, #0xc
	bne _0200ED98
_0200EBFC:
	cmp r0, #8
	bne _0200EC30
	add r0, sl, #0xa
	str r0, [sp]
	ldrh r0, [sl, #0x2c]
	add fp, sl, #0x14
	ldrh r7, [sl, #8]
	ldrh r6, [sl, #0x10]
	ldrh r4, [sl, #0x12]
	str r0, [sp, #4]
	ldrh sb, [sl, #0x2e]
	mov r5, #0
	b _0200EC60
_0200EC30:
	cmp r0, #0xc
	bne _0200EC60
	ldrh r0, [sl, #0x16]
	mov r6, #0
	ldrh r7, [sl, #8]
	str r0, [sp, #4]
	add r0, sl, #0x10
	ldrh r5, [sl, #0xa]
	ldrh r4, [sl, #0xc]
	ldrh sb, [sl, #0x18]
	mov fp, r6
	str r0, [sp]
_0200EC60:
	cmp r7, #7
	beq _0200EC78
	cmp r7, #9
	beq _0200EC78
	cmp r7, #0x1a
	bne _0200ED98
_0200EC78:
	cmp r7, #7
	ldreq r1, [r8, #0x14c]
	moveq r0, #1
	orreq r0, r1, r0, lsl r6
	streq r0, [r8, #0x14c]
	movne r0, #1
	mvnne r0, r0, lsl r6
	ldrne r1, [r8, #0x14c]
	add r3, r8, #0x100
	andne r0, r1, r0
	strne r0, [r8, #0x14c]
	ldr r0, _0200EDEC @ =0x023471D8
	mov r1, #0
	mov r2, #0x44
	strh r5, [r3, #0x50]
	bl FUN_0200A144
	ldr r3, _0200EDEC @ =0x023471D8
	mov r1, #0
	mov r2, #0x82
	strh r2, [r3]
	strh r7, [r3, #4]
	strh r6, [r3, #0x12]
	strh r5, [r3, #0x20]
	strh r1, [r3, #2]
	str r1, [r3, #8]
	str r1, [r3, #0xc]
	strh r1, [r3, #0x10]
	ldr r1, [r8, #0x14c]
	ldr r2, _0200EDF0 @ =0x0000FFFF
	strh r1, [r3, #0x22]
	strh r2, [r3, #0x1a]
	ldr r0, [sp]
	ldr r1, _0200EDF4 @ =0x023471EC
	mov r2, #6
	strh r4, [r3, #0x3c]
	bl FUN_0200A1D8
	cmp fp, #0
	beq _0200ED24
	ldr r1, _0200EDF8 @ =0x023471FC
	mov r0, fp
	mov r2, #0x18
	bl FUN_0200A0B0
	b _0200ED34
_0200ED24:
	ldr r1, _0200EDF8 @ =0x023471FC
	mov r0, #0
	mov r2, #0x18
	bl FUN_0200A098
_0200ED34:
	cmp r5, #0
	ldreq r1, [sp, #4]
	ldr r0, _0200EDEC @ =0x023471D8
	movne r1, sb
	cmp r5, #0
	ldrne sb, [sp, #4]
	ldr r5, _0200EDEC @ =0x023471D8
	strh r1, [r0, #0x40]
	mov r4, #0
	strh sb, [r5, #0x42]
_0200ED5C:
	strh r4, [r5, #6]
	add r2, r8, r4, lsl #2
	ldr r0, [r2, #0xcc]
	cmp r0, #0
	beq _0200ED84
	ldr r1, [r2, #0x10c]
	mov r0, r5
	str r1, [r5, #0x1c]
	ldr r1, [r2, #0xcc]
	.word 0xE12FFF31
_0200ED84:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x10
	blo _0200ED5C
_0200ED98:
	ldr r0, [r8, #0x10]
	mov r1, #0x100
	bl FUN_02008C5C
	bl FUN_0200E9FC
	ldr r0, [r8, #0x10]
	cmp sl, r0
	addeq sp, sp, #0xc
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldrh r2, [sl]
	mov r0, sl
	mov r1, #0x100
	orr r2, r2, #0x8000
	strh r2, [sl]
	bl FUN_02008C78
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0200EDE0: .4byte 0x0234718C
_0200EDE4: .4byte 0x0000FFF5
_0200EDE8: .4byte 0x02347188
_0200EDEC: .4byte 0x023471D8
_0200EDF0: .4byte 0x0000FFFF
_0200EDF4: .4byte 0x023471EC
_0200EDF8: .4byte 0x023471FC
	arm_func_end FUN_0200EA18

	arm_func_start FUN_0200EDFC
FUN_0200EDFC: @ 0x0200EDFC
	push {r0, r1, r2, r3}
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200EF00
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	addne sp, sp, #0x10
	bxne lr
	ldr r0, _0200EEA0 @ =0x0234718C
	mov r1, #2
	ldr r0, [r0]
	ldr r0, [r0, #4]
	bl FUN_02008C5C
	ldr r0, _0200EEA0 @ =0x0234718C
	add r1, sp, #8
	ldr r2, [r0]
	ldr r0, [sp, #8]
	ldr r2, [r2, #4]
	cmp r0, #0
	bic r1, r1, #3
	addeq sp, sp, #4
	add ip, r1, #4
	ldrh r3, [r2]
	mov r0, #3
	ldmeq sp!, {lr}
	addeq sp, sp, #0x10
	bxeq lr
	mov r2, #0
_0200EE70:
	add ip, ip, #4
	ldr r1, [ip, #-4]
	cmp r1, r3
	ldr r1, [sp, #8]
	moveq r0, r2
	subs r1, r1, #1
	str r1, [sp, #8]
	bne _0200EE70
	add sp, sp, #4
	ldm sp!, {lr}
	add sp, sp, #0x10
	bx lr
	.align 2, 0
_0200EEA0: .4byte 0x0234718C
	arm_func_end FUN_0200EDFC

	arm_func_start FUN_0200EEA4
FUN_0200EEA4: @ 0x0200EEA4
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200EF00
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	ldr r0, _0200EEFC @ =0x0234718C
	mov r1, #2
	ldr r0, [r0]
	ldr r0, [r0, #4]
	bl FUN_02008C5C
	ldr r0, _0200EEFC @ =0x0234718C
	ldr r0, [r0]
	ldr r0, [r0, #4]
	ldrh r0, [r0]
	cmp r0, #1
	movls r0, #3
	movhi r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200EEFC: .4byte 0x0234718C
	arm_func_end FUN_0200EEA4

	arm_func_start FUN_0200EF00
FUN_0200EF00: @ 0x0200EF00
	ldr r0, _0200EF18 @ =0x02347188
	ldrh r0, [r0]
	cmp r0, #0
	movne r0, #0
	moveq r0, #3
	bx lr
	.align 2, 0
_0200EF18: .4byte 0x02347188
	arm_func_end FUN_0200EF00

	arm_func_start FUN_0200EF1C
FUN_0200EF1C: @ 0x0200EF1C
	ldr r0, _0200EF28 @ =0x0234718C
	ldr r0, [r0]
	bx lr
	.align 2, 0
_0200EF28: .4byte 0x0234718C
	arm_func_end FUN_0200EF1C

	arm_func_start FUN_0200EF2C
FUN_0200EF2C: @ 0x0200EF2C
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r4, r1
	bl FUN_0200F05C
	movs r5, r0
	moveq r0, #8
	popeq {r4, r5, r6, lr}
	bxeq lr
	mov r0, r6
	mov r1, r5
	mov r2, r4
	bl FUN_0200A1D8
	mov r0, r5
	mov r1, r4
	bl FUN_02008C78
	mov r1, r5
	mov r0, #0xa
	mov r2, #0
	bl FUN_0200A4F0
	mov r4, r0
	ldr r0, _0200EFA0 @ =0x02347190
	mov r1, r5
	mov r2, #1
	bl FUN_02008AEC
	cmp r4, #0
	movlt r0, #8
	movge r0, #2
	pop {r4, r5, r6, lr}
	bx lr
	.align 2, 0
_0200EFA0: .4byte 0x02347190
	arm_func_end FUN_0200EF2C

	arm_func_start FUN_0200EFA4
FUN_0200EFA4: @ 0x0200EFA4
	push {r0, r1, r2, r3}
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r4, r0
	bl FUN_0200F05C
	movs r5, r0
	addeq sp, sp, #4
	moveq r0, #8
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	strh r4, [r5]
	ldrh r2, [sp, #0x14]
	add r0, sp, #0x14
	bic r0, r0, #3
	mov r3, #0
	cmp r2, #0
	add r4, r0, #4
	ble _0200F00C
_0200EFF0:
	add r4, r4, #4
	ldr r1, [r4, #-4]
	add r0, r5, r3, lsl #2
	add r3, r3, #1
	str r1, [r0, #4]
	cmp r3, r2
	blt _0200EFF0
_0200F00C:
	mov r0, r5
	mov r1, #0x100
	bl FUN_02008C78
	mov r1, r5
	mov r0, #0xa
	mov r2, #0
	bl FUN_0200A4F0
	mov r4, r0
	ldr r0, _0200F058 @ =0x02347190
	mov r1, r5
	mov r2, #1
	bl FUN_02008AEC
	cmp r4, #0
	movlt r0, #8
	movge r0, #2
	add sp, sp, #4
	pop {r4, r5, lr}
	add sp, sp, #0x10
	bx lr
	.align 2, 0
_0200F058: .4byte 0x02347190
	arm_func_end FUN_0200EFA4

	arm_func_start FUN_0200F05C
FUN_0200F05C: @ 0x0200F05C
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r0, _0200F0CC @ =0x02347190
	add r1, sp, #0
	mov r2, #0
	bl FUN_02008A40
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	ldmeq sp!, {lr}
	bxeq lr
	ldr r0, [sp]
	mov r1, #2
	bl FUN_02008C5C
	ldr r1, [sp]
	ldrh r0, [r1]
	ands r0, r0, #0x8000
	addne sp, sp, #4
	movne r0, r1
	ldmne sp!, {lr}
	bxne lr
	ldr r0, _0200F0CC @ =0x02347190
	mov r2, #1
	bl FUN_0200898C
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200F0CC: .4byte 0x02347190
	arm_func_end FUN_0200F05C

	arm_func_start FUN_0200F0D0
FUN_0200F0D0: @ 0x0200F0D0
	ldr r2, _0200F0E4 @ =0x0234718C
	ldr r2, [r2]
	add r0, r2, r0, lsl #2
	str r1, [r0, #0x18]
	bx lr
	.align 2, 0
_0200F0E4: .4byte 0x0234718C
	arm_func_end FUN_0200F0D0

	arm_func_start FUN_0200F0E8
FUN_0200F0E8: @ 0x0200F0E8
	push {r4, lr}
	bl FUN_02009A90
	mov r4, r0
	bl FUN_0200EF00
	cmp r0, #0
	beq _0200F114
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #3
	pop {r4, lr}
	bx lr
_0200F114:
	mov r0, #1
	mov r1, #0
	bl FUN_0200EDFC
	cmp r0, #0
	popne {r4, lr}
	bxne lr
	bl FUN_0200E9FC
	mov r0, #0xa
	mov r1, #0
	bl FUN_0200A5CC
	ldr r2, _0200F164 @ =0x0234718C
	mov r3, #0
	ldr r1, _0200F168 @ =0x02347188
	mov r0, r4
	str r3, [r2]
	strh r3, [r1]
	bl FUN_02009AA4
	mov r0, #0
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200F164: .4byte 0x0234718C
_0200F168: .4byte 0x02347188
	arm_func_end FUN_0200F0E8

	arm_func_start FUN_0200F16C
FUN_0200F16C: @ 0x0200F16C
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov r6, r0
	mov r5, r1
	mov r7, r2
	bl FUN_02009A90
	ldr r1, _0200F34C @ =0x02347188
	mov r4, r0
	ldrh r1, [r1]
	cmp r1, #0
	beq _0200F1A4
	bl FUN_02009AA4
	mov r0, #3
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
_0200F1A4:
	cmp r6, #0
	bne _0200F1BC
	bl FUN_02009AA4
	mov r0, #6
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
_0200F1BC:
	cmp r5, #3
	bls _0200F1D4
	bl FUN_02009AA4
	mov r0, #6
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
_0200F1D4:
	ands r1, r6, #0x1f
	beq _0200F1EC
	bl FUN_02009AA4
	mov r0, #6
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
_0200F1EC:
	bl FUN_0200A3C0
	mov r0, #0xa
	mov r1, #1
	bl FUN_0200A5A4
	cmp r0, #0
	bne _0200F218
	mov r0, r4
	bl FUN_02009AA4
	mov r0, #4
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
_0200F218:
	mov r0, r6
	mov r1, r7
	bl FUN_02008C5C
	mov r0, r5
	mov r1, r6
	mov r3, r7
	mov r2, #0
	bl FUN_0200A008
	ldr r0, _0200F350 @ =0x0234718C
	add r1, r6, #0x200
	str r6, [r0]
	str r1, [r6]
	ldr r2, [r0]
	ldr r1, [r2]
	add r1, r1, #0x300
	str r1, [r2, #4]
	ldr r2, [r0]
	ldr r1, [r2, #4]
	add r1, r1, #0x800
	str r1, [r2, #0xc]
	ldr r1, [r0]
	ldr r0, [r1, #0xc]
	add r0, r0, #0x100
	str r0, [r1, #0x10]
	bl FUN_0200E9FC
	ldr r1, _0200F350 @ =0x0234718C
	mov r3, #0
	ldr r0, [r1]
	strh r5, [r0, #0x14]
	ldr r0, [r1]
	str r3, [r0, #0x14c]
	ldr r0, [r1]
	add r0, r0, #0x100
	strh r3, [r0, #0x50]
	mov r2, r3
_0200F2A4:
	ldr r0, [r1]
	add r0, r0, r3, lsl #2
	str r2, [r0, #0xcc]
	ldr r0, [r1]
	add r0, r0, r3, lsl #2
	add r3, r3, #1
	str r2, [r0, #0x10c]
	cmp r3, #0x10
	blt _0200F2A4
	ldr r0, _0200F354 @ =0x02347190
	ldr r1, _0200F358 @ =0x023471B0
	mov r2, #0xa
	bl FUN_02008B94
	ldr sb, _0200F35C @ =0x02347220
	mov sl, #0
	ldr r6, _0200F354 @ =0x02347190
	mov r8, #0x8000
	mov r7, #2
	mov r5, #1
_0200F2F0:
	mov r0, sb
	mov r1, r7
	strh r8, [sb]
	bl FUN_02008C78
	mov r0, r6
	mov r1, sb
	mov r2, r5
	bl FUN_02008AEC
	add sl, sl, #1
	cmp sl, #0xa
	add sb, sb, #0x100
	blt _0200F2F0
	ldr r1, _0200F360 @ =0x02309E58
	mov r0, #0xa
	bl FUN_0200A5CC
	ldr r1, _0200F34C @ =0x02347188
	mov r2, #1
	mov r0, r4
	strh r2, [r1]
	bl FUN_02009AA4
	mov r0, #0
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	.align 2, 0
_0200F34C: .4byte 0x02347188
_0200F350: .4byte 0x0234718C
_0200F354: .4byte 0x02347190
_0200F358: .4byte 0x023471B0
_0200F35C: .4byte 0x02347220
_0200F360: .4byte 0x02309E58
	arm_func_end FUN_0200F16C

	arm_func_start FUN_0200F364
FUN_0200F364: @ 0x0200F364
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r2, #0xf00
	bl FUN_0200F16C
	cmp r0, #0
	ldreq r1, _0200F394 @ =0x0234718C
	moveq r2, #0
	ldreq r1, [r1]
	strheq r2, [r1, #0x16]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200F394: .4byte 0x0234718C
	arm_func_end FUN_0200F364

	arm_func_start FUN_0200F398
FUN_0200F398: @ 0x0200F398
	stmdb sp!, {lr}
	sub sp, sp, #0xc
	ldr r0, _0200F40C @ =0x0231CF3C
	ldr r0, [r0]
	cmp r0, #0x10000
	bne _0200F3E0
	bl FUN_0200D8F4
	add r0, sp, #0
	bl FUN_0200D834
	cmp r0, #0
	bne _0200F3E0
	ldr r2, [sp, #8]
	ldr r0, [sp, #4]
	ldr r1, _0200F40C @ =0x0231CF3C
	add r0, r2, r0, lsl #8
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [r1]
_0200F3E0:
	ldr r1, _0200F40C @ =0x0231CF3C
	ldr r0, [r1]
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	lsl r0, r2, #0x10
	str r2, [r1]
	lsr r0, r0, #0x10
	add sp, sp, #0xc
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200F40C: .4byte 0x0231CF3C
	arm_func_end FUN_0200F398

	arm_func_start FUN_0200F410
FUN_0200F410: @ 0x0200F410
	push {r4, lr}
	bl FUN_0200EF1C
	mov r4, r0
	bl FUN_0200EF00
	cmp r0, #0
	movne r0, #0
	popne {r4, lr}
	bxne lr
	ldr r0, [r4, #4]
	mov r1, #2
	bl FUN_02008C5C
	ldr r2, [r4, #4]
	ldrh r0, [r2]
	cmp r0, #9
	beq _0200F460
	cmp r0, #0xa
	beq _0200F48C
	cmp r0, #0xb
	beq _0200F48C
	b _0200F4A8
_0200F460:
	ldr r0, _0200F4B4 @ =0x00000182
	mov r1, #2
	add r0, r2, r0
	bl FUN_02008C5C
	ldr r2, [r4, #4]
	add r0, r2, #0x100
	ldrh r0, [r0, #0x82]
	cmp r0, #0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
_0200F48C:
	add r0, r2, #0xbc
	mov r1, #2
	bl FUN_02008C5C
	ldr r0, [r4, #4]
	ldrh r0, [r0, #0xbc]
	pop {r4, lr}
	bx lr
_0200F4A8:
	mov r0, #0
	pop {r4, lr}
	bx lr
	.align 2, 0
_0200F4B4: .4byte 0x00000182
	arm_func_end FUN_0200F410

	arm_func_start FUN_0200F4B8
FUN_0200F4B8: @ 0x0200F4B8
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_0200EF00
	cmp r0, #0
	movne r0, #0x8000
	ldreq r0, _0200F4E0 @ =0x027FFCFA
	ldrheq r0, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_0200F4E0: .4byte 0x027FFCFA
	arm_func_end FUN_0200F4B8

	arm_func_start FUN_0200F4E4
FUN_0200F4E4: @ 0x0200F4E4
	push {r4, r5, lr}
	sub sp, sp, #4
	bl FUN_0200EF1C
	mov r4, r0
	mov r0, #2
	mov r1, #7
	mov r2, #8
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #4
	movne r0, #0
	popne {r4, r5, lr}
	bxne lr
	ldr r0, [r4, #4]
	mov r1, #4
	add r0, r0, #0xc
	bl FUN_02008C5C
	ldr r1, [r4, #4]
	ldr r0, [r1, #0xc]
	cmp r0, #1
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	bxeq lr
	add r0, r1, #0x188
	mov r1, #2
	bl FUN_02008C5C
	ldr r1, [r4, #4]
	add r0, r1, #0x100
	ldrh r0, [r0, #0x88]
	cmp r0, #0
	moveq r5, #1
	add r0, r1, #0x3e
	mov r1, #2
	movne r5, #0
	bl FUN_02008C5C
	cmp r5, #1
	ldr r0, [r4, #4]
	addne sp, sp, #4
	ldrh r5, [r0, #0x3e]
	addne r0, r5, #0x51
	bicne r0, r0, #0x1f
	lslne r0, r0, #1
	popne {r4, r5, lr}
	bxne lr
	add r0, r0, #0xf8
	mov r1, #2
	bl FUN_02008C5C
	ldr r0, [r4, #4]
	add r1, r5, #0xc
	ldrh r0, [r0, #0xf8]
	mul r0, r1, r0
	add r0, r0, #0x29
	bic r0, r0, #0x1f
	lsl r0, r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200F4E4

	arm_func_start FUN_0200F5CC
FUN_0200F5CC: @ 0x0200F5CC
	push {r4, lr}
	bl FUN_0200EF1C
	mov r4, r0
	mov r0, #2
	mov r1, #7
	mov r2, #8
	bl FUN_0200EDFC
	cmp r0, #0
	movne r0, #0
	popne {r4, lr}
	bxne lr
	ldr r0, [r4, #4]
	mov r1, #4
	add r0, r0, #0xc
	bl FUN_02008C5C
	ldr r1, [r4, #4]
	ldr r0, [r1, #0xc]
	cmp r0, #1
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	add r0, r1, #0x3c
	mov r1, #4
	bl FUN_02008C5C
	ldr r0, [r4, #4]
	ldrh r0, [r0, #0x3c]
	add r0, r0, #0x1f
	bic r0, r0, #0x1f
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200F5CC

	arm_func_start FUN_0200F644
FUN_0200F644: @ 0x0200F644
	push {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0x48
	movs r5, r1
	mov r6, r0
	mov r4, r2
	beq _0200F6AC
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x44
	bl FUN_0200A144
	mov r3, #0
	ldr r1, _0200F720 @ =0x0000FFFF
	mov r7, #0x82
	mov r2, #0x19
	add r0, sp, #0x14
	strh r7, [sp]
	strh r3, [sp, #2]
	strh r2, [sp, #4]
	strh r6, [sp, #6]
	str r3, [sp, #8]
	str r3, [sp, #0xc]
	strh r3, [sp, #0x10]
	strh r1, [sp, #0x1a]
	str r4, [sp, #0x1c]
	strh r3, [sp, #0x12]
	bl FUN_02009C5C
_0200F6AC:
	bl FUN_02009A90
	mov r8, r0
	bl FUN_0200EF00
	movs r7, r0
	beq _0200F6D8
	mov r0, r8
	bl FUN_02009AA4
	add sp, sp, #0x48
	mov r0, r7
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0200F6D8:
	bl FUN_0200EF1C
	add r0, r0, r6, lsl #2
	str r5, [r0, #0xcc]
	str r4, [r0, #0x10c]
	cmp r5, #0
	beq _0200F708
	bl FUN_0200E994
	strh r0, [sp, #0x22]
	bl FUN_0200E9C8
	strh r0, [sp, #0x20]
	add r0, sp, #0
	.word 0xE12FFF35
_0200F708:
	mov r0, r8
	bl FUN_02009AA4
	mov r0, #0
	add sp, sp, #0x48
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200F720: .4byte 0x0000FFFF
	arm_func_end FUN_0200F644

	arm_func_start FUN_0200F724
FUN_0200F724: @ 0x0200F724
	push {r4, r5, r6, lr}
	mov r6, r0
	bl FUN_02009A90
	mov r5, r0
	bl FUN_0200EF00
	movs r4, r0
	beq _0200F754
	mov r0, r5
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, r5, r6, lr}
	bx lr
_0200F754:
	bl FUN_0200EF1C
	str r6, [r0, #0xc8]
	mov r0, r5
	bl FUN_02009AA4
	mov r0, #0
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0200F724

	arm_func_start FUN_0200F770
FUN_0200F770: @ 0x0200F770
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0x2c
	mov r7, r0
	mov r6, r1
	mov r0, #1
	mov r1, #2
	mov r5, r2
	mov r4, r3
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #0x2c
	popne {r4, r5, r6, r7, lr}
	bxne lr
	cmp r6, #0
	addeq sp, sp, #0x2c
	moveq r0, #6
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	ldrh r1, [r6]
	mov r0, r6
	lsl r1, r1, #1
	bl FUN_02008C78
	bl FUN_0200EF1C
	add r1, r0, #0x100
	mov r2, #0
	strh r2, [r1, #0x50]
	str r2, [r0, #0x14c]
	mov r1, r7
	mov r0, #0xc
	bl FUN_0200F0D0
	mov r0, #0xc
	strh r0, [sp]
	str r6, [sp, #4]
	cmp r5, #0
	beq _0200F810
	add r1, sp, #8
	mov r0, r5
	mov r2, #0x18
	bl FUN_0200A1D8
	b _0200F820
_0200F810:
	add r0, sp, #8
	mov r1, #0
	mov r2, #0x18
	bl FUN_0200A144
_0200F820:
	ldrh r2, [sp, #0x40]
	add r0, sp, #0
	mov r1, #0x28
	str r4, [sp, #0x20]
	strh r2, [sp, #0x26]
	bl FUN_0200EF2C
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #0x2c
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200F770

	arm_func_start FUN_0200F84C
FUN_0200F84C: @ 0x0200F84C
	push {r4, lr}
	mov r4, r0
	mov r0, #1
	mov r1, #5
	bl FUN_0200EDFC
	cmp r0, #0
	popne {r4, lr}
	bxne lr
	mov r1, r4
	mov r0, #0xb
	bl FUN_0200F0D0
	mov r0, #0xb
	mov r1, #0
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200F84C

	arm_func_start FUN_0200F894
FUN_0200F894: @ 0x0200F894
	push {r4, r5, lr}
	sub sp, sp, #0x14
	mov r5, r0
	mov r0, #3
	mov r4, r1
	mov r2, r0
	mov r1, #2
	mov r3, #5
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #0x14
	popne {r4, r5, lr}
	bxne lr
	cmp r4, #0
	addeq sp, sp, #0x14
	moveq r0, #6
	popeq {r4, r5, lr}
	bxeq lr
	ldr r0, [r4]
	cmp r0, #0
	addeq sp, sp, #0x14
	moveq r0, #6
	popeq {r4, r5, lr}
	bxeq lr
	ldrh r0, [r4, #4]
	cmp r0, #1
	blo _0200F908
	cmp r0, #0xe
	bls _0200F918
_0200F908:
	add sp, sp, #0x14
	mov r0, #6
	pop {r4, r5, lr}
	bx lr
_0200F918:
	mov r1, r5
	mov r0, #0xa
	bl FUN_0200F0D0
	mov r0, #0xa
	strh r0, [sp]
	ldrh r2, [r4, #4]
	add r0, sp, #0
	mov r1, #0x10
	strh r2, [sp, #2]
	ldr r2, [r4]
	str r2, [sp, #4]
	ldrh r2, [r4, #6]
	strh r2, [sp, #8]
	ldrb r2, [r4, #8]
	strb r2, [sp, #0xa]
	ldrb r2, [r4, #9]
	strb r2, [sp, #0xb]
	ldrb r2, [r4, #0xa]
	strb r2, [sp, #0xc]
	ldrb r2, [r4, #0xb]
	strb r2, [sp, #0xd]
	ldrb r2, [r4, #0xc]
	strb r2, [sp, #0xe]
	ldrb r2, [r4, #0xd]
	strb r2, [sp, #0xf]
	bl FUN_0200EF2C
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #0x14
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200F894

	arm_func_start FUN_0200F994
FUN_0200F994: @ 0x0200F994
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	mov r0, #1
	mov r1, #2
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	bl FUN_0200EF1C
	add r1, r0, #0x100
	mov r2, #0
	strh r2, [r1, #0x50]
	str r2, [r0, #0x14c]
	mov r1, r5
	mov r0, #8
	bl FUN_0200F0D0
	mov r2, r4
	mov r0, #8
	mov r1, #1
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200F994

	arm_func_start FUN_0200FA04
FUN_0200FA04: @ 0x0200FA04
	ldrh r1, [r0, #4]
	cmp r1, #0x70
	movhi r0, #0
	bxhi lr
	ldrh r1, [r0, #0x18]
	cmp r1, #0xa
	blo _0200FA28
	cmp r1, #0x3e8
	bls _0200FA30
_0200FA28:
	mov r0, #0
	bx lr
_0200FA30:
	ldrh r0, [r0, #0x32]
	cmp r0, #1
	blo _0200FA44
	cmp r0, #0xe
	bls _0200FA4C
_0200FA44:
	mov r0, #0
	bx lr
_0200FA4C:
	mov r0, #1
	bx lr
	arm_func_end FUN_0200FA04

	arm_func_start FUN_0200FA54
FUN_0200FA54: @ 0x0200FA54
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	mov r0, #1
	mov r1, #2
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	cmp r4, #0
	addeq sp, sp, #4
	moveq r0, #6
	popeq {r4, r5, lr}
	bxeq lr
	ldrh r0, [r4, #4]
	cmp r0, #0
	beq _0200FAB8
	ldr r0, [r4]
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #6
	popeq {r4, r5, lr}
	bxeq lr
_0200FAB8:
	ldrh r1, [r4, #0x14]
	ldrh r0, [r4, #0x34]
	cmp r1, #0
	movne r2, #0x2a
	moveq r2, #0
	add r0, r0, r2
	cmp r0, #0x200
	bgt _0200FAF4
	ldrh r0, [r4, #0x36]
	cmp r1, #0
	movne r1, #6
	moveq r1, #0
	add r0, r0, r1
	cmp r0, #0x200
	ble _0200FB04
_0200FAF4:
	add sp, sp, #4
	mov r0, #6
	pop {r4, r5, lr}
	bx lr
_0200FB04:
	mov r0, r4
	bl FUN_0200FA04
	mov r1, r5
	mov r0, #7
	bl FUN_0200F0D0
	mov r0, r4
	mov r1, #0x40
	bl FUN_02008C78
	ldrh r1, [r4, #4]
	cmp r1, #0
	beq _0200FB38
	ldr r0, [r4]
	bl FUN_02008C78
_0200FB38:
	mov r2, r4
	mov r0, #7
	mov r1, #1
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0200FA54

	arm_func_start FUN_0200FB5C
FUN_0200FB5C: @ 0x0200FB5C
	push {r4, lr}
	mov r4, r0
	mov r0, #1
	mov r1, #2
	bl FUN_0200EDFC
	cmp r0, #0
	popne {r4, lr}
	bxne lr
	mov r1, r4
	mov r0, #2
	bl FUN_0200F0D0
	mov r0, #2
	mov r1, #0
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200FB5C

	arm_func_start FUN_0200FBA4
FUN_0200FBA4: @ 0x0200FBA4
	push {r4, lr}
	mov r4, r0
	bl FUN_0200EEA4
	cmp r0, #0
	popne {r4, lr}
	bxne lr
	mov r1, r4
	mov r0, #1
	bl FUN_0200F0D0
	mov r0, #1
	mov r1, #0
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200FBA4

	arm_func_start FUN_0200FBE4
FUN_0200FBE4: @ 0x0200FBE4
	push {r4, lr}
	sub sp, sp, #8
	mov r4, r1
	mov r1, r2
	bl FUN_0200F364
	cmp r0, #0
	addne sp, sp, #8
	popne {r4, lr}
	bxne lr
	mov r1, r4
	mov r0, #0
	bl FUN_0200F0D0
	bl FUN_0200EF1C
	mov r3, r0
	ldr r1, [r3, #0x10]
	mov r0, #0
	str r1, [sp]
	ldr r2, [r3]
	ldr r3, [r3, #4]
	mov r1, #3
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #8
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0200FBE4

	arm_func_start FUN_0200FC4C
FUN_0200FC4C: @ 0x0200FC4C
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #0x14
	mov sb, r0
	mov r8, r1
	mov r7, r2
	mov r6, r3
	mov r5, #1
	bl FUN_0200EF1C
	ldr r4, [r0, #4]
	mov r0, #2
	mov r1, #9
	mov r2, #0xa
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #0x14
	popne {r4, r5, r6, r7, r8, sb, lr}
	bxne lr
	add r0, r4, #0x3c
	mov r1, #2
	bl FUN_02008C5C
	add r0, r4, #0x188
	mov r1, #2
	bl FUN_02008C5C
	add r0, r4, #0x100
	ldrh r0, [r0, #0x88]
	cmp r0, #0
	bne _0200FCDC
	ldr r0, _0200FDA4 @ =0x00000182
	mov r1, #2
	add r0, r4, r0
	bl FUN_02008C5C
	add r2, r4, #0x100
	add r0, r4, #0x86
	mov r1, #2
	ldrh r5, [r2, #0x82]
	bl FUN_02008C5C
_0200FCDC:
	cmp r7, #0
	addeq sp, sp, #0x14
	moveq r0, #6
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	cmp r5, #0
	addeq sp, sp, #0x14
	moveq r0, #7
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	add r0, r4, #0x7c
	mov r1, #2
	bl FUN_02008C5C
	ldr r0, [r4, #0x7c]
	cmp r7, r0
	addeq sp, sp, #0x14
	moveq r0, #6
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	cmp r6, #0x200
	addhi sp, sp, #0x14
	movhi r0, #6
	pophi {r4, r5, r6, r7, r8, sb, lr}
	bxhi lr
	cmp r6, #0
	addeq sp, sp, #0x14
	moveq r0, #6
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	mov r0, r7
	mov r1, r6
	bl FUN_02008C78
	ldrh r2, [sp, #0x30]
	ldrh r1, [sp, #0x34]
	ldrh r0, [sp, #0x38]
	str r2, [sp]
	str r1, [sp, #4]
	str r0, [sp, #8]
	str sb, [sp, #0xc]
	mov r2, r7
	mov r3, r6
	mov r0, #0xf
	mov r1, #7
	str r8, [sp, #0x10]
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #0x14
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	.align 2, 0
_0200FDA4: .4byte 0x00000182
	arm_func_end FUN_0200FC4C

	arm_func_start FUN_0200FDA8
FUN_0200FDA8: @ 0x0200FDA8
	push {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0x28
	mov r6, r1
	mov r7, r0
	mov r5, r2
	add r1, sp, #8
	mov r0, #0
	mov r2, #0x1c
	mov r4, r3
	bl FUN_0200A0CC
	ldrh lr, [sp, #0x44]
	ldr r1, [sp, #0x58]
	ldrh ip, [sp, #0x48]
	ldr r0, [sp, #0x54]
	ldr r8, _0200FE48 @ =0x00001E03
	cmp r0, #0
	ldr r3, [sp, #0x4c]
	ldr r2, [sp, #0x50]
	strb r1, [sp, #0x22]
	strh ip, [sp, #0x1e]
	strb r3, [sp, #0x20]
	strb r2, [sp, #0x21]
	ldrh r1, [sp, #0x40]
	str r8, [sp, #8]
	orrne r0, r8, #4
	strne r0, [sp, #8]
	strh lr, [sp, #0xc]
	strh lr, [sp, #0xe]
	strhne lr, [sp, #0x10]
	str r1, [sp]
	add ip, sp, #8
	mov r0, r7
	mov r1, r6
	mov r2, r5
	mov r3, r4
	str ip, [sp, #4]
	bl FUN_0200FE4C
	add sp, sp, #0x28
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_0200FE48: .4byte 0x00001E03
	arm_func_end FUN_0200FDA8

	arm_func_start FUN_0200FE4C
FUN_0200FE4C: @ 0x0200FE4C
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #0x34
	mov sb, r0
	mov r8, r1
	mov r7, r2
	mov r6, r3
	bl FUN_0200EF1C
	ldr r5, [r0, #4]
	mov r0, #2
	mov r1, #7
	mov r2, #8
	bl FUN_0200EDFC
	cmp r0, #0
	addne sp, sp, #0x34
	popne {r4, r5, r6, r7, r8, sb, lr}
	bxne lr
	add r0, r5, #0x188
	mov r1, #2
	bl FUN_02008C5C
	add r0, r5, #0xc6
	mov r1, #2
	bl FUN_02008C5C
	add r0, r5, #0x100
	ldrh r0, [r0, #0x88]
	cmp r0, #0
	beq _0200FECC
	ldrh r0, [r5, #0xc6]
	cmp r0, #1
	addne sp, sp, #0x34
	movne r0, #3
	popne {r4, r5, r6, r7, r8, sb, lr}
	bxne lr
_0200FECC:
	add r0, r5, #0xc
	mov r1, #4
	bl FUN_02008C5C
	ldr r0, [r5, #0xc]
	cmp r0, #1
	addeq sp, sp, #0x34
	moveq r0, #3
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	ands r0, r7, #0x3f
	addne sp, sp, #0x34
	movne r0, #6
	popne {r4, r5, r6, r7, r8, sb, lr}
	bxne lr
	ldrh r4, [sp, #0x50]
	ands r0, r4, #0x1f
	addne sp, sp, #0x34
	movne r0, #6
	popne {r4, r5, r6, r7, r8, sb, lr}
	bxne lr
	add r0, r5, #0x9c
	mov r1, #2
	bl FUN_02008C5C
	ldrh r0, [r5, #0x9c]
	cmp r0, #0
	bne _0200FF64
	bl FUN_0200F4E4
	cmp r7, r0
	addlt sp, sp, #0x34
	movlt r0, #6
	poplt {r4, r5, r6, r7, r8, sb, lr}
	bxlt lr
	bl FUN_0200F5CC
	cmp r4, r0
	addlt sp, sp, #0x34
	movlt r0, #6
	poplt {r4, r5, r6, r7, r8, sb, lr}
	bxlt lr
_0200FF64:
	mov r1, sb
	mov r0, #0xe
	bl FUN_0200F0D0
	add r1, sp, #0
	mov r0, #0
	mov r2, #0x30
	bl FUN_0200A0CC
	ldrh r3, [sp, #0x50]
	lsr r4, r7, #1
	mov r5, #0xe
	ldr r0, [sp, #0x54]
	add r1, sp, #0x14
	mov r2, #0x1c
	strh r5, [sp]
	str r8, [sp, #4]
	str r4, [sp, #8]
	str r6, [sp, #0xc]
	str r3, [sp, #0x10]
	bl FUN_0200A0E0
	add r0, sp, #0
	mov r1, #0x30
	bl FUN_0200EF2C
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #0x34
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_0200FE4C

	arm_func_start FUN_0200FFD0
FUN_0200FFD0: @ 0x0200FFD0
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0xc
	mov r7, r0
	mov r6, r1
	mov r5, r2
	mov r4, r3
	bl FUN_0200EEA4
	cmp r0, #0
	addne sp, sp, #0xc
	popne {r4, r5, r6, r7, lr}
	bxne lr
	mov r1, r7
	mov r0, #0x1d
	bl FUN_0200F0D0
	ldrh ip, [sp, #0x20]
	str r4, [sp]
	mov r2, r6
	mov r3, r5
	mov r0, #0x1d
	mov r1, #4
	str ip, [sp, #4]
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_0200FFD0

	arm_func_start FUN_0201003C
FUN_0201003C: @ 0x0201003C
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	bl FUN_0200EEA4
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	cmp r4, #0
	beq _0201007C
	cmp r4, #1
	addne sp, sp, #4
	movne r0, #6
	popne {r4, r5, lr}
	bxne lr
_0201007C:
	mov r1, r5
	mov r0, #0x19
	bl FUN_0200F0D0
	mov r2, r4
	mov r0, #0x19
	mov r1, #1
	bl FUN_0200EFA4
	cmp r0, #0
	moveq r0, #2
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0201003C

	arm_func_start FUN_020100AC
FUN_020100AC: @ 0x020100AC
	push {r3, r4, r5, lr}
	mov r5, r0
	bl FUN_02009A90
	mov r4, r0
	bl FUN_02010FC4
	mov r1, #0x590
	mul lr, r5, r1
	ldr r3, _02010138 @ =0x0234D6CC
	add r2, r0, lr
	ldr r1, [r3]
	ldrb r2, [r2, #0x4c5]
	add r1, r1, #0x1000
	mvn ip, #0
	str r5, [r1, #0x4ec]
	ldr r1, [r3]
	add r0, r0, #0x4d0
	add r0, r0, lr
	add r1, r1, #0x1000
	strb r2, [r1, #0x4f0]
	ldr r1, [r3]
	mov r2, #0xc0
	add r1, r1, #0x1000
	str ip, [r1, #0xb0c]
	ldr r1, [r3]
	add r1, r1, #0x1340
	bl FUN_0200A0B0
	ldr r0, _02010138 @ =0x0234D6CC
	ldr r0, [r0]
	add r0, r0, #0x1340
	bl FUN_02013470
	mov r5, r0
	mov r0, r4
	bl FUN_02009AA4
	mov r0, r5
	pop {r3, r4, r5, pc}
	.align 2, 0
_02010138: .4byte 0x0234D6CC
	arm_func_end FUN_020100AC

	arm_func_start FUN_0201013C
FUN_0201013C: @ 0x0201013C
	push {r3, r4, lr}
	sub sp, sp, #0x34
	ldr r2, _020101C4 @ =0x0234D6CC
	str r1, [sp]
	ldr r2, [r2]
	mov r4, r0
	add r0, r2, #0x1300
	add r1, sp, #4
	mov r2, #0x16
	bl FUN_0200A1D8
	mov r3, #1
	mov r2, #7
	add r0, sp, #0x23
	add r1, sp, #0
	strh r3, [sp, #0x1a]
	strb r4, [sp, #0x1c]
	strb r2, [sp, #0x20]
	bl FUN_02013904
	ldr r1, _020101C4 @ =0x0234D6CC
	strb r0, [sp, #0x22]
	ldr r1, [r1]
	add r0, sp, #0x20
	bl FUN_02013814
	cmp r0, #0
	addeq sp, sp, #0x34
	moveq r0, #0x15
	popeq {r3, r4, pc}
	ldr r0, _020101C4 @ =0x0234D6CC
	ldr r1, _020101C8 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x34
	pop {r3, r4, pc}
	.align 2, 0
_020101C4: .4byte 0x0234D6CC
_020101C8: .4byte 0x0000FFFF
	arm_func_end FUN_0201013C

	arm_func_start FUN_020101CC
FUN_020101CC: @ 0x020101CC
	push {r4, lr}
	mov r4, r0
	bl FUN_02009A90
	ldr r1, _020101F0 @ =0x0234D6CC
	ldr r1, [r1]
	add r1, r1, #0x1000
	str r4, [r1, #0x4e4]
	bl FUN_02009AA4
	pop {r4, pc}
	.align 2, 0
_020101F0: .4byte 0x0234D6CC
	arm_func_end FUN_020101CC

	arm_func_start FUN_020101F4
FUN_020101F4: @ 0x020101F4
	ldr r0, _02010210 @ =0x0234D6CC
	ldr r0, [r0]
	cmp r0, #0
	addne r0, r0, #0x1000
	ldrne r0, [r0, #0x4e8]
	moveq r0, #0
	bx lr
	.align 2, 0
_02010210: .4byte 0x0234D6CC
	arm_func_end FUN_020101F4

	arm_func_start FUN_02010214
FUN_02010214: @ 0x02010214
	push {r4, lr}
	mov r4, #0
	bl FUN_02009A90
	ldr r1, _0201025C @ =0x0234D6CC
	ldr r2, [r1]
	cmp r2, #0
	beq _02010250
	add r1, r2, #0x1000
	ldr r1, [r1, #0x4e8]
	cmp r1, #7
	addeq r1, r2, #0x1400
	ldrheq r2, [r1, #0xf2]
	cmpeq r2, #0
	moveq r4, #1
	strheq r4, [r1, #0xf2]
_02010250:
	bl FUN_02009AA4
	mov r0, r4
	pop {r4, pc}
	.align 2, 0
_0201025C: .4byte 0x0234D6CC
	arm_func_end FUN_02010214

	arm_func_start FUN_02010260
FUN_02010260: @ 0x02010260
	ldr r2, _02010278 @ =0x0234D6CC
	ldr ip, _0201027C @ =0x0230B6C0
	ldr r2, [r2]
	add r2, r2, #0x1000
	str r0, [r2, #0x4e8]
	bx ip
	.align 2, 0
_02010278: .4byte 0x0234D6CC
_0201027C: .4byte 0x0230B6C0
	arm_func_end FUN_02010260

	arm_func_start FUN_02010280
FUN_02010280: @ 0x02010280
	push {r3, lr}
	ldr r2, _020102A4 @ =0x0234D6CC
	ldr r2, [r2]
	add r2, r2, #0x1000
	ldr r2, [r2, #0x4e4]
	cmp r2, #0
	popeq {r3, pc}
	.word 0xE12FFF32
	pop {r3, pc}
	.align 2, 0
_020102A4: .4byte 0x0234D6CC
	arm_func_end FUN_02010280

	arm_func_start FUN_020102A8
FUN_020102A8: @ 0x020102A8
	push {r3, r4, r5, lr}
	mov r4, r0
	mov r5, r1
	cmp r4, #0xff
	bgt _02010334
	bge _0201048C
	cmp r4, #0x19
	addls pc, pc, r4, lsl #2
	b _02010590
_020102CC: @ jump table
	b _02010590 @ case 0
	b _02010590 @ case 1
	b _02010590 @ case 2
	b _02010590 @ case 3
	b _0201034C @ case 4
	b _02010374 @ case 5
	b _02010384 @ case 6
	b _02010590 @ case 7
	b _02010590 @ case 8
	b _02010390 @ case 9
	b _02010478 @ case 10
	b _0201043C @ case 11
	b _02010590 @ case 12
	b _02010590 @ case 13
	b _02010590 @ case 14
	b _02010590 @ case 15
	b _02010590 @ case 16
	b _020103A4 @ case 17
	b _02010590 @ case 18
	b _02010590 @ case 19
	b _02010590 @ case 20
	b _02010340 @ case 21
	b _02010590 @ case 22
	b _02010590 @ case 23
	b _02010590 @ case 24
	b _0201039C @ case 25
_02010334:
	cmp r4, #0x100
	beq _020104F4
	b _02010590
_02010340:
	mov r0, #1
	bl FUN_02010260
	b _02010590
_0201034C:
	bl FUN_0201325C
	bl FUN_02013270
	mov r2, r0
	ldrh r1, [r5, #0x12]
	ldr r0, _020105BC @ =0x0230BE94
	bl FUN_02011034
	ldr r0, _020105BC @ =0x0230BE94
	mov r1, #1
	bl FUN_02011370
	b _02010590
_02010374:
	ldr r0, _020105BC @ =0x0230BE94
	mov r1, #0
	bl FUN_02011370
	b _02010590
_02010384:
	mov r0, #2
	bl FUN_02010260
	b _02010590
_02010390:
	mov r0, r5
	bl FUN_020105D0
	b _02010590
_0201039C:
	bl FUN_020108B0
	b _02010590
_020103A4:
	ldr r0, _020105C0 @ =0x0234D6CC
	ldr r2, [r0]
	add r0, r2, #0x1000
	ldr r1, [r0, #0x4e8]
	cmp r1, #0xa
	ldrbeq r0, [r0, #0xb10]
	cmpeq r0, #1
	bne _020103FC
	ldr r1, _020105C4 @ =0x023FE840
	add r0, r2, #0x1400
	mov r2, #0xe4
	bl FUN_0200A0B0
	ldr r0, _020105C0 @ =0x0234D6CC
	ldr r1, _020105C8 @ =0x023FE800
	ldr r0, [r0]
	mov r2, #0x3c
	add r0, r0, #0x1340
	bl FUN_0200A0B0
	mov r0, #0xb
	mov r1, #0
	bl FUN_02010260
	b _02010590
_020103FC:
	mov r0, #0xc
	mov r1, #0
	bl FUN_02010260
	ldr r0, _020105C0 @ =0x0234D6CC
	ldr r0, [r0]
	add r0, r0, #0x1000
	ldrb r1, [r0, #0x300]
	bic r1, r1, #0xf0
	strb r1, [r0, #0x300]
	bl FUN_02010BD8
	ldr r0, _020105C0 @ =0x0234D6CC
	mov r1, #0
	ldr r0, [r0]
	add r0, r0, #0x1000
	str r1, [r0, #0x4e8]
	b _02010590
_0201043C:
	mov r0, #3
	bl FUN_02010260
	ldr r0, _020105C0 @ =0x0234D6CC
	ldr r0, [r0]
	add r0, r0, #0x1000
	ldr r0, [r0, #0x4ec]
	bl FUN_02011B10
	ldr r0, _020105C0 @ =0x0234D6CC
	mov r1, #0
	ldr r0, [r0]
	add r0, r0, #0x1000
	str r1, [r0, #0x4ec]
	bl FUN_02013554
	bl FUN_020131A4
	b _02010590
_02010478:
	mov r0, #4
	bl FUN_02010260
	bl FUN_02013554
	bl FUN_020131A4
	b _02010590
_0201048C:
	ldrh r0, [r5, #2]
	cmp r0, #0xf
	addls pc, pc, r0, lsl #2
	b _020104E8
_0201049C: @ jump table
	b _020104E8 @ case 0
	b _020104DC @ case 1
	b _020104E8 @ case 2
	b _020104E8 @ case 3
	b _020104DC @ case 4
	b _020104DC @ case 5
	b _020104DC @ case 6
	b _020104E8 @ case 7
	b _020104DC @ case 8
	b _020104DC @ case 9
	b _020104E8 @ case 10
	b _020104E8 @ case 11
	b _020104E8 @ case 12
	b _020104E8 @ case 13
	b _020104E8 @ case 14
	b _020104E8 @ case 15
_020104DC:
	mov r0, #9
	bl FUN_02010C28
	b _02010590
_020104E8:
	mov r0, #8
	bl FUN_02010C28
	b _02010590
_020104F4:
	ldrh r0, [r5]
	cmp r0, #0x1d
	addls pc, pc, r0, lsl #2
	b _02010588
_02010504: @ jump table
	b _0201057C @ case 0
	b _02010588 @ case 1
	b _02010588 @ case 2
	b _02010588 @ case 3
	b _02010588 @ case 4
	b _02010588 @ case 5
	b _02010588 @ case 6
	b _0201057C @ case 7
	b _0201057C @ case 8
	b _02010588 @ case 9
	b _02010588 @ case 10
	b _02010588 @ case 11
	b _02010588 @ case 12
	b _0201057C @ case 13
	b _0201057C @ case 14
	b _0201057C @ case 15
	b _02010588 @ case 16
	b _0201057C @ case 17
	b _0201057C @ case 18
	b _02010588 @ case 19
	b _02010588 @ case 20
	b _0201057C @ case 21
	b _02010588 @ case 22
	b _02010588 @ case 23
	b _02010588 @ case 24
	b _0201057C @ case 25
	b _02010588 @ case 26
	b _02010588 @ case 27
	b _02010588 @ case 28
	b _0201057C @ case 29
_0201057C:
	mov r0, #9
	bl FUN_02010C28
	b _02010590
_02010588:
	mov r0, #8
	bl FUN_02010C28
_02010590:
	cmp r4, #0x11
	popne {r3, r4, r5, pc}
	ldr r0, _020105C0 @ =0x0234D6CC
	ldr r2, _020105CC @ =0x00001B20
	ldr r1, [r0]
	mov r0, #0
	bl FUN_0200A098
	ldr r0, _020105C0 @ =0x0234D6CC
	mov r1, #0
	str r1, [r0]
	pop {r3, r4, r5, pc}
	.align 2, 0
_020105BC: .4byte 0x0230BE94
_020105C0: .4byte 0x0234D6CC
_020105C4: .4byte 0x023FE840
_020105C8: .4byte 0x023FE800
_020105CC: .4byte 0x00001B20
	arm_func_end FUN_020102A8

	arm_func_start FUN_020105D0
FUN_020105D0: @ 0x020105D0
	push {r4, r5, r6, lr}
	sub sp, sp, #0x18
	ldr r1, _020108AC @ =0x0234D6CC
	mov r6, r0
	ldr r5, [r1]
	bl FUN_020135C4
	mov r4, r0
	ldr r1, [r6, #0xc]
	add r0, sp, #0
	bl FUN_02013950
	ldrb r1, [sp]
	mov r6, r0
	cmp r1, #6
	addls pc, pc, r1, lsl #2
	b _020108A4
_0201060C: @ jump table
	b _020108A4 @ case 0
	b _02010628 @ case 1
	b _02010650 @ case 2
	b _020106A0 @ case 3
	b _02010728 @ case 4
	b _02010868 @ case 5
	b _02010678 @ case 6
_02010628:
	add r0, r5, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #2
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	mov r0, #5
	mov r1, #0
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_02010650:
	add r0, r5, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #5
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	mov r0, #6
	mov r1, #0
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_02010678:
	add r0, r5, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #5
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	mov r0, #0xe
	mov r1, #0
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_020106A0:
	add r1, r5, #0x1000
	ldr r1, [r1, #0x4e8]
	cmp r1, #5
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	add r1, r5, #0x1400
	mov r2, #0xe4
	bl FUN_0200A1D8
	add r0, r5, #0x2f8
	add r0, r0, #0x1800
	add r1, r5, #0x1400
	bl FUN_02010C40
	cmp r0, #0
	bne _020106E8
	mov r0, #3
	bl FUN_02010C28
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_020106E8:
	add r1, r5, #0x1000
	ldrb r3, [r1, #0x300]
	and r2, r4, #0xff
	add r0, r5, #0x2f8
	bic r3, r3, #0xf0
	lsl r2, r2, #0x1c
	orr r2, r3, r2, lsr #24
	add r0, r0, #0x1800
	strb r2, [r1, #0x300]
	bl FUN_02010DC0
	add r1, r5, #0x1400
	strh r0, [r1, #0xf6]
	mov r0, #7
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_02010728:
	add r0, r5, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #7
	addeq r0, r5, #0x1400
	ldrheq r0, [r0, #0xf2]
	cmpeq r0, #1
	bne _0201075C
	mov r0, #8
	mov r1, #0
	bl FUN_02010260
	add r0, r5, #0x1400
	mov r1, #0
	strh r1, [r0, #0xf2]
_0201075C:
	add r0, r5, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #8
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	add r3, r5, #0x1400
	ldrh r0, [r3, #0xf6]
	cmp r0, #0
	beq _02010788
	cmp r0, #0x3000
	blo _02010798
_02010788:
	mov r0, #5
	bl FUN_02010C28
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_02010798:
	ldrh r2, [sp, #4]
	cmp r2, r0
	bhs _020107BC
	add r1, r5, #0x2f8
	add r0, sp, #8
	add r1, r1, #0x1800
	bl FUN_02010D0C
	cmp r0, #0
	bne _020107C8
_020107BC:
	mov r0, #4
	bl FUN_02010C28
	b _02010844
_020107C8:
	add r0, r5, #0x1000
	ldrh r1, [sp, #2]
	ldrb r0, [r0, #0x4f0]
	cmp r1, r0
	beq _020107E8
	mov r0, #6
	bl FUN_02010C28
	b _02010844
_020107E8:
	ldrb r0, [sp, #0x14]
	ldr r1, [sp, #8]
	ldr r2, [sp, #0xc]
	bl FUN_02010DC8
	cmp r0, #0
	bne _0201080C
	mov r0, #7
	bl FUN_02010C28
	b _02010844
_0201080C:
	ldrh r0, [sp, #4]
	bl FUN_02010AA8
	cmp r0, #0
	bne _02010844
	ldr r1, [sp, #8]
	ldr r2, [sp, #0xc]
	mov r0, r6
	bl FUN_0200A1D8
	add r0, r5, #0x1400
	ldrh r1, [r0, #0xf4]
	add r1, r1, #1
	strh r1, [r0, #0xf4]
	ldrh r0, [sp, #4]
	bl FUN_02010AD8
_02010844:
	bl FUN_02010B14
	cmp r0, #0
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	mov r0, #9
	mov r1, #0
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_02010868:
	add r0, r5, #0x1000
	ldr r1, [r0, #0x4e8]
	cmp r1, #9
	bne _0201088C
	mov r0, #0xa
	mov r1, #0
	bl FUN_02010260
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
_0201088C:
	cmp r1, #0xa
	addne sp, sp, #0x18
	popne {r4, r5, r6, pc}
	mov r1, #1
	strb r1, [r0, #0xb10]
	bl FUN_020131A4
_020108A4:
	add sp, sp, #0x18
	pop {r4, r5, r6, pc}
	.align 2, 0
_020108AC: .4byte 0x0234D6CC
	arm_func_end FUN_020105D0

	arm_func_start FUN_020108B0
FUN_020108B0: @ 0x020108B0
	stmdb sp!, {lr}
	sub sp, sp, #0x14
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, [r0]
	add r0, r1, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #0xa
	addls pc, pc, r0, lsl #2
	b _02010900
_020108D4: @ jump table
	b _02010900 @ case 0
	b _02010900 @ case 1
	b _02010900 @ case 2
	b _02010900 @ case 3
	b _02010900 @ case 4
	b _0201092C @ case 5
	b _02010900 @ case 6
	b _02010960 @ case 7
	b _0201098C @ case 8
	b _020109F4 @ case 9
	b _02010A20 @ case 10
_02010900:
	mov r2, #0
	add r0, sp, #0
	strb r2, [sp]
	bl FUN_02013814
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, _02010A50 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x14
	ldm sp!, {pc}
_0201092C:
	bl FUN_02010FC4
	ldr r1, _02010A4C @ =0x0234D6CC
	mov r3, r0
	ldr r0, [r1]
	mov r1, #0x590
	add r0, r0, #0x1000
	ldr r2, [r0, #0x4ec]
	ldrb r0, [r0, #0x4f0]
	mla r1, r2, r1, r3
	ldr r1, [r1, #0x4c8]
	bl FUN_0201013C
	add sp, sp, #0x14
	ldm sp!, {pc}
_02010960:
	mov r2, #8
	add r0, sp, #0
	strb r2, [sp]
	bl FUN_02013814
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, _02010A50 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x14
	ldm sp!, {pc}
_0201098C:
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x12
	bl FUN_0200A144
	mov r0, #9
	strb r0, [sp]
	bl FUN_02010B3C
	ldr r1, _02010A4C @ =0x0234D6CC
	strh r0, [sp, #2]
	ldr r1, [r1]
	add r0, sp, #0
	add r2, r1, #0x1400
	ldrh r3, [r2, #0xf4]
	strb r3, [sp, #4]
	ldrh r2, [r2, #0xf4]
	and r2, r2, #0xff00
	asr r2, r2, #8
	strb r2, [sp, #5]
	bl FUN_02013814
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, _02010A50 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x14
	ldm sp!, {pc}
_020109F4:
	mov r2, #0xa
	add r0, sp, #0
	strb r2, [sp]
	bl FUN_02013814
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, _02010A50 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x14
	ldm sp!, {pc}
_02010A20:
	mov r2, #0xb
	add r0, sp, #0
	strb r2, [sp]
	bl FUN_02013814
	ldr r0, _02010A4C @ =0x0234D6CC
	ldr r1, _02010A50 @ =0x0000FFFF
	ldr r2, [r0]
	mov r0, #8
	bl FUN_02010F40
	add sp, sp, #0x14
	ldm sp!, {pc}
	.align 2, 0
_02010A4C: .4byte 0x0234D6CC
_02010A50: .4byte 0x0000FFFF
	arm_func_end FUN_020108B0

	arm_func_start FUN_02010A54
FUN_02010A54: @ 0x02010A54
	push {r3, lr}
	cmp r0, #4
	addls pc, pc, r0, lsl #2
	pop {r3, pc}
_02010A64: @ jump table
	pop {r3, pc} @ case 0
	b _02010A78 @ case 1
	b _02010A84 @ case 2
	b _02010A90 @ case 3
	b _02010A9C @ case 4
_02010A78:
	mov r0, #0xf
	bl FUN_02010280
	pop {r3, pc}
_02010A84:
	mov r0, #0x10
	bl FUN_02010280
	pop {r3, pc}
_02010A90:
	mov r0, #0x11
	bl FUN_02010280
	pop {r3, pc}
_02010A9C:
	mov r0, #0x12
	bl FUN_02010280
	pop {r3, pc}
	arm_func_end FUN_02010A54

	arm_func_start FUN_02010AA8
FUN_02010AA8: @ 0x02010AA8
	ldr r1, _02010AD4 @ =0x0234D6CC
	and r2, r0, #7
	ldr r1, [r1]
	mov r3, #1
	add r0, r1, r0, asr #3
	add r0, r0, #0x1000
	ldrb r0, [r0, #0x4f8]
	tst r0, r3, lsl r2
	moveq r3, #0
	mov r0, r3
	bx lr
	.align 2, 0
_02010AD4: .4byte 0x0234D6CC
	arm_func_end FUN_02010AA8

	arm_func_start FUN_02010AD8
FUN_02010AD8: @ 0x02010AD8
	push {r3, lr}
	ldr r2, _02010B10 @ =0x0234D6CC
	and r3, r0, #7
	ldr r1, [r2]
	mov ip, #1
	add r1, r1, r0, asr #3
	add r1, r1, #0x1000
	ldrb lr, [r1, #0x4f8]
	orr r3, lr, ip, lsl r3
	strb r3, [r1, #0x4f8]
	ldr r1, [r2]
	add r1, r1, #0x1000
	str r0, [r1, #0xb0c]
	pop {r3, pc}
	.align 2, 0
_02010B10: .4byte 0x0234D6CC
	arm_func_end FUN_02010AD8

	arm_func_start FUN_02010B14
FUN_02010B14: @ 0x02010B14
	ldr r0, _02010B38 @ =0x0234D6CC
	ldr r0, [r0]
	add r0, r0, #0x1400
	ldrh r1, [r0, #0xf6]
	ldrh r0, [r0, #0xf4]
	sub r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
	.align 2, 0
_02010B38: .4byte 0x0234D6CC
	arm_func_end FUN_02010B14

	arm_func_start FUN_02010B3C
FUN_02010B3C: @ 0x02010B3C
	push {r3, r4, r5, r6, r7, lr}
	ldr r6, _02010BD4 @ =0x0234D6CC
	mov r5, #0
	ldr r2, [r6]
	mov r7, r5
	add r0, r2, #0x1000
	ldr r0, [r0, #0xb0c]
	add r4, r0, #1
_02010B5C:
	cmp r4, #0
	blt _02010B74
	add r0, r2, #0x1400
	ldrh r0, [r0, #0xf6]
	cmp r4, r0
	blt _02010B7C
_02010B74:
	mov r4, r7
	b _02010B9C
_02010B7C:
	mov r0, r4
	bl FUN_02010AA8
	cmp r0, #0
	addne r4, r4, #1
	bne _02010B9C
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_02010B9C:
	ldr r2, [r6]
	add r1, r2, #0x1000
	ldr r0, [r1, #0xb0c]
	cmp r0, r4
	addeq r0, r2, #0x1400
	ldrheq r0, [r0, #0xf6]
	popeq {r3, r4, r5, r6, r7, pc}
	add r5, r5, #1
	cmp r5, #0x3e8
	ble _02010B5C
	lsl r0, r4, #0x10
	str r4, [r1, #0xb0c]
	lsr r0, r0, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_02010BD4: .4byte 0x0234D6CC
	arm_func_end FUN_02010B3C

	arm_func_start FUN_02010BD8
FUN_02010BD8: @ 0x02010BD8
	push {r3, lr}
	mov r0, #0
	mov r1, #0x2000000
	mov r2, #0x2c0000
	bl FUN_0200A0F8
	mov r0, #0
	mov r1, #0x22c0000
	mov r2, #0x40000
	bl FUN_0200A0F8
	ldr r1, _02010C20 @ =0x023FE800
	mov r0, #0
	mov r2, #0x124
	bl FUN_0200A098
	ldr r1, _02010C24 @ =0x027FFE00
	mov r0, #0
	mov r2, #0x160
	bl FUN_0200A098
	pop {r3, pc}
	.align 2, 0
_02010C20: .4byte 0x023FE800
_02010C24: .4byte 0x027FFE00
	arm_func_end FUN_02010BD8

	arm_func_start FUN_02010C28
FUN_02010C28: @ 0x02010C28
	push {r3, lr}
	strh r0, [sp]
	add r1, sp, #0
	mov r0, #0x13
	bl FUN_02010280
	pop {r3, pc}
	arm_func_end FUN_02010C28

	arm_func_start FUN_02010C40
FUN_02010C40: @ 0x02010C40
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov sl, r0
	add r6, sl, #0xc
	cmp r1, #0
	mov r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, pc}
	mov r2, r0
_02010C5C:
	str r0, [sl, r2, lsl #2]
	add r3, r1, r2, lsl #4
	add r2, r2, #1
	ldr r3, [r3, #0x14]
	and r2, r2, #0xff
	cmp r2, #3
	add r0, r0, r3
	blo _02010C5C
	mov sb, #0
	ldr r4, _02010D08 @ =0x0234D6CC
	strh sb, [r6]
	add r5, r1, #0xc
_02010C8C:
	ldr r0, [r4]
	add r7, r5, sb, lsl #4
	add r0, r0, #0x1000
	ldr r1, [r0, #0x318]
	ldr r8, [r7, #8]
	add r0, r8, r1
	sub r0, r0, #1
	bl FUN_020186D8
	lsl r1, sb, #1
	ldrh r3, [r6, r1]
	lsl r2, r0, #0x10
	ldr r1, [r7, #4]
	add r2, r3, r2, lsr #16
	lsl r3, r2, #0x10
	mov r0, sb
	mov r2, r8
	lsr r7, r3, #0x10
	bl FUN_02010E74
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, pc}
	cmp sb, #2
	addlo r0, r6, sb, lsl #1
	strhlo r7, [r0, #2]
	add r0, sb, #1
	and sb, r0, #0xff
	strhhs r7, [sl, #0x12]
	cmp sb, #3
	blo _02010C8C
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, pc}
	.align 2, 0
_02010D08: .4byte 0x0234D6CC
	arm_func_end FUN_02010C40

	arm_func_start FUN_02010D0C
FUN_02010D0C: @ 0x02010D0C
	push {r3, r4, r5, lr}
	ldrh r4, [r1, #0x12]
	cmp r2, r4
	movhs r0, #0
	pophs {r3, r4, r5, pc}
	mov ip, #2
_02010D24:
	add r4, r1, ip, lsl #1
	ldrh r4, [r4, #0xc]
	cmp r2, r4
	bhs _02010D44
	sub r4, ip, #1
	lsl ip, r4, #0x18
	asrs ip, ip, #0x18
	bpl _02010D24
_02010D44:
	cmp ip, #0
	movlt r0, #0
	poplt {r3, r4, r5, pc}
	ldr r4, _02010DBC @ =0x0234D6CC
	add r5, r1, ip, lsl #1
	ldr lr, [r4]
	ldrh r5, [r5, #0xc]
	add lr, lr, #0x1000
	ldr lr, [lr, #0x318]
	sub r5, r2, r5
	mul r2, r5, lr
	add r3, r3, #0xc
	add r5, r3, ip, lsl #4
	ldr r3, [r5, #8]
	sub lr, r3, r2
	str lr, [r0, #4]
	ldr r3, [r4]
	add r3, r3, #0x1000
	ldr r3, [r3, #0x318]
	cmp lr, r3
	strhi r3, [r0, #4]
	ldr r1, [r1, ip, lsl #2]
	add r1, r2, r1
	str r1, [r0, #8]
	ldr r1, [r5]
	add r1, r2, r1
	str r1, [r0]
	strb ip, [r0, #0xc]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.align 2, 0
_02010DBC: .4byte 0x0234D6CC
	arm_func_end FUN_02010D0C

	arm_func_start FUN_02010DC0
FUN_02010DC0: @ 0x02010DC0
	ldrh r0, [r0, #0x12]
	bx lr
	arm_func_end FUN_02010DC0

	arm_func_start FUN_02010DC8
FUN_02010DC8: @ 0x02010DC8
	ldr r3, _02010E6C @ =0x02314228
	ldr r0, [r3, r0, lsl #2]
	cmp r0, #0
	beq _02010E0C
	cmp r0, #1
	beq _02010E28
	cmp r0, #2
	bne _02010E5C
	ldr r0, _02010E70 @ =0x027FFE00
	cmp r1, r0
	blo _02010E64
	add r1, r1, r2
	add r0, r0, #0x160
	cmp r1, r0
	bhi _02010E64
	mov r0, #1
	bx lr
_02010E0C:
	cmp r1, #0x2000000
	blo _02010E64
	add r0, r1, r2
	cmp r0, #0x22c0000
	bhi _02010E64
	mov r0, #1
	bx lr
_02010E28:
	cmp r1, #0x22c0000
	blo _02010E40
	add r0, r1, r2
	cmp r0, #0x2300000
	movls r0, #1
	bxls lr
_02010E40:
	cmp r1, #0x2000000
	blo _02010E64
	add r0, r1, r2
	cmp r0, #0x2300000
	bhi _02010E64
	mov r0, #1
	bx lr
_02010E5C:
	mov r0, #0
	bx lr
_02010E64:
	mov r0, #0
	bx lr
	.align 2, 0
_02010E6C: .4byte 0x02314228
_02010E70: .4byte 0x027FFE00
	arm_func_end FUN_02010DC8

	arm_func_start FUN_02010E74
FUN_02010E74: @ 0x02010E74
	push {r3, lr}
	ldr r3, _02010F34 @ =0x02314228
	ldr r3, [r3, r0, lsl #2]
	cmp r3, #0
	beq _02010E98
	cmp r3, #1
	beq _02010EA0
	cmp r3, #2
	bne _02010F24
_02010E98:
	bl FUN_02010DC8
	pop {r3, pc}
_02010EA0:
	cmp r1, #0x2000000
	blo _02010EF8
	ldr r0, _02010F38 @ =0x023FE800
	cmp r1, r0
	bhs _02010EF8
	cmp r1, #0x2300000
	add r1, r1, r2
	bhs _02010ECC
	cmp r1, #0x2300000
	movhi r0, #0
	pophi {r3, pc}
_02010ECC:
	cmp r1, #0x2300000
	movls r0, #1
	popls {r3, pc}
	ldr r0, _02010F38 @ =0x023FE800
	cmp r1, r0
	bhs _02010EF0
	cmp r2, #0x40000
	movls r0, #1
	popls {r3, pc}
_02010EF0:
	mov r0, #0
	pop {r3, pc}
_02010EF8:
	ldr r3, _02010F3C @ =0x037F8000
	cmp r1, r3
	blo _02010F2C
	add r0, r3, #0x17000
	cmp r1, r0
	bhs _02010F2C
	add r1, r1, r2
	cmp r1, r0
	movls r0, #1
	movhi r0, #0
	pop {r3, pc}
_02010F24:
	mov r0, #0
	pop {r3, pc}
_02010F2C:
	mov r0, #0
	pop {r3, pc}
	.align 2, 0
_02010F34: .4byte 0x02314228
_02010F38: .4byte 0x023FE800
_02010F3C: .4byte 0x037F8000
	arm_func_end FUN_02010E74

	arm_func_start FUN_02010F40
FUN_02010F40: @ 0x02010F40
	push {r4, r5, r6, lr}
	mov r6, r0
	mov r4, r2
	add r2, r6, #0x1f
	mov r5, r1
	mov r0, r4
	bic r1, r2, #0x1f
	bl FUN_02008C94
	bl FUN_02008CB8
	mov r0, r4
	mov r1, r6
	mov r2, r5
	bl FUN_02013390
	pop {r4, r5, r6, pc}
	arm_func_end FUN_02010F40

	arm_func_start FUN_02010F78
FUN_02010F78: @ 0x02010F78
	asr r3, r1, #1
	cmp r3, #0
	mov r2, #0
	ble _02010F9C
_02010F88:
	ldrh r1, [r0], #2
	sub r3, r3, #1
	cmp r3, #0
	add r2, r2, r1
	bgt _02010F88
_02010F9C:
	lsl r0, r2, #0x10
	lsr r0, r0, #0x10
	add r1, r0, r2, lsr #16
	ldr r0, _02010FC0 @ =0x0000FFFF
	add r1, r1, r1, lsr #16
	eor r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
	.align 2, 0
_02010FC0: .4byte 0x0000FFFF
	arm_func_end FUN_02010F78

	arm_func_start FUN_02010FC4
FUN_02010FC4: @ 0x02010FC4
	ldr r0, _02010FD0 @ =0x02347C20
	ldr r0, [r0, #0xc]
	bx lr
	.align 2, 0
_02010FD0: .4byte 0x02347C20
	arm_func_end FUN_02010FC4

	arm_func_start FUN_02010FD4
FUN_02010FD4: @ 0x02010FD4
	ldr r1, _02010FE4 @ =0x02347DA0
	ldr r0, _02010FE8 @ =0x02347C20
	str r1, [r0, #0xc]
	bx lr
	.align 2, 0
_02010FE4: .4byte 0x02347DA0
_02010FE8: .4byte 0x02347C20
	arm_func_end FUN_02010FD4

	arm_func_start FUN_02010FEC
FUN_02010FEC: @ 0x02010FEC
	ldr r2, _02010FFC @ =0x02347C20
	str r0, [r2, #4]
	str r1, [r2]
	bx lr
	.align 2, 0
_02010FFC: .4byte 0x02347C20
	arm_func_end FUN_02010FEC

	arm_func_start FUN_02011000
FUN_02011000: @ 0x02011000
	push {r3, lr}
	ldr r0, _0201102C @ =0x02347C20
	ldr r2, _02011030 @ =0x00005910
	ldr r1, [r0, #0xc]
	mov r0, #0
	bl FUN_0200A0F8
	ldr r0, _0201102C @ =0x02347C20
	mov r1, #1
	ldr r0, [r0, #0xc]
	strh r1, [r0, #0xc]
	pop {r3, pc}
	.align 2, 0
_0201102C: .4byte 0x02347C20
_02011030: .4byte 0x00005910
	arm_func_end FUN_02011000

	arm_func_start FUN_02011034
FUN_02011034: @ 0x02011034
	push {r3, r4, r5, r6, r7, lr}
	mov r5, r2
	mov r7, r0
	mov r0, r5
	mov r6, r1
	bl FUN_020110D4
	cmp r0, #0
	moveq r0, #0
	popeq {r3, r4, r5, r6, r7, pc}
	ldr r1, _020110CC @ =0x02347CE0
	mov r0, r5
	mov r2, #0xc0
	bl FUN_0200A0B0
	ldr r5, _020110CC @ =0x02347CE0
	ldr r2, _020110D0 @ =0x02347C20
	add r3, r5, #0x50
	add r0, r3, #8
	mov r1, #0x68
	str r3, [r2, #8]
	bl FUN_02010F78
	cmp r0, #0
	movne r0, #0
	popne {r3, r4, r5, r6, r7, pc}
	mov r0, r5
	mov r1, r7
	bl FUN_02011114
	movs r4, r0
	movmi r0, #0
	popmi {r3, r4, r5, r6, r7, pc}
	mov r0, r5
	mov r1, r4
	mov r2, r6
	bl FUN_020114CC
	mov r0, r4
	mov r1, r7
	bl FUN_0201127C
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020110CC: .4byte 0x02347CE0
_020110D0: .4byte 0x02347C20
	arm_func_end FUN_02011034

	arm_func_start FUN_020110D4
FUN_020110D4: @ 0x020110D4
	ldrh r0, [r0, #0x40]
	cmp r0, #1
	moveq r0, #1
	movne r0, #0
	bx lr
	arm_func_end FUN_020110D4

	arm_func_start FUN_020110E8
FUN_020110E8: @ 0x020110E8
	mov r2, #0x10000
	rsb r2, r2, #0
	mov r3, #0x20
	strh r3, [r0, #0xa]
	and r2, r1, r2
	strh r1, [r0, #0xc]
	lsr r1, r2, #0x10
	strh r1, [r0, #0xe]
	ldrh r1, [r0, #0x48]
	strh r1, [r0, #0x10]
	bx lr
	arm_func_end FUN_020110E8

	arm_func_start FUN_02011114
FUN_02011114: @ 0x02011114
	push {r4, r5, r6, r7, r8, lr}
	ldr r2, _02011278 @ =0x02347C20
	mov r8, r1
	ldr r6, [r2, #0xc]
	ldr lr, [r2, #8]
	ldrh ip, [r6]
	mov r3, r6
	add r2, r6, #0x10
	mov r4, #0
	mov r1, #1
_0201113C:
	tst ip, r1, lsl r4
	beq _020111CC
	ldr r7, [r2, #0x4b8]
	ldr r5, [lr]
	cmp r7, r5
	ldrbeq r7, [r2, #0x4c4]
	ldrbeq r5, [r0, #4]
	cmpeq r7, r5
	ldrbeq r7, [r2, #0x4c5]
	ldrbeq r5, [r0, #5]
	cmpeq r7, r5
	ldrbeq r7, [r2, #0x4c6]
	ldrbeq r5, [r0, #6]
	cmpeq r7, r5
	ldrbeq r7, [r2, #0x4c7]
	ldrbeq r5, [r0, #7]
	cmpeq r7, r5
	ldrbeq r7, [r2, #0x4c8]
	ldrbeq r5, [r0, #8]
	cmpeq r7, r5
	ldrbeq r7, [r2, #0x4c9]
	ldrbeq r5, [r0, #9]
	cmpeq r7, r5
	bne _020111CC
	ldrb r7, [lr, #4]
	ldrb r5, [r3, #0x4c5]
	lsl r7, r7, #0x18
	cmp r5, r7, lsr #26
	bne _020111CC
	ldrh r0, [r6, #4]
	tst r0, r1, lsl r4
	bne _020111C4
	mov r0, r4
	bl FUN_02011A4C
_020111C4:
	mov r0, r4
	pop {r4, r5, r6, r7, r8, pc}
_020111CC:
	add r4, r4, #1
	cmp r4, #0x10
	add r2, r2, #0x590
	add r3, r3, #0x590
	blt _0201113C
	ldrh r2, [r6]
	mov r7, #0
	mov r1, #1
_020111EC:
	tst r2, r1, lsl r7
	lsl r5, r1, r7
	bne _0201124C
	mov r1, #0x590
	mul r4, r7, r1
	add r1, r6, #0x4d0
	add r1, r1, r4
	mov r2, #0xc0
	bl FUN_0200A0B0
	ldr r2, _02011278 @ =0x02347C20
	lsl r1, r5, #0x10
	ldr r3, [r2, #8]
	ldr r0, [r2, #0xc]
	ldrb r5, [r3, #5]
	add r3, r0, r4
	mov r0, r7
	strb r5, [r3, #0x4c3]
	ldr r3, [r2, #0xc]
	ldrh r2, [r3]
	orr r1, r2, r1, lsr #16
	strh r1, [r3]
	bl FUN_02011A4C
	mov r0, r7
	pop {r4, r5, r6, r7, r8, pc}
_0201124C:
	add r7, r7, #1
	cmp r7, #0x10
	blt _020111EC
	cmp r8, #0
	beq _02011270
	mov r1, #0
	mov r2, r1
	mov r0, #4
	.word 0xE12FFF38
_02011270:
	mvn r0, #0
	pop {r4, r5, r6, r7, r8, pc}
	.align 2, 0
_02011278: .4byte 0x02347C20
	arm_func_end FUN_02011114

	arm_func_start FUN_0201127C
FUN_0201127C: @ 0x0201127C
	push {r4, r5, r6, lr}
	ldr r2, _0201136C @ =0x02347C20
	movs r5, r1
	ldr r1, [r2, #0xc]
	mov r6, r0
	add r1, r1, #0x10
	mov r0, #0x590
	mla r4, r6, r0, r1
	beq _020112B0
	mov r1, r4
	mov r2, r6
	mov r0, #5
	.word 0xE12FFF35
_020112B0:
	ldr r1, [r4, #0x580]
	ldr r0, [r4, #0x584]
	cmp r1, r0
	bne _02011334
	cmp r1, #0
	addne r0, r4, #0x300
	ldrhne r1, [r0, #0x5a]
	cmpne r1, #0
	beq _02011334
	add r0, r4, #0x500
	ldrh r0, [r0, #0x88]
	cmp r0, r1
	bne _02011334
	ldr r0, _0201136C @ =0x02347C20
	mov r2, #1
	ldr r3, [r0, #0xc]
	ldrh r1, [r3, #4]
	tst r1, r2, lsl r6
	popne {r4, r5, r6, pc}
	orr r1, r1, r2, lsl r6
	strh r1, [r3, #4]
	ldr r1, [r0, #0xc]
	ldrh r0, [r1, #2]
	orr r0, r0, r2, lsl r6
	strh r0, [r1, #2]
	bl FUN_02011ABC
	cmp r5, #0
	popeq {r4, r5, r6, pc}
	mov r1, r4
	mov r2, r6
	mov r0, #1
	.word 0xE12FFF35
	pop {r4, r5, r6, pc}
_02011334:
	ldr r0, _0201136C @ =0x02347C20
	mov r2, #1
	ldr r1, [r0, #0xc]
	ldrh r0, [r1, #4]
	tst r0, r2, lsl r6
	eorne r0, r0, r2, lsl r6
	strhne r0, [r1, #4]
	cmpne r5, #0
	popeq {r4, r5, r6, pc}
	mov r1, r4
	mov r2, r6
	mov r0, #2
	.word 0xE12FFF35
	pop {r4, r5, r6, pc}
	.align 2, 0
_0201136C: .4byte 0x02347C20
	arm_func_end FUN_0201127C

	arm_func_start FUN_02011370
FUN_02011370: @ 0x02011370
	push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
	mov r8, #0
	ldr r5, _020114C8 @ =0x02347C20
	mov sl, r0
	str r1, [sp]
	mov r7, r8
	mov sb, r8
	mov r6, r8
	mov fp, #1
_02011394:
	ldr r0, [r5, #0xc]
	lsl r2, fp, r7
	ldrh r1, [r0]
	add r3, r0, #0x10
	add r3, r3, sb
	lsl r4, r2, #0x10
	tst r1, r4, lsr #16
	beq _02011424
	add r1, r3, #0x500
	ldrsh r2, [r1, #0x8a]
	ldrh r0, [r0, #0xc]
	sub r0, r2, r0
	strh r0, [r1, #0x8a]
	ldrsh r0, [r1, #0x8a]
	cmp r0, #0
	bge _02011424
	strh r6, [r1, #0x8a]
	ldr r0, [r5, #0xc]
	ldrh r0, [r0, #4]
	tst r0, r4, lsr #16
	cmpne sl, #0
	beq _020113FC
	mov r0, #3
	mov r1, r6
	mov r2, r7
	.word 0xE12FFF3A
_020113FC:
	ldr r1, [r5, #0xc]
	mvn r2, r4, lsr #16
	ldrh r0, [r1, #6]
	ldrh r3, [r1]
	tst r0, r4, lsr #16
	and r2, r3, r2
	mov r0, r7
	movne r8, #1
	strh r2, [r1]
	bl FUN_02011B10
_02011424:
	add r7, r7, #1
	cmp r7, #0x10
	add sb, sb, #0x590
	blt _02011394
	ldr r1, _020114C8 @ =0x02347C20
	ldr r3, [r1, #0xc]
	ldrh r0, [r3, #6]
	cmp r0, #0
	beq _020114A8
	ldrsh r2, [r3, #8]
	cmp r2, #0
	ble _020114A8
	ldrh r0, [r3, #0xc]
	sub r0, r2, r0
	strh r0, [r3, #8]
	ldr r2, [r1, #0xc]
	ldrsh r0, [r2, #8]
	cmp r0, #0
	movlt r8, #1
	blt _020114A8
	ldr r0, [sp]
	cmp r0, #0
	bne _020114A0
	ldrsh r0, [r2, #0xa]
	add r0, r0, #1
	strh r0, [r2, #0xa]
	ldr r0, [r1, #0xc]
	ldrsh r0, [r0, #0xa]
	cmp r0, #4
	movgt r8, #1
	b _020114A8
_020114A0:
	mov r0, #0
	strh r0, [r2, #0xa]
_020114A8:
	cmp r8, #0
	popeq {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	ldr r0, _020114C8 @ =0x02347C20
	mov r1, #0
	ldr r0, [r0, #0xc]
	strh r1, [r0, #8]
	bl FUN_02011ABC
	pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	.align 2, 0
_020114C8: .4byte 0x02347C20
	arm_func_end FUN_02011370

	arm_func_start FUN_020114CC
FUN_020114CC: @ 0x020114CC
	push {r3, r4, r5, lr}
	mov r5, r1
	mov r4, r2
	bl FUN_020115D4
	mov r0, r5
	bl FUN_0201163C
	mov r0, r5
	bl FUN_02011698
	ldr r1, _020115CC @ =0x02347C20
	mov r0, #0x590
	ldr r3, [r1, #0xc]
	ldr r2, [r1, #8]
	add r1, r3, #0x10
	mla r1, r5, r0, r1
	ldrb r3, [r1, #0x58e]
	ldrb r0, [r2, #7]
	cmp r3, r0
	bne _02011548
	ldrb r0, [r1, #0x58f]
	add r2, r0, #1
	and r0, r2, #0xff
	strb r2, [r1, #0x58f]
	cmp r0, #3
	bls _02011550
	add r0, r1, #0xc4
	add r1, r1, #0x500
	mov r2, #0
	add r0, r0, #0x400
	strh r2, [r1, #0x8a]
	bl FUN_020116CC
	pop {r3, r4, r5, pc}
_02011548:
	mov r0, #0
	strb r0, [r1, #0x58f]
_02011550:
	ldr r3, _020115CC @ =0x02347C20
	ldr ip, _020115D0 @ =0x00001771
	ldr r0, [r3, #8]
	add r2, r1, #0x500
	ldrb lr, [r0, #7]
	add r0, r1, #0x4c0
	strb lr, [r1, #0x58e]
	strh ip, [r2, #0x8a]
	ldr ip, [r3, #8]
	ldr ip, [ip]
	str ip, [r1, #0x4b8]
	ldr r3, [r3, #8]
	ldrb r3, [r3, #4]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x1a
	strb r3, [r1, #0x4b5]
	strh r4, [r2, #0x8c]
	ldr r1, [r1, #0x4b8]
	bl FUN_020110E8
	ldr r0, _020115CC @ =0x02347C20
	ldr r0, [r0, #8]
	ldrb r0, [r0, #4]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1e
	cmp r0, #2
	mov r0, r5
	bne _020115C4
	bl FUN_0201183C
	pop {r3, r4, r5, pc}
_020115C4:
	bl FUN_0201176C
	pop {r3, r4, r5, pc}
	.align 2, 0
_020115CC: .4byte 0x02347C20
_020115D0: .4byte 0x00001771
	arm_func_end FUN_020114CC

	arm_func_start FUN_020115D4
FUN_020115D4: @ 0x020115D4
	push {r4, r5, r6, lr}
	mov r5, r1
	mov r1, #0x590
	mul r4, r5, r1
	ldr r1, _02011638 @ =0x02347C20
	mov r6, r0
	ldr r0, [r1, #0xc]
	ldrh r1, [r6, #0x48]
	add r0, r0, r4
	add r0, r0, #0x500
	ldrh r0, [r0, #0x18]
	cmp r1, r0
	popeq {r4, r5, r6, pc}
	mov r0, r5
	bl FUN_02011B64
	ldr r1, _02011638 @ =0x02347C20
	mov r0, r6
	ldr r1, [r1, #0xc]
	mov r2, #0xc0
	add r1, r1, #0x4d0
	add r1, r1, r4
	bl FUN_0200A0B0
	mov r0, r5
	bl FUN_02011A4C
	pop {r4, r5, r6, pc}
	.align 2, 0
_02011638: .4byte 0x02347C20
	arm_func_end FUN_020115D4

	arm_func_start FUN_0201163C
FUN_0201163C: @ 0x0201163C
	push {r3, r4, r5, lr}
	mov r5, r0
	mov r1, #0x590
	mul r4, r5, r1
	ldr r1, _02011694 @ =0x02347C20
	ldr r2, [r1, #0xc]
	ldr r3, [r1, #8]
	add r1, r2, r4
	ldrb r2, [r3, #5]
	ldrb r1, [r1, #0x4c3]
	cmp r2, r1
	popeq {r3, r4, r5, pc}
	bl FUN_02011B64
	mov r0, r5
	bl FUN_02011A4C
	ldr r0, _02011694 @ =0x02347C20
	ldr r1, [r0, #8]
	ldr r0, [r0, #0xc]
	ldrb r1, [r1, #5]
	add r0, r0, r4
	strb r1, [r0, #0x4c3]
	pop {r3, r4, r5, pc}
	.align 2, 0
_02011694: .4byte 0x02347C20
	arm_func_end FUN_0201163C

	arm_func_start FUN_02011698
FUN_02011698: @ 0x02011698
	push {r3, lr}
	ldr r2, _020116C8 @ =0x02347C20
	mov r1, #0x590
	ldr r3, [r2, #0xc]
	ldr r2, [r2, #8]
	mla r1, r0, r1, r3
	ldrb r2, [r2, #6]
	ldrb r1, [r1, #0x4c4]
	cmp r2, r1
	popeq {r3, pc}
	bl FUN_02011A4C
	pop {r3, pc}
	.align 2, 0
_020116C8: .4byte 0x02347C20
	arm_func_end FUN_02011698

	arm_func_start FUN_020116CC
FUN_020116CC: @ 0x020116CC
	push {r3, r4, r5, r6, r7, lr}
	mov ip, #0
	ldr r4, _02011768 @ =0x02347C20
	mov lr, ip
	mov r5, ip
	mov r2, #1
_020116E4:
	ldr r3, [r4, #0xc]
	ldrh r1, [r3]
	tst r1, r2, lsl ip
	beq _02011754
	add r1, r3, #0xd4
	add r1, r1, #0x400
	ldrb r6, [r1, lr]
	ldrb r7, [r0]
	add r1, r1, lr
	cmp r7, r6
	ldrbeq r7, [r0, #1]
	ldrbeq r6, [r1, #1]
	cmpeq r7, r6
	ldrbeq r7, [r0, #2]
	ldrbeq r6, [r1, #2]
	cmpeq r7, r6
	ldrbeq r7, [r0, #3]
	ldrbeq r6, [r1, #3]
	cmpeq r7, r6
	ldrbeq r7, [r0, #4]
	ldrbeq r6, [r1, #4]
	cmpeq r7, r6
	ldrbeq r6, [r0, #5]
	ldrbeq r1, [r1, #5]
	cmpeq r6, r1
	addeq r1, r3, lr
	addeq r1, r1, #0x500
	strheq r5, [r1, #0x9a]
_02011754:
	add ip, ip, #1
	cmp ip, #0x10
	add lr, lr, #0x590
	blt _020116E4
	pop {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_02011768: .4byte 0x02347C20
	arm_func_end FUN_020116CC

	arm_func_start FUN_0201176C
FUN_0201176C: @ 0x0201176C
	push {r4, lr}
	ldr r2, _02011838 @ =0x02347C20
	mov r1, #0x590
	ldr r4, [r2, #0xc]
	ldr r3, [r2, #8]
	add r2, r4, #0x10
	mla r4, r0, r1, r2
	ldrb r2, [r4, #0x4b3]
	ldrb r1, [r3, #5]
	add r0, r4, #0x358
	cmp r2, r1
	bne _020117B0
	ldrb r1, [r3, #0xa]
	ldr ip, [r4, #0x580]
	mov r2, #1
	tst ip, r2, lsl r1
	popne {r4, pc}
_020117B0:
	ldr r2, _02011838 @ =0x02347C20
	ldrb r1, [r3, #4]
	ldr r2, [r2, #8]
	lsl r1, r1, #0x1e
	lsrs r1, r1, #0x1e
	ldrb ip, [r2, #0xa]
	moveq lr, r4
	addne lr, r4, #0x220
	mov r1, #0x62
	mla r1, ip, r1, lr
	ldrb r2, [r2, #0xc]
	add ip, r1, r2
	cmp ip, r0
	pophi {r4, pc}
	add r0, r3, #0xe
	bl FUN_0200A0B0
	ldr r0, _02011838 @ =0x02347C20
	mov r2, #1
	ldr r1, [r0, #8]
	ldrb r1, [r1, #4]
	lsl r1, r1, #0x1e
	lsr r1, r1, #0x1e
	strb r1, [r4, #0x4b2]
	ldr r1, [r0, #8]
	ldr r3, [r4, #0x580]
	ldrb r1, [r1, #0xa]
	orr r1, r3, r2, lsl r1
	str r1, [r4, #0x580]
	ldr r0, [r0, #8]
	ldrb r0, [r0, #0xb]
	lsl r0, r2, r0
	sub r0, r0, #1
	str r0, [r4, #0x584]
	pop {r4, pc}
	.align 2, 0
_02011838: .4byte 0x02347C20
	arm_func_end FUN_0201176C

	arm_func_start FUN_0201183C
FUN_0201183C: @ 0x0201183C
	push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
	ldr r1, _02011A44 @ =0x02347C20
	mov sl, r0
	ldr r2, [r1, #0xc]
	mov r0, #0x590
	add r2, r2, #0x10
	mla r5, sl, r0, r2
	mov r3, #0
_0201185C:
	ldr r2, [r1, #8]
	add r0, r5, r3
	add r2, r2, r3
	ldrb r2, [r2, #0x68]
	add r3, r3, #1
	cmp r3, #8
	strb r2, [r0, #0x4a8]
	blt _0201185C
	ldr r0, _02011A44 @ =0x02347C20
	add r1, r5, #0x510
	ldr r0, [r0, #8]
	mov r2, #0x70
	bl FUN_0200A0B0
	ldr r4, _02011A44 @ =0x02347C20
	ldrb r0, [r5, #0x4b4]
	ldr r2, [r4, #8]
	ldrb r1, [r2, #6]
	cmp r0, r1
	beq _02011988
	add r0, r0, #1
	and r0, r0, #0xff
	cmp r0, r1
	add r0, r5, #0x5e
	bne _0201193C
	mov sb, #0
	add r8, r0, #0x300
	mov r6, sb
	mov fp, #0x16
	mov r7, #2
_020118D0:
	ldr r0, [r4, #8]
	ldrh r0, [r0, #0xe]
	tst r0, r7, lsl sb
	beq _020118F0
	mov r0, r6
	mov r1, r8
	mov r2, fp
	bl FUN_0200A098
_020118F0:
	add sb, sb, #1
	cmp sb, #0xf
	add r8, r8, #0x16
	blt _020118D0
	ldr r1, _02011A44 @ =0x02347C20
	add r0, r5, #0x500
	ldr r3, [r1, #8]
	mov r2, #1
	ldrh r3, [r3, #0xe]
	ldrh r4, [r0, #0x88]
	mvn r2, r2, lsl sl
	mvn r3, r3
	and r3, r4, r3
	strh r3, [r0, #0x88]
	ldr r1, [r1, #0xc]
	ldrh r0, [r1, #4]
	and r0, r0, r2
	strh r0, [r1, #4]
	b _02011974
_0201193C:
	ldr r2, _02011A48 @ =0x0000014A
	add r1, r0, #0x300
	mov r0, #0
	bl FUN_0200A098
	add r0, r5, #0x500
	mov r3, #0
	mov r1, r4
	strh r3, [r0, #0x88]
	ldr r3, [r1, #0xc]
	mov r2, #1
	ldrh r1, [r3, #4]
	mvn r0, r2, lsl sl
	and r0, r1, r0
	strh r0, [r3, #4]
_02011974:
	ldr r0, _02011A44 @ =0x02347C20
	ldr r0, [r0, #8]
	ldrb r0, [r0, #6]
	strb r0, [r5, #0x4b4]
	b _0201199C
_02011988:
	add r0, r5, #0x500
	ldrh r1, [r0, #0x88]
	ldrh r0, [r2, #0xc]
	cmp r1, r0
	popeq {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
_0201199C:
	ldr r4, _02011A44 @ =0x02347C20
	add r1, r5, #0x188
	ldr r0, [r4, #8]
	mov sl, #0
	ldrb r3, [r0, #0xa]
	add r0, r5, #0x300
	add r7, r1, #0x400
	strb r3, [r5, #0x358]
	ldr r3, [r4, #8]
	add r2, r5, #0x500
	ldrh r3, [r3, #0xc]
	mov sb, sl
	mov fp, #0x16
	strh r3, [r0, #0x5a]
	ldr r1, [r4, #8]
	ldrh r1, [r1, #0xe]
	strh r1, [r0, #0x5c]
	ldrh r0, [r2, #0x88]
	orr r0, r0, #1
	strh r0, [r2, #0x88]
	add r0, r5, #0x5e
	add r6, r0, #0x300
	mov r5, #1
_020119F8:
	ldr r0, [r4, #8]
	add r0, r0, #0x10
	ldrb r1, [r0, sb]
	lsl r1, r1, #0x18
	lsrs r8, r1, #0x1c
	beq _02011A30
	sub r2, r8, #1
	mla r1, r2, fp, r6
	mov r2, #0x16
	add r0, r0, sb
	bl FUN_0200A0B0
	ldrh r0, [r7]
	orr r0, r0, r5, lsl r8
	strh r0, [r7]
_02011A30:
	add sl, sl, #1
	cmp sl, #4
	add sb, sb, #0x16
	blo _020119F8
	pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
	.align 2, 0
_02011A44: .4byte 0x02347C20
_02011A48: .4byte 0x0000014A
	arm_func_end FUN_0201183C

	arm_func_start FUN_02011A4C
FUN_02011A4C: @ 0x02011A4C
	push {r4, lr}
	ldr r1, _02011AB8 @ =0x02347C20
	mov r4, r0
	ldr r3, [r1, #0xc]
	ldrh r0, [r3, #6]
	cmp r0, #0
	popne {r4, pc}
	ldr r2, [r1, #4]
	cmp r2, #0
	beq _02011A88
	add r0, r3, #0xd4
	add r1, r0, #0x400
	mov r0, #0x590
	mla r0, r4, r0, r1
	.word 0xE12FFF32
_02011A88:
	ldr r0, _02011AB8 @ =0x02347C20
	mov r1, #1
	ldr r2, [r0, #0xc]
	mov r3, #0x16
	strh r3, [r2, #0xc]
	lsl r3, r1, r4
	ldr r2, [r0, #0xc]
	add r1, r1, #0x320
	strh r3, [r2, #6]
	ldr r0, [r0, #0xc]
	strh r1, [r0, #8]
	pop {r4, pc}
	.align 2, 0
_02011AB8: .4byte 0x02347C20
	arm_func_end FUN_02011A4C

	arm_func_start FUN_02011ABC
FUN_02011ABC: @ 0x02011ABC
	push {r3, lr}
	ldr r0, _02011B0C @ =0x02347C20
	ldr r1, [r0, #0xc]
	ldrh r1, [r1, #6]
	cmp r1, #0
	popeq {r3, pc}
	ldr r0, [r0]
	cmp r0, #0
	beq _02011AE4
	.word 0xE12FFF30
_02011AE4:
	ldr r0, _02011B0C @ =0x02347C20
	mov r3, #1
	ldr r1, [r0, #0xc]
	mov r2, #0
	strh r3, [r1, #0xc]
	ldr r1, [r0, #0xc]
	strh r2, [r1, #6]
	ldr r0, [r0, #0xc]
	strh r2, [r0, #0xa]
	pop {r3, pc}
	.align 2, 0
_02011B0C: .4byte 0x02347C20
	arm_func_end FUN_02011ABC

	arm_func_start FUN_02011B10
FUN_02011B10: @ 0x02011B10
	push {r4, lr}
	ldr r1, _02011B60 @ =0x02347C20
	mov r3, r0
	ldr r2, [r1, #0xc]
	mov ip, #1
	ldrh r0, [r2, #2]
	mvn r4, ip, lsl r3
	and r0, r0, r4
	strh r0, [r2, #2]
	ldr lr, [r1, #0xc]
	mov r2, #0x590
	ldrh ip, [lr, #4]
	mov r0, #0
	and ip, ip, r4
	strh ip, [lr, #4]
	ldr r1, [r1, #0xc]
	add r1, r1, #0x10
	mla r1, r3, r2, r1
	bl FUN_0200A098
	pop {r4, pc}
	.align 2, 0
_02011B60: .4byte 0x02347C20
	arm_func_end FUN_02011B10

	arm_func_start FUN_02011B64
FUN_02011B64: @ 0x02011B64
	push {r4, lr}
	ldr ip, _02011BF0 @ =0x02347C20
	mov lr, #1
	ldr r3, [ip, #0xc]
	mov r1, #0x590
	ldrh r2, [r3, #2]
	mvn r4, lr, lsl r0
	and r2, r2, r4
	strh r2, [r3, #2]
	ldr lr, [ip, #0xc]
	mul r1, r0, r1
	ldrh r3, [lr, #4]
	mov r0, #0
	mov r2, #0x4c0
	and r3, r3, r4
	strh r3, [lr, #4]
	ldr r3, [ip, #0xc]
	add r3, r3, r1
	str r0, [r3, #0x590]
	ldr r3, [ip, #0xc]
	add r3, r3, r1
	str r0, [r3, #0x594]
	ldr r3, [ip, #0xc]
	add r3, r3, r1
	add r3, r3, #0x500
	strh r0, [r3, #0x98]
	ldr r3, [ip, #0xc]
	add r3, r3, r1
	add r3, r3, #0x500
	strh r0, [r3, #0x9c]
	ldr r3, [ip, #0xc]
	add r3, r3, #0x10
	add r1, r3, r1
	bl FUN_0200A098
	pop {r4, pc}
	.align 2, 0
_02011BF0: .4byte 0x02347C20
	arm_func_end FUN_02011B64

	arm_func_start FUN_02011BF4
FUN_02011BF4: @ 0x02011BF4
	push {r3, r4, r5, lr}
	mov r4, r0
	bl FUN_0200F4B8
	cmp r0, #0
	moveq r0, #0
	popeq {r3, r4, r5, pc}
	ldrh lr, [r4, #4]
	mov r2, #1
	mov ip, #0
	mov r5, lr
	mov r3, r2
_02011C20:
	sub r1, r5, #1
	tst r0, r3, lsl r1
	cmpne lr, r5
	strhne r5, [r4, #4]
	bne _02011C5C
	add r1, ip, #1
	lsl r1, r1, #0x10
	cmp r5, #0x10
	lsr ip, r1, #0x10
	moveq r1, r2
	addne r1, r5, #1
	lsl r1, r1, #0x10
	cmp ip, #0x10
	lsr r5, r1, #0x10
	blo _02011C20
_02011C5C:
	mov r0, #1
	pop {r3, r4, r5, pc}
	arm_func_end FUN_02011BF4

	arm_func_start FUN_02011C64
FUN_02011C64: @ 0x02011C64
	ldr r1, _02011CC0 @ =0x0234D6C0
	mov r0, #0
	ldr ip, [r1, #8]
	mov r3, r0
	add r1, ip, #0x500
	ldrh r1, [r1, #0x28]
	mov r2, r0
	cmp r1, #1
	ldrbeq r1, [ip, #0x50c]
	cmpeq r1, #0
	moveq r3, #1
	cmp r3, #0
	beq _02011CA8
	add r1, ip, #0x500
	ldrh r1, [r1, #0x26]
	cmp r1, #0
	moveq r2, #1
_02011CA8:
	cmp r2, #0
	addne r1, ip, #0x500
	ldrhne r1, [r1, #0x2a]
	cmpne r1, #0
	movne r0, #1
	bx lr
	.align 2, 0
_02011CC0: .4byte 0x0234D6C0
	arm_func_end FUN_02011C64

	arm_func_start FUN_02011CC4
FUN_02011CC4: @ 0x02011CC4
	push {r3, lr}
	ldr r0, _02011D0C @ =0x0230D154
	bl FUN_0200F724
	mov r1, r0
	mov r0, #0x80
	bl FUN_020135DC
	ldr r3, _02011D10 @ =0x0231CF40
	ldr r0, _02011D0C @ =0x0230D154
	ldrh r1, [r3, #4]
	str r1, [sp]
	ldrh r1, [r3, #6]
	ldrh r2, [r3, #2]
	ldrh r3, [r3]
	bl FUN_0200FFD0
	mov r1, r0
	mov r0, #0x1d
	bl FUN_020135DC
	pop {r3, pc}
	.align 2, 0
_02011D0C: .4byte 0x0230D154
_02011D10: .4byte 0x0231CF40
	arm_func_end FUN_02011CC4

	arm_func_start FUN_02011D14
FUN_02011D14: @ 0x02011D14
	push {r3, r4, lr}
	sub sp, sp, #0x1c
	mov r4, r0
	ldrh r0, [r4]
	cmp r0, #0x19
	bgt _02011D7C
	bge _02011E58
	cmp r0, #0xf
	addls pc, pc, r0, lsl #2
	b _02012484
_02011D3C: @ jump table
	b _02011D98 @ case 0
	b _02012284 @ case 1
	b _02012318 @ case 2
	b _02012484 @ case 3
	b _02012484 @ case 4
	b _02012484 @ case 5
	b _02012484 @ case 6
	b _02011E20 @ case 7
	b _02011EA8 @ case 8
	b _02012484 @ case 9
	b _02012484 @ case 10
	b _02012484 @ case 11
	b _02012484 @ case 12
	b _0201238C @ case 13
	b _020120FC @ case 14
	b _02012188 @ case 15
_02011D7C:
	cmp r0, #0x1d
	bgt _02011D8C
	beq _02011DD0
	b _02012484
_02011D8C:
	cmp r0, #0x80
	beq _020123C4
	b _02012484
_02011D98:
	ldrh r0, [r4, #2]
	cmp r0, #0
	beq _02011DC4
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011DC4:
	bl FUN_02011CC4
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011DD0:
	ldrh r0, [r4, #2]
	cmp r0, #0
	beq _02011DFC
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011DFC:
	ldr r1, _020124A4 @ =0x0234D6C0
	ldr r0, _020124A8 @ =0x0230D154
	ldr r1, [r1, #8]
	bl FUN_0200FA54
	mov r1, r0
	mov r0, #7
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011E20:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x15
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	ldr r0, _020124A8 @ =0x0230D154
	mov r1, #1
	bl FUN_0201003C
	mov r1, r0
	mov r0, #0x19
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011E58:
	ldrh r0, [r4, #2]
	cmp r0, #0
	beq _02011E84
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011E84:
	ldr r1, _020124AC @ =0x0231CF40
	ldr r0, _020124A8 @ =0x0230D154
	ldr r1, [r1, #0xc]
	bl FUN_0200F994
	mov r1, r0
	mov r0, #8
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011EA8:
	ldrh r0, [r4, #2]
	cmp r0, #0
	beq _02011ED4
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02011ED4:
	ldrh r0, [r4, #8]
	cmp r0, #7
	bgt _02011F04
	bge _02011F4C
	cmp r0, #2
	bgt _020120DC
	cmp r0, #0
	blt _020120DC
	beq _02011F24
	cmp r0, #2
	beq _020120A8
	b _020120DC
_02011F04:
	cmp r0, #9
	bgt _02011F14
	beq _0201206C
	b _020120DC
_02011F14:
	cmp r0, #0x1a
	addeq sp, sp, #0x1c
	popeq {r3, r4, pc}
	b _020120DC
_02011F24:
	ldr r1, _020124A4 @ =0x0234D6C0
	mov r2, #0
	ldr r0, [r1, #8]
	add sp, sp, #0x1c
	add r0, r0, #0x500
	strh r2, [r0, #0x2a]
	ldr r0, [r1, #8]
	add r0, r0, #0x500
	strh r2, [r0, #0x28]
	pop {r3, r4, pc}
_02011F4C:
	ldr r2, _020124A4 @ =0x0234D6C0
	ldr r0, [r2, #8]
	add r0, r0, #0x500
	ldrh r1, [r0, #0x26]
	cmp r1, #1
	addeq sp, sp, #0x1c
	popeq {r3, r4, pc}
	ldrh lr, [r0, #0x2a]
	ldrh r3, [r4, #0x10]
	mov ip, #1
	mov r1, r4
	orr r3, lr, ip, lsl r3
	strh r3, [r0, #0x2a]
	ldr r2, [r2, #8]
	mov r0, #0
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	ldr r1, _020124A4 @ =0x0234D6C0
	ldr r0, [r1, #8]
	add r0, r0, #0x500
	ldrh r0, [r0, #0x28]
	cmp r0, #0
	bne _0201203C
	ldr r0, [r1, #0xc]
	add r0, r0, #0x1000
	ldr r2, [r0, #0x31c]
	cmp r2, #0
	bne _0201203C
	mov r2, #1
	str r2, [r0, #0x31c]
	ldr r0, [r1, #8]
	ldr r1, _020124A4 @ =0x0234D6C0
	add r0, r0, #0x500
	ldrh r0, [r0, #0x2c]
	ldr ip, [r1, #8]
	mov r1, #1
	cmp r0, #0
	movne r2, #0
	lsl r0, r2, #0x10
	lsr r3, r0, #0x10
	add r0, ip, #0x500
	ldrh r4, [r0, #0x18]
	mov r2, #0
	str r4, [sp]
	str r3, [sp, #4]
	str r2, [sp, #8]
	str r2, [sp, #0xc]
	str r2, [sp, #0x10]
	str r1, [sp, #0x14]
	str r1, [sp, #0x18]
	ldrh r2, [r0, #0x1a]
	ldr r1, [ip, #0x504]
	ldr r0, _020124A8 @ =0x0230D154
	add r3, ip, #0x40
	bl FUN_0200FDA8
	mov r1, r0
	mov r0, #0xe
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_0201203C:
	bl FUN_02011C64
	cmp r0, #0
	addeq sp, sp, #0x1c
	popeq {r3, r4, pc}
	ldr r1, _020124A4 @ =0x0234D6C0
	mov r0, #0x19
	ldr r2, [r1, #8]
	mov r1, #0
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_0201206C:
	ldr r2, _020124A4 @ =0x0234D6C0
	ldrh r3, [r4, #0x10]
	ldr r1, [r2, #8]
	mov r0, #1
	add r1, r1, #0x500
	ldrh ip, [r1, #0x2a]
	mvn r3, r0, lsl r3
	and r3, ip, r3
	strh r3, [r1, #0x2a]
	ldr r2, [r2, #8]
	mov r1, r4
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_020120A8:
	ldr r0, _020124A4 @ =0x0234D6C0
	ldr r1, [r0, #8]
	add r0, r1, #0x500
	ldrh r0, [r0, #0x26]
	cmp r0, #1
	addeq sp, sp, #0x1c
	popeq {r3, r4, pc}
	ldr r2, [r1, #0x51c]
	mov r1, r4
	mov r0, #0x1c
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_020120DC:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_020120FC:
	ldr r2, _020124A4 @ =0x0234D6C0
	mov r1, #0
	ldr r0, [r2, #0xc]
	add r0, r0, #0x1000
	str r1, [r0, #0x31c]
	ldrh r0, [r4, #4]
	cmp r0, #0xa
	beq _02012128
	cmp r0, #0xb
	beq _02012150
	b _0201216C
_02012128:
	ldr r0, [r2, #8]
	mov r3, #1
	add r0, r0, #0x500
	strh r3, [r0, #0x28]
	ldr r2, [r2, #8]
	mov r0, #0x19
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012150:
	ldr r0, [r2, #8]
	ldr r1, [r4, #8]
	ldr r2, [r0, #0x51c]
	mov r0, #3
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_0201216C:
	ldr r0, [r2, #8]
	mov r1, r4
	ldr r2, [r0, #0x51c]
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012188:
	ldr r0, _020124A4 @ =0x0234D6C0
	ldr r3, [r0, #0xc]
	add r0, r3, #0x7000
	ldr r0, [r0, #0x4c8]
	cmp r0, #0
	beq _020121E4
	mov r2, #0
	mov r1, r2
_020121A8:
	add r0, r3, r1, lsl #2
	add r0, r0, #0x1000
	ldr r0, [r0, #0x4e8]
	cmp r0, #0
	beq _020121C8
	add r2, r2, #1
	cmp r2, #2
	bhs _020121D4
_020121C8:
	add r1, r1, #1
	cmp r1, #0xf
	blo _020121A8
_020121D4:
	cmp r2, #1
	bne _020121E4
	ldr r0, _020124B0 @ =0x000032C8
	bl _02009B00
_020121E4:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r2, #0
	ldr r1, [r0, #8]
	strb r2, [r1, #0x50c]
	ldrh r1, [r4, #2]
	cmp r1, #0
	bne _02012234
	ldr r0, [r0, #8]
	mov r1, r4
	ldr r2, [r0, #0x51c]
	mov r0, #2
	.word 0xE12FFF32
	ldr r1, _020124A4 @ =0x0234D6C0
	mov r0, #0x19
	ldr r2, [r1, #8]
	mov r1, #0
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012234:
	cmp r1, #0xa
	ldr r0, [r0, #8]
	mov r1, r4
	bne _02012258
	ldr r2, [r0, #0x51c]
	mov r0, #0x2a
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012258:
	ldr r2, [r0, #0x51c]
	mov r0, #0x13
	.word 0xE12FFF32
	ldr r1, _020124A4 @ =0x0234D6C0
	mov r0, #0x19
	ldr r2, [r1, #8]
	mov r1, #0
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012284:
	ldr r1, _020124A4 @ =0x0234D6C0
	ldr r0, [r1, #0xc]
	add r0, r0, #0x1000
	ldr r0, [r0, #0x320]
	cmp r0, #0
	bne _02012300
	ldrh r0, [r4, #2]
	mov r2, #0
	cmp r0, #0
	ldr r0, [r1, #8]
	add r0, r0, #0x500
	beq _020122D4
	strh r2, [r0, #0x26]
	ldr r0, [r1, #8]
	mov r1, r4
	ldr r2, [r0, #0x51c]
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_020122D4:
	strh r2, [r0, #0x2a]
	ldr r1, [r1, #8]
	ldr r0, _020124A8 @ =0x0230D154
	add r1, r1, #0x500
	strh r2, [r1, #0x28]
	bl FUN_0200FB5C
	mov r1, r0
	mov r0, #2
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012300:
	mov r1, #0
	mov r2, r1
	mov r0, #1
	bl FUN_0200F644
	mov r0, #0
	bl FUN_0200F724
_02012318:
	ldrh r0, [r4, #2]
	cmp r0, #0
	beq _02012354
	ldr r2, _020124A4 @ =0x0234D6C0
	mov r3, #0
	ldr r0, [r2, #8]
	mov r1, r4
	add r0, r0, #0x500
	strh r3, [r0, #0x26]
	ldr r2, [r2, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012354:
	ldr r3, _020124A4 @ =0x0234D6C0
	mov ip, #0
	ldr r0, [r3, #8]
	mov r1, r4
	strb ip, [r0, #0x50d]
	ldr r2, [r3, #0xc]
	mov r0, #0x11
	add r2, r2, #0x1300
	strh ip, [r2, #0x16]
	ldr r2, [r3, #8]
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_0201238C:
	ldrh r0, [r4, #2]
	cmp r0, #0
	addne sp, sp, #0x1c
	popne {r3, r4, pc}
	ldr r0, _020124A4 @ =0x0234D6C0
	ldrh r1, [r4, #0xa]
	ldr r0, [r0, #8]
	add sp, sp, #0x1c
	add r0, r0, #0x500
	ldrh r2, [r0, #0x2a]
	mvn r1, r1
	and r1, r2, r1
	strh r1, [r0, #0x2a]
	pop {r3, r4, pc}
_020123C4:
	ldrh r0, [r4, #4]
	sub r0, r0, #0x10
	cmp r0, #7
	addls pc, pc, r0, lsl #2
	b _0201249C
_020123D8: @ jump table
	b _020123F8 @ case 0
	b _02012418 @ case 1
	b _02012438 @ case 2
	b _02012458 @ case 3
	b _0201249C @ case 4
	b _0201249C @ case 5
	b _02012478 @ case 6
	b _0201249C @ case 7
_020123F8:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x1d
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012418:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x1f
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012438:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x20
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012458:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x21
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012478:
	bl FUN_02009D48
	add sp, sp, #0x1c
	pop {r3, r4, pc}
_02012484:
	ldr r0, _020124A4 @ =0x0234D6C0
	mov r1, r4
	ldr r2, [r0, #8]
	mov r0, #0x100
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
_0201249C:
	add sp, sp, #0x1c
	pop {r3, r4, pc}
	.align 2, 0
_020124A4: .4byte 0x0234D6C0
_020124A8: .4byte 0x0230D154
_020124AC: .4byte 0x0231CF40
_020124B0: .4byte 0x000032C8
	arm_func_end FUN_02011D14

	arm_func_start FUN_020124B4
FUN_020124B4: @ 0x020124B4
	push {r3, lr}
	mov r1, r0
	ldrh r0, [r1, #2]
	cmp r0, #0
	popne {r3, pc}
	ldrh r0, [r1, #4]
	cmp r0, #0x15
	bgt _020124F0
	bge _02012508
	cmp r0, #9
	popgt {r3, pc}
	cmp r0, #7
	poplt {r3, pc}
	cmpne r0, #9
	pop {r3, pc}
_020124F0:
	cmp r0, #0x1a
	popgt {r3, pc}
	cmp r0, #0x19
	poplt {r3, pc}
	cmpne r0, #0x1a
	pop {r3, pc}
_02012508:
	ldr r2, _02012520 @ =0x0234D6C0
	mov r0, #9
	ldr r2, [r2, #8]
	ldr r2, [r2, #0x51c]
	.word 0xE12FFF32
	pop {r3, pc}
	.align 2, 0
_02012520: .4byte 0x0234D6C0
	arm_func_end FUN_020124B4

	arm_func_start FUN_02012524
FUN_02012524: @ 0x02012524
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x1c
	mov r6, r0
	ldrh r0, [r6]
	ldr r1, _02012D40 @ =0x0234D6C0
	cmp r0, #0x1d
	ldr r4, [r1, #8]
	bgt _020125B0
	cmp r0, #0x1d
	bge _0201261C
	cmp r0, #0x15
	addls pc, pc, r0, lsl #2
	b _02012D28
_02012558: @ jump table
	b _020125BC @ case 0
	b _02012C20 @ case 1
	b _02012C80 @ case 2
	b _02012D28 @ case 3
	b _02012D28 @ case 4
	b _02012D28 @ case 5
	b _02012D28 @ case 6
	b _02012D28 @ case 7
	b _02012D28 @ case 8
	b _02012D28 @ case 9
	b _020126B8 @ case 10
	b _02012980 @ case 11
	b _020129D0 @ case 12
	b _02012D28 @ case 13
	b _02012B48 @ case 14
	b _02012BBC @ case 15
	b _02012D28 @ case 16
	b _02012D28 @ case 17
	b _02012D28 @ case 18
	b _02012D28 @ case 19
	b _02012D28 @ case 20
	b _02012CDC @ case 21
_020125B0:
	cmp r0, #0x80
	beq _02012D04
	b _02012D28
_020125BC:
	ldrh r0, [r6, #2]
	ldr r2, [r4, #0x51c]
	mov r1, r6
	cmp r0, #0
	beq _020125E0
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_020125E0:
	mov r0, #0x15
	.word 0xE12FFF32
	ldr r3, _02012D44 @ =0x0231CF40
	ldr r0, _02012D48 @ =0x0230D964
	ldrh r1, [r3, #4]
	str r1, [sp]
	ldrh r1, [r3, #6]
	ldrh r2, [r3, #2]
	ldrh r3, [r3]
	bl FUN_0200FFD0
	mov r1, r0
	mov r0, #0x1d
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_0201261C:
	ldrh r0, [r6, #2]
	cmp r0, #0
	beq _02012640
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012640:
	add r0, r4, #0x440
	str r0, [r1, #0x20]
	ldrh r0, [r1, #0x24]
	mov r2, #1
	cmp r0, #0
	moveq r0, #1
	strheq r0, [r1, #0x24]
	ldr r0, _02012D40 @ =0x0234D6C0
	ldrh r1, [r0, #0x26]
	cmp r1, #0
	moveq r1, #0xc8
	strheq r1, [r0, #0x26]
	ldr r0, _02012D40 @ =0x0234D6C0
	mov r1, #0xff
	strb r1, [r0, #0x28]
	strb r1, [r0, #0x29]
	strb r1, [r0, #0x2a]
	strb r1, [r0, #0x2b]
	strb r1, [r0, #0x2c]
	strb r1, [r0, #0x2d]
	str r2, [r4, #0x5e4]
	ldr r0, _02012D48 @ =0x0230D964
	ldr r1, _02012D4C @ =0x0234D6E0
	str r2, [r4, #0x5e8]
	bl FUN_0200F894
	mov r1, r0
	mov r0, #0xa
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_020126B8:
	ldrh r0, [r6, #2]
	cmp r0, #0
	beq _020126DC
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_020126DC:
	ldrh r0, [r6, #8]
	cmp r0, #3
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	cmp r0, #4
	beq _02012908
	cmp r0, #5
	bne _02012968
	add ip, r4, #0x600
	mov r5, #0
	add r0, r4, #0x500
	mov fp, #0x180
	b _02012838
_02012710:
	mla r2, r5, fp, ip
	ldrb r3, [r6, #0xa]
	ldrb r1, [r2, #0xca]
	mov lr, #0
	mov sl, lr
	cmp r3, r1
	ldrbeq r1, [r2, #0xcb]
	ldrbeq r2, [r6, #0xb]
	mov r7, lr
	mov r8, lr
	cmpeq r2, r1
	moveq sl, #1
	mov sb, lr
	cmp sl, #0
	beq _02012764
	mov r2, #0x180
	mla r2, r5, r2, ip
	ldrb r1, [r6, #0xc]
	ldrb r2, [r2, #0xcc]
	cmp r1, r2
	moveq sb, #1
_02012764:
	cmp sb, #0
	beq _02012784
	mov r1, #0x180
	mla r1, r5, r1, ip
	ldrb r2, [r6, #0xd]
	ldrb r1, [r1, #0xcd]
	cmp r2, r1
	moveq r8, #1
_02012784:
	cmp r8, #0
	beq _020127A4
	mov r1, #0x180
	mla r1, r5, r1, ip
	ldrb r2, [r6, #0xe]
	ldrb r1, [r1, #0xce]
	cmp r2, r1
	moveq r7, #1
_020127A4:
	cmp r7, #0
	beq _020127C4
	mov r1, #0x180
	mla r1, r5, r1, ip
	ldrb r2, [r6, #0xf]
	ldrb r1, [r1, #0xcf]
	cmp r2, r1
	moveq lr, #1
_020127C4:
	cmp lr, #0
	beq _02012834
	mov r0, #0x180
	mla r0, r5, r0, ip
	ldrh r1, [r6, #0x36]
	add sb, r6, #0x38
	add r8, r0, #0xf8
	strh r1, [r0, #0xf6]
	mov r7, #8
_020127E8:
	ldm sb!, {r0, r1, r2, r3}
	stm r8!, {r0, r1, r2, r3}
	subs r7, r7, #1
	bne _020127E8
	add r1, r4, #0x600
	mov r0, #0x180
	mla r0, r5, r0, r1
	mov r1, #0xc0
	bl FUN_02008C5C
	ldr r1, _02012D40 @ =0x0234D6C0
	add r2, r4, #0x600
	mov r0, #0x180
	mla r2, r5, r0, r2
	ldrh r0, [r1]
	add r1, r4, #0x440
	mov r3, #0xc0
	bl FUN_02009F14
	str r5, [r4, #0x5ec]
	b _020128A8
_02012834:
	add r5, r5, #1
_02012838:
	ldrh r1, [r0, #0xe0]
	cmp r5, r1
	blt _02012710
	cmp r5, #0x10
	bge _020128A8
	mov r0, #0x180
	mla r1, r5, r0, ip
	mov r0, r6
	add r7, r5, #1
	add r3, r4, #0x500
	add r1, r1, #0xc0
	mov r2, #0xb8
	strh r7, [r3, #0xe0]
	bl FUN_0200A0B0
	add r1, r4, #0x600
	mov r0, #0x180
	mla r0, r5, r0, r1
	mov r1, #0xc0
	bl FUN_02008C5C
	ldr r1, _02012D40 @ =0x0234D6C0
	add r2, r4, #0x600
	mov r0, #0x180
	mla r2, r5, r0, r2
	ldrh r0, [r1]
	add r1, r4, #0x440
	mov r3, #0xc0
	bl FUN_02009F14
	str r5, [r4, #0x5ec]
_020128A8:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #4
	.word 0xE12FFF32
	ldr r0, [r4, #0x5e4]
	cmp r0, #0
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	ldr r0, [r4, #0x5e8]
	cmp r0, #0
	beq _020128E8
	ldr r0, _02012D4C @ =0x0234D6E0
	bl FUN_02011BF4
	cmp r0, #0
	bne _020128E8
	bl FUN_020131A4
_020128E8:
	ldr r0, _02012D48 @ =0x0230D964
	ldr r1, _02012D4C @ =0x0234D6E0
	bl FUN_0200F894
	mov r1, r0
	mov r0, #0xa
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012908:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #5
	.word 0xE12FFF32
	ldr r0, [r4, #0x5e4]
	cmp r0, #0
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	ldr r0, [r4, #0x5e8]
	cmp r0, #0
	beq _02012948
	ldr r0, _02012D4C @ =0x0234D6E0
	bl FUN_02011BF4
	cmp r0, #0
	bne _02012948
	bl FUN_020131A4
_02012948:
	ldr r0, _02012D48 @ =0x0230D964
	ldr r1, _02012D4C @ =0x0234D6E0
	bl FUN_0200F894
	mov r1, r0
	mov r0, #0xa
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012968:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012980:
	ldrh r0, [r6, #2]
	cmp r0, #0
	beq _020129A4
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_020129A4:
	ldr r1, [r4, #0x520]
	mov r2, #0
	ldr r0, _02012D48 @ =0x0230D964
	mov r3, #1
	str r2, [sp]
	bl FUN_0200F770
	mov r1, r0
	mov r0, #0xc
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_020129D0:
	ldrh r0, [r6, #2]
	cmp r0, #0
	beq _02012A00
	add r0, r4, #0x500
	mov r1, #0
	strh r1, [r0, #0xe0]
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0xb
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012A00:
	ldrh r0, [r6, #8]
	cmp r0, #9
	bgt _02012A2C
	cmp r0, #6
	blt _02012B30
	beq _02012A3C
	cmp r0, #7
	beq _02012A58
	cmp r0, #9
	beq _02012B08
	b _02012B30
_02012A2C:
	cmp r0, #0x1a
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	b _02012B30
_02012A3C:
	add r0, r4, #0x500
	mov r1, #0
	strh r1, [r0, #0x2a]
	mov r1, #1
	strh r1, [r0, #0x28]
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012A58:
	ldrh r2, [r6, #0xa]
	add r0, r4, #0x500
	mov r1, r6
	strh r2, [r0, #0xe2]
	ldr r2, [r4, #0x51c]
	mov r0, #6
	.word 0xE12FFF32
	ldr r1, _02012D50 @ =0x0230D8F4
	add r3, r4, #0x500
	mov r0, #1
	mov r2, #0
	strh r0, [r3, #0x2a]
	bl FUN_0200F644
	cmp r0, #0
	addne sp, sp, #0x1c
	popne {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	add r0, r4, #0x500
	ldrh r0, [r0, #0x2c]
	add r1, r4, #0x500
	ldrh r2, [r1, #0x18]
	cmp r0, #0
	movne r0, #0
	moveq r0, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r2, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #1
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	ldrh r2, [r1, #0x1a]
	ldr r1, [r4, #0x504]
	ldr r0, _02012D48 @ =0x0230D964
	add r3, r4, #0x40
	bl FUN_0200FDA8
	mov r1, r0
	mov r0, #0xe
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012B08:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0xa
	.word 0xE12FFF32
	add r0, r4, #0x500
	mov r1, #0
	strh r1, [r0, #0x2a]
	strh r1, [r0, #0x28]
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012B30:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012B48:
	ldrh r0, [r6, #4]
	cmp r0, #0xa
	beq _02012B70
	cmp r0, #0xc
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	cmp r0, #0xd
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	b _02012BA4
_02012B70:
	add r0, r4, #0x500
	mov r1, #1
	strh r1, [r0, #0x28]
	bl FUN_02011C64
	cmp r0, #0
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	ldr r2, [r4, #0x51c]
	mov r0, #0x19
	mov r1, #0
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012BA4:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012BBC:
	mov r0, #0
	strb r0, [r4, #0x50c]
	ldrh r0, [r6, #2]
	cmp r0, #0
	bne _02012BE4
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #8
	.word 0xE12FFF32
	b _02012C08
_02012BE4:
	cmp r0, #9
	ldr r2, [r4, #0x51c]
	mov r1, r6
	bne _02012C00
	mov r0, #0x29
	.word 0xE12FFF32
	b _02012C08
_02012C00:
	mov r0, #0x12
	.word 0xE12FFF32
_02012C08:
	ldr r2, [r4, #0x51c]
	mov r0, #0x19
	mov r1, #0
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012C20:
	ldrh r0, [r6, #2]
	cmp r0, #0
	add r0, r4, #0x500
	beq _02012C50
	mov r1, #0
	strh r1, [r0, #0x26]
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012C50:
	mov r2, #0
	strh r2, [r0, #0x2a]
	ldr r1, [r1, #8]
	ldr r0, _02012D48 @ =0x0230D964
	add r1, r1, #0x500
	strh r2, [r1, #0x28]
	bl FUN_0200FB5C
	mov r1, r0
	mov r0, #2
	bl FUN_020135DC
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012C80:
	ldrh r0, [r6, #2]
	cmp r0, #0
	beq _02012CB0
	add r0, r4, #0x500
	mov r1, #0
	strh r1, [r0, #0x26]
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012CB0:
	mov r2, #0
	strb r2, [r4, #0x50d]
	ldr r0, [r1, #0xc]
	mov r1, r6
	add r0, r0, #0x1300
	strh r2, [r0, #0x16]
	ldr r2, [r4, #0x51c]
	mov r0, #0x11
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012CDC:
	bl FUN_02011C64
	cmp r0, #0
	addeq sp, sp, #0x1c
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	ldr r2, [r4, #0x51c]
	mov r0, #0x19
	mov r1, #0
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012D04:
	ldrh r0, [r6, #4]
	cmp r0, #0x16
	beq _02012D1C
	add sp, sp, #0x1c
	cmp r0, #0x17
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012D1C:
	bl FUN_02009D48
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
_02012D28:
	ldr r2, [r4, #0x51c]
	mov r1, r6
	mov r0, #0x100
	.word 0xE12FFF32
	add sp, sp, #0x1c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
	.align 2, 0
_02012D40: .4byte 0x0234D6C0
_02012D44: .4byte 0x0231CF40
_02012D48: .4byte 0x0230D964
_02012D4C: .4byte 0x0234D6E0
_02012D50: .4byte 0x0230D8F4
	arm_func_end FUN_02012524

	arm_func_start FUN_02012D54
FUN_02012D54: @ 0x02012D54
	push {r3, lr}
	sub sp, sp, #8
	add r0, sp, #0
	bl FUN_02009C5C
	mov r1, #0
	add r2, sp, #0
	mov r3, r1
_02012D70:
	ldrb r0, [r2], #1
	add r1, r1, #1
	cmp r1, #6
	add r3, r3, r0
	blt _02012D70
	ldr r1, _02012DB4 @ =0x027FFC3C
	ldr r0, _02012DB8 @ =0xCCCCCCCD
	ldr r1, [r1]
	mov r2, #0x14
	add r1, r3, r1
	rsb r3, r1, r1, lsl #3
	umull r1, r0, r3, r0
	lsr r0, r0, #4
	umull r0, r1, r2, r0
	sub r0, r3, r0
	add sp, sp, #8
	pop {r3, pc}
	.align 2, 0
_02012DB4: .4byte 0x027FFC3C
_02012DB8: .4byte 0xCCCCCCCD
	arm_func_end FUN_02012D54

	arm_func_start FUN_02012DBC
FUN_02012DBC: @ 0x02012DBC
	push {r3, r4, r5, r6, r7, r8, sb, lr}
	ldr r4, _02012F94 @ =0x0234D6C0
	mov sb, r1
	ldr r1, [r4, #0xc]
	mov r8, r2
	cmp r1, #0
	addne r1, r1, #0x1300
	ldrhne r1, [r1, #0x16]
	mov r7, r3
	cmpne r1, #0
	movne r0, #2
	popne {r3, r4, r5, r6, r7, r8, sb, pc}
	add r0, r0, #0x1f
	bic r4, r0, #0x1f
	add r0, r4, #0x1f
	add r0, r0, #0x1e00
	cmp r7, #0x10000
	bic r5, r0, #0x1f
	bne _02012E10
	bl FUN_0200F398
	mov r7, r0
_02012E10:
	bl FUN_02009A90
	ldr r3, _02012F98 @ =0x0000FFFF
	ldr r1, _02012F9C @ =0x0231CF40
	mov r2, #5
	strh r3, [r1, #6]
	strh r2, [r1]
	mov r2, #0x28
	strh r2, [r1, #2]
	mov r6, r0
	strh r2, [r1, #4]
	mov r2, #1
	ldr r0, [sp, #0x20]
	ldr r3, _02012F94 @ =0x0234D6C0
	str r2, [r1, #0xc]
	strh r0, [r3]
	str r4, [r3, #8]
	mov r1, r4
	mov r0, #0
	mov r2, #0x1e00
	str r5, [r3, #0xc]
	bl FUN_0200A0CC
	mov r1, r5
	mov r0, #0
	mov r2, #0x1340
	bl FUN_0200A098
	ldrb r0, [sb, #1]
	add r2, r4, #0x530
	mov r1, #0
	cmp r0, #0
	ble _02012EA4
_02012E88:
	add r0, sb, r1, lsl #1
	ldrh r0, [r0, #2]
	add r1, r1, #1
	strh r0, [r2], #2
	ldrb r0, [sb, #1]
	cmp r1, r0
	blt _02012E88
_02012EA4:
	add r0, r4, #0x138
	add r3, r0, #0x400
	ldr r0, _02012F9C @ =0x0231CF40
	mov ip, #0
	ldr r1, [r0, #8]
_02012EB8:
	ldrh r2, [r1]
	cmp r2, #0
	beq _02012EDC
	add r1, r1, #2
	add ip, ip, #1
	str r1, [r0, #8]
	cmp ip, #0x10
	strh r2, [r3], #2
	blt _02012EB8
_02012EDC:
	mov r0, sb
	add r1, r5, #0x1300
	mov r2, #0x16
	bl FUN_0200A1D8
	ldrb r0, [sb, #1]
	cmp r0, #0xa
	bhs _02012F08
	add r0, r5, r0, lsl #1
	add r0, r0, #0x1300
	mov r1, #0
	strh r1, [r0, #2]
_02012F08:
	add r0, r4, #0x500
	mov r1, #0x100
	strh r1, [r0]
	mov r1, #8
	strh r1, [r0, #2]
	mov r2, #0
	strh r2, [r0, #0x18]
	strh r2, [r0, #0x1a]
	mov r1, #1
	strh r1, [r0, #0x2c]
	add r0, r5, #0x400
	str r0, [r4, #0x504]
	strh r2, [r4, #0xe]
	strh r2, [r4, #0x12]
	strh r1, [r4, #0x16]
	strh r2, [r4, #0x14]
	str r8, [r4, #8]
	strh r7, [r4, #0xc]
	bl FUN_02012D54
	add r0, r0, #0xc8
	strh r0, [r4, #0x18]
	mov r0, #0xf
	strh r0, [r4, #0x10]
	mov r3, #0
	strb r3, [r4, #0x50c]
	strb r3, [r4, #0x50d]
	add r1, r5, #0x1300
	mov r2, #1
	mov r0, r6
	strh r2, [r1, #0x16]
	add r1, r5, #0x1000
	str r3, [r1, #0x31c]
	bl FUN_02009AA4
	mov r0, #0
	pop {r3, r4, r5, r6, r7, r8, sb, pc}
	.align 2, 0
_02012F94: .4byte 0x0234D6C0
_02012F98: .4byte 0x0000FFFF
_02012F9C: .4byte 0x0231CF40
	arm_func_end FUN_02012DBC

	arm_func_start FUN_02012FA0
FUN_02012FA0: @ 0x02012FA0
	push {r4, lr}
	ldr r2, _02013070 @ =0x0234D6C0
	mov r3, #0
	ldr r1, [r2, #8]
	mov r0, #0xa
	add r1, r1, #0x500
	strh r3, [r1, #0x28]
	ldr r1, [r2, #8]
	add r1, r1, #0x500
	strh r3, [r1, #0x2a]
	ldr r1, [r2, #8]
	add r1, r1, #0x500
	strh r3, [r1, #0x26]
	ldr r1, [r2, #8]
	add r1, r1, #0x500
	strh r3, [r1, #0x48]
	bl FUN_02013334
	ldr r4, _02013070 @ =0x0234D6C0
	ldr r0, [r4, #0xc]
	add r0, r0, #0x1000
	ldr r0, [r0, #0x320]
	cmp r0, #0
	bne _02013048
_02012FFC:
	ldrh r2, [r4]
	ldmib r4, {r0, r1}
	ldr r1, [r1, #0x508]
	bl FUN_0200FBE4
	cmp r0, #4
	beq _02012FFC
	cmp r0, #2
	movne r0, #8
	popne {r4, pc}
	ldr r0, _02013070 @ =0x0234D6C0
	ldr r0, [r0, #8]
	ldr r0, [r0, #0x508]
	bl FUN_0200F724
	ldr r0, _02013070 @ =0x0234D6C0
	mov r2, #1
	ldr r1, [r0, #8]
	mov r0, #0
	strb r2, [r1, #0x50d]
	pop {r4, pc}
_02013048:
	ldr r0, [r4, #8]
	ldr r0, [r0, #0x508]
	bl FUN_0200F724
	mov r0, r4
	ldr r0, [r0, #8]
	mov r1, #1
	strb r1, [r0, #0x50d]
	bl FUN_02011CC4
	mov r0, #0
	pop {r4, pc}
	.align 2, 0
_02013070: .4byte 0x0234D6C0
	arm_func_end FUN_02012FA0

	arm_func_start FUN_02013074
FUN_02013074: @ 0x02013074
	push {r4, r5, r6, lr}
	bl FUN_02009A90
	ldr r3, _0201314C @ =0x0234D6C0
	mov r4, r0
	ldr r1, [r3, #0xc]
	mov r0, #0
	add r1, r1, #0x1000
	str r0, [r1, #0x320]
	ldr r5, [r3, #0xc]
	mov r2, #0x7e0
	add r1, r5, #0x3f
	add r1, r1, #0x1b00
	bic r1, r1, #0x1f
	str r1, [r3, #4]
	add r1, r5, #0x1000
	ldr r6, [r1, #0x4e4]
	add r1, r5, #0x1340
	bl FUN_0200A098
	mov r0, r6
	bl FUN_020101CC
	ldr r2, _0201314C @ =0x0234D6C0
	mov r0, #0
	ldr r1, [r2, #0xc]
	mov r3, #2
	add r1, r1, #0x1000
	str r0, [r1, #0x4e8]
	ldr r1, [r2, #8]
	ldr r5, _02013150 @ =0x0230B6E8
	add r1, r1, #0x500
	strh r3, [r1, #0x24]
	ldr r1, [r2, #8]
	mov r3, #1
	str r5, [r1, #0x51c]
	ldr r5, [r2, #8]
	ldr ip, _02013154 @ =0x0230D964
	sub r1, r3, #2
	str ip, [r5, #0x508]
	ldr r5, [r2, #8]
	str r0, [r5, #0x5e4]
	ldr r0, [r2, #8]
	str r3, [r0, #0x5e8]
	ldr r0, [r2, #8]
	str r1, [r0, #0x5ec]
	bl FUN_02010FD4
	ldr r0, _02013158 @ =0x0230E6CC
	ldr r1, _0201315C @ =0x0230E71C
	bl FUN_02010FEC
	bl FUN_02011000
	bl FUN_02012FA0
	mov r5, r0
	mov r0, r4
	bl FUN_02009AA4
	mov r0, r5
	pop {r4, r5, r6, pc}
	.align 2, 0
_0201314C: .4byte 0x0234D6C0
_02013150: .4byte 0x0230B6E8
_02013154: .4byte 0x0230D964
_02013158: .4byte 0x0230E6CC
_0201315C: .4byte 0x0230E71C
	arm_func_end FUN_02013074

	arm_func_start FUN_02013160
FUN_02013160: @ 0x02013160
	push {r4, lr}
	ldr r0, _02013194 @ =0x0234D6C0
	ldr r0, [r0, #8]
	ldr r0, [r0, #0x508]
	bl FUN_0200FBA4
	mov r4, r0
	mov r1, r4
	mov r0, #1
	bl FUN_020135DC
	cmp r4, #2
	moveq r4, #0
	mov r0, r4
	pop {r4, pc}
	.align 2, 0
_02013194: .4byte 0x0234D6C0
	arm_func_end FUN_02013160

	arm_func_start FUN_02013198
FUN_02013198: @ 0x02013198
	ldr ip, _020131A0 @ =FUN_0230E5A0
	bx ip
	.align 2, 0
_020131A0: .4byte FUN_0230E5A0
	arm_func_end FUN_02013198

	arm_func_start FUN_020131A4
FUN_020131A4: @ 0x020131A4
	push {r3, r4, r5, lr}
	mov r5, #1
	bl FUN_02009A90
	ldr r1, _02013218 @ =0x0234D6C0
	mov r4, r0
	ldr r2, [r1, #8]
	add r0, r2, #0x500
	ldrh r0, [r0, #0x26]
	cmp r0, #0
	bne _02013208
	mov r0, #0
	str r0, [r2, #0x5e4]
	ldr r0, [r1, #8]
	mov r1, r5
	add r0, r0, #0x500
	strh r1, [r0, #0x26]
	bl FUN_02013614
	cmp r0, #0
	beq _02013200
	ldr r0, _0201321C @ =0x0230E5D8
	bl FUN_0201379C
	mov r5, #0
	b _02013208
_02013200:
	bl FUN_02013160
	mov r5, r0
_02013208:
	mov r0, r4
	bl FUN_02009AA4
	mov r0, r5
	pop {r3, r4, r5, pc}
	.align 2, 0
_02013218: .4byte 0x0234D6C0
_0201321C: .4byte 0x0230E5D8
	arm_func_end FUN_020131A4

	arm_func_start FUN_02013220
FUN_02013220: @ 0x02013220
	push {r4, lr}
	bl FUN_02009A90
	ldr r1, _02013258 @ =0x0234D6C0
	mov r4, r0
	ldr r0, [r1, #0xc]
	add r0, r0, #0x1000
	ldr r0, [r0, #0x320]
	cmp r0, #0
	beq _02013248
	bl FUN_02009D48
_02013248:
	bl FUN_020131A4
	mov r0, r4
	bl FUN_02009AA4
	pop {r4, pc}
	.align 2, 0
_02013258: .4byte 0x0234D6C0
	arm_func_end FUN_02013220

	arm_func_start FUN_0201325C
FUN_0201325C: @ 0x0201325C
	ldr r0, _0201326C @ =0x0234D6C0
	ldr r0, [r0, #8]
	ldr r0, [r0, #0x5ec]
	bx lr
	.align 2, 0
_0201326C: .4byte 0x0234D6C0
	arm_func_end FUN_0201325C

	arm_func_start FUN_02013270
FUN_02013270: @ 0x02013270
	ldr r2, _02013288 @ =0x0234D6C0
	mov r1, #0x180
	ldr r2, [r2, #8]
	add r2, r2, #0x600
	mla r0, r1, r0, r2
	bx lr
	.align 2, 0
_02013288: .4byte 0x0234D6C0
	arm_func_end FUN_02013270

	arm_func_start FUN_0201328C
FUN_0201328C: @ 0x0201328C
	ldr r1, _020132D8 @ =0x0234D6C0
	mov r2, #0xdc
	strh r2, [r1, #0x26]
	ldr r2, [r1, #8]
	mov r3, #0
	str r3, [r2, #0x5e8]
	ldrb r2, [r0]
	strb r2, [r1, #0x28]
	ldrb r2, [r0, #1]
	strb r2, [r1, #0x29]
	ldrb r2, [r0, #2]
	strb r2, [r1, #0x2a]
	ldrb r2, [r0, #3]
	strb r2, [r1, #0x2b]
	ldrb r2, [r0, #4]
	strb r2, [r1, #0x2c]
	ldrb r0, [r0, #5]
	strb r0, [r1, #0x2d]
	bx lr
	.align 2, 0
_020132D8: .4byte 0x0234D6C0
	arm_func_end FUN_0201328C

	arm_func_start FUN_020132DC
FUN_020132DC: @ 0x020132DC
	ldr r1, _0201332C @ =0x0234D6C0
	mov r0, #0xa
	strh r0, [r1, #0x26]
	ldr r2, [r1, #8]
	mov r3, #1
	ldr r0, _02013330 @ =0x0231424C
	str r3, [r2, #0x5e8]
	ldrb ip, [r0]
	ldrb r3, [r0, #1]
	ldrb r2, [r0, #2]
	strb ip, [r1, #0x28]
	strb r3, [r1, #0x29]
	strb r2, [r1, #0x2a]
	ldrb r2, [r0, #3]
	strb r2, [r1, #0x2b]
	ldrb r2, [r0, #4]
	strb r2, [r1, #0x2c]
	ldrb r0, [r0, #5]
	strb r0, [r1, #0x2d]
	bx lr
	.align 2, 0
_0201332C: .4byte 0x0234D6C0
_02013330: .4byte 0x0231424C
	arm_func_end FUN_020132DC

	arm_func_start FUN_02013334
FUN_02013334: @ 0x02013334
	ldr r1, _02013340 @ =0x0234D6C0
	strh r0, [r1, #0x26]
	bx lr
	.align 2, 0
_02013340: .4byte 0x0234D6C0
	arm_func_end FUN_02013334

	arm_func_start FUN_02013344
FUN_02013344: @ 0x02013344
	push {r3, r4, lr}
	sub sp, sp, #0xc
	ldrh r4, [sp, #0x18]
	mov r3, r2
	mov r2, r1
	str r4, [sp]
	mov r4, #1
	str r4, [sp, #4]
	mov r4, #3
	mov r1, #0
	str r4, [sp, #8]
	bl FUN_0200FC4C
	mov r4, r0
	mov r1, r4
	mov r0, #0xf
	bl FUN_020135DC
	mov r0, r4
	add sp, sp, #0xc
	pop {r3, r4, pc}
	arm_func_end FUN_02013344

	arm_func_start FUN_02013390
FUN_02013390: @ 0x02013390
	push {r3, r4, r5, lr}
	ldr ip, _02013468 @ =0x0234D6C0
	lsl r3, r1, #0x10
	ldr r5, [ip, #8]
	lsl ip, r2, #0x10
	add lr, r5, #0x500
	ldrh r4, [lr, #0x28]
	mov r1, r0
	lsr r2, r3, #0x10
	cmp r4, #0
	ldrhne r0, [lr, #0x26]
	lsr r4, ip, #0x10
	cmpne r0, #1
	moveq r0, #1
	popeq {r3, r4, r5, pc}
	ldrh r0, [lr, #0x24]
	cmp r0, #1
	beq _020133E4
	cmp r0, #2
	beq _0201342C
	b _02013460
_020133E4:
	ldrh r0, [lr, #0x2c]
	cmp r0, #0
	moveq r0, #0x3e8
	movne r0, #0
	lsl r3, r0, #0x10
	str r4, [sp]
	ldr r0, [r5, #0x508]
	lsr r3, r3, #0x10
	bl FUN_02013344
	cmp r0, #2
	bne _02013420
	ldr r1, _02013468 @ =0x0234D6C0
	mov r2, #1
	ldr r1, [r1, #8]
	strb r2, [r1, #0x50c]
_02013420:
	cmp r0, #2
	moveq r0, #0
	pop {r3, r4, r5, pc}
_0201342C:
	ldr r0, _0201346C @ =0x0230D964
	mov r3, #0
	str r4, [sp]
	bl FUN_02013344
	cmp r0, #2
	bne _02013454
	ldr r1, _02013468 @ =0x0234D6C0
	mov r2, #1
	ldr r1, [r1, #8]
	strb r2, [r1, #0x50c]
_02013454:
	cmp r0, #2
	moveq r0, #0
	pop {r3, r4, r5, pc}
_02013460:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.align 2, 0
_02013468: .4byte 0x0234D6C0
_0201346C: .4byte 0x0230D964
	arm_func_end FUN_02013390

	arm_func_start FUN_02013470
FUN_02013470: @ 0x02013470
	push {r4, lr}
	ldr r1, _02013550 @ =0x0234D6C0
	mov r4, r0
	ldr r0, [r1, #8]
	ldrh r2, [r4, #0x4c]
	add r0, r0, #0x500
	strh r2, [r0]
	ldr r0, [r1, #8]
	ldrh r2, [r4, #0x4e]
	add r0, r0, #0x500
	strh r2, [r0, #2]
	ldr r0, [r1, #8]
	ldr r2, [r1, #0xc]
	add r0, r0, #0x500
	ldrh r3, [r0]
	add r0, r2, #0x1000
	sub r2, r3, #6
	str r2, [r0, #0x318]
	ldr r0, [r1, #8]
	add r0, r0, #0x500
	ldrh r0, [r0, #2]
	bl FUN_020137E4
	ldrh r0, [r4, #0x4c]
	ldr r1, _02013550 @ =0x0234D6C0
	mov r2, #0
	add r3, r0, #0x55
	ldr r0, [r1, #8]
	bic r3, r3, #0x1f
	lsl r3, r3, #1
	add r0, r0, #0x500
	strh r3, [r0, #0x1a]
	ldrh r3, [r4, #0x4e]
	ldr r0, [r1, #8]
	add r3, r3, #0x21
	bic r3, r3, #0x1f
	add r0, r0, #0x500
	strh r3, [r0, #0x18]
	ldr r0, [r1, #8]
	str r4, [r0, #0x520]
	ldr r0, [r1, #8]
	ldrh r3, [r4, #0x48]
	add r0, r0, #0x500
	strh r3, [r0, #0x48]
	ldr r0, [r1, #8]
	str r2, [r0, #0x5e4]
	ldr r0, [r1, #8]
	ldr r0, [r0, #0x508]
	bl FUN_0200F84C
	mov r4, r0
	mov r1, r4
	mov r0, #0xb
	bl FUN_020135DC
	cmp r4, #2
	moveq r4, #0
	mov r0, r4
	pop {r4, pc}
	.align 2, 0
_02013550: .4byte 0x0234D6C0
	arm_func_end FUN_02013470

	arm_func_start FUN_02013554
FUN_02013554: @ 0x02013554
	push {r4, lr}
	ldr r0, _020135B8 @ =0x0234D6C0
	mov r2, #1
	ldr r1, [r0, #8]
	str r2, [r1, #0x5e4]
	ldr r0, [r0, #8]
	ldr r0, [r0, #0x5e8]
	cmp r0, #0
	beq _0201358C
	ldr r0, _020135BC @ =0x0234D6E0
	bl FUN_02011BF4
	cmp r0, #0
	bne _0201358C
	bl FUN_020131A4
_0201358C:
	ldr r0, _020135C0 @ =0x0230D964
	ldr r1, _020135BC @ =0x0234D6E0
	bl FUN_0200F894
	mov r4, r0
	mov r1, r4
	mov r0, #0xa
	bl FUN_020135DC
	cmp r4, #2
	moveq r4, #0
	mov r0, r4
	pop {r4, pc}
	.align 2, 0
_020135B8: .4byte 0x0234D6C0
_020135BC: .4byte 0x0234D6E0
_020135C0: .4byte 0x0230D964
	arm_func_end FUN_02013554

	arm_func_start FUN_020135C4
FUN_020135C4: @ 0x020135C4
	ldr r0, _020135D8 @ =0x0234D6C0
	ldr r0, [r0, #8]
	add r0, r0, #0x500
	ldrh r0, [r0, #0xe2]
	bx lr
	.align 2, 0
_020135D8: .4byte 0x0234D6C0
	arm_func_end FUN_020135C4

	arm_func_start FUN_020135DC
FUN_020135DC: @ 0x020135DC
	push {r3, lr}
	cmp r1, #2
	cmpne r1, #0
	popeq {r3, pc}
	ldr r2, _02013610 @ =0x0234D6C0
	strh r0, [sp]
	ldr r0, [r2, #8]
	strh r1, [sp, #2]
	ldr r2, [r0, #0x51c]
	add r1, sp, #0
	mov r0, #0xff
	.word 0xE12FFF32
	pop {r3, pc}
	.align 2, 0
_02013610: .4byte 0x0234D6C0
	arm_func_end FUN_020135DC

	arm_func_start FUN_02013614
FUN_02013614: @ 0x02013614
	ldr r0, _0201362C @ =0x0234D700
	ldr r0, [r0]
	cmp r0, #0
	movne r0, #1
	moveq r0, #0
	bx lr
	.align 2, 0
_0201362C: .4byte 0x0234D700
	arm_func_end FUN_02013614

	arm_func_start FUN_02013630
FUN_02013630: @ 0x02013630
	push {r3, r4, r5, r6, r7, r8, sb, lr}
	ldr r4, _02013798 @ =0x0234D700
	mov sb, r0
	mov r8, r1
	mov r7, r2
	mov r6, r3
	ldr r4, [r4]
	bl FUN_02013614
	cmp r0, #0
	bne _0201365C
	bl FUN_02009D48
_0201365C:
	ldr r0, [sb, #4]
	lsl r0, r0, #0x1f
	lsrs r0, r0, #0x1f
	beq _02013670
	bl FUN_02009D48
_02013670:
	cmp r6, #0x1f
	bls _020136BC
	mov r0, r4
	bl FUN_02007FE0
	cmp r6, #0x20
	bne _02013698
	cmp r0, #0
	subne r6, r0, #1
	moveq r6, #0
	b _020136BC
_02013698:
	cmp r6, #0x21
	bne _020136B0
	cmp r0, #0x1f
	addlo r6, r0, #1
	movhs r6, #0x1f
	b _020136BC
_020136B0:
	cmp r6, #0x22
	moveq r6, r0
	movne r6, #0x1f
_020136BC:
	bl FUN_02009A90
	ldr r1, [sb, #4]
	mov r5, r0
	bic r0, r1, #1
	orr r1, r0, #1
	and r0, r1, #1
	str r1, [sb, #4]
	orr r0, r0, r6, lsl #1
	stmib sb, {r0, r8}
	str r7, [sb, #0xc]
	ldr r0, [r4, #0xc0]
	cmp r0, #0
	add r0, r4, #0xc4
	bne _02013714
	cmp sb, r0
	ldreq r0, _02013798 @ =0x0234D700
	moveq r1, #0
	streq r1, [r0]
	mov r0, r4
	str sb, [r4, #0xc0]
	bl FUN_020080E8
	b _0201378C
_02013714:
	cmp sb, r0
	ldr r1, [r4, #0xc0]
	bne _02013750
	ldr r0, [r1]
	cmp r0, #0
	beq _0201373C
_0201372C:
	mov r1, r0
	ldr r0, [r0]
	cmp r0, #0
	bne _0201372C
_0201373C:
	ldr r0, _02013798 @ =0x0234D700
	str sb, [r1]
	mov r1, #0
	str r1, [r0]
	b _0201378C
_02013750:
	ldr r0, [r1, #4]
	cmp r6, r0, lsr #1
	strlo sb, [r4, #0xc0]
	strlo r1, [sb]
	blo _0201378C
	b _0201376C
_02013768:
	mov r1, r2
_0201376C:
	ldr r2, [r1]
	cmp r2, #0
	beq _02013784
	ldr r0, [r2, #4]
	cmp r6, r0, lsr #1
	bhs _02013768
_02013784:
	str r2, [sb]
	str sb, [r1]
_0201378C:
	mov r0, r5
	bl FUN_02009AA4
	pop {r3, r4, r5, r6, r7, r8, sb, pc}
	.align 2, 0
_02013798: .4byte 0x0234D700
	arm_func_end FUN_02013630

	arm_func_start FUN_0201379C
FUN_0201379C: @ 0x0201379C
	push {r3, r4, r5, lr}
	mov r5, r0
	bl FUN_02009A90
	mov r4, r0
	bl FUN_02013614
	cmp r0, #0
	beq _020137D4
	ldr r0, _020137E0 @ =0x0234D700
	mov r1, #0
	ldr r0, [r0]
	mov r2, r5
	mov r3, r1
	add r0, r0, #0xc4
	bl FUN_02013630
_020137D4:
	mov r0, r4
	bl FUN_02009AA4
	pop {r3, r4, r5, pc}
	.align 2, 0
_020137E0: .4byte 0x0234D700
	arm_func_end FUN_0201379C

	arm_func_start FUN_020137E4
FUN_020137E4: @ 0x020137E4
	push {r3, lr}
	ldr r2, _02013810 @ =0x0234D704
	sub r1, r0, #2
	mov r0, #0x1e
	str r1, [r2, #8]
	bl FUN_020184CC
	ldr r1, _02013810 @ =0x0234D704
	mov r2, #0x1e
	str r0, [r1, #0xc]
	str r2, [r1, #0x10]
	pop {r3, pc}
	.align 2, 0
_02013810: .4byte 0x0234D704
	arm_func_end FUN_020137E4

	arm_func_start FUN_02013814
FUN_02013814: @ 0x02013814
	push {r4, lr}
	ldrb r3, [r0]
	mov r4, r1
	add r2, r4, #1
	strb r3, [r1]
	ldrb r1, [r0]
	mov r4, r2
	cmp r1, #0xb
	addls pc, pc, r1, lsl #2
	b _020138F0
_0201383C: @ jump table
	b _020138F0 @ case 0
	b _020138F0 @ case 1
	b _020138F0 @ case 2
	b _020138F0 @ case 3
	b _020138F0 @ case 4
	b _020138F0 @ case 5
	b _020138F0 @ case 6
	b _0201386C @ case 7
	b _020138F8 @ case 8
	b _020138B0 @ case 9
	b _020138F8 @ case 10
	b _020138F8 @ case 11
_0201386C:
	ldrb r3, [r0, #2]
	ldr r1, _02013900 @ =0x0234D704
	add r4, r2, #1
	strb r3, [r2]
	ldrb r3, [r0, #2]
	ldr r2, [r1, #0xc]
	cmp r3, r2
	movgt r0, #0
	popgt {r4, pc}
	ldr r2, [r1, #8]
	mov r1, r4
	add r0, r0, #3
	bl FUN_0200A1D8
	ldr r0, _02013900 @ =0x0234D704
	ldr r0, [r0, #8]
	add r4, r4, r0
	b _020138F8
_020138B0:
	ldrh r1, [r0, #2]
	add r4, r2, #2
	ldr r3, _02013900 @ =0x0234D704
	strb r1, [r2]
	ldrh ip, [r0, #2]
	mov r1, r4
	add r0, r0, #4
	and ip, ip, #0xff00
	asr ip, ip, #8
	strb ip, [r2, #1]
	ldr r2, [r3, #8]
	bl FUN_0200A1D8
	ldr r0, _02013900 @ =0x0234D704
	ldr r0, [r0, #8]
	add r4, r4, r0
	b _020138F8
_020138F0:
	mov r0, #0
	pop {r4, pc}
_020138F8:
	mov r0, r4
	pop {r4, pc}
	.align 2, 0
_02013900: .4byte 0x0234D704
	arm_func_end FUN_02013814

	arm_func_start FUN_02013904
FUN_02013904: @ 0x02013904
	push {r3, r4, r5, lr}
	ldr r2, _0201394C @ =0x0234D704
	mov r4, r1
	ldrb r3, [r2]
	mov r5, r0
	ldr r1, [r2, #0xc]
	add r0, r3, #1
	bl FUN_020184CC
	ldr r0, _0201394C @ =0x0234D704
	and r3, r1, #0xff
	strb r1, [r0]
	ldr r2, [r0, #8]
	mov r1, r5
	mla r0, r3, r2, r4
	bl FUN_0200A1D8
	ldr r0, _0201394C @ =0x0234D704
	ldrb r0, [r0]
	pop {r3, r4, r5, pc}
	.align 2, 0
_0201394C: .4byte 0x0234D704
	arm_func_end FUN_02013904

	arm_func_start FUN_02013950
FUN_02013950: @ 0x02013950
	ldrb r2, [r1], #1
	strb r2, [r0]
	cmp r2, #6
	addls pc, pc, r2, lsl #2
	b _020139B8
_02013964: @ jump table
	b _020139B8 @ case 0
	b _020139C0 @ case 1
	b _020139C0 @ case 2
	b _020139C0 @ case 3
	b _02013980 @ case 4
	b _020139C0 @ case 5
	b _020139C0 @ case 6
_02013980:
	ldrb r2, [r1]
	strh r2, [r0, #2]
	ldrh r3, [r0, #2]
	ldrb r2, [r1, #1]
	orr r2, r3, r2, lsl #8
	strh r2, [r0, #2]
	ldrb r2, [r1, #2]
	strh r2, [r0, #4]
	ldrb r2, [r1, #3]
	ldrh r3, [r0, #4]
	add r1, r1, #4
	orr r2, r3, r2, lsl #8
	strh r2, [r0, #4]
	b _020139C0
_020139B8:
	mov r0, #0
	bx lr
_020139C0:
	mov r0, r1
	bx lr
	arm_func_end FUN_02013950

	arm_func_start FUN_020139C8
FUN_020139C8: @ 0x020139C8
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	bl FUN_02009A90
	ldr r1, _02013A18 @ =0x0234D718
	mov r4, r0
	str r5, [r1]
	bl FUN_02013CD8
	cmp r0, #0
	bne _02013A04
	cmp r5, #0
	movne r1, #0x1000
	moveq r1, #0x5000
	mov r0, #0xf000
	bl FUN_020095AC
_02013A04:
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02013A18: .4byte 0x0234D718
	arm_func_end FUN_020139C8

	arm_func_start FUN_02013A1C
FUN_02013A1C: @ 0x02013A1C
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r1, r7
	mov r0, #0xd
	mov r2, #0
	bl FUN_0200A4F0
	cmp r0, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r6, #1
	mov r5, #0xd
	mov r4, #0
_02013A54:
	mov r0, r6
	blx SVC_WaitByLoop
	mov r0, r5
	mov r1, r7
	mov r2, r4
	bl FUN_0200A4F0
	cmp r0, #0
	bne _02013A54
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02013A1C

	arm_func_start FUN_02013A80
FUN_02013A80: @ 0x02013A80
	push {r4, lr}
	mov r4, r1
	ldr r1, [r4]
	cmp r1, #0
	bne _02013A98
	bl FUN_02007B68
_02013A98:
	ldr r0, [r4, #4]
	bl FUN_02009AA4
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02013A80

	arm_func_start FUN_02013AA8
FUN_02013AA8: @ 0x02013AA8
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r7, r0
	mov r6, r1
	ldr r5, _02013B24 @ =0x027FFFE8
	mov r4, #1
_02013AC0:
	bl FUN_02009A90
	str r0, [r6, #4]
	mov r0, r5
	bl FUN_02007BCC
	and r0, r0, #0x40
	str r0, [r6]
	ldr r0, [r6]
	cmp r0, #0
	addne sp, sp, #4
	popne {r4, r5, r6, r7, lr}
	bxne lr
	mov r0, r7
	bl FUN_02007C6C
	cmp r0, #0
	addeq sp, sp, #4
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	ldr r0, [r6, #4]
	bl FUN_02009AA4
	mov r0, r4
	blx SVC_WaitByLoop
	b _02013AC0
	arm_func_end FUN_02013AA8

	arm_func_start FUN_02013B18
FUN_02013B18: @ 0x02013B18
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_02013B24: .4byte 0x027FFFE8
	arm_func_end FUN_02013B18

	arm_func_start FUN_02013B28
FUN_02013B28: @ 0x02013B28
	ldr r3, _02013B58 @ =0x04000204
	ldr r2, [r0]
	ldrh r1, [r3]
	bic r1, r1, #0xc
	orr r1, r1, r2, lsl #2
	strh r1, [r3]
	ldrh r1, [r3]
	ldr r2, [r0, #4]
	bic r0, r1, #0x10
	orr r0, r0, r2, lsl #4
	strh r0, [r3]
	bx lr
	.align 2, 0
_02013B58: .4byte 0x04000204
	arm_func_end FUN_02013B28

	arm_func_start FUN_02013B5C
FUN_02013B5C: @ 0x02013B5C
	ldr r2, _02013BA0 @ =0x04000204
	ldrh r1, [r2]
	and r1, r1, #0xc
	asr r1, r1, #2
	str r1, [r0]
	ldrh r1, [r2]
	and r1, r1, #0x10
	asr r1, r1, #4
	str r1, [r0, #4]
	ldrh r0, [r2]
	bic r0, r0, #0xc
	orr r0, r0, #0xc
	strh r0, [r2]
	ldrh r0, [r2]
	bic r0, r0, #0x10
	strh r0, [r2]
	bx lr
	.align 2, 0
_02013BA0: .4byte 0x04000204
	arm_func_end FUN_02013B5C

	arm_func_start FUN_02013BA4
FUN_02013BA4: @ 0x02013BA4
	push {r4, lr}
	sub sp, sp, #0x10
	ldr r2, _02013CB0 @ =0x027FFC30
	ldr r0, _02013CB4 @ =0x0000FFFF
	ldrh r1, [r2]
	mov r4, #1
	cmp r1, r0
	addeq sp, sp, #0x10
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	ldrb r0, [r2, #5]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	cmp r0, #1
	addeq sp, sp, #0x10
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	ldr r0, _02013CB8 @ =0x0234D71C
	add r1, sp, #0
	ldrh r0, [r0, #2]
	bl FUN_02013AA8
	add r0, sp, #8
	bl FUN_02013B5C
	mov r0, #0x8000000
	ldrb r2, [r0, #0xb2]
	cmp r2, #0x96
	bne _02013C2C
	ldr r1, _02013CB0 @ =0x027FFC30
	ldrh r0, [r0, #0xbe]
	ldrh r1, [r1]
	cmp r1, r0
	bne _02013C74
_02013C2C:
	cmp r2, #0x96
	beq _02013C4C
	ldr r1, _02013CB0 @ =0x027FFC30
	ldr r0, _02013CBC @ =0x0801FFFE
	ldrh r1, [r1]
	ldrh r0, [r0]
	cmp r1, r0
	bne _02013C74
_02013C4C:
	ldr r2, _02013CB0 @ =0x027FFC30
	mov r0, #0x8000000
	ldr r1, [r2, #8]
	ldr r0, [r0, #0xac]
	cmp r1, r0
	beq _02013C88
	ldrb r0, [r2, #5]
	lsl r0, r0, #0x1f
	lsrs r0, r0, #0x1f
	beq _02013C88
_02013C74:
	ldr r1, _02013CB0 @ =0x027FFC30
	mov r4, #0
	ldrb r0, [r1, #5]
	orr r0, r0, #2
	strb r0, [r1, #5]
_02013C88:
	add r0, sp, #8
	bl FUN_02013B28
	ldr r0, _02013CB8 @ =0x0234D71C
	add r1, sp, #0
	ldrh r0, [r0, #2]
	bl FUN_02013A80
	mov r0, r4
	add sp, sp, #0x10
	pop {r4, lr}
	bx lr
	.align 2, 0
_02013CB0: .4byte 0x027FFC30
_02013CB4: .4byte 0x0000FFFF
_02013CB8: .4byte 0x0234D71C
_02013CBC: .4byte 0x0801FFFE
	arm_func_end FUN_02013BA4

	arm_func_start FUN_02013CC0
FUN_02013CC0: @ 0x02013CC0
	ldr r0, _02013CD4 @ =0x027FFC30
	ldrb r0, [r0, #5]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bx lr
	.align 2, 0
_02013CD4: .4byte 0x027FFC30
	arm_func_end FUN_02013CC0

	arm_func_start FUN_02013CD8
FUN_02013CD8: @ 0x02013CD8
	stmdb sp!, {lr}
	sub sp, sp, #4
	bl FUN_02013BA4
	cmp r0, #0
	beq _02013D04
	bl FUN_02013CC0
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #1
	ldmeq sp!, {lr}
	bxeq lr
_02013D04:
	mov r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02013CD8

	arm_func_start FUN_02013D14
FUN_02013D14: @ 0x02013D14
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _02013D4C @ =0x0234D71C
	mov r3, #0
	ldr r2, _02013D50 @ =0x05000001
	add r0, sp, #0
	str r3, [sp]
	blx SVC_CpuSet
	bl FUN_02007B74
	ldr r1, _02013D4C @ =0x0234D71C
	strh r0, [r1, #2]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02013D4C: .4byte 0x0234D71C
_02013D50: .4byte 0x05000001
	arm_func_end FUN_02013D14

	arm_func_start FUN_02013D54
FUN_02013D54: @ 0x02013D54
	ldr r0, _02013D64 @ =0x0234D724
	mov r1, #0
	str r1, [r0]
	bx lr
	.align 2, 0
_02013D64: .4byte 0x0234D724
	arm_func_end FUN_02013D54

	arm_func_start FUN_02013D68
FUN_02013D68: @ 0x02013D68
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #2
	bl FUN_02013A1C
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02013D68

	arm_func_start FUN_02013D88
FUN_02013D88: @ 0x02013D88
	stmdb sp!, {lr}
	sub sp, sp, #4
	and r0, r1, #0x3f
	cmp r0, #0x11
	bne _02013DF0
	ldr r0, _02013E00 @ =0x0234D72C
	ldr r0, [r0]
	cmp r0, #0
	addne sp, sp, #4
	ldmne sp!, {lr}
	bxne lr
	ldr r1, _02013E04 @ =0x0234D730
	mov r0, #0
	ldr r1, [r1]
	cmp r1, #0
	beq _02013DCC
	.word 0xE12FFF31
_02013DCC:
	cmp r0, #0
	beq _02013DD8
	bl FUN_02013D68
_02013DD8:
	ldr r0, _02013E00 @ =0x0234D72C
	mov r1, #1
	str r1, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
_02013DF0:
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02013E00: .4byte 0x0234D72C
_02013E04: .4byte 0x0234D730
	arm_func_end FUN_02013D88

	arm_func_start FUN_02013E08
FUN_02013E08: @ 0x02013E08
	stmdb sp!, {lr}
	sub sp, sp, #4
	and r0, r1, #0x3f
	cmp r0, #1
	ldreq r0, _02013E40 @ =0x0234D71C
	moveq r1, #1
	strheq r1, [r0]
	addeq sp, sp, #4
	ldmeq sp!, {lr}
	bxeq lr
	bl FUN_02009D48
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02013E40: .4byte 0x0234D71C
	arm_func_end FUN_02013E08

	arm_func_start FUN_02013E44
FUN_02013E44: @ 0x02013E44
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0x14
	ldr r0, _0201402C @ =0x0234D720
	ldr r1, [r0]
	cmp r1, #0
	addne sp, sp, #0x14
	popne {r4, r5, r6, r7, lr}
	bxne lr
	ldr r1, _02014030 @ =0x04000300
	mov r2, #1
	str r2, [r0]
	ldrh r0, [r1]
	ands r0, r0, #1
	addeq sp, sp, #0x14
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, #0x40000
	bl FUN_02007A40
	ldr r3, _02014034 @ =0x04000208
	mov r2, #1
	ldrh r4, [r3]
	ldr r1, _02014038 @ =0x0234D71C
	mov r6, r0
	strh r2, [r3]
	ldrh r0, [r1, #2]
	add r1, sp, #0
	bl FUN_02013AA8
	ldr r1, _0201403C @ =0x04000204
	add r0, sp, #8
	ldrh r1, [r1]
	and r1, r1, #0x8000
	asr r5, r1, #0xf
	bl FUN_02013B5C
	ldr r3, _0201403C @ =0x04000204
	ldr r0, _02014040 @ =0x0234D740
	ldrh r2, [r3]
	add r0, r0, #0x80
	mov r1, #0x40
	bic r2, r2, #0x8000
	strh r2, [r3]
	bl FUN_02008C5C
	ldr r2, _02014040 @ =0x0234D740
	ldr r1, _02014044 @ =0x08000080
	mov r0, #1
	mov r3, #0x40
	add r2, r2, #0x80
	bl FUN_02009F14
	ldr r2, _0201403C @ =0x04000204
	add r0, sp, #8
	ldrh r1, [r2]
	bic r1, r1, #0x8000
	orr r1, r1, r5, lsl #15
	strh r1, [r2]
	bl FUN_02013B28
	ldr r0, _02014038 @ =0x0234D71C
	add r1, sp, #0
	ldrh r0, [r0, #2]
	bl FUN_02013A80
	ldr r0, _02014048 @ =0x027FFF9B
	ldrb r0, [r0]
	cmp r0, #0
	bne _02013F4C
	ldr r0, _0201404C @ =0x027FFF9A
	ldrb r0, [r0]
	cmp r0, #0
	bne _02013FB8
_02013F4C:
	ldr r2, _02014040 @ =0x0234D740
	ldr r0, _02014050 @ =0x027FFC30
	ldrh r1, [r2, #0xbe]
	mov r3, #0
	strh r1, [r0]
_02013F60:
	add r0, r2, r3
	ldrb r1, [r0, #0xb5]
	add r0, r3, #0x2700000
	add r0, r0, #0xff000
	add r3, r3, #1
	strb r1, [r0, #0xc32]
	cmp r3, #3
	blt _02013F60
	ldrh r0, [r2, #0xb0]
	ldr r1, _02014050 @ =0x027FFC30
	strh r0, [r1, #6]
	ldr r0, [r2, #0xac]
	str r0, [r1, #8]
	bl FUN_02013BA4
	cmp r0, #0
	movne r2, #1
	ldr r1, _02014048 @ =0x027FFF9B
	moveq r2, #0
	strb r2, [r1]
	ldr r0, _0201404C @ =0x027FFF9A
	mov r1, #1
	strb r1, [r0]
_02013FB8:
	ldr r0, _02014054 @ =0xFFFF0020
	ldr r1, _02014058 @ =0x0234D744
	mov r2, #0x9c
	bl FUN_0200A0E0
	bl FUN_02008C28
	ldr r0, _02014040 @ =0x0234D740
	add r0, r0, #0xfe000000
	lsr r0, r0, #5
	lsl r0, r0, #6
	orr r0, r0, #1
	bl FUN_02013A1C
	ldr r5, _02014038 @ =0x0234D71C
	ldrh r0, [r5]
	cmp r0, #1
	beq _0201400C
	mov r7, #1
_02013FF8:
	mov r0, r7
	blx SVC_WaitByLoop
	ldrh r0, [r5]
	cmp r0, #1
	bne _02013FF8
_0201400C:
	ldr r2, _02014034 @ =0x04000208
	mov r0, r6
	ldrh r1, [r2]
	strh r4, [r2]
	bl FUN_02007A40
	add sp, sp, #0x14
	pop {r4, r5, r6, r7, lr}
	bx lr
	.align 2, 0
_0201402C: .4byte 0x0234D720
_02014030: .4byte 0x04000300
_02014034: .4byte 0x04000208
_02014038: .4byte 0x0234D71C
_0201403C: .4byte 0x04000204
_02014040: .4byte 0x0234D740
_02014044: .4byte 0x08000080
_02014048: .4byte 0x027FFF9B
_0201404C: .4byte 0x027FFF9A
_02014050: .4byte 0x027FFC30
_02014054: .4byte 0xFFFF0020
_02014058: .4byte 0x0234D744
	arm_func_end FUN_02013E44

	arm_func_start FUN_0201405C
FUN_0201405C: @ 0x0201405C
	push {r4, r5, lr}
	sub sp, sp, #4
	ldr r0, _02014110 @ =0x0234D728
	ldr r1, [r0]
	cmp r1, #0
	addne sp, sp, #4
	popne {r4, r5, lr}
	bxne lr
	mov r1, #1
	str r1, [r0]
	bl FUN_02013D14
	ldr r0, _02014114 @ =0x0234D72C
	mov r1, #0
	str r1, [r0]
	bl FUN_0200A3C0
	mov r5, #0xd
	mov r4, #1
_020140A0:
	mov r0, r5
	mov r1, r4
	bl FUN_0200A5A4
	cmp r0, #0
	beq _020140A0
	ldr r1, _02014118 @ =0x0230F248
	mov r0, #0xd
	bl FUN_0200A5CC
	bl FUN_02013E44
	mov r0, #0xd
	mov r1, #0
	bl FUN_0200A5CC
	ldr r1, _0201411C @ =0x0230F1C8
	mov r0, #0xd
	bl FUN_0200A5CC
	ldr r1, _02014120 @ =0x0234D730
	mov r2, #0
	ldr r0, _02014124 @ =0x0234D800
	str r2, [r1]
	bl FUN_0201422C
	ldr r1, _02014128 @ =0x0230F194
	mov r0, #0x11
	bl FUN_0200A5CC
	mov r0, #0
	bl FUN_020139C8
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_02014110: .4byte 0x0234D728
_02014114: .4byte 0x0234D72C
_02014118: .4byte 0x0230F248
_0201411C: .4byte 0x0230F1C8
_02014120: .4byte 0x0234D730
_02014124: .4byte 0x0234D800
_02014128: .4byte 0x0230F194
	arm_func_end FUN_0201405C

	arm_func_start FUN_0201412C
FUN_0201412C: @ 0x0201412C
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	sub sp, sp, #0x28
	ldr r6, _02014210 @ =0x0234D8EC
	ldr r5, _02014214 @ =0x0234D8E8
	mov r4, r0
	add sb, sp, #0
	mov r8, #0
	mov r7, #0x24
_0201414C:
	mov r0, sb
	mov r1, r8
	mov r2, r7
	bl FUN_0200A144
	bl FUN_02009A90
	ldr r1, [r4, #0xc0]
	mov sl, r0
	cmp r1, #0
	bne _02014184
_02014170:
	mov r0, r8
	bl FUN_0200819C
	ldr r0, [r4, #0xc0]
	cmp r0, #0
	beq _02014170
_02014184:
	ldr lr, [r4, #0xc0]
	add ip, sp, #0
	ldm lr!, {r0, r1, r2, r3}
	stm ip!, {r0, r1, r2, r3}
	ldm lr!, {r0, r1, r2, r3}
	stm ip!, {r0, r1, r2, r3}
	ldr r1, [lr]
	mov r0, sl
	str r1, [ip]
	bl FUN_02009AA4
	ldr r1, [sp]
	cmp r1, #0
	beq _020141C4
	mov r0, sb
	.word 0xE12FFF31
	str r0, [sp, #8]
_020141C4:
	bl FUN_02009A90
	ldr r1, [sp, #4]
	mov sl, r0
	strb r8, [r6, #0x22]
	cmp r1, #0
	beq _020141E4
	mov r0, sb
	.word 0xE12FFF31
_020141E4:
	ldr r0, [r5]
	cmp r0, #0
	beq _02014200
	mov r0, sl
	str r8, [r4, #0xc0]
	bl FUN_02009AA4
	b _0201414C
_02014200:
	bl FUN_02008304
	add sp, sp, #0x28
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	.align 2, 0
_02014210: .4byte 0x0234D8EC
_02014214: .4byte 0x0234D8E8
	arm_func_end FUN_0201412C

	arm_func_start FUN_02014218
FUN_02014218: @ 0x02014218
	ldr ip, _02014228 @ =0x02305584
	mov r1, #0
	mov r2, #0x24
	bx ip
	.align 2, 0
_02014228: .4byte 0x02305584
	arm_func_end FUN_02014218

	arm_func_start FUN_0201422C
FUN_0201422C: @ 0x0201422C
	push {r4, r5, lr}
	sub sp, sp, #0xc
	mov r5, r0
	bl FUN_02009A90
	ldr r1, _020142AC @ =0x0234D8E8
	mov r4, r0
	ldr r0, [r1]
	cmp r0, #0
	bne _02014298
	add r0, r5, #0xc4
	str r5, [r1]
	bl FUN_02014218
	ldr r0, _020142B0 @ =0x0234D8EC
	bl FUN_02014218
	mov r0, #0
	str r0, [r5, #0xc0]
	mov r2, #0x400
	ldr r1, _020142B4 @ =0x0230F56C
	ldr r3, _020142B8 @ =0x0234DD10
	mov r0, r5
	str r2, [sp]
	mov r2, #0x14
	str r2, [sp, #4]
	mov r2, r5
	bl FUN_02008330
	mov r0, r5
	bl FUN_020080E8
_02014298:
	mov r0, r4
	bl FUN_02009AA4
	add sp, sp, #0xc
	pop {r4, r5, lr}
	bx lr
	.align 2, 0
_020142AC: .4byte 0x0234D8E8
_020142B0: .4byte 0x0234D8EC
_020142B4: .4byte 0x0230F56C
_020142B8: .4byte 0x0234DD10
	arm_func_end FUN_0201422C

	thumb_func_start SVC_SoftReset
SVC_SoftReset: @ 0x020142BC
	svc #0
	bx lr
	thumb_func_end SVC_SoftReset

	thumb_func_start SVC_WaitByLoop
SVC_WaitByLoop: @ 0x020142C0
	svc #3
	bx lr
	thumb_func_end SVC_WaitByLoop

	thumb_func_start SVC_WaitIntr
SVC_WaitIntr: @ 0x020142C4
	movs r2, #0
	svc #4
	bx lr
	thumb_func_end SVC_WaitIntr

	non_word_aligned_thumb_func_start SVC_WaitVBlankIntr
SVC_WaitVBlankIntr: @ 0x020142CA
	movs r2, #0
	svc #5
	bx lr
	thumb_func_end SVC_WaitVBlankIntr

	thumb_func_start SVC_Halt
SVC_Halt: @ 0x020142D0
	svc #6
	bx lr
	thumb_func_end SVC_Halt

	thumb_func_start SVC_Div
SVC_Div: @ 0x020142D4
	svc #9
	bx lr
	thumb_func_end SVC_Div

	thumb_func_start SVC_DivRem
SVC_DivRem: @ 0x020142D8
	svc #9
	adds r0, r1, #0
	bx lr
	thumb_func_end SVC_DivRem

	non_word_aligned_thumb_func_start SVC_CpuSet
SVC_CpuSet: @ 0x020142DE
	svc #0xb
	bx lr
	thumb_func_end SVC_CpuSet

	non_word_aligned_thumb_func_start SVC_CpuSetFast
SVC_CpuSetFast: @ 0x020142E2
	svc #0xc
	bx lr
	thumb_func_end SVC_CpuSetFast

	non_word_aligned_thumb_func_start SVC_Sqrt
SVC_Sqrt: @ 0x020142E6
	svc #0xd
	bx lr
	thumb_func_end SVC_Sqrt

	non_word_aligned_thumb_func_start SVC_GetCRC16
SVC_GetCRC16: @ 0x020142EA
	svc #0xe
	bx lr
	thumb_func_end SVC_GetCRC16

	non_word_aligned_thumb_func_start IsMmemExpanded
IsMmemExpanded: @ 0x020142EE
	svc #0xf
	bx lr
	thumb_func_end IsMmemExpanded

	non_word_aligned_thumb_func_start SVC_UnpackBits
SVC_UnpackBits: @ 0x020142F2
	svc #0x10
	bx lr
	thumb_func_end SVC_UnpackBits

	non_word_aligned_thumb_func_start SVC_UncompressLZ8
SVC_UncompressLZ8: @ 0x020142F6
	svc #0x11
	bx lr
	thumb_func_end SVC_UncompressLZ8

	non_word_aligned_thumb_func_start SVC_UncompressLZ16FromDevice
SVC_UncompressLZ16FromDevice: @ 0x020142FA
	svc #0x12
	bx lr
	thumb_func_end SVC_UncompressLZ16FromDevice

	non_word_aligned_thumb_func_start SVC_UncompressHuffmanFromDevice
SVC_UncompressHuffmanFromDevice: @ 0x020142FE
	svc #0x13
	bx lr
	thumb_func_end SVC_UncompressHuffmanFromDevice

	non_word_aligned_thumb_func_start SVC_UncompressRL8
SVC_UncompressRL8: @ 0x02014302
	svc #0x14
	bx lr
	thumb_func_end SVC_UncompressRL8

	non_word_aligned_thumb_func_start SVC_UncompressRL16FromDevice
SVC_UncompressRL16FromDevice: @ 0x02014306
	svc #0x15
	bx lr
	.align 2, 0
	thumb_func_end SVC_UncompressRL16FromDevice

	arm_func_start FUN_0201430C
FUN_0201430C: @ 0x0201430C
	push {r4, r5, r6, lr}
	sub sp, sp, #0x68
	mov r6, r0
	add r0, sp, #0
	mov r5, r1
	mov r4, r2
	bl FUN_0200C510
	add r0, sp, #0
	mov r1, r5
	mov r2, r4
	bl FUN_0200C3B4
	add r0, sp, #0
	mov r1, r6
	bl FUN_0200C1B8
	add sp, sp, #0x68
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0201430C

	arm_func_start FUN_02014350
FUN_02014350: @ 0x02014350
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _02014394 @ =0x0234DD14
	mov r2, r0
	ldr r1, [r1]
	cmp r1, #0
	beq _0201437C
	.word 0xE12FFF31
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
_0201437C:
	mov r0, #0
	mvn r1, #0
	bl FUN_020092CC
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_02014394: .4byte 0x0234DD14
	arm_func_end FUN_02014350

	arm_func_start FUN_02014398
FUN_02014398: @ 0x02014398
	stmdb sp!, {lr}
	sub sp, sp, #4
	ldr r1, _020143DC @ =0x0234DD10
	mov r2, r0
	ldr r1, [r1]
	cmp r1, #0
	beq _020143C4
	.word 0xE12FFF31
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
_020143C4:
	mov r0, #0
	mvn r1, #0
	bl FUN_02009340
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	.align 2, 0
_020143DC: .4byte 0x0234DD10
	arm_func_end FUN_02014398

	arm_func_start FUN_020143E0
FUN_020143E0: @ 0x020143E0
	push {r4, lr}
	sub sp, sp, #0x120
	mov r3, #0
	str r3, [sp, #0x10]
	str r3, [sp, #0x18]
	str r2, [sp]
	mov r3, #0x80
	mov r4, r0
	mov r2, r1
	ldr ip, _020144DC @ =0x00010001
	str r3, [sp, #4]
	add r0, sp, #0x1c
	mov r1, #0x100
	str ip, [sp, #8]
	bl FUN_0201481C
	mov r1, r0
	add r0, sp, #0x1c
	add r2, sp, #0xc
	add r3, sp, #0x10
	bl FUN_02014684
	cmp r0, #0
	addeq sp, sp, #0x120
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	add r1, sp, #0x14
	add r0, sp, #0x18
	str r1, [sp]
	str r0, [sp, #4]
	mov r2, #0
	ldr r0, [sp, #0xc]
	ldr r1, [sp, #0x10]
	mov r3, r2
	bl FUN_020144E0
	cmp r0, #0
	addeq sp, sp, #0x120
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	ldr r0, [sp, #0x18]
	cmp r0, #0x14
	addne sp, sp, #0x120
	movne r0, #0
	popne {r4, lr}
	bxne lr
	ldr r2, [sp, #0x14]
	mov r3, #0
_0201449C:
	ldrb r1, [r2]
	ldrb r0, [r4]
	cmp r1, r0
	addne sp, sp, #0x120
	movne r0, #0
	popne {r4, lr}
	bxne lr
	add r3, r3, #1
	cmp r3, #0x14
	add r4, r4, #1
	add r2, r2, #1
	blt _0201449C
	mov r0, #1
	add sp, sp, #0x120
	pop {r4, lr}
	bx lr
	.align 2, 0
_020144DC: .4byte 0x00010001
	arm_func_end FUN_020143E0

	arm_func_start FUN_020144E0
FUN_020144E0: @ 0x020144E0
	push {r0, r1, r2, r3}
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r2
	mov r4, r3
	add r0, sp, #0x10
	add r1, sp, #0x14
	mov r2, #0x30
	mov r3, #0
	bl FUN_02014748
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	add r0, sp, #0x10
	add r1, sp, #0x14
	mov r2, #0x30
	mov r3, #0
	bl FUN_02014748
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	add r0, sp, #0x10
	add r1, sp, #0x14
	add r3, sp, #0
	mov r2, #6
	bl FUN_02014748
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	cmp r5, #0
	ldrne r0, [sp, #0x10]
	strne r0, [r5]
	cmp r4, #0
	ldrne r0, [sp]
	strne r0, [r4]
	ldr r2, [sp]
	ldr r0, [sp, #0x10]
	ldr r1, [sp, #0x14]
	add r0, r0, r2
	str r0, [sp, #0x10]
	cmp r1, r2
	addlo sp, sp, #4
	movlo r0, #0
	poplo {r4, r5, lr}
	addlo sp, sp, #0x10
	bxlo lr
	sub ip, r1, r2
	add r0, sp, #0x10
	add r1, sp, #0x14
	add r3, sp, #0
	mov r2, #5
	str ip, [sp, #0x14]
	bl FUN_02014748
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	ldr r2, [sp]
	ldr r0, [sp, #0x10]
	ldr r1, [sp, #0x14]
	add r0, r0, r2
	str r0, [sp, #0x10]
	cmp r1, r2
	addlo sp, sp, #4
	movlo r0, #0
	poplo {r4, r5, lr}
	addlo sp, sp, #0x10
	bxlo lr
	sub ip, r1, r2
	add r0, sp, #0x10
	add r1, sp, #0x14
	add r3, sp, #0
	mov r2, #4
	str ip, [sp, #0x14]
	bl FUN_02014748
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	addeq sp, sp, #0x10
	bxeq lr
	ldr r1, [sp, #0x20]
	cmp r1, #0
	ldrne r0, [sp, #0x10]
	strne r0, [r1]
	ldr r1, [sp, #0x24]
	cmp r1, #0
	ldrne r0, [sp]
	strne r0, [r1]
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	add sp, sp, #0x10
	bx lr
	arm_func_end FUN_020144E0

	arm_func_start FUN_02014684
FUN_02014684: @ 0x02014684
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r1, #0xa
	addlo sp, sp, #4
	movlo r0, #0
	ldmlo sp!, {lr}
	bxlo lr
	ldrb ip, [r0]
	add lr, r0, r1
	cmp ip, #1
	addne sp, sp, #4
	movne r0, #0
	ldmne sp!, {lr}
	bxne lr
	add ip, r0, #1
	mov r1, #0
_020146C4:
	ldrb r0, [ip], #1
	cmp r0, #0xff
	addne sp, sp, #4
	movne r0, #0
	ldmne sp!, {lr}
	bxne lr
	add r1, r1, #1
	cmp r1, #8
	blt _020146C4
	cmp ip, lr
	beq _02014708
_020146F0:
	ldrb r0, [ip]
	cmp r0, #0xff
	bne _02014708
	add ip, ip, #1
	cmp ip, lr
	bne _020146F0
_02014708:
	cmp ip, lr
	addeq sp, sp, #4
	moveq r0, #0
	ldmeq sp!, {lr}
	bxeq lr
	ldrb r0, [ip]
	cmp r0, #0
	movne r0, #0
	addeq r0, ip, #1
	subeq r1, lr, r0
	streq r1, [r3]
	streq r0, [r2]
	moveq r0, #1
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02014684

	arm_func_start FUN_02014748
FUN_02014748: @ 0x02014748
	push {r4, r5, r6, lr}
	ldr r5, [r0]
	mov r6, #0
	ldrb r4, [r5]
	add r5, r5, #1
	mov ip, r6
	cmp r4, r2
	ldr r2, [r1]
	movne r0, r6
	popne {r4, r5, r6, lr}
	bxne lr
	cmp r2, #1
	movlo r0, r6
	poplo {r4, r5, r6, lr}
	bxlo lr
	ldrb lr, [r5]
	sub r4, r2, #1
	ands r2, lr, #0x80
	beq _020147E4
	and r2, lr, #0x7f
	and lr, r2, #0xff
	add r2, lr, #1
	cmp r4, r2
	movlo r0, r6
	poplo {r4, r5, r6, lr}
	bxlo lr
	cmp r3, #0
	sub r6, r4, lr
	beq _020147DC
	ldrb r2, [r5, #1]
	add r5, r5, #1
	and r4, r2, #0x7f
_020147C8:
	sub r2, lr, #1
	add ip, r4, ip, lsl #7
	ands lr, r2, #0xff
	bne _020147C8
	b _02014800
_020147DC:
	add r5, r5, lr
	b _02014800
_020147E4:
	add r5, r5, #1
	cmp r4, #1
	mov ip, lr
	movlo r0, r6
	poplo {r4, r5, r6, lr}
	bxlo lr
	sub r6, r4, #1
_02014800:
	str r5, [r0]
	str r6, [r1]
	cmp r3, #0
	strne ip, [r3]
	mov r0, #1
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_02014748

	arm_func_start FUN_0201481C
FUN_0201481C: @ 0x0201481C
	push {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0x58
	movs r6, r0
	mov r5, r1
	mov r8, r2
	mov r7, r3
	beq _0201484C
	cmp r8, #0
	beq _0201484C
	ldr r0, [sp, #0x70]
	cmp r0, #0
	bne _0201485C
_0201484C:
	add sp, sp, #0x58
	mvn r0, #2
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0201485C:
	bl FUN_0201825C
	mov r4, r0
	add r0, sp, #4
	bl FUN_020182DC
	add r0, sp, #0x18
	bl FUN_020182DC
	add r0, sp, #0x2c
	bl FUN_020182DC
	add r0, sp, #0x40
	bl FUN_020182DC
	cmp r4, #0
	mvneq r5, #1
	beq _02014938
	add r2, sp, #4
	mov r0, r8
	mov r1, r7
	bl FUN_02017F18
	cmp r0, #0
	mvneq r5, #1
	beq _02014938
	ldr r1, [sp, #0x78]
	add r0, sp, #0x2c
	bl FUN_0201802C
	cmp r0, #0
	mvneq r5, #1
	beq _02014938
	ldr r0, [sp, #0x70]
	ldr r1, [sp, #0x74]
	add r2, sp, #0x40
	bl FUN_02017F18
	cmp r0, #0
	mvneq r5, #1
	beq _02014938
	add r0, sp, #0x18
	add r1, sp, #4
	add r2, sp, #0x2c
	add r3, sp, #0x40
	str r4, [sp]
	bl FUN_02016468
	cmp r0, #0
	mvneq r5, #1
	beq _02014938
	add r0, sp, #0x18
	bl FUN_02018438
	add r1, r0, #7
	asr r0, r1, #2
	add r0, r1, r0, lsr #29
	asr r0, r0, #3
	cmp r0, r5
	mvngt r5, #0
	bgt _02014938
	add r0, sp, #0x18
	mov r1, r6
	bl FUN_02017E9C
	mov r5, r0
_02014938:
	add r0, sp, #4
	bl FUN_020183BC
	add r0, sp, #0x18
	bl FUN_020183BC
	add r0, sp, #0x2c
	bl FUN_020183BC
	add r0, sp, #0x40
	bl FUN_020183BC
	cmp r4, #0
	beq _02014968
	mov r0, r4
	bl FUN_020181EC
_02014968:
	mov r0, r5
	add sp, sp, #0x58
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_0201481C

	arm_func_start FUN_02014978
FUN_02014978: @ 0x02014978
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x7c
	mov r4, #0
	mov r5, r3
	mov r3, r4
	str r3, [sp, #0x34]
	ldr r3, [r5]
	str r0, [sp, #4]
	mov r0, r4
	ldr r3, [r3]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	ands r0, r3, #1
	ldr r0, [sp, #0xa0]
	str r4, [sp, #8]
	str r0, [sp, #0xa0]
	mov r7, r1
	mov r6, r2
	addeq sp, sp, #0x7c
	moveq r0, r4
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldr r1, [r7, #4]
	ldr r0, [r0]
	cmp r1, #0
	str r0, [sp, #0xc]
	beq _020149FC
	cmp r1, #1
	bne _02014A18
	ldr r0, [r7]
	ldr r0, [r0]
	cmp r0, #0
	bne _02014A18
_020149FC:
	ldr r0, [sp, #4]
	mov r1, #0
	bl FUN_0201802C
	add sp, sp, #0x7c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02014A18:
	ldr r1, [r6, #4]
	cmp r1, #0
	beq _02014A3C
	cmp r1, #1
	bne _02014A58
	ldr r0, [r6]
	ldr r0, [r0]
	cmp r0, #0
	bne _02014A58
_02014A3C:
	ldr r0, [sp, #4]
	mov r1, #1
	bl FUN_0201802C
	add sp, sp, #0x7c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02014A58:
	cmp r1, #1
	bne _02014A8C
	ldr r0, [r6]
	ldr r0, [r0]
	cmp r0, #1
	bne _02014A8C
	ldr r0, [sp, #4]
	mov r1, r7
	bl FUN_020180D4
	add sp, sp, #0x7c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02014A8C:
	ldr r0, [sp, #0xa4]
	str r0, [sp, #0x18]
	cmp r0, #0
	bne _02014AC0
	bl FUN_02015B10
	str r0, [sp, #0x18]
	cmp r0, #0
	beq _0201511C
	ldr r2, [sp, #0xa0]
	mov r1, r5
	bl FUN_02015B44
	cmp r0, #0
	beq _0201511C
_02014AC0:
	ldr r3, [sp, #0xa0]
	add r1, sp, #0x34
	mov r4, r3
	ldr r4, [r4, #0x10c]
	mov r0, r6
	mov r2, #0
	str r4, [sp, #0x1c]
	bl FUN_02015ED8
	cmp r0, #0
	beq _0201511C
	ldr r0, [sp, #0xa0]
	ldr r0, [r0]
	add r1, r0, #1
	ldr r0, [sp, #0xa0]
	str r1, [r0]
	ldr r0, [sp, #0x34]
	ldrb r1, [r0, #2]
	ldrb r0, [r0, #3]
	str r0, [sp, #0x10]
	add r0, r1, #0x3f
	bl FUN_020184CC
	ldr r1, [sp, #0x34]
	mov r4, r0
	add r0, r1, #4
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x18]
	ldr r3, [r7, #4]
	ldr sl, [r0, #0x24]
	cmp r3, sl
	bne _02014B58
	ldr r1, [r7]
	sub r2, sl, #1
	ldr r0, [r5]
	ldr r1, [r1, r2, lsl #2]
	ldr r0, [r0, r2, lsl #2]
	cmp r1, r0
	strlo r7, [sp, #0x14]
	blo _02014C10
_02014B58:
	cmp r3, sl
	bge _02014BCC
	ldr r0, [sp, #0xa0]
	ldr r3, [r0]
	add r1, r0, #4
	add r2, r3, #1
	str r2, [r0]
	mov r0, #0x14
	mla r0, r3, r0, r1
	ldr r2, [r7, #4]
	mov r1, r0
	str r2, [r1, #4]
	mov r1, sl
	str r0, [sp, #0x14]
	bl FUN_0201833C
	ldr r0, [r7, #4]
	mov r2, #0
	cmp r0, #0
	ble _02014C10
_02014BA4:
	ldr r1, [r7]
	ldr r0, [sp, #0x14]
	ldr r1, [r1, r2, lsl #2]
	ldr r0, [r0]
	str r1, [r0, r2, lsl #2]
	ldr r0, [r7, #4]
	add r2, r2, #1
	cmp r2, r0
	blt _02014BA4
	b _02014C10
_02014BCC:
	ldr r0, [sp, #0xa0]
	mov r2, r5
	ldr r3, [r0]
	mov r1, r7
	add r5, r3, #1
	str r5, [r0]
	add r5, r0, #4
	mov r0, #0x14
	mla r0, r3, r0, r5
	ldr r3, [sp, #0xa0]
	str r0, [sp, #0x14]
	bl FUN_020164C4
	cmp r0, #0
	beq _0201511C
	ldr r0, [sp, #0x14]
	mov r1, sl
	bl FUN_0201833C
_02014C10:
	ldr r0, [sp, #0xa0]
	ldr r3, [r0]
	ldr r0, [r6, #4]
	add r1, r3, #1
	mul r2, r0, r4
	ldr r0, [sp, #0xa0]
	lsl r4, r2, #1
	str r1, [r0]
	ldr r1, [r0]
	add r4, r4, #7
	add r2, r1, #1
	str r2, [r0]
	ldr r2, [sp, #0x10]
	ldr r0, [r0]
	mul r5, r2, sl
	asr r2, r4, #1
	add r2, r4, r2, lsr #30
	add r5, r5, r2, asr #2
	ldr r2, [sp, #0xa0]
	mov r6, #0x14
	add r2, r2, #4
	mla r8, r1, r6, r2
	mla r4, r3, r6, r2
	ldr r1, [sp, #0xa0]
	add r3, r0, #1
	mla r7, r0, r6, r2
	str r3, [r1]
	mov r0, r1
	ldr r0, [r0]
	mla r6, r0, r6, r2
	add r1, r0, #1
	ldr r0, [sp, #0xa0]
	str r1, [r0]
	ldr r0, [sp, #4]
	ldr r0, [r0, #8]
	cmp sl, r0
	ldrle r0, [sp, #4]
	ble _02014CB4
	ldr r0, [sp, #4]
	mov r1, sl
	bl FUN_0201816C
_02014CB4:
	cmp r0, #0
	beq _0201511C
	ldr r0, [r8, #8]
	lsl r1, sl, #2
	cmp r1, r0
	movle r0, r8
	ble _02014CD8
	mov r0, r8
	bl FUN_0201816C
_02014CD8:
	cmp r0, #0
	beq _0201511C
	ldr r1, [r7, #8]
	lsl r0, sl, #1
	str r0, [sp, #0x24]
	cmp r0, r1
	movle r0, r7
	ble _02014D04
	ldr r1, [sp, #0x24]
	mov r0, r7
	bl FUN_0201816C
_02014D04:
	cmp r0, #0
	beq _0201511C
	ldr r0, [r4, #8]
	cmp r5, r0
	movle r0, r4
	ble _02014D28
	mov r1, r5
	mov r0, r4
	bl FUN_0201816C
_02014D28:
	cmp r0, #0
	beq _0201511C
	ldr r1, [r6, #8]
	ldr r0, [sp, #0x24]
	cmp r0, r1
	movle r0, r6
	ble _02014D50
	ldr r1, [sp, #0x24]
	mov r0, r6
	bl FUN_0201816C
_02014D50:
	cmp r0, #0
	beq _0201511C
	ldr r0, [sp, #0x18]
	ldr fp, [r8]
	ldr r8, [r7]
	ldr r6, [r6]
	ldr r1, [r4]
	ldr r7, [r0, #0x48]
	ldr r5, [r0, #0x20]
	ldr r3, [sp, #0x18]
	str r1, [sp, #0x38]
	str sl, [sp]
	ldr r1, [sp, #0x14]
	ldr r3, [r3, #0xc]
	ldr r1, [r1]
	mov r0, r6
	mov r2, sl
	bl FUN_02016A98
	str r7, [sp]
	ldr r0, [sp, #0x38]
	mov r1, r6
	mov r2, r5
	mov r3, sl
	bl FUN_020160E0
	ldr r0, [sp, #0x10]
	cmp r0, #1
	ble _02014E58
	ldr r1, [sp, #0x38]
	mov r0, r6
	mov r2, sl
	mov r3, fp
	bl FUN_02016220
	mov r0, fp
	mov r1, r6
	mov r2, r5
	mov r3, sl
	str r7, [sp]
	bl FUN_020160E0
	ldr r0, [sp, #0x10]
	mov r4, #1
	cmp r0, #1
	ble _02014E58
	lsl r0, sl, #2
	str r0, [sp, #0x28]
	add sb, sp, #0x38
_02014E04:
	sub r3, r4, #1
	ldr r2, [sb, r3, lsl #2]
	ldr r1, [sp, #0x28]
	mov r0, r6
	add r1, r2, r1
	str r1, [sb, r4, lsl #2]
	str sl, [sp]
	ldr r1, [sb, r3, lsl #2]
	mov r2, sl
	mov r3, fp
	bl FUN_02016A98
	str r7, [sp]
	ldr r0, [sb, r4, lsl #2]
	mov r1, r6
	mov r2, r5
	mov r3, sl
	bl FUN_020160E0
	ldr r0, [sp, #0x10]
	add r4, r4, #1
	cmp r4, r0
	blt _02014E04
_02014E58:
	ldr r3, [sp, #0x34]
	add r0, r3, #1
	str r0, [sp, #0x34]
	add r2, r0, #1
	ldrb r1, [r3]
	str r2, [sp, #0x34]
	ldrb sb, [r3, #1]
	cmp sb, #0xff
	bne _02014ED8
	cmp r1, #0
	bne _02014ED8
	add r0, r2, #1
	str r0, [sp, #0x34]
	ldrb r1, [r2]
	b _02014EA8
_02014E94:
	add sb, sb, #0x100
	ldr r1, [sp, #0x34]
	add r1, r1, #2
	str r1, [sp, #0x34]
	ldrb r1, [r0, #1]
_02014EA8:
	ldr r0, [sp, #0x34]
	ldrb r2, [r0]
	cmp r2, #0xff
	bne _02014EC0
	cmp r1, #0
	beq _02014E94
_02014EC0:
	ldr r2, [sp, #0x34]
	add r2, r2, #1
	str r2, [sp, #0x34]
	ldrb r0, [r0]
	add r0, r0, #1
	add sb, sb, r0
_02014ED8:
	asr r2, r1, #1
	add r0, sp, #0x38
	ldr r0, [r0, r2, lsl #2]
	mov r1, r8
	lsl r2, sl, #2
	bl FUN_0200A1D8
	cmp sb, #0
	beq _020150B0
	mov r0, #0xff
	str r0, [sp, #0x2c]
	mov r0, #0
	str r0, [sp, #0x30]
_02014F08:
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	beq _02014F3C
	mov r3, r0
	ldr r1, [sp, #0x2c]
	ldr r2, [sp, #0x20]
	ldr r3, [r3]
	.word 0xE12FFF33
	cmp r0, #0
	ldr r0, [sp, #0x20]
	add r0, r0, #1
	str r0, [sp, #0x20]
	bne _0201511C
_02014F3C:
	ldr r0, [sp, #0xa0]
	ldr r0, [r0, #0x108]
	ands r0, r0, #0x4000
	bne _0201511C
	cmp sb, #0
	ldr r4, [sp, #0x30]
	ble _02014F90
_02014F58:
	mov r0, r6
	mov r1, r8
	mov r2, sl
	mov r3, fp
	bl FUN_02016220
	str r7, [sp]
	mov r0, r8
	mov r1, r6
	mov r2, r5
	mov r3, sl
	bl FUN_020160E0
	add r4, r4, #1
	cmp r4, sb
	blt _02014F58
_02014F90:
	ldr r2, [sp, #0x34]
	add r0, r2, #1
	str r0, [sp, #0x34]
	add r1, r0, #1
	ldrb r0, [r2]
	str r1, [sp, #0x34]
	ldrb sb, [r2, #1]
	cmp sb, #0xff
	bne _02015010
	cmp r0, #0
	bne _02015010
	add r0, r1, #1
	str r0, [sp, #0x34]
	ldrb r0, [r1]
	b _02014FE0
_02014FCC:
	add sb, sb, #0x100
	ldr r0, [sp, #0x34]
	add r0, r0, #2
	str r0, [sp, #0x34]
	ldrb r0, [r1, #1]
_02014FE0:
	ldr r1, [sp, #0x34]
	ldrb r2, [r1]
	cmp r2, #0xff
	bne _02014FF8
	cmp r0, #0
	beq _02014FCC
_02014FF8:
	ldr r2, [sp, #0x34]
	add r2, r2, #1
	str r2, [sp, #0x34]
	ldrb r1, [r1]
	add r1, r1, #1
	add sb, sb, r1
_02015010:
	cmp r0, #0
	bne _02015020
	cmp sb, #0
	beq _020150B0
_02015020:
	cmp sb, #0
	bne _02015030
	cmp r0, #1
	beq _0201506C
_02015030:
	asr r1, r0, #1
	str sl, [sp]
	add r0, sp, #0x38
	ldr r3, [r0, r1, lsl #2]
	mov r0, r6
	mov r1, r8
	mov r2, sl
	bl FUN_02016A98
	mov r0, r8
	mov r1, r6
	mov r2, r5
	mov r3, sl
	str r7, [sp]
	bl FUN_020160E0
	b _020150A8
_0201506C:
	ldr r0, [sp, #0x14]
	str sl, [sp]
	ldr r3, [r0]
	mov r0, r6
	mov r1, r8
	mov r2, sl
	bl FUN_02016A98
	ldr r0, [sp, #4]
	str r7, [sp]
	ldr r0, [r0]
	mov r1, r6
	mov r2, r5
	mov r3, sl
	bl FUN_020160E0
	b _020150F4
_020150A8:
	cmp sb, #0
	bne _02014F08
_020150B0:
	ldr r0, [sp, #0x24]
	mov r2, sl
	cmp sl, r0
	bge _020150D8
	mov r1, #0
_020150C4:
	ldr r0, [sp, #0x24]
	str r1, [r8, r2, lsl #2]
	add r2, r2, #1
	cmp r2, r0
	blt _020150C4
_020150D8:
	ldr r0, [sp, #4]
	str r7, [sp]
	ldr r0, [r0]
	mov r1, r8
	mov r2, r5
	mov r3, sl
	bl FUN_020160E0
_020150F4:
	ldr r0, [sp, #0xa0]
	ldr r0, [r0, #0x108]
	ands r0, r0, #0x4000
	bne _0201511C
	ldr r0, [sp, #4]
	mov r1, r0
	str sl, [r1, #4]
	bl FUN_020182F0
	mov r0, #1
	str r0, [sp, #8]
_0201511C:
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	beq _02015144
	ldr r3, [r0]
	mov r1, #0xff
	mvn r2, #0
	.word 0xE12FFF33
	cmp r0, #0
	movne r0, #0
	strne r0, [sp, #8]
_02015144:
	ldr r0, [sp, #0xa4]
	cmp r0, #0
	bne _02015160
	ldr r0, [sp, #0x18]
	cmp r0, #0
	beq _02015160
	bl FUN_02015A94
_02015160:
	ldr r2, [sp, #0xc]
	ldr r1, [sp, #0xa0]
	ldr r0, [sp, #8]
	str r2, [r1]
	add sp, sp, #0x7c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_02014978

	arm_func_start FUN_0201517C
FUN_0201517C: @ 0x0201517C
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x18c
	mov sl, r0
	mov r0, #0
	str r0, [sp, #8]
	mov r5, r1
	ldr r1, [sp, #8]
	mov r0, r2
	str r2, [sp, #4]
	mov r4, r3
	str r1, [sp, #0xc]
	ldr sb, [sp, #0x1b0]
	bl FUN_02018438
	ldr r1, [r5, #4]
	mov r8, r0
	cmp r1, #0
	beq _020151D8
	cmp r1, #1
	bne _020151F4
	ldr r0, [r5]
	ldr r0, [r0]
	cmp r0, #0
	bne _020151F4
_020151D8:
	mov r0, sl
	mov r1, #0
	bl FUN_0201802C
	add sp, sp, #0x18c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_020151F4:
	ldr r0, [sp, #4]
	ldr r1, [r0, #4]
	cmp r1, #0
	beq _0201521C
	cmp r1, #1
	bne _02015238
	ldr r0, [r0]
	ldr r0, [r0]
	cmp r0, #0
	bne _02015238
_0201521C:
	mov r0, sl
	mov r1, #1
	bl FUN_0201802C
	add sp, sp, #0x18c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02015238:
	cmp r1, #1
	bne _02015270
	ldr r0, [sp, #4]
	ldr r0, [r0]
	ldr r0, [r0]
	cmp r0, #1
	bne _02015270
	mov r0, sl
	mov r1, r5
	bl FUN_020180D4
	add sp, sp, #0x18c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02015270:
	add r0, sp, #0x18
	bl FUN_02015A6C
	add r0, sp, #0x18
	mov r1, r4
	mov r2, sb
	bl FUN_020159F4
	cmp r0, #0
	ble _020154BC
	add r0, sp, #0x4c
	bl FUN_020182DC
	ldr r2, [sb]
	add r1, sb, #4
	mov r0, #0x14
	mla r6, r2, r0, r1
	add r1, r2, #1
	str r1, [sb]
	mov r2, r4
	mov r4, #1
	add r0, sp, #0x4c
	mov r1, r5
	mov r3, sb
	str r4, [sp, #0xc]
	bl FUN_020164C4
	cmp r0, #0
	beq _020154BC
	add r1, sp, #0x4c
	add r3, sp, #0x18
	mov r0, r6
	mov r2, r1
	str sb, [sp]
	bl FUN_02015948
	cmp r0, #0
	beq _020154BC
	cmp r8, #0x11
	movle fp, r4
	ble _02015318
	cmp r8, #0x100
	movge fp, #5
	bge _02015318
	cmp r8, #0x80
	movge fp, #4
	movlt fp, #3
_02015318:
	sub r0, fp, #1
	mov r4, #1
	lsl r7, r4, r0
	cmp r7, #1
	ble _02015374
	add r5, sp, #0x60
_02015330:
	mov r0, r5
	bl FUN_020182DC
	sub r3, r4, #1
	mov r2, #0x14
	add r1, sp, #0x4c
	mla r1, r3, r2, r1
	mov r0, r5
	mov r2, r6
	add r3, sp, #0x18
	str sb, [sp]
	bl FUN_02015948
	cmp r0, #0
	beq _020154BC
	add r4, r4, #1
	cmp r4, r7
	add r5, r5, #0x14
	blt _02015330
_02015374:
	mov r5, #1
	mov r0, sl
	mov r1, r5
	str r4, [sp, #0xc]
	sub r8, r8, #1
	bl FUN_0201802C
	cmp r0, #0
	beq _020154BC
	mov r0, r5
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
_020153A4:
	ldr r0, [sp, #4]
	mov r1, r8
	bl FUN_02017D3C
	cmp r0, #0
	bne _020153F0
	cmp r5, #0
	bne _020153E0
	mov r0, sl
	mov r1, sl
	mov r2, sl
	add r3, sp, #0x18
	str sb, [sp]
	bl FUN_02015948
	cmp r0, #0
	beq _020154BC
_020153E0:
	cmp r8, #0
	beq _020154B4
	sub r8, r8, #1
	b _020153A4
_020153F0:
	ldr r6, [sp, #0x10]
	ldr r7, [sp, #0x14]
	cmp fp, #1
	mov r4, r6
	ble _02015434
_02015404:
	subs r1, r8, r4
	bmi _02015434
	ldr r0, [sp, #4]
	bl FUN_02017D3C
	cmp r0, #0
	subne r0, r4, r7
	lslne r0, r6, r0
	movne r7, r4
	add r4, r4, #1
	orrne r6, r0, #1
	cmp r4, fp
	blt _02015404
_02015434:
	cmp r5, #0
	add r5, r7, #1
	bne _02015478
	cmp r5, #0
	ldr r4, [sp, #0x14]
	ble _02015478
_0201544C:
	mov r0, sl
	mov r1, sl
	mov r2, sl
	add r3, sp, #0x18
	str sb, [sp]
	bl FUN_02015948
	cmp r0, #0
	beq _020154BC
	add r4, r4, #1
	cmp r4, r5
	blt _0201544C
_02015478:
	asr r3, r6, #1
	mov r1, #0x14
	add r0, sp, #0x4c
	mla r2, r3, r1, r0
	mov r0, sl
	mov r1, sl
	add r3, sp, #0x18
	str sb, [sp]
	bl FUN_02015948
	cmp r0, #0
	beq _020154BC
	add r0, r7, #1
	ldr r5, [sp, #0x14]
	subs r8, r8, r0
	bpl _020153A4
_020154B4:
	mov r0, #1
	str r0, [sp, #8]
_020154BC:
	ldr r0, [sp, #0xc]
	ldr r1, [sb]
	cmp r0, #0
	sub r0, r1, #1
	str r0, [sb]
	mov r4, #0
	ble _020154F8
	add r5, sp, #0x4c
_020154DC:
	mov r0, r5
	bl FUN_02018414
	ldr r0, [sp, #0xc]
	add r4, r4, #1
	cmp r4, r0
	add r5, r5, #0x14
	blt _020154DC
_020154F8:
	add r0, sp, #0x18
	bl FUN_02015A38
	ldr r0, [sp, #8]
	add sp, sp, #0x18c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_0201517C

	arm_func_start FUN_02015510
FUN_02015510: @ 0x02015510
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	movs r8, r2
	mov sl, r0
	mov sb, r1
	mov fp, #0
	mov r5, #2
	addeq sp, sp, #4
	mvneq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	mov r0, r8
	bl FUN_0201846C
	cmp r0, #0x20
	beq _02015564
	mov r1, #1
	cmp sl, r1, lsl r0
	addhi sp, sp, #4
	movhi r0, fp
	pophi {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxhi lr
_02015564:
	cmp sl, r8
	rsb r2, r0, #0x20
	subhs sl, sl, r8
	cmp r2, #0
	lslne r1, sl, r2
	rsbne r0, r2, #0x20
	orrne sl, r1, sb, lsr r0
	lslne r8, r8, r2
	ldr r4, _0201564C @ =0x0000FFFF
	lslne sb, sb, r2
	and r7, r4, r8, lsr #16
	and r6, r8, r4
_02015594:
	lsr r0, sl, #0x10
	cmp r0, r7
	moveq r0, r4
	beq _020155B0
	mov r0, sl
	mov r1, r7
	bl FUN_020186D8
_020155B0:
	mul ip, r0, r7
	mul r3, r0, r6
	and r2, r4, sb, lsr #16
_020155BC:
	mov lr, #0x10000
	sub r1, sl, ip
	rsb lr, lr, #0
	ands lr, r1, lr
	bne _020155E8
	add r1, r2, r1, lsl #16
	cmp r3, r1
	subhi ip, ip, r7
	subhi r3, r3, r6
	subhi r0, r0, #1
	bhi _020155BC
_020155E8:
	mul r2, r0, r6
	and r1, r2, r4
	mul r3, r0, r7
	lsl r1, r1, #0x10
	cmp sb, r1
	add r2, r3, r2, lsr #16
	addlo r2, r2, #1
	cmp sl, r2
	addlo sl, sl, r8
	sub sb, sb, r1
	sublo r0, r0, #1
	sub r1, sl, r2
	subs r5, r5, #1
	beq _0201563C
	and r2, r0, r4
	lsl r1, r1, #0x10
	and r0, sb, r4
	orr sl, r1, sb, lsr #16
	lsl fp, r2, #0x10
	lsl sb, r0, #0x10
	b _02015594
_0201563C:
	orr r0, fp, r0
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_0201564C: .4byte 0x0000FFFF
	arm_func_end FUN_02015510

	arm_func_start FUN_02015650
FUN_02015650: @ 0x02015650
	push {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0x18
	mov r8, r0
	add r0, sp, #4
	mov r7, r1
	mov r6, r2
	mov r5, r3
	mvn r4, #0
	bl FUN_020182DC
	add r0, sp, #4
	mov r1, #0
	bl FUN_0201802C
	add r0, sp, #4
	mov r1, r6
	bl FUN_02017DAC
	cmp r0, #0
	beq _020156B4
	add r2, sp, #4
	mov r0, r8
	mov r3, r7
	mov r1, #0
	str r5, [sp]
	bl FUN_020164F8
	cmp r0, #0
	movne r4, r6
_020156B4:
	add r0, sp, #4
	bl FUN_020183BC
	mov r0, r4
	add sp, sp, #0x18
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_02015650

	arm_func_start FUN_020156CC
FUN_020156CC: @ 0x020156CC
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xc
	ldr r6, [sp, #0x30]
	mov sb, r1
	ldr fp, [r6]
	movs sl, r0
	add r0, fp, #1
	str r0, [r6]
	ldr r7, [r6]
	add r4, r6, #4
	mov r0, #0x14
	mla r5, fp, r0, r4
	add ip, r7, #1
	mov r1, #0
	str r5, [sp, #4]
	mla r5, r7, r0, r4
	str ip, [r6]
	str r1, [sp]
	ldreq r1, [r6]
	mov r8, r2
	mlaeq sl, r1, r0, r4
	addeq r0, r1, #1
	streq r0, [r6]
	mov r7, r3
	cmp sb, #0
	bne _0201574C
	ldr r2, [r6]
	add r1, r6, #4
	mov r0, #0x14
	mla sb, r2, r0, r1
	add r0, r2, #1
	str r0, [r6]
_0201574C:
	mov r0, r8
	mov r1, r7
	bl FUN_02017E48
	cmp r0, #0
	bge _0201578C
	mov r0, sl
	mov r1, #0
	bl FUN_0201802C
	mov r0, sb
	mov r1, r8
	bl FUN_020180D4
	add sp, sp, #0xc
	str fp, [r6]
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_0201578C:
	mov r0, r8
	bl FUN_02018438
	ldr r1, [r7, #0x28]
	mov r2, r0
	lsl r0, r1, #1
	cmp r0, r2
	movgt r2, r0
	suble r0, r2, r0
	movgt r4, #0
	addle r0, r0, r0, lsr #31
	asrle r4, r0, #1
	ldr r1, [r7, #0x2c]
	add r0, r2, r2, lsr #31
	asr r0, r0, #1
	cmp r2, r1
	str r0, [sp, #8]
	beq _020157E4
	mov r1, r7
	mov r3, r6
	add r0, r7, #0x14
	bl FUN_02015650
	str r0, [r7, #0x2c]
_020157E4:
	ldr r2, [sp, #8]
	ldr r0, [sp, #4]
	mov r1, r8
	sub r2, r2, r4
	bl FUN_020173E4
	cmp r0, #0
	beq _02015934
	ldr r1, [sp, #4]
	mov r0, r5
	mov r3, r6
	add r2, r7, #0x14
	bl FUN_02016BBC
	cmp r0, #0
	beq _02015934
	ldr r2, [sp, #8]
	mov r0, sl
	mov r1, r5
	add r2, r2, r4
	bl FUN_020173E4
	cmp r0, #0
	beq _02015934
	mov r4, #0
	mov r0, r5
	mov r1, r7
	mov r2, sl
	mov r3, r6
	str r4, [sl, #0xc]
	bl FUN_02016BBC
	cmp r0, #0
	beq _02015934
	mov r0, sb
	mov r1, r8
	mov r2, r5
	bl FUN_02016E00
	cmp r0, #0
	beq _02015934
	mov r5, r4
	mov r0, sb
	mov r1, r7
	str r5, [sb, #0xc]
	bl FUN_02017E48
	cmp r0, #0
	blt _020158E0
	mov r4, #1
_02015894:
	cmp r5, #2
	add r5, r5, #1
	bgt _02015934
	mov r0, sb
	mov r1, sb
	mov r2, r7
	bl FUN_02016E00
	cmp r0, #0
	beq _02015934
	mov r0, sl
	mov r1, r4
	bl FUN_020172BC
	cmp r0, #0
	beq _02015934
	mov r0, sb
	mov r1, r7
	bl FUN_02017E48
	cmp r0, #0
	bge _02015894
_020158E0:
	ldr r0, [sb, #4]
	mov r1, #1
	cmp r0, #0
	beq _0201590C
	cmp r0, #1
	bne _02015908
	ldr r0, [sb]
	ldr r0, [r0]
	cmp r0, #0
	beq _0201590C
_02015908:
	mov r1, #0
_0201590C:
	cmp r1, #0
	movne r0, #0
	ldreq r0, [r8, #0xc]
	str r0, [sb, #0xc]
	mov r0, #1
	ldr r2, [r8, #0xc]
	ldr r1, [r7, #0xc]
	str r0, [sp]
	eor r0, r2, r1
	str r0, [sl, #0xc]
_02015934:
	ldr r0, [sp]
	str fp, [r6]
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_020156CC

	arm_func_start FUN_02015948
FUN_02015948: @ 0x02015948
	push {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #8
	ldr r4, [sp, #0x20]
	mov ip, #0x14
	ldr r5, [r4]
	add lr, r4, #4
	mla r6, r5, ip, lr
	add ip, r5, #1
	mov r8, r0
	mov r7, r3
	str ip, [r4]
	cmp r2, #0
	mov r5, #0
	beq _020159B8
	cmp r1, r2
	bne _020159A0
	mov r0, r6
	mov r2, r4
	bl FUN_0201630C
	cmp r0, #0
	bne _020159BC
	b _020159D8
_020159A0:
	mov r0, r6
	mov r3, r4
	bl FUN_02016BBC
	cmp r0, #0
	bne _020159BC
	b _020159D8
_020159B8:
	mov r6, r1
_020159BC:
	mov r1, r8
	mov r2, r6
	mov r3, r7
	mov r0, #0
	str r4, [sp]
	bl FUN_020156CC
	mov r5, #1
_020159D8:
	ldr r1, [r4]
	mov r0, r5
	sub r1, r1, #1
	str r1, [r4]
	add sp, sp, #8
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_02015948

	arm_func_start FUN_020159F4
FUN_020159F4: @ 0x020159F4
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	bl FUN_020180D4
	add r0, r5, #0x14
	mov r1, #0
	bl FUN_0201802C
	mov r0, r4
	bl FUN_02018438
	str r0, [r5, #0x28]
	mov r0, #0
	str r0, [r5, #0x2c]
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_020159F4

	arm_func_start FUN_02015A38
FUN_02015A38: @ 0x02015A38
	push {r4, lr}
	mov r4, r0
	bl FUN_020183BC
	add r0, r4, #0x14
	bl FUN_020183BC
	ldr r0, [r4, #0x30]
	ands r0, r0, #1
	popeq {r4, lr}
	bxeq lr
	mov r0, r4
	bl FUN_02014350
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02015A38

	arm_func_start FUN_02015A6C
FUN_02015A6C: @ 0x02015A6C
	push {r4, lr}
	mov r4, r0
	bl FUN_020182DC
	add r0, r4, #0x14
	bl FUN_020182DC
	mov r0, #0
	str r0, [r4, #0x28]
	str r0, [r4, #0x30]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02015A6C

	arm_func_start FUN_02015A94
FUN_02015A94: @ 0x02015A94
	push {r4, lr}
	mov r4, r0
	add r0, r4, #0xc
	bl FUN_020183BC
	add r0, r4, #0x20
	bl FUN_020183BC
	add r0, r4, #0x34
	bl FUN_020183BC
	ldr r0, [r4, #0x4c]
	ands r0, r0, #1
	popeq {r4, lr}
	bxeq lr
	mov r0, r4
	bl FUN_02014350
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02015A94

	arm_func_start FUN_02015AD4
FUN_02015AD4: @ 0x02015AD4
	push {r4, lr}
	mov r4, r0
	mov r1, #0
	str r1, [r4]
	add r0, r4, #0xc
	str r1, [r4, #8]
	bl FUN_020182DC
	add r0, r4, #0x20
	bl FUN_020182DC
	add r0, r4, #0x34
	bl FUN_020182DC
	mov r0, #0
	str r0, [r4, #0x4c]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02015AD4

	arm_func_start FUN_02015B10
FUN_02015B10: @ 0x02015B10
	push {r4, lr}
	mov r0, #0x50
	bl FUN_02014398
	movs r4, r0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	bl FUN_02015AD4
	mov r1, #1
	mov r0, r4
	str r1, [r4, #0x4c]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02015B10

	arm_func_start FUN_02015B44
FUN_02015B44: @ 0x02015B44
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #0x14
	mov r6, r1
	ldr r3, [r6, #4]
	mov r7, r0
	cmp r3, #0
	mov r5, r2
	addeq sp, sp, #0x14
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	add r0, r7, #0x20
	add r4, r7, #0xc
	bl FUN_020180D4
	cmp r0, #0
	addeq sp, sp, #0x14
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	add r0, sp, #0
	bl FUN_020182DC
	mov r1, #1
	mov r0, r6
	str r1, [r7]
	bl FUN_02018438
	add r1, r0, #0x1f
	asr r0, r1, #4
	add r0, r1, r0, lsr #27
	asr r2, r0, #5
	mov r0, r4
	mov r1, #0
	str r2, [r7, #8]
	bl FUN_0201802C
	cmp r0, #0
	addeq sp, sp, #0x14
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, r4
	mov r1, #0x20
	bl FUN_02017DAC
	cmp r0, #0
	beq _02015CE8
	ldr r0, [r6]
	ldr r4, [r0]
	mov r0, r4
	bl FUN_0201604C
	mov r1, r0
	add r0, sp, #0
	bl FUN_0201802C
	cmp r0, #0
	beq _02015CE8
	add r0, sp, #0
	mov r2, #0x20
	mov r1, r0
	bl FUN_02017500
	cmp r0, #0
	beq _02015CE8
	ldr r0, [sp, #4]
	cmp r0, #0
	beq _02015C60
	cmp r0, #1
	bne _02015C50
	ldr r0, [sp]
	ldr r0, [r0]
	cmp r0, #0
	beq _02015C60
_02015C50:
	add r0, sp, #0
	mov r1, #1
	bl FUN_0201715C
	b _02015C74
_02015C60:
	add r0, sp, #0
	mvn r1, #0
	bl FUN_0201802C
	cmp r0, #0
	beq _02015CE8
_02015C74:
	ldr r2, [sp, #4]
	cmp r2, #1
	ldrge r0, [sp]
	ldrge r1, [r0]
	movlt r1, #0
	cmp r2, #2
	ldrge r0, [sp]
	mov r2, r4
	ldrge r0, [r0, #4]
	movlt r0, #0
	bl FUN_02015510
	str r0, [r7, #0x48]
	add r0, r7, #0xc
	mov r1, #0
	bl FUN_0201802C
	ldr r1, [r7, #8]
	add r0, r7, #0xc
	lsl r1, r1, #6
	bl FUN_02017DAC
	cmp r0, #0
	beq _02015CE8
	add r0, r7, #0xc
	mov r1, r0
	mov r3, r5
	add r2, r7, #0x20
	bl FUN_020164C4
	ldr r1, [r7, #8]
	add r0, r7, #0xc
	bl FUN_0201833C
_02015CE8:
	add r0, sp, #0
	bl FUN_020183BC
	mov r0, #1
	add sp, sp, #0x14
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02015B44

	arm_func_start FUN_02015D00
FUN_02015D00: @ 0x02015D00
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xc
	mov r4, r2
	mov r7, r1
	cmp r4, #6
	mov r5, r0
	movgt r4, #6
	mov r1, #1
	lsl r2, r1, r4
	ldr r0, [r7, #4]
	sub r2, r2, #1
	add r0, r4, r0, lsl #5
	ldr r3, _02015ED4 @ =0x0231CF64
	str r2, [sp]
	ldr r2, [r3, r4, lsl #2]
	mov r1, r4
	sub r0, r0, #1
	str r2, [sp, #4]
	mov r6, #0
	bl FUN_020184CC
	mov ip, #0
	lsl r0, r0, #1
	add r0, r0, #2
	mov r8, r6
	add r1, r5, r0
	strb r8, [r5, r0]
	strb r8, [r1, #-1]
	ldr r0, [r7]
	ldr r2, [r7, #4]
	ldr r7, [r0]
	add lr, r0, #4
	cmp r2, #1
	sub sb, r1, #2
	ldrgt r8, [lr], #4
	mov sl, r7
	mov r0, ip
	str ip, [sp, #8]
	mov r1, #0xff
	mov fp, ip
_02015D9C:
	ldr r3, [sp]
	and r3, sl, r3
	ldr sl, [sp, #4]
	ldrb sl, [sl, r3]
	cmp sl, #0
	beq _02015DFC
	add ip, ip, sl
	add r6, r6, sl
	cmp r6, #0x20
	blo _02015DE4
	cmp r2, #1
	ble _02015DFC
	sub r2, r2, #1
	mov r7, r8
	cmp r2, #1
	movle r8, fp
	ldrgt r8, [lr], #4
	sub r6, r6, #0x20
_02015DE4:
	cmp r6, #0
	moveq sl, r7
	lsrne sl, r7, r6
	rsbne r3, r6, #0x20
	orrne sl, sl, r8, lsl r3
	b _02015D9C
_02015DFC:
	cmp r3, #0
	beq _02015E80
	strb ip, [sb]
	strb r3, [sb, #-1]
	cmp ip, #0x100
	sub sb, sb, #2
	blo _02015E38
	cmp ip, #0x100
	blo _02015E38
_02015E20:
	strb r1, [sb]
	sub ip, ip, #0x100
	strb r0, [sb, #-1]
	sub sb, sb, #2
	cmp ip, #0x100
	bhs _02015E20
_02015E38:
	mov ip, r4
	add r6, r6, r4
	cmp r6, #0x20
	blo _02015E68
	cmp r2, #1
	ble _02015E80
	sub r2, r2, #1
	mov r7, r8
	cmp r2, #1
	ldrle r8, [sp, #8]
	sub r6, r6, #0x20
	ldrgt r8, [lr], #4
_02015E68:
	cmp r6, #0
	moveq sl, r7
	lsrne sl, r7, r6
	rsbne r3, r6, #0x20
	orrne sl, sl, r8, lsl r3
	b _02015D9C
_02015E80:
	add sb, sb, #1
	mov r0, #2
	b _02015EA4
_02015E8C:
	strb r2, [r5]
	ldrb r1, [sb, #1]
	add sb, sb, #2
	add r0, r0, #2
	strb r1, [r5, #1]
	add r5, r5, #2
_02015EA4:
	ldrb r2, [sb]
	cmp r2, #0
	bne _02015E8C
	ldrb r1, [sb, #1]
	cmp r1, #0
	bne _02015E8C
	mov r1, #0
	strb r1, [r5]
	strb r1, [r5, #1]
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_02015ED4: .4byte 0x0231CF64
	arm_func_end FUN_02015D00

	arm_func_start FUN_02015ED8
FUN_02015ED8: @ 0x02015ED8
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	ldr r5, [r3], #4
	mov r2, #0x14
	mla r4, r5, r2, r3
	mov sb, r0
	ldr r0, [sb, #4]
	mov r8, r1
	cmp r0, #0
	mov r5, #0
	lsl r1, r0, #5
	addeq sp, sp, #4
	moveq r0, r5
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	cmp r0, #1
	bne _02015F78
	cmp r0, #1
	bne _02015F3C
	ldr r2, [sb]
	ldr r1, _0201603C @ =0x00010001
	ldr r2, [r2]
	cmp r2, r1
	ldreq r5, _02016040 @ =0x02314254
	beq _02015F68
_02015F3C:
	ldr r1, [sb]
	ldr r1, [r1]
	cmp r1, #0x11
	bne _02015F58
	cmp r0, #1
	ldreq r5, _02016044 @ =0x0231426C
	beq _02015F68
_02015F58:
	cmp r1, #3
	bne _02015F68
	cmp r0, #1
	ldreq r5, _02016048 @ =0x02314260
_02015F68:
	mov r7, #1
	mov r6, r7
	mov r1, #0x20
	b _02015FA8
_02015F78:
	cmp r1, #0x100
	movge r7, #5
	movge r6, #0x10
	movge r1, #7
	bge _02015FA8
	cmp r1, #0x80
	movge r6, #8
	movge r1, r6
	movge r7, #4
	movlt r7, #3
	movlt r6, #4
	movlt r1, #0xb
_02015FA8:
	mul r1, r0, r1
	lsl r0, r1, #1
	add r1, r0, #7
	asr r0, r1, #1
	add r0, r1, r0, lsr #30
	cmp r5, #0
	asr r1, r0, #2
	bne _02016024
	ldr r0, [r4, #8]
	cmp r1, r0
	movle r0, r4
	ble _02015FE0
	mov r0, r4
	bl FUN_0201816C
_02015FE0:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	ldr r5, [r4]
	mov r1, sb
	mov r2, r7
	add r0, r5, #4
	bl FUN_02015D00
	add r1, r0, #2
	asr r0, r1, #8
	strb r0, [r5]
	strb r1, [r5, #1]
	strb r7, [r5, #2]
	strb r6, [r5, #3]
	b _02016028
_02016024:
	mov r1, #8
_02016028:
	str r5, [r8]
	add r0, r1, #2
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	.align 2, 0
_0201603C: .4byte 0x00010001
_02016040: .4byte 0x02314254
_02016044: .4byte 0x0231426C
_02016048: .4byte 0x02314260
	arm_func_end FUN_02015ED8

	arm_func_start FUN_0201604C
FUN_0201604C: @ 0x0201604C
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov sl, r0
	mov r1, sl
	rsb r0, sl, #0
	bl FUN_020186D8
	movs r8, r1
	mov r7, sl
	mov r5, #0
	mov r6, #1
	mvn r4, #0
	beq _020160B4
_02016078:
	mov r0, r7
	mov r1, r8
	bl FUN_020186D8
	mov sb, r1
	mov r0, r7
	mov r1, r8
	bl FUN_020186D8
	mla r1, r0, r6, r5
	mov r5, r6
	mov r7, r8
	mov r6, r1
	mov r8, sb
	cmp sb, #0
	rsb r4, r4, #0
	bne _02016078
_020160B4:
	cmp r4, #0
	sublt r5, sl, r5
	cmp r7, #1
	movne r1, #0
	bne _020160D4
	mov r0, r5
	mov r1, sl
	bl FUN_020186D8
_020160D4:
	mov r0, r1
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	arm_func_end FUN_0201604C

	arm_func_start FUN_020160E0
FUN_020160E0: @ 0x020160E0
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xc
	mov r7, r3
	mov sb, r1
	mov r6, #0
	mov sl, r0
	mov r8, r2
	mov r4, r6
	cmp r7, #0
	add r5, sb, r7, lsl #2
	ldr fp, [sp, #0x30]
	ble _02016170
	mov r0, #1
	str r6, [sp, #4]
	str r0, [sp]
_0201611C:
	ldr r1, [sb]
	mov r0, sb
	mul r3, r1, fp
	mov r1, r8
	mov r2, r7
	bl FUN_02017B5C
	add r1, r0, r6
	ldr r0, [r5]
	cmp r1, r6
	ldrlo r6, [sp]
	add r0, r0, r1
	str r0, [r5]
	ldr r0, [r5]
	ldrhs r6, [sp, #4]
	cmp r0, r1
	add r4, r4, #1
	addlo r6, r6, #1
	cmp r4, r7
	add sb, sb, #4
	add r5, r5, #4
	blt _0201611C
_02016170:
	cmp r6, #0
	sub r2, r7, #1
	bne _020161C4
	ldr r1, [sb, r2, lsl #2]
	ldr r0, [r8, r2, lsl #2]
	cmp r1, r0
	bne _020161B0
	cmp r2, #0
	ble _020161B0
_02016194:
	ldr r1, [sb, r2, lsl #2]
	ldr r0, [r8, r2, lsl #2]
	cmp r1, r0
	bne _020161B0
	sub r2, r2, #1
	cmp r2, #0
	bgt _02016194
_020161B0:
	ldr r1, [sb, r2, lsl #2]
	ldr r0, [r8, r2, lsl #2]
	cmp r1, r0
	movhs r6, #1
	movlo r6, #0
_020161C4:
	cmp r6, #0
	beq _020161EC
	mov r0, sl
	mov r1, sb
	mov r2, r8
	mov r3, r7
	bl FUN_02017604
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_020161EC:
	cmp r7, #0
	addle sp, sp, #0xc
	mov r1, #0
	pople {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxle lr
_02016200:
	ldr r0, [sb, r1, lsl #2]
	str r0, [sl, r1, lsl #2]
	add r1, r1, #1
	cmp r1, r7
	blt _02016200
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_020160E0

	arm_func_start FUN_02016220
FUN_02016220: @ 0x02016220
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	mov fp, r2
	lsl r6, fp, #1
	mov sl, r0
	mov r7, fp
	mov sb, r1
	sub r7, r7, #1
	sub r2, r6, #1
	mov r0, #0
	str r0, [sl, r2, lsl #2]
	ldr r0, [sl, r2, lsl #2]
	str r3, [sp]
	mov r5, sb
	str r0, [sl]
	cmp r7, #0
	add r4, sl, #4
	ble _02016288
	add r5, r5, #4
	ldr r3, [sb]
	mov r0, r4
	mov r1, r5
	mov r2, r7
	bl FUN_020179BC
	str r0, [r4, r7, lsl #2]
	add r4, r4, #8
_02016288:
	sub r8, fp, #2
	cmp r8, #0
	ble _020162C8
_02016294:
	mov r0, r5
	sub r7, r7, #1
	add r5, r5, #4
	ldr r3, [r0]
	mov r0, r4
	mov r1, r5
	mov r2, r7
	bl FUN_02017B5C
	sub r8, r8, #1
	str r0, [r4, r7, lsl #2]
	cmp r8, #0
	add r4, r4, #8
	bgt _02016294
_020162C8:
	mov r0, sl
	mov r1, sl
	mov r2, sl
	mov r3, r6
	bl FUN_02017718
	ldr r0, [sp]
	mov r1, sb
	mov r2, fp
	bl FUN_02017868
	ldr r2, [sp]
	mov r0, sl
	mov r1, sl
	mov r3, r6
	bl FUN_02017718
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_02016220

	arm_func_start FUN_0201630C
FUN_0201630C: @ 0x0201630C
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #0x64
	ldr r5, [r2]
	mov sb, r0
	mov r8, r1
	cmp r8, sb
	add r3, r2, #4
	mov r2, #0x14
	movne r7, sb
	addeq r0, r5, #1
	mla r4, r5, r2, r3
	mlaeq r7, r0, r2, r3
	ldr r5, [r8, #4]
	cmp r5, #0
	movle r0, #0
	strle r0, [sb, #4]
	addle sp, sp, #0x64
	movle r0, #1
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r0, [r7, #8]
	lsl r6, r5, #1
	cmp r6, r0
	movle r0, r7
	ble _0201637C
	mov r0, r7
	mov r1, r6
	bl FUN_0201816C
_0201637C:
	cmp r0, #0
	addeq sp, sp, #0x64
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	str r6, [r7, #4]
	mov r0, #0
	str r0, [r7, #0xc]
	cmp r5, #4
	bne _020163BC
	ldr r0, [r7]
	ldr r1, [r8]
	add r3, sp, #0
	mov r2, #4
	bl FUN_02016220
	b _02016420
_020163BC:
	cmp r5, #8
	bne _020163DC
	ldr r0, [r7]
	ldr r1, [r8]
	add r3, sp, #0x20
	mov r2, #8
	bl FUN_02016220
	b _02016420
_020163DC:
	ldr r0, [r4, #8]
	cmp r6, r0
	movle r0, r4
	ble _020163F8
	mov r0, r4
	mov r1, r6
	bl FUN_0201816C
_020163F8:
	cmp r0, #0
	addeq sp, sp, #0x64
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	ldr r0, [r7]
	ldr r1, [r8]
	ldr r3, [r4]
	mov r2, r5
	bl FUN_02016220
_02016420:
	cmp r6, #0
	ble _02016444
	ldr r1, [r7]
	sub r0, r6, #1
	ldr r0, [r1, r0, lsl #2]
	cmp r0, #0
	ldreq r0, [r7, #4]
	subeq r0, r0, #1
	streq r0, [r7, #4]
_02016444:
	cmp r7, sb
	beq _02016458
	mov r0, sb
	mov r1, r7
	bl FUN_020180D4
_02016458:
	mov r0, #1
	add sp, sp, #0x64
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_0201630C

	arm_func_start FUN_02016468
FUN_02016468: @ 0x02016468
	stmdb sp!, {lr}
	sub sp, sp, #0xc
	ldr ip, [r3, #4]
	cmp ip, #0
	ble _020164AC
	ldr ip, [r3]
	ldr ip, [ip]
	ands ip, ip, #1
	beq _020164AC
	ldr lr, [sp, #0x10]
	mov ip, #0
	str lr, [sp]
	str ip, [sp, #4]
	bl FUN_02014978
	add sp, sp, #0xc
	ldm sp!, {lr}
	bx lr
_020164AC:
	ldr ip, [sp, #0x10]
	str ip, [sp]
	bl FUN_0201517C
	add sp, sp, #0xc
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02016468

	arm_func_start FUN_020164C4
FUN_020164C4: @ 0x020164C4
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov lr, r1
	mov ip, r2
	str r3, [sp]
	mov r1, r0
	mov r2, lr
	mov r3, ip
	mov r0, #0
	bl FUN_020164F8
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_020164C4

	arm_func_start FUN_020164F8
FUN_020164F8: @ 0x020164F8
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0x4c
	mov r6, r3
	ldr r3, [r6, #4]
	mov r8, r0
	str r1, [sp]
	str r2, [sp, #4]
	cmp r3, #0
	ldr r4, [sp, #0x70]
	beq _02016538
	cmp r3, #1
	bne _02016548
	ldr r0, [r6]
	ldr r0, [r0]
	cmp r0, #0
	bne _02016548
_02016538:
	add sp, sp, #0x4c
	mov r0, #0
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02016548:
	ldr r0, [sp, #4]
	mov r1, r6
	bl FUN_02017E48
	cmp r0, #0
	bge _020165A8
	ldr r0, [sp]
	cmp r0, #0
	beq _02016584
	ldr r1, [sp, #4]
	bl FUN_020180D4
	cmp r0, #0
	addeq sp, sp, #0x4c
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
_02016584:
	cmp r8, #0
	beq _02016598
	mov r0, r8
	mov r1, #0
	bl FUN_0201802C
_02016598:
	add sp, sp, #0x4c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_020165A8:
	ldr r3, [r4]
	add r0, r4, #4
	mov r2, #0x14
	mla r1, r3, r2, r0
	mov r3, #0
	str r3, [r1, #0xc]
	ldr r5, [r4]
	str r1, [sp, #0x14]
	add r4, r5, #1
	mla r1, r4, r2, r0
	add r3, r5, #2
	str r1, [sp, #0x18]
	mla r1, r3, r2, r0
	cmp r8, #0
	str r1, [sp, #0x1c]
	addeq r1, r5, #3
	mlaeq r8, r1, r2, r0
	mov r0, r6
	bl FUN_02018438
	lsr r1, r0, #0x1f
	rsb r0, r1, r0, lsl #27
	add r0, r1, r0, ror #27
	rsb r0, r0, #0x20
	str r0, [sp, #8]
	ldr r0, [sp, #0x1c]
	ldr r2, [sp, #8]
	mov r1, r6
	bl FUN_02017500
	cmp r0, #0
	addeq sp, sp, #0x4c
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldr r2, [sp, #8]
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #4]
	ldr r3, [sp, #0x1c]
	mov r4, #0
	add r2, r2, #0x20
	str r4, [r3, #0xc]
	bl FUN_02017500
	cmp r0, #0
	addeq sp, sp, #0x4c
	moveq r0, r4
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldr r0, [sp, #0x18]
	mov r1, r4
	str r1, [r0, #0xc]
	ldr r0, [sp, #0x1c]
	ldr r0, [r0, #4]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x28]
	ldr r4, [r0, #4]
	add r0, sp, #0x38
	sub r1, r4, r1
	str r1, [sp, #0x10]
	bl FUN_020182DC
	ldr r0, [sp, #0x18]
	ldr r2, [r0]
	ldr r0, [sp, #0x28]
	sub r1, r0, #1
	ldr r0, [sp, #0x10]
	add r0, r2, r0, lsl #2
	str r0, [sp, #0x38]
	ldr r0, [sp, #0x28]
	str r0, [sp, #0x3c]
	ldr r0, [sp, #0x18]
	ldr r2, [r0, #8]
	ldr r0, [sp, #0x28]
	cmp r0, #1
	add r0, r2, #1
	str r0, [sp, #0x40]
	ldr r0, [sp, #0x1c]
	moveq r5, #0
	ldr r2, [r0]
	ldr r0, [r2, r1, lsl #2]
	str r0, [sp, #0x24]
	ldrne r0, [sp, #0x28]
	subne r0, r0, #2
	ldrne r5, [r2, r0, lsl #2]
	ldr r0, [sp, #0x18]
	ldr r2, [r8, #8]
	ldr r1, [r0]
	sub r0, r4, #1
	add r7, r1, r0, lsl #2
	ldr r0, [sp, #0x10]
	add r1, r0, #1
	cmp r1, r2
	movle r0, r8
	ble _02016720
	mov r0, r8
	bl FUN_0201816C
_02016720:
	cmp r0, #0
	beq _02016A84
	ldr r0, [sp, #4]
	ldr r1, [r6, #0xc]
	ldr r3, [r0, #0xc]
	ldr r0, [sp, #0x10]
	sub r2, r0, #1
	eor r0, r3, r1
	str r0, [r8, #0xc]
	ldr r0, [sp, #0x10]
	str r0, [r8, #4]
	ldr r0, [sp, #0x28]
	ldr r3, [r8]
	add r1, r0, #1
	add r0, r3, r2, lsl #2
	str r0, [sp, #0x20]
	ldr r0, [sp, #0x14]
	ldr r0, [r0, #8]
	cmp r1, r0
	ldrle r0, [sp, #0x14]
	ble _0201677C
	ldr r0, [sp, #0x14]
	bl FUN_0201816C
_0201677C:
	cmp r0, #0
	beq _02016A84
	ldr r1, [sp, #0x1c]
	add r0, sp, #0x38
	bl FUN_02017E48
	cmp r0, #0
	blt _020167D0
	add r0, sp, #0x38
	ldr r2, [sp, #0x1c]
	mov r1, r0
	bl FUN_02016E00
	cmp r0, #0
	beq _02016A84
	ldr r0, [sp, #0x20]
	mov r2, #1
	str r2, [r0]
	ldr r0, [r8, #4]
	ldr r1, [r8]
	sub r0, r0, #1
	str r2, [r1, r0, lsl #2]
	b _020167DC
_020167D0:
	ldr r0, [r8, #4]
	sub r0, r0, #1
	str r0, [r8, #4]
_020167DC:
	ldr r0, [sp, #0x10]
	sub r1, r0, #1
	ldr r0, [sp, #0x20]
	cmp r1, #0
	sub r0, r0, #4
	str r0, [sp, #0x20]
	mov r0, #0
	str r0, [sp, #0xc]
	ble _02016A2C
	ldr r8, _02016A94 @ =0x0000FFFF
	cmp r1, #0
	and r0, r5, r8
	str r0, [sp, #0x2c]
	and r0, r8, r5, lsr #16
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x24]
	and r4, r0, r8
	ble _02016A2C
	and sb, r8, r0, lsr #16
	mvn r0, #0
	str r0, [sp, #0x34]
_02016830:
	ldr r1, [sp, #0x38]
	ldr r0, [sp, #0x3c]
	sub r1, r1, #4
	add r0, r0, #1
	str r0, [sp, #0x3c]
	str r1, [sp, #0x38]
	ldr fp, [r7]
	ldr r0, [sp, #0x24]
	ldr r5, [r7, #-4]
	cmp fp, r0
	ldreq r6, [sp, #0x34]
	beq _02016874
	ldr r2, [sp, #0x24]
	mov r0, fp
	mov r1, r5
	bl FUN_02015510
	mov r6, r0
_02016874:
	ldr r0, [sp, #0x2c]
	and r2, r6, r8
	mul ip, r0, r2
	ldr r0, [sp, #0x30]
	and lr, r8, r6, lsr #16
	ldr r1, [sp, #0x30]
	mul r0, r2, r0
	mul r3, r1, lr
	ldr r1, [sp, #0x2c]
	mul sl, sb, lr
	mla r1, lr, r1, r0
	cmp r1, r0
	addlo r3, r3, #0x10000
	and r0, r8, r1, lsr #16
	add r3, r3, r0
	and r0, r1, r8
	add ip, ip, r0, lsl #16
	cmp ip, r0, lsl #16
	mul r0, r2, sb
	mul r1, r4, r2
	mla r2, lr, r4, r0
	addlo r3, r3, #1
	cmp r2, r0
	addlo sl, sl, #0x10000
	and r0, r8, r2, lsr #16
	add sl, sl, r0
	and r0, r2, r8
	add r1, r1, r0, lsl #16
	cmp r1, r0, lsl #16
	addlo sl, sl, #1
	sub r1, r5, r1
	cmp r1, r5
	addhi sl, sl, #1
	subs r0, fp, sl
	bne _02016924
	cmp r3, r1
	blo _02016924
	cmp r3, r1
	bne _0201691C
	ldr r0, [r7, #-8]
	cmp ip, r0
	bls _02016924
_0201691C:
	sub r6, r6, #1
	b _02016874
_02016924:
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x1c]
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [sp, #0x28]
	mov r3, r6
	bl FUN_020179BC
	ldr r1, [sp, #0x14]
	ldr r2, [sp, #0x28]
	ldr r3, [r1]
	ldr r1, [sp, #0x28]
	str r0, [r3, r2, lsl #2]
	add r1, r1, #1
	cmp r1, #0
	ble _02016984
	ldr r0, [sp, #0x14]
	ldr r2, [r0]
_02016968:
	sub r0, r1, #1
	ldr r0, [r2, r0, lsl #2]
	cmp r0, #0
	bne _02016984
	sub r1, r1, #1
	cmp r1, #0
	bgt _02016968
_02016984:
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x14]
	str r1, [r0, #4]
	add r0, sp, #0x38
	mov r1, r0
	ldr r5, [sp, #0x3c]
	bl FUN_02016CBC
	ldr r0, [sp, #0x18]
	ldr r1, [r0, #4]
	ldr r0, [sp, #0x3c]
	add r0, r1, r0
	sub r1, r0, r5
	ldr r0, [sp, #0x18]
	str r1, [r0, #4]
	ldr r0, [sp, #0x44]
	cmp r0, #0
	beq _020169FC
	add r0, sp, #0x38
	ldr r2, [sp, #0x1c]
	mov r1, r0
	sub r6, r6, #1
	ldr r5, [sp, #0x3c]
	bl FUN_02017080
	ldr r0, [sp, #0x18]
	ldr r1, [r0, #4]
	ldr r0, [sp, #0x3c]
	sub r0, r0, r5
	add r1, r1, r0
	ldr r0, [sp, #0x18]
	str r1, [r0, #4]
_020169FC:
	ldr r0, [sp, #0x20]
	sub r7, r7, #4
	str r6, [r0], #-4
	str r0, [sp, #0x20]
	ldr r0, [sp, #0xc]
	add r0, r0, #1
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	sub r1, r0, #1
	ldr r0, [sp, #0xc]
	cmp r0, r1
	blt _02016830
_02016A2C:
	ldr r0, [sp, #0x18]
	bl FUN_020182F0
	ldr r0, [sp]
	cmp r0, #0
	beq _02016A74
	ldr r2, [sp, #8]
	ldr r3, [sp, #4]
	ldr r1, [sp, #0x18]
	add r2, r2, #0x20
	ldr r4, [r3, #0xc]
	bl FUN_020173E4
	cmp r0, #0
	addeq sp, sp, #0x4c
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	ldr r0, [sp]
	str r4, [r0, #0xc]
_02016A74:
	add sp, sp, #0x4c
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02016A84:
	mov r0, #0
	add sp, sp, #0x4c
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	.align 2, 0
_02016A94: .4byte 0x0000FFFF
	arm_func_end FUN_020164F8

	arm_func_start FUN_02016A98
FUN_02016A98: @ 0x02016A98
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	ldr r5, [sp, #0x20]
	mov r7, r2
	mov sb, r0
	mov r8, r1
	mov r6, r3
	cmp r7, r5
	bge _02016AD4
	mov r1, r7
	mov r0, r8
	mov r7, r5
	mov r8, r6
	mov r5, r1
	mov r6, r0
_02016AD4:
	ldr r3, [r6]
	mov r0, sb
	mov r1, r8
	mov r2, r7
	add r4, sb, r7, lsl #2
	bl FUN_020179BC
	str r0, [sb, r7, lsl #2]
_02016AF0:
	sub r0, r5, #1
	cmp r0, #0
	addle sp, sp, #4
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r3, [r6, #4]
	mov r1, r8
	mov r2, r7
	add r0, sb, #4
	bl FUN_02017B5C
	sub r1, r5, #2
	cmp r1, #0
	addle sp, sp, #4
	str r0, [r4, #4]
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r3, [r6, #8]
	mov r1, r8
	mov r2, r7
	add r0, sb, #8
	bl FUN_02017B5C
	sub r1, r5, #3
	cmp r1, #0
	addle sp, sp, #4
	str r0, [r4, #8]
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r3, [r6, #0xc]
	mov r1, r8
	mov r2, r7
	add r0, sb, #0xc
	bl FUN_02017B5C
	sub r5, r5, #4
	cmp r5, #0
	addle sp, sp, #4
	str r0, [r4, #0xc]
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r3, [r6, #0x10]
	mov r1, r8
	mov r2, r7
	add r0, sb, #0x10
	bl FUN_02017B5C
	str r0, [r4, #0x10]
	add r4, r4, #0x10
	add sb, sb, #0x10
	add r6, r6, #0x10
	b _02016AF0
	arm_func_end FUN_02016A98

	arm_func_start FUN_02016BB0
FUN_02016BB0: @ 0x02016BB0
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_02016BB0

	arm_func_start FUN_02016BBC
FUN_02016BBC: @ 0x02016BBC
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #4
	mov sb, r1
	ldr r6, [sb, #4]
	mov r8, r2
	mov sl, r0
	cmp r6, #0
	ldr r5, [r8, #4]
	beq _02016BE8
	cmp r5, #0
	bne _02016C04
_02016BE8:
	mov r0, sl
	mov r1, #0
	bl FUN_0201802C
	add sp, sp, #4
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
_02016C04:
	ldr r1, [sb, #0xc]
	ldr r0, [r8, #0xc]
	cmp sl, sb
	add r7, r6, r5
	eor fp, r1, r0
	beq _02016C24
	cmp sl, r8
	bne _02016C3C
_02016C24:
	ldr r0, [r3]
	add r2, r3, #4
	add r1, r0, #1
	mov r0, #0x14
	mla r4, r1, r0, r2
	b _02016C40
_02016C3C:
	mov r4, sl
_02016C40:
	ldr r0, [r4, #8]
	cmp r7, r0
	movle r0, r4
	ble _02016C5C
	mov r0, r4
	mov r1, r7
	bl FUN_0201816C
_02016C5C:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxeq lr
	str r7, [r4, #4]
	str r5, [sp]
	ldr r0, [r4]
	ldr r1, [sb]
	ldr r3, [r8]
	mov r2, r6
	bl FUN_02016A98
	mov r0, r4
	str fp, [sl, #0xc]
	bl FUN_020182F0
	cmp sl, r4
	beq _02016CAC
	mov r0, sl
	mov r1, r4
	bl FUN_020180D4
_02016CAC:
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_02016BBC

	arm_func_start FUN_02016CBC
FUN_02016CBC: @ 0x02016CBC
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	mov r6, r1
	ldr r1, [r6, #0xc]
	mov r3, #0
	mov r7, r0
	mov r5, r2
	mov r4, r3
	cmp r1, #0
	beq _02016D04
	ldr r0, [r5, #0xc]
	cmp r0, #0
	movne r0, r6
	moveq r3, #1
	movne r6, r5
	movne r5, r0
	moveq r4, r3
	b _02016D10
_02016D04:
	ldr r0, [r5, #0xc]
	cmp r0, #0
	movne r3, #1
_02016D10:
	cmp r3, #0
	beq _02016D44
	mov r0, r7
	mov r1, r6
	mov r2, r5
	bl FUN_02016F64
	cmp r0, #0
	moveq r0, #0
	add sp, sp, #4
	strne r4, [r7, #0xc]
	movne r0, #1
	pop {r4, r5, r6, r7, lr}
	bx lr
_02016D44:
	ldr r0, [r5, #4]
	ldr r1, [r6, #4]
	cmp r1, r0
	movle r1, r0
	ldr r0, [r7, #8]
	cmp r1, r0
	movle r0, r7
	ble _02016D6C
	mov r0, r7
	bl FUN_0201816C
_02016D6C:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, r6
	mov r1, r5
	bl FUN_02017E48
	cmp r0, #0
	bge _02016DC4
	mov r0, r7
	mov r1, r5
	mov r2, r6
	bl FUN_02016E00
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, #1
	str r0, [r7, #0xc]
	b _02016DF0
_02016DC4:
	mov r0, r7
	mov r1, r6
	mov r2, r5
	bl FUN_02016E00
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	mov r0, #0
	str r0, [r7, #0xc]
_02016DF0:
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02016CBC

	arm_func_start FUN_02016E00
FUN_02016E00: @ 0x02016E00
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov r8, r1
	mov r7, r2
	ldr r5, [r7, #4]
	ldr r6, [r8, #4]
	mov r4, r0
	cmp r6, r5
	movlt r0, #0
	poplt {r4, r5, r6, r7, r8, sb, sl, lr}
	bxlt lr
	ldr r1, [r4, #8]
	cmp r6, r1
	ble _02016E3C
	mov r1, r6
	bl FUN_0201816C
_02016E3C:
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, lr}
	bxeq lr
	mov r3, #0
	mov r0, r3
	cmp r5, #0
	ldr r2, [r8]
	ldr sb, [r7]
	ldr r1, [r4]
	ble _02016EBC
	mov ip, r3
	mov r7, r3
	mov lr, #1
_02016E74:
	cmp r3, #0
	ldr sl, [r2], #4
	ldr r8, [sb], #4
	beq _02016E9C
	cmp sl, r8
	movls r3, lr
	sub r8, sl, r8
	movhi r3, ip
	sub sl, r8, #1
	b _02016EAC
_02016E9C:
	cmp sl, r8
	movlo r3, lr
	movhs r3, r7
	sub sl, sl, r8
_02016EAC:
	add r0, r0, #1
	cmp r0, r5
	str sl, [r1], #4
	blt _02016E74
_02016EBC:
	cmp r3, #0
	beq _02016EEC
	cmp r0, r6
	bge _02016EEC
_02016ECC:
	ldr r5, [r2], #4
	add r0, r0, #1
	sub r3, r5, #1
	cmp r5, r3
	str r3, [r1], #4
	bhi _02016EEC
	cmp r0, r6
	blt _02016ECC
_02016EEC:
	cmp r1, r2
	beq _02016F4C
_02016EF4:
	cmp r0, r6
	bge _02016F4C
	ldr r5, [r2]
	add r3, r0, #1
	str r5, [r1]
	cmp r3, r6
	bge _02016F4C
	ldr r5, [r2, #4]
	add r3, r0, #2
	str r5, [r1, #4]
	cmp r3, r6
	bge _02016F4C
	ldr r5, [r2, #8]
	add r3, r0, #3
	str r5, [r1, #8]
	cmp r3, r6
	ldrlt r3, [r2, #0xc]
	add r0, r0, #4
	strlt r3, [r1, #0xc]
	addlt r2, r2, #0x10
	addlt r1, r1, #0x10
	blt _02016EF4
_02016F4C:
	mov r0, r4
	str r6, [r4, #4]
	bl FUN_020182F0
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	arm_func_end FUN_02016E00

	arm_func_start FUN_02016F64
FUN_02016F64: @ 0x02016F64
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	mov r4, r1
	mov r8, r2
	ldr r2, [r4, #4]
	ldr r1, [r8, #4]
	mov sb, r0
	cmp r2, r1
	movlt r0, r4
	movlt r4, r8
	movlt r8, r0
	ldr r6, [r4, #4]
	ldr r0, [sb, #8]
	add r1, r6, #1
	cmp r1, r0
	ldr r7, [r8, #4]
	movle r0, sb
	ble _02016FB4
	mov r0, sb
	bl FUN_0201816C
_02016FB4:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, lr}
	bxeq lr
	str r6, [sb, #4]
	ldr r5, [r4]
	ldr r4, [sb]
	ldr r2, [r8]
	mov r0, r4
	mov r1, r5
	mov r3, r7
	bl FUN_02017718
	cmp r0, #0
	add r4, r4, r7, lsl #2
	add r5, r5, r7, lsl #2
	beq _0201704C
	cmp r7, r6
	bge _0201702C
_02017000:
	ldr r2, [r5], #4
	mov r3, r4
	add r1, r2, #1
	str r1, [r4], #4
	ldr r1, [r3]
	add r7, r7, #1
	cmp r1, r2
	movhs r0, #0
	bhs _0201702C
	cmp r7, r6
	blt _02017000
_0201702C:
	cmp r7, r6
	blt _0201704C
	cmp r0, #0
	movne r0, #1
	strne r0, [r4], #4
	ldrne r0, [sb, #4]
	addne r0, r0, #1
	strne r0, [sb, #4]
_0201704C:
	cmp r4, r5
	beq _02017070
	cmp r7, r6
	bge _02017070
_0201705C:
	ldr r0, [r5], #4
	add r7, r7, #1
	cmp r7, r6
	str r0, [r4], #4
	blt _0201705C
_02017070:
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	arm_func_end FUN_02016F64

	arm_func_start FUN_02017080
FUN_02017080: @ 0x02017080
	push {r4, r5, r6, lr}
	mov r5, r1
	mov r4, r2
	ldr r2, [r5, #0xc]
	ldr r1, [r4, #0xc]
	mov r6, r0
	eors r0, r2, r1
	beq _02017124
	cmp r2, #0
	movne r0, r5
	movne r5, r4
	movne r4, r0
	mov r0, r5
	mov r1, r4
	bl FUN_02017E48
	cmp r0, #0
	bge _020170F0
	mov r0, r6
	mov r1, r4
	mov r2, r5
	bl FUN_02016E00
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	mov r0, #1
	str r0, [r6, #0xc]
	b _02017118
_020170F0:
	mov r0, r6
	mov r1, r5
	mov r2, r4
	bl FUN_02016E00
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	mov r0, #0
	str r0, [r6, #0xc]
_02017118:
	mov r0, #1
	pop {r4, r5, r6, lr}
	bx lr
_02017124:
	cmp r2, #0
	movne r0, #1
	strne r0, [r6, #0xc]
	moveq r0, #0
	streq r0, [r6, #0xc]
	mov r0, r6
	mov r1, r5
	mov r2, r4
	bl FUN_02016F64
	cmp r0, #0
	moveq r0, #0
	movne r0, #1
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_02017080

	arm_func_start FUN_0201715C
FUN_0201715C: @ 0x0201715C
	push {r4, r5, lr}
	sub sp, sp, #4
	movs r4, r1
	mov r5, r0
	addeq sp, sp, #4
	moveq r0, #1
	popeq {r4, r5, lr}
	bxeq lr
	ldr r2, [r5, #0xc]
	cmp r2, #0
	beq _020171A8
	mov r2, #0
	str r2, [r5, #0xc]
	bl FUN_020172BC
	mov r1, #1
	add sp, sp, #4
	str r1, [r5, #0xc]
	pop {r4, r5, lr}
	bx lr
_020171A8:
	ldr r1, [r5, #4]
	cmp r1, #1
	bgt _0201724C
	cmp r1, #0
	bne _02017204
	ldr r1, [r5, #8]
	cmp r1, #1
	bge _020171D0
	mov r1, #1
	bl FUN_0201816C
_020171D0:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r5]
	mov r0, #1
	str r4, [r1]
	str r0, [r5, #0xc]
	add sp, sp, #4
	str r0, [r5, #4]
	pop {r4, r5, lr}
	bx lr
_02017204:
	ldr r2, [r5]
	ldr r1, [r2]
	cmp r1, r4
	moveq r0, #0
	streq r0, [r5, #4]
	beq _0201723C
	cmp r1, r4
	subhi r0, r1, r4
	strhi r0, [r2]
	movls r0, #1
	strls r0, [r5, #0xc]
	ldrls r0, [r5]
	subls r1, r4, r1
	strls r1, [r0]
_0201723C:
	add sp, sp, #4
	mov r0, #1
	pop {r4, r5, lr}
	bx lr
_0201724C:
	mov r0, #0
	mov r1, #1
_02017254:
	ldr ip, [r5]
	lsl r3, r0, #2
	ldr r2, [ip, r0, lsl #2]
	cmp r2, r4
	ldrhs r1, [ip, r3]
	subhs r1, r1, r4
	strhs r1, [ip, r3]
	bhs _0201728C
	ldr r2, [ip, r3]
	add r0, r0, #1
	sub r2, r2, r4
	mov r4, r1
	str r2, [ip, r3]
	b _02017254
_0201728C:
	ldr r1, [r5]
	ldr r1, [r1, r3]
	cmp r1, #0
	bne _020172AC
	ldr r1, [r5, #4]
	sub r1, r1, #1
	cmp r0, r1
	streq r1, [r5, #4]
_020172AC:
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0201715C

	arm_func_start FUN_020172BC
FUN_020172BC: @ 0x020172BC
	push {r4, r5, lr}
	sub sp, sp, #4
	movs r4, r1
	mov r5, r0
	addeq sp, sp, #4
	moveq r0, #1
	popeq {r4, r5, lr}
	bxeq lr
	ldr r2, [r5, #0xc]
	cmp r2, #0
	beq _02017364
	ldr r2, [r5, #4]
	cmp r2, #1
	ble _02017314
	mov r2, #0
	str r2, [r5, #0xc]
	bl FUN_0201715C
	mov r1, #1
	add sp, sp, #4
	str r1, [r5, #0xc]
	pop {r4, r5, lr}
	bx lr
_02017314:
	ldr r2, [r5]
	ldr r1, [r2]
	cmp r1, r4
	subhi r0, r1, r4
	strhi r0, [r2]
	bhi _02017354
	cmp r1, r4
	movhs r0, #0
	strhs r0, [r5, #0xc]
	strhs r0, [r5, #4]
	bhs _02017354
	mov r0, #0
	str r0, [r5, #0xc]
	ldr r0, [r5]
	sub r1, r4, r1
	str r1, [r0]
_02017354:
	add sp, sp, #4
	mov r0, #1
	pop {r4, r5, lr}
	bx lr
_02017364:
	ldr r1, [r5, #4]
	ldr r2, [r5, #8]
	add r1, r1, #1
	cmp r1, r2
	ble _0201737C
	bl FUN_0201816C
_0201737C:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r5]
	ldr r0, [r5, #4]
	mov r3, #0
	str r3, [r1, r0, lsl #2]
	mov r0, #1
_020173A4:
	ldr r2, [r5]
	ldr r1, [r2, r3, lsl #2]
	add r1, r4, r1
	cmp r4, r1
	str r1, [r2, r3, lsl #2]
	movhi r4, r0
	addhi r3, r3, #1
	bhi _020173A4
	ldr r0, [r5, #4]
	cmp r3, r0
	addge r0, r0, #1
	strge r0, [r5, #4]
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_020172BC

	arm_func_start FUN_020173E4
FUN_020173E4: @ 0x020173E4
	push {r4, r5, r6, r7, r8, lr}
	mov r7, r1
	asr r1, r2, #4
	lsr r3, r2, #0x1f
	add r1, r2, r1, lsr #27
	rsb r2, r3, r2, lsl #27
	add r4, r3, r2, ror #27
	ldr r2, [r7, #4]
	asr r6, r1, #5
	mov r8, r0
	cmp r6, r2
	rsb r5, r4, #0x20
	ble _0201742C
	mov r1, #0
	bl FUN_0201802C
	mov r0, #1
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
_0201742C:
	cmp r8, r7
	beq _02017464
	sub r1, r2, r6
	ldr r2, [r8, #8]
	add r1, r1, #2
	cmp r1, r2
	ble _0201744C
	bl FUN_0201816C
_0201744C:
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr r0, [r7, #0xc]
	str r0, [r8, #0xc]
_02017464:
	ldr r0, [r7]
	ldr r1, [r7, #4]
	add r2, r0, r6, lsl #2
	ldr r0, [r8]
	sub r7, r1, r6
	mov r6, r2
	str r7, [r8, #4]
	cmp r4, #0
	bne _020174AC
	add r2, r7, #1
	cmp r2, #0
	ble _020174EC
_02017494:
	ldr r1, [r6], #4
	sub r2, r2, #1
	cmp r2, #0
	str r1, [r0], #4
	bgt _02017494
	b _020174EC
_020174AC:
	cmp r7, #1
	add r6, r2, #4
	ldr r3, [r2]
	mov r2, #1
	ble _020174DC
_020174C0:
	lsr r1, r3, r4
	ldr r3, [r6], #4
	add r2, r2, #1
	orr r1, r1, r3, lsl r5
	cmp r2, r7
	str r1, [r0], #4
	blt _020174C0
_020174DC:
	lsr r1, r3, r4
	str r1, [r0]
	mov r1, #0
	str r1, [r0, #4]
_020174EC:
	mov r0, r8
	bl FUN_020182F0
	mov r0, #1
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	arm_func_end FUN_020173E4

	arm_func_start FUN_02017500
FUN_02017500: @ 0x02017500
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	mov r4, r1
	mov r7, r2
	asr r1, r7, #4
	mov r5, r0
	add r2, r7, r1, lsr #27
	ldr r1, [r4, #4]
	ldr r3, [r5, #8]
	add r1, r1, r2, asr #5
	add r1, r1, #1
	cmp r1, r3
	asr r6, r2, #5
	ble _02017538
	bl FUN_0201816C
_02017538:
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, r7, r8, sb, sl, lr}
	bxeq lr
	ldr r0, [r4, #0xc]
	lsr r1, r7, #0x1f
	str r0, [r5, #0xc]
	ldr r3, [r4, #4]
	rsb r0, r1, r7, lsl #27
	adds ip, r1, r0, ror #27
	ldr r2, [r4]
	ldr r0, [r5]
	add r1, r3, r6
	mov r3, #0
	str r3, [r0, r1, lsl #2]
	rsb r3, ip, #0x20
	bne _020175A0
	ldr r1, [r4, #4]
	subs r7, r1, #1
	bmi _020175D4
_02017588:
	ldr r3, [r2, r7, lsl #2]
	add r1, r6, r7
	str r3, [r0, r1, lsl #2]
	subs r7, r7, #1
	bpl _02017588
	b _020175D4
_020175A0:
	ldr r1, [r4, #4]
	subs r1, r1, #1
	bmi _020175D4
_020175AC:
	add sb, r6, r1
	add r8, sb, #1
	ldr sl, [r2, r1, lsl #2]
	ldr lr, [r0, r8, lsl #2]
	lsl r7, sl, ip
	orr lr, lr, sl, lsr r3
	str lr, [r0, r8, lsl #2]
	str r7, [r0, sb, lsl #2]
	subs r1, r1, #1
	bpl _020175AC
_020175D4:
	lsl r2, r6, #2
	mov r1, #0
	bl FUN_0200A144
	ldr r1, [r4, #4]
	mov r0, r5
	add r1, r1, r6
	add r1, r1, #1
	str r1, [r5, #4]
	bl FUN_020182F0
	mov r0, #1
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	arm_func_end FUN_02017500

	arm_func_start FUN_02017604
FUN_02017604: @ 0x02017604
	push {r4, r5, r6, r7, r8, sb, sl, lr}
	cmp r3, #0
	movle r0, #0
	pople {r4, r5, r6, r7, r8, sb, sl, lr}
	bxle lr
	mov r6, #0
	mov r4, r6
	mov lr, r6
	mov ip, r6
	mov r7, r6
	mov r5, #1
_02017630:
	ldr sl, [r1]
	ldr sb, [r2]
	sub r8, sl, sb
	sub r8, r8, r6
	str r8, [r0]
	cmp sl, sb
	beq _02017658
	cmp sl, sb
	movlo r6, r5
	movhs r6, r4
_02017658:
	sub r8, r3, #1
	cmp r8, #0
	ble _0201770C
	ldr sl, [r1, #4]
	ldr sb, [r2, #4]
	sub r8, sl, sb
	sub r8, r8, r6
	str r8, [r0, #4]
	cmp sl, sb
	beq _0201768C
	cmp sl, sb
	movlo r6, r5
	movhs r6, lr
_0201768C:
	sub r8, r3, #2
	cmp r8, #0
	ble _0201770C
	ldr sl, [r1, #8]
	ldr sb, [r2, #8]
	sub r8, sl, sb
	sub r8, r8, r6
	str r8, [r0, #8]
	cmp sl, sb
	beq _020176C0
	cmp sl, sb
	movlo r6, r5
	movhs r6, ip
_020176C0:
	sub r8, r3, #3
	cmp r8, #0
	ble _0201770C
	ldr sl, [r1, #0xc]
	ldr sb, [r2, #0xc]
	sub r8, sl, sb
	sub r8, r8, r6
	str r8, [r0, #0xc]
	cmp sl, sb
	beq _020176F4
	cmp sl, sb
	movlo r6, r5
	movhs r6, r7
_020176F4:
	sub r3, r3, #4
	cmp r3, #0
	addgt r1, r1, #0x10
	addgt r2, r2, #0x10
	addgt r0, r0, #0x10
	bgt _02017630
_0201770C:
	mov r0, r6
	pop {r4, r5, r6, r7, r8, sb, sl, lr}
	bx lr
	arm_func_end FUN_02017604

	arm_func_start FUN_02017718
FUN_02017718: @ 0x02017718
	push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	sub sp, sp, #0xc
	cmp r3, #0
	addle sp, sp, #0xc
	movle r0, #0
	pople {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bxle lr
	mov ip, #0
	mov r7, ip
	mov r6, ip
	mov r5, ip
	mov r4, ip
	mov lr, ip
	mov fp, ip
	str ip, [sp]
	str ip, [sp, #4]
	mov r8, #1
_0201775C:
	ldr sb, [r1]
	add sl, sb, ip
	ldr sb, [r2]
	cmp sl, ip
	movlo ip, r8
	add sb, sl, sb
	movhs ip, r7
	cmp sb, sl
	movlo sl, r8
	movhs sl, r6
	str sb, [r0]
	sub sb, r3, #1
	add ip, ip, sl
	cmp sb, #0
	ble _02017858
	ldr sb, [r1, #4]
	ldr sl, [r2, #4]
	add sb, sb, ip
	cmp sb, ip
	movlo ip, r8
	add sl, sb, sl
	movhs ip, r5
	cmp sl, sb
	movlo sb, r8
	movhs sb, r4
	add ip, ip, sb
	sub sb, r3, #2
	str sl, [r0, #4]
	cmp sb, #0
	ble _02017858
	ldr sb, [r1, #8]
	ldr sl, [r2, #8]
	add sb, sb, ip
	cmp sb, ip
	movlo ip, r8
	add sl, sb, sl
	movhs ip, lr
	cmp sl, sb
	movlo sb, r8
	movhs sb, fp
	add ip, ip, sb
	sub sb, r3, #3
	str sl, [r0, #8]
	cmp sb, #0
	ble _02017858
	ldr sb, [r1, #0xc]
	ldr sl, [r2, #0xc]
	add sb, sb, ip
	cmp sb, ip
	movlo ip, r8
	add sl, sb, sl
	ldrhs ip, [sp]
	cmp sl, sb
	movlo sb, r8
	ldrhs sb, [sp, #4]
	sub r3, r3, #4
	cmp r3, #0
	str sl, [r0, #0xc]
	add ip, ip, sb
	addgt r1, r1, #0x10
	addgt r2, r2, #0x10
	addgt r0, r0, #0x10
	bgt _0201775C
_02017858:
	mov r0, ip
	add sp, sp, #0xc
	pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
	bx lr
	arm_func_end FUN_02017718

	arm_func_start FUN_02017868
FUN_02017868: @ 0x02017868
	push {r4, r5, r6, r7, r8, lr}
	cmp r2, #0
	pople {r4, r5, r6, r7, r8, lr}
	bxle lr
	mov r3, #0x8000
	ldr lr, _020179B8 @ =0x0000FFFF
	rsb ip, r3, #0
_02017884:
	ldr r5, [r1]
	mov r3, #0x8000
	and r4, r5, lr
	and r7, lr, r5, lsr #16
	mul r6, r4, r7
	mul r5, r4, r4
	and r4, r6, lr
	add r8, r5, r4, lsl #17
	rsb r3, r3, #0
	mul r5, r7, r7
	and r3, r6, r3
	add r3, r5, r3, lsr #15
	cmp r8, r4, lsl #17
	addlo r3, r3, #1
	str r8, [r0]
	str r3, [r0, #4]
	subs r3, r2, #1
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr r4, [r1, #4]
	and r7, lr, r4, lsr #16
	and r3, r4, lr
	mul r6, r3, r7
	mul r4, r3, r3
	and r3, r6, lr
	add r8, r4, r3, lsl #17
	mul r5, r7, r7
	and r4, r6, ip
	cmp r8, r3, lsl #17
	add r3, r5, r4, lsr #15
	addlo r3, r3, #1
	str r8, [r0, #8]
	str r3, [r0, #0xc]
	subs r3, r2, #2
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr r5, [r1, #8]
	mov r3, #0x8000
	and r4, r5, lr
	and r7, lr, r5, lsr #16
	mul r6, r4, r7
	mul r5, r4, r4
	and r4, r6, lr
	add r8, r5, r4, lsl #17
	rsb r3, r3, #0
	mul r5, r7, r7
	and r3, r6, r3
	add r3, r5, r3, lsr #15
	cmp r8, r4, lsl #17
	addlo r3, r3, #1
	str r8, [r0, #0x10]
	str r3, [r0, #0x14]
	subs r3, r2, #3
	popeq {r4, r5, r6, r7, r8, lr}
	bxeq lr
	ldr r5, [r1, #0xc]
	mov r3, #0x8000
	and r4, r5, lr
	and r7, lr, r5, lsr #16
	mul r6, r4, r7
	mul r5, r4, r4
	and r4, r6, lr
	add r8, r5, r4, lsl #17
	rsb r3, r3, #0
	mul r5, r7, r7
	and r3, r6, r3
	add r3, r5, r3, lsr #15
	cmp r8, r4, lsl #17
	addlo r3, r3, #1
	str r8, [r0, #0x18]
	subs r2, r2, #4
	str r3, [r0, #0x1c]
	addne r1, r1, #0x10
	addne r0, r0, #0x20
	bne _02017884
	pop {r4, r5, r6, r7, r8, lr}
	bx lr
	.align 2, 0
_020179B8: .4byte 0x0000FFFF
	arm_func_end FUN_02017868

	arm_func_start FUN_020179BC
FUN_020179BC: @ 0x020179BC
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	cmp r2, #0
	mov r4, #0
	addle sp, sp, #4
	movle r0, r4
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r5, _02017B58 @ =0x0000FFFF
	and lr, r3, r5
	and ip, r5, r3, lsr #16
_020179E8:
	ldr r3, [r1]
	and r7, r5, r3, lsr #16
	mul r6, lr, r7
	and r3, r3, r5
	mla sb, ip, r3, r6
	mul r8, r3, lr
	mul r3, r7, ip
	cmp sb, r6
	and r6, sb, r5
	addlo r3, r3, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r3, r3, r7
	add r6, r8, r4
	addlo r3, r3, #1
	cmp r6, r4
	addlo r3, r3, #1
	str r6, [r0]
	mov r4, r3
	subs r6, r2, #1
	beq _02017B48
	ldr r4, [r1, #4]
	and r7, r5, r4, lsr #16
	mul r6, lr, r7
	and r4, r4, r5
	mla sb, ip, r4, r6
	mul r8, r4, lr
	mul r4, r7, ip
	cmp sb, r6
	and r6, sb, r5
	addlo r4, r4, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r4, r4, r7
	add r6, r8, r3
	addlo r4, r4, #1
	cmp r6, r3
	addlo r4, r4, #1
	str r6, [r0, #4]
	subs r3, r2, #2
	beq _02017B48
	ldr r3, [r1, #8]
	and r7, r5, r3, lsr #16
	mul r6, lr, r7
	and r3, r3, r5
	mla sb, ip, r3, r6
	mul r8, r3, lr
	mul r3, r7, ip
	cmp sb, r6
	and r6, sb, r5
	addlo r3, r3, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r3, r3, r7
	add r6, r8, r4
	addlo r3, r3, #1
	cmp r6, r4
	addlo r3, r3, #1
	str r6, [r0, #8]
	mov r4, r3
	subs r6, r2, #3
	beq _02017B48
	ldr r4, [r1, #0xc]
	and r7, r5, r4, lsr #16
	mul r6, lr, r7
	and r4, r4, r5
	mla sb, ip, r4, r6
	mul r8, r4, lr
	mul r4, r7, ip
	cmp sb, r6
	and r6, sb, r5
	addlo r4, r4, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r4, r4, r7
	add r6, r8, r3
	addlo r4, r4, #1
	cmp r6, r3
	addlo r4, r4, #1
	subs r2, r2, #4
	str r6, [r0, #0xc]
	addne r1, r1, #0x10
	addne r0, r0, #0x10
	bne _020179E8
_02017B48:
	mov r0, r4
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	.align 2, 0
_02017B58: .4byte 0x0000FFFF
	arm_func_end FUN_020179BC

	arm_func_start FUN_02017B5C
FUN_02017B5C: @ 0x02017B5C
	push {r4, r5, r6, r7, r8, sb, lr}
	sub sp, sp, #4
	cmp r2, #0
	mov ip, #0
	addle sp, sp, #4
	movle r0, ip
	pople {r4, r5, r6, r7, r8, sb, lr}
	bxle lr
	ldr r5, _02017D38 @ =0x0000FFFF
	and r4, r3, r5
	and lr, r5, r3, lsr #16
_02017B88:
	ldr r3, [r1]
	and r7, r5, r3, lsr #16
	mul r6, r4, r7
	and r3, r3, r5
	mla sb, lr, r3, r6
	mul r8, r3, r4
	mul r3, r7, lr
	cmp sb, r6
	and r6, sb, r5
	addlo r3, r3, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r3, r3, r7
	ldr r6, [r0]
	addlo r3, r3, #1
	add r7, r8, ip
	cmp r7, ip
	add r7, r7, r6
	addlo r3, r3, #1
	cmp r7, r6
	addlo r3, r3, #1
	mov ip, r3
	str r7, [r0]
	subs r6, r2, #1
	beq _02017D28
	ldr ip, [r1, #4]
	and r7, r5, ip, lsr #16
	mul r6, r4, r7
	and ip, ip, r5
	mla sb, lr, ip, r6
	mul r8, ip, r4
	mul ip, r7, lr
	cmp sb, r6
	and r6, sb, r5
	addlo ip, ip, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add ip, ip, r7
	add r6, r8, r3
	addlo ip, ip, #1
	cmp r6, r3
	ldr r3, [r0, #4]
	addlo ip, ip, #1
	add r6, r6, r3
	cmp r6, r3
	addlo ip, ip, #1
	str r6, [r0, #4]
	subs r3, r2, #2
	beq _02017D28
	ldr r3, [r1, #8]
	and r7, r5, r3, lsr #16
	mul r6, r4, r7
	and r3, r3, r5
	mla sb, lr, r3, r6
	mul r8, r3, r4
	mul r3, r7, lr
	cmp sb, r6
	and r6, sb, r5
	addlo r3, r3, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add r3, r3, r7
	ldr r6, [r0, #8]
	addlo r3, r3, #1
	add r7, r8, ip
	cmp r7, ip
	add r7, r7, r6
	addlo r3, r3, #1
	cmp r7, r6
	addlo r3, r3, #1
	mov ip, r3
	str r7, [r0, #8]
	subs r6, r2, #3
	beq _02017D28
	ldr ip, [r1, #0xc]
	and r7, r5, ip, lsr #16
	mul r6, r4, r7
	and ip, ip, r5
	mla sb, lr, ip, r6
	mul r8, ip, r4
	mul ip, r7, lr
	cmp sb, r6
	and r6, sb, r5
	addlo ip, ip, #0x10000
	and r7, r5, sb, lsr #16
	add r8, r8, r6, lsl #16
	cmp r8, r6, lsl #16
	add ip, ip, r7
	add r6, r8, r3
	addlo ip, ip, #1
	cmp r6, r3
	ldr r3, [r0, #0xc]
	addlo ip, ip, #1
	add r6, r6, r3
	cmp r6, r3
	addlo ip, ip, #1
	subs r2, r2, #4
	str r6, [r0, #0xc]
	addne r1, r1, #0x10
	addne r0, r0, #0x10
	bne _02017B88
_02017D28:
	mov r0, ip
	add sp, sp, #4
	pop {r4, r5, r6, r7, r8, sb, lr}
	bx lr
	.align 2, 0
_02017D38: .4byte 0x0000FFFF
	arm_func_end FUN_02017B5C

	arm_func_start FUN_02017D3C
FUN_02017D3C: @ 0x02017D3C
	stmdb sp!, {lr}
	sub sp, sp, #4
	cmp r1, #0
	addlt sp, sp, #4
	movlt r0, #0
	ldmlt sp!, {lr}
	bxlt lr
	asr r2, r1, #4
	add r2, r1, r2, lsr #27
	lsr r3, r1, #0x1f
	ldr ip, [r0, #4]
	asr lr, r2, #5
	cmp ip, lr
	rsb r1, r3, r1, lsl #27
	addle sp, sp, #4
	add r2, r3, r1, ror #27
	movle r0, #0
	ldmle sp!, {lr}
	bxle lr
	ldr r1, [r0]
	mov r0, #1
	lsl r2, r0, r2
	ldr r1, [r1, lr, lsl #2]
	ands r1, r2, r1
	moveq r0, #0
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02017D3C

	arm_func_start FUN_02017DAC
FUN_02017DAC: @ 0x02017DAC
	push {r4, r5, r6, lr}
	mov r6, r0
	asr r2, r1, #4
	add r2, r1, r2, lsr #27
	lsr r3, r1, #0x1f
	rsb r1, r3, r1, lsl #27
	ldr r4, [r6, #4]
	asr r5, r2, #5
	cmp r4, r5
	add r4, r3, r1, ror #27
	bgt _02017E2C
	ldr r2, [r6, #8]
	add r1, r5, #1
	cmp r1, r2
	ble _02017DEC
	bl FUN_0201816C
_02017DEC:
	cmp r0, #0
	moveq r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	ldr r3, [r6, #4]
	add r2, r5, #1
	cmp r3, r2
	bge _02017E24
	mov r1, #0
_02017E10:
	ldr r0, [r6]
	str r1, [r0, r3, lsl #2]
	add r3, r3, #1
	cmp r3, r2
	blt _02017E10
_02017E24:
	add r0, r5, #1
	str r0, [r6, #4]
_02017E2C:
	ldr r2, [r6]
	mov r0, #1
	ldr r1, [r2, r5, lsl #2]
	orr r1, r1, r0, lsl r4
	str r1, [r2, r5, lsl #2]
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_02017DAC

	arm_func_start FUN_02017E48
FUN_02017E48: @ 0x02017E48
	ldr r3, [r0, #4]
	ldr r2, [r1, #4]
	subs r2, r3, r2
	movne r0, r2
	bxne lr
	subs r2, r3, #1
	ldr ip, [r0]
	ldr r3, [r1]
	bmi _02017E94
_02017E6C:
	ldr r1, [ip, r2, lsl #2]
	ldr r0, [r3, r2, lsl #2]
	cmp r1, r0
	beq _02017E8C
	cmp r1, r0
	movhi r0, #1
	mvnls r0, #0
	bx lr
_02017E8C:
	subs r2, r2, #1
	bpl _02017E6C
_02017E94:
	mov r0, #0
	bx lr
	arm_func_end FUN_02017E48

	arm_func_start FUN_02017E9C
FUN_02017E9C: @ 0x02017E9C
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	bl FUN_02018438
	add r1, r0, #7
	asr r0, r1, #2
	add r0, r1, r0, lsr #29
	asr r0, r0, #3
	cmp r0, #0
	addle sp, sp, #4
	sub ip, r0, #1
	pople {r4, r5, lr}
	bxle lr
_02017ED4:
	lsr r3, ip, #0x1f
	asr r1, ip, #1
	rsb r2, r3, ip, lsl #30
	add r1, ip, r1, lsr #30
	add r2, r3, r2, ror #30
	ldr r3, [r5]
	asr r1, r1, #2
	ldr r3, [r3, r1, lsl #2]
	lsl r1, r2, #3
	lsr r1, r3, r1
	cmp ip, #0
	strb r1, [r4], #1
	sub ip, ip, #1
	bgt _02017ED4
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_02017E9C

	arm_func_start FUN_02017F18
FUN_02017F18: @ 0x02017F18
	push {r4, r5, r6, r7, lr}
	sub sp, sp, #4
	movs r5, r2
	mov r7, r0
	mov r6, r1
	bne _02017F38
	bl FUN_02018290
	mov r5, r0
_02017F38:
	cmp r5, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	cmp r6, #0
	mov r4, #0
	addeq sp, sp, #4
	moveq r0, r5
	streq r4, [r5, #4]
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	add r0, r6, #2
	lsl r2, r0, #3
	add r1, r2, #0x1f
	asr r0, r1, #4
	add r0, r1, r0, lsr #27
	ldr r1, [r5, #8]
	asr r0, r0, #5
	cmp r0, r1
	movle r0, r5
	ble _02017FA8
	asr r0, r2, #4
	add r0, r2, r0, lsr #27
	asr r1, r0, #5
	mov r0, r5
	add r1, r1, #1
	bl FUN_0201816C
_02017FA8:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, r6, r7, lr}
	bxeq lr
	sub r0, r6, #1
	lsr r1, r0, #2
	add ip, r1, #1
	cmp r6, #0
	str ip, [r5, #4]
	and r3, r0, #3
	sub r6, r6, #1
	beq _02018014
	mov r1, #0
	mov r0, #3
_02017FE4:
	ldrb r2, [r7], #1
	cmp r3, #0
	sub r3, r3, #1
	orr r4, r2, r4, lsl #8
	ldreq r2, [r5]
	subeq ip, ip, #1
	streq r4, [r2, ip, lsl #2]
	moveq r4, r1
	moveq r3, r0
	cmp r6, #0
	sub r6, r6, #1
	bne _02017FE4
_02018014:
	mov r0, r5
	bl FUN_020182F0
	mov r0, r5
	add sp, sp, #4
	pop {r4, r5, r6, r7, lr}
	bx lr
	arm_func_end FUN_02017F18

	arm_func_start FUN_0201802C
FUN_0201802C: @ 0x0201802C
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r4, r0
	ldr r2, [r4, #8]
	mov r5, r1
	cmp r2, #1
	bge _02018050
	mov r1, #2
	bl FUN_0201816C
_02018050:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	bxeq lr
	mov r0, #0
	str r0, [r4, #0xc]
	str r0, [r4, #4]
	ldr r0, [r4]
	str r5, [r0]
	ldr r0, [r4]
	ldr r0, [r0]
	cmp r0, #0
	movne r0, #1
	strne r0, [r4, #4]
	mov r0, #1
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0201802C

	arm_func_start FUN_0201809C
FUN_0201809C: @ 0x0201809C
	push {r4, lr}
	mov r4, r0
	ldr r0, [r4]
	cmp r0, #0
	beq _020180C0
	ldr r2, [r4, #8]
	mov r1, #0
	lsl r2, r2, #2
	bl FUN_0200A144
_020180C0:
	mov r0, #0
	str r0, [r4, #4]
	str r0, [r4, #0xc]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0201809C

	arm_func_start FUN_020180D4
FUN_020180D4: @ 0x020180D4
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	mov r4, r1
	cmp r5, r4
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	ldr r1, [r4, #4]
	ldr r2, [r5, #8]
	cmp r1, r2
	ble _02018108
	bl FUN_0201816C
_02018108:
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	popeq {r4, r5, lr}
	bxeq lr
	ldr r2, [r4, #4]
	ldr r0, [r4]
	ldr r1, [r5]
	lsl r2, r2, #2
	bl FUN_0200A1D8
	ldr r0, [r4, #4]
	str r0, [r5, #4]
	ldr r0, [r5, #4]
	cmp r0, #0
	bne _02018154
	ldr r1, [r5]
	cmp r1, #0
	movne r0, #0
	strne r0, [r1]
_02018154:
	ldr r1, [r4, #0xc]
	mov r0, r5
	str r1, [r5, #0xc]
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_020180D4

	arm_func_start FUN_0201816C
FUN_0201816C: @ 0x0201816C
	push {r4, r5, r6, lr}
	mov r5, r0
	ldr r0, [r5, #8]
	mov r4, r1
	cmp r4, r0
	ble _020181E0
	ldr r0, [r5, #0x10]
	ands r0, r0, #2
	movne r0, #0
	popne {r4, r5, r6, lr}
	bxne lr
	add r0, r4, #1
	lsl r0, r0, #2
	bl FUN_02014398
	movs r6, r0
	moveq r0, #0
	popeq {r4, r5, r6, lr}
	bxeq lr
	ldr r0, [r5]
	cmp r0, #0
	beq _020181D8
	ldr r2, [r5, #4]
	mov r1, r6
	lsl r2, r2, #2
	bl FUN_0200A1D8
	ldr r0, [r5]
	bl FUN_02014350
_020181D8:
	str r6, [r5]
	str r4, [r5, #8]
_020181E0:
	mov r0, r5
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_0201816C

	arm_func_start FUN_020181EC
FUN_020181EC: @ 0x020181EC
	push {r4, r5, r6, lr}
	mov r6, r0
	add r4, r6, #4
	mov r5, #0
_020181FC:
	mov r0, r4
	bl FUN_02018414
	add r5, r5, #1
	cmp r5, #0xc
	add r4, r4, #0x14
	blt _020181FC
	ldr r0, [r6, #0x108]
	ands r0, r0, #1
	popeq {r4, r5, r6, lr}
	bxeq lr
	mov r0, r6
	bl FUN_02014350
	pop {r4, r5, r6, lr}
	bx lr
	arm_func_end FUN_020181EC

	arm_func_start FUN_02018234
FUN_02018234: @ 0x02018234
	push {r4, lr}
	mov r1, #0
	mov r2, #0x110
	mov r4, r0
	bl FUN_0200A144
	mov r0, #0
	str r0, [r4]
	str r0, [r4, #0x108]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02018234

	arm_func_start FUN_0201825C
FUN_0201825C: @ 0x0201825C
	push {r4, lr}
	mov r0, #0x110
	bl FUN_02014398
	movs r4, r0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	bl FUN_02018234
	mov r1, #1
	mov r0, r4
	str r1, [r4, #0x108]
	pop {r4, lr}
	bx lr
	arm_func_end FUN_0201825C

	arm_func_start FUN_02018290
FUN_02018290: @ 0x02018290
	stmdb sp!, {lr}
	sub sp, sp, #4
	mov r0, #0x14
	bl FUN_02014398
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	ldmeq sp!, {lr}
	bxeq lr
	mov r1, #1
	str r1, [r0, #0x10]
	mov r1, #0
	str r1, [r0, #4]
	str r1, [r0, #0xc]
	str r1, [r0, #8]
	str r1, [r0]
	add sp, sp, #4
	ldm sp!, {lr}
	bx lr
	arm_func_end FUN_02018290

	arm_func_start FUN_020182DC
FUN_020182DC: @ 0x020182DC
	ldr ip, _020182EC @ =0x02305584
	mov r1, #0
	mov r2, #0x14
	bx ip
	.align 2, 0
_020182EC: .4byte 0x02305584
	arm_func_end FUN_020182DC

	arm_func_start FUN_020182F0
FUN_020182F0: @ 0x020182F0
	ldr r3, [r0, #4]
	cmp r3, #0
	bxle lr
	ldr r2, [r0]
	sub r1, r3, #1
	cmp r3, #0
	add r3, r2, r1, lsl #2
	bxle lr
	add r2, r0, #4
_02018314:
	ldr r1, [r3], #-4
	cmp r1, #0
	bxne lr
	ldr r1, [r2]
	sub r1, r1, #1
	str r1, [r2]
	ldr r1, [r0, #4]
	cmp r1, #0
	bgt _02018314
	bx lr
	arm_func_end FUN_020182F0

	arm_func_start FUN_0201833C
FUN_0201833C: @ 0x0201833C
	push {r4, r5, lr}
	sub sp, sp, #4
	mov r5, r0
	ldr r2, [r5, #4]
	mov r4, r1
	cmp r2, r4
	addge sp, sp, #4
	popge {r4, r5, lr}
	bxge lr
	ldr r2, [r5, #8]
	cmp r4, r2
	ble _02018370
	bl FUN_0201816C
_02018370:
	ldr r0, [r5]
	cmp r0, #0
	addeq sp, sp, #4
	popeq {r4, r5, lr}
	bxeq lr
	ldr r2, [r5, #4]
	cmp r2, r4
	addge sp, sp, #4
	popge {r4, r5, lr}
	bxge lr
	mov r1, #0
_0201839C:
	ldr r0, [r5]
	str r1, [r0, r2, lsl #2]
	add r2, r2, #1
	cmp r2, r4
	blt _0201839C
	add sp, sp, #4
	pop {r4, r5, lr}
	bx lr
	arm_func_end FUN_0201833C

	arm_func_start FUN_020183BC
FUN_020183BC: @ 0x020183BC
	push {r4, lr}
	movs r4, r0
	popeq {r4, lr}
	bxeq lr
	ldr r0, [r4]
	cmp r0, #0
	beq _020183E8
	ldr r1, [r4, #0x10]
	ands r1, r1, #2
	bne _020183E8
	bl FUN_02014350
_020183E8:
	ldr r0, [r4, #0x10]
	orr r0, r0, #0x8000
	str r0, [r4, #0x10]
	ldr r0, [r4, #0x10]
	ands r0, r0, #1
	popeq {r4, lr}
	bxeq lr
	mov r0, r4
	bl FUN_02014350
	pop {r4, lr}
	bx lr
	arm_func_end FUN_020183BC

	arm_func_start FUN_02018414
FUN_02018414: @ 0x02018414
	push {r4, lr}
	movs r4, r0
	popeq {r4, lr}
	bxeq lr
	bl FUN_0201809C
	mov r0, r4
	bl FUN_020183BC
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02018414

	arm_func_start FUN_02018438
FUN_02018438: @ 0x02018438
	push {r4, lr}
	ldr r1, [r0, #4]
	cmp r1, #0
	moveq r0, #0
	popeq {r4, lr}
	bxeq lr
	ldr r0, [r0]
	sub r4, r1, #1
	ldr r0, [r0, r4, lsl #2]
	bl FUN_0201846C
	add r0, r0, r4, lsl #5
	pop {r4, lr}
	bx lr
	arm_func_end FUN_02018438

	arm_func_start FUN_0201846C
FUN_0201846C: @ 0x0201846C
	mov r1, #0x10000
	rsb r1, r1, #0
	ands r1, r0, r1
	beq _0201848C
	ands r1, r0, #0xff000000
	movne r2, #0x18
	moveq r2, #0x10
	b _02018498
_0201848C:
	ands r1, r0, #0xff00
	movne r2, #8
	moveq r2, #0
_02018498:
	lsr r1, r0, r2
	ands r0, r1, #0xf0
	ldreq r0, _020184C8 @ =0x02314278
	ldrsbeq r0, [r0, r1]
	addeq r0, r0, r2
	bxeq lr
	ldr r0, _020184C8 @ =0x02314278
	lsr r1, r1, #4
	ldrsb r0, [r0, r1]
	add r0, r0, r2
	add r0, r0, #4
	bx lr
	.align 2, 0
_020184C8: .4byte 0x02314278
	arm_func_end FUN_0201846C

	arm_func_start FUN_020184CC
FUN_020184CC: @ 0x020184CC
	eor ip, r0, r1
	and ip, ip, #0x80000000
	cmp r0, #0
	rsblt r0, r0, #0
	addlt ip, ip, #1
	cmp r1, #0
	rsblt r1, r1, #0
	beq _020186C4
	cmp r0, r1
	movlo r1, r0
	movlo r0, #0
	blo _020186C4
	mov r2, #0x1c
	lsr r3, r0, #4
	cmp r1, r3, lsr #12
	suble r2, r2, #0x10
	lsrle r3, r3, #0x10
	cmp r1, r3, lsr #4
	suble r2, r2, #8
	lsrle r3, r3, #8
	cmp r1, r3
	suble r2, r2, #4
	lsrle r3, r3, #4
	lsl r0, r0, r2
	rsb r1, r1, #0
	adds r0, r0, r0
	add r2, r2, r2, lsl #1
	add pc, pc, r2, lsl #2
	mov r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	mov r1, r3
_020186C4:
	ands r3, ip, #0x80000000
	rsbne r0, r0, #0
	ands r3, ip, #1
	rsbne r1, r1, #0
	bx lr
	arm_func_end FUN_020184CC

	arm_func_start FUN_020186D8
FUN_020186D8: @ 0x020186D8
	cmp r1, #0
	bxeq lr
	cmp r0, r1
	movlo r1, r0
	movlo r0, #0
	bxlo lr
	mov r2, #0x1c
	lsr r3, r0, #4
	cmp r1, r3, lsr #12
	suble r2, r2, #0x10
	lsrle r3, r3, #0x10
	cmp r1, r3, lsr #4
	suble r2, r2, #8
	lsrle r3, r3, #8
	cmp r1, r3
	suble r2, r2, #4
	lsrle r3, r3, #4
	lsl r0, r0, r2
	rsb r1, r1, #0
	adds r0, r0, r0
	add r2, r2, r2, lsl #1
	add pc, pc, r2, lsl #2
	mov r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	adcs r3, r1, r3, lsl #1
	sublo r3, r3, r1
	adcs r0, r0, r0
	mov r1, r3
	bx lr
	arm_func_end FUN_020186D8

	arm_func_start FUN_020188BC
FUN_020188BC: @ 0x020188BC
	bx lr
	arm_func_end FUN_020188BC

	arm_func_start FUN_020188C0
FUN_020188C0: @ 0x020188C0
	push {r4, lr}
	ldr r4, _020188E8 @ =0x02004B98
	b _020188D4
_020188CC:
	blx r0
	add r4, r4, #4
_020188D4:
	cmp r4, #0
	ldrne r0, [r4]
	cmpne r0, #0
	bne _020188CC
	pop {r4, pc}
	.align 2, 0
	; 0x020188E8
	.word 0x02004B98
	.word 0x027FFA80
	.word 0x027FFE00
	.word 0x00000003
	.word 0x027FF000
	.word 0x00000000
