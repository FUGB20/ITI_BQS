module Pcounter (state, reset, clk, Pcount);
parameter down = 2'b01,
	  up   = 2'b10,
	  stay = 2'b11,
	  n    = 3;

input reset, clk;
input [1:0] state;
output reg [n-1:0] Pcount;
wire [n-1:0] max_count = (1 << n) - 1;

always @(posedge clk or posedge reset)
begin
if(reset)
begin
Pcount <= 0;
end
else
begin
case(state)
up: begin
if(Pcount >= max_count)
Pcount <= max_count;
else
Pcount <= Pcount + 1;
end
down: begin
if(Pcount <= 0)
Pcount <= 0;
else
Pcount <= Pcount - 1;
end
stay: begin
Pcount <= Pcount;
end
default: Pcount <= Pcount;
endcase
end
end
endmodule