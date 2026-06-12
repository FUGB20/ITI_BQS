module Tcounter(input [2:0] T, output reg[2:0] Tc);
integer i;
always @(*) begin
Tc = 0;
for(i = 0; i<3; i = i + 1) begin
if(T[i])
Tc = Tc + 1;
end
end
endmodule
