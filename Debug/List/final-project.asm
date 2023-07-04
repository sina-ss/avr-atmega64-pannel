
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _adc_result=R4
	.DEF _adc_result_msb=R5
	.DEF _numPredefinedUsers=R6
	.DEF _numPredefinedUsers_msb=R7
	.DEF _numRegisteredUsers=R8
	.DEF _numRegisteredUsers_msb=R9
	.DEF _bufferIndex=R10
	.DEF _bufferIndex_msb=R11
	.DEF _isRegistering=R12
	.DEF _isRegistering_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x4,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x75,0x73,0x65,0x72,0x31,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x70,0x61,0x73,0x73
	.DB  0x31,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x75,0x73,0x65,0x72,0x32,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x70,0x61,0x73,0x73
	.DB  0x32,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x75,0x73,0x65,0x72,0x33,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x70,0x61,0x73,0x73
	.DB  0x33,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x75,0x73,0x65,0x72,0x34,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x70,0x61,0x73,0x73
	.DB  0x34
_0x5:
	.DB  LOW(_0x4),HIGH(_0x4),LOW(_0x4+20),HIGH(_0x4+20),LOW(_0x4+38),HIGH(_0x4+38)
_0x6:
	.DB  0x3
_0x33:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x35:
	.DB  0x0,0x0,0x80,0xBF
_0x0:
	.DB  0x56,0x6F,0x6C,0x74,0x61,0x67,0x65,0x20
	.DB  0x6D,0x65,0x61,0x73,0x75,0x72,0x65,0x6D
	.DB  0x65,0x6E,0x74,0x0,0x53,0x65,0x74,0x74
	.DB  0x69,0x6E,0x67,0x20,0x74,0x68,0x65,0x20
	.DB  0x63,0x6C,0x6F,0x63,0x6B,0x0,0x41,0x75
	.DB  0x74,0x6F,0x6D,0x61,0x74,0x69,0x63,0x20
	.DB  0x73,0x68,0x75,0x74,0x64,0x6F,0x77,0x6E
	.DB  0x0,0xA,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x50,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
	.DB  0x3A,0x20,0x0,0xA,0x4E,0x65,0x77,0x20
	.DB  0x50,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
	.DB  0x3A,0x20,0x0,0xA,0x4C,0x6F,0x67,0x69
	.DB  0x6E,0x20,0x53,0x75,0x63,0x63,0x65,0x73
	.DB  0x73,0x66,0x75,0x6C,0x21,0xA,0x0,0xA
	.DB  0x4C,0x6F,0x67,0x69,0x6E,0x20,0x46,0x61
	.DB  0x69,0x6C,0x65,0x64,0x21,0xA,0x0,0xA
	.DB  0x43,0x6F,0x6E,0x66,0x69,0x72,0x6D,0x20
	.DB  0x50,0x61,0x73,0x73,0x77,0x6F,0x72,0x64
	.DB  0x3A,0x20,0x0,0xA,0x52,0x65,0x67,0x69
	.DB  0x73,0x74,0x72,0x61,0x74,0x69,0x6F,0x6E
	.DB  0x20,0x53,0x75,0x63,0x63,0x65,0x73,0x73
	.DB  0x66,0x75,0x6C,0x21,0xA,0x0,0xA,0x52
	.DB  0x65,0x67,0x69,0x73,0x74,0x72,0x61,0x74
	.DB  0x69,0x6F,0x6E,0x20,0x46,0x61,0x69,0x6C
	.DB  0x65,0x64,0x21,0xA,0x0,0x56,0x6F,0x6C
	.DB  0x74,0x61,0x67,0x65,0x3A,0x20,0x25,0x2E
	.DB  0x32,0x66,0x56,0x0,0xA,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x74,0x69,0x6D,0x65,0x20
	.DB  0x28,0x48,0x48,0x3A,0x4D,0x4D,0x3A,0x53
	.DB  0x53,0x29,0x3A,0x20,0x0,0x25,0x64,0x3A
	.DB  0x25,0x64,0x3A,0x25,0x64,0x0,0x54,0x69
	.DB  0x6D,0x65,0x3A,0x20,0x25,0x30,0x32,0x64
	.DB  0x3A,0x25,0x30,0x32,0x64,0x3A,0x25,0x30
	.DB  0x32,0x64,0x0,0xA,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x73,0x68,0x75,0x74,0x64,0x6F
	.DB  0x77,0x6E,0x20,0x64,0x75,0x72,0x61,0x74
	.DB  0x69,0x6F,0x6E,0x20,0x28,0x4D,0x4D,0x3A
	.DB  0x53,0x53,0x29,0x3A,0x20,0x0,0x53,0x68
	.DB  0x75,0x74,0x64,0x6F,0x77,0x6E,0x20,0x69
	.DB  0x6E,0x20,0x25,0x30,0x32,0x64,0x3A,0x25
	.DB  0x30,0x32,0x64,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x55,0x73,0x65,0x72,0x6E,0x61
	.DB  0x6D,0x65,0x3A,0x20,0x0,0x4D,0x65,0x6E
	.DB  0x75,0x3A,0x20,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x91
	.DW  _predefinedUsers
	.DW  _0x3*2

	.DW  0x14
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x12
	.DW  _0x4+20
	.DW  _0x0*2+20

	.DW  0x13
	.DW  _0x4+38
	.DW  _0x0*2+38

	.DW  0x06
	.DW  _menuOptions
	.DW  _0x5*2

	.DW  0x01
	.DW  _numMenuOptions
	.DW  _0x6*2

	.DW  0x12
	.DW  _0x11
	.DW  _0x0*2+57

	.DW  0x12
	.DW  _0x11+18
	.DW  _0x0*2+57

	.DW  0x10
	.DW  _0x11+36
	.DW  _0x0*2+75

	.DW  0x14
	.DW  _0x1D
	.DW  _0x0*2+91

	.DW  0x14
	.DW  _0x1D+20
	.DW  _0x0*2+91

	.DW  0x10
	.DW  _0x1D+40
	.DW  _0x0*2+111

	.DW  0x14
	.DW  _0x27
	.DW  _0x0*2+127

	.DW  0x1B
	.DW  _0x29
	.DW  _0x0*2+147

	.DW  0x17
	.DW  _0x29+27
	.DW  _0x0*2+174

	.DW  0x04
	.DW  _lastVoltage_S0000007000
	.DW  _0x35*2

	.DW  0x19
	.DW  _0x3A
	.DW  _0x0*2+212

	.DW  0x02
	.DW  _0x3A+25
	.DW  _0x0*2+109

	.DW  0x23
	.DW  _0x3E
	.DW  _0x0*2+267

	.DW  0x11
	.DW  _0x54
	.DW  _0x0*2+324

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <alcd.h>
;
;#define LED1 PORTD.0
;#define LED2 PORTD.1
;#define KEY_PORT PORTD.2
;#define VOLTAGE_PIN ADC0
;#define BUZZER PORTD.3
;#define SHUTDOWN_MINUTE 5
;
;// ADC conversion result
;unsigned int adc_result;
;
;// Time struct
;typedef struct
;{
;    int hours;
;    int minutes;
;    int seconds;
;} Time;
;
;typedef struct
;{
;    char username[20];
;    char password[20];
;} User;
;
;User predefinedUsers[] = { {"user1", "pass1"}, {"user2", "pass2"}, {"user3", "pass3"}, {"user4", "pass4"} };

	.DSEG
;User registeredUsers[10];  // Limit new users to 10
;int numPredefinedUsers = sizeof(predefinedUsers) / sizeof(User);
;int numRegisteredUsers = 0;
;
;char inputBuffer[20];
;int bufferIndex = 0;
;char tempPassword[20];
;
;char loggedUser[20];
;int isRegistering = 0;
;
;Time currentTime = {0, 0, 0};
;Time shutdownTime = {0, 0, 0};
;
;// Menu options
;char* menuOptions[] = {"Voltage measurement", "Setting the clock", "Automatic shutdown"};
_0x4:
	.BYTE 0x39
;int numMenuOptions = sizeof(menuOptions) / sizeof(char*);
;
;// Menu state
;int isMenuOpen = 0;
;int menuSelection = 0;
;float voltage;
;char voltageStr[20];
;char timeBuffer[10];
;char c; //read until new line for clock
;// Display the time on LCD
;char lcdBuffer[20];
;// Display the remaining time on LCD
;char lcdBuffer[20];
;//Diration for shutdown
;char durationBuffer[10];
;int i = 0; //counter for for :)
;
;void send_string(char *str)
; 0000 0043 {

	.CSEG
_send_string:
; .FSTART _send_string
; 0000 0044     while (*str != 0)
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x7:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x9
; 0000 0045     {
; 0000 0046         while ((UCSR0A & (1 << UDRE0)) == 0);
_0xA:
	SBIS 0xB,5
	RJMP _0xA
; 0000 0047         UDR0 = *str;
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	OUT  0xC,R30
; 0000 0048         str++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0049     }
	RJMP _0x7
_0x9:
; 0000 004A }
	ADIW R28,2
	RET
; .FEND
;
;void check_user()
; 0000 004D {
_check_user:
; .FSTART _check_user
; 0000 004E     int i;
; 0000 004F     for (i = 0; i < numPredefinedUsers; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0xE:
	__CPWRR 16,17,6,7
	BRGE _0xF
; 0000 0050     {
; 0000 0051         if (strcmp(predefinedUsers[i].username, inputBuffer) == 0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRNE _0x10
; 0000 0052         {
; 0000 0053             send_string("\nEnter Password: ");
	__POINTW2MN _0x11,0
	RCALL _send_string
; 0000 0054             return;
	RJMP _0x20C000A
; 0000 0055         }
; 0000 0056     }
_0x10:
	__ADDWRN 16,17,1
	RJMP _0xE
_0xF:
; 0000 0057     for (i = 0; i < numRegisteredUsers; i++)
	__GETWRN 16,17,0
_0x13:
	__CPWRR 16,17,8,9
	BRGE _0x14
; 0000 0058     {
; 0000 0059         if (strcmp(registeredUsers[i].username, inputBuffer) == 0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL _strcmp
	CPI  R30,0
	BRNE _0x15
; 0000 005A         {
; 0000 005B             send_string("\nEnter Password: ");
	__POINTW2MN _0x11,18
	RCALL _send_string
; 0000 005C             return;
	RJMP _0x20C000A
; 0000 005D         }
; 0000 005E     }
_0x15:
	__ADDWRN 16,17,1
	RJMP _0x13
_0x14:
; 0000 005F     // If username not found, register new user
; 0000 0060     isRegistering = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0061     strcpy(registeredUsers[numRegisteredUsers].username, inputBuffer);
	MOVW R30,R8
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	CALL __MULW12U
	CALL SUBOPT_0x2
	CALL _strcpy
; 0000 0062     send_string("\nNew Password: ");
	__POINTW2MN _0x11,36
	RCALL _send_string
; 0000 0063 }
	RJMP _0x20C000A
; .FEND

	.DSEG
_0x11:
	.BYTE 0x34
;
;void check_password()
; 0000 0066 {

	.CSEG
_check_password:
; .FSTART _check_password
; 0000 0067     int i;
; 0000 0068     for (i = 0; i < numPredefinedUsers; i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x17:
	__CPWRR 16,17,6,7
	BRGE _0x18
; 0000 0069     {
; 0000 006A         if (strcmp(predefinedUsers[i].username, inputBuffer) == 0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRNE _0x19
; 0000 006B         {
; 0000 006C             if (strcmp(predefinedUsers[i].password, tempPassword) == 0)
	CALL SUBOPT_0x0
	__ADDW1MN _predefinedUsers,20
	CALL SUBOPT_0x3
	BRNE _0x1A
; 0000 006D             {
; 0000 006E                 strcpy(loggedUser, predefinedUsers[i].username);
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_predefinedUsers)
	SBCI R31,HIGH(-_predefinedUsers)
	MOVW R26,R30
	CALL _strcpy
; 0000 006F                 LED2 = 1; // Turn on the LED2
	SBI  0x12,1
; 0000 0070                 send_string("\nLogin Successful!\n");
	__POINTW2MN _0x1D,0
	RCALL _send_string
; 0000 0071                 return;
	RJMP _0x20C000A
; 0000 0072             }
; 0000 0073         }
_0x1A:
; 0000 0074     }
_0x19:
	__ADDWRN 16,17,1
	RJMP _0x17
_0x18:
; 0000 0075     for (i = 0; i < numRegisteredUsers; i++)
	__GETWRN 16,17,0
_0x1F:
	__CPWRR 16,17,8,9
	BRGE _0x20
; 0000 0076     {
; 0000 0077         if (strcmp(registeredUsers[i].username, inputBuffer) == 0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL _strcmp
	CPI  R30,0
	BRNE _0x21
; 0000 0078         {
; 0000 0079             if (strcmp(registeredUsers[i].password, tempPassword) == 0)
	CALL SUBOPT_0x0
	__ADDW1MN _registeredUsers,20
	CALL SUBOPT_0x3
	BRNE _0x22
; 0000 007A             {
; 0000 007B                 strcpy(loggedUser, registeredUsers[i].username);
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_registeredUsers)
	SBCI R31,HIGH(-_registeredUsers)
	MOVW R26,R30
	CALL _strcpy
; 0000 007C                 LED2 = 1; // Turn on the LED2
	SBI  0x12,1
; 0000 007D                 send_string("\nLogin Successful!\n");
	__POINTW2MN _0x1D,20
	RCALL _send_string
; 0000 007E                 return;
	RJMP _0x20C000A
; 0000 007F             }
; 0000 0080         }
_0x22:
; 0000 0081     }
_0x21:
	__ADDWRN 16,17,1
	RJMP _0x1F
_0x20:
; 0000 0082     send_string("\nLogin Failed!\n");
	__POINTW2MN _0x1D,40
	RCALL _send_string
; 0000 0083     LED2 = 0; // Turn off the LED2
	CBI  0x12,1
; 0000 0084 }
_0x20C000A:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x1D:
	.BYTE 0x38
;
;void check_new_password()
; 0000 0087 {

	.CSEG
_check_new_password:
; .FSTART _check_new_password
; 0000 0088     strcpy(tempPassword, inputBuffer);
	CALL SUBOPT_0x5
	CALL _strcpy
; 0000 0089     send_string("\nConfirm Password: ");
	__POINTW2MN _0x27,0
	RCALL _send_string
; 0000 008A }
	RET
; .FEND

	.DSEG
_0x27:
	.BYTE 0x14
;
;void check_confirm_password()
; 0000 008D {

	.CSEG
_check_confirm_password:
; .FSTART _check_confirm_password
; 0000 008E     if (strcmp(tempPassword, inputBuffer) == 0)
	CALL SUBOPT_0x5
	CALL _strcmp
	CPI  R30,0
	BRNE _0x28
; 0000 008F     {
; 0000 0090         strcpy(registeredUsers[numRegisteredUsers].password, tempPassword);
	MOVW R30,R8
	LDI  R26,LOW(40)
	LDI  R27,HIGH(40)
	CALL __MULW12U
	__ADDW1MN _registeredUsers,20
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_tempPassword)
	LDI  R27,HIGH(_tempPassword)
	CALL _strcpy
; 0000 0091         numRegisteredUsers++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0092         send_string("\nRegistration Successful!\n");
	__POINTW2MN _0x29,0
	RJMP _0x63
; 0000 0093     }
; 0000 0094     else
_0x28:
; 0000 0095     {
; 0000 0096         send_string("\nRegistration Failed!\n");
	__POINTW2MN _0x29,27
_0x63:
	RCALL _send_string
; 0000 0097     }
; 0000 0098     isRegistering = 0;
	CLR  R12
	CLR  R13
; 0000 0099 }
	RET
; .FEND

	.DSEG
_0x29:
	.BYTE 0x32
;
;interrupt [USART0_RXC] void usart_rx_isr(void)
; 0000 009C {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009D     char data = UDR0;
; 0000 009E     if (data == '\n')
	ST   -Y,R17
;	data -> R17
	IN   R17,12
	CPI  R17,10
	BRNE _0x2B
; 0000 009F     {
; 0000 00A0         inputBuffer[bufferIndex] = '\0'; // Null-terminate the received string
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
	ADD  R26,R10
	ADC  R27,R11
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00A1         if (loggedUser[0] == '\0')
	LDS  R30,_loggedUser
	CPI  R30,0
	BRNE _0x2C
; 0000 00A2         {
; 0000 00A3             if (isRegistering == 0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x2D
; 0000 00A4             {
; 0000 00A5                 check_user();
	RCALL _check_user
; 0000 00A6             }
; 0000 00A7             else if (isRegistering == 1)
	RJMP _0x2E
_0x2D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x2F
; 0000 00A8             {
; 0000 00A9                 check_new_password();
	RCALL _check_new_password
; 0000 00AA                 isRegistering++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00AB             }
; 0000 00AC             else
	RJMP _0x30
_0x2F:
; 0000 00AD             {
; 0000 00AE                 check_confirm_password();
	RCALL _check_confirm_password
; 0000 00AF             }
_0x30:
_0x2E:
; 0000 00B0         }
; 0000 00B1         else
	RJMP _0x31
_0x2C:
; 0000 00B2         {
; 0000 00B3             check_password();
	RCALL _check_password
; 0000 00B4         }
_0x31:
; 0000 00B5         bufferIndex = 0;
	CLR  R10
	CLR  R11
; 0000 00B6     }
; 0000 00B7     else
	RJMP _0x32
_0x2B:
; 0000 00B8     {
; 0000 00B9         inputBuffer[bufferIndex] = data;
	MOVW R30,R10
	SUBI R30,LOW(-_inputBuffer)
	SBCI R31,HIGH(-_inputBuffer)
	ST   Z,R17
; 0000 00BA         bufferIndex++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00BB     }
_0x32:
; 0000 00BC }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;unsigned char get7SegmentCode(unsigned char digit)
; 0000 00BF {
_get7SegmentCode:
; .FSTART _get7SegmentCode
; 0000 00C0     unsigned char segmentCodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};
; 0000 00C1     if (digit < 10)
	ST   -Y,R26
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x33*2)
	LDI  R31,HIGH(_0x33*2)
	CALL __INITLOCB
;	digit -> Y+10
;	segmentCodes -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0xA)
	BRSH _0x34
; 0000 00C2         return segmentCodes[digit];
	LDD  R30,Y+10
	LDI  R31,0
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP _0x20C0009
; 0000 00C3     return 0;
_0x34:
	LDI  R30,LOW(0)
_0x20C0009:
	ADIW R28,11
	RET
; 0000 00C4 }
; .FEND
;
;void display_on_7segment(float voltage)
; 0000 00C7 {
_display_on_7segment:
; .FSTART _display_on_7segment
; 0000 00C8     static unsigned char digitIndex = 0;
; 0000 00C9     static unsigned int digitCodes[4] = {0};
; 0000 00CA 
; 0000 00CB     // Calculate digit codes once when voltage changes
; 0000 00CC     static float lastVoltage = -1.0f;

	.DSEG

	.CSEG
; 0000 00CD     if (voltage != lastVoltage)
	CALL __PUTPARD2
;	voltage -> Y+0
	LDS  R30,_lastVoltage_S0000007000
	LDS  R31,_lastVoltage_S0000007000+1
	LDS  R22,_lastVoltage_S0000007000+2
	LDS  R23,_lastVoltage_S0000007000+3
	CALL __GETD2S0
	CALL __CPD12
	BRNE PC+2
	RJMP _0x36
; 0000 00CE     {
; 0000 00CF         int intVoltage = (int)(voltage * 100);  // Convert to integer to avoid floating point division
; 0000 00D0         digitCodes[0] = get7SegmentCode(intVoltage / 1000);  // Thousands
	SBIW R28,2
;	voltage -> Y+2
;	intVoltage -> Y+0
	__GETD2S 2
	__GETD1N 0x42C80000
	CALL __MULF12
	CALL __CFD1
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x6
	LDI  R31,0
	STS  _digitCodes_S0000007000,R30
	STS  _digitCodes_S0000007000+1,R31
; 0000 00D1         digitCodes[1] = get7SegmentCode((intVoltage % 1000) / 100);  // Hundreds
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6
	__POINTW2MN _digitCodes_S0000007000,2
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00D2         digitCodes[2] = get7SegmentCode((intVoltage % 100) / 10);  // Tens
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x6
	__POINTW2MN _digitCodes_S0000007000,4
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00D3         digitCodes[3] = get7SegmentCode(intVoltage % 10);  // Ones
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R26,R30
	RCALL _get7SegmentCode
	__POINTW2MN _digitCodes_S0000007000,6
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00D4         lastVoltage = voltage;
	__GETD1S 2
	STS  _lastVoltage_S0000007000,R30
	STS  _lastVoltage_S0000007000+1,R31
	STS  _lastVoltage_S0000007000+2,R22
	STS  _lastVoltage_S0000007000+3,R23
; 0000 00D5     }
	ADIW R28,2
; 0000 00D6 
; 0000 00D7     // Turn off all digits
; 0000 00D8     PORTA = 0;
_0x36:
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00D9 
; 0000 00DA     // Set segments
; 0000 00DB     PORTA = digitCodes[digitIndex];
	LDS  R30,_digitIndex_S0000007000
	LDI  R26,LOW(_digitCodes_S0000007000)
	LDI  R27,HIGH(_digitCodes_S0000007000)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x1B,R30
; 0000 00DC 
; 0000 00DD     // Turn on the current digit
; 0000 00DE     PORTA |= (1 << (digitIndex + 4));
	IN   R1,27
	LDS  R30,_digitIndex_S0000007000
	SUBI R30,-LOW(4)
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x1B,R30
; 0000 00DF 
; 0000 00E0     // Go to the next digit
; 0000 00E1     digitIndex = (digitIndex + 1) % 4;
	LDS  R30,_digitIndex_S0000007000
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	STS  _digitIndex_S0000007000,R30
; 0000 00E2 }
	JMP  _0x20C0003
; .FEND
;
;void measure_voltage()
; 0000 00E5 {
_measure_voltage:
; .FSTART _measure_voltage
; 0000 00E6     // Start the ADC conversion
; 0000 00E7     ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 00E8 
; 0000 00E9     // Wait for conversion to complete
; 0000 00EA     while (ADCSRA & (1 << ADSC));
_0x37:
	SBIC 0x6,6
	RJMP _0x37
; 0000 00EB 
; 0000 00EC     // Get the result
; 0000 00ED     adc_result = ADCL | (ADCH << 8);
	IN   R30,0x4
	MOV  R26,R30
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	OR   R30,R26
	MOVW R4,R30
; 0000 00EE 
; 0000 00EF     // Display the voltage on the 7-segment display and LCD
; 0000 00F0     voltage = (adc_result / 1024.0) * 5;
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44800000
	CALL __DIVF21
	__GETD2N 0x40A00000
	CALL __MULF12
	STS  _voltage,R30
	STS  _voltage+1,R31
	STS  _voltage+2,R22
	STS  _voltage+3,R23
; 0000 00F1     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x7
; 0000 00F2     sprintf(voltageStr, "Voltage: %.2fV", voltage);
	LDI  R30,LOW(_voltageStr)
	LDI  R31,HIGH(_voltageStr)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,197
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_voltage
	LDS  R31,_voltage+1
	LDS  R22,_voltage+2
	LDS  R23,_voltage+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00F3     lcd_puts(voltageStr);
	LDI  R26,LOW(_voltageStr)
	LDI  R27,HIGH(_voltageStr)
	CALL _lcd_puts
; 0000 00F4 
; 0000 00F5 
; 0000 00F6     // Assuming you have a function to display numbers on 7-segment
; 0000 00F7     display_on_7segment(voltage);
	LDS  R26,_voltage
	LDS  R27,_voltage+1
	LDS  R24,_voltage+2
	LDS  R25,_voltage+3
	RCALL _display_on_7segment
; 0000 00F8 }
	RET
; .FEND
;
;void set_clock()
; 0000 00FB {
_set_clock:
; .FSTART _set_clock
; 0000 00FC     // Ask the user to input time
; 0000 00FD     send_string("\nEnter time (HH:MM:SS): ");
	__POINTW2MN _0x3A,0
	RCALL _send_string
; 0000 00FE     while (c = UDR0, c != '\n') // read until newline
_0x3B:
	CALL SUBOPT_0x8
	BREQ _0x3D
; 0000 00FF     {
; 0000 0100         strncat(timeBuffer, &c, 1);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0101     }
	RJMP _0x3B
_0x3D:
; 0000 0102     // Remove newline character from fgets
; 0000 0103     timeBuffer[strcspn(timeBuffer, "\n")] = 0;
	CALL SUBOPT_0x9
	__POINTW2MN _0x3A,25
	CALL _strcspn
	SUBI R30,LOW(-_timeBuffer)
	SBCI R31,HIGH(-_timeBuffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0104 
; 0000 0105     sscanf(timeBuffer, "%d:%d:%d", &currentTime.hours, &currentTime.minutes, &currentTime.seconds);
	CALL SUBOPT_0x9
	__POINTW1FN _0x0,237
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_currentTime)
	LDI  R31,HIGH(_currentTime)
	CALL SUBOPT_0xB
	__POINTW1MN _currentTime,2
	CALL SUBOPT_0xB
	__POINTW1MN _currentTime,4
	CALL SUBOPT_0xB
	LDI  R24,12
	CALL _sscanf
	ADIW R28,16
; 0000 0106 
; 0000 0107     // Display the time on LCD
; 0000 0108     sprintf(lcdBuffer, "Time: %02d:%02d:%02d", currentTime.hours, currentTime.minutes, currentTime.seconds);
	LDI  R30,LOW(_lcdBuffer)
	LDI  R31,HIGH(_lcdBuffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,246
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_currentTime
	LDS  R31,_currentTime+1
	CALL SUBOPT_0xC
	__GETW1MN _currentTime,2
	CALL SUBOPT_0xC
	__GETW1MN _currentTime,4
	CALL SUBOPT_0xC
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0109     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x7
; 0000 010A     lcd_puts(lcdBuffer);
	LDI  R26,LOW(_lcdBuffer)
	LDI  R27,HIGH(_lcdBuffer)
	CALL _lcd_puts
; 0000 010B }
	RET
; .FEND

	.DSEG
_0x3A:
	.BYTE 0x1B
;
;void auto_shutdown()
; 0000 010E {

	.CSEG
_auto_shutdown:
; .FSTART _auto_shutdown
; 0000 010F     // Ask the user to input shutdown duration
; 0000 0110     send_string("\nEnter shutdown duration (MM:SS): ");
	__POINTW2MN _0x3E,0
	RCALL _send_string
; 0000 0111     while (c = UDR0, c != '\n') // read until newline
_0x3F:
	CALL SUBOPT_0x8
	BREQ _0x41
; 0000 0112     {
; 0000 0113         strncat(durationBuffer, &c, 1);
	LDI  R30,LOW(_durationBuffer)
	LDI  R31,HIGH(_durationBuffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
; 0000 0114     }
	RJMP _0x3F
_0x41:
; 0000 0115     sscanf(durationBuffer, "%d:%d", &shutdownTime.minutes, &shutdownTime.seconds);
	LDI  R30,LOW(_durationBuffer)
	LDI  R31,HIGH(_durationBuffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,240
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _shutdownTime,2
	CALL SUBOPT_0xB
	__POINTW1MN _shutdownTime,4
	CALL SUBOPT_0xB
	LDI  R24,8
	CALL _sscanf
	ADIW R28,12
; 0000 0116 
; 0000 0117     // Start a countdown
; 0000 0118     while (shutdownTime.minutes != 0 || shutdownTime.seconds != 0)
_0x42:
	__GETW2MN _shutdownTime,2
	SBIW R26,0
	BRNE _0x45
	__GETW2MN _shutdownTime,4
	SBIW R26,0
	BRNE _0x45
	RJMP _0x44
_0x45:
; 0000 0119     {
; 0000 011A         // Decrement the time
; 0000 011B         if (--shutdownTime.seconds < 0)
	__POINTW2MN _shutdownTime,4
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	TST  R31
	BRPL _0x47
; 0000 011C         {
; 0000 011D             shutdownTime.seconds = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1MN _shutdownTime,4
; 0000 011E             shutdownTime.minutes--;
	__POINTW2MN _shutdownTime,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 011F         }
; 0000 0120 
; 0000 0121         // Display the remaining time on LCD
; 0000 0122         sprintf(lcdBuffer, "Shutdown in %02d:%02d", shutdownTime.minutes, shutdownTime.seconds);
_0x47:
	LDI  R30,LOW(_lcdBuffer)
	LDI  R31,HIGH(_lcdBuffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,302
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _shutdownTime,2
	CALL SUBOPT_0xC
	__GETW1MN _shutdownTime,4
	CALL SUBOPT_0xC
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0123         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x7
; 0000 0124         lcd_puts(lcdBuffer);
	LDI  R26,LOW(_lcdBuffer)
	LDI  R27,HIGH(_lcdBuffer)
	CALL _lcd_puts
; 0000 0125 
; 0000 0126         // Beep the buzzer when there is 1 minute left
; 0000 0127         if (shutdownTime.minutes == 1 && shutdownTime.seconds == 0)
	__GETW2MN _shutdownTime,2
	SBIW R26,1
	BRNE _0x49
	__GETW2MN _shutdownTime,4
	SBIW R26,0
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 0128         {
; 0000 0129             PORTD |= (1 << BUZZER);
	CALL SUBOPT_0xD
	OR   R30,R1
	OUT  0x12,R30
; 0000 012A         }
; 0000 012B 
; 0000 012C         // Delay for a second
; 0000 012D         for(i = 0; i < 1000; i++)
_0x48:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x4C:
	LDS  R26,_i
	LDS  R27,_i+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRGE _0x4D
; 0000 012E             delay_ms(1); // Using delay_ms() in a loop
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL SUBOPT_0xE
	RJMP _0x4C
_0x4D:
; 0000 012F }
	RJMP _0x42
_0x44:
; 0000 0130 
; 0000 0131     // Shutdown the system
; 0000 0132     PORTD &= ~(1 << LED1);
	IN   R1,18
	LDI  R30,0
	SBIC 0x12,0
	LDI  R30,1
	CALL SUBOPT_0xF
; 0000 0133     PORTD &= ~(1 << LED2);
	IN   R1,18
	LDI  R30,0
	SBIC 0x12,1
	LDI  R30,1
	CALL SUBOPT_0xF
; 0000 0134     PORTD &= ~(1 << BUZZER);
	CALL SUBOPT_0xD
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
; 0000 0135     lcd_clear();
	CALL _lcd_clear
; 0000 0136     PORTA = 0; // Turn off 7-segment
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0137 }
	RET
; .FEND

	.DSEG
_0x3E:
	.BYTE 0x23
;
;void main(void)
; 0000 013A {

	.CSEG
_main:
; .FSTART _main
; 0000 013B     // Port D is output for LEDs
; 0000 013C     DDRD.0 = 1;
	SBI  0x11,0
; 0000 013D     DDRD.1 = 1;
	SBI  0x11,1
; 0000 013E 
; 0000 013F     // Turn on the LED1
; 0000 0140     LED1 = 1;
	SBI  0x12,0
; 0000 0141 
; 0000 0142     // Initialize USART
; 0000 0143     UCSR0A = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0144     UCSR0B = 0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0145     UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0146     UBRR0L = 51; // for 9600 bps with 8MHz clock
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0147 
; 0000 0148     // Enable Global Interrupts
; 0000 0149     #asm("sei")
	sei
; 0000 014A 
; 0000 014B     send_string("Enter Username: ");
	__POINTW2MN _0x54,0
	RCALL _send_string
; 0000 014C 
; 0000 014D     while (1)
_0x55:
; 0000 014E     {
; 0000 014F         if (isMenuOpen == 1)
	LDS  R26,_isMenuOpen
	LDS  R27,_isMenuOpen+1
	SBIW R26,1
	BRNE _0x58
; 0000 0150         {
; 0000 0151             // Display the menu on LCD
; 0000 0152             lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0153             lcd_putsf("Menu: ");
	__POINTW2FN _0x0,341
	CALL _lcd_putsf
; 0000 0154             lcd_gotoxy(0, 1);
	CALL SUBOPT_0x7
; 0000 0155             lcd_puts(menuOptions[menuSelection]);
	LDS  R30,_menuSelection
	LDS  R31,_menuSelection+1
	LDI  R26,LOW(_menuOptions)
	LDI  R27,HIGH(_menuOptions)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	CALL _lcd_puts
; 0000 0156 
; 0000 0157             // Display selection on 7-segment
; 0000 0158             PORTA = menuSelection + 1;
	LDS  R30,_menuSelection
	SUBI R30,-LOW(1)
	OUT  0x1B,R30
; 0000 0159 
; 0000 015A             // Implement switch case for menu selections
; 0000 015B             switch (menuSelection)
	LDS  R30,_menuSelection
	LDS  R31,_menuSelection+1
; 0000 015C             {
; 0000 015D                 case 0:
	SBIW R30,0
	BRNE _0x5C
; 0000 015E                     measure_voltage();
	RCALL _measure_voltage
; 0000 015F                     break;
	RJMP _0x5B
; 0000 0160                 case 1:
_0x5C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0161                     set_clock();
	RCALL _set_clock
; 0000 0162                     break;
	RJMP _0x5B
; 0000 0163                 case 2:
_0x5D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5B
; 0000 0164                     auto_shutdown();
	RCALL _auto_shutdown
; 0000 0165                     break;
; 0000 0166             }
_0x5B:
; 0000 0167         }
; 0000 0168 
; 0000 0169         if (PIND & (1 << KEY_PORT))
_0x58:
	IN   R1,16
	LDI  R30,0
	SBIC 0x12,2
	LDI  R30,1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x5F
; 0000 016A         {
; 0000 016B             // Menu button is pressed
; 0000 016C             if (isMenuOpen == 0)
	LDS  R30,_isMenuOpen
	LDS  R31,_isMenuOpen+1
	SBIW R30,0
	BRNE _0x60
; 0000 016D             {
; 0000 016E                 // Open the menu
; 0000 016F                 isMenuOpen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _isMenuOpen,R30
	STS  _isMenuOpen+1,R31
; 0000 0170                 menuSelection = 0; // Reset the menu selection
	LDI  R30,LOW(0)
	STS  _menuSelection,R30
	STS  _menuSelection+1,R30
; 0000 0171             }
; 0000 0172             else
	RJMP _0x61
_0x60:
; 0000 0173             {
; 0000 0174                 // Select the current menu item
; 0000 0175                 menuSelection = (menuSelection + 1) % numMenuOptions;
	LDS  R26,_menuSelection
	LDS  R27,_menuSelection+1
	ADIW R26,1
	LDS  R30,_numMenuOptions
	LDS  R31,_numMenuOptions+1
	CALL __MODW21
	STS  _menuSelection,R30
	STS  _menuSelection+1,R31
; 0000 0176 
; 0000 0177                 // Close the menu
; 0000 0178                 isMenuOpen = 0;
	LDI  R30,LOW(0)
	STS  _isMenuOpen,R30
	STS  _isMenuOpen+1,R30
; 0000 0179                 PORTA = 0; // Turn off 7-segment
	OUT  0x1B,R30
; 0000 017A             }
_0x61:
; 0000 017B         }
; 0000 017C     }
_0x5F:
	RJMP _0x55
; 0000 017D }
_0x62:
	RJMP _0x62
; .FEND

	.DSEG
_0x54:
	.BYTE 0x11
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0xE
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0xE
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0007
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x10
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x10
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0008
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x16
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_get_buff_G100:
; .FSTART _get_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007A
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x200007B
_0x200007A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x200007C
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007D
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL SUBOPT_0xE
_0x200007D:
	RJMP _0x200007E
_0x200007C:
	LDI  R17,LOW(0)
_0x200007E:
_0x200007B:
	MOV  R30,R17
	LDD  R17,Y+0
_0x20C0007:
	ADIW R28,5
	RET
; .FEND
__scanf_G100:
; .FSTART __scanf_G100
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x200007F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000081
	CALL SUBOPT_0x17
	BREQ _0x2000082
_0x2000083:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000086
	CALL SUBOPT_0x17
	BRNE _0x2000087
_0x2000086:
	RJMP _0x2000085
_0x2000087:
	CALL SUBOPT_0x19
	BRGE _0x2000088
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x2000088:
	RJMP _0x2000083
_0x2000085:
	MOV  R20,R19
	RJMP _0x2000089
_0x2000082:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x200008A
	LDI  R21,LOW(0)
_0x200008B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x200008F
	CPI  R19,58
	BRLO _0x200008E
_0x200008F:
	RJMP _0x200008D
_0x200008E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200008B
_0x200008D:
	CPI  R19,0
	BRNE _0x2000091
	RJMP _0x2000081
_0x2000091:
_0x2000092:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x2000094
	CALL SUBOPT_0x19
	BRGE _0x2000095
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x2000095:
	RJMP _0x2000092
_0x2000094:
	CPI  R18,0
	BRNE _0x2000096
	RJMP _0x2000097
_0x2000096:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x2000098
	LDI  R21,LOW(255)
_0x2000098:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x200009C
	CALL SUBOPT_0x1A
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x19
	BRGE _0x200009D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x200009D:
	RJMP _0x200009B
_0x200009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20000A6
	CALL SUBOPT_0x1A
_0x200009F:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20000A1
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20000A3
	CALL SUBOPT_0x17
	BREQ _0x20000A2
_0x20000A3:
	CALL SUBOPT_0x19
	BRGE _0x20000A5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x20000A5:
	RJMP _0x20000A1
_0x20000A2:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x200009F
_0x20000A1:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x200009B
_0x20000A6:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20000AB
	CPI  R30,LOW(0x69)
	BRNE _0x20000AC
_0x20000AB:
	CLT
	BLD  R15,1
	RJMP _0x20000AD
_0x20000AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20000AE
_0x20000AD:
	LDI  R18,LOW(10)
	RJMP _0x20000A9
_0x20000AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20000AF
	LDI  R18,LOW(16)
	RJMP _0x20000A9
_0x20000AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20000B2
	RJMP _0x20000B1
_0x20000B2:
	RJMP _0x20C0006
_0x20000A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20000B3:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20000B5
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20000B6
	CALL SUBOPT_0x19
	BRGE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x20000B7:
	RJMP _0x20000B8
_0x20000B6:
	SBRC R15,1
	RJMP _0x20000B9
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x20000BA
	BLD  R15,2
	RJMP _0x20000B3
_0x20000BA:
	CPI  R19,43
	BREQ _0x20000B3
_0x20000B9:
	CPI  R18,16
	BRNE _0x20000BC
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20000B8
	RJMP _0x20000BE
_0x20000BC:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x20000BF
_0x20000B8:
	SBRC R15,0
	RJMP _0x20000C1
	MOV  R20,R19
	RJMP _0x20000B5
_0x20000BF:
_0x20000BE:
	CPI  R19,97
	BRLO _0x20000C2
	SUBI R19,LOW(87)
	RJMP _0x20000C3
_0x20000C2:
	CPI  R19,65
	BRLO _0x20000C4
	SUBI R19,LOW(55)
	RJMP _0x20000C5
_0x20000C4:
	SUBI R19,LOW(48)
_0x20000C5:
_0x20000C3:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	CLT
	BLD  R15,0
	RJMP _0x20000B3
_0x20000B5:
	CALL SUBOPT_0x1A
	SBRS R15,2
	RJMP _0x20000C6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x20000C6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x200009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20000C7
_0x200008A:
_0x20000B1:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x18
	POP  R20
	CP   R30,R19
	BREQ _0x20000C8
	CALL SUBOPT_0x19
	BRGE _0x20000C9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x20000C9:
_0x2000097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20000CA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x20000CA:
	RJMP _0x2000081
_0x20000C8:
_0x20000C7:
_0x2000089:
	RJMP _0x200007F
_0x2000081:
_0x20000C1:
_0x20C0006:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20C0005:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x16
	SBIW R30,0
	BRNE _0x20000CB
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x20000CB:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x16
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x16
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G100)
	LDI  R31,HIGH(_get_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G100
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strcspn:
; .FSTART _strcspn
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strcspn0:
    ld   r22,x+
    tst  r22
    breq strcspn2
    ldd  r31,y+1
    ld   r30,y
strcspn1:
    ld   r23,z+
    tst  r23
    breq strcspn3
    cp   r22,r23
    breq strcspn2
    rjmp strcspn1
strcspn3:
    adiw r24,1
    rjmp strcspn0
strcspn2:
    movw r30,r24
_0x20C0003:
	ADIW R28,4
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncat:
; .FSTART _strncat
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncat0:
    ld   r22,x+
    tst  r22
    brne strncat0
    sbiw r26,1
strncat1:
    st   x,r23
    tst  r23
    breq strncat2
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncat1
strncat2:
    movw r30,r24
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20C0002
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
_0x20C0002:
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	RJMP _0x20C0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x206000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x206000B
_0x206000D:
_0x20C0001:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.CSEG

	.DSEG
_predefinedUsers:
	.BYTE 0xA0
_registeredUsers:
	.BYTE 0x190
_inputBuffer:
	.BYTE 0x14
_tempPassword:
	.BYTE 0x14
_loggedUser:
	.BYTE 0x14
_currentTime:
	.BYTE 0x6
_shutdownTime:
	.BYTE 0x6
_menuOptions:
	.BYTE 0x6
_numMenuOptions:
	.BYTE 0x2
_isMenuOpen:
	.BYTE 0x2
_menuSelection:
	.BYTE 0x2
_voltage:
	.BYTE 0x4
_voltageStr:
	.BYTE 0x14
_timeBuffer:
	.BYTE 0xA
_c:
	.BYTE 0x1
_lcdBuffer:
	.BYTE 0x14
_durationBuffer:
	.BYTE 0xA
_i:
	.BYTE 0x2
_digitIndex_S0000007000:
	.BYTE 0x1
_digitCodes_S0000007000:
	.BYTE 0x8
_lastVoltage_S0000007000:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x0:
	__MULBNWRU 16,17,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	SUBI R30,LOW(-_predefinedUsers)
	SBCI R31,HIGH(-_predefinedUsers)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	SUBI R30,LOW(-_registeredUsers)
	SBCI R31,HIGH(-_registeredUsers)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_tempPassword)
	LDI  R27,HIGH(_tempPassword)
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_loggedUser)
	LDI  R31,HIGH(_loggedUser)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_tempPassword)
	LDI  R31,HIGH(_tempPassword)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL __DIVW21
	MOV  R26,R30
	JMP  _get7SegmentCode

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	IN   R30,0xC
	STS  _c,R30
	LDS  R26,_c
	CPI  R26,LOW(0xA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(_timeBuffer)
	LDI  R31,HIGH(_timeBuffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _strncat

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	IN   R1,18
	LDI  R30,0
	SBIC 0x12,3
	LDI  R30,1
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
