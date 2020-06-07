// Author: 0710012 何權祐, 0710018 張宸愷

module PC_selector(
    input [6-1:0] opcode,
    input [6-1:0] funct_i,
    input alu_zero,
    output reg [2-1:0] PC_select

);

always@(*) begin
    if(opcode == 6'b000000 && funct_i == 6'b001000) begin
    PC_select = 2'd2;
    end
    else if(opcode == 6'b000010 || opcode == 6'b000011) begin
        PC_select = 2'd2;
    end 
    else if(opcode == 6'b000110) begin // BLEZ
        if(alu_zero) PC_select = 2'd0;
        else PC_select = 2'd1;
    end
    else if(opcode == 6'b000111) begin // BGTZ
        if(alu_zero) PC_select = 2'd0;
        else PC_select = 2'd1;
    end
    else if(opcode == 6'b000101) begin // BNE
        if(alu_zero) PC_select = 2'd0;
        else PC_select = 2'd1;
    end
    else if(opcode == 6'b000100) begin // BEQ
        if(alu_zero) PC_select = 2'd1;
        else PC_select = 2'd0;
    end
    else begin
        PC_select = 2'd0;
    end

end




endmodule