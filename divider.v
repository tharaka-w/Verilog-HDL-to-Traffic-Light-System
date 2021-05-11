module divider_timer();
    reg clk,reset_sync;
    wire clk_1hz;
    divider mydevider(clk,clk_1hz,reset_sync);
    initial begin
        $monitor($time,"clk:%b,clk_1hz:%b,reset_sync:",clk,clk_1hz,reset_sync);
        $dumpfile("wavedata5.vcd");//specifing the name of the file
        $dumpvars;//specifying the module
        clk=0;
        reset_sync=1;
        #5 reset_sync=0;
        
        #50 $finish();
    end
    initial forever #1 clk=~clk;
    

    endmodule



module divider(clk,clk_1hz,reset_sync);
input clk,reset_sync;
output reg clk_1hz;
parameter frequency =8'd10 ;
reg[7:0] count=0;

always @(posedge clk) begin
    count=count+8'd1;
    if (reset_sync==1) begin
        count=8'd0;
        clk_1hz<=0;
    end else if (count<=frequency/2)begin
        clk_1hz<=1;
    end else begin
        clk_1hz<=0;
    end
    if (count==frequency)begin
        count=8'd0;
    end
    
end


endmodule

