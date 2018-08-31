module electronic_clock
(
	input wire set_time_button,
	input wire set_time_change_button,
	input wire set_time_add_button,
	input wire clk,
	input wire rst,
	
	output wire[6:0] hour_h_seg7,
	output wire[6:0] hour_l_seg7,
	output wire[6:0] minute_h_seg7,
	output wire[6:0] minute_l_seg7,
	output wire[6:0] second_h_seg7,
	output wire[6:0] second_l_seg7,
	
	output wire[3:0] hour_h_watch,
	output wire[3:0] hour_l_watch,
	output wire[3:0] minute_h_watch,
	output wire[3:0] minute_l_watch,
	output wire[3:0] second_h_watch,
	output wire[3:0] second_l_watch
);

	wire set_time_button_confirm;
	wire set_time_change_button_confirm;
	wire set_time_add_button_confirm;
	
	wire[3:0] hour_h;
	wire[3:0] hour_l;
	wire[3:0] minute_h;
	wire[3:0] minute_l;
	wire[3:0] second_h;
	wire[3:0] second_l;
	wire set_hour;
	wire set_minute;
	wire set_second;
	wire hour_instruction;
	wire minute_instruction;
	wire second_instruction;

	key_vibration_eliminate set_time_button_key
	(
		.in(set_time_button),
		.clk(clk),
		.rst(rst),
		.out(set_time_button_confirm)
	);
	key_vibration_eliminate set_time_change_button_key
	(
		.in(set_time_change_button),
		.clk(clk),
		.rst(rst),
		.out(set_time_change_button_confirm)
	);
	key_vibration_eliminate set_time_add_button_key
	(
		.in(set_time_add_button),
		.clk(clk),
		.rst(rst),
		.out(set_time_add_button_confirm)
	);
	counter counter_object
	(
		.clk(clk),
		.rst(rst),
		
		.set_time(set_time_button_confirm),
		.set_time_change(set_time_change_button_confirm),
		.set_time_add(set_time_add_button_confirm),
		
		.hour_h(hour_h),
		.hour_l(hour_l),
		.minute_h(minute_h),
		.minute_l(minute_l),
		.second_h(second_h),
		.second_l(second_l),
		
		//标志正在设置的位是哪一个
		.set_hour(set_hour),
		.set_minute(set_minute),
		.set_second(set_second)
	);
	flashing_instruction flashing_instruction_hour
	(
		.en(set_hour),
		.clk(clk),
		.rst(rst),
		.instruction(hour_instruction)
	);
	seg_7 seg_change_hour_h
	(
		.in(hour_h),
		.clk(clk),
		.en(hour_instruction),
		.out(hour_h_seg7)
	);
	seg_7 seg_change_hour_l
	(
		.in(hour_l),
		.clk(clk),
		.en(hour_instruction),
		.out(hour_l_seg7)
	);
	flashing_instruction flashing_instruction_minute
	(
		.en(set_minute),
		.clk(clk),
		.rst(rst),
		.instruction(minute_instruction)
	);
	seg_7 seg_change_minute_h
	(
		.in(minute_h),
		.clk(clk),
		.en(minute_instruction),
		.out(minute_h_seg7)
	);
	seg_7 seg_change_minute_l
	(
		.in(minute_l),
		.clk(clk),
		.en(minute_instruction),
		.out(minute_l_seg7)
	);
	flashing_instruction flashing_instruction_second
	(
		.en(set_second),
		.clk(clk),
		.rst(rst),
		.instruction(second_instruction)
	);
	seg_7 seg_change_second_h
	(
		.in(second_h),
		.clk(clk),
		.en(second_instruction),
		.out(second_h_seg7)
	);
	seg_7 seg_change_second_l
	(
		.in(second_l),
		.clk(clk),
		.en(second_instruction),
		.out(second_l_seg7)
	);
	
	assign hour_h_watch = hour_h;
	assign hour_l_watch = hour_l;
	assign minute_h_watch = minute_h;
	assign minute_l_watch = minute_l;
	assign second_h_watch = second_h;
	assign second_l_watch = second_l;
	
endmodule