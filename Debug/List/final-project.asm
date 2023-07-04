
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
	JMP  _0x20C0003
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
	RJMP _0x20C0004
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
	RJMP _0x20C0004
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
	RJMP _0x20C0004
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
; 0000 006C             if (strcmp(predefinedUsers[i].password, inputBuffer) == 0)
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
	RJMP _0x20C0004
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
; 0000 0079             if (strcmp(registeredUsers[i].password, inputBuffer) == 0)
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
	RJMP _0x20C0004
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
_0x20C0004:
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
	LDI  R30,LOW(_tempPassword)
	LDI  R31,HIGH(_tempPassword)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
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
	LDI  R30,LOW(_tempPassword)
	LDI  R31,HIGH(_tempPassword)
	CALL SUBOPT_0x3
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
	RJMP _0x5D
; 0000 0093     }
; 0000 0094     else
_0x28:
; 0000 0095     {
; 0000 0096         send_string("\nRegistration Failed!\n");
	__POINTW2MN _0x29,27
_0x5D:
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
; 0000 00C0     unsigned char segmentCodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};
; 0000 00C1     if (digit < 10)
;	digit -> Y+10
;	segmentCodes -> Y+0
; 0000 00C2         return segmentCodes[digit];
; 0000 00C3     return 0;
; 0000 00C4 }
;
;void display_on_7segment(float voltage)
; 0000 00C7 {
; 0000 00C8     static unsigned char digitIndex = 0;
; 0000 00C9     static unsigned int digitCodes[4] = {0};
; 0000 00CA 
; 0000 00CB     // Calculate digit codes once when voltage changes
; 0000 00CC     static float lastVoltage = -1.0f;

	.DSEG

	.CSEG
; 0000 00CD     if (voltage != lastVoltage)
;	voltage -> Y+0
; 0000 00CE     {
; 0000 00CF         int intVoltage = (int)(voltage * 100);  // Convert to integer to avoid floating point division
; 0000 00D0         digitCodes[0] = get7SegmentCode(intVoltage / 1000);  // Thousands
;	voltage -> Y+2
;	intVoltage -> Y+0
; 0000 00D1         digitCodes[1] = get7SegmentCode((intVoltage % 1000) / 100);  // Hundreds
; 0000 00D2         digitCodes[2] = get7SegmentCode((intVoltage % 100) / 10);  // Tens
; 0000 00D3         digitCodes[3] = get7SegmentCode(intVoltage % 10);  // Ones
; 0000 00D4         lastVoltage = voltage;
; 0000 00D5     }
; 0000 00D6 
; 0000 00D7     // Turn off all digits
; 0000 00D8     PORTA = 0;
; 0000 00D9 
; 0000 00DA     // Set segments
; 0000 00DB     PORTA = digitCodes[digitIndex];
; 0000 00DC 
; 0000 00DD     // Turn on the current digit
; 0000 00DE     PORTA |= (1 << (digitIndex + 4));
; 0000 00DF 
; 0000 00E0     // Go to the next digit
; 0000 00E1     digitIndex = (digitIndex + 1) % 4;
; 0000 00E2 }
;
;void measure_voltage()
; 0000 00E5 {
; 0000 00E6     // Start the ADC conversion
; 0000 00E7     ADCSRA |= (1 << ADSC);
; 0000 00E8 
; 0000 00E9     // Wait for conversion to complete
; 0000 00EA     while (ADCSRA & (1 << ADSC));
; 0000 00EB 
; 0000 00EC     // Get the result
; 0000 00ED     adc_result = ADCL | (ADCH << 8);
; 0000 00EE 
; 0000 00EF     // Display the voltage on the 7-segment display and LCD
; 0000 00F0     voltage = (adc_result / 1024.0) * 5;
; 0000 00F1     lcd_gotoxy(0, 1);
; 0000 00F2     sprintf(voltageStr, "Voltage: %.2fV", voltage);
; 0000 00F3     lcd_puts(voltageStr);
; 0000 00F4 
; 0000 00F5 
; 0000 00F6     // Assuming you have a function to display numbers on 7-segment
; 0000 00F7     display_on_7segment(voltage);
; 0000 00F8 }
;
;void set_clock()
; 0000 00FB {
; 0000 00FC     // Ask the user to input time
; 0000 00FD     send_string("\nEnter time (HH:MM:SS): ");
; 0000 00FE     while (c = UDR0, c != '\n') // read until newline
; 0000 00FF     {
; 0000 0100         strncat(timeBuffer, &c, 1);
; 0000 0101     }
; 0000 0102     // Remove newline character from fgets
; 0000 0103     timeBuffer[strcspn(timeBuffer, "\n")] = 0;
; 0000 0104 
; 0000 0105     sscanf(timeBuffer, "%d:%d:%d", &currentTime.hours, &currentTime.minutes, &currentTime.seconds);
; 0000 0106 
; 0000 0107     // Display the time on LCD
; 0000 0108     sprintf(lcdBuffer, "Time: %02d:%02d:%02d", currentTime.hours, currentTime.minutes, currentTime.seconds);
; 0000 0109     lcd_gotoxy(0, 1);
; 0000 010A     lcd_puts(lcdBuffer);
; 0000 010B }

	.DSEG
_0x3A:
	.BYTE 0x1B
;
;void auto_shutdown()
; 0000 010E {

	.CSEG
; 0000 010F     // Ask the user to input shutdown duration
; 0000 0110     send_string("\nEnter shutdown duration (MM:SS): ");
; 0000 0111     while (c = UDR0, c != '\n') // read until newline
; 0000 0112     {
; 0000 0113         strncat(durationBuffer, &c, 1);
; 0000 0114     }
; 0000 0115     sscanf(durationBuffer, "%d:%d", &shutdownTime.minutes, &shutdownTime.seconds);
; 0000 0116 
; 0000 0117     // Start a countdown
; 0000 0118     while (shutdownTime.minutes != 0 || shutdownTime.seconds != 0)
; 0000 0119     {
; 0000 011A         // Decrement the time
; 0000 011B         if (--shutdownTime.seconds < 0)
; 0000 011C         {
; 0000 011D             shutdownTime.seconds = 59;
; 0000 011E             shutdownTime.minutes--;
; 0000 011F         }
; 0000 0120 
; 0000 0121         // Display the remaining time on LCD
; 0000 0122         sprintf(lcdBuffer, "Shutdown in %02d:%02d", shutdownTime.minutes, shutdownTime.seconds);
; 0000 0123         lcd_gotoxy(0, 1);
; 0000 0124         lcd_puts(lcdBuffer);
; 0000 0125 
; 0000 0126         // Beep the buzzer when there is 1 minute left
; 0000 0127         if (shutdownTime.minutes == 1 && shutdownTime.seconds == 0)
; 0000 0128         {
; 0000 0129             PORTD |= (1 << BUZZER);
; 0000 012A         }
; 0000 012B 
; 0000 012C         // Delay for a second
; 0000 012D         for(i = 0; i < 1000; i++)
; 0000 012E             delay_ms(1); // Using delay_ms() in a loop
; 0000 012F }
; 0000 0130 
; 0000 0131     // Shutdown the system
; 0000 0132     PORTD &= ~(1 << LED1);
; 0000 0133     PORTD &= ~(1 << LED2);
; 0000 0134     PORTD &= ~(1 << BUZZER);
; 0000 0135     lcd_clear();
; 0000 0136     PORTA = 0; // Turn off 7-segment
; 0000 0137 }

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
; 0000 014E {
; 0000 014F     if (isMenuOpen == 1)
	LDS  R26,_isMenuOpen
	LDS  R27,_isMenuOpen+1
	SBIW R26,1
	BRNE _0x58
; 0000 0150     {
; 0000 0151         // Display the menu on LCD
; 0000 0152         lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0153         lcd_putsf("Menu: ");
	__POINTW2FN _0x0,341
	CALL _lcd_putsf
; 0000 0154         lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0155         lcd_puts(menuOptions[menuSelection]);
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
; 0000 0157         // Display selection on 7-segment
; 0000 0158         PORTA = menuSelection + 1;
	LDS  R30,_menuSelection
	SUBI R30,-LOW(1)
	OUT  0x1B,R30
; 0000 0159     }
; 0000 015A 
; 0000 015B     if (PIND & (1 << KEY_PORT))
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
	BREQ _0x59
; 0000 015C     {
; 0000 015D         // Menu button is pressed
; 0000 015E         if (isMenuOpen == 0)
	LDS  R30,_isMenuOpen
	LDS  R31,_isMenuOpen+1
	SBIW R30,0
	BRNE _0x5A
; 0000 015F         {
; 0000 0160             // Open the menu
; 0000 0161             isMenuOpen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _isMenuOpen,R30
	STS  _isMenuOpen+1,R31
; 0000 0162         }
; 0000 0163         else
	RJMP _0x5B
_0x5A:
; 0000 0164         {
; 0000 0165             // Close the menu
; 0000 0166             isMenuOpen = 0;
	LDI  R30,LOW(0)
	STS  _isMenuOpen,R30
	STS  _isMenuOpen+1,R30
; 0000 0167             PORTA = 0; // Turn off 7-segment
	OUT  0x1B,R30
; 0000 0168         }
_0x5B:
; 0000 0169     }
; 0000 016A }
_0x59:
	RJMP _0x55
; 0000 016B 
; 0000 016C }
_0x5C:
	RJMP _0x5C
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
_0x20C0003:
	ADIW R28,2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_inputBuffer)
	LDI  R27,HIGH(_inputBuffer)
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


	.CSEG
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
