module mainunit();


    
    reg clk,rst,sensor,walk_request,reprogram;
    reg [1:0] selector;
    reg [3:0] time_value;

    wire [6:0] n7;
    wire [1:0] interval;
    wire [3:0] value;
    wire prog_sync,wr_sync,sensor_sync,reset_sync,wr,expired,wr_reset,start_timer,clk_1hz;

     
    

    fulldesign mymain(rst,sensor,walk_request,reprogram,time_value,selector,clk,n7);
    


    initial begin
        $monitor($time,"rst:%b,sensor:%b,walk_request:%b, reprogram:%b,selector:%b,time_value:%b,clk:%b,n7:%b",rst,sensor,walk_request,reprogram,selector,time_value,clk,n7);
        $dumpfile("wavedatadesign.vcd");//specifing the name of the file
        $dumpvars;//specifying the module

            clk=0;
            rst=1;
            sensor=1;
            walk_request=0;
            reprogram=0;
            selector=2'b00;
            time_value=4'b0000;




            #5
            
            rst=0;
            sensor=0;
            walk_request=1;
            reprogram=0;
            selector=2'b00;
            time_value=4'b0000;

            

            #2
            reprogram=0;

            #5
            
            
            
            walk_request=1;
            
            selector=2'b00;
            time_value=4'b0000;

            #5
            
            
            sensor=1;
            walk_request=0;
            
            selector=2'b00;
            time_value=4'b0000;

            
            
            #15
            sensor=0;
            walk_request=1;

            #20
            sensor=0;
            walk_request=1;



            selector=2'b00;
            time_value=4'b0000;

            #5
            time_value=4'b0100; 
            selector=2'b01;
            reprogram=1;
            #1
            reprogram=0;



            #100 $finish();


         

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










module fsm(clk,reset_sync,wr,sensor_sync,prog_sync,expired,wr_reset,interval,start_timer,n7);
    input clk,reset_sync,sensor_sync,wr,prog_sync,expired;
    output reg wr_reset,start_timer;
    output reg[6:0] n7;
    output reg[1:0] interval;
    

    parameter s0 =3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100,s5=3'b101,s6=3'b110 ;

    reg [2:0] current_state;

    always @(posedge clk,reset_sync) begin
        if (prog_sync==1)begin
            current_state=s0;
        end else if (reset_sync==1) begin
            current_state=s0;
            wr_reset=0;
        end else begin
            case (current_state)
                s0:begin
                    if( (expired==1) & (sensor_sync==0) )begin
                        current_state=s1;
                        start_timer=0;
                    end else if ((expired==1) & (sensor_sync==1))begin
                        current_state=s2;
                        start_timer=0;
                    end
                end
                s1:begin
                    if (expired==1)begin
                        current_state=s3;
                        start_timer=0;
                    end
                end
                s2:begin
                    if (expired==1)begin
                        current_state=s3;
                        start_timer=0;
                    end
                end
                s3:begin
                    if ((wr==1)& (expired==1))begin
                        current_state=s4;
                        start_timer=0;
                    end else if ((wr==0)& (expired==1)) begin
                        current_state=s5;
                        start_timer=0;
                    end
                end
                s4:begin 
                    if (expired==1)begin
                        current_state=s5;
                        start_timer=0;
                    end
                end
                s5:begin
                    if (expired==1)begin
                        current_state=s6;
                        start_timer=0;
                    end
                end
                s6:begin
                    if (expired==1)begin
                        current_state=s0;
                        start_timer=0;
                    end
                end
            endcase
        end
        
    end

    always @(current_state) begin
        case(current_state)
        s0:begin start_timer=1;n7=7'b0011000;interval=2'b00;end
        s1:begin start_timer=1;n7=7'b0011000;interval=2'b00; end
        s2:begin start_timer=1;n7=7'b0011000;interval=2'b01; end
        s3:begin start_timer=1;n7=7'b0101000;interval=2'b10; end
        s4:begin start_timer=1;n7=7'b1001001;interval=2'b01;wr_reset=1; end
        s5:begin start_timer=1;n7=7'b1000010;interval=2'b00; end
        s6:begin start_timer=1;n7=7'b1000100;interval=2'b10; end
        
    endcase
    end

endmodule



module timepara(reset_sync,clk,time_value,selector,prog_sync,interval,value);
    input [1:0] selector;
    input [1:0] interval;
    input [3:0] time_value;
    input prog_sync,reset_sync,clk;
    output reg[3:0] value;
    reg  [3:0]base_interval =4'b0110;
    reg  [3:0]extended_interval = 4'b0011;
    reg [3:0]yellow_interval = 4'b0010;

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


module timer (rst,clk,start_timer,value,expired);
input rst,clk,start_timer;
input [3:0] value;
output reg expired;

reg start_flag;
reg [3:0] counter;

always @ (posedge clk,rst) begin
    if (rst==1) begin
        expired=0;
        start_flag=0;
        counter=4'b0000;
    end else if (start_timer>0 & start_flag==0) begin
       
        start_flag=1;
        //counter=counter+4'b0001;
    end else if (value==counter) begin
        start_flag=0;
        expired=1;
        counter=4'b0000;

    end else if (start_flag>0) begin
        counter=counter+4'b0001;
    end else begin 
        expired=0;
    end

        


end
    
endmodule


module divider(clk,clk_1hz,reset_sync);
input clk,reset_sync;
output reg clk_1hz;
parameter frequency =8'd10 ;
reg[7:0] count=0;

///always @(posedge clk) begin
//    count=count+8'd1;
 //   if (reset_sync==1) begin
  //      count=8'd0;
   //     clk_1hz<=0;
    //end else if (count<=frequency/2)begin
     //   clk_1hz<=1;
  //  end else begin
    //    clk_1hz<=0;
    //end
    //if (count==frequency)begin
     //   count=8'd0;
    //end
    
//end//
always @(negedge clk) begin
    clk_1hz<=0;
    end
    always @(posedge clk) begin
        clk_1hz<=-clk_1hz;
    end

endmodule


module fulldesign(rst,sensor,walk_request,reprogram,time_value,selector,clk,n7);
    input clk,rst,sensor,walk_request,reprogram;
    input [3:0] time_value;
    input [1:0] selector;
    
    output [6:0] n7;
    wire [1:0] interval;
    wire [3:0] value;
    wire prog_sync,wr_sync,sensor_sync,reset_sync,wr,expired,wr_reset,start_timer,clk_1hz;
    //wire [6:0] N7;
    synchroniser mysync(clk,rst, sensor,walk_request,reprogram,prog_sync,wr_sync,sensor_sync,reset_sync);
    walkreg mywalkreg(wr,wr_reset,wr_sync,clk,reset_sync);
    fsm myfsm(clk,reset_sync,wr,sensor_sync,prog_sync,expired,wr_reset,interval,start_timer,n7);
    timepara mytimepara(reset_sync,clk,time_value,selector,prog_sync,interval,value);
    timer myTimer(rst,clk,start_timer,value,expired);
    divider mydevider(clk,clk_1hz,reset_sync);

    


endmodule

