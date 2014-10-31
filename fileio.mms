	LOC	Data_Segment
	GREG	@
msg	BYTE	"HI",10,0

	LOC	#100
Main	LDOU	$255,$1,8
	
	TRAP	0,Fputs,StdOut
end	TRAP	0,Halt,0
