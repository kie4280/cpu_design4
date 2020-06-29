// Author: 0710012 何權祐, 0710018 張宸愷
`timescale 1ns/1ps

module alu_top(
    src1,       //1 bit source 1 (input)
    src2,       //1 bit source 2 (input)
    A_invert,   //1 bit A_invert (input)
    B_invert,   //1 bit B_invert (input)
    cin,        //1 bit carry in (input)
    operation,  //operation      (input)
    result,     //1 bit result   (output)
    cout       //1 bit carry out(output)
);

input         src1;
input         src2;

input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
input [3-1:0] comp;
output reg    result;
output        cout;

wire          add_result;

add add_part((A_invert ? ~src1:src1), (B_invert ? ~src2:src2), cin, cout, add_result);

always @(*) 
begin
    case(operation) 
        2'b00: begin
            result = (A_invert ? ~src1:src1) & (B_invert ? ~src2:src2);
        end
        2'b01: begin
            result = (A_invert ? ~src1:src1) | (B_invert ? ~src2:src2);
        end
        2'b10: begin
            result = add_result;
        end
        2'b11: begin
            result = add_result;
        end

        default:;

    endcase

end

endmodule
