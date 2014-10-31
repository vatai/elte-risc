	LOC Data_Segment
	GREG @
txt	BYTE "Hello Worl",10,0

	LOC #100

Main	LDA $255,txt
	TRAP 0,Fputs,StdOut

	PUT 255,$1
	ADDU $1,$1,$1
	
	TRAP 0,Halt,0
	
