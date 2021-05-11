module timeparatest();
    reg [0:1] selector,interval;
    reg  [0:3] time_value;
    reg  prog_sync,reset_sync,clk;
    wire [0:4]value;

    timepara mytimepara(reset_sync,clk,time_value,selector,prog_sync,interval,value);
    initial begin
        $monitor($time,"reset_sync:%b,clk:%b,time_value:%b:,selector:%b,prog_sync:%b,interval:%b,value:%b",reset_sync,clk,time_value,selector,prog_sync,interval,value);
        $dumpfile("wavedata8.vcd");//specifing the name of the file
        $dumpvars;//specifying the module
        clk=0;
        selector=2'b00;
        interval=2'b00;
        time_value=3'b000;
        prog_sync=0;
        reset_sync=0;

        #2
        interval=2'b01;
        #5 interval=2'b10;

        time_value=4'b0100; 
        selector=2'b01;

        #2 prog_sync=1;

        interval=2'b01;
        #2 prog_sync=0;

        time_value=4'b0001; 
        selector=2'b10;

        #2 prog_sync=1;
        #2 interval=2'b10;
        #2 prog_sync=0;
        time_value=4'b1000; 
        selector=2'b00;

        #2 prog_sync=1;


        #3 interval=2'b00;

        #10 reset_sync=1;

        interval=2'b01;
        #2 interval=2'b10;
        #2 interval=2'b00;



        #20 $finish();



    end
    initial forever #1 clk=~clk;
endmodule






module timepara(reset_sync,clk,time_value,selector,prog_sync,interval,value);
    input [0:1] selector,interval;
    input [0:3] time_value;
    input prog_sync,reset_sync,clk;
    output reg[0:4]value;
    reg  [0:3]base_interval =4'b0110;
    reg  [0:3]extended_interval = 4'b0011;
    reg [0:3]yellow_interval = 4'b0010;

    always @(posedge clk, interval,prog_sync,reset_sync) begin
        if (reset_sync==1)begin
            base_interval=4'b0110;
            extended_interval=4'b0011;
            yellow_interval=4'b0010;
        end else if (prog_sync==1)begin
            case(selector)
                2'b00:begin
                    base_interval=time_value;
                end 
                2'b01:begin
                    extended_interval=time_value;
                end
                2'b10:begin
                    yellow_interval=time_value;
                end
            endcase
        end 
        
            case (interval)
                2'b00:begin
                    value=base_interval;
                end
                2'b01:begin
                    value=extended_interval;
                end
                2'b10:begin
                    value=yellow_interval;
                end
            endcase
        
        
    end

endmodule