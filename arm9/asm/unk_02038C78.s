	.include "asm/macros.inc"
	.include "global.inc"

	.extern sNumScriptCmds

	.section .rodata

	.global UNK_020F2DB4
UNK_020F2DB4: ; 0x020F2DB4
	.short 0x006F
	.byte 0x01, 0x00
	.short 0x0000, 0x00C9
	.short 0x0011
	.byte 0x01, 0x01
	.short 0x0000, 0x00A0
	.short 0x0016
	.byte 0x01, 0x01
	.short 0x0000, 0x00A1
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x0057
	.short 0x0029
	.byte 0x01, 0x01
	.short 0x0000, 0x0000
	.short 0x0012
	.byte 0x01, 0x01
	.short 0x0000, 0x00D9
	.short 0x0134
	.byte 0x01, 0x01
	.short 0x0000, 0x0001
	.short 0x0012
	.byte 0x01, 0x01
	.short 0x0000, 0x00A7
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x0096
	.short 0x0137
	.byte 0x01, 0x01
	.short 0x0000, 0x0002
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x00E4
	.short 0x0004
	.byte 0x01, 0x01
	.short 0x0000, 0x0003
	.short 0x0028
	.byte 0x01, 0x02
	.short 0x0000, 0x0004
	.short 0x0011
	.byte 0x01, 0x02
	.short 0x0000, 0x0005
	.short 0x001A
	.byte 0x01, 0x02
	.short 0x0000, 0x0008
	.short 0x005C
	.byte 0x01, 0x02
	.short 0x0000, 0x0006
	.short 0x0013
	.byte 0x01, 0x02
	.short 0x0000, 0x0009
	.short 0x0011
	.byte 0x01, 0x02
	.short 0x0000, 0x00A2
	.short 0x0011
	.byte 0x01, 0x02
	.short 0x0000, 0x00D0
	.short 0x0056
	.byte 0x01, 0x02
	.short 0x0000, 0x00D1
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x000A
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x000B
	.short 0x0004
	.byte 0x01, 0x02
	.short 0x0000, 0x005B
	.short 0x0032
	.byte 0x01, 0x02
	.short 0x0000, 0x000C
	.short 0x001C
	.byte 0x01, 0x02
	.short 0x0000, 0x0097
	.short 0x0026
	.byte 0x01, 0x01
	.short 0x0000, 0x000D
	.short 0x002F
	.byte 0x01, 0x01
	.short 0x0000, 0x000E
	.short 0x005E
	.byte 0x01, 0x02
	.short 0x0000, 0x000F
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0010
	.short 0x001A
	.byte 0x01, 0x01
	.short 0x0000, 0x0011
	.short 0x0003
	.byte 0x01, 0x01
	.short 0x0000, 0x0012
	.short 0x0013
	.byte 0x01, 0x01
	.short 0x0000, 0x00A3
	.short 0x002E
	.byte 0x01, 0x01
	.short 0x0000, 0x0013
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0014
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x0015
	.short 0x0026
	.byte 0x01, 0x01
	.short 0x0000, 0x0016
	.short 0x005D
	.byte 0x01, 0x01
	.short 0x0000, 0x0017
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x0018
	.short 0x0003
	.byte 0x01, 0x01
	.short 0x0000, 0x0019
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x001A
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x001B
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x00D2
	.short 0x0130
	.byte 0x01, 0x01
	.short 0x0000, 0x00D3
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x00D4
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x00D5
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x00D6
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00D7
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x001C
	.short 0x0059
	.byte 0x01, 0x01
	.short 0x0000, 0x001D
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x001E
	.short 0x0015
	.byte 0x01, 0x01
	.short 0x0000, 0x0098
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x00A4
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x00A5
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00A6
	.short 0x0003
	.byte 0x01, 0x01
	.short 0x0000, 0x00B8
	.short 0x0031
	.byte 0x01, 0x01
	.short 0x0000, 0x00B9
	.short 0x001A
	.byte 0x01, 0x01
	.short 0x0000, 0x00BA
	.short 0x01C3
	.byte 0x01, 0x00
	.short 0x0000, 0x00D8
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x00AE
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x001F
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x0007
	.short 0x0027
	.byte 0x01, 0x01
	.short 0x0000, 0x00B4
	.short 0x0015
	.byte 0x01, 0x01
	.short 0x0000, 0x0020
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0021
	.short 0x001A
	.byte 0x01, 0x01
	.short 0x0000, 0x0023
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x0099
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x00BB
	.short 0x0003
	.byte 0x01, 0x01
	.short 0x0000, 0x00BC
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x0022
	.short 0x004F
	.byte 0x01, 0x01
	.short 0x0000, 0x0024
	.short 0x004E
	.byte 0x01, 0x01
	.short 0x0000, 0x0025
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x0026
	.short 0x0026
	.byte 0x01, 0x01
	.short 0x0000, 0x0027
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x0095
	.short 0x0003
	.byte 0x01, 0x01
	.short 0x0000, 0x009A
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00BD
	.short 0x0013
	.byte 0x01, 0x01
	.short 0x0000, 0x00CA
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x00B5
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00B6
	.short 0x0034
	.byte 0x01, 0x01
	.short 0x0000, 0x00B7
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x0028
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0029
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x002A
	.short 0x005D
	.byte 0x01, 0x01
	.short 0x0000, 0x002B
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x00A8
	.short 0x012D
	.byte 0x01, 0x01
	.short 0x0000, 0x002C
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x002D
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x002E
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x002F
	.short 0x0018
	.byte 0x01, 0x01
	.short 0x0000, 0x009B
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x009C
	.short 0x001A
	.byte 0x01, 0x01
	.short 0x0000, 0x00A9
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x0030
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0031
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x0032
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x00BE
	.short 0x0030
	.byte 0x01, 0x01
	.short 0x0000, 0x00BF
	.short 0x001D
	.byte 0x01, 0x00
	.short 0x0000, 0x00C0
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x00DA
	.short 0x0027
	.byte 0x01, 0x01
	.short 0x0000, 0x0033
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0034
	.short 0x002F
	.byte 0x01, 0x01
	.short 0x0000, 0x0035
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x0036
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x0037
	.short 0x0139
	.byte 0x01, 0x01
	.short 0x0000, 0x0038
	.short 0x002D
	.byte 0x01, 0x01
	.short 0x0000, 0x0039
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x003A
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x003B
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00DB
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x00DC
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x00DD
	.short 0x0012
	.byte 0x01, 0x01
	.short 0x0000, 0x00DE
	.short 0x001A
	.byte 0x01, 0x01
	.short 0x0000, 0x00DF
	.short 0x0016
	.byte 0x01, 0x01
	.short 0x0000, 0x00E0
	.short 0x0011
	.byte 0x01, 0x01
	.short 0x0000, 0x00E1
	.short 0x0018
	.byte 0x01, 0x01
	.short 0x0000, 0x00E2
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x00E3
	.short 0x0034
	.byte 0x01, 0x01
	.short 0x0000, 0x003C
	.short 0x002D
	.byte 0x01, 0x01
	.short 0x0000, 0x003D
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x003E
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x003F
	.short 0x0028
	.byte 0x01, 0x01
	.short 0x0000, 0x0040
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0041
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0042
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x0043
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x0044
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x0045
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x0046
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x0047
	.short 0x0031
	.byte 0x01, 0x01
	.short 0x0000, 0x0048
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x0049
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x00C1
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x00C2
	.short 0x004D
	.byte 0x01, 0x01
	.short 0x0000, 0x00C3
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x00C4
	.short 0x002E
	.byte 0x01, 0x01
	.short 0x0000, 0x00C5
	.short 0x0018
	.byte 0x01, 0x01
	.short 0x0000, 0x00C6
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x00C7
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x00C8
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00B2
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x00B3
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x004A
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x004B
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x004C
	.short 0x0028
	.byte 0x01, 0x01
	.short 0x0000, 0x004D
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x004E
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x004F
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x0050
	.short 0x0026
	.byte 0x01, 0x01
	.short 0x0000, 0x0051
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x0052
	.short 0x004C
	.byte 0x01, 0x01
	.short 0x0000, 0x0053
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x0054
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x0055
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0056
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x0058
	.short 0x0018
	.byte 0x01, 0x01
	.short 0x0000, 0x0059
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x005A
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x005C
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x005D
	.short 0x0026
	.byte 0x01, 0x01
	.short 0x0000, 0x005E
	.short 0x004E
	.byte 0x01, 0x01
	.short 0x0000, 0x005F
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x0060
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x0061
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0062
	.short 0x0135
	.byte 0x01, 0x01
	.short 0x0000, 0x0063
	.short 0x0056
	.byte 0x01, 0x01
	.short 0x0000, 0x0064
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x0065
	.short 0x0018
	.byte 0x01, 0x01
	.short 0x0000, 0x0066
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x0067
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x0068
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x0069
	.short 0x0027
	.byte 0x01, 0x01
	.short 0x0000, 0x006A
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x006B
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x006C
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x006D
	.short 0x005E
	.byte 0x01, 0x01
	.short 0x0000, 0x009D
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x009E
	.short 0x012C
	.byte 0x01, 0x01
	.short 0x0000, 0x006E
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x006F
	.short 0x0059
	.byte 0x01, 0x01
	.short 0x0000, 0x0070
	.short 0x0029
	.byte 0x01, 0x01
	.short 0x0000, 0x0071
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x0072
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x0073
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x0074
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x0075
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x0076
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x0077
	.short 0x0132
	.byte 0x01, 0x01
	.short 0x0000, 0x0078
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x0079
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x007A
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x007B
	.short 0x0035
	.byte 0x01, 0x00
	.short 0x0000, 0x007C
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x007D
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x007E
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x007F
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x00AA
	.short 0x0058
	.byte 0x01, 0x01
	.short 0x0000, 0x00AB
	.short 0x0059
	.byte 0x01, 0x01
	.short 0x0000, 0x00AC
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x0080
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x0081
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x0082
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x00CB
	.short 0x004D
	.byte 0x01, 0x01
	.short 0x0000, 0x00CC
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00AD
	.short 0x001D
	.byte 0x01, 0x01
	.short 0x0000, 0x0083
	.short 0x0057
	.byte 0x01, 0x00
	.short 0x0000, 0x0084
	.short 0x0056
	.byte 0x01, 0x00
	.short 0x0000, 0x0085
	.short 0x0056
	.byte 0x01, 0x00
	.short 0x0000, 0x0086
	.short 0x0059
	.byte 0x01, 0x01
	.short 0x0000, 0x0087
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x009F
	.short 0x002E
	.byte 0x01, 0x01
	.short 0x0000, 0x0088
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x0089
	.short 0x0029
	.byte 0x01, 0x01
	.short 0x0000, 0x008A
	.short 0x012A
	.byte 0x01, 0x01
	.short 0x0000, 0x008B
	.short 0x0034
	.byte 0x01, 0x01
	.short 0x0000, 0x008C
	.short 0x002F
	.byte 0x01, 0x01
	.short 0x0000, 0x008D
	.short 0x0019
	.byte 0x01, 0x01
	.short 0x0000, 0x00AF
	.short 0x001C
	.byte 0x01, 0x01
	.short 0x0000, 0x00B0
	.short 0x001B
	.byte 0x01, 0x01
	.short 0x0000, 0x00B1
	.short 0x0031
	.byte 0x01, 0x01
	.short 0x0000, 0x008E
	.short 0x0002
	.byte 0x01, 0x01
	.short 0x0000, 0x008F
	.short 0x005A
	.byte 0x01, 0x01
	.short 0x0000, 0x0090
	.short 0x0032
	.byte 0x01, 0x01
	.short 0x0000, 0x00CD
	.short 0x0033
	.byte 0x01, 0x01
	.short 0x0000, 0x00CE
	.short 0x0017
	.byte 0x01, 0x01
	.short 0x0000, 0x00CF
	.short 0x0057
	.byte 0x01, 0x01
	.short 0x0000, 0x0091
	.short 0x005C
	.byte 0x01, 0x01
	.short 0x0000, 0x0092
	.short 0x0030
	.byte 0x01, 0x01
	.short 0x0000, 0x0093
	.short 0x002D
	.byte 0x01, 0x01
	.short 0x0000, 0x0094

	.text

	thumb_func_start FUN_02038C78
FUN_02038C78: ; 0x02038C78
	push {r3-r7, lr}
	add r5, r0, #0x0
	add r6, r1, #0x0
	add r7, r2, #0x0
	bl CreateFieldContext
	add r4, r0, #0x0
	mov r0, #0x0
	str r0, [sp, #0x0]
	add r0, r5, #0x0
	add r1, r4, #0x0
	add r2, r6, #0x0
	add r3, r7, #0x0
	bl FUN_02038E60
	ldr r1, _02038CA4 ; =FUN_02038D48
	add r0, r5, #0x0
	add r2, r4, #0x0
	bl FUN_020463CC
	pop {r3-r7, pc}
	nop
_02038CA4: .word FUN_02038D48 

	thumb_func_start FUN_02038CA8
FUN_02038CA8: ; 0x02038CA8
	push {r4-r6, lr}
	ldr r0, [r0, #0x10]
	add r5, r1, #0x0
	add r4, r2, #0x0
	add r6, r3, #0x0
	bl FUN_0204652C
	ldr r2, [sp, #0x1c]
	mov r1, #0x1c
	add r3, r2, #0x0
	add r0, #0x50
	mul r3, r1
	add r1, r0, r3
	str r4, [r0, r3]
	ldr r0, [sp, #0x10]
	str r6, [r1, #0x4]
	str r0, [r1, #0x8]
	ldr r0, [sp, #0x14]
	str r0, [r1, #0xc]
	ldr r0, [sp, #0x18]
	str r0, [r1, #0x10]
	str r5, [r1, #0x14]
	pop {r4-r6, pc}
	.balign 4

	thumb_func_start FUN_02038CD8
FUN_02038CD8: ; 0x02038CD8
	push {r4-r7, lr}
	sub sp, #0xc
	add r6, r0, #0x0
	add r7, r1, #0x0
	str r2, [sp, #0x4]
	add r5, r3, #0x0
	bl FUN_02046528
	str r0, [sp, #0x8]
	bl CreateFieldContext
	add r4, r0, #0x0
	ldr r0, [sp, #0x8]
	ldr r3, [sp, #0x4]
	add r1, r4, #0x0
	add r2, r7, #0x0
	str r5, [sp, #0x0]
	bl FUN_02038E60
	ldr r1, _02038D0C ; =FUN_02038D48
	add r0, r6, #0x0
	add r2, r4, #0x0
	bl FUN_0204640C
	add sp, #0xc
	pop {r4-r7, pc}
	.balign 4
_02038D0C: .word FUN_02038D48 

	thumb_func_start FUN_02038D10
FUN_02038D10: ; 0x02038D10
	push {r3-r7, lr}
	sub sp, #0x8
	add r5, r0, #0x0
	add r6, r1, #0x0
	add r7, r2, #0x0
	bl FUN_02046528
	str r0, [sp, #0x4]
	bl CreateFieldContext
	add r4, r0, #0x0
	mov r0, #0x0
	str r0, [sp, #0x0]
	ldr r0, [sp, #0x4]
	add r1, r4, #0x0
	add r2, r6, #0x0
	add r3, r7, #0x0
	bl FUN_02038E60
	ldr r1, _02038D44 ; =FUN_02038D48
	add r0, r5, #0x0
	add r2, r4, #0x0
	bl FUN_020463EC
	add sp, #0x8
	pop {r3-r7, pc}
	.balign 4
_02038D44: .word FUN_02038D48 

	thumb_func_start FUN_02038D48
FUN_02038D48: ; 0x02038D48
	push {r3-r7, lr}
	sub sp, #0x8
	add r5, r0, #0x0
	bl FUN_0204652C
	add r4, r0, #0x0
	add r0, r5, #0x0
	bl FUN_02046528
	ldrb r1, [r4, #0x4]
	str r0, [sp, #0x0]
	cmp r1, #0x0
	beq _02038D68
	cmp r1, #0x1
	beq _02038D9E
	b _02038E1A
_02038D68:
	ldrh r1, [r4, #0xa]
	bl CreateScriptContext
	str r0, [r4, #0x38]
	mov r0, #0x1
	strb r0, [r4, #0x9]
	mov r0, #0x8
	mov r1, #0x40
	mov r2, #0xb
	bl ScrStrBufs_new_custom
	str r0, [r4, #0x40]
	mov r0, #0x1
	lsl r0, r0, #0xa
	mov r1, #0xb
	bl String_ctor
	str r0, [r4, #0x44]
	mov r0, #0x1
	lsl r0, r0, #0xa
	mov r1, #0xb
	bl String_ctor
	str r0, [r4, #0x48]
	ldrb r0, [r4, #0x4]
	add r0, r0, #0x1
	strb r0, [r4, #0x4]
_02038D9E:
	mov r0, #0x0
	add r7, r4, #0x0
	str r0, [sp, #0x4]
	add r5, r4, #0x0
	add r7, #0x9
_02038DA8:
	ldr r6, [r5, #0x38]
	cmp r6, #0x0
	beq _02038DD2
	add r0, r6, #0x0
	bl RunScriptCommand
	cmp r0, #0x0
	bne _02038DD2
	add r0, r6, #0x0
	bl DeleteScriptContext
	ldrb r0, [r4, #0x9]
	cmp r0, #0x0
	bne _02038DC8
	bl GF_AssertFail
_02038DC8:
	mov r0, #0x0
	str r0, [r5, #0x38]
	ldrb r0, [r7, #0x0]
	sub r0, r0, #0x1
	strb r0, [r7, #0x0]
_02038DD2:
	ldr r0, [sp, #0x4]
	add r5, r5, #0x4
	add r0, r0, #0x1
	str r0, [sp, #0x4]
	cmp r0, #0x2
	blt _02038DA8
	ldrb r0, [r4, #0x9]
	cmp r0, #0x0
	bne _02038E1A
	add r0, r4, #0x0
	add r0, #0xa4
	ldr r5, [r0, #0x0]
	ldr r0, [r4, #0x40]
	bl ScrStrBufs_delete
	ldr r0, [r4, #0x44]
	bl String_dtor
	ldr r0, [r4, #0x48]
	bl String_dtor
	mov r0, #0x0
	str r0, [r4, #0x0]
	add r0, r4, #0x0
	bl FreeToHeap
	cmp r5, #0x0
	beq _02038E14
	ldr r0, [sp, #0x0]
	blx r5
	add sp, #0x8
	mov r0, #0x0
	pop {r3-r7, pc}
_02038E14:
	add sp, #0x8
	mov r0, #0x1
	pop {r3-r7, pc}
_02038E1A:
	mov r0, #0x0
	add sp, #0x8
	pop {r3-r7, pc}

	thumb_func_start CreateFieldContext
CreateFieldContext: ; 0x02038E20
	push {r4, lr}
	mov r0, #0xb
	mov r1, #0xdc
	bl AllocFromHeap
	add r4, r0, #0x0
	bne _02038E32
	bl GF_AssertFail
_02038E32:
	add r0, r4, #0x0
	mov r1, #0x0
	mov r2, #0xdc
	bl memset
	ldr r0, _02038E44 ; =0x0003643F
	str r0, [r4, #0x0]
	add r0, r4, #0x0
	pop {r4, pc}
	.balign 4
_02038E44: .word 0x0003643F

	thumb_func_start DeleteScriptContext
DeleteScriptContext: ; 0x02038E48
	push {r4, lr}
	add r4, r0, #0x0
	ldr r0, [r4, #0x78]
	bl DestroyMsgData
	ldr r0, [r4, #0x7c]
	bl FreeToHeap
	add r0, r4, #0x0
	bl FreeToHeap
	pop {r4, pc}

	thumb_func_start FUN_02038E60
FUN_02038E60: ; 0x02038E60
	push {r3-r7, lr}
	add r5, r1, #0x0
	add r7, r0, #0x0
	add r0, r5, #0x0
	mov r1, #0x36
	add r4, r2, #0x0
	add r6, r3, #0x0
	bl FUN_02039300
	str r0, [sp, #0x0]
	ldr r0, [r7, #0x38]
	bl FUN_020552F8
	str r0, [r5, #0x28]
	str r6, [r5, #0x2c]
	ldr r0, [sp, #0x18]
	strh r4, [r5, #0xa]
	str r0, [r5, #0x34]
	cmp r6, #0x0
	beq _02038E92
	add r0, r6, #0x0
	bl FUN_02058448
	ldr r1, [sp, #0x0]
	strh r0, [r1, #0x0]
_02038E92:
	mov r0, #0x7d
	lsl r0, r0, #0x6
	cmp r4, r0
	blo _02038EA8
	ldr r0, _02038EAC ; =0x0000225F
	cmp r4, r0
	bhi _02038EA8
	add r0, r5, #0x0
	add r1, r4, #0x0
	bl FUN_020396E8
_02038EA8:
	pop {r3-r7, pc}
	nop
_02038EAC: .word 0x0000225F

	thumb_func_start CreateScriptContext
CreateScriptContext: ; 0x02038EB0
	push {r4-r6, lr}
	add r5, r0, #0x0
	add r6, r1, #0x0
	mov r0, #0xb
	mov r1, #0x84
	bl AllocFromHeap
	add r4, r0, #0x0
	bne _02038EC6
	bl GF_AssertFail
_02038EC6:
	ldr r2, _02038EE4 ; =sNumScriptCmds
	ldr r1, _02038EE8 ; =gScriptCmdTable
	ldr r2, [r2, #0x0]
	add r0, r4, #0x0
	bl InitScriptContext
	add r0, r5, #0x0
	add r1, r4, #0x0
	add r2, r6, #0x0
	mov r3, #0x0
	bl SetUpScriptContextForMap
	add r0, r4, #0x0
	pop {r4-r6, pc}
	nop
_02038EE4: .word sNumScriptCmds
_02038EE8: .word gScriptCmdTable

	thumb_func_start SetUpScriptContextForMap
SetUpScriptContextForMap: ; 0x02038EEC
	push {r4-r6, lr}
	add r4, r1, #0x0
	add r3, r4, #0x0
	add r5, r0, #0x0
	add r3, #0x80
	str r5, [r3, #0x0]
	bl LoadScriptsAndMessagesByMapId
	add r6, r0, #0x0
	ldr r1, [r4, #0x7c]
	add r0, r4, #0x0
	bl SetupBytecodeScript
	add r0, r4, #0x0
	add r1, r6, #0x0
	bl ScriptRunByIndex
	ldr r1, [r5, #0x10]
	add r0, r4, #0x0
	bl FUN_02038B6C
	pop {r4-r6, pc}

	thumb_func_start LoadScriptsAndMessagesByMapId
LoadScriptsAndMessagesByMapId: ; 0x02038F18
	push {r3-r5, lr}
	ldr r3, _02039210 ; =0x0000283C
	add r4, r2, #0x0
	cmp r4, r3
	blo _02038F36
	mov r3, #0x1f
	ldr r2, _02039214 ; =0x000003D1
	lsl r3, r3, #0x4
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039210 ; =0x0000283C
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038F36:
	add r2, r3, #0x0
	sub r2, #0x64
	cmp r4, r2
	blo _02038F52
	ldr r2, _02039218 ; =0x00000175
	add r3, r2, #0x0
	sub r3, #0x29
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _0203921C ; =0x000027D8
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038F52:
	add r2, r3, #0x0
	sub r2, #0x96
	cmp r4, r2
	blo _02038F6C
	ldr r2, _02039220 ; =0x00000412
	ldr r3, _02039224 ; =0x00000232
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039228 ; =0x000027A6
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038F6C:
	sub r3, #0xc8
	cmp r4, r3
	blo _02038F84
	ldr r2, _0203922C ; =0x00000411
	ldr r3, _02039230 ; =0x00000233
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039234 ; =0x00002774
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038F84:
	ldr r3, _02039238 ; =0x00002710
	cmp r4, r3
	blo _02038F9E
	ldr r2, _0203923C ; =0x00000177
	add r3, r2, #0x0
	sub r3, #0x29
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039238 ; =0x00002710
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038F9E:
	add r2, r3, #0x0
	sub r2, #0x32
	cmp r4, r2
	blo _02038FBC
	mov r2, #0x5e
	lsl r2, r2, #0x2
	add r3, r2, #0x0
	sub r3, #0x29
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039240 ; =0x000026DE
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038FBC:
	add r2, r3, #0x0
	sub r2, #0x64
	cmp r4, r2
	blo _02038FD6
	ldr r2, _02039244 ; =0x0000016D
	mov r3, #0xc7
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039248 ; =0x000026AC
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038FD6:
	add r2, r3, #0x0
	sub r2, #0xc8
	cmp r4, r2
	blo _02038FF0
	mov r2, #0xce
	mov r3, #0xcb
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _0203924C ; =0x00002648
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02038FF0:
	ldr r5, _02039250 ; =0x000025E4
	cmp r4, r5
	blo _0203900A
	ldr r2, _02039254 ; =0x00000183
	add r3, r2, #0x0
	sub r3, #0x9
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_0203900A:
	add r2, r5, #0x0
	sub r2, #0x64
	cmp r4, r2
	blo _02039026
	ldr r2, _02039258 ; =0x00000179
	mov r3, #0xc7
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, #0x64
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039026:
	sub r5, #0xc8
	cmp r4, r5
	blo _02039042
	mov r2, #0x1d
	lsl r2, r2, #0x4
	add r3, r2, #0x0
	add r3, #0x1c
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _0203925C ; =0x0000251C
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039042:
	ldr r5, _02039260 ; =0x000024B8
	cmp r4, r5
	blo _0203905C
	ldr r2, _02039264 ; =0x00000187
	add r3, r2, #0x0
	sub r3, #0xa
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_0203905C:
	add r2, r5, #0x0
	sub r2, #0x64
	cmp r4, r2
	blo _0203907C
	mov r2, #0x5d
	lsl r2, r2, #0x2
	add r3, r2, #0x0
	sub r3, #0x2b
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, #0x64
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_0203907C:
	sub r5, #0xc8
	cmp r4, r5
	blo _02039098
	mov r2, #0x61
	lsl r2, r2, #0x2
	add r3, r2, #0x0
	sub r3, #0x9
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039268 ; =0x000023F0
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039098:
	ldr r2, _0203926C ; =0x0000238C
	cmp r4, r2
	blo _020390B0
	mov r2, #0x0
	mov r3, #0x9
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _0203926C ; =0x0000238C
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020390B0:
	add r5, r2, #0x0
	sub r5, #0x64
	cmp r4, r5
	blo _020390CA
	mov r2, #0xcf
	add r3, r2, #0x0
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039270 ; =0x00002328
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020390CA:
	add r5, r2, #0x0
	sub r5, #0x82
	cmp r4, r5
	blo _020390E4
	ldr r2, _02039274 ; =0x00000186
	mov r3, #0x7
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039278 ; =0x0000230A
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020390E4:
	add r5, r2, #0x0
	sub r5, #0x96
	cmp r4, r5
	blo _02039100
	ldr r2, _0203927C ; =0x000001CF
	add r3, r2, #0x0
	add r3, #0x17
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039280 ; =0x000022F6
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039100:
	sub r2, #0xc8
	cmp r4, r2
	blo _0203911A
	ldr r2, _02039284 ; =0x00000185
	add r3, r2, #0x0
	sub r3, #0x9
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _02039288 ; =0x000022C4
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_0203911A:
	ldr r2, _0203928C ; =0x00002260
	cmp r4, r2
	blo _02039134
	ldr r2, _02039290 ; =0x000001CE
	add r3, r2, #0x0
	add r3, #0x17
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _0203928C ; =0x00002260
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039134:
	mov r2, #0x7d
	lsl r2, r2, #0x6
	cmp r4, r2
	blo _02039152
	ldr r2, _02039294 ; =0x00000176
	add r3, r2, #0x0
	sub r3, #0x29
	bl LoadScriptsAndMessagesParameterized
	mov r0, #0x7d
	lsl r0, r0, #0x6
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039152:
	ldr r5, _02039298 ; =0x00001B58
	cmp r4, r5
	blo _0203916C
	ldr r2, _0203929C ; =0x00000172
	add r3, r2, #0x0
	sub r3, #0x2d
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_0203916C:
	lsr r5, r3, #0x1
	cmp r4, r5
	blo _02039186
	mov r2, #0x41
	lsl r2, r2, #0x4
	mov r3, #0xc7
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _020392A0 ; =0x00001388
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_02039186:
	ldr r5, _020392A4 ; =0x00000BB8
	cmp r4, r5
	blo _020391A0
	mov r2, #0x41
	lsl r2, r2, #0x4
	mov r3, #0xc7
	bl LoadScriptsAndMessagesParameterized
	add r0, r5, #0x0
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020391A0:
	sub r5, #0xc8
	cmp r4, r5
	blo _020391BC
	ldr r2, _020392A8 ; =0x0000017A
	add r3, r2, #0x0
	sub r3, #0x1c
	bl LoadScriptsAndMessagesParameterized
	mov r0, #0xaf
	lsl r0, r0, #0x4
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020391BC:
	lsr r3, r3, #0x2
	cmp r4, r3
	blo _020391D4
	mov r2, #0x1
	mov r3, #0xd
	bl LoadScriptsAndMessagesParameterized
	ldr r0, _020392AC ; =0x000009C4
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020391D4:
	lsr r2, r2, #0x2
	cmp r4, r2
	blo _020391EE
	mov r2, #0xcd
	mov r3, #0xc7
	bl LoadScriptsAndMessagesParameterized
	mov r0, #0x7d
	lsl r0, r0, #0x4
	sub r0, r4, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020391EE:
	cmp r4, #0x1
	blo _020391FE
	bl LoadScriptsAndMessagesForCurrentMap
	sub r0, r4, #0x1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	b _0203920A
_020391FE:
	ldr r2, _020392B0 ; =0x00000171
	add r3, r2, #0x0
	sub r3, #0x34
	bl LoadScriptsAndMessagesParameterized
	mov r4, #0x0
_0203920A:
	add r0, r4, #0x0
	pop {r3-r5, pc}
	nop
_02039210: .word 0x0000283C
_02039214: .word 0x000003D1
_02039218: .word 0x00000175
_0203921C: .word 0x000027D8
_02039220: .word 0x00000412
_02039224: .word 0x00000232
_02039228: .word 0x000027A6
_0203922C: .word 0x00000411
_02039230: .word 0x00000233
_02039234: .word 0x00002774
_02039238: .word 0x00002710
_0203923C: .word 0x00000177
_02039240: .word 0x000026DE
_02039244: .word 0x0000016D
_02039248: .word 0x000026AC
_0203924C: .word 0x00002648
_02039250: .word 0x000025E4
_02039254: .word 0x00000183
_02039258: .word 0x00000179
_0203925C: .word 0x0000251C
_02039260: .word 0x000024B8
_02039264: .word 0x00000187
_02039268: .word 0x000023F0
_0203926C: .word 0x0000238C
_02039270: .word 0x00002328
_02039274: .word 0x00000186
_02039278: .word 0x0000230A
_0203927C: .word 0x000001CF
_02039280: .word 0x000022F6
_02039284: .word 0x00000185
_02039288: .word 0x000022C4
_0203928C: .word 0x00002260
_02039290: .word 0x000001CE
_02039294: .word 0x00000176
_02039298: .word 0x00001B58
_0203929C: .word 0x00000172
_020392A0: .word 0x00001388
_020392A4: .word 0x00000BB8
_020392A8: .word 0x0000017A
_020392AC: .word 0x000009C4
_020392B0: .word 0x00000171

	thumb_func_start LoadScriptsAndMessagesParameterized
LoadScriptsAndMessagesParameterized: ; 0x020392B4
	push {r3-r5, lr}
	add r5, r1, #0x0
	add r1, r2, #0x0
	add r4, r3, #0x0
	mov r0, #0xa
	mov r2, #0xb
	bl AllocAndReadWholeNarcMemberByIdPair
	str r0, [r5, #0x7c]
	mov r0, #0x1
	mov r1, #0x1a
	add r2, r4, #0x0
	mov r3, #0xb
	bl NewMsgDataFromNarc
	str r0, [r5, #0x78]
	pop {r3-r5, pc}
	.balign 4

	thumb_func_start LoadScriptsAndMessagesForCurrentMap
LoadScriptsAndMessagesForCurrentMap: ; 0x020392D8
	push {r3-r5, lr}
	add r5, r0, #0x0
	ldr r0, [r5, #0x1c]
	add r4, r1, #0x0
	ldr r0, [r0, #0x0]
	bl LoadScriptsForCurrentMap
	str r0, [r4, #0x7c]
	ldr r0, [r5, #0x1c]
	ldr r0, [r0, #0x0]
	bl GetCurrentMapMessageBank
	add r2, r0, #0x0
	mov r0, #0x1
	mov r1, #0x1a
	mov r3, #0xb
	bl NewMsgDataFromNarc
	str r0, [r4, #0x78]
	pop {r3-r5, pc}

	thumb_func_start FUN_02039300
FUN_02039300: ; 0x02039300
	push {r3, lr}
	cmp r1, #0x36
	bls _02039308
	b _02039430
_02039308:
	add r2, r1, r1
	add r2, pc
	ldrh r2, [r2, #0x6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_02039314: ; jump table (using 16-bit offset)
	.short _02039382 - _02039314 - 2; case 0
	.short _02039386 - _02039314 - 2; case 1
	.short _0203938A - _02039314 - 2; case 2
	.short _0203938E - _02039314 - 2; case 3
	.short _02039392 - _02039314 - 2; case 4
	.short _02039396 - _02039314 - 2; case 5
	.short _0203939A - _02039314 - 2; case 6
	.short _0203939E - _02039314 - 2; case 7
	.short _020393A2 - _02039314 - 2; case 8
	.short _020393A6 - _02039314 - 2; case 9
	.short _020393AA - _02039314 - 2; case 10
	.short _020393AE - _02039314 - 2; case 11
	.short _020393B2 - _02039314 - 2; case 12
	.short _020393B6 - _02039314 - 2; case 13
	.short _020393BA - _02039314 - 2; case 14
	.short _020393BE - _02039314 - 2; case 15
	.short _020393C2 - _02039314 - 2; case 16
	.short _020393C6 - _02039314 - 2; case 17
	.short _020393CA - _02039314 - 2; case 18
	.short _020393CE - _02039314 - 2; case 19
	.short _020393D2 - _02039314 - 2; case 20
	.short _020393D6 - _02039314 - 2; case 21
	.short _020393DA - _02039314 - 2; case 22
	.short _020393DE - _02039314 - 2; case 23
	.short _020393E2 - _02039314 - 2; case 24
	.short _020393E6 - _02039314 - 2; case 25
	.short _020393EA - _02039314 - 2; case 26
	.short _020393EE - _02039314 - 2; case 27
	.short _020393F2 - _02039314 - 2; case 28
	.short _020393F6 - _02039314 - 2; case 29
	.short _020393FA - _02039314 - 2; case 30
	.short _020393FE - _02039314 - 2; case 31
	.short _02039402 - _02039314 - 2; case 32
	.short _02039406 - _02039314 - 2; case 33
	.short _0203940A - _02039314 - 2; case 34
	.short _0203940E - _02039314 - 2; case 35
	.short _02039412 - _02039314 - 2; case 36
	.short _02039416 - _02039314 - 2; case 37
	.short _0203941A - _02039314 - 2; case 38
	.short _0203941E - _02039314 - 2; case 39
	.short _02039422 - _02039314 - 2; case 40
	.short _02039426 - _02039314 - 2; case 41
	.short _02039426 - _02039314 - 2; case 42
	.short _02039426 - _02039314 - 2; case 43
	.short _02039426 - _02039314 - 2; case 44
	.short _02039426 - _02039314 - 2; case 45
	.short _02039426 - _02039314 - 2; case 46
	.short _02039426 - _02039314 - 2; case 47
	.short _02039426 - _02039314 - 2; case 48
	.short _02039426 - _02039314 - 2; case 49
	.short _02039426 - _02039314 - 2; case 50
	.short _02039426 - _02039314 - 2; case 51
	.short _02039426 - _02039314 - 2; case 52
	.short _02039426 - _02039314 - 2; case 53
	.short _02039426 - _02039314 - 2; case 54
_02039382:
	add r0, #0x10
	pop {r3, pc}
_02039386:
	add r0, #0x14
	pop {r3, pc}
_0203938A:
	add r0, #0x24
	pop {r3, pc}
_0203938E:
	add r0, r0, #0x5
	pop {r3, pc}
_02039392:
	add r0, r0, #0x6
	pop {r3, pc}
_02039396:
	add r0, r0, #0x7
	pop {r3, pc}
_0203939A:
	add r0, #0x8
	pop {r3, pc}
_0203939E:
	add r0, #0x9
	pop {r3, pc}
_020393A2:
	add r0, #0xa
	pop {r3, pc}
_020393A6:
	add r0, #0x28
	pop {r3, pc}
_020393AA:
	add r0, #0x2c
	pop {r3, pc}
_020393AE:
	add r0, #0x30
	pop {r3, pc}
_020393B2:
	add r0, #0x34
	pop {r3, pc}
_020393B6:
	add r0, #0x38
	pop {r3, pc}
_020393BA:
	add r0, #0x3c
	pop {r3, pc}
_020393BE:
	add r0, #0x40
	pop {r3, pc}
_020393C2:
	add r0, #0x44
	pop {r3, pc}
_020393C6:
	add r0, #0x48
	pop {r3, pc}
_020393CA:
	add r0, #0x4c
	pop {r3, pc}
_020393CE:
	add r0, #0xa8
	pop {r3, pc}
_020393D2:
	add r0, #0xac
	pop {r3, pc}
_020393D6:
	add r0, #0xb0
	pop {r3, pc}
_020393DA:
	add r0, #0xb4
	pop {r3, pc}
_020393DE:
	add r0, #0xc
	pop {r3, pc}
_020393E2:
	add r0, #0x50
	pop {r3, pc}
_020393E6:
	add r0, #0x54
	pop {r3, pc}
_020393EA:
	add r0, #0x58
	pop {r3, pc}
_020393EE:
	add r0, #0x5c
	pop {r3, pc}
_020393F2:
	add r0, #0x60
	pop {r3, pc}
_020393F6:
	add r0, #0x64
	pop {r3, pc}
_020393FA:
	add r0, #0x68
	pop {r3, pc}
_020393FE:
	add r0, #0x6c
	pop {r3, pc}
_02039402:
	add r0, #0x70
	pop {r3, pc}
_02039406:
	add r0, #0x74
	pop {r3, pc}
_0203940A:
	add r0, #0x78
	pop {r3, pc}
_0203940E:
	add r0, #0x7c
	pop {r3, pc}
_02039412:
	add r0, #0x80
	pop {r3, pc}
_02039416:
	add r0, #0x84
	pop {r3, pc}
_0203941A:
	add r0, #0xb8
	pop {r3, pc}
_0203941E:
	add r0, #0xc8
	pop {r3, pc}
_02039422:
	add r0, #0xd8
	pop {r3, pc}
_02039426:
	sub r1, #0x29
	add r0, #0x88
	lsl r1, r1, #0x1
	add r0, r0, r1
	pop {r3, pc}
_02039430:
	bl GF_AssertFail
	mov r0, #0x0
	pop {r3, pc}

	thumb_func_start FUN_02039438
FUN_02039438: ; 0x02039438
	push {r3-r5, lr}
	ldr r0, [r0, #0x10]
	add r5, r1, #0x0
	bl FUN_0204652C
	add r4, r0, #0x0
	ldr r1, [r4, #0x0]
	ldr r0, _0203945C ; =0x0003643F
	cmp r1, r0
	beq _02039450
	bl GF_AssertFail
_02039450:
	add r0, r4, #0x0
	add r1, r5, #0x0
	bl FUN_02039300
	pop {r3-r5, pc}
	nop
_0203945C: .word 0x0003643F

	thumb_func_start FUN_02039460
FUN_02039460: ; 0x02039460
	push {r3-r5, lr}
	add r5, r0, #0x0
	ldr r0, [r5, #0x10]
	bl FUN_0204652C
	add r4, r0, #0x0
	add r0, r5, #0x0
	bl FUN_02035068
	cmp r0, #0x1
	bne _0203947C
	ldr r0, _02039480 ; =FUN_020351A0
	add r4, #0xa4
	str r0, [r4, #0x0]
_0203947C:
	pop {r3-r5, pc}
	nop
_02039480: .word FUN_020351A0 

	thumb_func_start ScriptRunByIndex
ScriptRunByIndex: ; 0x02039484
	push {r4, lr}
	add r4, r0, #0x0
	ldr r2, [r4, #0x8]
	lsl r1, r1, #0x2
	add r1, r2, r1
	str r1, [r4, #0x8]
	bl ScriptReadWord
	ldr r1, [r4, #0x8]
	add r0, r1, r0
	str r0, [r4, #0x8]
	pop {r4, pc}

	thumb_func_start LoadScriptsForCurrentMap
LoadScriptsForCurrentMap: ; 0x0203949C
	push {r3, lr}
	bl MapHeader_GetScriptsBank
	add r1, r0, #0x0
	mov r0, #0xa
	mov r2, #0xb
	bl AllocAndReadWholeNarcMemberByIdPair
	pop {r3, pc}
	.balign 4

	thumb_func_start GetCurrentMapMessageBank
GetCurrentMapMessageBank: ; 0x020394B0
	ldr r3, _020394B4 ; =MapHeader_GetMsgBank
	bx r3
	.balign 4
_020394B4: .word MapHeader_GetMsgBank 

	thumb_func_start GetVarPointer
GetVarPointer: ; 0x020394B8
	push {r3-r5, lr}
	add r5, r0, #0x0
	ldr r0, [r5, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	mov r1, #0x1
	lsl r1, r1, #0xe
	cmp r4, r1
	bhs _020394D0
	mov r0, #0x0
	pop {r3-r5, pc}
_020394D0:
	lsl r1, r1, #0x1
	cmp r4, r1
	bhs _020394DE
	add r1, r4, #0x0
	bl GetVarAddr
	pop {r3-r5, pc}
_020394DE:
	ldr r1, _020394EC ; =0x00007FD7
	add r0, r5, #0x0
	sub r1, r4, r1
	bl FUN_02039438
	pop {r3-r5, pc}
	nop
_020394EC: .word 0x00007FD7

	thumb_func_start VarGet
VarGet: ; 0x020394F0
	push {r4, lr}
	add r4, r1, #0x0
	bl GetVarPointer
	cmp r0, #0x0
	beq _020394FE
	ldrh r4, [r0, #0x0]
_020394FE:
	add r0, r4, #0x0
	pop {r4, pc}
	.balign 4

	thumb_func_start FUN_02039504
FUN_02039504: ; 0x02039504
	push {r3-r5, lr}
	add r4, r1, #0x0
	add r5, r0, #0x0
	cmp r4, #0x10
	blo _02039512
	bl GF_AssertFail
_02039512:
	ldr r1, _02039524 ; =0x00004020
	add r0, r5, #0x0
	add r1, r4, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl VarGet
	pop {r3-r5, pc}
	nop
_02039524: .word 0x00004020

	thumb_func_start FlagCheck
FlagCheck: ; 0x02039528
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	add r1, r4, #0x0
	bl CheckFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start FlagSet
FlagSet: ; 0x0203953C
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	add r1, r4, #0x0
	bl SetFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start FlagClear
FlagClear: ; 0x02039550
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	add r1, r4, #0x0
	bl ClearFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start ResetTempFlagsAndVars
ResetTempFlagsAndVars: ; 0x02039564
	push {r4, lr}
	ldr r0, [r0, #0xc]
	bl SavArray_Flags_get
	mov r1, #0x1
	add r4, r0, #0x0
	bl GetFlagAddr
	mov r1, #0x0
	strb r1, [r0, #0x0]
	strb r1, [r0, #0x1]
	strb r1, [r0, #0x2]
	strb r1, [r0, #0x3]
	strb r1, [r0, #0x4]
	strb r1, [r0, #0x5]
	strb r1, [r0, #0x6]
	strb r1, [r0, #0x7]
	mov r1, #0x1
	add r0, r4, #0x0
	lsl r1, r1, #0xe
	bl GetVarAddr
	mov r1, #0x0
	mov r2, #0x40
	bl memset
	pop {r4, pc}
	.balign 4

	thumb_func_start FUN_0203959C
FUN_0203959C: ; 0x0203959C
	push {r3, lr}
	ldr r0, [r0, #0xc]
	bl SavArray_Flags_get
	mov r1, #0xaa
	lsl r1, r1, #0x4
	bl GetFlagAddr
	mov r2, #0x18
	mov r1, #0x0
_020395B0:
	strb r1, [r0, #0x0]
	add r0, r0, #0x1
	sub r2, r2, #0x1
	bne _020395B0
	pop {r3, pc}
	.balign 4

	thumb_func_start FUN_020395BC
FUN_020395BC: ; 0x020395BC
	push {r3-r7, lr}
	add r4, r1, #0x0
	add r5, r0, #0x0
	mov r1, #0x29
	add r6, r2, #0x0
	add r7, r3, #0x0
	bl FUN_02039438
	strh r4, [r0, #0x0]
	add r0, r5, #0x0
	mov r1, #0x2a
	bl FUN_02039438
	strh r6, [r0, #0x0]
	add r0, r5, #0x0
	mov r1, #0x2b
	bl FUN_02039438
	strh r7, [r0, #0x0]
	add r0, r5, #0x0
	mov r1, #0x2c
	bl FUN_02039438
	add r1, sp, #0x8
	ldrh r1, [r1, #0x10]
	strh r1, [r0, #0x0]
	pop {r3-r7, pc}
	.balign 4

	thumb_func_start FUN_020395F4
FUN_020395F4: ; 0x020395F4
	ldr r1, _02039610 ; =0x00001388
	cmp r0, r1
	bhs _02039604
	ldr r1, _02039614 ; =0x00000BB7
	sub r0, r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
_02039604:
	sub r1, r1, #0x1
	sub r0, r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
	nop
_02039610: .word 0x00001388
_02039614: .word 0x00000BB7

	thumb_func_start FUN_02039618
FUN_02039618: ; 0x02039618
	ldr r1, _02039628 ; =0x00001388
	cmp r0, r1
	blo _02039622
	mov r0, #0x1
	bx lr
_02039622:
	mov r0, #0x0
	bx lr
	nop
_02039628: .word 0x00001388

	thumb_func_start Field_TrainerIsDoubleBattle
Field_TrainerIsDoubleBattle: ; 0x0203962C
	push {r3, lr}
	mov r1, #0x9
	bl TrainerData_GetAttr
	cmp r0, #0x0
	beq _0203963C
	mov r0, #0x1
	pop {r3, pc}
_0203963C:
	mov r0, #0x0
	pop {r3, pc}

	thumb_func_start TrainerFlagCheck
TrainerFlagCheck: ; 0x02039640
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	mov r1, #0x55
	lsl r1, r1, #0x4
	add r1, r4, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl CheckFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start TrainerFlagSet
TrainerFlagSet: ; 0x0203965C
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	mov r1, #0x55
	lsl r1, r1, #0x4
	add r1, r4, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl SetFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start TrainerFlagClear
TrainerFlagClear: ; 0x02039678
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0x0
	bl SavArray_Flags_get
	mov r1, #0x55
	lsl r1, r1, #0x4
	add r1, r4, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl ClearFlagInArray
	pop {r4, pc}
	.balign 4

	thumb_func_start FUN_02039694
FUN_02039694: ; 0x02039694
	ldr r1, _020396A0 ; =0x00001C66
	sub r0, r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
	nop
_020396A0: .word 0x00001C66

	thumb_func_start FUN_020396A4
FUN_020396A4: ; 0x020396A4
	mov r1, #0x7d
	lsl r1, r1, #0x6
	sub r0, r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr

	thumb_func_start FUN_020396B0
FUN_020396B0: ; 0x020396B0
	push {r4, lr}
	ldr r4, _020396E4 ; =UNK_020F2DB4
	bl FUN_020396A4
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	mov r1, #0x0
	add r2, r4, #0x0
_020396C0:
	ldrh r0, [r2, #0x6]
	cmp r3, r0
	beq _020396CE
	add r1, r1, #0x1
	add r2, #0x8
	cmp r1, #0xe5
	blo _020396C0
_020396CE:
	cmp r1, #0xe5
	blo _020396DA
	bl GF_AssertFail
	mov r0, #0x0
	pop {r4, pc}
_020396DA:
	lsl r0, r1, #0x3
	add r0, r4, r0
	ldrb r0, [r0, #0x3]
	pop {r4, pc}
	nop
_020396E4: .word UNK_020F2DB4

	thumb_func_start FUN_020396E8
FUN_020396E8: ; 0x020396E8
	push {r3-r7, lr}
	add r5, r1, #0x0
	add r4, r0, #0x0
	mov r1, #0x29
	bl FUN_02039300
	add r7, r0, #0x0
	add r0, r4, #0x0
	mov r1, #0x2a
	bl FUN_02039300
	add r6, r0, #0x0
	add r0, r4, #0x0
	mov r1, #0x2b
	bl FUN_02039300
	add r4, r0, #0x0
	add r0, r5, #0x0
	bl FUN_020396A4
	lsl r0, r0, #0x18
	ldr r2, _02039750 ; =UNK_020F2DB4
	lsr r3, r0, #0x18
	mov r1, #0x0
_02039718:
	ldrh r0, [r2, #0x6]
	cmp r3, r0
	beq _02039726
	add r1, r1, #0x1
	add r2, #0x8
	cmp r1, #0xe5
	blo _02039718
_02039726:
	cmp r1, #0xe5
	blo _02039732
	bl GF_AssertFail
	mov r0, #0x0
	pop {r3-r7, pc}
_02039732:
	lsl r0, r1, #0x3
	ldr r1, _02039750 ; =UNK_020F2DB4
	ldrh r1, [r1, r0]
	strh r1, [r7, #0x0]
	ldr r1, _02039750 ; =UNK_020F2DB4
	add r0, r1, r0
	ldrb r0, [r0, #0x2]
	strh r0, [r6, #0x0]
	add r0, r5, #0x0
	bl FUN_02039694
	strh r0, [r4, #0x0]
	mov r0, #0x1
	pop {r3-r7, pc}
	nop
_02039750: .word UNK_020F2DB4

	thumb_func_start FUN_02039754
FUN_02039754: ; 0x02039754
	push {r4-r7, lr}
	sub sp, #0x24
	str r0, [sp, #0x0]
	add r4, r1, #0x0
	mov r6, #0x0
	bl FUN_02034AF8
	add r5, r0, #0x0
	add r2, r5, #0x1
	mov r1, #0x6
	add r0, r4, #0x0
	mul r1, r2
	bl AllocFromHeap
	str r0, [sp, #0x1c]
	cmp r5, #0x0
	bne _02039786
	mov r2, #0xff
	add r1, r0, #0x0
	strb r2, [r1, #0x4]
	ldr r2, _02039870 ; =0x0000FFFF
	add sp, #0x24
	strh r2, [r1, #0x0]
	strh r2, [r1, #0x2]
	pop {r4-r7, pc}
_02039786:
	ldr r0, [sp, #0x0]
	bl FUN_02034AF0
	add r4, r0, #0x0
	bne _020397A0
	ldr r0, [sp, #0x1c]
	mov r1, #0xff
	strb r1, [r0, #0x4]
	ldr r1, _02039870 ; =0x0000FFFF
	add sp, #0x24
	strh r1, [r0, #0x0]
	strh r1, [r0, #0x2]
	pop {r4-r7, pc}
_020397A0:
	ldr r0, [sp, #0x0]
	ldr r0, [r0, #0x38]
	bl FUN_02055320
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x0]
	ldr r0, [r0, #0x38]
	bl FUN_0205532C
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	sub r0, r0, #0x7
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x18]
	add r0, r0, #0x7
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x14]
	sub r0, r0, #0x7
	str r0, [sp, #0x8]
	ldr r0, [sp, #0x14]
	add r0, r0, #0x6
	str r0, [sp, #0x4]
	ldr r0, [sp, #0x10]
	cmp r0, #0x0
	bge _020397D6
	add r0, r6, #0x0
	str r0, [sp, #0x10]
_020397D6:
	ldr r0, [sp, #0x8]
	cmp r0, #0x0
	bge _020397E0
	mov r0, #0x0
	str r0, [sp, #0x8]
_020397E0:
	add r0, r5, #0x1
	mov r7, #0x0
	str r0, [sp, #0x20]
	cmp r0, #0x0
	ble _02039856
	ldr r5, [sp, #0x1c]
_020397EC:
	ldrh r0, [r4, #0x2]
	cmp r0, #0x2
	bne _0203984C
	ldrh r0, [r4, #0x0]
	bl FUN_02039694
	add r1, r0, #0x0
	ldr r0, [sp, #0x0]
	bl FlagCheck
	cmp r0, #0x0
	bne _0203984C
	ldr r1, [r4, #0x4]
	ldr r0, [sp, #0x10]
	cmp r1, r0
	blt _0203984C
	ldr r0, [sp, #0xc]
	cmp r1, r0
	bgt _0203984C
	ldr r1, [r4, #0x8]
	ldr r0, [sp, #0x8]
	cmp r1, r0
	blt _0203984C
	ldr r0, [sp, #0x4]
	cmp r1, r0
	bgt _0203984C
	ldrh r0, [r4, #0x0]
	bl FUN_020396B0
	strb r0, [r5, #0x4]
	ldr r1, [r4, #0x4]
	ldr r0, [sp, #0x18]
	sub r1, r0, r1
	mov r0, #0x7
	sub r0, r0, r1
	bl abs
	strh r0, [r5, #0x0]
	ldr r1, [r4, #0x8]
	ldr r0, [sp, #0x14]
	sub r1, r0, r1
	mov r0, #0x7
	sub r0, r0, r1
	bl abs
	strh r0, [r5, #0x2]
	add r5, r5, #0x6
	add r6, r6, #0x1
_0203984C:
	ldr r0, [sp, #0x20]
	add r7, r7, #0x1
	add r4, #0x14
	cmp r7, r0
	blt _020397EC
_02039856:
	mov r0, #0x6
	add r3, r6, #0x0
	mul r3, r0
	ldr r0, [sp, #0x1c]
	mov r1, #0xff
	add r2, r0, r3
	strb r1, [r2, #0x4]
	ldr r1, _02039870 ; =0x0000FFFF
	strh r1, [r0, r3]
	strh r1, [r2, #0x2]
	add sp, #0x24
	pop {r4-r7, pc}
	nop
_02039870: .word 0x0000FFFF

	thumb_func_start RunPokemonCenterScriptsInNewContext
RunPokemonCenterScriptsInNewContext: ; 0x02039874
	ldr r3, _0203987C ; =RunScriptInNewContext
	mov r1, #0x96
	lsl r1, r1, #0x6
	bx r3
	.balign 4
_0203987C: .word RunScriptInNewContext

	thumb_func_start RunScriptInNewContext
RunScriptInNewContext: ; 0x02039880
	push {r4, lr}
	bl CreateScriptContext
	add r4, r0, #0x0
_02039888:
	add r0, r4, #0x0
	bl RunScriptCommand
	cmp r0, #0x1
	beq _02039888
	add r0, r4, #0x0
	bl DeleteScriptContext
	pop {r4, pc}
	.balign 4

	thumb_func_start FUN_0203989C
FUN_0203989C: ; 0x0203989C
	push {r3-r5, lr}
	add r5, r0, #0x0
	add r4, r1, #0x0
	bl FUN_02034D2C
	add r1, r0, #0x0
	bne _020398AE
	mov r0, #0x0
	pop {r3-r5, pc}
_020398AE:
	cmp r4, #0x1
	bne _020398BC
	add r0, r5, #0x0
	add r2, r4, #0x0
	bl FUN_02039914
	b _020398C2
_020398BC:
	add r1, r4, #0x0
	bl _020398EC
_020398C2:
	add r1, r0, #0x0
	ldr r0, _020398E8 ; =0x0000FFFF
	cmp r1, r0
	bne _020398CE
	mov r0, #0x0
	pop {r3-r5, pc}
_020398CE:
	cmp r4, #0x1
	bne _020398DC
	add r0, r5, #0x0
	mov r2, #0x0
	bl FUN_02038C78
	b _020398E2
_020398DC:
	add r0, r5, #0x0
	bl RunScriptInNewContext
_020398E2:
	mov r0, #0x1
	pop {r3-r5, pc}
	nop
_020398E8: .word 0x0000FFFF
_020398EC:
	ldrb r2, [r0, #0x0]
	cmp r2, #0x0
	bne _020398F6
	ldr r0, _02039910 ; =0x0000FFFF
	bx lr
_020398F6:
	cmp r2, r1
	bne _02039908
	ldrb r1, [r0, #0x1]
	ldrb r0, [r0, #0x2]
	lsl r0, r0, #0x8
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
_02039908:
	add r0, r0, #0x5
	b _020398EC
_0203990C: ; 0x0203990C
	bx lr
	nop
_02039910: .word 0x0000FFFF

	thumb_func_start FUN_02039914
FUN_02039914: ; 0x02039914
	push {r3-r7, lr}
	add r5, r0, #0x0
	add r4, r1, #0x0
_0203991A:
	ldrb r0, [r4, #0x0]
	cmp r0, #0x0
	bne _02039924
	ldr r0, _0203999C ; =0x0000FFFF
	pop {r3-r7, pc}
_02039924:
	cmp r0, r2
	bne _02039940
	ldrb r0, [r4, #0x4]
	ldrb r2, [r4, #0x2]
	ldrb r3, [r4, #0x1]
	lsl r1, r0, #0x18
	ldrb r0, [r4, #0x3]
	lsl r2, r2, #0x8
	add r2, r3, r2
	lsl r0, r0, #0x10
	add r0, r0, r2
	add r1, r1, r0
	add r0, r4, #0x5
	b _02039944
_02039940:
	add r4, r4, #0x5
	b _0203991A
_02039944:
	cmp r1, #0x0
	bne _0203994C
	ldr r0, _0203999C ; =0x0000FFFF
	pop {r3-r7, pc}
_0203994C:
	add r4, r0, r1
_0203994E:
	ldrb r1, [r4, #0x0]
	cmp r1, #0x0
	bne _02039958
	ldr r0, _0203999C ; =0x0000FFFF
	pop {r3-r7, pc}
_02039958:
	ldrb r0, [r4, #0x1]
	lsl r0, r0, #0x8
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	bne _02039968
	ldr r0, _0203999C ; =0x0000FFFF
	pop {r3-r7, pc}
_02039968:
	ldrb r0, [r4, #0x3]
	ldrb r2, [r4, #0x2]
	lsl r0, r0, #0x8
	add r0, r2, r0
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	add r0, r5, #0x0
	bl VarGet
	add r7, r0, #0x0
	add r0, r5, #0x0
	add r1, r6, #0x0
	bl VarGet
	cmp r7, r0
	bne _02039996
	ldrb r0, [r4, #0x5]
	ldrb r1, [r4, #0x4]
	lsl r0, r0, #0x8
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	pop {r3-r7, pc}
_02039996:
	add r4, r4, #0x6
	b _0203994E
	pop {r3-r7, pc}
	.balign 4
_0203999C: .word 0x0000FFFF
