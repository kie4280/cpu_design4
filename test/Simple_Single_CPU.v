// Author: 0710012 何權祐, 0710018 張宸愷

module CPU(
    clk_i,
    start_i
    );

// Input port
input clk_i;
input start_i;

wire [32-1:0] instruction;
wire [32-1:0] ProgramCounter_i, ProgramCounter_o, ProgramCounter_4, ProgramCounter_j_jal,
              ProgramCounter_w, ProgramCounter_b, ProgramCounter_j, ProgramCounter_bran, ProgramCounter_jr;
wire [32-1:0] RSdata, RTdata, RDdata, ALU_Result, Mux_Alu_src2, Mux_Alu_src1;
wire [5-1:0]  RD_addr;
wire reg_write, branch, branch_eq, jump, alu_src1;
wire [2-1:0] reg_dst, reg_data_select;
wire [2-1:0] alu_src2;
wire[4-1:0] alu_op;
wire sign, zero;
wire [4-1:0] alu_ctrl;
wire [2-1:0] PC_select;
wire [32-1:0] DM_ADDR, DM_DATA_IN, DM_DATA_OUT;
wire MEMREAD, MEMWRITE;

assign DM_ADDR = ALU_Result;
assign ProgramCounter_jr = RSdata;
assign ProgramCounter_j_jal = {ProgramCounter_o[31:28], instruction[25:0], 2'b0};
assign DM_DATA_IN = RTdata;

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (start_i),
    .pc_in_i(ProgramCounter_i),//
    .pc_out_o(ProgramCounter_o)
    );

Adder Adder1(
    .src1_i(ProgramCounter_o),//
    .src2_i(32'd4),//
    .sum_o(ProgramCounter_4)//
    );

Instruction_Memory IM(
    .addr_i(ProgramCounter_o),
    .instr_o(instruction)
    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instruction[20:16]),
    .data1_i(instruction[15:11]),
    .data2_i(5'd31),
    .select_i(reg_dst),//
    .data_o(RD_addr)  //
    );


Reg_File RF(
    .clk_i(clk_i),
    .rst_i(start_i) ,
    .RSaddr_i(instruction[25:21]) ,
    .RTaddr_i(instruction[20:16]) ,
    .RDaddr_i(RD_addr) ,
    .RDdata_i(RDdata) ,//
    .RegWrite_i(reg_write),//
    .RSdata_o(RSdata) ,//
    .RTdata_o(RTdata)//
    );

Decoder Decoder(
    .rst_n(start_i),
    .instr_op_i(instruction[31:26]),    
    .memread_o(MEMREAD),
    .memwrite_o(MEMWRITE),
    .ALU_op_o(alu_op),
    .ALUSrc_o(alu_src2),
    .RegDst_o(reg_dst),
    .Branch_o(branch),
    .Branch_eq(branch_eq),
    .reg_data_select(reg_data_select)
    );

ALU_Ctrl AC(
    .rst_n(start_i),
    .funct_i(instruction[5:0]),//
    .ALUOp_i(alu_op),//
    .ALUCtrl_o(alu_ctrl),//
    .Sign_extend_o(sign),
    .Mux_ALU_src1(alu_src1),
    .RegWrite_o(reg_write)
    );

Sign_Extend SE(
    .data_i(instruction[15:0]),//
    .sign_i(sign),//
    .data_o(ProgramCounter_w)//
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc1(
    .data0_i(RSdata),//
    .data1_i(ProgramCounter_w),//    
    .select_i(alu_src1),//
    .data_o(Mux_Alu_src1)
    );

MUX_3to1 #(.size(32)) Mux_ALUSrc2(
    .data0_i(RTdata),//
    .data1_i(ProgramCounter_w),//
    .data2_i(32'b0),
    .select_i(alu_src2),//
    .data_o(Mux_Alu_src2)
    );

ALU ALU(
    .rst_n(start_i),
    .src1_i(Mux_Alu_src1),//
    .src2_i(Mux_Alu_src2),//
    .ctrl_i(alu_ctrl),//
    .result_o(ALU_Result),//
    .zero_o(zero)//
    );

Adder Adder2(
    .src1_i(ProgramCounter_b),//
    .src2_i(ProgramCounter_4),//
    .sum_o(ProgramCounter_bran)//
    );

Shift_Left_Two_32 Shifter(
    .data_i(ProgramCounter_w),//
    .data_o(ProgramCounter_b)//
    );

MUX_2to1 #(.size(32)) MUX_Which_Jump(
    .data0_i(ProgramCounter_j_jal),//
    .data1_i(ProgramCounter_jr),//
    .select_i(instruction[31:26] == 6'b000000),//
    .data_o(ProgramCounter_j)
    );

MUX_3to1 #(.size(32)) MUX_next_PC(
    .data0_i(ProgramCounter_4),
    .data1_i(ProgramCounter_bran),
    .data2_i(ProgramCounter_j),
    .select_i(PC_select),
    .data_o(ProgramCounter_i)
    );

MUX_3to1 #(.size(32)) Mux_Result_Dst(
    .data0_i(ALU_Result),//
    .data1_i(DM_DATA_OUT),//
    .data2_i(ProgramCounter_4),
    .select_i(reg_data_select),//
    .data_o(RDdata)
    );

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(DM_ADDR),
    .data_i(DM_DATA_IN),
    .data_o(DM_DATA_OUT),
    .MemRead_i(MEMREAD),
    .MemWrite_i(MEMWRITE)
);

PC_selector pc_ss(
    .opcode(instruction[31:26]),
    .funct_i(instruction[5:0]),
    .alu_zero(zero),
    .PC_select(PC_select)

);

endmodule
