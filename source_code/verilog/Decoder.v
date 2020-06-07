// Author: 0710012 何權祐, 0710018 張宸愷

module Decoder(
    rst_n,
    instr_op_i,
    reg_data_select,
    memread_o,
    memwrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Branch_eq
    );

//I/O ports
input  [6-1:0] instr_op_i;
input rst_n;


output reg[4-1:0] ALU_op_o = 0;
output reg[2-1:0] ALUSrc_o = 0;
output reg[2-1:0] RegDst_o = 0;
output reg        Branch_o = 0;
output reg        Branch_eq = 0;

output reg        memread_o = 0;
output reg        memwrite_o = 0;
output reg[2-1:0] reg_data_select = 0;

//ALUOP for decoder
localparam[4-1:0] R_TYPE=0, ADDI=1, SLTIU=2, 
                  BEQ=3, LUI=4, ORI=5, BNE=6,
                  LW=7, SW=8, BLEZ=9, BGTZ=10,
                  J=11, JAL=12;


//begin logic

always@(*) begin

    if(rst_n) begin
        if(instr_op_i == 6'b000000) begin
            RegDst_o = 2'b01;
        end
        else if(instr_op_i == 6'b000011) begin
            RegDst_o = 2'b10;
        end
        else begin
            RegDst_o = 2'b00;
        end

        if(instr_op_i == 6'b000011) begin
            reg_data_select = 2'b10;
        end
        else if(instr_op_i == 6'b100011) begin
            reg_data_select = 2'b01;
        end
        else begin
            reg_data_select = 2'b00;
        end

        
        
        Branch_o = (instr_op_i == 6'b000100 || instr_op_i == 6'b000101);
        Branch_eq = (instr_op_i == 6'b000100);        
        memread_o = (instr_op_i == 6'b100011);
        memwrite_o = (instr_op_i == 6'b101011);
        case (instr_op_i)
            6'b000000: begin
                ALU_op_o = R_TYPE;
                ALUSrc_o = 0;                
                
            end
            6'b001000: begin
                ALU_op_o = ADDI;
                ALUSrc_o = 1;                
                
            end
            6'b001011: begin
                ALU_op_o = SLTIU;
                ALUSrc_o = 1;                
                
            end
            6'b000100: begin
                ALU_op_o = BEQ;
                ALUSrc_o = 0;                
                
            end
            6'b001111: begin
                ALU_op_o = LUI;
                ALUSrc_o = 1;                
                
            end
            6'b001101: begin
                ALU_op_o = ORI;
                ALUSrc_o = 1;                
                
            end
            6'b000101: begin
                ALU_op_o = BNE;
                ALUSrc_o = 0;                
                
            end
            6'b100011: begin
                ALU_op_o = LW;
                ALUSrc_o = 1;                
                
            end
            6'b101011: begin
                ALU_op_o = SW;
                ALUSrc_o = 1;                
                
            end
            6'b000110: begin
                ALU_op_o = BLEZ;
                ALUSrc_o = 2;                
                
            end
            6'b000111: begin
                ALU_op_o = BGTZ;
                ALUSrc_o = 2;                
                
            end
            
            6'b000010: begin
                ALU_op_o = J;
                ALUSrc_o = 0;                
                
            end
            6'b000011: begin
                ALU_op_o = JAL;
                ALUSrc_o = 0;                
                
            end
            

            default:;                                             
        endcase
    


    end else begin
        
        ALU_op_o = 0;
        ALUSrc_o = 0;
        RegDst_o = 0;
        Branch_o = 0;
        Branch_eq = 0;

    end

    
    

end

endmodule
