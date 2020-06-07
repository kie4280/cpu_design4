 `timescale 1ns/1ps
// Author: 0710012 何權祐, 0710018 張宸愷

module alu(
        rst_n,         // negative reset            (input)
        src1,          // 32 bits source 1          (input)
        src2,          // 32 bits source 2          (input)
        ALU_control,   // 4 bits ALU control input  (input)
		comp, // 3 bits bonus control input(input) 
        result,        // 32 bits result            (output)
        zero,          // 1 bit when the output is 0, zero must be set (output)
        cout,          // 1 bit carry out           (output)
        overflow       // 1 bit overflow            (output)
);


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [3-1:0] comp; 
output [32-1:0] result;
output reg      zero;
output reg      cout;
output reg      overflow;

wire[32-1:0] less_wire;
wire[32-1:0] equal_wire;
wire[33-1:0] carry;
reg A_invert;
reg B_invert;
reg[2-1:0] operation;

wire set;
reg[32-1:0] result_reg;
wire[32-1:0] result_wire;

alu_top start(
    src1[0], src2[0],
    A_invert, B_invert, carry[0], operation,
    result_wire[0], carry[1]);

alu_bottom last(
    src1[31], src2[31], A_invert, B_invert, carry[31],
    operation, result_wire[31], carry[32]);


genvar i;
generate

    for(i=1; i<31; i=i+1) begin
        alu_top a(
            src1[i], src2[i], 
            A_invert, B_invert, carry[i], operation,
            result_wire[i], carry[i+1]);
    end

endgenerate

assign carry[0] = (ALU_control == 4'b0110 || ALU_control == 4'b0111);
assign result = result_reg;

always @(*) begin

    

    if(rst_n) begin        

        case(ALU_control)
            4'b0000: begin //AND
                A_invert = 0;
                B_invert = 0;
                operation = 2'b00;
                overflow = 0;
                cout = 0;
                result_reg = result_wire;
            end
            4'b0001: begin //OR
                A_invert = 0;
                B_invert = 0;
                operation = 2'b01;
                overflow = 0;
                cout = 0;
                result_reg = result_wire;
            end
            4'b0010: begin //ADD
                A_invert = 0;
                B_invert = 0;
                operation = 2'b10;
                if(~src1[31] & ~src2[31] & result_wire[31]) begin
                    overflow = 1;
                end
                else if(src1[31] & src2[31] & ~result_wire[31]) begin
                    overflow = 1;
                end
                else begin
                    overflow = 0;
                end
                cout = carry[32];
                result_reg = result_wire;
            end
            4'b0110: begin //SUB
                A_invert = 0;
                B_invert = 1;
                operation = 2'b10;
                if(~src1[31] & src2[31] & result_wire[31]) begin
                    overflow = 1;
                end
                else if(src1[31] & ~src2[31] & ~result_wire[31]) begin
                    overflow = 1;
                end
                else begin
                    overflow = 0;
                end
                cout = carry[32];
                result_reg = result_wire;

            end
            4'b1100: begin //NOR
                A_invert = 1;
                B_invert = 1;
                operation = 2'b00;
                overflow = 0;
                cout = 0;
                result_reg = result_wire;
            end
            4'b1101: begin //NAND
                A_invert = 1;
                B_invert = 1;
                operation = 2'b01;
                overflow = 0;
                cout = 0;
                result_reg = result_wire;
            end
            4'b0111: begin //COMP
                
                A_invert = 0;
                B_invert = 1;
                operation = 2'b11;
                
                overflow = 0;
                cout = 0;              
                
                case(comp)
                    3'b000: begin // SLT
                        
                        result_reg = {31'b0, (!(src1[31]^src2[31]) && result_wire[31]) || 
                        (src1[31] == 1 && src2[31] == 0)};
                    end
                    3'b001: begin // SGT
                    if(src1[31]^src2[31] == 1) begin
                        if(src1[31]==0) result_reg = {31'b0, 1'b1};
                        else result_reg = {31'b0, 1'b0};

                    end else begin 
                        result_reg = {31'b0, (~result_wire[31]) & (|result_wire[30:0])};

                    end
                        
                    end
                    3'b010: begin // SLE
                        if(src1[31]^src2[31] == 1) begin
                            if(src1[31]==1) result_reg = {31'b0, 1'b1};
                            else result_reg = {31'b0, 1'b0};

                        end 
                        else if(src1==src2) begin
                            result_reg = {31'b0, 1'b1};
                        end
                        else begin 
                            result_reg = {31'b0, result_wire[31]};

                        end
                    end
                    3'b011: begin // SGE
                        result_reg = {31'b0, 1'b0};
                    end
                    3'b110: begin // SEQ
                        result_reg = {31'b0, 1'b0};
                    end
                    3'b100: begin // SNE
                        result_reg = {31'b0, 1'b0};
                    end
                    3'b101: begin //SLTU
                        result_reg = {31'b0, result_wire[31] & (~carry[32])};
                    end
                endcase

            end

            default: result_reg = result_wire;

        endcase

        

    end

    zero = ~(|result);
    
    

end




endmodule
