module bqs #(parameter n = 3) (
    input t1, t2, t3, Fs, Bs, reset, clk,
    output [n-1:0] Pcount,
    output [4:0] Wtime,
    output [6:0] Pcount_7seg, Wtime_7seg_ten, Wtime_7seg_sec,
    output Falarm, Ealarm, Fflag, Eflag
);

    wire [1:0] Tcount;
    wire frontsig, backsig;
    wire [3:0] tens, sec;


    localparam max_count = (1 << n) - 1;

    
    Tcounter t ({t1, t2, t3}, Tcount);
    
    
    edge_detector e1 (Fs, reset, clk, frontsig); 
    edge_detector e2 (Bs, reset, clk, backsig);  


    Pcounter #(.n(n)) p (
        .state({frontsig, backsig}), 
        .reset(reset), 
        .clk(clk), 
        .Pcount(Pcount)
    );

    rom r (Tcount, Pcount, Wtime);


    decoder_7seg people (1'b0, Pcount[2], Pcount[1], Pcount[0], 
        Pcount_7seg[6], Pcount_7seg[5], Pcount_7seg[4], 
        Pcount_7seg[3], Pcount_7seg[2], Pcount_7seg[1], Pcount_7seg[0]);

    seperator s (Wtime, tens, sec);

    decoder_7seg ten (tens[3], tens[2], tens[1], tens[0], 
        Wtime_7seg_ten[6], Wtime_7seg_ten[5], Wtime_7seg_ten[4], 
        Wtime_7seg_ten[3], Wtime_7seg_ten[2], Wtime_7seg_ten[1], Wtime_7seg_ten[0]);

    decoder_7seg secs (sec[3], sec[2], sec[1], sec[0], 
        Wtime_7seg_sec[6], Wtime_7seg_sec[5], Wtime_7seg_sec[4], 
        Wtime_7seg_sec[3], Wtime_7seg_sec[2], Wtime_7seg_sec[1], Wtime_7seg_sec[0]);

  
    

    assign Eflag = (Pcount == 0);
    assign Fflag = (Pcount == max_count);


    assign Ealarm = Eflag & backsig; 
    

    assign Falarm = Fflag & frontsig;  

endmodule