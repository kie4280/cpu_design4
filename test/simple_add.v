// Author: 0710012 何權祐, 0710018 張宸愷
`timescale 1ns/1ps

module add(A, B, CIN, COUT, SUM);

	input A, B, CIN;
	output COUT, SUM;

	assign {COUT, SUM} = A + B + CIN;
	
endmodule