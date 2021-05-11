module sync_timer();
    reg rst,sensor,walk_request,reprogram,clk;
    wire prog_sync,wr_sync,sensor_sync,reset_sync;

    synchroniser mysync(clk,rst, sensor,walk_request,reprogram,prog_sync,wr_sync,sensor_sync,reset_sync);


    initial begin
        $monitor($time,"clk:%b,rst:%b,sensor:%b, walk_request:%b,reprogram:%b,prog_sync:%b,wr_sync:%b,sensor_sync:%b,reset_sync:%b",clk,rst, sensor,walk_request,reprogram,prog_sync,wr_sync,sensor_sync,reset_sync);
        $dumpfile("wavedata3.vcd");//specifing the name of the file
        $dumpvars(0, mysync);//specifying the module

            clk=0;
            rst=1;
            sensor=0;
            walk_request=0;
            reprogram=0;


            #5
            rst=0;
            sensor=1;
            walk_request=1;
            reprogram=1;

            #5
            
            sensor=0;
            walk_request=1;
            reprogram=0;

            #5
            sensor=1;
            walk_request=0;
            reprogram=0;

            #5
            sensor=0;
            walk_request=0;
            reprogram=1;

            #5
            
            sensor=0;
            walk_request=1;
            reprogram=0;

            #30 $finish();


         

    end

    initial forever #1 clk=~clk;
endmodule





module synchroniser(clk,rst, sensor,walk_request,reprogram,prog_sync,wr_sync,sensor_sync,reset_sync);
input rst,sensor,walk_request,reprogram,clk;
output  reg prog_sync,wr_sync,sensor_sync,reset_sync;


always @(posedge clk) begin
    reset_sync=rst;
    prog_sync=reprogram;
    wr_sync=walk_request;
    sensor_sync=sensor;
end
endmodule