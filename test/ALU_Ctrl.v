// Author: 0710012 何權祐, 0710018 張宸愷

module ALU_Ctrl(
        rst_n,
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
        Sign_extend_o,
        Mux_ALU_src1,
        RegWrite_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;
input      rst_n;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;
output reg Sign_extend_o;
output reg Mux_ALU_src1;
output reg RegWrite_o = 0;


//Select exact operation

//actual ALU control code
localparam [4-1:0] A_AND=0, A_OR=1, A_LW=2, A_SW=3, A_ADDU=4, A_SUBU=5, A_SLT=6, A_BLEZ=7,
                   A_SRA=8, A_SRAV=9, A_LUI=10, A_SLTU=11, A_SLL=12, A_SMUL=13, A_BGTZ=14;

//ALUOP from decoder
localparam[4-1:0] R_TYPE=0, ADDI=1, SLTIU=2, 
                  BEQ=3, LUI=4, ORI=5, BNE=6,
                  LW=7, SW=8, BLEZ=9, BGTZ=10,
                  J=11, JAL=12;

//begin logic
always@(*) begin  

    if(rst_n) begin
        if(ALUOp_i == R_TYPE && (funct_i == 6'b000011 || funct_i == 6'b000000
         || funct_i == 6'b000111)) begin
            Mux_ALU_src1 = 1;
        end
        else begin
            Mux_ALU_src1 = 0;
        end
        

        if(ALUOp_i == R_TYPE) begin
            case(funct_i) 
                6'b100001: begin //add unsigned
                    ALUCtrl_o = A_ADDU;
                    RegWrite_o = 1;
                end
                6'b100011: begin //sub unsigned
                    ALUCtrl_o = A_SUBU;
                    RegWrite_o = 1;
                end
                6'b100100: begin //bitwise and
                    ALUCtrl_o = A_AND;
                    RegWrite_o = 1;
                end
                6'b100101: begin //bitwise or
                    ALUCtrl_o = A_OR;
                    RegWrite_o = 1;
                end
                6'b101010: begin //slt
                    ALUCtrl_o = A_SLT;
                    RegWrite_o = 1;
                end
                6'b000011: begin // shift right constant
                    ALUCtrl_o = A_SRA;
                    RegWrite_o = 1;
                end
                6'b000111: begin //shift right variable
                    ALUCtrl_o = A_SRAV;
                    RegWrite_o = 1;
                end
                6'b001000: begin //jump register
                    RegWrite_o = 0;
                
                end
                6'b000000: begin //shift left logical
                    ALUCtrl_o = A_SLL;
                    RegWrite_o = 1;
                end
                6'b011000: begin //signed multiplication
                    ALUCtrl_o = A_SMUL;
                    RegWrite_o = 1;
                end

                default:;


            endcase
            Sign_extend_o = 0;
        end

        else if(ALUOp_i == ADDI) begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_ADDU;
            RegWrite_o = 1;

        end
        else if(ALUOp_i == SLTIU) begin
            Sign_extend_o = 0;
            ALUCtrl_o = A_SLTU;
            RegWrite_o = 1;

        end
        else if(ALUOp_i == BEQ)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_SUBU;
            RegWrite_o = 0;
        end
        else if (ALUOp_i == LUI) begin
            Sign_extend_o = 0;
            ALUCtrl_o = A_LUI;
            RegWrite_o = 1;
        end
        else if (ALUOp_i == ORI) begin
            Sign_extend_o = 0;
            ALUCtrl_o = A_OR;
            RegWrite_o = 1;
        end 
        else if(ALUOp_i == BNE)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_SUBU;
            RegWrite_o = 0;
        end
        else if(ALUOp_i == LW)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_LW;
            RegWrite_o = 1;
        end
        else if(ALUOp_i == SW)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_SW;
            RegWrite_o = 0;
        end
        
        else if(ALUOp_i == J)begin
            Sign_extend_o = 0;        
            RegWrite_o = 0;
        end
        else if(ALUOp_i == JAL)begin
            Sign_extend_o = 0;
            RegWrite_o = 1;        
        end
        else if(ALUOp_i == BLEZ)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_BLEZ;
            RegWrite_o = 0;
        end
        else if(ALUOp_i == BGTZ)begin
            Sign_extend_o = 1;
            ALUCtrl_o = A_BGTZ;
            RegWrite_o = 0;
        end

        else begin
            Sign_extend_o = 0;
            RegWrite_o = 0;
        end
    end
    else begin
        Sign_extend_o = 0;
        ALUCtrl_o = 0;
        RegWrite_o = 0;
        Mux_ALU_src1 = 0;

    end

    

end


endmodule
