module tb_timer ();
    reg rst,clk_1hz,start_timer;
    reg [3:0] value;
    wire expired;
    timer myTimer(rst,clk_1hz,start_timer,value,expired);

    initial begin
        $monitor($time,"rst:%b,clk_1hz:%b,start_timer:%b, value:%b,expired:%b",rst,clk_1hz,start_timer,value,start_timer,expired);
        $dumpfile("wavedata2.vcd");//specifing the name of the file
        $dumpvars;//specifying the module

        clk_1hz=0;
        rst=1;
        start_timer=0;
        value=4'b0000;

        #4 rst=0;
        #2 start_timer=1;
        #2 start_timer=0;

        #20  
        value=4'b0010;
        start_timer=1;
        #2 start_timer=0;

        #20 $finish();


    end
    initial forever #1 clk_1hz= ~clk_1hz;
   
     
endmodule








module timer (rst,clk_1hz,start_timer,value,expired);
input rst,clk_1hz,start_timer;
input [3:0] value;
output reg expired;

reg start_flag;
reg [3:0] counter;

always @ (posedge clk_1hz,rst) begin
    if (rst==1) begin
        expired=0;
        start_flag=0;
        counter=4'b0000;
    end else if (start_timer==1) begin
       
        start_flag=1;
    end else if (value==counter) begin
        start_flag=0;
        expired=1;
        counter=4'b0000;
    end else if (start_flag==1) begin
        counter=counter+4'b0001;
    end else begin 
        expired=0;
    end

        


end
    
endmodule