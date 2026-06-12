// ----------------- D-Flip Flop --------------------//
// asynchronous reset D-flipflop 
module d_ff ( d, rstn, clk, q) ;
input d, rstn, clk;
output reg q;
// D-flipflop is sensitive to positive edge clock and negative edge reset
always @ (posedge clk or posedge rstn)
// the output q is zero at negative reset
    if (rstn)
          q <= 0;
// else the output q follows the d input
       else
          q <= d;
endmodule 
// --------------------------------------------------//
