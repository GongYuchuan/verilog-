`timescale 10ns/10ns
module electronic_clock_test;

	reg clk;
	reg rst;
	reg set_time_button;
	reg set_time_change_button;
	reg set_time_add_button;
	wire[6:0] hour_h_seg7;
	wire[6:0] hour_l_seg7;
	wire[6:0] minute_h_seg7;
	wire[6:0] minute_l_seg7;
	wire[6:0] second_h_seg7;
	wire[6:0] second_l_seg7;
	
	wire[3:0] hour_h_watch;
	wire[3:0] hour_l_watch;
	wire[3:0] minute_h_watch;
	wire[3:0] minute_l_watch;
	wire[3:0] second_h_watch;
	wire[3:0] second_l_watch;
	
	electronic_clock electronic_clock_v1
	(
		.set_time_button(set_time_button),
		.set_time_change_button(set_time_change_button),
		.set_time_add_button(set_time_add_button),
		.clk(clk),
		.rst(rst),
		
		.hour_h_seg7(hour_h_seg7),
		.hour_l_seg7(hour_l_seg7),
		.minute_h_seg7(minute_h_seg7),
		.minute_l_seg7(minute_l_seg7),
		.second_h_seg7(second_h_seg7),
		.second_l_seg7(second_l_seg7),
		
		.hour_h_watch(hour_h_watch),
		.hour_l_watch(hour_l_watch),
		.minute_h_watch(minute_h_watch),
		.minute_l_watch(minute_l_watch),
		.second_h_watch(second_h_watch),
		.second_l_watch(second_l_watch)
	);
	
	initial
	begin
		repeat(1000)//10000s
		begin
			repeat(1_000_000_000)
			begin
				clk = 1'b1;
				#1 clk = 1'b0;
				#1;
			end
		end
	end
	
	initial
	begin
		set_time_button = 1'b1;
		set_time_change_button = 1'b1;
		set_time_add_button = 1'b1;
		
		rst = 1'b0;
		#10 rst = 1'b1;
		repeat(400)
			#1_000_000_000;//4000s
		
		set_time_button = 1'b0;
		#100_000_000;//1s
		set_time_button = 1'b1;
		#500_000_000;//5s
		
		set_time_add_button = 1'b0;
		#100_000_000;//1s
		set_time_add_button = 1'b1;
		#500_000_000;//5s
		
		set_time_change_button = 1'b0;
		#100_000_000;//1s
		set_time_change_button = 1'b1;
		#500_000_000;//5s
		
		set_time_add_button = 1'b0;
		#100_000_000;//1s
		set_time_add_button = 1'b1;
		#500_000_000;//5s
		
		set_time_change_button = 1'b0;
		#100_000_000;//1s
		set_time_change_button = 1'b1;
		#500_000_000;//5s
		
		set_time_add_button = 1'b0;
		#100_000_000;//1s
		set_time_add_button = 1'b1;
		#500_000_000;//5s
		
		set_time_button = 1'b0;
		#100_000_000;//1s
		set_time_button = 1'b1;
	end
	
	initial
	begin
		$monitor("rst = %b,set_time_button = %d,set_time_change_button = %d,set_time_add_button = %d\n hour = %d%d,minute = %d%d,second = %d%d",
		rst,set_time_button,set_time_change_button,set_time_add_button,
		hour_h_watch,hour_l_watch,minute_h_watch,minute_l_watch,second_h_watch,second_l_watch);
	end
endmodule