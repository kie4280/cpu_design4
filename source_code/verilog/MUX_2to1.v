// Author: 0710012 何權祐, 0710018 張宸愷

module MUX_2to1(
    data0_i,
    data1_i,
    select_i,
    data_o
    );

parameter size = 0;

//I/O ports
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o;

//Internal Signals
reg     [size-1:0] data_o;

//begin logic
always@(*) begin
    if (select_i==1) begin
        data_o=data1_i;    
    end
    else if (select_i==0)begin
        data_o=data0_i;
    end

end


endmodule
