module testfsm();
reg clk,reset_sync,sensor_sync,wr,prog_sync,expired;
wire  wr_reset,start_timer;
wire [0:6] n7;
wire [0:1]interval;

fsm myfsm(clk,reset_sync,wr,sensor_sync,prog_sync,expired,wr_reset,interval,start_timer,n7);
initial begin
        $monitor($time,"clk:%b,creset_sync:%b,wr:,sensor_sync:%b,prog_sync:%b,prog_sync:%b,expired:%b,wr_reset:%b,interval:%b,start_timer:%b,n7:%b",clk,reset_sync,wr,sensor_sync,prog_sync,expired,wr_reset,interval,start_timer,n7);
        $dumpfile("wavedata7.vcd");//specifing the name of the file
        $dumpvars;//specifying the module
        clk=0;
        
        
        reset_sync=0;
        sensor_sync=0;
        wr=0;
        prog_sync=0;
        expired=0;

        #2 wr=1;
        #2 sensor_sync=1;

        #2 prog_sync=1;
        #2 prog_sync=0;
        #4 expired=1;
        #2 expired=0;
        #3 expired=1;
        #2 expired=0;
        #3 expired=1;
        #2 expired=0;
        #3 expired=1;
        #2 expired=0;
        #3 expired=1;
        #2 expired=0;
        #10 expired=1;
        #2 expired=0;



        #40 $finish();
end

        initial forever #1 clk=~clk;


endmodule 

module fsm(clk,reset_sync,wr,sensor_sync,prog_sync,expired,wr_reset,interval,start_timer,n7);
    input clk,reset_sync,sensor_sync,wr,prog_sync,expired;
    output reg wr_reset,start_timer;
    output reg[0:6] n7;
    output reg[0:1]interval;

    parameter s0 =3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100,s5=3'b101,s6=3'b110 ;

    reg [2:0] current_state;

    always @(posedge clk,reset_sync) begin
        if (prog_sync==1)begin
            current_state=s0;
        end else if (reset_sync==1) begin
            current_state=s0;
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
        s0:begin start_timer=1;n7=7'b0011000;interval=2'b00;
        end
        s1:begin start_timer=1;n7=7'b0011000;interval=2'b00; end
        s2:begin start_timer=1;n7=7'b0011000;interval=2'b01; end
        s3:begin start_timer=1;n7=7'b0101000;interval=2'b10; end
        s4:begin start_timer=1;n7=7'b1001001;interval=2'b01;wr_reset=1; end
        s5:begin start_timer=1;n7=7'b1000010;interval=2'b00; end
        s6:begin start_timer=1;n7=7'b1000100;interval=2'b10; end
        
    endcase
    end

endmodule