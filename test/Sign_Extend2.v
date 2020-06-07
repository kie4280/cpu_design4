// Author: 0710012 何權祐, 0710018 張宸愷

module Sign_Extend2(
    data_i,
    data_o
    );

//I/O ports
input   [32-1:0] data_i;
output  [64-1:0] data_o;

//Internal Signals
reg     [64-1:0] data_o;

always@(*) begin
//Sign extended
    data_o={{32{data_i[31]}},data_i};
end
endmodule
