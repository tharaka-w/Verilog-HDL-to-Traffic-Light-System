
module timer();
    reg  wr_sync,wr_reset,clk,reset_sync;
    wire wr;
    walkreg mywalkreg(wr,wr_reset,wr_sync,clk,reset_sync);
    initial begin
        $monitor($time,"clk:%b,reset_sync:%b,wr_sync:%b, wr_reset:%b,wr:%b",clk,reset_sync,wr_sync,wr_reset,wr);
        $dumpfile("wavedata4.vcd");//specifing the name of the file
        $dumpvars;//specifying the module
        clk=0;
        reset_sync=1;
        wr_reset=0;
        wr_sync=0;

        #4 
        reset_sync=0;
        wr_reset=0;
        wr_sync=1;

        #5  
        
        reset_sync=0;
        wr_reset=1;
        wr_sync=0;
        #5


        reset_sync=0;
        wr_reset=0;
        wr_sync=1;


        
        #5
        reset_sync=1;
        wr_reset=0;
        wr_sync=1;
        #20 $finish();


    end
    initial forever #1 clk= ~clk;
endmodule




module walkreg (wr,wr_reset,wr_sync,clk,reset_sync);
input wr_sync,wr_reset,clk,reset_sync;
output reg wr;

always @(posedge clk,wr_reset,wr_sync,reset_sync) begin
    if (reset_sync==1)begin
        wr=1'b0;
    end else if (wr_reset==1) begin
        wr=1'b0;
    end else if (wr_sync==1) begin
        wr=1'b1;
    end
end

endmodule


