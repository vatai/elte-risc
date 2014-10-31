blocks 	IS		2
t		IS		$255
fid		IS		3*8
A1		IS		$0
A2		IS		$1
B1		IS		$2
B2		IS		$3
C1		IS		$4
C2		IS		$5
S		IS		$6
I		IS		$8
J		IS		$9
K		IS		$10
N		IS		$11

I2		IS		$12
J2		IS		$13
K2		IS		$14
SUM		IS		$15
AE		IS		$16
BE		IS		$17

WB		IS		$0
WS		IS		$1
WI		IS		$2
WK		IS		$3
WO		IS		$4


		LOC	Data_Segment
		GREG	@
fname	BYTE	"matrix2.bin",0
argopen	OCTA	fname,BinaryRead
argread	OCTA	buffer
size	OCTA	4
wrb		TETRA	0,0,0,0
wrarg	OCTA	wrb,5
buffer	TETRA	0
	
		LOC	#100
Main	SWYM
*************************************	
		LDA		t,argopen
		TRAP	0,Fopen,fid

		LDA		t,argread
		TRAP	0,Fread,fid

		LDA		t,buffer
		LDT		$0,t
		SET		$2,$0
		
		LDA		t,size
		MUL		$0,$0,$0
		MUL		$0,$0,4
		STO		$0,t

		LDA		t,argread
		TRAP	0,Fread,fid

		TRAP	0,Fclose,fid

		LDA		t,size
		STO		$2,t

		LDA		$1,buffer

		PUSHJ	0,PrMx

*************************************
	
		LDA		t,size
		LDO		S,t

		LDA		A1,buffer

		LDA		B1,buffer

		SET		t,S
		MUL		t,t,t
		MUL		t,t,8

		LDA		C1,buffer
		ADD		C1,C1,t

		SET		N,S
		DIV		N,N,blocks

		SET		I,0

Loop1	CMP		t,I,N
		BZ		t,Loop1E

		ADD		I,I,1

		SET		J,0

Loop2	CMP		t,J,N
		BZ		t,Loop2E

		ADD		J,J,1

		SET		K,0

Loop3	CMP		t,K,N
		BZ		t,Loop3E

		ADD		K,K,1

		*MXMUL

		SET		A2,A1
		SET		B2,B1
		SET		C2,C1

		********************************

		SET		I2,0

Loop4	CMP		t,I2,blocks
		BZ		t,Loop4E

		ADD		I2,I2,1

		SET		J2,0

Loop5	CMP		t,J2,blocks
		BZ		t,Loop5E

		ADD		J2,J2,1

		SET		SUM,0

		SET		K2,0

Loop6	CMP		t,K2,blocks
		BZ		t,Loop6E

		ADD		K2,K2,1

		LDT		AE,A2,0
		LDT		BE,B2,0

		MUL		AE,AE,BE
		ADD		SUM,SUM,AE

		ADD		A2,A2,4

		*A2	:=	A2 + 4

		SET		t,S
		MUL		t,t,4
		ADD		B2,B2,t

		*B2 :=	B2 + S*4

		JMP		Loop6

Loop6E	SET		t,blocks
		MUL		t,t,4
		SUB		A2,A2,t

		*A2 :=	A2 - blocks*4

		SET		t,blocks
		MUL		t,t,S
		MUL		t,t,4
		SUB		B2,B2,t

		*B2 :=	B2 - blocks*S*4

		ADD		B2,B2,4

		*B2 :=	B2 + 4
		
		LDO		t,C2
		ADD		t,t,SUM
		STT		t,C2

		ADD		C2,C2,4

		*C2	:=	C2 + 4

		JMP		Loop5

Loop5E	SET		t,S
		MUL		t,t,4
		ADD		A2,A2,t

		*A2 :=	A2 + S*4

		ADD		C2,C2,t

		*C2 :=	C2 + S*4

		SET		t,blocks
		MUL		t,t,4
		SUB		B2,B2,t

		*B2 :=	B2 - blocks*4

		SUB		C2,C2,t

		*C2	:=	C2 - blocks*4

		JMP		Loop4

Loop4E	SWYM


		********************************

		SET		t,blocks
		MUL		t,t,4
		ADD		A1,A1,t

		*A1 := A1 + blocks*4

		SET		t,S
		MUL		t,t,blocks
		MUL		t,t,4
		ADD		B1,B1,t

		*B1 := B1 + S*blocks*4

		JMP		Loop3

Loop3E	SET		t,N
		MUL		t,t,blocks
		MUL		t,t,4
		SUB		A1,A1,t
		
		*A1 := A1 - N*blocks*4

		SET		t,N
		MUL		t,t,S
		MUL		t,t,blocks
		MUL		t,t,4
		SUB		B1,B1,t

		*B1 :=	B1 - N*S*blocks*4

		SET		t,blocks
		MUL		t,t,4
		ADD		B1,B1,t

		*B1	:=	B1 + blocks*4

		ADD		C1,C1,t

		*C1 :=	C1 + blocks*4

		JMP		Loop2

Loop2E	SET		t,N
		MUL		t,t,blocks
		MUL		t,t,4
		SUB		B1,B1,t

		*B1 :=	B1 - N*blocks*4

		SET		t,S
		MUL		t,t,blocks
		MUL		t,t,4
		ADD		A1,A1,t

		*A1 := A1 + S*blocks*4

		SET		t,N
		MUL		t,t,blocks
		MUL		t,t,4
		SUB		C1,C1,t

		*C1 := C1 - N*blocks*4

		SET		t,S
		MUL		t,t,blocks
		MUL		t,t,4
		ADD		C1,C1,t

		*C1 := C1 + S*blocks*4

		JMP		Loop1

Loop1E	SWYM

		SET		t,S
		MUL		t,t,t
		MUL		t,t,8

		LDA		C1,buffer
		ADD		C1,C1,t

		SET		$1,C1
		SET		$2,S

		PUSHJ	0,PrMx
		
		TRAP	0,Halt,0
		

PrMx	SWYM *$0 buffer, $1 size

		SET		WI,0
		

PRL1	CMP		t,WI,WS
		BZ		t,PRL1E

		ADD		WI,WI,1

		SET		WK,0
		
PRL2	CMP		t,WK,WS
		BZ		t,PRL2E

		ADD		WK,WK,1

		LDT		WO,WB
		
		LDA		$5,wrb
		SET		$6,WO

		DIV		$6,$6,10
		GET		$7,rR
		ADD		$7,$7,48
		STB		$7,$5,3

		DIV		$6,$6,10
		GET		$7,rR
		ADD		$7,$7,48
		STB		$7,$5,2

		DIV		$6,$6,10
		GET		$7,rR
		ADD		$7,$7,48
		STB		$7,$5,1

		DIV		$6,$6,10
		GET		$7,rR
		ADD		$7,$7,48
		STB		$7,$5,0

		SET		$7,0
		STB		$7,$5,4

		LDA		t,wrarg
		TRAP	0,Fwrite,StdOut

		ADD		WB,WB,4

		JMP PRL2

PRL2E	SWYM

		LDA		$5,wrb

		SET		$6,0
		STB		$6,$5,0

		SET		$6,0
		STB		$6,$5,1

		SET		$6,0
		STB		$6,$5,2

		SET		$6,0
		STB		$6,$5,3

		SET		$6,10
		STB		$6,$5,4

		LDA		t,wrarg
		TRAP	0,Fwrite,StdOut

		JMP PRL1

PRL1E	SWYM

		LDA		$5,wrb

		SET		$6,0
		STB		$6,$5,0

		SET		$6,0
		STB		$6,$5,1

		SET		$6,0
		STB		$6,$5,2

		SET		$6,0
		STB		$6,$5,3

		SET		$6,10
		STB		$6,$5,4

		LDA		t,wrarg
		TRAP	0,Fwrite,StdOut

		POP		0,0