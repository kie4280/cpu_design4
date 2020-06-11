// Author: 0710012 何權祐, 0710018 張宸愷

module ALU(
    rst_n,
    src1_i,
    src2_i,
    ctrl_i,
    result_o,
    zero_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input rst_n;

output reg[32-1:0]	 result_o;
output reg           zero_o;

//Internal signals

wire          cout_out;
wire          overflow_out;
reg [3-1:0]   comp;
reg [4-1:0]   ALU_Ctrl;
wire [32-1:0] result_out;
wire [64-1:0] shift_src;
wire zero_unused;


Sign_Extend2 e2(
    .data_i(src2_i),
    .data_o(shift_src)
);

alu alu(
	.rst_n(rst_n),
	.src1(src1_i),
	.src2(src2_i),
	.ALU_control(ALU_Ctrl),
	.comp(comp),
	.result(result_out),
	.zero(zero_unused),
	.cout(cout_out),
	.overflow(overflow_out)
);



//actual ALU control code
localparam [4-1:0] AND=0, OR=1, LW=2, SW=3, ADDU=4, SUBU=5, SLT=6, BLEZ=7,
                   SRA=8, SRAV=9, LUI=10, SLTU=11, SLL=12, SMUL=13, BGTZ=14;

always@(*) begin

    if(ctrl_i == SLT) comp = 3'b000;
    else if(ctrl_i == SLTU) comp = 3'b101; 
    else if(ctrl_i == BLEZ) comp = 3'b010;
    else if(ctrl_i == BGTZ) comp = 3'b001;
    

    case(ctrl_i) 
        AND: begin
            ALU_Ctrl = 4'b0000;
            result_o = result_out;
        end
        OR: begin
            ALU_Ctrl = 4'b0001;
            result_o = result_out;
        end
        ADDU: begin
            ALU_Ctrl = 4'b0010;
            result_o = result_out;
        end
        SUBU: begin
            ALU_Ctrl = 4'b0110;
            result_o = result_out;
        end
        SLT: begin
            ALU_Ctrl = 4'b0111; 
            result_o = result_out;
        end
        LUI: begin
            result_o = {src2_i[15:0], 16'b0};
        end
        SLTU: begin
            ALU_Ctrl = 4'b0111;
            result_o = result_out;
        end
        SRA: begin
            result_o = shift_src >> src1_i[10:6];

        end
        SRAV: begin
            result_o = shift_src >> src1_i[4:0];

        end
        SLL: begin
            result_o = shift_src << src1_i[10:6];
        end
        
        SMUL: begin 
            ALU_Ctrl = 4'b0000;
            result_o = src1_i * src2_i;
        end
        LW: begin 
            ALU_Ctrl = 4'b0010;
            result_o = result_out;
        end
        SW: begin 
            ALU_Ctrl = 4'b0010;
            result_o = result_out;
        end
        BLEZ: begin 
            ALU_Ctrl = 4'b0111;
            result_o = result_out;
        end
        BGTZ: begin 
            ALU_Ctrl = 4'b0111;
            result_o = result_out;
        end

        default: begin


        end

    endcase

    zero_o = ~(|result_o);


end


endmodule
