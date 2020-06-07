// Author: 0710012 何權祐, 0710018 張宸愷

module Sign_Extend(
    data_i,
    sign_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
input   sign_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

always@(*) begin
//Sign extended
    if (sign_i==1) begin
        data_o={{16{data_i[15]}},data_i};
    end else begin
        data_o={{16{1'b0}}, data_i};
    end

end


endmodule
