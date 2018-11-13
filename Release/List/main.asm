
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _sample_ready_flag=R5
	.DEF _zeroAdjusting=R4
	.DEF _startSendingDiffValues=R7
	.DEF _stopSendingDiffValues=R6
	.DEF _flewValueChanged=R9
	.DEF _reade2prom=R8
	.DEF _db_monitoring=R11
	.DEF _offset_changed=R10
	.DEF _send_offset=R13
	.DEF _calibration_applied=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  _timer2_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x6E:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x25,0x34,0x2E,0x33,0x66,0x0,0x25,0x34
	.DB  0x2E,0x34,0x66,0x0,0x67,0x61,0x69,0x6E
	.DB  0x20,0x25,0x34,0x2E,0x33,0x66,0x20,0x6F
	.DB  0x66,0x66,0x73,0x65,0x74,0x20,0x25,0x34
	.DB  0x2E,0x33,0x66,0x20,0x73,0x65,0x72,0x69
	.DB  0x61,0x6C,0x20,0x25,0x6C,0x64,0xA,0x0
	.DB  0x67,0x61,0x69,0x6E,0x20,0x25,0x34,0x2E
	.DB  0x33,0x66,0x20,0x6F,0x66,0x66,0x73,0x65
	.DB  0x74,0x20,0x25,0x34,0x2E,0x33,0x66,0x20
	.DB  0x25,0x6C,0x75,0xA,0x0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 08/16/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <eeprom.h>
;#include "def.c"
;#include "delay.h"
;#include "stdio.h"
;#include "stdlib.h"
;#include "spi.h"
;// parametrize program
;/*
;    to run test program comment CALIB_ENABLE and DEBUG uncommenct TEST_PROGRAM
;    to run calibration program comment TEST_PROGRAM , DEBUG uncomment CALIB_ENABLE
;    to calib manually comment lines CALIB_ENABLE,TEST_PROGRAM uncomment DEBUG
;*/
;//#define TEST_PROGRAM
;//#define DEBUG
;#define CS          PORTB.1
;#define L298_EN     PORTA.6
;#define L298_I1     PORTA.5
;#define L298_I2     PORTA.7
;#define LED_G       PORTC.3
;#define LED_R       PORTC.4
;#define DIRECTION   PORTD.6
;
;
;
;#define CALIB_PROCESSING    PIND.2   // C1  R31
;#define DEBUG_CHECK    PIND.4   // C3  R32
;#define START_MEASUREMENT 0
;#define TIME_DETECT       1
;#define STOP_MEASUREMENT  2
;
;
;#define TIMER_ON    0x03 // 187.5 / 2 = 93.75 min 85Khz
;#define TIMER_OFF   0x00
;#define ADC_VREF_TYPE 0x00
;// pulse generation time
;#define PULSE_DURATION  100
;#define REST_DURATION   60
;#define SAMPLE_DURATION 20
;#define TIME_MASURE_LIMIT_CNTR 1000/(PULSE_DURATION*2 + REST_DURATION*2)
;
;#define LITER_PER_PULSE 10000.0
;#define MAX_ELEMENT_CNT 4
;#define GAIN_ADDR        0x05
;#define OFFSET_ADDR      0x09
;#define SERIAL_ADDR      0x01
;#define SERIAL_NUMBER    12345678
;#define SHIFT_LENGHT_MAX 22
;#define SHIFT_DETERMINED_LENGTH  8
;
;#define RANGE_2   // above 3inch
;#ifdef RANGE_2
;    #define TIMER_PRESCALE 0x03  // divide by 4
;    #define TIMER_DIVIDER 4
;#else
;    #define TIMER_PRESCALE 0x05  // divide by 4
;    #define TIMER_DIVIDER 64
;#endif
;
;
;unsigned char sample_ready_flag=0;
;unsigned char zeroAdjusting = 0, startSendingDiffValues = 0, stopSendingDiffValues = 0,
;            flewValueChanged = 0, reade2prom = 0, db_monitoring = 0, offset_changed = 0,
;            send_offset = 0, calibration_applied = 0, ref_sensor_pulse_measurement_started = 0,
;            ref_sensor_pulse_measurement_stopped = 0, measure_Q3_calib = 0, measure_Q2_calib = 0,
;            accuracy_measurement = 0, measure_Q3_calib_send_data = 0, measure_Q2_calib_send_data = 0,
;            accuracy_measurement_send_data = 0, pulse_is_detected = 0, calibration_changed = 0,
;            wd_monitoring = 0, wd_test = 0, serial_number_applied = 0;
;
;unsigned char read_max_samples = 0, read_min_samples = 0 ;
;float dbi_final = 0, offset = 0, dbi_added_value = 0, gain = 0, pulse_duration_1 = 0,
;         dbi_Q3 = 0, diff_Q3 = 0, dbi_Q2 = 0, diff_Q2 = 0, sum_avg_sum_min = 0, sum_avg_sum_max = 0;;
;
;unsigned long int ovf_timer0_cnt = 0, pulse_edge_cnt = 0, eeprom_serial_num = 0;
;unsigned char db_changed = 0;
;
;void process_rx_buffer(void);
;void sendParamsFloat(float * send_arr, unsigned char element_cnt);
;void send_f(float);
;//void sendAckResponse();
;void time2_init();
;// read adc
;
;
;signed long int spi_sampling()//unsigned  char *msb_shift,unsigned char *scnd_shift,unsigned char * lsb_shift
; 0000 001B {

	.CSEG
_spi_sampling:
; .FSTART _spi_sampling
;    //unsigned long int data_msb = 0;
;    //unsigned long int data_scnd = 0;
;    unsigned char data_msb_i = 0, data_scnd_i = 0;
;  //  unsigned long int msb_shift_i = 0, scnd_shift_i = 0;
;   signed int temp = 0;
;    signed long int data = 0;
;
;    CS = 1;
	CALL SUBOPT_0x0
	CALL __SAVELOCR4
;	data_msb_i -> R17
;	data_scnd_i -> R16
;	temp -> R18,R19
;	data -> Y+4
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
	SBI  0x18,1
;    delay_us(1);
	__DELAY_USB 4
;    CS = 0;
	CBI  0x18,1
;
;
;    data_msb_i = spi(0x55);
	LDI  R26,LOW(85)
	CALL _spi
	MOV  R17,R30
;    data_msb_i &= 0x1F;
	ANDI R17,LOW(31)
;
;   /* if ((data_msb_i & 0x80))
;        data_msb_i &= 0x7F;
;    else
;        data_msb_i |= 0x80;
;    */
;    //delay_us(1);
;
;    data_scnd_i = spi(0x55);
	LDI  R26,LOW(85)
	CALL _spi
	MOV  R16,R30
;
;
;    data |= (((unsigned long int)data_msb_i) << 8);
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL SUBOPT_0x1
;
;    data |= (((unsigned long int)data_scnd_i));
	MOV  R30,R16
	LDI  R31,0
	CALL __CWD1
	CALL SUBOPT_0x1
;    //  data |=  (data_lsb_i);
;    temp = 0x1FFF & data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ANDI R31,HIGH(0x1FFF)
	MOVW R18,R30
;    if (temp & 0x1000)
	SBRC R19,4
;    {
;        temp = temp| 0xF000;
	ORI  R19,HIGH(61440)
;    }
;    delay_us(1);
	__DELAY_USB 4
;    CS = 1;
	SBI  0x18,1
;    //printf("msb %lu lsb %lu data %d\n",data_msb_i,data_scnd_i,temp);
;    return temp;
	MOVW R30,R18
	CALL __CWD1
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;}
; .FEND
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
;{
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x2
;// Place your code here
;    static char state = START_MEASUREMENT;//, refPulseCounter = 0;
;
;    switch(state)
	LDS  R30,_state_S0000001000
	LDI  R31,0
;    {
;        case START_MEASUREMENT:
	SBIW R30,0
	BRNE _0xD
;        if(measure_Q3_calib || measure_Q2_calib || accuracy_measurement)
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BRNE _0xF
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BRNE _0xF
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0xE
_0xF:
;        {
;            TCCR0 = TIMER_ON;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;            state = TIME_DETECT;
	LDI  R30,LOW(1)
	STS  _state_S0000001000,R30
;            pulse_is_detected = 1;
	STS  _pulse_is_detected,R30
;            ref_sensor_pulse_measurement_started = 1;
	STS  _ref_sensor_pulse_measurement_started,R30
;            ovf_timer0_cnt = 0;
	LDI  R30,LOW(0)
	STS  _ovf_timer0_cnt,R30
	STS  _ovf_timer0_cnt+1,R30
	STS  _ovf_timer0_cnt+2,R30
	STS  _ovf_timer0_cnt+3,R30
;            measure_Q3_calib_send_data = 0;
	STS  _measure_Q3_calib_send_data,R30
;            pulse_edge_cnt = 0;
	STS  _pulse_edge_cnt,R30
	STS  _pulse_edge_cnt+1,R30
	STS  _pulse_edge_cnt+2,R30
	STS  _pulse_edge_cnt+3,R30
;            pulse_duration_1 = 0;
	STS  _pulse_duration_1,R30
	STS  _pulse_duration_1+1,R30
	STS  _pulse_duration_1+2,R30
	STS  _pulse_duration_1+3,R30
;           // ovf_timer0_cnt = 0;
;        }
;        ref_sensor_pulse_measurement_stopped = 0;
_0xE:
	LDI  R30,LOW(0)
	STS  _ref_sensor_pulse_measurement_stopped,R30
;        break;
	RJMP _0xC
;        case TIME_DETECT:
_0xD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xC
;            pulse_duration_1 = (TCNT0*0.004 + ovf_timer0_cnt*1.024);//
	IN   R30,0x32
	CALL SUBOPT_0x3
	__GETD2N 0x3B83126F
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_ovf_timer0_cnt
	LDS  R31,_ovf_timer0_cnt+1
	LDS  R22,_ovf_timer0_cnt+2
	LDS  R23,_ovf_timer0_cnt+3
	CALL __CDF1U
	__GETD2N 0x3F83126F
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _pulse_duration_1,R30
	STS  _pulse_duration_1+1,R31
	STS  _pulse_duration_1+2,R22
	STS  _pulse_duration_1+3,R23
;            pulse_is_detected = 1;
	LDI  R30,LOW(1)
	STS  _pulse_is_detected,R30
;            //pulse_duration_2 = 0;
;            pulse_edge_cnt++;
	LDI  R26,LOW(_pulse_edge_cnt)
	LDI  R27,HIGH(_pulse_edge_cnt)
	CALL SUBOPT_0x4
;            if(pulse_duration_1 >= 30000.0)
	LDS  R26,_pulse_duration_1
	LDS  R27,_pulse_duration_1+1
	LDS  R24,_pulse_duration_1+2
	LDS  R25,_pulse_duration_1+3
	__GETD1N 0x46EA6000
	CALL __CMPF12
	BRLO _0x12
;            {
;                state = START_MEASUREMENT;
	STS  _state_S0000001000,R30
;                ref_sensor_pulse_measurement_stopped = 1;
	LDI  R30,LOW(1)
	STS  _ref_sensor_pulse_measurement_stopped,R30
;                if(measure_Q3_calib)
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BREQ _0x13
;                {
;                    measure_Q3_calib = 0;
	LDI  R30,LOW(0)
	STS  _measure_Q3_calib,R30
;                    measure_Q3_calib_send_data = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q3_calib_send_data,R30
;                }
;                if(measure_Q2_calib)
_0x13:
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BREQ _0x14
;                {
;                    measure_Q2_calib = 0;
	LDI  R30,LOW(0)
	STS  _measure_Q2_calib,R30
;                    measure_Q2_calib_send_data = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q2_calib_send_data,R30
;                }
;                if(accuracy_measurement)
_0x14:
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0x15
;                {
;                    accuracy_measurement = 0;
	LDI  R30,LOW(0)
	STS  _accuracy_measurement,R30
;                    accuracy_measurement_send_data = 1;
	LDI  R30,LOW(1)
	STS  _accuracy_measurement_send_data,R30
;                }
;                TCCR0 = TIMER_OFF;
_0x15:
	LDI  R30,LOW(0)
	OUT  0x33,R30
;            }
;            else
	RJMP _0x16
_0x12:
;                state = TIME_DETECT;
	LDI  R30,LOW(1)
	STS  _state_S0000001000,R30
;        break;
_0x16:
;        /*case STOP_MEASUREMENT:
;            pulse_duration_2 = (TCNT0*0.004 + ovf_timer0_cnt*1.024);
;            ref_sensor_pulse_measurement_stopped = 1;
;            //ref_sensor_pulse_measurement_started = 0;
;            ovf_timer0_cnt = 0;
;            TCCR0 = TIMER_OFF;
;            state = START_MEASUREMENT;
;            if(measure_Q3_calib)
;            {
;                measure_Q3_calib = 0;
;                measure_Q3_calib_send_data = 1;
;            }
;            break;
;        */
;    }
_0xC:
;
;}
	RJMP _0xBE
; .FEND
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 250
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
;{
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
;char status,data;
;status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
;data=UDR;
	IN   R16,12
;
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x17
;   {
;   rx_buffer[rx_wr_index++]=data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;   //LED_R = 1;
;#if RX_BUFFER_SIZE == 256
;   // special case for receiver buffer size=256
;   if (++rx_counter == 0) rx_buffer_overflow=1;
;#else
;   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0xFA)
	BRNE _0x18
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;   if (++rx_counter == RX_BUFFER_SIZE)
_0x18:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0xFA)
	BRNE _0x19
;      {
;      rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
;      rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      }
;#endif
;    if ((rx_buffer[rx_wr_index-1] == 0x04))
_0x19:
	CALL SUBOPT_0x5
	BRNE _0x1A
;      {
;         process_rx_buffer();
	RCALL _process_rx_buffer
;      }
;   }
_0x1A:
;}
_0x17:
	LD   R16,Y+
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
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter==0);
;	data -> R17
;data=rx_buffer[rx_rd_index++];
;#if RX_BUFFER_SIZE != 256
;if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;#endif
;#asm("cli")
;--rx_counter;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;{
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;// Place your code here
;
;    ovf_timer0_cnt++;
	LDI  R26,LOW(_ovf_timer0_cnt)
	LDI  R27,HIGH(_ovf_timer0_cnt)
	CALL SUBOPT_0x4
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;{
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	CALL SUBOPT_0x2
;// Place your code here
;unsigned long int temp = 0;
;  if (db_changed)
	CALL SUBOPT_0x0
;	temp -> Y+0
	LDS  R30,_db_changed
	CPI  R30,0
	BREQ _0x1F
;  {
;
;    db_changed = 0;
	LDI  R30,LOW(0)
	STS  _db_changed,R30
;
;    //temp = (((float)(1/(float)(dbi_final*10))*1000000)/2)/64;
;    temp = (((float)(1/(float)(dbi_final*10))*1000000)/2)/TIMER_DIVIDER;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL __MULF12
	CALL SUBOPT_0x8
	CALL __DIVF21
	__GETD2N 0x49742400
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x9
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40800000
	CALL __DIVF21
	MOVW R26,R28
	CALL __CFD1U
	CALL __PUTDP1
;
;    OCR1AH= (temp & 0xFF00)>>8;
	CALL __GETD1S0
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSRD12
	OUT  0x2B,R30
;    OCR1AL= (temp & 0x00FF);
	LD   R30,Y
	OUT  0x2A,R30
;    //PORTB.2 = 1;
;
;  }
;
;}
_0x1F:
	ADIW R28,4
_0xBE:
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
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
;{
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; // Place your code here
; // Place your code here
;    static char state=0,counter=0;
; //char str[16];
; //pulse generator procedure 80ms up 80ms lo 180ms idle
;
; switch(state)
	LDS  R30,_state_S0000006000
	LDI  R31,0
; {
;    case 0:
	SBIW R30,0
	BRNE _0x23
;        if(counter >= PULSE_DURATION - SAMPLE_DURATION && counter <= PULSE_DURATION - 2) // 30 - 5
	LDS  R26,_counter_S0000006000
	CPI  R26,LOW(0x50)
	BRLO _0x25
	CPI  R26,LOW(0x63)
	BRLO _0x26
_0x25:
	RJMP _0x24
_0x26:
;        {
;           read_max_samples = 1;
	LDI  R30,LOW(1)
	RJMP _0xBB
;
;        }
;        else
_0x24:
;            read_max_samples = 0;
	LDI  R30,LOW(0)
_0xBB:
	STS  _read_max_samples,R30
;        counter++;
	CALL SUBOPT_0xA
;        if(counter == PULSE_DURATION) //140
	CPI  R26,LOW(0x64)
	BRNE _0x28
;        {
;            counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000006000,R30
;
;            LED_G=1;
	SBI  0x15,3
;            //DIRECTION = 0;
;
;            L298_I1=0;
	CBI  0x1B,5
;            L298_I2=0;
	CBI  0x1B,7
;            state=1;
	LDI  R30,LOW(1)
	STS  _state_S0000006000,R30
;        }
;    break;
_0x28:
	RJMP _0x22
;    //---------
;    case 1:
_0x23:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2F
;        counter++;
	CALL SUBOPT_0xA
;        if(counter == REST_DURATION)
	CPI  R26,LOW(0x3C)
	BRNE _0x30
;        {
;            counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000006000,R30
;
;            //DIRECTION = 0;
;            L298_I1=0;
	CBI  0x1B,5
;            L298_I2=1;
	SBI  0x1B,7
;            state=2;
	LDI  R30,LOW(2)
	STS  _state_S0000006000,R30
;        }
;    break;
_0x30:
	RJMP _0x22
;    //---------
;    case 2:
_0x2F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x35
;        if(counter >= PULSE_DURATION - SAMPLE_DURATION  && counter <= PULSE_DURATION - 2)
	LDS  R26,_counter_S0000006000
	CPI  R26,LOW(0x50)
	BRLO _0x37
	CPI  R26,LOW(0x63)
	BRLO _0x38
_0x37:
	RJMP _0x36
_0x38:
;        {
;           read_min_samples = 1;
	LDI  R30,LOW(1)
	RJMP _0xBC
;        }
;        else
_0x36:
;            read_min_samples = 0;
	LDI  R30,LOW(0)
_0xBC:
	STS  _read_min_samples,R30
;        counter++;
	CALL SUBOPT_0xA
;        if(counter == PULSE_DURATION)
	CPI  R26,LOW(0x64)
	BRNE _0x3A
;        {
;            counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000006000,R30
;
;            //DIRECTION = 0;
;            L298_I1=0;
	CBI  0x1B,5
;            L298_I2=0;
	CBI  0x1B,7
;            sample_ready_flag=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;            state=3;
	LDI  R30,LOW(3)
	STS  _state_S0000006000,R30
;        }
;    break;
_0x3A:
	RJMP _0x22
;    //---------
;    case 3:
_0x35:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x22
;   // if(counter == 1)
;   //   sample_ready_flag=1;
;    counter++;
	CALL SUBOPT_0xA
;
;    if(counter == REST_DURATION)
	CPI  R26,LOW(0x3C)
	BRNE _0x40
;    {
;        counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000006000,R30
;        LED_G=0;
	CBI  0x15,3
;        L298_I1=1;
	SBI  0x1B,5
;        //DIRECTION = 1;
;        L298_I2=0;
	CBI  0x1B,7
;
;        if(sample_ready_flag==0)
	TST  R5
	BRNE _0x47
;        {
;            state=0;
	STS  _state_S0000006000,R30
;
;        }
;    }
_0x47:
;    break;
_0x40:
; }
_0x22:
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;void process_rx_buffer()
;{
_process_rx_buffer:
; .FSTART _process_rx_buffer
;
;    char i = 0;//,j = 0;
;    while(rx_buffer[i] != 0x03)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
_0x48:
	CALL SUBOPT_0xB
	BREQ _0x4A
;        i++;
	SUBI R17,-1
	RJMP _0x48
_0x4A:
	CALL SUBOPT_0xB
	BRNE _0x4C
	CALL SUBOPT_0x5
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
;    {
;        LED_R =1;
	SBI  0x15,4
;         switch (rx_buffer[i+1])
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer,1
	LD   R30,Z
	LDI  R31,0
;        {
;            case 0x01:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x53
;                reade2prom = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
;                break;
	RJMP _0x52
;            case 0x02:
_0x53:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x54
;                db_monitoring = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;                break;
	RJMP _0x52
;            case 0x03:
_0x54:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x55
;                offset_changed = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;                break;
	RJMP _0x52
;            case 0x05:
_0x55:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x56
;                measure_Q3_calib = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q3_calib,R30
;                break;
	RJMP _0x52
;            case 0x06:
_0x56:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x57
;                measure_Q2_calib = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q2_calib,R30
;                break;
	RJMP _0x52
;            case 0x07:
_0x57:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x58
;                calibration_applied = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
;                break;
	RJMP _0x52
;            case 0x08:
_0x58:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x59
;                calibration_changed = 1;
	LDI  R30,LOW(1)
	STS  _calibration_changed,R30
;                break;
	RJMP _0x52
;            case 0x09:
_0x59:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5A
;                accuracy_measurement = 1;
	LDI  R30,LOW(1)
	STS  _accuracy_measurement,R30
;                break;
	RJMP _0x52
;            case 0x0a:
_0x5A:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x5B
;                wd_monitoring = 1;
	LDI  R30,LOW(1)
	STS  _wd_monitoring,R30
;                break;
	RJMP _0x52
;            case 0x0b:
_0x5B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x5C
;                wd_test = 1;
	LDI  R30,LOW(1)
	STS  _wd_test,R30
;                break;
	RJMP _0x52
;            case 0x0c:
_0x5C:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x5D
;                serial_number_applied = 1;
	LDI  R30,LOW(1)
	STS  _serial_number_applied,R30
;                break;
	RJMP _0x52
;            case 0x11:
_0x5D:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x5E
;                zeroAdjusting = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
;                break;
	RJMP _0x52
;            case 0x33:
_0x5E:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x5F
;                startSendingDiffValues = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
;                break;
	RJMP _0x52
;            case 0x44:
_0x5F:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x60
;                stopSendingDiffValues = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;                break;
	RJMP _0x52
;            case 0x88:
_0x60:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x52
;                flewValueChanged = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
;                break;
;        }
_0x52:
;    }
; }
_0x4B:
	LD   R17,Y+
	RET
; .FEND
;
;
;void send_f(float dataf)
;{
_send_f:
; .FSTART _send_f
;        char send[50];
;        //unsigned long int data;
;        char size = 0, i;
;       // data = 6526521;
;        //dataf = 4333.44;
;
;        send[0] = 0x03;
	CALL __PUTPARD2
	SBIW R28,50
	ST   -Y,R17
	ST   -Y,R16
;	dataf -> Y+52
;	send -> Y+2
;	size -> R17
;	i -> R16
	LDI  R17,0
	LDI  R30,LOW(3)
	STD  Y+2,R30
;       // sprintf(send + 1,"%lu",data);
;        sprintf(send + 1,"%4.3f",dataf);
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 56
	CALL SUBOPT_0xC
;        size = strlen(send);
	MOVW R26,R28
	ADIW R26,2
	CALL _strlen
	MOV  R17,R30
;
;        //printf("%u %lu\n",size,data);
;
;
;        send[size++] = 0x04;
	SUBI R17,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(4)
	ST   X,R30
;      //  send[size++] = 10;
;        for(i = 0; i < size; i++)
	LDI  R16,LOW(0)
_0x63:
	CP   R16,R17
	BRSH _0x64
;            putchar(send[i]);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CALL _putchar
	SUBI R16,-1
	RJMP _0x63
_0x64:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,56
	RET
; .FEND
;
;void sendParamsFloat(float * send_arr, unsigned char element_cnt)
;{
_sendParamsFloat:
; .FSTART _sendParamsFloat
;   char send[80];
;   char temp[20];
;   char size = 0, i =0 , k = 0, cnt = 0;
;  //send_f(min);
;  i = 0;
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,37
	CALL __SAVELOCR4
;	*send_arr -> Y+105
;	element_cnt -> Y+104
;	send -> Y+24
;	temp -> Y+4
;	size -> R17
;	i -> R16
;	k -> R19
;	cnt -> R18
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R16,LOW(0)
;  send[0] = 0x03;
	LDI  R30,LOW(3)
	STD  Y+24,R30
;  //send[1] = element_cnt;
;  i = 1;
	LDI  R16,LOW(1)
;  for(cnt = 0; cnt < element_cnt; cnt++)
	LDI  R18,LOW(0)
_0x66:
	__GETB1SX 104
	CP   R18,R30
	BRSH _0x67
;  {
;   //send[i++] = 3;
;   sprintf(temp,"%4.4f",send_arr[cnt]);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R18
	__GETW2SX 109
	LDI  R31,0
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
;   size = strlen(temp);
	MOVW R26,R28
	ADIW R26,4
	CALL _strlen
	MOV  R17,R30
;   memcpy(send+i,temp,size);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,24
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	CLR  R27
	CALL _memcpy
;   i += size;
	ADD  R16,R17
;   send[i++] = ',';
	CALL SUBOPT_0xE
	LDI  R30,LOW(44)
	ST   X,R30
;  }
	SUBI R18,-1
	RJMP _0x66
_0x67:
;  i--;
	SUBI R16,1
;  send[i++] = 4;
	CALL SUBOPT_0xE
	LDI  R30,LOW(4)
	ST   X,R30
;   //send[i] = 10;
;   //*/
;   for(k = 0; k < i; k++)
	LDI  R19,LOW(0)
_0x69:
	CP   R19,R16
	BRSH _0x6A
;      putchar(send[k]);
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,24
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CALL _putchar
	SUBI R19,-1
	RJMP _0x69
_0x6A:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,44
	RET
; .FEND
;/*
;void sendAckResponse()
;{
;    char send[5];
;    char i;
;
;    send[0] = 0x02;
;    send[1] = 0xdd;
;    send[2] = 0x04;
;    for(i = 0; i < 3; i++)
;        putchar(send[i]);
;}
; */
;void read_eeprom_values()
;{
_read_eeprom_values:
; .FSTART _read_eeprom_values
;   //unsigned char idx = 0;
;   //float data;
;   unsigned char addr = 0;
;   unsigned char check_byte = eeprom_read_byte(0);
;  // eeprom_serial_num = eeprom_read_dword(SERIAL_ADDR);
;  // printf("serial_number %lu check_byte %d\n",eeprom_serial_num,check_byte);
;   if (check_byte != 0xBB)
	ST   -Y,R17
	ST   -Y,R16
;	addr -> R17
;	check_byte -> R16
	LDI  R17,0
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EEPROMRDB
	MOV  R16,R30
	CPI  R16,187
	BREQ _0x6B
;   {
;    offset = 0;
	CALL SUBOPT_0xF
;    dbi_added_value = 0;
	STS  _dbi_added_value,R30
	STS  _dbi_added_value+1,R30
	STS  _dbi_added_value+2,R30
	STS  _dbi_added_value+3,R30
;   // element_cnt_read = 0;
;    gain = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x10
;    //send_f(offset);
;    //send_f(gain);
;    //send(element_cnt_read);
;    eeprom_serial_num = SERIAL_NUMBER;
	__GETD1N 0xBC614E
	CALL SUBOPT_0x11
;    eeprom_write_dword(SERIAL_ADDR,SERIAL_NUMBER);
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	__GETD1N 0xBC614E
	CALL __EEPROMWRD
;    printf("gain %4.3f offset %4.3f serial %ld\n",gain,offset,eeprom_serial_num);
	__POINTW1FN _0x0,12
	RJMP _0x20E0005
;    return;
;   }
;   addr = GAIN_ADDR;
_0x6B:
	LDI  R17,LOW(5)
;   gain = eeprom_read_float(addr);
	MOV  R26,R17
	CALL SUBOPT_0x12
;
;   addr = OFFSET_ADDR;
	LDI  R17,LOW(9)
;   //dbi_added_value = eeprom_read_float(addr);
;   offset = eeprom_read_float(addr);
	MOV  R26,R17
	CALL SUBOPT_0x13
;   eeprom_serial_num = eeprom_read_dword(SERIAL_ADDR);
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EEPROMRDD
	CALL SUBOPT_0x11
;   printf("gain %4.3f offset %4.3f %lu\n",gain,offset,eeprom_serial_num);
	__POINTW1FN _0x0,48
_0x20E0005:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
	CALL __PUTPARD1
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	LDS  R30,_eeprom_serial_num
	LDS  R31,_eeprom_serial_num+1
	LDS  R22,_eeprom_serial_num+2
	LDS  R23,_eeprom_serial_num+3
	CALL __PUTPARD1
	LDI  R24,12
	CALL _printf
	ADIW R28,14
;
;}
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void init(void)
;{
_init:
; .FSTART _init
;    // Input/Output Ports initialization
;    // Port A initialization
;    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
;    DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(224)
	OUT  0x1A,R30
;    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
;    PORTA=(0<<PORTA7) | (0<<PORTA6) | (1<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(32)
	OUT  0x1B,R30
;
;    // Port B initialization
;    // Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
;    DDRB=(1<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(146)
	OUT  0x17,R30
;    // State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
;    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
;
;    // Port C initialization
;    // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
;    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(25)
	OUT  0x14,R30
;    // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
;    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
;
;    // Port D initialization
;    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=In
;    DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(226)
	OUT  0x11,R30
;    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=T
;    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
;
;    // Timer/Counter 0 initialization
;    // Clock source: System Clock
;    // Clock value: Timer 0 Stopped
;    // Mode: Normal top=0xFF
;    // OC0 output: Disconnected
;    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
;    TCNT0=0x00;
	OUT  0x32,R30
;    OCR0=0x00;
	OUT  0x3C,R30
;
;    // Timer/Counter 1 initialization
;    // Clock source: System Clock
;    // Clock value: 187.500 kHz
;    // Mode: Fast PWM top=OCR1A
;    // OC1A output: Inverted PWM
;    // OC1B output: Disconnected
;    // Noise Canceler: Off
;    // Input Capture on Falling Edge
;    // Timer Period: 2.9547 ms
;    // Output Pulse(s):
;    // OC1A Period: 2.9547 ms Width: 0 us
;    // Timer1 Overflow Interrupt: Off
;    // Input Capture Interrupt: Off
;    // Compare A Match Interrupt: On
;    // Compare B Match Interrupt: Off
;    TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(67)
	OUT  0x2F,R30
;    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);      //(0<<CS12) | (1< ...
	LDI  R30,LOW(24)
	OUT  0x2E,R30
;    TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    TCNT1L=0x00;
	OUT  0x2C,R30
;    ICR1H=0x00;
	OUT  0x27,R30
;    ICR1L=0x00;
	OUT  0x26,R30
;    OCR1AH=0x02;
	LDI  R30,LOW(2)
	OUT  0x2B,R30
;    OCR1AL=0x29;
	LDI  R30,LOW(41)
	OUT  0x2A,R30
;    OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;    OCR1BL=0x00;
	OUT  0x28,R30
;
;    // Timer/Counter 2 initialization
;    // Clock source: System Clock
;    // Clock value: 187.500 kHz
;    // Mode: CTC top=OCR2A
;    // OC2 output: Disconnected
;    // Timer Period: 1.0027 ms
;    /*
;    ASSR=0<<AS2;
;    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
;    TCNT2=0x00;
;    OCR2=0xFB;
;    */
;
;    // Timer(s)/Counter(s) Interrupt(s) initialization
;    TIMSK=(1<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(145)
	OUT  0x39,R30
;
;    // External Interrupt(s) initialization
;    // INT0: Off
;    // INT1: On
;    // INT1 Mode: Rising Edge
;    // INT2: Off
;    GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
;    MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(12)
	OUT  0x35,R30
;    MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
;    GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(128)
	OUT  0x3A,R30
;
;    // USART initialization
;    // Communication Parameters: 8 Data, 1 Stop, No Parity
;    // USART Receiver: On
;    // USART Transmitter: On
;    // USART Mode: Asynchronous
;    // USART Baud Rate: 9600
;    UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
;    UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
;    UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
;    UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    UBRRL=0x67;//0x67 75600
	LDI  R30,LOW(103)
	OUT  0x9,R30
;
;    // Analog Comparator initialization
;    // Analog Comparator: Off
;    // The Analog Comparator's positive input is
;    // connected to the AIN0 pin
;    // The Analog Comparator's negative input is
;    // connected to the AIN1 pin
;    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
;
;    // ADC initialization
;    // ADC disabled
;    ADMUX= 0;
	OUT  0x7,R30
;    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
;
;#ifdef SPI_MAN
;    // SPI initialization
;    // SPI disabled
;    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
;#else
;   // SPI initialization
;    // SPI Type: Master
;    // SPI Clock Rate: 93.750 kHz
;    // SPI Clock Phase: Cycle Start
;    // SPI Clock Polarity: Low
;    // SPI Data Order: MSB First
;    SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (1<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(83)
	OUT  0xD,R30
;    SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
;#endif
;
;    // TWI initialization
;    // TWI disabled
;    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
;
;    // Global enable interrupts
;    #asm("sei")
	sei
;    L298_EN = 1;
	SBI  0x1B,6
;    //L298_I1 = 1;
;}
	RET
; .FEND
;void enable_watchdog()
;{
_enable_watchdog:
; .FSTART _enable_watchdog
;    // Watchdog Timer initialization
;    // Watchdog Timer Prescaler: OSC/2048k
;    WDTCR=(0<<WDTOE) | (1<<WDE) | (1<<WDP2) | (1<<WDP1) | (1<<WDP0);
	LDI  R30,LOW(15)
	OUT  0x21,R30
;}
	RET
; .FEND
;void time2_init()
;{
_time2_init:
; .FSTART _time2_init
;     // Timer/Counter 2 initialization
;    // Clock source: System Clock
;    // Clock value: 187.500 kHz
;    // Mode: CTC top=OCR2A
;    // OC2 output: Disconnected
;    // Timer Period: 1.0027 ms
;    ASSR=0<<AS2;
	LDI  R30,LOW(0)
	OUT  0x22,R30
;    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);//(1<<CS22) | (0<<CS21) |  ...
	LDI  R30,LOW(12)
	OUT  0x25,R30
;    TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;    OCR2=0xFB;
	LDI  R30,LOW(251)
	OUT  0x23,R30
;
;}
	RET
; .FEND
;#include "delay.h"
;
;#define LSB 0.0006103515625
;#define ADC_VOL_24 1.5
;#define ADC_VOL_5 0.44
;#define ADC_VOL_8 0.72
;#define ADC_VOL_8N 1.5
;#define VAR_ERROR  20
;
;// Declare your global variables here
;
;void main(void)
; 0000 0028 {
_main:
; .FSTART _main
; 0000 0029 // Declare your local variables here
; 0000 002A 
; 0000 002B    char gainStr[10], offsetStr[10], temp[20];
; 0000 002C    char * ch_temp;
; 0000 002D    unsigned char idx = 0, addr = 0,  flow_sample_counter=0, check_byte = 0,
; 0000 002E                     check_stop_process = 0, len_total = 0, len_gain = 0, len_offset = 0, insert_idx = 0;;
; 0000 002F 
; 0000 0030    signed int max_sample = 0, min_sample = 0;
; 0000 0031    unsigned int max_count = 0, min_count = 0 ;
; 0000 0032 
; 0000 0033    signed long int sum_max = 0, sum_min = 0;
; 0000 0034    unsigned long int sum_diff_counter = 0, serial_number = 0, cntr = 0;
; 0000 0035 
; 0000 0036    float sum = 0, sum_avg_max = 0, sum_avg_min = 0,
; 0000 0037         diff_avg_max_min = 0, sum_all_diffs = 0, avg_sum_max = 0, avg_sum_min = 0,
; 0000 0038         average1 = 0, average2 = 0, diff_avg = 0, dbi_measured = 0, accuracyFault = 0, send_array[MAX_ELEMENT_CNT],
; 0000 0039         dbi_temp = 0;
; 0000 003A    float avg_sum_min_arr[SHIFT_LENGHT_MAX],avg_sum_max_arr[SHIFT_LENGHT_MAX];
; 0000 003B     char ResetFlags = MCUCSR ;
; 0000 003C    static unsigned int wathchdog_counter;
; 0000 003D    init();
	SBIW R28,62
	SUBI R29,1
	LDI  R24,101
	LDI  R26,LOW(177)
	LDI  R27,HIGH(177)
	LDI  R30,LOW(_0x6E*2)
	LDI  R31,HIGH(_0x6E*2)
	CALL __INITLOCB
;	gainStr -> Y+308
;	offsetStr -> Y+298
;	temp -> Y+278
;	*ch_temp -> R16,R17
;	idx -> R19
;	addr -> R18
;	flow_sample_counter -> R21
;	check_byte -> R20
;	check_stop_process -> Y+277
;	len_total -> Y+276
;	len_gain -> Y+275
;	len_offset -> Y+274
;	insert_idx -> Y+273
;	max_sample -> Y+271
;	min_sample -> Y+269
;	max_count -> Y+267
;	min_count -> Y+265
;	sum_max -> Y+261
;	sum_min -> Y+257
;	sum_diff_counter -> Y+253
;	serial_number -> Y+249
;	cntr -> Y+245
;	sum -> Y+241
;	sum_avg_max -> Y+237
;	sum_avg_min -> Y+233
;	diff_avg_max_min -> Y+229
;	sum_all_diffs -> Y+225
;	avg_sum_max -> Y+221
;	avg_sum_min -> Y+217
;	average1 -> Y+213
;	average2 -> Y+209
;	diff_avg -> Y+205
;	dbi_measured -> Y+201
;	accuracyFault -> Y+197
;	send_array -> Y+181
;	dbi_temp -> Y+177
;	avg_sum_min_arr -> Y+89
;	avg_sum_max_arr -> Y+1
;	ResetFlags -> Y+0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	IN   R30,0x34
	ST   Y,R30
	RCALL _init
; 0000 003E 
; 0000 003F    // eeprom_write_dword(SERIAL_ADDR,SERIAL_NUMBER);
; 0000 0040    // delay_ms(2000);
; 0000 0041 
; 0000 0042     read_eeprom_values();
	RCALL _read_eeprom_values
; 0000 0043     delay_us(1000);
	__DELAY_USW 3000
; 0000 0044     time2_init();
	RCALL _time2_init
; 0000 0045 
; 0000 0046     memset(gainStr,'\0',10);
	MOVW R30,R28
	SUBI R30,LOW(-(308))
	SBCI R31,HIGH(-(308))
	CALL SUBOPT_0x16
; 0000 0047 	memset(offsetStr, '\0', 10);
	MOVW R30,R28
	SUBI R30,LOW(-(298))
	SBCI R31,HIGH(-(298))
	CALL SUBOPT_0x16
; 0000 0048     memset(send_array,0,MAX_ELEMENT_CNT);
	CALL SUBOPT_0x17
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	CALL _memset
; 0000 0049 
; 0000 004A     //offset = 0;
; 0000 004B     send_offset = 0;
	CLR  R13
; 0000 004C     enable_watchdog();
	RCALL _enable_watchdog
; 0000 004D     // printf("ResetFlag %x wd %d\n",ResetFlags,wathchdog_counter);
; 0000 004E      if (ResetFlags & (1<<3))
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0x6F
; 0000 004F         wathchdog_counter++;
	LDI  R26,LOW(_wathchdog_counter_S000000E000)
	LDI  R27,HIGH(_wathchdog_counter_S000000E000)
	CALL SUBOPT_0x18
; 0000 0050      else
	RJMP _0x70
_0x6F:
; 0000 0051         wathchdog_counter = 0;
	LDI  R30,LOW(0)
	STS  _wathchdog_counter_S000000E000,R30
	STS  _wathchdog_counter_S000000E000+1,R30
; 0000 0052 
; 0000 0053 while(1)
_0x70:
_0x71:
; 0000 0054       {
; 0000 0055        #asm("WDR");
	WDR
; 0000 0056 
; 0000 0057       // Place your code here
; 0000 0058         if(wd_test)
	LDS  R30,_wd_test
	CPI  R30,0
	BREQ _0x74
; 0000 0059         {
; 0000 005A             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 005B             wd_test = 0;
	STS  _wd_test,R30
; 0000 005C             for (cntr = 0; cntr < 1000000;cntr++);
	__CLRD1SX 245
_0x76:
	__GETD2SX 245
	__CPD2N 0xF4240
	BRSH _0x77
	MOVW R26,R28
	SUBI R26,LOW(-(245))
	SBCI R27,HIGH(-(245))
	CALL SUBOPT_0x4
	RJMP _0x76
_0x77:
; 0000 005D         }
; 0000 005E         if(serial_number_applied)
_0x74:
	LDS  R30,_serial_number_applied
	CPI  R30,0
	BRNE PC+2
	RJMP _0x78
; 0000 005F          {
; 0000 0060             serial_number_applied = 0;
	LDI  R30,LOW(0)
	STS  _serial_number_applied,R30
; 0000 0061 
; 0000 0062             idx = 0;
	CALL SUBOPT_0x19
; 0000 0063             memset(temp,'\0',20);
; 0000 0064            // send(rx_wr_index);
; 0000 0065             // for(index = 0; index < rx_wr_index ; index++)
; 0000 0066                // putchar(rx_buffer[index]);
; 0000 0067             //   printf("%x,",rx_buffer[index]);
; 0000 0068             addr = SERIAL_ADDR;
	LDI  R18,LOW(1)
; 0000 0069             while(rx_buffer[idx+2] != 0x04 && idx < rx_wr_index)
_0x79:
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _rx_buffer,2
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ _0x7C
	LDS  R30,_rx_wr_index
	CP   R19,R30
	BRLO _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 006A             {
; 0000 006B               temp[idx] = rx_buffer[idx+2];
	CALL SUBOPT_0x1A
	__ADDW1MN _rx_buffer,2
	LD   R30,Z
	ST   X,R30
; 0000 006C               //printf("%c,",temp[idx]);
; 0000 006D               //eeprom_write_byte(addr,temp[idx]);
; 0000 006E               //addr += 1;
; 0000 006F               idx++;
	SUBI R19,-1
; 0000 0070             }
	RJMP _0x79
_0x7B:
; 0000 0071             //printf("%lu",atol(temp));
; 0000 0072             if(eeprom_serial_num == SERIAL_NUMBER)
	LDS  R26,_eeprom_serial_num
	LDS  R27,_eeprom_serial_num+1
	LDS  R24,_eeprom_serial_num+2
	LDS  R25,_eeprom_serial_num+3
	__CPD2N 0xBC614E
	BRNE _0x7E
; 0000 0073             {
; 0000 0074                 eeprom_write_dword(addr,atol(temp));
	MOV  R30,R18
	LDI  R31,0
	PUSH R31
	PUSH R30
	MOVW R26,R28
	SUBI R26,LOW(-(278))
	SBCI R27,HIGH(-(278))
	CALL _atol
	POP  R26
	POP  R27
	CALL __EEPROMWRD
; 0000 0075                 eeprom_serial_num = atol(temp);
	MOVW R26,R28
	SUBI R26,LOW(-(278))
	SBCI R27,HIGH(-(278))
	CALL _atol
	CALL SUBOPT_0x11
; 0000 0076             }
; 0000 0077             rx_wr_index = 0;
_0x7E:
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0078             LED_R = 0;
	CBI  0x15,4
; 0000 0079 
; 0000 007A          }
; 0000 007B          if(calibration_changed)
_0x78:
	LDS  R30,_calibration_changed
	CPI  R30,0
	BRNE PC+2
	RJMP _0x81
; 0000 007C          {
; 0000 007D             //printf("calibration_changed");
; 0000 007E             calibration_changed = 0;
	LDI  R30,LOW(0)
	STS  _calibration_changed,R30
; 0000 007F             idx = 0;
	CALL SUBOPT_0x19
; 0000 0080             memset(temp,'\0',20);
; 0000 0081            // send(rx_wr_index);
; 0000 0082             // for(index = 0; index < rx_wr_index ; index++)
; 0000 0083                // putchar(rx_buffer[index]);
; 0000 0084             //   printf("%x,",rx_buffer[index]);
; 0000 0085 
; 0000 0086             while(rx_buffer[idx+1] != 0x04 && idx < rx_wr_index)
_0x82:
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _rx_buffer,1
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ _0x85
	LDS  R30,_rx_wr_index
	CP   R19,R30
	BRLO _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 0087             {
; 0000 0088               temp[idx] = rx_buffer[idx+1];
	CALL SUBOPT_0x1A
	__ADDW1MN _rx_buffer,1
	LD   R30,Z
	ST   X,R30
; 0000 0089               idx++;
	SUBI R19,-1
; 0000 008A             }
	RJMP _0x82
_0x84:
; 0000 008B            // printf("tempStr %s\n",temp);
; 0000 008C             len_total = strlen(temp);
	MOVW R26,R28
	SUBI R26,LOW(-(278))
	SBCI R27,HIGH(-(278))
	CALL _strlen
	__PUTB1SX 276
; 0000 008D             ch_temp = strchr(temp,',');
	MOVW R30,R28
	SUBI R30,LOW(-(278))
	SBCI R31,HIGH(-(278))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(44)
	CALL _strchr
	MOVW R16,R30
; 0000 008E             len_gain = ch_temp - temp + 1;
	MOVW R30,R28
	SUBI R30,LOW(-(278))
	SBCI R31,HIGH(-(278))
	MOV  R26,R30
	MOV  R30,R16
	SUB  R30,R26
	SUBI R30,-LOW(1)
	__PUTB1SX 275
; 0000 008F             memcpy(gainStr,temp + 1, len_gain - 1);
	MOVW R30,R28
	SUBI R30,LOW(-(308))
	SBCI R31,HIGH(-(308))
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(280))
	SBCI R31,HIGH(-(280))
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__GETB1SX 279
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R30
	CALL _memcpy
; 0000 0090 
; 0000 0091             len_offset = len_total - len_gain;
	__GETB2SX 275
	__GETB1SX 276
	SUB  R30,R26
	__PUTB1SX 274
; 0000 0092             memcpy(offsetStr, temp + len_gain , len_offset);
	MOVW R30,R28
	SUBI R30,LOW(-(298))
	SBCI R31,HIGH(-(298))
	ST   -Y,R31
	ST   -Y,R30
	__GETB1SX 277
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(280))
	SBCI R27,HIGH(-(280))
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__GETB2SX 278
	CLR  R27
	CALL _memcpy
; 0000 0093             //printf("gainStr %s offsetStr %s\n",gainStr,offsetStr);
; 0000 0094             gain = atof(gainStr);
	MOVW R26,R28
	SUBI R26,LOW(-(308))
	SBCI R27,HIGH(-(308))
	CALL _atof
	CALL SUBOPT_0x1B
; 0000 0095             offset = atof(offsetStr);
	MOVW R26,R28
	SUBI R26,LOW(-(298))
	SBCI R27,HIGH(-(298))
	CALL _atof
	CALL SUBOPT_0x1C
; 0000 0096             //send_f(gain);
; 0000 0097             //send_f(offset);
; 0000 0098             eeprom_write_byte(0,0xBB);
	CALL SUBOPT_0x1D
; 0000 0099             eeprom_write_float(GAIN_ADDR,gain);
; 0000 009A             eeprom_write_float(OFFSET_ADDR,offset);
; 0000 009B 
; 0000 009C             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 009D             //TCCR1B |= 0x03;  // start timer1 after calibration
; 0000 009E             delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 009F 
; 0000 00A0             LED_R = 0;
	CBI  0x15,4
; 0000 00A1          }
; 0000 00A2          if(calibration_applied)
_0x81:
	TST  R12
	BRNE PC+2
	RJMP _0x89
; 0000 00A3          {
; 0000 00A4 
; 0000 00A5             calibration_applied = 0;
	CLR  R12
; 0000 00A6             idx = 0;
	LDI  R19,LOW(0)
; 0000 00A7             gain = (diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_Q2);
	LDS  R26,_diff_Q2
	LDS  R27,_diff_Q2+1
	LDS  R24,_diff_Q2+2
	LDS  R25,_diff_Q2+3
	LDS  R30,_diff_Q3
	LDS  R31,_diff_Q3+1
	LDS  R22,_diff_Q3+2
	LDS  R23,_diff_Q3+3
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_dbi_Q2
	LDS  R27,_dbi_Q2+1
	LDS  R24,_dbi_Q2+2
	LDS  R25,_dbi_Q2+3
	CALL SUBOPT_0x1F
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x1B
; 0000 00A8             offset = diff_Q3 - gain*dbi_Q3;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL __MULF12
	LDS  R26,_diff_Q3
	LDS  R27,_diff_Q3+1
	LDS  R24,_diff_Q3+2
	LDS  R25,_diff_Q3+3
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x1C
; 0000 00A9 
; 0000 00AA             //printf("diff_q3 %f dbi_q3 %f diff_Q2 %f dbi_Q2 %f d3-d2 %f Q3-Q2 %f gain %f offset %f\n",
; 0000 00AB             //        diff_Q3,dbi_Q3,diff_Q2,dbi_Q2,diff_Q3 - diff_Q2,dbi_Q3 - dbi_Q2,(diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_ ...
; 0000 00AC 
; 0000 00AD             //TCCR1B |= 0x03;  // start timer1 after calibration
; 0000 00AE             delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 00AF             send_array[0] = gain;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x21
; 0000 00B0             send_array[1] = offset;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0000 00B1             eeprom_write_byte(0,0xBB);
	CALL SUBOPT_0x1D
; 0000 00B2             eeprom_write_float(GAIN_ADDR,gain);
; 0000 00B3             eeprom_write_float(OFFSET_ADDR,offset);
; 0000 00B4             sendParamsFloat(send_array,2);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x24
; 0000 00B5             rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 
; 0000 00B9         }//if(calibration_applied)
; 0000 00BA         if(stopSendingDiffValues == 1)
_0x89:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x8A
; 0000 00BB         {
; 0000 00BC             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 00BD             startSendingDiffValues = 0;
	CLR  R7
; 0000 00BE             stopSendingDiffValues = 0;
	CLR  R6
; 0000 00BF             zeroAdjusting = 0;
	CLR  R4
; 0000 00C0             db_monitoring = 0;
	CLR  R11
; 0000 00C1             LED_R = 0;
	CBI  0x15,4
; 0000 00C2             //sendAckResponse();
; 0000 00C3             //
; 0000 00C4         }
; 0000 00C5         if(reade2prom == 1)
_0x8A:
	LDI  R30,LOW(1)
	CP   R30,R8
	BREQ PC+2
	RJMP _0x8D
; 0000 00C6         {
; 0000 00C7            rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 00C8            reade2prom = 0;
	CLR  R8
; 0000 00C9            delay_ms(1000);
	CALL SUBOPT_0x1E
; 0000 00CA            check_byte = eeprom_read_byte(0);
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EEPROMRDB
	MOV  R20,R30
; 0000 00CB            serial_number = eeprom_read_dword(SERIAL_ADDR);
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EEPROMRDD
	__PUTD1SX 249
; 0000 00CC            if (check_byte != 0xBB)
	CPI  R20,187
	BREQ _0x8E
; 0000 00CD            {
; 0000 00CE             offset = 0;
	CALL SUBOPT_0xF
; 0000 00CF             gain = 0;
	CALL SUBOPT_0x10
; 0000 00D0             //send_f(offset);
; 0000 00D1             //send_f(gain);
; 0000 00D2             //send(element_cnt_read);
; 0000 00D3             send_array[0] = offset;
	RJMP _0xBD
; 0000 00D4             send_array[1] = gain;
; 0000 00D5             send_array[2] = serial_number;
; 0000 00D6             sendParamsFloat(send_array,3);
; 0000 00D7             //return;
; 0000 00D8 
; 0000 00D9            }
; 0000 00DA            else
_0x8E:
; 0000 00DB            {
; 0000 00DC                addr = GAIN_ADDR;
	LDI  R18,LOW(5)
; 0000 00DD                gain = eeprom_read_float(addr);
	MOV  R26,R18
	CALL SUBOPT_0x12
; 0000 00DE                addr = OFFSET_ADDR;
	LDI  R18,LOW(9)
; 0000 00DF                //dbi_added_value = eeprom_read_float(addr);
; 0000 00E0                offset = eeprom_read_float(addr);
	MOV  R26,R18
	CALL SUBOPT_0x13
; 0000 00E1                //send_f(gain);
; 0000 00E2                //send_f(offset);
; 0000 00E3                send_array[0] = offset;
_0xBD:
	LDS  R30,_offset
	LDS  R31,_offset+1
	LDS  R22,_offset+2
	LDS  R23,_offset+3
	CALL SUBOPT_0x21
; 0000 00E4                send_array[1] = gain;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x25
; 0000 00E5                send_array[2] = serial_number;
	MOVW R26,R30
	__GETD1SX 249
	CALL SUBOPT_0x26
; 0000 00E6                sendParamsFloat(send_array,3);
	LDI  R26,LOW(3)
	RCALL _sendParamsFloat
; 0000 00E7            }
; 0000 00E8 
; 0000 00E9             LED_R = 0;
	CBI  0x15,4
; 0000 00EA         }
; 0000 00EB         if(measure_Q3_calib || measure_Q2_calib || accuracy_measurement)
_0x8D:
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BRNE _0x93
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BRNE _0x93
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0x92
_0x93:
; 0000 00EC         {
; 0000 00ED             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 00EE         }
; 0000 00EF         if (read_max_samples)
_0x92:
	LDS  R30,_read_max_samples
	CPI  R30,0
	BREQ _0x95
; 0000 00F0         {
; 0000 00F1             max_sample = spi_sampling();
	RCALL _spi_sampling
	__PUTW1SX 271
; 0000 00F2             sum_max += max_sample;
	CALL SUBOPT_0x27
	CALL __CWD1
	CALL __ADDD12
	__PUTD1SX 261
; 0000 00F3             max_count++;
	MOVW R26,R28
	SUBI R26,LOW(-(267))
	SBCI R27,HIGH(-(267))
	CALL SUBOPT_0x18
; 0000 00F4         }
; 0000 00F5 
; 0000 00F6         if (read_min_samples)
_0x95:
	LDS  R30,_read_min_samples
	CPI  R30,0
	BREQ _0x96
; 0000 00F7         {
; 0000 00F8             min_sample = spi_sampling();
	RCALL _spi_sampling
	__PUTW1SX 269
; 0000 00F9             sum_min += min_sample;
	CALL SUBOPT_0x28
	CALL __CWD1
	CALL __ADDD12
	__PUTD1SX 257
; 0000 00FA             min_count++;
	MOVW R26,R28
	SUBI R26,LOW(-(265))
	SBCI R27,HIGH(-(265))
	CALL SUBOPT_0x18
; 0000 00FB         }
; 0000 00FC         if(ref_sensor_pulse_measurement_stopped)
_0x96:
	LDS  R30,_ref_sensor_pulse_measurement_stopped
	CPI  R30,0
	BREQ _0x97
; 0000 00FD         {
; 0000 00FE             check_stop_process = 1;
	LDI  R30,LOW(1)
	__PUTB1SX 277
; 0000 00FF         }
; 0000 0100         if(pulse_is_detected)
_0x97:
	LDS  R30,_pulse_is_detected
	CPI  R30,0
	BREQ _0x98
; 0000 0101         {
; 0000 0102             send_array[0] = 0xbb;
	__GETD1N 0x433B0000
	CALL SUBOPT_0x21
; 0000 0103             send_array[1] = (float)pulse_edge_cnt;
	MOVW R26,R30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x26
; 0000 0104             sendParamsFloat(send_array,2);
	CALL SUBOPT_0x24
; 0000 0105             pulse_is_detected = 0;
	STS  _pulse_is_detected,R30
; 0000 0106         }
; 0000 0107         if (sample_ready_flag && max_count !=0 && min_count !=0)
_0x98:
	TST  R5
	BREQ _0x9A
	__GETW2SX 267
	SBIW R26,0
	BREQ _0x9A
	__GETW2SX 265
	SBIW R26,0
	BRNE _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 0108         {
; 0000 0109           // printf("watch_dog timer counter %lu\n",wathchdog_counter);
; 0000 010A            if(wd_monitoring)
	LDS  R30,_wd_monitoring
	CPI  R30,0
	BREQ _0x9C
; 0000 010B            {
; 0000 010C                 send_array[0] =  (float)wathchdog_counter;
	LDS  R30,_wathchdog_counter_S000000E000
	LDS  R31,_wathchdog_counter_S000000E000+1
	CALL SUBOPT_0x2A
	__PUTD1SX 181
; 0000 010D                 sendParamsFloat(send_array,1);
	CALL SUBOPT_0x17
	LDI  R26,LOW(1)
	RCALL _sendParamsFloat
; 0000 010E                 wd_monitoring = 0;
	LDI  R30,LOW(0)
	STS  _wd_monitoring,R30
; 0000 010F                 rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 0110                 LED_R = 0;
	CBI  0x15,4
; 0000 0111            }
; 0000 0112            average1 = (float)((sum_max) / (float)max_count);
_0x9C:
	__GETW1SX 267
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x27
	CALL __CDF2
	CALL __DIVF21
	__PUTD1SX 213
; 0000 0113            average2 = (float)((sum_min) / (float)min_count);
	__GETW1SX 265
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x28
	CALL __CDF2
	CALL __DIVF21
	__PUTD1SX 209
; 0000 0114           // printf("min %d max %d\n",max_count,min_count);
; 0000 0115            max_count = 0;
	LDI  R30,LOW(0)
	__CLRW1SX 267
; 0000 0116            min_count = 0;
	__CLRW1SX 265
; 0000 0117            sum_max = 0;
	__CLRD1SX 261
; 0000 0118            sum_min = 0;
	__CLRD1SX 257
; 0000 0119            sample_ready_flag = 0;
	CLR  R5
; 0000 011A            //if(CALIB_PROCESSING == 0)
; 0000 011B            //{
; 0000 011C               if(ref_sensor_pulse_measurement_started)
	LDS  R30,_ref_sensor_pulse_measurement_started
	CPI  R30,0
	BREQ _0x9F
; 0000 011D               {
; 0000 011E                 diff_avg_max_min = average1 - average2;
	CALL SUBOPT_0x2B
; 0000 011F                 sum_all_diffs += diff_avg_max_min;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CALL __ADDF12
	__PUTD1SX 225
; 0000 0120                 sum_diff_counter++;
	MOVW R26,R28
	SUBI R26,LOW(-(253))
	SBCI R27,HIGH(-(253))
	CALL SUBOPT_0x4
; 0000 0121                 //printf("ovf %lu s %4.1f c %lu p1 %4.3f\n",ovf_timer0_cnt,sum_all_diffs,sum_diff_counter,pulse_duration ...
; 0000 0122               }
; 0000 0123               //if(ref_sensor_pulse_measurement_stopped)
; 0000 0124               if(check_stop_process)
_0x9F:
	__GETB1SX 277
	CPI  R30,0
	BRNE PC+2
	RJMP _0xA0
; 0000 0125               {
; 0000 0126                 check_stop_process = 0;
	LDI  R30,LOW(0)
	__PUTB1SX 277
; 0000 0127                 diff_avg = sum_all_diffs / sum_diff_counter;
	__GETD1SX 253
	CALL SUBOPT_0x2D
	CALL __CDF1U
	CALL __DIVF21
	__PUTD1SX 205
; 0000 0128                 dbi_measured = (pulse_edge_cnt*LITER_PER_PULSE) / (pulse_duration_1);
	CALL SUBOPT_0x29
	CALL __CDF1U
	__GETD2N 0x461C4000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pulse_duration_1
	LDS  R31,_pulse_duration_1+1
	LDS  R22,_pulse_duration_1+2
	LDS  R23,_pulse_duration_1+3
	CALL __DIVF21
	__PUTD1SX 201
; 0000 0129                 //printf("pulse_duration_1 %4.3f pulse_edge_cnt %lu sum_all_diffs %4.4f sum_diff_counter %d diff_avg %4. ...
; 0000 012A                 sum_all_diffs = 0;
	LDI  R30,LOW(0)
	__CLRD1SX 225
; 0000 012B                 sum_diff_counter = 0;
	__CLRD1SX 253
; 0000 012C                 diff_avg_max_min = 0;
	CALL SUBOPT_0x2E
; 0000 012D                 ref_sensor_pulse_measurement_stopped = 0;
	LDI  R30,LOW(0)
	STS  _ref_sensor_pulse_measurement_stopped,R30
; 0000 012E                 ref_sensor_pulse_measurement_started = 0;
	STS  _ref_sensor_pulse_measurement_started,R30
; 0000 012F                 if(measure_Q3_calib_send_data)
	LDS  R30,_measure_Q3_calib_send_data
	CPI  R30,0
	BREQ _0xA1
; 0000 0130                 {
; 0000 0131                    dbi_Q3 = dbi_measured;
	CALL SUBOPT_0x2F
	STS  _dbi_Q3,R30
	STS  _dbi_Q3+1,R31
	STS  _dbi_Q3+2,R22
	STS  _dbi_Q3+3,R23
; 0000 0132                    diff_Q3 = diff_avg;
	CALL SUBOPT_0x30
	STS  _diff_Q3,R30
	STS  _diff_Q3+1,R31
	STS  _diff_Q3+2,R22
	STS  _diff_Q3+3,R23
; 0000 0133                    send_array[0] = dbi_measured;
	CALL SUBOPT_0x31
; 0000 0134                    send_array[1] = diff_avg;
	CALL SUBOPT_0x32
; 0000 0135                    sendParamsFloat(send_array,2);
	CALL SUBOPT_0x24
; 0000 0136                    measure_Q3_calib_send_data = 0;
	STS  _measure_Q3_calib_send_data,R30
; 0000 0137                 }
; 0000 0138                 if(measure_Q2_calib_send_data)
_0xA1:
	LDS  R30,_measure_Q2_calib_send_data
	CPI  R30,0
	BREQ _0xA2
; 0000 0139                 {
; 0000 013A                    dbi_Q2 = dbi_measured;
	CALL SUBOPT_0x2F
	STS  _dbi_Q2,R30
	STS  _dbi_Q2+1,R31
	STS  _dbi_Q2+2,R22
	STS  _dbi_Q2+3,R23
; 0000 013B                    diff_Q2 = diff_avg;
	CALL SUBOPT_0x30
	STS  _diff_Q2,R30
	STS  _diff_Q2+1,R31
	STS  _diff_Q2+2,R22
	STS  _diff_Q2+3,R23
; 0000 013C                    send_array[0] = dbi_measured;
	CALL SUBOPT_0x31
; 0000 013D                    send_array[1] = diff_avg;
	CALL SUBOPT_0x32
; 0000 013E                    sendParamsFloat(send_array,2);
	CALL SUBOPT_0x24
; 0000 013F                    measure_Q2_calib_send_data = 0;
	STS  _measure_Q2_calib_send_data,R30
; 0000 0140                 }
; 0000 0141                 //sendParamsFloat(dbi_measured,diff_avg);
; 0000 0142                 if(accuracy_measurement_send_data)
_0xA2:
	LDS  R30,_accuracy_measurement_send_data
	CPI  R30,0
	BRNE PC+2
	RJMP _0xA3
; 0000 0143                 {
; 0000 0144                     dbi_final = (diff_avg - offset)/gain;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0145                     accuracyFault = ((dbi_final - dbi_measured)/dbi_measured)*100;
	__GETD2SX 201
	LDS  R30,_dbi_final
	LDS  R31,_dbi_final+1
	LDS  R22,_dbi_final+2
	LDS  R23,_dbi_final+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x2F
	CALL __DIVF21
	__GETD2N 0x42C80000
	CALL __MULF12
	__PUTD1SX 197
; 0000 0146                     send_array[0] = dbi_measured;
	CALL SUBOPT_0x31
; 0000 0147                     send_array[1] = dbi_final;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x25
; 0000 0148                     send_array[2] = accuracyFault;
	__GETD2SX 197
	CALL SUBOPT_0x23
; 0000 0149                     send_array[3] = diff_avg;
	MOVW R30,R28
	SUBI R30,LOW(-(181))
	SBCI R31,HIGH(-(181))
	ADIW R30,12
	CALL SUBOPT_0x32
; 0000 014A                     sendParamsFloat(send_array,4);
	LDI  R26,LOW(4)
	RCALL _sendParamsFloat
; 0000 014B                     accuracy_measurement_send_data = 0;
	LDI  R30,LOW(0)
	STS  _accuracy_measurement_send_data,R30
; 0000 014C                 }
; 0000 014D 
; 0000 014E               }
_0xA3:
; 0000 014F 
; 0000 0150 
; 0000 0151            //} //if(CALIB_PROCESSING == 0)
; 0000 0152            //else
; 0000 0153            //{
; 0000 0154                 //flow_avg_max[flow_sample_counter] = average1;
; 0000 0155                 //flow_avg_min[flow_sample_counter] = average2;
; 0000 0156                 sum_avg_max += average1;
_0xA0:
	__GETD1SX 213
	CALL SUBOPT_0x35
	CALL __ADDF12
	__PUTD1SX 237
; 0000 0157                 sum_avg_min += average2;
	__GETD1SX 209
	CALL SUBOPT_0x36
	CALL __ADDF12
	__PUTD1SX 233
; 0000 0158                 diff_avg_max_min = average1 - average2;
	CALL SUBOPT_0x2B
; 0000 0159 
; 0000 015A                 if(flow_sample_counter== TIME_MASURE_LIMIT_CNTR)//(1000 / (PULSE_DURATION*2 + REST_DURATION*2)))
	CPI  R21,3
	BREQ PC+2
	RJMP _0xA4
; 0000 015B                 {
; 0000 015C 
; 0000 015D                     sum=0;
	LDI  R30,LOW(0)
	__CLRD1SX 241
; 0000 015E                    //sum_avg_max = 0;
; 0000 015F                    // sum_avg_min = 0;
; 0000 0160                     avg_sum_max = 0;
	__CLRD1SX 221
; 0000 0161                     avg_sum_min = 0;
	__CLRD1SX 217
; 0000 0162                     diff_avg_max_min = 0;
	CALL SUBOPT_0x2E
; 0000 0163                     /*for(counter=0 ; counter <= flow_sample_counter ; counter++)
; 0000 0164                     {
; 0000 0165                         //sum+=flow[counter];
; 0000 0166                         sum_avg_max += flow_avg_max[counter];
; 0000 0167                       //  printf("flow_avg_max %d %4.3f sum_avg_max % 4.3f\n",counter,flow_avg_max[counter],sum_avg_max) ...
; 0000 0168                         sum_avg_min += flow_avg_min[counter];
; 0000 0169 
; 0000 016A                     }
; 0000 016B                     */
; 0000 016C 
; 0000 016D                     avg_sum_max = (float)(sum_avg_max/(float)(flow_sample_counter+1.0));
	MOV  R30,R21
	CALL SUBOPT_0x3
	CALL SUBOPT_0x8
	CALL __ADDF12
	CALL SUBOPT_0x35
	CALL SUBOPT_0x37
; 0000 016E                     avg_sum_min = (float)(sum_avg_min/(float)(flow_sample_counter+1.0));
	MOV  R30,R21
	CALL SUBOPT_0x3
	CALL SUBOPT_0x8
	CALL __ADDF12
	CALL SUBOPT_0x36
	CALL SUBOPT_0x38
; 0000 016F                    // printf("sample_before_window %4.3f sum %4.3f\n",avg_sum_min,sum_avg_min);
; 0000 0170                     avg_sum_min_arr[insert_idx] = avg_sum_min;
	__GETB1SX 273
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x39
	CALL SUBOPT_0x23
; 0000 0171                     avg_sum_max_arr[insert_idx] = avg_sum_max;
	__GETB1SX 273
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x3A
; 0000 0172 
; 0000 0173                     if(insert_idx == SHIFT_DETERMINED_LENGTH - 1)
	__GETB2SX 273
	CPI  R26,LOW(0x7)
	BRNE _0xA5
; 0000 0174                         insert_idx = 0;
	LDI  R30,LOW(0)
	__PUTB1SX 273
; 0000 0175                     else
	RJMP _0xA6
_0xA5:
; 0000 0176                         insert_idx++;
	MOVW R26,R28
	SUBI R26,LOW(-(273))
	SBCI R27,HIGH(-(273))
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0177                    //  printf("insert_idx %d shift_len %d avg_sum_min %4.3f\n",insert_idx,shift_lenght,avg_sum_min);
; 0000 0178                     for(idx=0;idx < SHIFT_DETERMINED_LENGTH; idx++)
_0xA6:
	LDI  R19,LOW(0)
_0xA8:
	CPI  R19,8
	BRSH _0xA9
; 0000 0179                     {
; 0000 017A                         sum_avg_sum_min += avg_sum_min_arr[idx];
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	CALL SUBOPT_0xD
	CALL SUBOPT_0x3B
	CALL __ADDF12
	STS  _sum_avg_sum_min,R30
	STS  _sum_avg_sum_min+1,R31
	STS  _sum_avg_sum_min+2,R22
	STS  _sum_avg_sum_min+3,R23
; 0000 017B                         sum_avg_sum_max += avg_sum_max_arr[idx];
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0xD
	CALL SUBOPT_0x3C
	CALL __ADDF12
	STS  _sum_avg_sum_max,R30
	STS  _sum_avg_sum_max+1,R31
	STS  _sum_avg_sum_max+2,R22
	STS  _sum_avg_sum_max+3,R23
; 0000 017C                     }
	SUBI R19,-1
	RJMP _0xA8
_0xA9:
; 0000 017D                     avg_sum_min = (float)(sum_avg_sum_min / (float)(SHIFT_DETERMINED_LENGTH));
	CALL SUBOPT_0x3B
	__GETD1N 0x41000000
	CALL SUBOPT_0x38
; 0000 017E                     avg_sum_max = (float)(sum_avg_sum_max / (float)(SHIFT_DETERMINED_LENGTH));
	CALL SUBOPT_0x3C
	__GETD1N 0x41000000
	CALL SUBOPT_0x37
; 0000 017F                    // printf("sample %4.3f sum %4.3f\n",avg_sum_min,sum_avg_sum_min);
; 0000 0180                    if (zeroAdjusting == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0xAA
; 0000 0181                     {
; 0000 0182                             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0183                             send_array[0] = avg_sum_min;
	__GETD1SX 217
	CALL SUBOPT_0x21
; 0000 0184                             send_array[1] = avg_sum_max;
	CALL SUBOPT_0x3A
; 0000 0185                             sendParamsFloat(send_array,2);
	CALL SUBOPT_0x17
	LDI  R26,LOW(2)
	RCALL _sendParamsFloat
; 0000 0186                     }
; 0000 0187 
; 0000 0188                     diff_avg_max_min = (avg_sum_max - avg_sum_min);
_0xAA:
	CALL SUBOPT_0x39
	__GETD1SX 221
	CALL __SUBF12
	__PUTD1SX 229
; 0000 0189                     if(startSendingDiffValues)
	TST  R7
	BREQ _0xAB
; 0000 018A                     {
; 0000 018B                         send_f(diff_avg_max_min);
	CALL SUBOPT_0x3D
	RCALL _send_f
; 0000 018C                         rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 018D                     }
; 0000 018E                    /* dbi_final = 1.7;
; 0000 018F                      if(dbi_final > 0.800)
; 0000 0190                         {
; 0000 0191                             TCCR1B |= 0x03;
; 0000 0192                             db_changed = 1;
; 0000 0193                         }
; 0000 0194                         else
; 0000 0195                             TCCR1B &= 0xF8;
; 0000 0196                             */
; 0000 0197 
; 0000 0198                     if(gain != 0 && offset != 0)
_0xAB:
	CALL SUBOPT_0x20
	CALL __CPD02
	BREQ _0xAD
	CALL SUBOPT_0x22
	CALL __CPD02
	BRNE _0xAE
_0xAD:
	RJMP _0xAC
_0xAE:
; 0000 0199                     {
; 0000 019A                         dbi_temp = (diff_avg_max_min - offset)/gain;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
	__PUTD1SX 177
; 0000 019B                         if(diff_avg_max_min < (offset / 2.0))
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3D
	CALL __CMPF12
	BRSH _0xAF
; 0000 019C                             DIRECTION = 1;
	SBI  0x12,6
; 0000 019D                         else
	RJMP _0xB2
_0xAF:
; 0000 019E                             DIRECTION = 0;
	CBI  0x12,6
; 0000 019F 
; 0000 01A0                         dbi_final = fabs(dbi_temp);// + 0.2;
_0xB2:
	__GETD2SX 177
	CALL _fabs
	CALL SUBOPT_0x34
; 0000 01A1 
; 0000 01A2                         if(dbi_final > 0.800)
	CALL SUBOPT_0x6
	__GETD1N 0x3F4CCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0xB5
; 0000 01A3                         {
; 0000 01A4                             TCCR1B |= TIMER_PRESCALE;
	IN   R30,0x2E
	ORI  R30,LOW(0x3)
	OUT  0x2E,R30
; 0000 01A5                             db_changed = 1;
	LDI  R30,LOW(1)
	STS  _db_changed,R30
; 0000 01A6                         }
; 0000 01A7                         else
	RJMP _0xB6
_0xB5:
; 0000 01A8                             TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 01A9                     }
_0xB6:
; 0000 01AA 
; 0000 01AB                     if(db_monitoring)
_0xAC:
	TST  R11
	BREQ _0xB7
; 0000 01AC                     {
; 0000 01AD                         rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 01AE                         send_f(dbi_final);
	CALL SUBOPT_0x6
	RCALL _send_f
; 0000 01AF                     }
; 0000 01B0 
; 0000 01B1                     sum_avg_max = 0;
_0xB7:
	LDI  R30,LOW(0)
	__CLRD1SX 237
; 0000 01B2                     sum_avg_min = 0;
	__CLRD1SX 233
; 0000 01B3                     flow_sample_counter = 0;
	LDI  R21,LOW(0)
; 0000 01B4                     sum_avg_sum_min = 0;
	STS  _sum_avg_sum_min,R30
	STS  _sum_avg_sum_min+1,R30
	STS  _sum_avg_sum_min+2,R30
	STS  _sum_avg_sum_min+3,R30
; 0000 01B5                     sum_avg_sum_max = 0;
	STS  _sum_avg_sum_max,R30
	STS  _sum_avg_sum_max+1,R30
	STS  _sum_avg_sum_max+2,R30
	STS  _sum_avg_sum_max+3,R30
; 0000 01B6                 }
; 0000 01B7                 else
	RJMP _0xB8
_0xA4:
; 0000 01B8                     flow_sample_counter++;
	SUBI R21,-1
; 0000 01B9            //}//if(CALIB_PROCESSING == 0)
; 0000 01BA         }//sample_ready_flag
_0xB8:
; 0000 01BB         else
	RJMP _0xB9
_0x99:
; 0000 01BC          sample_ready_flag = 0;
	CLR  R5
; 0000 01BD       }//while(1)
_0xB9:
	RJMP _0x71
; 0000 01BE }
_0xBA:
	RJMP _0xBA
; .FEND

	.CSEG
_memcpy:
; .FSTART _memcpy
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
; .FEND
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	JMP  _0x20E0004
; .FEND
_strchr:
; .FSTART _strchr
	ST   -Y,R26
    ld   r26,y+
    ld   r30,y+
    ld   r31,y+
strchr0:
    ld   r27,z
    cp   r26,r27
    breq strchr1
    adiw r30,1
    tst  r27
    brne strchr0
    clr  r30
    clr  r31
strchr1:
    ret
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

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	JMP  _0x20E0001
; .FEND
_put_usart_G102:
; .FSTART _put_usart_G102
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x18
	ADIW R28,3
	RET
; .FEND
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x18
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x18
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20E0004:
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
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
_0x2040016:
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
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x3E
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x3E
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x3F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x40
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x42
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
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
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x40
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
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
	CALL SUBOPT_0x43
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0003
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x43
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x44
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x44
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_fabs:
; .FSTART _fabs
	CALL __PUTPARD2
    ld   r30,y+
    ld   r31,y+
    ld   r22,y+
    ld   r23,y+
    cbr  r23,0x80
    ret
; .FEND
_atol:
; .FSTART _atol
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
__atol0:
    ld   r30,x
    push r26
	MOV  R26,R30
	CALL _isspace
    pop  r26
    tst  r30
    breq __atol1
    adiw r26,1
    rjmp __atol0
__atol1:
    clt
    ld   r30,x
    cpi  r30,'-'
    brne __atol2
    set
    rjmp __atol3
__atol2:
    cpi  r30,'+'
    brne __atol4
__atol3:
    adiw r26,1
__atol4:
    clr  r0
    clr  r1
    clr  r24
    clr  r25
__atol5:
    ld   r30,x
    push r26
	MOV  R26,R30
	CALL _isdigit
    pop  r26
    tst  r30
    breq __atol6
    movw r30,r0
    movw r22,r24
    rcall __atol8
    rcall __atol8
    add  r0,r30
    adc  r1,r31
    adc  r24,r22
    adc  r25,r23
    rcall __atol8
    ld   r30,x+
    clr  r31
    subi r30,'0'
    add  r0,r30
    adc  r1,r31
    adc  r24,r31
    adc  r25,r31
    rjmp __atol5
__atol6:
    movw r30,r0
    movw r22,r24
    brtc __atol7
    com  r30
    com  r31
    com  r22
    com  r23
    clr  r24
    adiw r30,1
    adc  r22,r24
    adc  r23,r24
__atol7:
    adiw r28,2
    ret

__atol8:
    lsl  r0
    rol  r1
    rol  r24
    rol  r25
    ret
; .FEND
_atof:
; .FSTART _atof
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	__CLRD1S 8
_0x206003C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x206003E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x206003C
_0x206003E:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R21,43
	BREQ _0x206006C
	CPI  R21,45
	BRNE _0x2060041
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x206006C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2060041:
	LDI  R30,LOW(0)
	MOV  R20,R30
	MOV  R21,R30
	__GETWRS 16,17,16
_0x2060042:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CALL _isdigit
	CPI  R30,0
	BRNE _0x2060045
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R21,R30
	CPI  R30,0
	BREQ _0x2060044
_0x2060045:
	OR   R20,R21
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2060042
_0x2060044:
	__GETWRS 18,19,16
	CPI  R20,0
	BREQ _0x2060047
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2060048:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x206004A
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x45
	CALL __CWD1
	CALL __CDF1
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x7
	CALL __DIVF21
	CALL SUBOPT_0x46
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	CALL SUBOPT_0x47
_0x206004B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x206004D
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x48
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x45
	CALL __ADDF12
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
	RJMP _0x206004B
_0x206004D:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R21,X
	CPI  R21,101
	BREQ _0x206004F
	CPI  R21,69
	BREQ _0x206004F
	RJMP _0x206004E
_0x206004F:
	LDI  R30,LOW(0)
	MOV  R20,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R21,X
	CPI  R21,43
	BREQ _0x206006D
	CPI  R21,45
	BRNE _0x2060053
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x206006D:
	__ADDWRN 18,19,1
_0x2060053:
_0x2060054:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x2060056
	LDI  R26,LOW(10)
	MULS R20,R26
	MOVW R30,R0
	ADD  R30,R21
	SUBI R30,LOW(48)
	MOV  R20,R30
	RJMP _0x2060054
_0x2060056:
	CPI  R20,39
	BRLO _0x2060057
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2060058
	__GETD1N 0xFF7FFFFF
	RJMP _0x20E0002
_0x2060058:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20E0002
_0x2060057:
	LDI  R21,LOW(32)
	CALL SUBOPT_0x47
_0x2060059:
	CPI  R21,0
	BREQ _0x206005B
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x48
	CALL __MULF12
	__PUTD1S 12
	MOV  R30,R20
	AND  R30,R21
	BREQ _0x206005C
	CALL SUBOPT_0x49
_0x206005C:
	LSR  R21
	RJMP _0x2060059
_0x206005B:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x206005D
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x45
	CALL __DIVF21
	RJMP _0x206006E
_0x206005D:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x45
	CALL __MULF12
_0x206006E:
	__PUTD1S 8
_0x206004E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206005F
	__GETD1S 8
	CALL __ANEGF1
	CALL SUBOPT_0x46
_0x206005F:
	__GETD1S 8
_0x20E0002:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2080003:
	SBIS 0xE,7
	RJMP _0x2080003
	IN   R30,0xF
_0x20E0001:
	ADIW R28,1
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

	.CSEG

	.DSEG
_ref_sensor_pulse_measurement_started:
	.BYTE 0x1
_ref_sensor_pulse_measurement_stopped:
	.BYTE 0x1
_measure_Q3_calib:
	.BYTE 0x1
_measure_Q2_calib:
	.BYTE 0x1
_accuracy_measurement:
	.BYTE 0x1
_measure_Q3_calib_send_data:
	.BYTE 0x1
_measure_Q2_calib_send_data:
	.BYTE 0x1
_accuracy_measurement_send_data:
	.BYTE 0x1
_pulse_is_detected:
	.BYTE 0x1
_calibration_changed:
	.BYTE 0x1
_wd_monitoring:
	.BYTE 0x1
_wd_test:
	.BYTE 0x1
_serial_number_applied:
	.BYTE 0x1
_read_max_samples:
	.BYTE 0x1
_read_min_samples:
	.BYTE 0x1
_dbi_final:
	.BYTE 0x4
_offset:
	.BYTE 0x4
_dbi_added_value:
	.BYTE 0x4
_gain:
	.BYTE 0x4
_pulse_duration_1:
	.BYTE 0x4
_dbi_Q3:
	.BYTE 0x4
_diff_Q3:
	.BYTE 0x4
_dbi_Q2:
	.BYTE 0x4
_diff_Q2:
	.BYTE 0x4
_sum_avg_sum_min:
	.BYTE 0x4
_sum_avg_sum_max:
	.BYTE 0x4
_ovf_timer0_cnt:
	.BYTE 0x4
_pulse_edge_cnt:
	.BYTE 0x4
_eeprom_serial_num:
	.BYTE 0x4
_db_changed:
	.BYTE 0x1
_state_S0000001000:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0xFA
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_state_S0000006000:
	.BYTE 0x1
_counter_S0000006000:
	.BYTE 0x1
_wathchdog_counter_S000000E000:
	.BYTE 0x2
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__GETD2S 4
	CALL __ORD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R0
	ST   -Y,R1
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R31,0
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R30,_rx_wr_index
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0x4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	LDS  R26,_dbi_final
	LDS  R27,_dbi_final+1
	LDS  R24,_dbi_final+2
	LDS  R25,_dbi_final+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1N 0x40000000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LDS  R30,_counter_S0000006000
	SUBI R30,-LOW(1)
	STS  _counter_S0000006000,R30
	LDS  R26,_counter_S0000006000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0x3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,24
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _offset,R30
	STS  _offset+1,R30
	STS  _offset+2,R30
	STS  _offset+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	STS  _gain,R30
	STS  _gain+1,R30
	STS  _gain+2,R30
	STS  _gain+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	STS  _eeprom_serial_num,R30
	STS  _eeprom_serial_num+1,R31
	STS  _eeprom_serial_num+2,R22
	STS  _eeprom_serial_num+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	CLR  R27
	CALL __EEPROMRDD
	STS  _gain,R30
	STS  _gain+1,R31
	STS  _gain+2,R22
	STS  _gain+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	CLR  R27
	CALL __EEPROMRDD
	STS  _offset,R30
	STS  _offset+1,R31
	STS  _offset+2,R22
	STS  _offset+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDS  R30,_gain
	LDS  R31,_gain+1
	LDS  R22,_gain+2
	LDS  R23,_gain+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R30,_offset
	LDS  R31,_offset+1
	LDS  R22,_offset+2
	LDS  R23,_offset+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
	MOVW R30,R28
	SUBI R30,LOW(-(181))
	SBCI R31,HIGH(-(181))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R19,LOW(0)
	MOVW R30,R28
	SUBI R30,LOW(-(278))
	SBCI R31,HIGH(-(278))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(278))
	SBCI R27,HIGH(-(278))
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	STS  _gain,R30
	STS  _gain+1,R31
	STS  _gain+2,R22
	STS  _gain+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	STS  _offset,R30
	STS  _offset+1,R31
	STS  _offset+2,R22
	STS  _offset+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(187)
	CALL __EEPROMWRB
	RCALL SUBOPT_0x14
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __EEPROMWRD
	RCALL SUBOPT_0x15
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL __EEPROMWRD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDS  R30,_dbi_Q3
	LDS  R31,_dbi_Q3+1
	LDS  R22,_dbi_Q3+2
	LDS  R23,_dbi_Q3+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDS  R26,_gain
	LDS  R27,_gain+1
	LDS  R24,_gain+2
	LDS  R25,_gain+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x21:
	__PUTD1SX 181
	MOVW R30,R28
	SUBI R30,LOW(-(181))
	SBCI R31,HIGH(-(181))
	ADIW R30,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x22:
	LDS  R26,_offset
	LDS  R27,_offset+1
	LDS  R24,_offset+2
	LDS  R25,_offset+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x23:
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(2)
	CALL _sendParamsFloat
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x23
	MOVW R30,R28
	SUBI R30,LOW(-(181))
	SBCI R31,HIGH(-(181))
	ADIW R30,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL __CDF1U
	CALL __PUTDP1
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__GETD2SX 261
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	__GETD2SX 257
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDS  R30,_pulse_edge_cnt
	LDS  R31,_pulse_edge_cnt+1
	LDS  R22,_pulse_edge_cnt+2
	LDS  R23,_pulse_edge_cnt+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x2B:
	__GETD2SX 209
	__GETD1SX 213
	CALL __SUBF12
	__PUTD1SX 229
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETD1SX 229
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	__GETD2SX 225
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	__CLRD1SX 229
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2F:
	__GETD1SX 201
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	__GETD1SX 205
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x2F
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x32:
	__GETD2SX 205
	RCALL SUBOPT_0x23
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x14
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	STS  _dbi_final,R30
	STS  _dbi_final+1,R31
	STS  _dbi_final+2,R22
	STS  _dbi_final+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	__GETD2SX 237
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	__GETD2SX 233
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	CALL __DIVF21
	__PUTD1SX 221
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	CALL __DIVF21
	__PUTD1SX 217
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	__GETD2SX 217
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	__GETD2SX 221
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDS  R26,_sum_avg_sum_min
	LDS  R27,_sum_avg_sum_min+1
	LDS  R24,_sum_avg_sum_min+2
	LDS  R25,_sum_avg_sum_min+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDS  R26,_sum_avg_sum_max
	LDS  R27,_sum_avg_sum_max+1
	LDS  R24,_sum_avg_sum_max+2
	LDS  R25,_sum_avg_sum_max+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD2SX 229
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x41:
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
SUBOPT_0x42:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	__GETD1N 0x3F800000
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x7
	CALL __MULF12
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD1S 12
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

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

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
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

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
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

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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
