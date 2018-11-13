
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : long, width
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
	.DEF _sample_ready_flag=R5
	.DEF _zeroAdjusting=R4
	.DEF _startSendingDiffValues=R7
	.DEF _stopSendingDiffValues=R6
	.DEF _flewValueChanged=R9
	.DEF _reade2prom1=R8
	.DEF _reade2prom2=R11
	.DEF _db_monitoring=R10
	.DEF _offset_changed=R13
	.DEF _send_offset=R12

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x0
_0x4:
	.DB  0x0
_0x5:
	.DB  0x0
_0x6:
	.DB  0x0
_0x7:
	.DB  0x0
_0x8:
	.DB  0x0
_0x9:
	.DB  0x0
_0xA:
	.DB  0x0
_0xB:
	.DB  0x0
_0xC:
	.DB  0x0
_0xD:
	.DB  0x0
_0xE:
	.DB  0x0
_0xF:
	.DB  0x0
_0x10:
	.DB  0x0
_0x11:
	.DB  0x0
_0x12:
	.DB  0x0
_0x13:
	.DB  0x0
_0x14:
	.DB  0x0
_0x15:
	.DB  0x0
_0x16:
	.DB  0x0
_0x17:
	.DB  0x0
_0x18:
	.DB  0x0
_0x19:
	.DB  0x0
_0x1A:
	.DB  0x0
_0x1B:
	.DB  0x0
_0x1C:
	.DB  0x0
_0x1D:
	.DB  0x0
_0x1E:
	.DB  0x0
_0x1F:
	.DB  0x0
_0x20:
	.DB  0x0
_0x21:
	.DB  0x0
_0x22:
	.DB  0x0
_0x23:
	.DB  0x0
_0x24:
	.DB  0x0
_0x25:
	.DB  0x0
_0x26:
	.DB  0x0
_0x27:
	.DB  0x0,0x0,0x0,0x0
_0x28:
	.DB  0x0,0x0,0x0,0x0
_0x29:
	.DB  0x0,0x0,0x0,0x0
_0x2A:
	.DB  0x0,0x0,0x0,0x0
_0x2B:
	.DB  0x0,0x0,0x0,0x0
_0x2C:
	.DB  0x0,0x0,0x0,0x0
_0x2D:
	.DB  0x0,0x0,0x0,0x0
_0x2E:
	.DB  0x0,0x0,0x0,0x0
_0x2F:
	.DB  0x0,0x0,0x0,0x0
_0x30:
	.DB  0x0,0x0,0x0,0x0
_0x31:
	.DB  0x0,0x0,0x0,0x0
_0x32:
	.DB  0x0,0x0,0x0,0x0
_0x33:
	.DB  0x0,0x0,0x0,0x0
_0x34:
	.DB  0x0,0x0,0x0,0x0
_0x35:
	.DB  0x0,0x0,0x0,0x0
_0x36:
	.DB  0x0,0x0,0x0,0x0
_0x37:
	.DB  0x1
_0x38:
	.DB  0x0,0x0
_0x39:
	.DB  0x0,0x0
_0x3A:
	.DB  0x0,0x0,0x0,0x0
_0x3B:
	.DB  0x0,0x0,0x0,0x0
_0x3C:
	.DB  0x0,0x0,0x0,0x0
_0x3D:
	.DB  0x0
_0x3E:
	.DB  0x0
_0x49:
	.DB  0x0
_0x57:
	.DB  0x0
_0x58:
	.DB  0x0
_0x59:
	.DB  0x0
_0x62:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x67:
	.DB  0x0
_0x68:
	.DB  0x0
_0xD6:
	.DB  0x0,0x0,0x80,0x3F,0x0,0x0,0x0,0x0
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
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0
_0x0:
	.DB  0x25,0x34,0x2E,0x33,0x66,0x0,0x63,0x68
	.DB  0x65,0x63,0x6B,0x5F,0x62,0x79,0x74,0x65
	.DB  0x20,0x25,0x78,0x20,0x70,0x75,0x6C,0x73
	.DB  0x65,0x43,0x68,0x65,0x63,0x6B,0x20,0x25
	.DB  0x78,0xA,0x0,0x53,0x49,0x47,0x4E,0x20
	.DB  0x73,0x65,0x74,0x20,0x74,0x6F,0x20,0x25
	.DB  0x64,0xA,0x0,0x53,0x49,0x47,0x4E,0x20
	.DB  0x73,0x65,0x74,0x20,0x74,0x6F,0x20,0x64
	.DB  0x65,0x66,0x61,0x75,0x6C,0x74,0x20,0x25
	.DB  0x64,0xA,0x0,0x70,0x75,0x6C,0x73,0x65
	.DB  0x4D,0x61,0x78,0x56,0x61,0x6C,0x75,0x65
	.DB  0x73,0x4C,0x69,0x6D,0x69,0x74,0x44,0x65
	.DB  0x66,0x61,0x75,0x6C,0x74,0x20,0x25,0x64
	.DB  0xA,0x0,0x70,0x75,0x6C,0x73,0x65,0x4D
	.DB  0x61,0x78,0x56,0x61,0x6C,0x75,0x65,0x73
	.DB  0x4C,0x69,0x6D,0x69,0x74,0x20,0x25,0x64
	.DB  0xA,0x0,0x64,0x69,0x66,0x66,0x53,0x61
	.DB  0x6D,0x70,0x6C,0x65,0x73,0x4C,0x69,0x6D
	.DB  0x69,0x74,0x20,0x64,0x65,0x66,0x61,0x75
	.DB  0x6C,0x74,0x20,0x25,0x64,0xA,0x0,0x64
	.DB  0x69,0x66,0x66,0x53,0x61,0x6D,0x70,0x6C
	.DB  0x65,0x73,0x4C,0x69,0x6D,0x69,0x74,0x20
	.DB  0x25,0x64,0xA,0x0,0x77,0x69,0x6E,0x5F
	.DB  0x73,0x69,0x7A,0x65,0x20,0x64,0x65,0x66
	.DB  0x61,0x75,0x6C,0x74,0x20,0x25,0x64,0xA
	.DB  0x0,0x77,0x69,0x6E,0x64,0x6F,0x77,0x53
	.DB  0x69,0x7A,0x65,0x20,0x25,0x64,0xA,0x0
	.DB  0x70,0x75,0x6C,0x73,0x65,0x57,0x69,0x64
	.DB  0x74,0x68,0x20,0x64,0x65,0x66,0x61,0x75
	.DB  0x6C,0x74,0x20,0x25,0x64,0xA,0x0,0x70
	.DB  0x75,0x6C,0x73,0x65,0x57,0x69,0x64,0x74
	.DB  0x68,0x20,0x25,0x64,0x20,0xA,0x0,0x67
	.DB  0x61,0x69,0x6E,0x20,0x25,0x34,0x2E,0x33
	.DB  0x66,0x20,0x6F,0x66,0x66,0x73,0x65,0x74
	.DB  0x20,0x25,0x34,0x2E,0x33,0x66,0x20,0x73
	.DB  0x65,0x72,0x69,0x61,0x6C,0x20,0x25,0x6C
	.DB  0x64,0x20,0x63,0x75,0x74,0x74,0x5F,0x6F
	.DB  0x66,0x66,0x20,0x25,0x34,0x2E,0x33,0x66
	.DB  0xA,0x0,0x67,0x61,0x69,0x6E,0x20,0x25
	.DB  0x34,0x2E,0x33,0x66,0x20,0x6F,0x66,0x66
	.DB  0x73,0x65,0x74,0x20,0x25,0x34,0x2E,0x33
	.DB  0x66,0x20,0x25,0x6C,0x75,0x20,0x63,0x75
	.DB  0x74,0x74,0x20,0x25,0x34,0x2E,0x33,0x66
	.DB  0xA,0x0
_0x2000003:
	.DB  0x0,0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060060:
	.DB  0x1,0x0,0x0,0x0
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _calibration_applied
	.DW  _0x3*2

	.DW  0x01
	.DW  _ref_sensor_pulse_measurement_started
	.DW  _0x4*2

	.DW  0x01
	.DW  _ref_sensor_pulse_measurement_stopped
	.DW  _0x5*2

	.DW  0x01
	.DW  _measure_Q3_calib
	.DW  _0x6*2

	.DW  0x01
	.DW  _measure_Q2_calib
	.DW  _0x7*2

	.DW  0x01
	.DW  _accuracy_measurement
	.DW  _0x8*2

	.DW  0x01
	.DW  _measure_Q3_calib_send_data
	.DW  _0x9*2

	.DW  0x01
	.DW  _measure_Q2_calib_send_data
	.DW  _0xA*2

	.DW  0x01
	.DW  _accuracy_measurement_send_data
	.DW  _0xB*2

	.DW  0x01
	.DW  _pulse_is_detected
	.DW  _0xC*2

	.DW  0x01
	.DW  _calibration_changed
	.DW  _0xD*2

	.DW  0x01
	.DW  _wd_monitoring
	.DW  _0xE*2

	.DW  0x01
	.DW  _wd_test
	.DW  _0xF*2

	.DW  0x01
	.DW  _serial_number_applied
	.DW  _0x10*2

	.DW  0x01
	.DW  _min_max_cnt_cmd
	.DW  _0x11*2

	.DW  0x01
	.DW  _current_sample_min
	.DW  _0x12*2

	.DW  0x01
	.DW  _current_sample_max
	.DW  _0x13*2

	.DW  0x01
	.DW  _PulseWidthSettingApplied
	.DW  _0x14*2

	.DW  0x01
	.DW  _cutt_off_changed
	.DW  _0x15*2

	.DW  0x01
	.DW  _start_fout_test
	.DW  _0x16*2

	.DW  0x01
	.DW  _stop_fout_test
	.DW  _0x17*2

	.DW  0x01
	.DW  _windowSizeChanged
	.DW  _0x18*2

	.DW  0x01
	.DW  _windowSize
	.DW  _0x19*2

	.DW  0x01
	.DW  _windowSizeTemp
	.DW  _0x1A*2

	.DW  0x01
	.DW  _insert_idx
	.DW  _0x1B*2

	.DW  0x01
	.DW  _respose_uart_activity
	.DW  _0x1C*2

	.DW  0x01
	.DW  _ep_positive_pulse_measurement
	.DW  _0x1D*2

	.DW  0x01
	.DW  _ep_negative_pulse_measurement
	.DW  _0x1E*2

	.DW  0x01
	.DW  _ep_check_cmd
	.DW  _0x1F*2

	.DW  0x01
	.DW  _ep_change_diff_samples_limit_flag
	.DW  _0x20*2

	.DW  0x01
	.DW  _ep_change_pulse_limit_flag
	.DW  _0x21*2

	.DW  0x01
	.DW  _inverseSignCmd
	.DW  _0x22*2

	.DW  0x01
	.DW  _read_max_samples
	.DW  _0x23*2

	.DW  0x01
	.DW  _read_min_samples
	.DW  _0x24*2

	.DW  0x01
	.DW  _pulseWidthTemp
	.DW  _0x25*2

	.DW  0x01
	.DW  _generate_fout_test
	.DW  _0x26*2

	.DW  0x04
	.DW  _dbi_final
	.DW  _0x27*2

	.DW  0x04
	.DW  _offset
	.DW  _0x28*2

	.DW  0x04
	.DW  _dbi_added_value
	.DW  _0x29*2

	.DW  0x04
	.DW  _gain
	.DW  _0x2A*2

	.DW  0x04
	.DW  _pulse_duration_1
	.DW  _0x2B*2

	.DW  0x04
	.DW  _dbi_Q3
	.DW  _0x2C*2

	.DW  0x04
	.DW  _diff_Q3
	.DW  _0x2D*2

	.DW  0x04
	.DW  _dbi_Q2
	.DW  _0x2E*2

	.DW  0x04
	.DW  _diff_Q2
	.DW  _0x2F*2

	.DW  0x04
	.DW  _sum_avg_sum_min
	.DW  _0x30*2

	.DW  0x04
	.DW  _sum_avg_sum_max
	.DW  _0x31*2

	.DW  0x04
	.DW  _sum_avg_curr_sum_max
	.DW  _0x32*2

	.DW  0x04
	.DW  _sum_avg_curr_sum_min
	.DW  _0x33*2

	.DW  0x04
	.DW  _avg_curr_sum_max
	.DW  _0x34*2

	.DW  0x04
	.DW  _eeprom_avg_curr_sum_max
	.DW  _0x35*2

	.DW  0x04
	.DW  _cutt_off
	.DW  _0x36*2

	.DW  0x01
	.DW  _signValue
	.DW  _0x37*2

	.DW  0x02
	.DW  _pulseMaxValuesLimit
	.DW  _0x38*2

	.DW  0x02
	.DW  _diffSamplesLimit
	.DW  _0x39*2

	.DW  0x04
	.DW  _ovf_timer0_cnt
	.DW  _0x3A*2

	.DW  0x04
	.DW  _pulse_edge_cnt
	.DW  _0x3B*2

	.DW  0x04
	.DW  _eeprom_serial_num
	.DW  _0x3C*2

	.DW  0x01
	.DW  _db_changed
	.DW  _0x3D*2

	.DW  0x01
	.DW  _pulseWidth
	.DW  _0x3E*2

	.DW  0x01
	.DW  _state_S0000002000
	.DW  _0x49*2

	.DW  0x01
	.DW  _rx_wr_index
	.DW  _0x57*2

	.DW  0x01
	.DW  _rx_rd_index
	.DW  _0x58*2

	.DW  0x01
	.DW  _rx_counter
	.DW  _0x59*2

	.DW  0x01
	.DW  _state_S0000007000
	.DW  _0x67*2

	.DW  0x01
	.DW  _counter_S0000007000
	.DW  _0x68*2

	.DW  0x04
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
	.ORG 0x460

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
;#include "math.h"
;//frame 240ms pulse_pos 80ms rest_pos 40ms pulse_neg 80ms rest_neg 40ms
;// parametrize program
;/*
;    to run test program comment CALIB_ENABLE and DEBUG uncommenct TEST_PROGRAM
;    to run calibration program comment TEST_PROGRAM , DEBUG uncomment CALIB_ENABLE
;    to calib manually comment lines CALIB_ENABLE,TEST_PROGRAM uncomment DEBUG
;*/
;//#define TEST_PROGRAM
;//#define DEBUG
;#define CS          PORTB.4
;#define L298_I1     PORTA.1
;#define L298_I2     PORTA.2
;#define L298_EN     PORTA.3
;//#define LED_G       PORTC.3
;#define LED         PORTC.4
;#define DIRECTION   PORTD.6
;#define EMPTY_PIPE  PORTD.7
;
;
;
;#define FACTORY_TEST   PIND.2   // C1  R31
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
;#define CURRENT_SAMPLE_DURATION 5
;#define TIME_MASURE_LIMIT_CNTR 1000/(PULSE_DURATION*2)
;
;#define LITER_PER_PULSE 10000.0
;#define MAX_ELEMENT_CNT 8
;#define SERIAL_ADDR      0x01
;#define GAIN_ADDR        0x05
;#define OFFSET_ADDR      0x09
;#define CURR_ADDR        0x0D
;#define CUTT_OFF_ADDR    0x11
;#define PULSE_WIDTH_VALID 0x15
;#define PULSE_WIDTH_ADDR 0x16
;#define WINDOW_SIZE_VALID_ADDR 0x17
;#define WINDOW_SIZE_ADDR 0x18
;#define EP_SAMPLES_LIMIT_VALID_ADDR 0x19
;#define EP_SAMPLES_LIMIT_ADDR 0x1a
;#define EP_PULSE_MAX_VALUE_LIMIT_VALID_ADDR 0x1b
;#define EP_PULSE_MAX_VALUE_LIMIT_ADDR 0x1c
;#define SIGN_VALID_ADDR   0x1d
;#define SIGN_ADDR   0x1e
;
;#define EP_MEASUREMENT 3
;#define NO_EP       0
;#define PULSE_LEVEL 1
;#define DBI_VALUE 2
;#define SAMPLE_DIFF_LEVEL 3
;
;
;#define SERIAL_NUMBER    12345678
;#define SHIFT_LENGHT_MAX 22
;#define SHIFT_DETERMINED_LENGTH  8
;#define EP_PULSE_MAX_VALUE_LIMIT      3900
;#define EP_SAMPLES_LIMIT    250
;#define CUTT_OFF 0.5
;#define VERSION 4.0
;//#define RANGE_2   // above 2.5inch
;#ifdef RANGE_2
;    #define TIMER_PRESCALE 0x03  // divide by 4
;    #define TIMER_DIVIDER 3.9263
;#else
;    #define TIMER_PRESCALE 0x05  // divide by 4
;    #define TIMER_DIVIDER 62.821//64
;#endif
;
;
;unsigned char sample_ready_flag = 0;
;unsigned char zeroAdjusting = 0, startSendingDiffValues = 0, stopSendingDiffValues = 0,
;            flewValueChanged = 0, reade2prom1 = 0, reade2prom2 = 0 ,db_monitoring = 0, offset_changed = 0,
;            send_offset = 0, calibration_applied = 0, ref_sensor_pulse_measurement_started = 0,

	.DSEG
;            ref_sensor_pulse_measurement_stopped = 0, measure_Q3_calib = 0, measure_Q2_calib = 0,
;            accuracy_measurement = 0, measure_Q3_calib_send_data = 0, measure_Q2_calib_send_data = 0,
;            accuracy_measurement_send_data = 0, pulse_is_detected = 0, calibration_changed = 0,
;            wd_monitoring = 0, wd_test = 0, serial_number_applied = 0, min_max_cnt_cmd = 0,
;            current_sample_min = 0, current_sample_max = 0, PulseWidthSettingApplied = 0, cutt_off_changed = 0, start_fo ...
;            windowSizeChanged = 0, windowSize = 0, windowSizeTemp = 0, insert_idx = 0,
;            respose_uart_activity = 0,ep_positive_pulse_measurement = 0, ep_negative_pulse_measurement = 0, ep_check_cmd ...
;            ep_change_diff_samples_limit_flag = 0, ep_change_pulse_limit_flag = 0, inverseSignCmd = 0;
;
;
;unsigned char read_max_samples = 0, read_min_samples = 0, pulseWidthTemp = 0, generate_fout_test = 0 ;
;float dbi_final = 0, offset = 0, dbi_added_value = 0, gain = 0, pulse_duration_1 = 0,
;         dbi_Q3 = 0, diff_Q3 = 0, dbi_Q2 = 0, diff_Q2 = 0, sum_avg_sum_min = 0, sum_avg_sum_max = 0, sum_avg_curr_sum_ma ...
;         avg_curr_sum_max = 0, eeprom_avg_curr_sum_max = 0, cutt_off = 0 ;
;signed char signValue = 1;
;signed int pulseMaxValuesLimit = 0, diffSamplesLimit = 0;
;unsigned long int ovf_timer0_cnt = 0, pulse_edge_cnt = 0, eeprom_serial_num = 0;
;unsigned char db_changed = 0, pulseWidth = 0;
;
;void process_rx_buffer(void);
;void sendParamsMinMax(float * send_arr, unsigned char element_cnt);
;void sendParamsFloat(float * send_arr, unsigned char element_cnt);
;void send_f(float);
;//void sendAckResponse();
;void time2_init();
;// read adc
;
;signed int read_adc(unsigned char adc_input)
; 0000 001B {

	.CSEG
_read_adc:
; .FSTART _read_adc
;
;    ADMUX= adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
;    // Delay needed for the stabilization of the ADC input voltage
;    delay_us(10);
	__DELAY_USB 40
;    // Start the AD conversion
;    ADCSRA|=0x43;
	IN   R30,0x6
	ORI  R30,LOW(0x43)
	OUT  0x6,R30
;    // Wait for the AD conversion to complete
;    while ((ADCSRA & 0x10)==0);
_0x3F:
	SBIS 0x6,4
	RJMP _0x3F
;    ADCSRA|=0x10;
	SBI  0x6,4
;    return ADCW & 0x3FF;
	IN   R30,0x4
	IN   R31,0x4+1
	ANDI R31,HIGH(0x3FF)
	ADIW R28,1
	RET
;}
; .FEND
;signed long int spi_sampling()//unsigned  char *msb_shift,unsigned char *scnd_shift,unsigned char * lsb_shift
;{
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
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR4
;	data_msb_i -> R17
;	data_scnd_i -> R16
;	temp -> R18,R19
;	data -> Y+4
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
	SBI  0x18,4
;    delay_us(1);
	__DELAY_USB 4
;    CS = 0;
	CBI  0x18,4
;
;
;    data_msb_i = spi(0x55);
	LDI  R26,LOW(85)
	CALL _spi
	MOV  R17,R30
;    data_msb_i &= 0x1F;
	ANDI R17,LOW(31)
;
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
	SBI  0x18,4
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
;// Place your code here
;    static char state = START_MEASUREMENT;//, refPulseCounter = 0;

	.DSEG

	.CSEG
;
;    switch(state)
	LDS  R30,_state_S0000002000
	LDI  R31,0
;    {
;        case START_MEASUREMENT:
	SBIW R30,0
	BRNE _0x4D
;        if(measure_Q3_calib || measure_Q2_calib || accuracy_measurement)
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BRNE _0x4F
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BRNE _0x4F
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0x4E
_0x4F:
;        {
;            TCCR0 = TIMER_ON;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;            state = TIME_DETECT;
	LDI  R30,LOW(1)
	STS  _state_S0000002000,R30
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
_0x4E:
	LDI  R30,LOW(0)
	STS  _ref_sensor_pulse_measurement_stopped,R30
;        break;
	RJMP _0x4C
;        case TIME_DETECT:
_0x4D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4C
;            pulse_duration_1 = (TCNT0*0.004 + ovf_timer0_cnt*1.024);//
	IN   R30,0x32
	CALL SUBOPT_0x2
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
	CALL SUBOPT_0x3
;            if(pulse_duration_1 >= 30000.0)
	LDS  R26,_pulse_duration_1
	LDS  R27,_pulse_duration_1+1
	LDS  R24,_pulse_duration_1+2
	LDS  R25,_pulse_duration_1+3
	__GETD1N 0x46EA6000
	CALL __CMPF12
	BRLO _0x52
;            {
;                state = START_MEASUREMENT;
	STS  _state_S0000002000,R30
;                ref_sensor_pulse_measurement_stopped = 1;
	LDI  R30,LOW(1)
	STS  _ref_sensor_pulse_measurement_stopped,R30
;                if(measure_Q3_calib)
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BREQ _0x53
;                {
;                    measure_Q3_calib = 0;
	LDI  R30,LOW(0)
	STS  _measure_Q3_calib,R30
;                    measure_Q3_calib_send_data = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q3_calib_send_data,R30
;                }
;                if(measure_Q2_calib)
_0x53:
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BREQ _0x54
;                {
;                    measure_Q2_calib = 0;
	LDI  R30,LOW(0)
	STS  _measure_Q2_calib,R30
;                    measure_Q2_calib_send_data = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q2_calib_send_data,R30
;                }
;                if(accuracy_measurement)
_0x54:
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0x55
;                {
;                    accuracy_measurement = 0;
	LDI  R30,LOW(0)
	STS  _accuracy_measurement,R30
;                    accuracy_measurement_send_data = 1;
	LDI  R30,LOW(1)
	STS  _accuracy_measurement_send_data,R30
;                }
;                TCCR0 = TIMER_OFF;
_0x55:
	LDI  R30,LOW(0)
	OUT  0x33,R30
;            }
;            else
	RJMP _0x56
_0x52:
;                state = TIME_DETECT;
	LDI  R30,LOW(1)
	STS  _state_S0000002000,R30
;        break;
_0x56:
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
_0x4C:
;
;}
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

	.DSEG
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

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	CALL SUBOPT_0x4
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
	BRNE _0x5A
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
	BRNE _0x5B
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;   if (++rx_counter == RX_BUFFER_SIZE)
_0x5B:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0xFA)
	BRNE _0x5C
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
_0x5C:
	CALL SUBOPT_0x5
	BRNE _0x5D
;      {
;         process_rx_buffer();
	RCALL _process_rx_buffer
;      }
;   }
_0x5D:
;}
_0x5A:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x16D
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
	CALL SUBOPT_0x3
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
	CALL SUBOPT_0x4
;// Place your code here
;float result = 0, num = 0;
;unsigned long int temp = 0;
;
;  if (db_changed)
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x62*2)
	LDI  R31,HIGH(_0x62*2)
	CALL __INITLOCB
;	result -> Y+8
;	num -> Y+4
;	temp -> Y+0
	LDS  R30,_db_changed
	CPI  R30,0
	BRNE PC+2
	RJMP _0x63
;  {
;
;    db_changed = 0;
	LDI  R30,LOW(0)
	STS  _db_changed,R30
;
;
;    num = (((float)(1/(float)(dbi_final*10))*1000000)/2)/TIMER_DIVIDER;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL __DIVF21
	__GETD2N 0x49742400
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40000000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x427B48B4
	CALL __DIVF21
	CALL SUBOPT_0x9
;    //temp = (((float)(1/(float)(dbi_final*10))*1000000)/2)/TIMER_DIVIDER;
;    //temp += 1;
;    result = (num - floor(num) > 0.5) ? ceil(num) : floor(num);
	CALL SUBOPT_0xA
	CALL _floor
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x64
	CALL SUBOPT_0xA
	CALL _ceil
	RJMP _0x65
_0x64:
	CALL SUBOPT_0xA
	CALL _floor
_0x65:
	CALL SUBOPT_0xC
;    temp = (unsigned long int)result;
	CALL SUBOPT_0xD
	CALL __CFD1U
	CALL SUBOPT_0xE
;
;    OCR1AH= (temp & 0xFF00)>>8;
	CALL SUBOPT_0xF
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
_0x63:
	ADIW R28,12
_0x16D:
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
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
;{
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; // Place your code here
; // Place your code here
;    static char state=0,counter=0;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; //char str[16];
; //pulse generator procedure 80ms up 80ms lo 180ms idle
;
; switch(state)
	LDS  R30,_state_S0000007000
	LDI  R31,0
; {
;
;    case 0:
	SBIW R30,0
	BRNE _0x6C
;        if( counter >= EP_MEASUREMENT -1 )
	LDS  R26,_counter_S0000007000
	CPI  R26,LOW(0x2)
	BRLO _0x6D
;        {
;            ep_positive_pulse_measurement = 0;
	LDI  R30,LOW(0)
	STS  _ep_positive_pulse_measurement,R30
;            sample_ready_flag = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;            state = 1;
	STS  _state_S0000007000,R30
;        }
;        counter++;
_0x6D:
	CALL SUBOPT_0x10
;        break;
	RJMP _0x6B
;    case 1:
_0x6C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6E
;        if(sample_ready_flag == 1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x6F
;        {
;            //140- 20 - 5
;            state = 1;
	STS  _state_S0000007000,R30
;            counter++;
	CALL SUBOPT_0x10
;
;
;
;        }
;        else
	RJMP _0x70
_0x6F:
;
;        {
;
;            if(counter >= pulseWidth - SAMPLE_DURATION - CURRENT_SAMPLE_DURATION && counter <= pulseWidth - SAMPLE_DURAT ...
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	BRLT _0x72
	CALL SUBOPT_0x13
	BRGE _0x73
_0x72:
	RJMP _0x71
_0x73:
;                current_sample_max = 1;
	LDI  R30,LOW(1)
	RJMP _0x15D
;            else
_0x71:
;                current_sample_max = 0;
	LDI  R30,LOW(0)
_0x15D:
	STS  _current_sample_max,R30
;            // 140-20
;            if(counter >= pulseWidth - SAMPLE_DURATION && counter <= pulseWidth - 1) // 30 - 5
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	BRLT _0x76
	CALL SUBOPT_0x15
	BRGE _0x77
_0x76:
	RJMP _0x75
_0x77:
;            {
;               read_max_samples = 1;
	LDI  R30,LOW(1)
	RJMP _0x15E
;
;            }
;            else
_0x75:
;                read_max_samples = 0;
	LDI  R30,LOW(0)
_0x15E:
	STS  _read_max_samples,R30
;            counter++;
	CALL SUBOPT_0x10
;            if(counter == pulseWidth) //140
	LDS  R30,_pulseWidth
	LDS  R26,_counter_S0000007000
	CP   R30,R26
	BRNE _0x79
;            {
;                counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000007000,R30
;
;                //LED = 1;
;                //DIRECTION = 0;
;
;                L298_I1=0;
	CBI  0x1B,1
;                L298_I2=1;
	SBI  0x1B,2
;                ep_negative_pulse_measurement = 1;
	LDI  R30,LOW(1)
	STS  _ep_negative_pulse_measurement,R30
;                state=2;
	LDI  R30,LOW(2)
	STS  _state_S0000007000,R30
;            }
;        }
_0x79:
_0x70:
;    break;
	RJMP _0x6B
;    //---------
;    /*case 1:
;        counter++;
;        if(counter == REST_DURATION)
;        {
;            counter=0;
;
;            //DIRECTION = 0;
;            L298_I1=0;
;            L298_I2=1;
;            state=2;
;        }
;    break;
;    */
;    //---------
;    case 2:
_0x6E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x7E
;        if(counter < EP_MEASUREMENT - 1)
	LDS  R26,_counter_S0000007000
	CPI  R26,LOW(0x2)
	BRSH _0x7F
;        {
;            ep_negative_pulse_measurement = 1;
	LDI  R30,LOW(1)
	RJMP _0x15F
;        }
;        else
_0x7F:
;            ep_negative_pulse_measurement = 0;
	LDI  R30,LOW(0)
_0x15F:
	STS  _ep_negative_pulse_measurement,R30
;        if (counter < pulseWidth - SAMPLE_DURATION - CURRENT_SAMPLE_DURATION - 1)
	LDS  R30,_pulseWidth
	LDI  R31,0
	SBIW R30,26
	LDS  R26,_counter_S0000007000
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x81
;            respose_uart_activity = 1;
	LDI  R30,LOW(1)
	RJMP _0x160
;        else
_0x81:
;            respose_uart_activity = 0;
	LDI  R30,LOW(0)
_0x160:
	STS  _respose_uart_activity,R30
;        if(counter >= pulseWidth - SAMPLE_DURATION - CURRENT_SAMPLE_DURATION && counter <= pulseWidth - SAMPLE_DURATION  ...
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	BRLT _0x84
	CALL SUBOPT_0x13
	BRGE _0x85
_0x84:
	RJMP _0x83
_0x85:
;            current_sample_min = 1;
	LDI  R30,LOW(1)
	RJMP _0x161
;        else
_0x83:
;            current_sample_min = 0;
	LDI  R30,LOW(0)
_0x161:
	STS  _current_sample_min,R30
;        if(counter >= pulseWidth - SAMPLE_DURATION  && counter <= pulseWidth - 1)
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	BRLT _0x88
	CALL SUBOPT_0x15
	BRGE _0x89
_0x88:
	RJMP _0x87
_0x89:
;        {
;           read_min_samples = 1;
	LDI  R30,LOW(1)
	RJMP _0x162
;        }
;        else
_0x87:
;            read_min_samples = 0;
	LDI  R30,LOW(0)
_0x162:
	STS  _read_min_samples,R30
;        counter++;
	CALL SUBOPT_0x10
;        if(counter == pulseWidth)
	LDS  R30,_pulseWidth
	LDS  R26,_counter_S0000007000
	CP   R30,R26
	BRNE _0x8B
;        {
;            counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000007000,R30
;
;            //DIRECTION = 0;
;            //LED = 0;
;            L298_I1=1;
	SBI  0x1B,1
;            ep_positive_pulse_measurement = 1;
	LDI  R30,LOW(1)
	STS  _ep_positive_pulse_measurement,R30
;            L298_I2 = 0;
	CBI  0x1B,2
;            //sample_ready_flag=1;
;            pulseWidth = pulseWidthTemp;
	LDS  R30,_pulseWidthTemp
	STS  _pulseWidth,R30
;            windowSize = windowSizeTemp;
	LDS  R30,_windowSizeTemp
	STS  _windowSize,R30
;            state=0;
	LDI  R30,LOW(0)
	STS  _state_S0000007000,R30
;        }
;    break;
_0x8B:
	RJMP _0x6B
;    //---------
;    case 3:
_0x7E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6B
;   // if(counter == 1)
;   //   sample_ready_flag=1;
;    counter++;
	CALL SUBOPT_0x10
;
;    if(counter == REST_DURATION)
	LDS  R26,_counter_S0000007000
	CPI  R26,LOW(0x3C)
	BRNE _0x91
;    {
;        counter=0;
	LDI  R30,LOW(0)
	STS  _counter_S0000007000,R30
;
;        L298_I1=1;
	SBI  0x1B,1
;        //DIRECTION = 1;
;        L298_I2=0;
	CBI  0x1B,2
;
;        if(sample_ready_flag==0)
	TST  R5
	BRNE _0x96
;        {
;            state=0;
	STS  _state_S0000007000,R30
;
;        }
;    }
_0x96:
;    break;
_0x91:
; }
_0x6B:
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
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
_0x97:
	CALL SUBOPT_0x16
	BREQ _0x99
;        i++;
	SUBI R17,-1
	RJMP _0x97
_0x99:
	CALL SUBOPT_0x16
	BRNE _0x9B
	CALL SUBOPT_0x5
	BREQ _0x9C
_0x9B:
	RJMP _0x9A
_0x9C:
;    {
;        //LED_R =1;
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
	BRNE _0xA0
;                reade2prom1 = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
;                break;
	RJMP _0x9F
;            case 0x02:
_0xA0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA1
;                reade2prom2 = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;                break;
	RJMP _0x9F
;            case 0x03:
_0xA1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA2
;                offset_changed = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
;                break;
	RJMP _0x9F
;            case 0x05:
_0xA2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xA3
;                measure_Q3_calib = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q3_calib,R30
;                break;
	RJMP _0x9F
;            case 0x06:
_0xA3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xA4
;                measure_Q2_calib = 1;
	LDI  R30,LOW(1)
	STS  _measure_Q2_calib,R30
;                break;
	RJMP _0x9F
;            case 0x07:
_0xA4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xA5
;                calibration_applied = 1;
	LDI  R30,LOW(1)
	STS  _calibration_applied,R30
;                break;
	RJMP _0x9F
;            case 0x08:
_0xA5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xA6
;                calibration_changed = 1;
	LDI  R30,LOW(1)
	STS  _calibration_changed,R30
;                break;
	RJMP _0x9F
;            case 0x09:
_0xA6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xA7
;                accuracy_measurement = 1;
	LDI  R30,LOW(1)
	STS  _accuracy_measurement,R30
;                break;
	RJMP _0x9F
;            case 0x0a:
_0xA7:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xA8
;                wd_monitoring = 1;
	LDI  R30,LOW(1)
	STS  _wd_monitoring,R30
;                break;
	RJMP _0x9F
;            case 0x0b:
_0xA8:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xA9
;                wd_test = 1;
	LDI  R30,LOW(1)
	STS  _wd_test,R30
;                break;
	RJMP _0x9F
;            case 0x0c:
_0xA9:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xAA
;                serial_number_applied = 1;
	LDI  R30,LOW(1)
	STS  _serial_number_applied,R30
;                break;
	RJMP _0x9F
;            case 0x0D:
_0xAA:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xAB
;                cutt_off_changed = 1;
	LDI  R30,LOW(1)
	STS  _cutt_off_changed,R30
;                break;
	RJMP _0x9F
;            case 0x0e:
_0xAB:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xAC
;                PulseWidthSettingApplied = 1;
	LDI  R30,LOW(1)
	STS  _PulseWidthSettingApplied,R30
;                break;
	RJMP _0x9F
;            case 0x0f:
_0xAC:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xAD
;                start_fout_test = 1;
	LDI  R30,LOW(1)
	STS  _start_fout_test,R30
;                break;
	RJMP _0x9F
;            case 0x10:
_0xAD:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xAE
;                stop_fout_test = 1;
	LDI  R30,LOW(1)
	STS  _stop_fout_test,R30
;                break;
	RJMP _0x9F
;            case 0x11:
_0xAE:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xAF
;                zeroAdjusting = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
;                break;
	RJMP _0x9F
;            case 0x12:
_0xAF:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xB0
;                windowSizeChanged = 1;
	LDI  R30,LOW(1)
	STS  _windowSizeChanged,R30
;                break;
	RJMP _0x9F
;            case 0x13:
_0xB0:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xB1
;                ep_check_cmd = 1;
	LDI  R30,LOW(1)
	STS  _ep_check_cmd,R30
;                break;
	RJMP _0x9F
;            case 0x14:
_0xB1:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xB2
;                ep_change_diff_samples_limit_flag = 1;
	LDI  R30,LOW(1)
	STS  _ep_change_diff_samples_limit_flag,R30
;                break;
	RJMP _0x9F
;            case 0x15:
_0xB2:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xB3
;                ep_change_pulse_limit_flag = 1;
	LDI  R30,LOW(1)
	STS  _ep_change_pulse_limit_flag,R30
;                break;
	RJMP _0x9F
;            case 0x16:
_0xB3:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xB4
;                inverseSignCmd = 1;
	LDI  R30,LOW(1)
	STS  _inverseSignCmd,R30
;                break;
	RJMP _0x9F
;            case 0x33:
_0xB4:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xB5
;                startSendingDiffValues = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
;                break;
	RJMP _0x9F
;            case 0x44:
_0xB5:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xB6
;                stopSendingDiffValues = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;                break;
	RJMP _0x9F
;            case 0x88:
_0xB6:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x9F
;                flewValueChanged = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
;                break;
;        }
_0x9F:
;    }
; }
_0x9A:
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
	CALL SUBOPT_0x17
	__GETD1S 56
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x19
	LDI  R30,LOW(4)
	ST   X,R30
;      //  send[size++] = 10;
;        for(i = 0; i < size; i++)
	LDI  R16,LOW(0)
_0xB9:
	CP   R16,R17
	BRSH _0xBA
;            putchar(send[i]);
	MOV  R30,R16
	CALL SUBOPT_0x19
	LD   R26,X
	CALL _putchar
	SUBI R16,-1
	RJMP _0xB9
_0xBA:
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
_0xBC:
	__GETB1SX 104
	CP   R18,R30
	BRSH _0xBD
;  {
;   //send[i++] = 3;
;   sprintf(temp,"%4.3f",send_arr[cnt]);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x17
	MOV  R30,R18
	__GETW2SX 109
	LDI  R31,0
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x1B
	MOV  R26,R17
	CLR  R27
	CALL _memcpy
;   i += size;
	ADD  R16,R17
;   send[i++] = ',';
	CALL SUBOPT_0x1C
	LDI  R30,LOW(44)
	ST   X,R30
;  }
	SUBI R18,-1
	RJMP _0xBC
_0xBD:
;  i--;
	SUBI R16,1
;  send[i++] = 4;
	CALL SUBOPT_0x1C
	LDI  R30,LOW(4)
	ST   X,R30
;   //send[i] = 10;
;   //*/
;   for(k = 0; k < i; k++)
	LDI  R19,LOW(0)
_0xBF:
	CP   R19,R16
	BRSH _0xC0
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
	RJMP _0xBF
_0xC0:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,44
	RET
; .FEND
;void sendParamsMinMax(float * send_arr, unsigned char element_cnt)
;{
;   char send[80];
;   //char temp;
;   char i =0 , k = 0, cnt = 0;
;  //send_f(min);
;  i = 0;
;	*send_arr -> Y+85
;	element_cnt -> Y+84
;	send -> Y+4
;	i -> R17
;	k -> R16
;	cnt -> R19
;  send[0] = 0x03;
;  //send[1] = element_cnt;
;  i = 1;
;  for(cnt = 0; cnt < element_cnt; cnt++)
;  {
;   //send[i++] = 3;
;   //sprintf(temp,"%4.3f",send_arr[cnt]);
;   unsigned int *temp = (unsigned int *)(send_arr+cnt);
;   //size = strlen(temp);
;   memcpy(send+i,temp,4);
;	*send_arr -> Y+87
;	element_cnt -> Y+86
;	send -> Y+6
;	*temp -> Y+0
;   i += 4;//size;
;   //send[i++] = ',';
;  }
;  //i++;
;  send[i++] = 0x4;
;   //send[i] = 10;
;   //*/
;   for(k = 0; k < i; k++)
;      putchar(send[k]);
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
;   unsigned char pulseWidthCheckByte = eeprom_read_byte(PULSE_WIDTH_VALID);
;   unsigned char winSizeCheckByte = eeprom_read_byte(WINDOW_SIZE_VALID_ADDR);
;   unsigned char ep_pulse_max_value_limit =  eeprom_read_byte(EP_PULSE_MAX_VALUE_LIMIT_VALID_ADDR);
;   unsigned char ep_samples_limit =  eeprom_read_byte(EP_SAMPLES_LIMIT_ADDR);
;   signed char signVal =  eeprom_read_byte(SIGN_VALID_ADDR);
;  // eeprom_serial_num = eeprom_read_dword(SERIAL_ADDR);
;   printf("check_byte %x pulseCheck %x\n",winSizeCheckByte,pulseWidthCheckByte);
	SBIW R28,1
	CALL __SAVELOCR6
;	addr -> R17
;	check_byte -> R16
;	pulseWidthCheckByte -> R19
;	winSizeCheckByte -> R18
;	ep_pulse_max_value_limit -> R21
;	ep_samples_limit -> R20
;	signVal -> Y+6
	LDI  R17,0
	CALL SUBOPT_0x1D
	MOV  R16,R30
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL __EEPROMRDB
	MOV  R19,R30
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	CALL __EEPROMRDB
	MOV  R18,R30
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	CALL __EEPROMRDB
	MOV  R21,R30
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	CALL __EEPROMRDB
	MOV  R20,R30
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	CALL __EEPROMRDB
	STD  Y+6,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R18
	CALL SUBOPT_0x1E
	MOV  R30,R19
	CALL SUBOPT_0x1E
	LDI  R24,8
	CALL _printf
	ADIW R28,10
;   if(signVal != 0x55)
	LDD  R26,Y+6
	CPI  R26,LOW(0x55)
	BREQ _0xC7
;   {
;        signValue = 1;
	LDI  R30,LOW(1)
	STS  _signValue,R30
;        eeprom_write_byte(SIGN_ADDR,signVal);
	LDD  R30,Y+6
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	CALL __EEPROMWRB
;        printf("SIGN set to %d\n",signValue);
	__POINTW1FN _0x0,35
	RJMP _0x163
;   }
;   else
_0xC7:
;   {
;        addr = SIGN_ADDR;
	LDI  R17,LOW(30)
;        signValue = eeprom_read_byte(SIGN_ADDR);
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	CALL __EEPROMRDB
	STS  _signValue,R30
;        printf("SIGN set to default %d\n",signValue);
	__POINTW1FN _0x0,51
_0x163:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_signValue
	CALL __CBD1
	CALL SUBOPT_0x1F
;   }
;   if(ep_pulse_max_value_limit != 0x55)
	CPI  R21,85
	BREQ _0xC9
;   {
;      pulseMaxValuesLimit = EP_PULSE_MAX_VALUE_LIMIT;
	LDI  R30,LOW(3900)
	LDI  R31,HIGH(3900)
	CALL SUBOPT_0x20
;      eeprom_write_byte(EP_PULSE_MAX_VALUE_LIMIT_ADDR,pulseMaxValuesLimit);
	LDS  R30,_pulseMaxValuesLimit
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	CALL __EEPROMWRB
;      printf("pulseMaxValuesLimitDefault %d\n",pulseMaxValuesLimit);
	__POINTW1FN _0x0,75
	RJMP _0x164
;   }
;   else
_0xC9:
;   {
;     addr = EP_PULSE_MAX_VALUE_LIMIT_ADDR;
	LDI  R17,LOW(28)
;     pulseMaxValuesLimit = eeprom_read_byte(addr);
	MOV  R26,R17
	CLR  R27
	CALL __EEPROMRDB
	LDI  R31,0
	CALL SUBOPT_0x20
;     printf("pulseMaxValuesLimit %d\n",pulseMaxValuesLimit);
	__POINTW1FN _0x0,106
_0x164:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL __CWD1
	CALL SUBOPT_0x1F
;   }
;   if(ep_samples_limit != 0x55)
	CPI  R20,85
	BREQ _0xCB
;   {
;     diffSamplesLimit = EP_SAMPLES_LIMIT;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x22
;     eeprom_write_byte(EP_SAMPLES_LIMIT_ADDR,diffSamplesLimit);
	LDS  R30,_diffSamplesLimit
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	CALL __EEPROMWRB
;     printf("diffSamplesLimit default %d\n",diffSamplesLimit);
	__POINTW1FN _0x0,130
	RJMP _0x165
;   }
;   else
_0xCB:
;   {
;     addr = EP_SAMPLES_LIMIT_ADDR;
	LDI  R17,LOW(26)
;     diffSamplesLimit = eeprom_read_byte(addr);
	CALL SUBOPT_0x23
	LDI  R31,0
	CALL SUBOPT_0x22
;     printf("diffSamplesLimit %d\n",diffSamplesLimit);
	__POINTW1FN _0x0,159
_0x165:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x24
	CALL __CWD1
	CALL SUBOPT_0x1F
;   }
;   if(winSizeCheckByte != 0x55)  // check window size
	CPI  R18,85
	BREQ _0xCD
;   {
;     windowSize = SHIFT_DETERMINED_LENGTH;
	LDI  R30,LOW(8)
	STS  _windowSize,R30
;     windowSizeTemp = SHIFT_DETERMINED_LENGTH;
	STS  _windowSizeTemp,R30
;     eeprom_write_byte(WINDOW_SIZE_ADDR,windowSize);
	LDS  R30,_windowSize
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	CALL __EEPROMWRB
;     printf("win_size default %d\n",windowSize);
	__POINTW1FN _0x0,180
	RJMP _0x166
;   }
;   else
_0xCD:
;   {
;     addr = WINDOW_SIZE_ADDR;
	LDI  R17,LOW(24)
;     windowSize = eeprom_read_byte(addr);
	CALL SUBOPT_0x23
	STS  _windowSize,R30
;     windowSizeTemp = windowSize;
	STS  _windowSizeTemp,R30
;     printf("windowSize %d\n",windowSize);
	__POINTW1FN _0x0,201
_0x166:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_windowSize
	CALL SUBOPT_0x1E
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;   }
;
;   if(pulseWidthCheckByte != 0x55)   // check pulse width
	CPI  R19,85
	BREQ _0xCF
;   {
;      pulseWidth = PULSE_DURATION;
	LDI  R30,LOW(100)
	STS  _pulseWidth,R30
;      pulseWidthTemp = PULSE_DURATION;
	STS  _pulseWidthTemp,R30
;      eeprom_write_byte(PULSE_WIDTH_ADDR,pulseWidth);
	LDS  R30,_pulseWidth
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	CALL __EEPROMWRB
;
;      printf("pulseWidth default %d\n",pulseWidth);
	__POINTW1FN _0x0,216
	RJMP _0x167
;   }
;   else
_0xCF:
;   {
;     addr = PULSE_WIDTH_ADDR;
	LDI  R17,LOW(22)
;     pulseWidth = eeprom_read_byte(addr);
	CALL SUBOPT_0x23
	STS  _pulseWidth,R30
;     pulseWidthTemp = pulseWidth;
	STS  _pulseWidthTemp,R30
;     addr = WINDOW_SIZE_ADDR;
	LDI  R17,LOW(24)
;
;     printf("pulseWidth %d \n",pulseWidth);
	__POINTW1FN _0x0,239
_0x167:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_pulseWidth
	CALL SUBOPT_0x1E
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;   }
;   if (check_byte != 0xBB)
	CPI  R16,187
	BREQ _0xD1
;   {
;    offset = 0;
	CALL SUBOPT_0x25
;    dbi_added_value = 0;
	STS  _dbi_added_value,R30
	STS  _dbi_added_value+1,R30
	STS  _dbi_added_value+2,R30
	STS  _dbi_added_value+3,R30
;   // element_cnt_read = 0;
;    gain = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x26
;    //send_f(offset);
;    //send_f(gain);
;    //send(element_cnt_read);
;    eeprom_serial_num = SERIAL_NUMBER;
	__GETD1N 0xBC614E
	CALL SUBOPT_0x27
;    eeprom_write_dword(SERIAL_ADDR,SERIAL_NUMBER);
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	__GETD1N 0xBC614E
	CALL __EEPROMWRD
;
;    cutt_off = CUTT_OFF;
	__GETD1N 0x3F000000
	CALL SUBOPT_0x28
;    eeprom_write_float(CUTT_OFF_ADDR, cutt_off);
	CALL SUBOPT_0x29
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __EEPROMWRD
;    printf("gain %4.3f offset %4.3f serial %ld cutt_off %4.3f\n",gain,offset,eeprom_serial_num,cutt_off);
	__POINTW1FN _0x0,255
	RJMP _0x20E000A
;    return;
;   }
;   addr = GAIN_ADDR;
_0xD1:
	LDI  R17,LOW(5)
;   gain = eeprom_read_float(addr);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
;
;   addr = OFFSET_ADDR;
	LDI  R17,LOW(9)
;   offset = eeprom_read_float(addr);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
;
;   addr = SERIAL_ADDR;
	LDI  R17,LOW(1)
;   eeprom_serial_num = eeprom_read_dword(addr);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x27
;
;   addr = CUTT_OFF_ADDR;
	LDI  R17,LOW(17)
;   cutt_off = eeprom_read_float(addr);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x28
;
;   printf("gain %4.3f offset %4.3f %lu cutt %4.3f\n",gain,offset,eeprom_serial_num,cutt_off);
	__POINTW1FN _0x0,306
_0x20E000A:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2D
	CALL __PUTPARD1
	CALL SUBOPT_0x2E
	CALL __PUTPARD1
	CALL SUBOPT_0x2F
	CALL __PUTPARD1
	CALL SUBOPT_0x29
	CALL __PUTPARD1
	LDI  R24,16
	CALL _printf
	ADIW R28,18
;
;}
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
;void init(void)
;{
_init:
; .FSTART _init
;    // Input/Output Ports initialization
;    // Port A initialization
;    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
;    DDRA=(1<<DDA7) | (1<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(198)
	OUT  0x1A,R30
;    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
;    PORTA=(0<<PORTA7) | (0<<PORTA6) | (1<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(32)
	OUT  0x1B,R30
;
;    // Port B initialization
;    //DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
;    // Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
;    DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(176)
	OUT  0x17,R30
;    // State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
;    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
;
;    // Port C initialization
;    // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
;    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(24)
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
;    UBRRL=0x69;//0x67 75600
	LDI  R30,LOW(105)
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
	SBI  0x1B,3
;    EMPTY_PIPE = 1;
	SBI  0x12,7
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
;    OCR2=0xFE;//0xFB;//0xFE
	LDI  R30,LOW(254)
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
;void processSerialNumber();
;void processCalibrationApplied();
;void processCalibrationChanged();
;void read_eeprom_Program1();
;void read_eeprom_Program2();
;//void processPulseWidthSetting();
;void processCuttOff(char);
;void processGenerateFout(unsigned char);
;
;void main(void)
; 0000 0030 {
_main:
; .FSTART _main
; 0000 0031 // Declare your local variables here
; 0000 0032 
; 0000 0033    //char gainStr[10], offsetStr[10], temp[20];
; 0000 0034    //char * ch_temp;
; 0000 0035    unsigned char idx = 0, flow_sample_counter=0, check_stop_process = 0, enableSendingValues = 0,
; 0000 0036             samples_diff_ep_flag = 0,i = 0, ep_sampling_check_flag = 0, empty_pipe_type = NO_EP, ep_detected_cnt = 0;
; 0000 0037 
; 0000 0038    signed int max_sample = 0, min_sample = 0, last_sample_pos  = 0 , first_sample_pos = 0,last_sample_neg  = 0 , first_s ...
; 0000 0039        max_sample_pulse_pos_ep = 0, min_sample_pulse_neg_ep = 0;
; 0000 003A    unsigned int max_count = 0, min_count = 0, curr_max_cnt = 0, curr_min_cnt = 0, curr_sum_max= 0, curr_sum_min = 0,
; 0000 003B                 ep_max_cnt = 0, ep_min_cnt = 0;
; 0000 003C    signed long int max_samples[20],min_samples[20];
; 0000 003D    signed long int sum_max = 0, sum_min = 0;
; 0000 003E 
; 0000 003F    unsigned long int sum_diff_counter = 0, cntr = 0;
; 0000 0040 
; 0000 0041    float sum = 0, sum_avg_max = 0, sum_avg_min = 0, sum_avg_curr_max = 0, sum_avg_curr_min = 0,
; 0000 0042         diff_avg_max_min = 0, sum_all_diffs = 0, avg_sum_max = 0, avg_sum_min = 0, avg_curr_sum_min = 0,
; 0000 0043         average1 = 0, average2 = 0, curAverage1 = 0, curAverage2 = 0, diff_avg = 0, dbi_measured = 0, accuracyFault = 0, ...
; 0000 0044         dbi_temp = 0, ceofCurrAvg = 1;
; 0000 0045    float avg_sum_min_arr[SHIFT_LENGHT_MAX],avg_sum_max_arr[SHIFT_LENGHT_MAX],avg_sum_curr_min_arr[SHIFT_LENGHT_MAX],avg_ ...
; 0000 0046     char ResetFlags = MCUCSR ;
; 0000 0047    static unsigned int wathchdog_counter;
; 0000 0048    init();
	SBIW R28,63
	SBIW R28,63
	SBIW R28,38
	SUBI R29,2
	__GETWRN 24,25,323
	LDI  R26,LOW(353)
	LDI  R27,HIGH(353)
	LDI  R30,LOW(_0xD6*2)
	LDI  R31,HIGH(_0xD6*2)
	CALL __INITLOCW
;	idx -> R17
;	flow_sample_counter -> R16
;	check_stop_process -> R19
;	enableSendingValues -> R18
;	samples_diff_ep_flag -> R21
;	i -> R20
;	ep_sampling_check_flag -> Y+675
;	empty_pipe_type -> Y+674
;	ep_detected_cnt -> Y+673
;	max_sample -> Y+671
;	min_sample -> Y+669
;	last_sample_pos -> Y+667
;	first_sample_pos -> Y+665
;	last_sample_neg -> Y+663
;	first_sample_neg -> Y+661
;	temp_max_sample_ep -> Y+659
;	temp_min_sample_ep -> Y+657
;	max_sample_pulse_pos_ep -> Y+655
;	min_sample_pulse_neg_ep -> Y+653
;	max_count -> Y+651
;	min_count -> Y+649
;	curr_max_cnt -> Y+647
;	curr_min_cnt -> Y+645
;	curr_sum_max -> Y+643
;	curr_sum_min -> Y+641
;	ep_max_cnt -> Y+639
;	ep_min_cnt -> Y+637
;	max_samples -> Y+557
;	min_samples -> Y+477
;	sum_max -> Y+473
;	sum_min -> Y+469
;	sum_diff_counter -> Y+465
;	cntr -> Y+461
;	sum -> Y+457
;	sum_avg_max -> Y+453
;	sum_avg_min -> Y+449
;	sum_avg_curr_max -> Y+445
;	sum_avg_curr_min -> Y+441
;	diff_avg_max_min -> Y+437
;	sum_all_diffs -> Y+433
;	avg_sum_max -> Y+429
;	avg_sum_min -> Y+425
;	avg_curr_sum_min -> Y+421
;	average1 -> Y+417
;	average2 -> Y+413
;	curAverage1 -> Y+409
;	curAverage2 -> Y+405
;	diff_avg -> Y+401
;	dbi_measured -> Y+397
;	accuracyFault -> Y+393
;	send_array -> Y+361
;	dbi_temp -> Y+357
;	ceofCurrAvg -> Y+353
;	avg_sum_min_arr -> Y+265
;	avg_sum_max_arr -> Y+177
;	avg_sum_curr_min_arr -> Y+89
;	avg_sum_curr_max_arr -> Y+1
;	ResetFlags -> Y+0
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	IN   R30,0x34
	ST   Y,R30
	RCALL _init
; 0000 0049 
; 0000 004A    // eeprom_write_dword(SERIAL_ADDR,SERIAL_NUMBER);
; 0000 004B    // delay_ms(2000);
; 0000 004C 
; 0000 004D     read_eeprom_values();
	RCALL _read_eeprom_values
; 0000 004E     delay_us(1000);
	__DELAY_USW 3000
; 0000 004F     time2_init();
	RCALL _time2_init
; 0000 0050 
; 0000 0051     send_offset = 0;
	CLR  R12
; 0000 0052     enable_watchdog();
	RCALL _enable_watchdog
; 0000 0053     // printf("ResetFlag %x wd %d\n",ResetFlags,wathchdog_counter);
; 0000 0054      if (ResetFlags & (1<<3))
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0xD7
; 0000 0055         wathchdog_counter++;
	LDI  R26,LOW(_wathchdog_counter_S0000010000)
	LDI  R27,HIGH(_wathchdog_counter_S0000010000)
	CALL SUBOPT_0x30
; 0000 0056      else
	RJMP _0xD8
_0xD7:
; 0000 0057         wathchdog_counter = 0;
	LDI  R30,LOW(0)
	STS  _wathchdog_counter_S0000010000,R30
	STS  _wathchdog_counter_S0000010000+1,R30
; 0000 0058 
; 0000 0059 while(1)
_0xD8:
_0xD9:
; 0000 005A       {
; 0000 005B        #asm("WDR");
	WDR
; 0000 005C 
; 0000 005D       // Place your code here
; 0000 005E         if(wd_test)
	LDS  R30,_wd_test
	CPI  R30,0
	BREQ _0xDC
; 0000 005F         {
; 0000 0060             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0061             wd_test = 0;
	STS  _wd_test,R30
; 0000 0062             for (cntr = 0; cntr < 1000000;cntr++);
	__CLRD1SX 461
_0xDE:
	__GETD2SX 461
	__CPD2N 0xF4240
	BRSH _0xDF
	MOVW R26,R28
	SUBI R26,LOW(-(461))
	SBCI R27,HIGH(-(461))
	CALL SUBOPT_0x3
	RJMP _0xDE
_0xDF:
; 0000 0063         }
; 0000 0064 
; 0000 0065         if(stopSendingDiffValues == 1)
_0xDC:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0xE0
; 0000 0066         {
; 0000 0067             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0068             startSendingDiffValues = 0;
	CLR  R7
; 0000 0069             stopSendingDiffValues = 0;
	CLR  R6
; 0000 006A             zeroAdjusting = 0;
	CLR  R4
; 0000 006B             db_monitoring = 0;
	CLR  R10
; 0000 006C            // LED_R = 0;
; 0000 006D             min_max_cnt_cmd = 0;
	STS  _min_max_cnt_cmd,R30
; 0000 006E             ep_check_cmd = 0;
	STS  _ep_check_cmd,R30
; 0000 006F             //sendAckResponse();
; 0000 0070             //
; 0000 0071         }
; 0000 0072 
; 0000 0073 
; 0000 0074 
; 0000 0075         if(measure_Q3_calib || measure_Q2_calib || accuracy_measurement)
_0xE0:
	LDS  R30,_measure_Q3_calib
	CPI  R30,0
	BRNE _0xE2
	LDS  R30,_measure_Q2_calib
	CPI  R30,0
	BRNE _0xE2
	LDS  R30,_accuracy_measurement
	CPI  R30,0
	BREQ _0xE1
_0xE2:
; 0000 0076         {
; 0000 0077             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0078         }
; 0000 0079         if(ep_positive_pulse_measurement)
_0xE1:
	LDS  R30,_ep_positive_pulse_measurement
	CPI  R30,0
	BREQ _0xE4
; 0000 007A         {
; 0000 007B             temp_max_sample_ep = abs(spi_sampling());
	RCALL _spi_sampling
	MOVW R26,R30
	CALL _abs
	__PUTW1SX 659
; 0000 007C           //  max_samples[ep_max_cnt] = temp_max_sample_ep;
; 0000 007D           //  ep_max_cnt++;
; 0000 007E            // printf("ep %d\n",temp_max_sample_ep);
; 0000 007F             if (temp_max_sample_ep > max_sample_pulse_pos_ep )
	CALL SUBOPT_0x31
	__GETW2SX 659
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xE5
; 0000 0080                 max_sample_pulse_pos_ep = temp_max_sample_ep;
	__GETW1SX 659
	__PUTW1SX 655
; 0000 0081         }
_0xE5:
; 0000 0082        // */
; 0000 0083         if(ep_negative_pulse_measurement)
_0xE4:
	LDS  R30,_ep_negative_pulse_measurement
	CPI  R30,0
	BREQ _0xE6
; 0000 0084         {
; 0000 0085             temp_min_sample_ep = abs(spi_sampling());
	RCALL _spi_sampling
	MOVW R26,R30
	CALL _abs
	__PUTW1SX 657
; 0000 0086            // min_samples[ep_min_cnt] = temp_min_sample_ep;
; 0000 0087            // ep_min_cnt++;
; 0000 0088             // printf("%d %d\n",temp_min_sample_ep,abs(temp_min_sample_ep));
; 0000 0089             if (temp_min_sample_ep > min_sample_pulse_neg_ep )
	CALL SUBOPT_0x32
	__GETW2SX 657
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xE7
; 0000 008A                 min_sample_pulse_neg_ep = temp_min_sample_ep;
	__GETW1SX 657
	__PUTW1SX 653
; 0000 008B 
; 0000 008C         }
_0xE7:
; 0000 008D         if(current_sample_max)
_0xE6:
	LDS  R30,_current_sample_max
	CPI  R30,0
	BREQ _0xE8
; 0000 008E         {
; 0000 008F            curr_sum_max += read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	CALL SUBOPT_0x33
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SX 643
; 0000 0090            curr_max_cnt++;
	MOVW R26,R28
	SUBI R26,LOW(-(647))
	SBCI R27,HIGH(-(647))
	CALL SUBOPT_0x30
; 0000 0091         }
; 0000 0092 
; 0000 0093         if (read_max_samples)
_0xE8:
	LDS  R30,_read_max_samples
	CPI  R30,0
	BREQ _0xE9
; 0000 0094         {
; 0000 0095             max_sample = spi_sampling();
	RCALL _spi_sampling
	__PUTW1SX 671
; 0000 0096             last_sample_pos = max_sample;
	CALL SUBOPT_0x34
	__PUTW1SX 667
; 0000 0097             if (max_count == 0)
	CALL SUBOPT_0x35
	SBIW R30,0
	BRNE _0xEA
; 0000 0098                 first_sample_pos = max_sample;
	CALL SUBOPT_0x34
	__PUTW1SX 665
; 0000 0099             sum_max += max_sample;
_0xEA:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL __CWD1
	CALL __ADDD12
	__PUTD1SX 473
; 0000 009A             max_count++;
	MOVW R26,R28
	SUBI R26,LOW(-(651))
	SBCI R27,HIGH(-(651))
	CALL SUBOPT_0x30
; 0000 009B         }
; 0000 009C 
; 0000 009D         if(current_sample_min)
_0xE9:
	LDS  R30,_current_sample_min
	CPI  R30,0
	BREQ _0xEB
; 0000 009E         {
; 0000 009F            curr_sum_min += read_adc(4);
	LDI  R26,LOW(4)
	CALL _read_adc
	CALL SUBOPT_0x37
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SX 641
; 0000 00A0            curr_min_cnt++;
	MOVW R26,R28
	SUBI R26,LOW(-(645))
	SBCI R27,HIGH(-(645))
	CALL SUBOPT_0x30
; 0000 00A1         }
; 0000 00A2         if (read_min_samples)
_0xEB:
	LDS  R30,_read_min_samples
	CPI  R30,0
	BREQ _0xEC
; 0000 00A3         {
; 0000 00A4             min_sample = spi_sampling();
	CALL _spi_sampling
	__PUTW1SX 669
; 0000 00A5             last_sample_neg = min_sample;
	CALL SUBOPT_0x38
	__PUTW1SX 663
; 0000 00A6             if(min_count == 0)
	CALL SUBOPT_0x39
	SBIW R30,0
	BRNE _0xED
; 0000 00A7                first_sample_neg = min_sample;
	CALL SUBOPT_0x38
	__PUTW1SX 661
; 0000 00A8             sum_min += min_sample;
_0xED:
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3A
	CALL __CWD1
	CALL __ADDD12
	__PUTD1SX 469
; 0000 00A9             min_count++;
	MOVW R26,R28
	SUBI R26,LOW(-(649))
	SBCI R27,HIGH(-(649))
	CALL SUBOPT_0x30
; 0000 00AA         }
; 0000 00AB         if(ref_sensor_pulse_measurement_stopped)
_0xEC:
	LDS  R30,_ref_sensor_pulse_measurement_stopped
	CPI  R30,0
	BREQ _0xEE
; 0000 00AC         {
; 0000 00AD             check_stop_process = 1;
	LDI  R19,LOW(1)
; 0000 00AE         }
; 0000 00AF         if(pulse_is_detected)
_0xEE:
	LDS  R30,_pulse_is_detected
	CPI  R30,0
	BREQ _0xEF
; 0000 00B0         {
; 0000 00B1             send_array[0] = 0xbb;
	__GETD1N 0x433B0000
	CALL SUBOPT_0x3B
; 0000 00B2             send_array[1] = (float)pulse_edge_cnt;
	ADIW R30,4
	MOVW R26,R30
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 00B3             sendParamsFloat(send_array,2);
	CALL SUBOPT_0x3E
; 0000 00B4             pulse_is_detected = 0;
	STS  _pulse_is_detected,R30
; 0000 00B5         }
; 0000 00B6         ///*
; 0000 00B7         if(respose_uart_activity && enableSendingValues)
_0xEF:
	LDS  R30,_respose_uart_activity
	CPI  R30,0
	BREQ _0xF1
	CPI  R18,0
	BRNE _0xF2
_0xF1:
	RJMP _0xF0
_0xF2:
; 0000 00B8         {
; 0000 00B9             enableSendingValues = 0;
	LDI  R18,LOW(0)
; 0000 00BA             if(serial_number_applied)
	LDS  R30,_serial_number_applied
	CPI  R30,0
	BREQ _0xF3
; 0000 00BB                 processSerialNumber();
	RCALL _processSerialNumber
; 0000 00BC 
; 0000 00BD              if(calibration_changed)
_0xF3:
	LDS  R30,_calibration_changed
	CPI  R30,0
	BREQ _0xF4
; 0000 00BE                 processCalibrationChanged();
	RCALL _processCalibrationChanged
; 0000 00BF 
; 0000 00C0              if(calibration_applied)
_0xF4:
	LDS  R30,_calibration_applied
	CPI  R30,0
	BREQ _0xF5
; 0000 00C1                 processCalibrationApplied();
	RCALL _processCalibrationApplied
; 0000 00C2              if(reade2prom1 == 1)
_0xF5:
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0xF6
; 0000 00C3                 read_eeprom_Program1();
	RCALL _read_eeprom_Program1
; 0000 00C4              if(reade2prom2 == 1)
_0xF6:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xF7
; 0000 00C5                 read_eeprom_Program2();
	RCALL _read_eeprom_Program2
; 0000 00C6              if(PulseWidthSettingApplied)
_0xF7:
	LDS  R30,_PulseWidthSettingApplied
	CPI  R30,0
	BREQ _0xF8
; 0000 00C7                 //processPulseWidthSetting();
; 0000 00C8                 processCuttOff(PULSE_WIDTH_ADDR);
	LDI  R26,LOW(22)
	RCALL _processCuttOff
; 0000 00C9              if(cutt_off_changed)
_0xF8:
	LDS  R30,_cutt_off_changed
	CPI  R30,0
	BREQ _0xF9
; 0000 00CA                 processCuttOff(CUTT_OFF_ADDR);
	LDI  R26,LOW(17)
	RCALL _processCuttOff
; 0000 00CB              if(start_fout_test)
_0xF9:
	LDS  R30,_start_fout_test
	CPI  R30,0
	BREQ _0xFA
; 0000 00CC                 processGenerateFout(1);
	LDI  R26,LOW(1)
	RCALL _processGenerateFout
; 0000 00CD              if(stop_fout_test)
_0xFA:
	LDS  R30,_stop_fout_test
	CPI  R30,0
	BREQ _0xFB
; 0000 00CE                 processGenerateFout(0);
	LDI  R26,LOW(0)
	RCALL _processGenerateFout
; 0000 00CF              if(windowSizeChanged)
_0xFB:
	LDS  R30,_windowSizeChanged
	CPI  R30,0
	BREQ _0xFC
; 0000 00D0                 processCuttOff(WINDOW_SIZE_ADDR);
	LDI  R26,LOW(24)
	RCALL _processCuttOff
; 0000 00D1             if(ep_change_diff_samples_limit_flag)
_0xFC:
	LDS  R30,_ep_change_diff_samples_limit_flag
	CPI  R30,0
	BREQ _0xFD
; 0000 00D2                processCuttOff(EP_SAMPLES_LIMIT_ADDR);
	LDI  R26,LOW(26)
	RCALL _processCuttOff
; 0000 00D3             if(ep_change_pulse_limit_flag)
_0xFD:
	LDS  R30,_ep_change_pulse_limit_flag
	CPI  R30,0
	BREQ _0xFE
; 0000 00D4                processCuttOff(EP_PULSE_MAX_VALUE_LIMIT_ADDR);
	LDI  R26,LOW(28)
	RCALL _processCuttOff
; 0000 00D5             if(inverseSignCmd)
_0xFE:
	LDS  R30,_inverseSignCmd
	CPI  R30,0
	BREQ _0xFF
; 0000 00D6                 processCuttOff(SIGN_ADDR);
	LDI  R26,LOW(30)
	RCALL _processCuttOff
; 0000 00D7              if(wd_monitoring)
_0xFF:
	LDS  R30,_wd_monitoring
	CPI  R30,0
	BREQ _0x100
; 0000 00D8                {
; 0000 00D9                     send_array[0] =  (float)wathchdog_counter;
	CALL SUBOPT_0x3F
; 0000 00DA                     sendParamsFloat(send_array,1);
	CALL SUBOPT_0x40
; 0000 00DB                     wd_monitoring = 0;
; 0000 00DC                     rx_wr_index = 0;
; 0000 00DD                     //LED_R = 0;
; 0000 00DE                }
; 0000 00DF                 if (zeroAdjusting == 1)
_0x100:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x101
; 0000 00E0                 {
; 0000 00E1                         rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 00E2                         /*
; 0000 00E3                         send_array[0] = avg_sum_min;
; 0000 00E4                         send_array[1] = avg_sum_max;
; 0000 00E5                         send_array[2] = avg_curr_sum_min;
; 0000 00E6                         send_array[3] = avg_curr_sum_max;
; 0000 00E7                         send_array[4] = diff_avg_max_min;
; 0000 00E8                         send_array[5] = ceofCurrAvg;
; 0000 00E9                         */
; 0000 00EA                         send_array[0] = avg_sum_min;
	__GETD1SX 425
	CALL SUBOPT_0x3B
; 0000 00EB                         send_array[1] = avg_sum_max;
	ADIW R30,4
	CALL SUBOPT_0x41
; 0000 00EC                         send_array[2] = ceofCurrAvg;
	MOVW R30,R28
	SUBI R30,LOW(-(361))
	SBCI R31,HIGH(-(361))
	ADIW R30,8
	__GETD2SX 353
	CALL SUBOPT_0x42
; 0000 00ED                         send_array[3] = avg_curr_sum_max;
	ADIW R30,12
	CALL SUBOPT_0x43
	CALL SUBOPT_0x42
; 0000 00EE                         send_array[4] = dbi_temp;
	ADIW R30,16
	CALL SUBOPT_0x44
	CALL SUBOPT_0x42
; 0000 00EF                        // send_array[5] = avg_curr_sum_min;
; 0000 00F0                      //   printf("min %4.3f max %4.3f %4.3f %4.3f %4.3f %4.3f",avg_sum_min,avg_sum_max,avg_curr_sum_min,
; 0000 00F1                      //       avg_curr_sum_max,diff_avg_max_min,ceofCurrAvg);
; 0000 00F2                         sendParamsFloat(send_array,5);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _sendParamsFloat
; 0000 00F3                 }
; 0000 00F4                 if(db_monitoring)
_0x101:
	TST  R10
	BREQ _0x102
; 0000 00F5                 {
; 0000 00F6                     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 00F7                     send_f(dbi_temp);
	CALL SUBOPT_0x44
	RCALL _send_f
; 0000 00F8                 }
; 0000 00F9         }
_0x102:
; 0000 00FA         //*/
; 0000 00FB 
; 0000 00FC         if (sample_ready_flag && max_count !=0 && min_count !=0)
_0xF0:
	TST  R5
	BREQ _0x104
	__GETW2SX 651
	SBIW R26,0
	BREQ _0x104
	__GETW2SX 649
	SBIW R26,0
	BRNE _0x105
_0x104:
	RJMP _0x103
_0x105:
; 0000 00FD         {
; 0000 00FE           // printf("watch_dog timer counter %lu\n",wathchdog_counter);
; 0000 00FF           if(ep_check_cmd)
	LDS  R30,_ep_check_cmd
	CPI  R30,0
	BREQ _0x106
; 0000 0100             {
; 0000 0101 
; 0000 0102               //  printf("f-lp %d l-fn %d\n",first_sample_pos - last_sample_pos,last_sample_neg-first_sample_neg);
; 0000 0103               //  printf("fp %d ls %d f-lp %d ln %d fn %d l-fn%d\n",first_sample_pos,last_sample_pos,first_sample_pos -  ...
; 0000 0104               //  printf("mpe %d mne %d\n",max_sample_pulse_pos_ep,min_sample_pulse_neg_ep);
; 0000 0105                 send_array[0] = first_sample_pos-last_sample_pos;
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	CALL SUBOPT_0x3B
; 0000 0106                 send_array[1] = last_sample_neg-first_sample_neg;
	ADIW R30,4
	MOVW R22,R30
	CALL SUBOPT_0x47
	MOVW R26,R22
	CALL SUBOPT_0x48
; 0000 0107                 send_array[2] = max_sample_pulse_pos_ep;
	ADIW R30,8
	MOVW R26,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x48
; 0000 0108                 send_array[3] = min_sample_pulse_neg_ep;
	ADIW R30,12
	MOVW R26,R30
	CALL SUBOPT_0x32
	CALL SUBOPT_0x48
; 0000 0109                 send_array[4] = empty_pipe_type;
	ADIW R30,16
	MOVW R26,R30
	__GETB1SX 674
	CALL SUBOPT_0x49
	CALL SUBOPT_0x3D
; 0000 010A                 //send_array[4] = dbi_temp;
; 0000 010B                 sendParamsFloat(send_array,5);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _sendParamsFloat
; 0000 010C               ///*
; 0000 010D               // printf("p %d m %d\n",ep_max_cnt,ep_min_cnt);
; 0000 010E                /*
; 0000 010F                printf("max samples: ");
; 0000 0110                 for(i = 0 ; i < ep_max_cnt; i++)
; 0000 0111                     printf("[%d]%d",i,max_samples[i]);
; 0000 0112                 printf("\nmin samples: ");
; 0000 0113                 for(i = 0 ; i < ep_max_cnt; i++)
; 0000 0114                     printf("[%d]%d",i,min_samples[i]);
; 0000 0115                 printf("\n");
; 0000 0116            // */
; 0000 0117                 rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0118             }
; 0000 0119             ep_max_cnt = 0;
_0x106:
	LDI  R30,LOW(0)
	__CLRW1SX 639
; 0000 011A             ep_min_cnt = 0;
	__CLRW1SX 637
; 0000 011B             if (max_sample_pulse_pos_ep < pulseMaxValuesLimit && min_sample_pulse_neg_ep < pulseMaxValuesLimit)
	CALL SUBOPT_0x21
	__GETW2SX 655
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x108
	CALL SUBOPT_0x21
	__GETW2SX 653
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x109
_0x108:
	RJMP _0x107
_0x109:
; 0000 011C             {
; 0000 011D                ep_sampling_check_flag = 1;
	LDI  R30,LOW(1)
	RJMP _0x168
; 0000 011E                //EMPTY_PIPE = 0;
; 0000 011F                //LED = 1;
; 0000 0120             }
; 0000 0121             else
_0x107:
; 0000 0122             {
; 0000 0123                ep_sampling_check_flag = 0;
	LDI  R30,LOW(0)
_0x168:
	__PUTB1SX 675
; 0000 0124                //EMPTY_PIPE = 1;
; 0000 0125                //LED = 0;
; 0000 0126             }
; 0000 0127             max_sample_pulse_pos_ep = 0;
	LDI  R30,LOW(0)
	__CLRW1SX 655
; 0000 0128             min_sample_pulse_neg_ep = 0;
	__CLRW1SX 653
; 0000 0129             if( (first_sample_pos - last_sample_pos  > diffSamplesLimit) || (last_sample_neg -first_sample_neg > diffSam ...
	CALL SUBOPT_0x45
	MOVW R26,R30
	CALL SUBOPT_0x24
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x10C
	CALL SUBOPT_0x47
	MOVW R26,R30
	CALL SUBOPT_0x24
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x10B
_0x10C:
; 0000 012A                 samples_diff_ep_flag = 1;
	LDI  R21,LOW(1)
; 0000 012B             else
	RJMP _0x10E
_0x10B:
; 0000 012C                 samples_diff_ep_flag = 0;
	LDI  R21,LOW(0)
; 0000 012D          /*
; 0000 012E          if(serial_number_applied)
; 0000 012F             processSerialNumber();
; 0000 0130 
; 0000 0131          if(calibration_changed)
; 0000 0132             processCalibrationChanged();
; 0000 0133 
; 0000 0134          if(calibration_applied)
; 0000 0135             processCalibrationApplied();
; 0000 0136         if(reade2prom == 1)
; 0000 0137           read_eeprom_Program();
; 0000 0138          if(PulseWidthSettingApplied)
; 0000 0139             processCuttOff(PULSE_WIDTH_ADDR);//processPulseWidthSetting();
; 0000 013A         if(cutt_off_changed)
; 0000 013B             processCuttOff(CUTT_OFF_ADDR);
; 0000 013C          if(start_fout_test)
; 0000 013D             processGenerateFout(1);
; 0000 013E          if(stop_fout_test)
; 0000 013F             processGenerateFout(0);
; 0000 0140          if(windowSizeChanged)
; 0000 0141             processCuttOff(WINDOW_SIZE_ADDR);
; 0000 0142             */
; 0000 0143        if(wd_monitoring)
_0x10E:
	LDS  R30,_wd_monitoring
	CPI  R30,0
	BREQ _0x10F
; 0000 0144        {
; 0000 0145             send_array[0] =  (float)wathchdog_counter;
	CALL SUBOPT_0x3F
; 0000 0146             sendParamsFloat(send_array,1);
	CALL SUBOPT_0x40
; 0000 0147             wd_monitoring = 0;
; 0000 0148             rx_wr_index = 0;
; 0000 0149             //LED_R = 0;
; 0000 014A        }
; 0000 014B        average1 = (float)((sum_max) / (float)max_count);
_0x10F:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x36
	CALL __CDF2
	CALL __DIVF21
	CALL SUBOPT_0x4B
; 0000 014C        average1 *= signValue;
	LDS  R30,_signValue
	LDI  R31,0
	SBRC R30,7
	SER  R31
	__GETD2SX 417
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4B
; 0000 014D        average2 = (float)((sum_min) / (float)min_count);
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x3A
	CALL __CDF2
	CALL __DIVF21
	CALL SUBOPT_0x4E
; 0000 014E        average2 *= signValue;
	LDS  R30,_signValue
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4E
; 0000 014F        curAverage1 = (float)((curr_sum_max) / (float)curr_max_cnt);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x33
	CALL SUBOPT_0x51
	__PUTD1SX 409
; 0000 0150        curAverage2 = (float)((curr_sum_min) / (float)curr_min_cnt);
	CALL SUBOPT_0x52
	CALL SUBOPT_0x37
	CALL SUBOPT_0x51
	__PUTD1SX 405
; 0000 0151        if(min_max_cnt_cmd)
	LDS  R30,_min_max_cnt_cmd
	CPI  R30,0
	BREQ _0x110
; 0000 0152        {
; 0000 0153             send_array[0] = max_count;
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x3B
; 0000 0154             send_array[1] = min_count;
	ADIW R30,4
	MOVW R26,R30
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x3D
; 0000 0155             send_array[2] = curr_max_cnt;
	ADIW R30,8
	MOVW R26,R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x3D
; 0000 0156             send_array[3] = curr_min_cnt;
	ADIW R30,12
	MOVW R26,R30
	CALL SUBOPT_0x52
	CALL SUBOPT_0x3D
; 0000 0157             //printf("min %d max %d\n",max_count,min_count);
; 0000 0158             sendParamsFloat(send_array,4);
	CALL SUBOPT_0x53
; 0000 0159             rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 015A        }
; 0000 015B        max_count = 0;
_0x110:
	LDI  R30,LOW(0)
	__CLRW1SX 651
; 0000 015C        min_count = 0;
	__CLRW1SX 649
; 0000 015D        curr_max_cnt = 0;
	__CLRW1SX 647
; 0000 015E        curr_min_cnt = 0;
	__CLRW1SX 645
; 0000 015F        sum_max = 0;
	__CLRD1SX 473
; 0000 0160        sum_min = 0;
	__CLRD1SX 469
; 0000 0161        curr_sum_max = 0;
	__CLRW1SX 643
; 0000 0162        curr_sum_min = 0;
	__CLRW1SX 641
; 0000 0163       // sample_ready_flag = 0;
; 0000 0164        //if(CALIB_PROCESSING == 0)
; 0000 0165        //{
; 0000 0166           if(ref_sensor_pulse_measurement_started)
	LDS  R30,_ref_sensor_pulse_measurement_started
	CPI  R30,0
	BREQ _0x111
; 0000 0167           {
; 0000 0168             diff_avg_max_min = average1 - average2;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 0169             sum_all_diffs += diff_avg_max_min;
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	CALL __ADDF12
	__PUTD1SX 433
; 0000 016A             sum_diff_counter++;
	MOVW R26,R28
	SUBI R26,LOW(-(465))
	SBCI R27,HIGH(-(465))
	CALL SUBOPT_0x3
; 0000 016B             //printf("ovf %lu s %4.1f c %lu p1 %4.3f\n",ovf_timer0_cnt,sum_all_diffs,sum_diff_counter,pulse_duration_1);
; 0000 016C           }
; 0000 016D           //if(ref_sensor_pulse_measurement_stopped)
; 0000 016E           if(check_stop_process)
_0x111:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x112
; 0000 016F           {
; 0000 0170             check_stop_process = 0;
	LDI  R19,LOW(0)
; 0000 0171             diff_avg = sum_all_diffs / sum_diff_counter;
	__GETD1SX 465
	CALL SUBOPT_0x57
	CALL __CDF1U
	CALL __DIVF21
	__PUTD1SX 401
; 0000 0172             dbi_measured = (pulse_edge_cnt*LITER_PER_PULSE) / (pulse_duration_1);
	CALL SUBOPT_0x3C
	__GETD2N 0x461C4000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_pulse_duration_1
	LDS  R31,_pulse_duration_1+1
	LDS  R22,_pulse_duration_1+2
	LDS  R23,_pulse_duration_1+3
	CALL __DIVF21
	__PUTD1SX 397
; 0000 0173             //printf("pulse_duration_1 %4.3f pulse_edge_cnt %lu sum_all_diffs %4.4f sum_diff_counter %d diff_avg %4.3f\n ...
; 0000 0174             sum_all_diffs = 0;
	LDI  R30,LOW(0)
	__CLRD1SX 433
; 0000 0175             sum_diff_counter = 0;
	__CLRD1SX 465
; 0000 0176             diff_avg_max_min = 0;
	CALL SUBOPT_0x58
; 0000 0177             ref_sensor_pulse_measurement_stopped = 0;
	LDI  R30,LOW(0)
	STS  _ref_sensor_pulse_measurement_stopped,R30
; 0000 0178             ref_sensor_pulse_measurement_started = 0;
	STS  _ref_sensor_pulse_measurement_started,R30
; 0000 0179             if(measure_Q3_calib_send_data)
	LDS  R30,_measure_Q3_calib_send_data
	CPI  R30,0
	BREQ _0x113
; 0000 017A             {
; 0000 017B                dbi_Q3 = dbi_measured;
	CALL SUBOPT_0x59
	STS  _dbi_Q3,R30
	STS  _dbi_Q3+1,R31
	STS  _dbi_Q3+2,R22
	STS  _dbi_Q3+3,R23
; 0000 017C                diff_Q3 = diff_avg;
	CALL SUBOPT_0x5A
	STS  _diff_Q3,R30
	STS  _diff_Q3+1,R31
	STS  _diff_Q3+2,R22
	STS  _diff_Q3+3,R23
; 0000 017D                send_array[0] = dbi_measured;
	CALL SUBOPT_0x5B
; 0000 017E                send_array[1] = diff_avg;
	CALL SUBOPT_0x5C
; 0000 017F                sendParamsFloat(send_array,2);
	CALL SUBOPT_0x3E
; 0000 0180                measure_Q3_calib_send_data = 0;
	STS  _measure_Q3_calib_send_data,R30
; 0000 0181             }
; 0000 0182             if(measure_Q2_calib_send_data)
_0x113:
	LDS  R30,_measure_Q2_calib_send_data
	CPI  R30,0
	BREQ _0x114
; 0000 0183             {
; 0000 0184                dbi_Q2 = dbi_measured;
	CALL SUBOPT_0x59
	STS  _dbi_Q2,R30
	STS  _dbi_Q2+1,R31
	STS  _dbi_Q2+2,R22
	STS  _dbi_Q2+3,R23
; 0000 0185                diff_Q2 = diff_avg;
	CALL SUBOPT_0x5A
	STS  _diff_Q2,R30
	STS  _diff_Q2+1,R31
	STS  _diff_Q2+2,R22
	STS  _diff_Q2+3,R23
; 0000 0186                send_array[0] = dbi_measured;
	CALL SUBOPT_0x5B
; 0000 0187                send_array[1] = diff_avg;
	CALL SUBOPT_0x5C
; 0000 0188                sendParamsFloat(send_array,2);
	CALL SUBOPT_0x3E
; 0000 0189                measure_Q2_calib_send_data = 0;
	STS  _measure_Q2_calib_send_data,R30
; 0000 018A             }
; 0000 018B             //sendParamsFloat(dbi_measured,diff_avg);
; 0000 018C             if(accuracy_measurement_send_data)
_0x114:
	LDS  R30,_accuracy_measurement_send_data
	CPI  R30,0
	BRNE PC+2
	RJMP _0x115
; 0000 018D             {
; 0000 018E                 dbi_final = (diff_avg - offset)/gain;
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5A
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x2D
	CALL __DIVF21
	CALL SUBOPT_0x5E
; 0000 018F                 accuracyFault = ((dbi_final - dbi_measured)/dbi_measured)*100;
	__GETD2SX 397
	LDS  R30,_dbi_final
	LDS  R31,_dbi_final+1
	LDS  R22,_dbi_final+2
	LDS  R23,_dbi_final+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x59
	CALL __DIVF21
	__GETD2N 0x42C80000
	CALL __MULF12
	__PUTD1SX 393
; 0000 0190                 send_array[0] = dbi_measured;
	CALL SUBOPT_0x5B
; 0000 0191                 send_array[1] = dbi_final;
	ADIW R30,4
	CALL SUBOPT_0x6
	CALL SUBOPT_0x42
; 0000 0192                 send_array[2] = accuracyFault;
	ADIW R30,8
	__GETD2SX 393
	CALL SUBOPT_0x42
; 0000 0193                 send_array[3] = diff_avg;
	ADIW R30,12
	__GETD2SX 401
	CALL SUBOPT_0x42
; 0000 0194                 sendParamsFloat(send_array,4);
	CALL SUBOPT_0x53
; 0000 0195                 accuracy_measurement_send_data = 0;
	STS  _accuracy_measurement_send_data,R30
; 0000 0196             }
; 0000 0197 
; 0000 0198           }
_0x115:
; 0000 0199 
; 0000 019A 
; 0000 019B            //} //if(CALIB_PROCESSING == 0)
; 0000 019C            //else
; 0000 019D            //{
; 0000 019E                 //flow_avg_max[flow_sample_counter] = average1;
; 0000 019F                 //flow_avg_min[flow_sample_counter] = average2;
; 0000 01A0             sum_avg_max += average1;
_0x112:
	CALL SUBOPT_0x54
	CALL SUBOPT_0x5F
	CALL __ADDF12
	__PUTD1SX 453
; 0000 01A1             sum_avg_min += average2;
	__GETD1SX 413
	CALL SUBOPT_0x60
	CALL __ADDF12
	__PUTD1SX 449
; 0000 01A2             sum_avg_curr_max += curAverage1;
	__GETD1SX 409
	CALL SUBOPT_0x61
	CALL __ADDF12
	__PUTD1SX 445
; 0000 01A3             sum_avg_curr_min += curAverage2;
	__GETD1SX 405
	CALL SUBOPT_0x62
	CALL __ADDF12
	__PUTD1SX 441
; 0000 01A4             //diff_avg_max_min = average1 - average2;
; 0000 01A5             //  printf("windowSize %d %d\n",pulseWidth,1000/(pulseWidth*2));
; 0000 01A6             if(flow_sample_counter== (1000/(pulseWidth*2)))//(1000 / (PULSE_DURATION*2 + REST_DURATION*2)))
	LDS  R26,_pulseWidth
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __DIVW21
	MOV  R26,R16
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+2
	RJMP _0x116
; 0000 01A7             {
; 0000 01A8 
; 0000 01A9                 sum=0;
	LDI  R30,LOW(0)
	__CLRD1SX 457
; 0000 01AA                //sum_avg_max = 0;
; 0000 01AB                // sum_avg_min = 0;
; 0000 01AC                 avg_sum_max = 0;
	__CLRD1SX 429
; 0000 01AD                 avg_sum_min = 0;
	__CLRD1SX 425
; 0000 01AE                 diff_avg_max_min = 0;
	CALL SUBOPT_0x58
; 0000 01AF                 enableSendingValues = 1;
	LDI  R18,LOW(1)
; 0000 01B0                 /*for(counter=0 ; counter <= flow_sample_counter ; counter++)
; 0000 01B1                 {
; 0000 01B2                     //sum+=flow[counter];
; 0000 01B3                     sum_avg_max += flow_avg_max[counter];
; 0000 01B4                   //  printf("flow_avg_max %d %4.3f sum_avg_max % 4.3f\n",counter,flow_avg_max[counter],sum_avg_max);
; 0000 01B5                     sum_avg_min += flow_avg_min[counter];
; 0000 01B6 
; 0000 01B7                 }
; 0000 01B8                 */
; 0000 01B9 
; 0000 01BA                 avg_sum_max = (float)(sum_avg_max/(float)(flow_sample_counter+1.0));
	MOV  R30,R16
	CALL SUBOPT_0x2
	CALL SUBOPT_0x63
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x64
; 0000 01BB                 avg_sum_min = (float)(sum_avg_min/(float)(flow_sample_counter+1.0));
	MOV  R30,R16
	CALL SUBOPT_0x2
	CALL SUBOPT_0x63
	CALL SUBOPT_0x60
	CALL SUBOPT_0x65
; 0000 01BC                 avg_curr_sum_max = (float)(sum_avg_curr_max/(float)(flow_sample_counter+1.0));
	MOV  R30,R16
	CALL SUBOPT_0x2
	CALL SUBOPT_0x63
	CALL SUBOPT_0x61
	CALL SUBOPT_0x66
; 0000 01BD                 avg_curr_sum_min = (float)(sum_avg_curr_min/(float)(flow_sample_counter+1.0));
	MOV  R30,R16
	CALL SUBOPT_0x2
	CALL SUBOPT_0x63
	CALL SUBOPT_0x62
	CALL SUBOPT_0x67
; 0000 01BE 
; 0000 01BF                 avg_sum_min_arr[insert_idx] = avg_sum_min;
	LDS  R30,_insert_idx
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(265))
	SBCI R27,HIGH(-(265))
	CALL SUBOPT_0x68
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
; 0000 01C0                 avg_sum_max_arr[insert_idx] = avg_sum_max;
	MOVW R26,R28
	SUBI R26,LOW(-(177))
	SBCI R27,HIGH(-(177))
	CALL SUBOPT_0x68
	CALL SUBOPT_0x41
; 0000 01C1                 avg_sum_curr_min_arr[insert_idx] = avg_curr_sum_min;
	LDS  R30,_insert_idx
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	CALL SUBOPT_0x68
	__GETD2SX 421
	CALL SUBOPT_0x6A
; 0000 01C2                 avg_sum_curr_max_arr[insert_idx] = avg_curr_sum_max;
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0x68
	CALL SUBOPT_0x43
	CALL __PUTDZ20
; 0000 01C3 
; 0000 01C4                 if(insert_idx == windowSize - 1)
	LDS  R30,_windowSize
	LDI  R31,0
	SBIW R30,1
	LDS  R26,_insert_idx
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x117
; 0000 01C5                     insert_idx = 0;
	LDI  R30,LOW(0)
	RJMP _0x169
; 0000 01C6                 else
_0x117:
; 0000 01C7                     insert_idx++;
	LDS  R30,_insert_idx
	SUBI R30,-LOW(1)
_0x169:
	STS  _insert_idx,R30
; 0000 01C8 
; 0000 01C9                 for(idx=0;idx < windowSize; idx++)
	LDI  R17,LOW(0)
_0x11A:
	LDS  R30,_windowSize
	CP   R17,R30
	BRLO PC+2
	RJMP _0x11B
; 0000 01CA                 {
; 0000 01CB                     sum_avg_sum_min += avg_sum_min_arr[idx];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(265))
	SBCI R27,HIGH(-(265))
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x6B
	CALL __ADDF12
	STS  _sum_avg_sum_min,R30
	STS  _sum_avg_sum_min+1,R31
	STS  _sum_avg_sum_min+2,R22
	STS  _sum_avg_sum_min+3,R23
; 0000 01CC                     sum_avg_sum_max += avg_sum_max_arr[idx];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(177))
	SBCI R27,HIGH(-(177))
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x6C
	CALL __ADDF12
	STS  _sum_avg_sum_max,R30
	STS  _sum_avg_sum_max+1,R31
	STS  _sum_avg_sum_max+2,R22
	STS  _sum_avg_sum_max+3,R23
; 0000 01CD                     sum_avg_curr_sum_min += avg_sum_curr_min_arr[idx];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x6D
	CALL __ADDF12
	STS  _sum_avg_curr_sum_min,R30
	STS  _sum_avg_curr_sum_min+1,R31
	STS  _sum_avg_curr_sum_min+2,R22
	STS  _sum_avg_curr_sum_min+3,R23
; 0000 01CE                     sum_avg_curr_sum_max += avg_sum_curr_max_arr[idx];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x6E
	CALL __ADDF12
	STS  _sum_avg_curr_sum_max,R30
	STS  _sum_avg_curr_sum_max+1,R31
	STS  _sum_avg_curr_sum_max+2,R22
	STS  _sum_avg_curr_sum_max+3,R23
; 0000 01CF                 }
	SUBI R17,-1
	RJMP _0x11A
_0x11B:
; 0000 01D0                 //printf("windowsize %d sum_max %4.3f\n",windowSize,sum_avg_curr_sum_max);
; 0000 01D1                 avg_sum_min = (float)(sum_avg_sum_min / (float)(windowSize));
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x65
; 0000 01D2                 avg_sum_max = (float)(sum_avg_sum_max / (float)(windowSize));
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x64
; 0000 01D3                 avg_curr_sum_min = (float)(sum_avg_curr_sum_min / (float)(windowSize));
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x67
; 0000 01D4                 avg_curr_sum_max = (float)(sum_avg_curr_sum_max / (float)(windowSize));
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x66
; 0000 01D5 
; 0000 01D6 
; 0000 01D7 
; 0000 01D8                 diff_avg_max_min = (avg_sum_max - avg_sum_min);///ceofCurrAvg;
	CALL SUBOPT_0x69
	__GETD1SX 429
	CALL SUBOPT_0x55
; 0000 01D9 
; 0000 01DA               /*
; 0000 01DB                 if (zeroAdjusting == 1)
; 0000 01DC                 {
; 0000 01DD                         rx_wr_index = 0;
; 0000 01DE                         send_array[0] = avg_sum_min;
; 0000 01DF                         send_array[1] = avg_sum_max;
; 0000 01E0                         send_array[2] = avg_curr_sum_min;
; 0000 01E1                         send_array[3] = avg_curr_sum_max;
; 0000 01E2                         send_array[4] = diff_avg_max_min;
; 0000 01E3                         send_array[5] = ceofCurrAvg;
; 0000 01E4                      //   printf("min %4.3f max %4.3f %4.3f %4.3f %4.3f %4.3f",avg_sum_min,avg_sum_max,avg_curr_sum_min,
; 0000 01E5                      //       avg_curr_sum_max,diff_avg_max_min,ceofCurrAvg);
; 0000 01E6                         sendParamsFloat(send_array,2);
; 0000 01E7                 }
; 0000 01E8                 */
; 0000 01E9                 if(startSendingDiffValues)
	TST  R7
	BREQ _0x11C
; 0000 01EA                 {
; 0000 01EB                     send_f(diff_avg_max_min);
	__GETD2SX 437
	CALL _send_f
; 0000 01EC                     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 01ED                 }
; 0000 01EE                if(generate_fout_test == 1)
_0x11C:
	LDS  R26,_generate_fout_test
	CPI  R26,LOW(0x1)
	BRNE _0x11D
; 0000 01EF                 {
; 0000 01F0                     dbi_temp = 10.7;
	__GETD1N 0x412B3333
	CALL SUBOPT_0x70
; 0000 01F1                     dbi_final = fabs(dbi_temp);
; 0000 01F2                     if(dbi_temp <= cutt_off)
	CALL SUBOPT_0x29
	CALL SUBOPT_0x44
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x11E
; 0000 01F3                         TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 01F4                     else
	RJMP _0x11F
_0x11E:
; 0000 01F5                     {
; 0000 01F6                         TCCR1B |= TIMER_PRESCALE;
	CALL SUBOPT_0x71
; 0000 01F7                         db_changed = 1;
; 0000 01F8                     }
_0x11F:
; 0000 01F9                 }
; 0000 01FA 		        else if(generate_fout_test  == 0 && gain != 0 && offset != 0)
	RJMP _0x120
_0x11D:
	LDS  R26,_generate_fout_test
	CPI  R26,LOW(0x0)
	BRNE _0x122
	CALL SUBOPT_0x72
	CALL __CPD02
	BREQ _0x122
	CALL SUBOPT_0x5D
	CALL __CPD02
	BRNE _0x123
_0x122:
	RJMP _0x121
_0x123:
; 0000 01FB                 {
; 0000 01FC                   eeprom_avg_curr_sum_max = eeprom_read_float(CURR_ADDR);
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	CALL __EEPROMRDD
	STS  _eeprom_avg_curr_sum_max,R30
	STS  _eeprom_avg_curr_sum_max+1,R31
	STS  _eeprom_avg_curr_sum_max+2,R22
	STS  _eeprom_avg_curr_sum_max+3,R23
; 0000 01FD                   ceofCurrAvg = avg_curr_sum_max / eeprom_avg_curr_sum_max;
	CALL SUBOPT_0x73
	CALL SUBOPT_0x43
	CALL __DIVF21
	__PUTD1SX 353
; 0000 01FE                   dbi_temp = (diff_avg_max_min - offset)/(gain*ceofCurrAvg);
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x56
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1SX 353
	CALL SUBOPT_0x72
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x70
; 0000 01FF                   //  if(diff_avg_max_min < (offset / 2.0))
; 0000 0200                   //      DIRECTION = 1;
; 0000 0201                   //  else
; 0000 0202 
; 0000 0203 
; 0000 0204                     dbi_final = fabs(dbi_temp);
; 0000 0205                     if(ep_sampling_check_flag)
	__GETB1SX 675
	CPI  R30,0
	BREQ _0x124
; 0000 0206                     {
; 0000 0207                         empty_pipe_type = PULSE_LEVEL;
	LDI  R30,LOW(1)
	RJMP _0x16A
; 0000 0208                         //EMPTY_PIPE = 0;
; 0000 0209                         //LED = 1;
; 0000 020A                     }
; 0000 020B                     else if (dbi_final > (cutt_off/0.8)*31.25)
_0x124:
	LDS  R26,_cutt_off
	LDS  R27,_cutt_off+1
	LDS  R24,_cutt_off+2
	LDS  R25,_cutt_off+3
	__GETD1N 0x3F4CCCCD
	CALL __DIVF21
	__GETD2N 0x41FA0000
	CALL __MULF12
	CALL SUBOPT_0x74
	BREQ PC+2
	BRCC PC+2
	RJMP _0x126
; 0000 020C                     {
; 0000 020D                         empty_pipe_type = DBI_VALUE;
	LDI  R30,LOW(2)
	RJMP _0x16A
; 0000 020E                         //EMPTY_PIPE = 0;
; 0000 020F                         //LED = 1;
; 0000 0210                     }
; 0000 0211                     else if(samples_diff_ep_flag)
_0x126:
	CPI  R21,0
	BREQ _0x128
; 0000 0212                     {
; 0000 0213                         empty_pipe_type = SAMPLE_DIFF_LEVEL;
	LDI  R30,LOW(3)
	RJMP _0x16A
; 0000 0214                         //EMPTY_PIPE = 0;
; 0000 0215                         //LED = 1;
; 0000 0216                     }
; 0000 0217                     else
_0x128:
; 0000 0218                     {
; 0000 0219                         //EMPTY_PIPE = 1;
; 0000 021A                         //LED = 0;
; 0000 021B                         empty_pipe_type = NO_EP;
	LDI  R30,LOW(0)
_0x16A:
	__PUTB1SX 674
; 0000 021C                     }
; 0000 021D                     if(empty_pipe_type != NO_EP)
	CPI  R30,0
	BREQ _0x12A
; 0000 021E                     {
; 0000 021F                         ep_detected_cnt++;
	MOVW R26,R28
	SUBI R26,LOW(-(673))
	SBCI R27,HIGH(-(673))
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0220                         if(ep_detected_cnt >= 5)
	__GETB2SX 673
	CPI  R26,LOW(0x5)
	BRLO _0x12B
; 0000 0221                         {
; 0000 0222                             TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 0223                             EMPTY_PIPE = 0;
	CBI  0x12,7
; 0000 0224                             ep_detected_cnt = 0;
	LDI  R30,LOW(0)
	__PUTB1SX 673
; 0000 0225                             LED = 1;
	SBI  0x15,4
; 0000 0226                         }
; 0000 0227                     }
_0x12B:
; 0000 0228                     else
	RJMP _0x130
_0x12A:
; 0000 0229                     {
; 0000 022A                         EMPTY_PIPE = 1;
	SBI  0x12,7
; 0000 022B                         LED = 0;
	CBI  0x15,4
; 0000 022C                         ep_detected_cnt = 0;
	LDI  R30,LOW(0)
	__PUTB1SX 673
; 0000 022D                         if(dbi_temp < 0)  // check reverse current
	__GETB2SX 360
	TST  R26
	BRPL _0x135
; 0000 022E                         {
; 0000 022F                             if(dbi_final < cutt_off)
	CALL SUBOPT_0x29
	CALL SUBOPT_0x74
	BRSH _0x136
; 0000 0230                                 TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 0231                             else
	RJMP _0x137
_0x136:
; 0000 0232                             {
; 0000 0233                                 DIRECTION = 1;
	SBI  0x12,6
; 0000 0234                                 TCCR1B |= TIMER_PRESCALE;
	CALL SUBOPT_0x71
; 0000 0235                                 db_changed = 1;
; 0000 0236                             }
_0x137:
; 0000 0237                         }
; 0000 0238                         else
	RJMP _0x13A
_0x135:
; 0000 0239                         {
; 0000 023A                             DIRECTION = 0;
	CBI  0x12,6
; 0000 023B                             if(dbi_final < cutt_off)
	CALL SUBOPT_0x29
	CALL SUBOPT_0x74
	BRSH _0x13D
; 0000 023C                                 TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 023D                             else
	RJMP _0x13E
_0x13D:
; 0000 023E                             {
; 0000 023F                                 TCCR1B |= TIMER_PRESCALE;
	CALL SUBOPT_0x71
; 0000 0240                                 db_changed = 1;
; 0000 0241                             }
_0x13E:
; 0000 0242                         }
_0x13A:
; 0000 0243                     }
_0x130:
; 0000 0244 
; 0000 0245                 }
; 0000 0246                 else
	RJMP _0x13F
_0x121:
; 0000 0247                 {
; 0000 0248                     dbi_temp = 0;
	LDI  R30,LOW(0)
	__CLRD1SX 357
; 0000 0249                     dbi_final = 0;
	STS  _dbi_final,R30
	STS  _dbi_final+1,R30
	STS  _dbi_final+2,R30
	STS  _dbi_final+3,R30
; 0000 024A                     TCCR1B &= 0xF8;
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0000 024B                 }
_0x13F:
_0x120:
; 0000 024C                 /*
; 0000 024D                 if(db_monitoring)
; 0000 024E                 {
; 0000 024F                     rx_wr_index = 0;
; 0000 0250                     send_f(dbi_temp);
; 0000 0251                 }
; 0000 0252                 */
; 0000 0253 
; 0000 0254 
; 0000 0255                 sum_avg_max = 0;
	LDI  R30,LOW(0)
	__CLRD1SX 453
; 0000 0256                 sum_avg_min = 0;
	__CLRD1SX 449
; 0000 0257                 sum_avg_curr_max = 0;
	__CLRD1SX 445
; 0000 0258                 sum_avg_curr_min = 0;
	__CLRD1SX 441
; 0000 0259                 flow_sample_counter = 0;
	LDI  R16,LOW(0)
; 0000 025A                 sum_avg_sum_min = 0;
	STS  _sum_avg_sum_min,R30
	STS  _sum_avg_sum_min+1,R30
	STS  _sum_avg_sum_min+2,R30
	STS  _sum_avg_sum_min+3,R30
; 0000 025B                 sum_avg_sum_max = 0;
	STS  _sum_avg_sum_max,R30
	STS  _sum_avg_sum_max+1,R30
	STS  _sum_avg_sum_max+2,R30
	STS  _sum_avg_sum_max+3,R30
; 0000 025C                 sum_avg_curr_sum_min = 0;
	STS  _sum_avg_curr_sum_min,R30
	STS  _sum_avg_curr_sum_min+1,R30
	STS  _sum_avg_curr_sum_min+2,R30
	STS  _sum_avg_curr_sum_min+3,R30
; 0000 025D                 sum_avg_curr_sum_max = 0;
	STS  _sum_avg_curr_sum_max,R30
	STS  _sum_avg_curr_sum_max+1,R30
	STS  _sum_avg_curr_sum_max+2,R30
	STS  _sum_avg_curr_sum_max+3,R30
; 0000 025E             }
; 0000 025F             else
	RJMP _0x140
_0x116:
; 0000 0260                 flow_sample_counter++;
	SUBI R16,-1
; 0000 0261        //}//if(CALIB_PROCESSING == 0)
; 0000 0262        sample_ready_flag = 0;
_0x140:
; 0000 0263     }//sample_ready_flag
; 0000 0264     else
_0x103:
; 0000 0265      sample_ready_flag = 0;
_0x16B:
	CLR  R5
; 0000 0266   }//while(1)
	RJMP _0xD9
; 0000 0267 }
_0x142:
	RJMP _0x142
; .FEND
;void processSerialNumber()
; 0000 0269 {
_processSerialNumber:
; .FSTART _processSerialNumber
; 0000 026A     char temp[20];
; 0000 026B     char addr = 0;
; 0000 026C     unsigned char idx = 0;
; 0000 026D     serial_number_applied = 0;
	SBIW R28,20
	ST   -Y,R17
	ST   -Y,R16
;	temp -> Y+2
;	addr -> R17
;	idx -> R16
	LDI  R17,0
	LDI  R16,0
	LDI  R30,LOW(0)
	STS  _serial_number_applied,R30
; 0000 026E 
; 0000 026F     idx = 0;
	LDI  R16,LOW(0)
; 0000 0270     memset(temp,'\0',20);
	MOVW R30,R28
	ADIW R30,2
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
; 0000 0271    // send(rx_wr_index);
; 0000 0272     // for(index = 0; index < rx_wr_index ; index++)
; 0000 0273        // putchar(rx_buffer[index]);
; 0000 0274     //   printf("%x,",rx_buffer[index]);
; 0000 0275     addr = SERIAL_ADDR;
	LDI  R17,LOW(1)
; 0000 0276     while(rx_buffer[idx+2] != 0x04 && idx < rx_wr_index)
_0x143:
	MOV  R30,R16
	LDI  R31,0
	__ADDW1MN _rx_buffer,2
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ _0x146
	LDS  R30,_rx_wr_index
	CP   R16,R30
	BRLO _0x147
_0x146:
	RJMP _0x145
_0x147:
; 0000 0277     {
; 0000 0278       temp[idx] = rx_buffer[idx+2];
	MOV  R30,R16
	CALL SUBOPT_0x19
	MOV  R30,R16
	LDI  R31,0
	__ADDW1MN _rx_buffer,2
	LD   R30,Z
	ST   X,R30
; 0000 0279       //printf("%c,",temp[idx]);
; 0000 027A       //eeprom_write_byte(addr,temp[idx]);
; 0000 027B       //addr += 1;
; 0000 027C       idx++;
	SUBI R16,-1
; 0000 027D     }
	RJMP _0x143
_0x145:
; 0000 027E     //printf("%lu",atol(temp));
; 0000 027F     //if(eeprom_serial_num == SERIAL_NUMBER)
; 0000 0280     //{
; 0000 0281         eeprom_write_dword(addr,atol(temp));
	MOV  R30,R17
	LDI  R31,0
	PUSH R31
	PUSH R30
	MOVW R26,R28
	ADIW R26,2
	CALL _atol
	POP  R26
	POP  R27
	CALL __EEPROMWRD
; 0000 0282         eeprom_serial_num = atol(temp);
	MOVW R26,R28
	ADIW R26,2
	CALL _atol
	CALL SUBOPT_0x27
; 0000 0283     //}
; 0000 0284     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0285     //LED_R = 0;
; 0000 0286 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20E0009
; .FEND
;void processCalibrationChanged()
; 0000 0288 {
_processCalibrationChanged:
; .FSTART _processCalibrationChanged
; 0000 0289     char temp[20];
; 0000 028A     char * ch_temp;
; 0000 028B     char gainStr[10], offsetStr[10];
; 0000 028C     unsigned char idx = 0, len_total = 0, len_gain = 0, len_offset = 0;
; 0000 028D 
; 0000 028E     memset(gainStr,'\0',10);
	SBIW R28,40
	CALL __SAVELOCR6
;	temp -> Y+26
;	*ch_temp -> R16,R17
;	gainStr -> Y+16
;	offsetStr -> Y+6
;	idx -> R19
;	len_total -> R18
;	len_gain -> R21
;	len_offset -> R20
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	MOVW R30,R28
	ADIW R30,16
	CALL SUBOPT_0x75
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 028F     memset(offsetStr,'\0',10);
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 0290     memset(temp,'\0',20);
	MOVW R30,R28
	ADIW R30,26
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
; 0000 0291 
; 0000 0292     calibration_changed = 0;
	LDI  R30,LOW(0)
	STS  _calibration_changed,R30
; 0000 0293     idx = 0;
	LDI  R19,LOW(0)
; 0000 0294     memset(temp,'\0',20);
	MOVW R30,R28
	ADIW R30,26
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
; 0000 0295 
; 0000 0296 
; 0000 0297 
; 0000 0298     while(rx_buffer[idx+1] != 0x04 && idx < rx_wr_index)
_0x148:
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _rx_buffer,1
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ _0x14B
	LDS  R30,_rx_wr_index
	CP   R19,R30
	BRLO _0x14C
_0x14B:
	RJMP _0x14A
_0x14C:
; 0000 0299     {
; 0000 029A       temp[idx] = rx_buffer[idx+1];
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,26
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R19
	LDI  R31,0
	__ADDW1MN _rx_buffer,1
	LD   R30,Z
	ST   X,R30
; 0000 029B       idx++;
	SUBI R19,-1
; 0000 029C     }
	RJMP _0x148
_0x14A:
; 0000 029D    // printf("tempStr %s\n",temp);
; 0000 029E     len_total = strlen(temp);
	MOVW R26,R28
	ADIW R26,26
	CALL _strlen
	MOV  R18,R30
; 0000 029F     ch_temp = strchr(temp,',');
	MOVW R30,R28
	ADIW R30,26
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(44)
	CALL _strchr
	MOVW R16,R30
; 0000 02A0     len_gain = ch_temp - temp + 1;
	MOVW R30,R28
	ADIW R30,26
	MOV  R26,R30
	MOV  R30,R16
	SUB  R30,R26
	SUBI R30,-LOW(1)
	MOV  R21,R30
; 0000 02A1     memcpy(gainStr,temp + 1, len_gain - 1);
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,29
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R30
	CALL _memcpy
; 0000 02A2 
; 0000 02A3     len_offset = len_total - len_gain;
	MOV  R30,R18
	SUB  R30,R21
	MOV  R20,R30
; 0000 02A4     memcpy(offsetStr, temp + len_gain , len_offset);
	CALL SUBOPT_0x1B
	MOV  R30,R21
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,28
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R20
	CLR  R27
	CALL _memcpy
; 0000 02A5     //printf("gainStr %s offsetStr %s\n",gainStr,offsetStr);
; 0000 02A6     gain = atof(gainStr);
	MOVW R26,R28
	ADIW R26,16
	CALL _atof
	CALL SUBOPT_0x2B
; 0000 02A7     offset = atof(offsetStr);
	MOVW R26,R28
	ADIW R26,6
	CALL _atof
	CALL SUBOPT_0x2C
; 0000 02A8     //send_f(gain);
; 0000 02A9     //send_f(offset);
; 0000 02AA     eeprom_write_byte(0,0xBB);
	CALL SUBOPT_0x77
; 0000 02AB     eeprom_write_float(GAIN_ADDR,gain);
; 0000 02AC     eeprom_write_float(OFFSET_ADDR,offset);
; 0000 02AD     eeprom_write_float(CURR_ADDR,avg_curr_sum_max);
	LDS  R30,_avg_curr_sum_max
	LDS  R31,_avg_curr_sum_max+1
	LDS  R22,_avg_curr_sum_max+2
	LDS  R23,_avg_curr_sum_max+3
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	CALL __EEPROMWRD
; 0000 02AE 
; 0000 02AF     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 02B0     //TCCR1B |= 0x03;  // start timer1 after calibration
; 0000 02B1     delay_ms(1000);
	CALL SUBOPT_0x78
; 0000 02B2 
; 0000 02B3     //LED_R = 0;
; 0000 02B4 }
	CALL __LOADLOCR6
	ADIW R28,46
	RET
; .FEND
;void processCalibrationApplied()
; 0000 02B6 {
_processCalibrationApplied:
; .FSTART _processCalibrationApplied
; 0000 02B7     //unsigned char idx = 0;
; 0000 02B8     float send_array[2];
; 0000 02B9     calibration_applied = 0;
	SBIW R28,8
;	send_array -> Y+0
	LDI  R30,LOW(0)
	STS  _calibration_applied,R30
; 0000 02BA     //idx = 0;
; 0000 02BB     gain = (diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_Q2);
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
	CALL SUBOPT_0x79
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x2B
; 0000 02BC     offset = diff_Q3 - gain*dbi_Q3;
	CALL SUBOPT_0x79
	CALL SUBOPT_0x72
	CALL __MULF12
	LDS  R26,_diff_Q3
	LDS  R27,_diff_Q3+1
	LDS  R24,_diff_Q3+2
	LDS  R25,_diff_Q3+3
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2C
; 0000 02BD 
; 0000 02BE     //printf("diff_q3 %f dbi_q3 %f diff_Q2 %f dbi_Q2 %f d3-d2 %f Q3-Q2 %f gain %f offset %f\n",
; 0000 02BF     //        diff_Q3,dbi_Q3,diff_Q2,dbi_Q2,diff_Q3 - diff_Q2,dbi_Q3 - dbi_Q2,(diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_Q2),diff ...
; 0000 02C0 
; 0000 02C1     //TCCR1B |= 0x03;  // start timer1 after calibration
; 0000 02C2     delay_ms(1000);
	CALL SUBOPT_0x78
; 0000 02C3     send_array[0] = gain;
	CALL SUBOPT_0x2D
	CALL SUBOPT_0xE
; 0000 02C4     send_array[1] = offset;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x9
; 0000 02C5     eeprom_write_byte(0,0xBB);
	CALL SUBOPT_0x77
; 0000 02C6     eeprom_write_float(GAIN_ADDR,gain);
; 0000 02C7     eeprom_write_float(OFFSET_ADDR,offset);
; 0000 02C8     sendParamsFloat(send_array,2);
	MOVW R30,R28
	CALL SUBOPT_0x3E
; 0000 02C9     rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 02CA }
	ADIW R28,8
	RET
; .FEND
;/*
;void processPulseWidthSetting()
;{
;    char temp[20];
;
;    char PulseWidthStr[10];
;    unsigned char idx = 0, len_gain = 0;
;   // printf("avg_curr_sum_max %4.3f %4.3f\n",avg_curr_sum_max,avg_curr_sum_min);
;    memset(PulseWidthStr,'\0',10);
;
;    PulseWidthSettingApplied = 0;
;    idx = 0;
;    memset(temp,'\0',20);
;
;    while(rx_buffer[idx+1] != 0x04 && idx < rx_wr_index)
;    {
;      temp[idx] = rx_buffer[idx+1];
;      idx++;
;    }
;    len_gain = strlen(temp);
;    memcpy(PulseWidthStr,temp + 1, len_gain - 1);
;    pulseWidthTemp = atoi(PulseWidthStr);
;   // printf("pulseWidthTemp %d\n",pulseWidthTemp);
;
;    eeprom_write_byte(PULSE_WIDTH_VALID,0x55);
;    eeprom_write_byte(PULSE_WIDTH_ADDR,pulseWidthTemp);
;    rx_wr_index = 0;
;    //LED_R = 0;
;}
;*/
;void read_eeprom_Program1()
; 0000 02EA {
_read_eeprom_Program1:
; .FSTART _read_eeprom_Program1
; 0000 02EB            unsigned char check_byte;
; 0000 02EC            unsigned long int serial_number = 0;
; 0000 02ED            //char addr;
; 0000 02EE            float send_array[4];
; 0000 02EF            serial_number = 0;
	SBIW R28,20
	LDI  R30,LOW(0)
	STD  Y+16,R30
	STD  Y+17,R30
	STD  Y+18,R30
	STD  Y+19,R30
	ST   -Y,R17
;	check_byte -> R17
;	serial_number -> Y+17
;	send_array -> Y+1
	__CLRD1S 17
; 0000 02F0            rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 02F1            reade2prom1 = 0;
	CLR  R8
; 0000 02F2            delay_ms(1000);
	CALL SUBOPT_0x78
; 0000 02F3            check_byte = eeprom_read_byte(0);
	CALL SUBOPT_0x1D
	MOV  R17,R30
; 0000 02F4            //serial_number = eeprom_read_dword(SERIAL_ADDR);
; 0000 02F5 
; 0000 02F6            //addr = PULSE_WIDTH_ADDR;
; 0000 02F7            //pulseWidth = eeprom_read_byte(PULSE_WIDTH_ADDR);
; 0000 02F8            //addr = WINDOW_SIZE_ADDR;
; 0000 02F9            //windowSize = eeprom_read_byte(WINDOW_SIZE_ADDR);
; 0000 02FA            //addr = CUTT_OFF_ADDR;
; 0000 02FB            //cutt_off = eeprom_read_float(CUTT_OFF_ADDR);
; 0000 02FC 
; 0000 02FD            if (check_byte != 0xBB)
	CPI  R17,187
	BREQ _0x14D
; 0000 02FE            {
; 0000 02FF             offset = 0;
	CALL SUBOPT_0x25
; 0000 0300             gain = 0;
	CALL SUBOPT_0x26
; 0000 0301            }
; 0000 0302 
; 0000 0303            send_array[0] = offset;
_0x14D:
	CALL SUBOPT_0x2E
	__PUTD1S 1
; 0000 0304            send_array[1] = gain;
	CALL SUBOPT_0x2D
	__PUTD1S 5
; 0000 0305            send_array[2] = eeprom_serial_num;
	CALL SUBOPT_0x2F
	CALL __CDF1U
	CALL SUBOPT_0x7A
; 0000 0306            send_array[3] = eeprom_avg_curr_sum_max;
	CALL SUBOPT_0x73
	__PUTD1S 13
; 0000 0307            /*send_array[3] = cutt_off;
; 0000 0308            send_array[4] = VERSION;
; 0000 0309            send_array[6] = pulseWidth;
; 0000 030A            send_array[7] = windowSize;
; 0000 030B            send_array[8] = pulseMaxValuesLimit;
; 0000 030C            send_array[9] = diffSamplesLimit;
; 0000 030D            send_array[10] = signValue;
; 0000 030E            */
; 0000 030F            sendParamsFloat(send_array,4);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL _sendParamsFloat
; 0000 0310             //LED_R = 0;
; 0000 0311 }
	LDD  R17,Y+0
	ADIW R28,21
	RET
; .FEND
;void read_eeprom_Program2()
; 0000 0313 {
_read_eeprom_Program2:
; .FSTART _read_eeprom_Program2
; 0000 0314            unsigned char check_byte;
; 0000 0315            unsigned long int serial_number = 0;
; 0000 0316            //char addr;
; 0000 0317            float send_array[7];
; 0000 0318            serial_number = 0;
	SBIW R28,32
	LDI  R30,LOW(0)
	STD  Y+28,R30
	STD  Y+29,R30
	STD  Y+30,R30
	STD  Y+31,R30
	ST   -Y,R17
;	check_byte -> R17
;	serial_number -> Y+29
;	send_array -> Y+1
	__CLRD1S 29
; 0000 0319            rx_wr_index = 0;
	STS  _rx_wr_index,R30
; 0000 031A            reade2prom2 = 0;
	CLR  R11
; 0000 031B            delay_ms(1000);
	CALL SUBOPT_0x78
; 0000 031C            check_byte = eeprom_read_byte(0);
	CALL SUBOPT_0x1D
	MOV  R17,R30
; 0000 031D            //serial_number = eeprom_read_dword(SERIAL_ADDR);
; 0000 031E 
; 0000 031F            //addr = PULSE_WIDTH_ADDR;
; 0000 0320            //pulseWidth = eeprom_read_byte(PULSE_WIDTH_ADDR);
; 0000 0321            //addr = WINDOW_SIZE_ADDR;
; 0000 0322            //windowSize = eeprom_read_byte(WINDOW_SIZE_ADDR);
; 0000 0323            //addr = CUTT_OFF_ADDR;
; 0000 0324            //cutt_off = eeprom_read_float(CUTT_OFF_ADDR);
; 0000 0325 
; 0000 0326            if (check_byte != 0xBB)
	CPI  R17,187
	BREQ _0x14E
; 0000 0327            {
; 0000 0328             offset = 0;
	CALL SUBOPT_0x25
; 0000 0329             gain = 0;
	CALL SUBOPT_0x26
; 0000 032A            }
; 0000 032B 
; 0000 032C            /*send_array[0] = offset;
; 0000 032D            send_array[1] = gain;
; 0000 032E            send_array[2] = serial_number;
; 0000 032F            send_array[3] = cutt_off;
; 0000 0330            send_array[4] = eeprom_avg_curr_sum_max;
; 0000 0331            */
; 0000 0332            send_array[0] = VERSION;
_0x14E:
	__GETD1N 0x40800000
	__PUTD1S 1
; 0000 0333            send_array[1] = pulseWidth;
	LDS  R30,_pulseWidth
	CALL SUBOPT_0x49
	__PUTD1S 5
; 0000 0334            send_array[2] = windowSize;
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x7A
; 0000 0335            send_array[3] = cutt_off;
	CALL SUBOPT_0x29
	__PUTD1S 13
; 0000 0336            send_array[4] = pulseMaxValuesLimit;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x46
	__PUTD1S 17
; 0000 0337            send_array[5] = diffSamplesLimit;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x46
	__PUTD1S 21
; 0000 0338            send_array[6] = signValue;
	LDS  R30,_signValue
	CALL __CBD1
	CALL __CDF1
	__PUTD1S 25
; 0000 0339            sendParamsFloat(send_array,7);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(7)
	CALL _sendParamsFloat
; 0000 033A             //LED_R = 0;
; 0000 033B }
	LDD  R17,Y+0
	ADIW R28,33
	RET
; .FEND
;
;void processCuttOff(char addr)
; 0000 033E {
_processCuttOff:
; .FSTART _processCuttOff
; 0000 033F     char temp[20];
; 0000 0340     unsigned char idx;
; 0000 0341     idx = 0;
	ST   -Y,R26
	SBIW R28,20
	ST   -Y,R17
;	addr -> Y+21
;	temp -> Y+1
;	idx -> R17
	LDI  R17,LOW(0)
; 0000 0342 
; 0000 0343     memset(temp,'\0',20);
	MOVW R30,R28
	ADIW R30,1
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
; 0000 0344     while(rx_buffer[idx+2] != 0x04 && idx < rx_wr_index)
_0x14F:
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer,2
	LD   R26,Z
	CPI  R26,LOW(0x4)
	BREQ _0x152
	LDS  R30,_rx_wr_index
	CP   R17,R30
	BRLO _0x153
_0x152:
	RJMP _0x151
_0x153:
; 0000 0345     {
; 0000 0346       temp[idx] = rx_buffer[idx+2];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer,2
	LD   R30,Z
	ST   X,R30
; 0000 0347       idx++;
	SUBI R17,-1
; 0000 0348     }
	RJMP _0x14F
_0x151:
; 0000 0349         switch(addr)
	LDD  R30,Y+21
	LDI  R31,0
; 0000 034A         {
; 0000 034B             case CUTT_OFF_ADDR:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x157
; 0000 034C                 cutt_off = atof(temp);
	MOVW R26,R28
	ADIW R26,1
	CALL _atof
	CALL SUBOPT_0x28
; 0000 034D                 cutt_off_changed = 0;
	LDI  R30,LOW(0)
	STS  _cutt_off_changed,R30
; 0000 034E                 eeprom_write_float(addr,atof(temp));
	LDD  R30,Y+21
	LDI  R31,0
	PUSH R31
	PUSH R30
	MOVW R26,R28
	ADIW R26,1
	CALL _atof
	POP  R26
	POP  R27
	CALL __EEPROMWRD
; 0000 034F                 break;
	RJMP _0x156
; 0000 0350             case WINDOW_SIZE_ADDR:
_0x157:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x158
; 0000 0351                 windowSizeTemp = atoi(temp);//atof(temp);
	CALL SUBOPT_0x7B
	STS  _windowSizeTemp,R30
; 0000 0352                 windowSizeChanged = 0;
	LDI  R30,LOW(0)
	STS  _windowSizeChanged,R30
; 0000 0353                 eeprom_write_byte(addr,atoi(temp));
	LDD  R30,Y+21
	LDI  R31,0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7B
	POP  R26
	POP  R27
	CALL __EEPROMWRB
; 0000 0354                 insert_idx = 0;
	LDI  R30,LOW(0)
	STS  _insert_idx,R30
; 0000 0355                 addr = WINDOW_SIZE_VALID_ADDR;
	LDI  R30,LOW(23)
	STD  Y+21,R30
; 0000 0356                 eeprom_write_byte(addr,0x55);
	LDD  R26,Y+21
	CLR  R27
	LDI  R30,LOW(85)
	RJMP _0x16C
; 0000 0357                 break;
; 0000 0358             case PULSE_WIDTH_ADDR:
_0x158:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x159
; 0000 0359                 PulseWidthSettingApplied = 0;
	LDI  R30,LOW(0)
	STS  _PulseWidthSettingApplied,R30
; 0000 035A                 pulseWidthTemp = atoi(temp);
	CALL SUBOPT_0x7B
	STS  _pulseWidthTemp,R30
; 0000 035B                 // printf("pulseWidthTemp %d\n",pulseWidthTemp);
; 0000 035C                 eeprom_write_byte(PULSE_WIDTH_VALID,0x55);
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x7C
; 0000 035D                 eeprom_write_byte(PULSE_WIDTH_ADDR,pulseWidthTemp);
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	RJMP _0x16C
; 0000 035E                 break;
; 0000 035F             case EP_SAMPLES_LIMIT_ADDR:
_0x159:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0x15A
; 0000 0360                 ep_change_diff_samples_limit_flag = 0;
	LDI  R30,LOW(0)
	STS  _ep_change_diff_samples_limit_flag,R30
; 0000 0361                 diffSamplesLimit = atoi(temp);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x22
; 0000 0362                 // printf("pulseWidthTemp %d\n",pulseWidthTemp);
; 0000 0363                 eeprom_write_byte(EP_SAMPLES_LIMIT_VALID_ADDR,0x55);
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	CALL SUBOPT_0x7C
; 0000 0364                 eeprom_write_byte(EP_SAMPLES_LIMIT_ADDR,pulseWidthTemp);
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x16C
; 0000 0365                 break;
; 0000 0366             case EP_PULSE_MAX_VALUE_LIMIT_ADDR:
_0x15A:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0x15B
; 0000 0367                 ep_change_pulse_limit_flag = 0;
	LDI  R30,LOW(0)
	STS  _ep_change_pulse_limit_flag,R30
; 0000 0368                 pulseMaxValuesLimit = atoi(temp);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x20
; 0000 0369                 // printf("pulseWidthTemp %d\n",pulseWidthTemp);
; 0000 036A                 eeprom_write_byte(EP_PULSE_MAX_VALUE_LIMIT_VALID_ADDR,0x55);
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	CALL SUBOPT_0x7C
; 0000 036B                 eeprom_write_byte(EP_PULSE_MAX_VALUE_LIMIT_ADDR,pulseWidthTemp);
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	RJMP _0x16C
; 0000 036C                 break;
; 0000 036D             case SIGN_ADDR:
_0x15B:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x156
; 0000 036E                 inverseSignCmd = 0;
	LDI  R30,LOW(0)
	STS  _inverseSignCmd,R30
; 0000 036F                 signValue = -signValue;
	LDS  R30,_signValue
	NEG  R30
	STS  _signValue,R30
; 0000 0370                 eeprom_write_byte(SIGN_VALID_ADDR,0x55);
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	LDI  R30,LOW(85)
	CALL __EEPROMWRB
; 0000 0371                 eeprom_write_byte(SIGN_ADDR,signValue);
	LDS  R30,_signValue
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
_0x16C:
	CALL __EEPROMWRB
; 0000 0372                 break;
; 0000 0373         }
_0x156:
; 0000 0374     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0375     //LED_R = 0;
; 0000 0376 }
	LDD  R17,Y+0
_0x20E0009:
	ADIW R28,22
	RET
; .FEND
;void processGenerateFout(unsigned char value)
; 0000 0378 {
_processGenerateFout:
; .FSTART _processGenerateFout
; 0000 0379     start_fout_test = 0;
	ST   -Y,R26
;	value -> Y+0
	LDI  R30,LOW(0)
	STS  _start_fout_test,R30
; 0000 037A     stop_fout_test = 0;
	STS  _stop_fout_test,R30
; 0000 037B     generate_fout_test = value;
	LD   R30,Y
	STS  _generate_fout_test,R30
; 0000 037C     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 037D     //LED_R = 0;
; 0000 037E }
	JMP  _0x20E0008
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
	JMP  _0x20E0007
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
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
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

	.DSEG

	.CSEG

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
_0x20E0008:
	ADIW R28,1
	RET
; .FEND
_put_usart_G102:
; .FSTART _put_usart_G102
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x30
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
_0x20E0007:
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x0
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20E0006
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20E0006
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x9
	RJMP _0x204001C
_0x204001E:
	CALL SUBOPT_0x7E
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x9
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x7F
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x9
_0x2040022:
	CALL SUBOPT_0x7F
	BRLO _0x2040024
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x7F
	BRSH _0x2040028
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x9
_0x2040025:
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
	CALL SUBOPT_0x7F
	BRLO _0x2040029
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	CALL SUBOPT_0xA
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x9
	__GETD1S 4
	CALL SUBOPT_0x80
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x86
	CALL SUBOPT_0x87
	CALL SUBOPT_0x49
	CALL SUBOPT_0xA
	CALL __MULF12
	CALL SUBOPT_0x80
	CALL SUBOPT_0xB
	CALL SUBOPT_0x83
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x86
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x88
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040116
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040116:
	ST   X,R30
	CALL SUBOPT_0x88
	CALL SUBOPT_0x88
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x88
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0006:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x89
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x89
	RJMP _0x2040117
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8A
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x8C
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x8D
	CALL __GETD1P
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	CALL SUBOPT_0x90
	CALL __ANEGF1
	CALL SUBOPT_0x8E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x8C
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	CALL SUBOPT_0x90
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2040065
_0x2040064:
	CALL SUBOPT_0x90
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x91
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x92
	CALL SUBOPT_0x91
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x92
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x93
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	CALL SUBOPT_0x93
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x93
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x93
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8D
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040118
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x92
	CALL __CWD1
	RJMP _0x2040118
_0x2040081:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x92
	CLR  R22
	CLR  R23
_0x2040118:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	CALL SUBOPT_0x90
	CALL __ANEGD1
	CALL SUBOPT_0x8E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	CALL SUBOPT_0x89
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	CALL SUBOPT_0x94
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x8C
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009C
_0x204009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	CALL SUBOPT_0x89
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	CALL SUBOPT_0x95
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040119
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040119:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	CALL SUBOPT_0x94
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	CALL SUBOPT_0x89
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x95
	CALL __MODD21U
	CALL SUBOPT_0x8E
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x93
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x8C
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040117:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x96
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0005
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x96
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x97
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
_0x20E0005:
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
	CALL SUBOPT_0x97
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
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND
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
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
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
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x0
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x206000D
	CALL SUBOPT_0x98
	__POINTW2FN _0x2060000,0
	CALL _strcpyf
	RJMP _0x20E0004
_0x206000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x206000C
	CALL SUBOPT_0x98
	__POINTW2FN _0x2060000,1
	CALL _strcpyf
	RJMP _0x20E0004
_0x206000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x206000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x99
	LDI  R30,LOW(45)
	ST   X,R30
_0x206000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2060010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2060010:
	LDD  R17,Y+8
_0x2060011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2060013
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x85
	CALL SUBOPT_0x9B
	RJMP _0x2060011
_0x2060013:
	CALL SUBOPT_0x9C
	CALL __ADDF12
	CALL SUBOPT_0x7A
	LDI  R17,LOW(0)
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9B
_0x2060014:
	CALL SUBOPT_0x9C
	CALL __CMPF12
	BRLO _0x2060016
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9B
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2060017
	CALL SUBOPT_0x98
	__POINTW2FN _0x2060000,5
	CALL _strcpyf
	RJMP _0x20E0004
_0x2060017:
	RJMP _0x2060014
_0x2060016:
	CPI  R17,0
	BRNE _0x2060018
	CALL SUBOPT_0x99
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2060019
_0x2060018:
_0x206001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206001C
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x9C
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x99
	CALL SUBOPT_0x87
	LDI  R31,0
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x9E
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7A
	RJMP _0x206001A
_0x206001C:
_0x2060019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20E0003
	CALL SUBOPT_0x99
	LDI  R30,LOW(46)
	ST   X,R30
_0x206001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2060020
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7A
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x99
	CALL SUBOPT_0x87
	LDI  R31,0
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x46
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7A
	RJMP _0x206001E
_0x2060020:
_0x20E0003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
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
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x46
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	CALL SUBOPT_0xC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x83
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
	CALL SUBOPT_0x80
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x9F
	CALL __ADDF12
	CALL SUBOPT_0xC
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
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
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x83
_0x2060059:
	CPI  R21,0
	BREQ _0x206005B
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x80
	CALL __MULF12
	CALL SUBOPT_0x83
	MOV  R30,R20
	AND  R30,R21
	BREQ _0x206005C
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
_0x206005C:
	LSR  R21
	RJMP _0x2060059
_0x206005B:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x206005D
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x9F
	CALL __DIVF21
	RJMP _0x206006E
_0x206005D:
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x9F
	CALL __MULF12
_0x206006E:
	__PUTD1S 8
_0x206004E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206005F
	CALL SUBOPT_0xD
	CALL __ANEGF1
	CALL SUBOPT_0xC
_0x206005F:
	CALL SUBOPT_0xD
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
	ADIW R28,1
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0xA0
    brne __floor1
__floor0:
	CALL SUBOPT_0xF
	RJMP _0x20E0001
__floor1:
    brtc __floor0
	CALL SUBOPT_0xF
	CALL SUBOPT_0x8
	CALL __SUBF12
	RJMP _0x20E0001
; .FEND
_ceil:
; .FSTART _ceil
	CALL SUBOPT_0xA0
    brne __ceil1
__ceil0:
	CALL SUBOPT_0xF
	RJMP _0x20E0001
__ceil1:
    brts __ceil0
	CALL SUBOPT_0xF
	CALL SUBOPT_0x63
_0x20E0001:
	ADIW R28,4
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

	.DSEG
_calibration_applied:
	.BYTE 0x1
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
_min_max_cnt_cmd:
	.BYTE 0x1
_current_sample_min:
	.BYTE 0x1
_current_sample_max:
	.BYTE 0x1
_PulseWidthSettingApplied:
	.BYTE 0x1
_cutt_off_changed:
	.BYTE 0x1
_start_fout_test:
	.BYTE 0x1
_stop_fout_test:
	.BYTE 0x1
_windowSizeChanged:
	.BYTE 0x1
_windowSize:
	.BYTE 0x1
_windowSizeTemp:
	.BYTE 0x1
_insert_idx:
	.BYTE 0x1
_respose_uart_activity:
	.BYTE 0x1
_ep_positive_pulse_measurement:
	.BYTE 0x1
_ep_negative_pulse_measurement:
	.BYTE 0x1
_ep_check_cmd:
	.BYTE 0x1
_ep_change_diff_samples_limit_flag:
	.BYTE 0x1
_ep_change_pulse_limit_flag:
	.BYTE 0x1
_inverseSignCmd:
	.BYTE 0x1
_read_max_samples:
	.BYTE 0x1
_read_min_samples:
	.BYTE 0x1
_pulseWidthTemp:
	.BYTE 0x1
_generate_fout_test:
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
_sum_avg_curr_sum_max:
	.BYTE 0x4
_sum_avg_curr_sum_min:
	.BYTE 0x4
_avg_curr_sum_max:
	.BYTE 0x4
_eeprom_avg_curr_sum_max:
	.BYTE 0x4
_cutt_off:
	.BYTE 0x4
_signValue:
	.BYTE 0x1
_pulseMaxValuesLimit:
	.BYTE 0x2
_diffSamplesLimit:
	.BYTE 0x2
_ovf_timer0_cnt:
	.BYTE 0x4
_pulse_edge_cnt:
	.BYTE 0x4
_eeprom_serial_num:
	.BYTE 0x4
_db_changed:
	.BYTE 0x1
_pulseWidth:
	.BYTE 0x1
_state_S0000002000:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0xFA
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_state_S0000007000:
	.BYTE 0x1
_counter_S0000007000:
	.BYTE 0x1
_wathchdog_counter_S0000010000:
	.BYTE 0x2
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__GETD2S 4
	CALL __ORD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R31,0
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	LDS  R26,_dbi_final
	LDS  R27,_dbi_final+1
	LDS  R24,_dbi_final+2
	LDS  R25,_dbi_final+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDS  R30,_counter_S0000007000
	SUBI R30,-LOW(1)
	STS  _counter_S0000007000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDS  R30,_pulseWidth
	LDI  R31,0
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	SBIW R30,25
	LDS  R26,_counter_S0000007000
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	MOVW R30,R0
	SBIW R30,21
	LDS  R26,_counter_S0000007000
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	SBIW R30,20
	LDS  R26,_counter_S0000007000
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	MOVW R30,R0
	SBIW R30,1
	LDS  R26,_counter_S0000007000
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R26,Z
	CPI  R26,LOW(0x3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,24
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STS  _pulseMaxValuesLimit,R30
	STS  _pulseMaxValuesLimit+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDS  R30,_pulseMaxValuesLimit
	LDS  R31,_pulseMaxValuesLimit+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	STS  _diffSamplesLimit,R30
	STS  _diffSamplesLimit+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOV  R26,R17
	CLR  R27
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDS  R30,_diffSamplesLimit
	LDS  R31,_diffSamplesLimit+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	STS  _offset,R30
	STS  _offset+1,R30
	STS  _offset+2,R30
	STS  _offset+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	STS  _gain,R30
	STS  _gain+1,R30
	STS  _gain+2,R30
	STS  _gain+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	STS  _eeprom_serial_num,R30
	STS  _eeprom_serial_num+1,R31
	STS  _eeprom_serial_num+2,R22
	STS  _eeprom_serial_num+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	STS  _cutt_off,R30
	STS  _cutt_off+1,R31
	STS  _cutt_off+2,R22
	STS  _cutt_off+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x29:
	LDS  R30,_cutt_off
	LDS  R31,_cutt_off+1
	LDS  R22,_cutt_off+2
	LDS  R23,_cutt_off+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	MOV  R26,R17
	CLR  R27
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	STS  _gain,R30
	STS  _gain+1,R31
	STS  _gain+2,R22
	STS  _gain+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	STS  _offset,R30
	STS  _offset+1,R31
	STS  _offset+2,R22
	STS  _offset+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2D:
	LDS  R30,_gain
	LDS  R31,_gain+1
	LDS  R22,_gain+2
	LDS  R23,_gain+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	LDS  R30,_offset
	LDS  R31,_offset+1
	LDS  R22,_offset+2
	LDS  R23,_offset+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R30,_eeprom_serial_num
	LDS  R31,_eeprom_serial_num+1
	LDS  R22,_eeprom_serial_num+2
	LDS  R23,_eeprom_serial_num+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETW1SX 655
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__GETW1SX 653
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	__GETW2SX 643
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETW1SX 671
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETW1SX 651
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	__GETD2SX 473
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETW2SX 641
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	__GETW1SX 669
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	__GETW1SX 649
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__GETD2SX 469
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x3B:
	__PUTD1SX 361
	MOVW R30,R28
	SUBI R30,LOW(-(361))
	SBCI R31,HIGH(-(361))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDS  R30,_pulse_edge_cnt
	LDS  R31,_pulse_edge_cnt+1
	LDS  R22,_pulse_edge_cnt+2
	LDS  R23,_pulse_edge_cnt+3
	CALL __CDF1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3D:
	CALL __PUTDP1
	MOVW R30,R28
	SUBI R30,LOW(-(361))
	SBCI R31,HIGH(-(361))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _sendParamsFloat
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	LDS  R30,_wathchdog_counter_S0000010000
	LDS  R31,_wathchdog_counter_S0000010000+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _sendParamsFloat
	LDI  R30,LOW(0)
	STS  _wd_monitoring,R30
	STS  _rx_wr_index,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x41:
	__GETD2SX 429
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x42:
	CALL __PUTDZ20
	MOVW R30,R28
	SUBI R30,LOW(-(361))
	SBCI R31,HIGH(-(361))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	LDS  R26,_avg_curr_sum_max
	LDS  R27,_avg_curr_sum_max+1
	LDS  R24,_avg_curr_sum_max+2
	LDS  R25,_avg_curr_sum_max+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x44:
	__GETD2SX 357
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	__GETW2SX 667
	__GETW1SX 665
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x46:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	__GETW2SX 661
	__GETW1SX 663
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x46
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x49:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x35
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	__PUTD1SX 417
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	RCALL SUBOPT_0x46
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x39
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	__PUTD1SX 413
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	__GETD2SX 413
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	__GETW1SX 647
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	__GETW1SX 645
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL _sendParamsFloat
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	__GETD1SX 417
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x55:
	CALL __SUBF12
	__PUTD1SX 437
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	__GETD1SX 437
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	__GETD2SX 433
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(0)
	__CLRD1SX 437
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x59:
	__GETD1SX 397
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5A:
	__GETD1SX 401
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x59
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5C:
	ADIW R30,4
	__GETD2SX 401
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5D:
	LDS  R26,_offset
	LDS  R27,_offset+1
	LDS  R24,_offset+2
	LDS  R25,_offset+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5E:
	STS  _dbi_final,R30
	STS  _dbi_final+1,R31
	STS  _dbi_final+2,R22
	STS  _dbi_final+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	__GETD2SX 453
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	__GETD2SX 449
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	__GETD2SX 445
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	__GETD2SX 441
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x8
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x64:
	CALL __DIVF21
	__PUTD1SX 429
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x65:
	CALL __DIVF21
	__PUTD1SX 425
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x66:
	CALL __DIVF21
	STS  _avg_curr_sum_max,R30
	STS  _avg_curr_sum_max+1,R31
	STS  _avg_curr_sum_max+2,R22
	STS  _avg_curr_sum_max+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x67:
	CALL __DIVF21
	__PUTD1SX 421
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	__GETD2SX 425
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6A:
	CALL __PUTDZ20
	LDS  R30,_insert_idx
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	LDS  R26,_sum_avg_sum_min
	LDS  R27,_sum_avg_sum_min+1
	LDS  R24,_sum_avg_sum_min+2
	LDS  R25,_sum_avg_sum_min+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	LDS  R26,_sum_avg_sum_max
	LDS  R27,_sum_avg_sum_max+1
	LDS  R24,_sum_avg_sum_max+2
	LDS  R25,_sum_avg_sum_max+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	LDS  R26,_sum_avg_curr_sum_min
	LDS  R27,_sum_avg_curr_sum_min+1
	LDS  R24,_sum_avg_curr_sum_min+2
	LDS  R25,_sum_avg_curr_sum_min+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	LDS  R26,_sum_avg_curr_sum_max
	LDS  R27,_sum_avg_curr_sum_max+1
	LDS  R24,_sum_avg_curr_sum_max+2
	LDS  R25,_sum_avg_curr_sum_max+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	LDS  R30,_windowSize
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x70:
	__PUTD1SX 357
	RCALL SUBOPT_0x44
	CALL _fabs
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x71:
	IN   R30,0x2E
	ORI  R30,LOW(0x5)
	OUT  0x2E,R30
	LDI  R30,LOW(1)
	STS  _db_changed,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x72:
	LDS  R26,_gain
	LDS  R27,_gain+1
	LDS  R24,_gain+2
	LDS  R25,_gain+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	LDS  R30,_eeprom_avg_curr_sum_max
	LDS  R31,_eeprom_avg_curr_sum_max+1
	LDS  R22,_eeprom_avg_curr_sum_max+2
	LDS  R23,_eeprom_avg_curr_sum_max+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	RCALL SUBOPT_0x6
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x77:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(187)
	CALL __EEPROMWRB
	RCALL SUBOPT_0x2D
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __EEPROMWRD
	RCALL SUBOPT_0x2E
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL __EEPROMWRD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	LDS  R30,_dbi_Q3
	LDS  R31,_dbi_Q3+1
	LDS  R22,_dbi_Q3+2
	LDS  R23,_dbi_Q3+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7A:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7B:
	MOVW R26,R28
	ADIW R26,1
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	LDI  R30,LOW(85)
	CALL __EEPROMWRB
	LDS  R30,_pulseWidthTemp
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	RCALL SUBOPT_0xA
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7E:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7F:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x80:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x81:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	RCALL SUBOPT_0x80
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x83:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x84:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x85:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x87:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x88:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x89:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8A:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8B:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8C:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x8D:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x8A
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x90:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x91:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x92:
	RCALL SUBOPT_0x8D
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x93:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x94:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x95:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x96:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x98:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x99:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9F:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA0:
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	RJMP SUBOPT_0xE


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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
	CLR  R25
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
