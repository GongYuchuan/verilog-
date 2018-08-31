module counter
(
    input wire clk,
    input wire rst,
	
	input wire set_time,
	input wire set_time_change,
	input wire set_time_add,
	
    output reg[3:0] hour_h,
	output reg[3:0] hour_l,
    output reg[3:0] minute_h,
	output reg[3:0] minute_l,
    output reg[3:0] second_h,
	output reg[3:0] second_l,
	
	//标志正在设置的位是哪一个
	output reg set_hour,
	output reg set_minute,
	output reg set_second
);
	
    reg[4:0]  hour_cnt;
    reg[5:0]  minute_cnt;
    reg[5:0]  second_cnt;
	reg[25:0] frequency_divider;
    reg       frequency_divider_out;
	reg       frequency_divider_out1,frequency_divider_out2;
	parameter crystal_frequency = 26'd50_000_000;
	
	reg[7:0]  hour_bcd_cnt;
    reg[7:0]  minute_bcd_cnt;
    reg[7:0]  second_bcd_cnt;
	
	reg       set_time_enable;
	parameter HOUR_CHANGE = 3'b001;
	parameter MINNUTE_CHANGE = 3'b010;
	parameter SECOND_CHANGE = 3'b100;
	reg[2:0]  change_state;
	reg       set_time_add_1;
	reg       set_time_add_2;
	reg       set_time_change_1;
	reg       set_time_change_2;
	
    always@(posedge clk or negedge rst)
    begin
        if(~rst)
		begin
            frequency_divider <= 26'b0;
			frequency_divider_out <= 1'b0;
		end
        else
        begin
            if(frequency_divider == crystal_frequency/2 - 26'b1)
			begin
                frequency_divider <= 26'b0;
				frequency_divider_out <= ~frequency_divider_out;
			end
            else
                frequency_divider <= frequency_divider + 26'b1;	
        end
    end
	
	always@(negedge set_time or negedge rst)
	begin
		if(~rst)
			set_time_enable <= 1'b0;
		else
			if(set_time_enable == 1'b0)
				set_time_enable <= 1'b1;
			else
				set_time_enable <= 1'b0;
	end
	
	always@(negedge rst or posedge clk)
	begin	
		if(~rst)
		begin
			change_state <= SECOND_CHANGE;
			set_time_change_1 <= 1'b1;
			set_time_change_2 <= 1'b1;
			set_second <= 1'b1;
			set_hour <= 1'b0;
			set_minute <= 1'b0;
		end
		else
		begin
			set_time_change_1 <= set_time_change;
			set_time_change_2 <= set_time_change_1;
			if(set_time_enable == 1'b1)
			begin
				if(~set_time_change_1 && set_time_change_2)
				begin
					case(change_state)
						HOUR_CHANGE:
						begin
							change_state <= SECOND_CHANGE;
							set_second <= 1'b1;
							set_hour <= 1'b0;
							set_minute <= 1'b0;
						end
						MINNUTE_CHANGE:
						begin
							change_state <= HOUR_CHANGE;
							set_hour <= 1'b1;
							set_second <= 1'b0;
							set_minute <= 1'b0;
						end
						SECOND_CHANGE:
						begin
							change_state <= MINNUTE_CHANGE;
							set_minute <= 1'b1;
							set_hour <= 1'b0;
							set_second <= 1'b0;
						end
						default:
						begin
							change_state <= SECOND_CHANGE;
							set_second <= 1'b1;
							set_hour <= 1'b0;
							set_minute <= 1'b0;
						end
					endcase
				end
				else
					change_state <= change_state;
			end
			else
				change_state <= SECOND_CHANGE;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(~rst)
		begin
			set_time_add_1 <= 1'b1;
			set_time_add_2 <= 1'b1;
			
			hour_cnt <= 5'b0;
			minute_cnt <= 6'b0;
			second_cnt <= 6'b0;
			frequency_divider_out1 <= 1'b0;
			frequency_divider_out2 <= 1'b0;
		end
		else
		begin
			set_time_add_1 <= set_time_add;
			set_time_add_2 <= set_time_add_1;
			frequency_divider_out1 <= frequency_divider_out;
			frequency_divider_out2 <= frequency_divider_out1;
			if(set_time_enable == 1'b1)
			begin
				if(~set_time_add_1 && set_time_add_2)
				begin
					case(change_state)
						HOUR_CHANGE:
						begin
							if(hour_cnt == 5'd23)
								hour_cnt <= 5'b0;
							else
								hour_cnt <= hour_cnt + 5'b1;
						end
						MINNUTE_CHANGE:
						begin
							if(minute_cnt == 6'd59)
								minute_cnt <= 6'b0;
							else
								minute_cnt <= minute_cnt + 6'b1;
						end
						SECOND_CHANGE:second_cnt <= 6'b0;
						default:change_state <= SECOND_CHANGE;
					endcase
				end
				else
					change_state <= change_state;
			end
			else
			begin
				if(frequency_divider_out1 && ~frequency_divider_out2)
				begin
					if(second_cnt == 6'd59)
					begin
						second_cnt <= 6'b0;
						if(minute_cnt == 6'd59)
						begin
							minute_cnt <= 6'b0;
							if(hour_cnt == 5'd23)
								hour_cnt <= 5'b0;
							else
								hour_cnt <= hour_cnt + 5'b1;
						end
						else
							minute_cnt <= minute_cnt + 6'b1;
					end
					else
						second_cnt <= second_cnt + 6'b1;
				end
				else
					second_cnt <= second_cnt;
			end
			
		end
	end
	
	always@(posedge clk)//BCD change
	begin
		if(second_cnt[3:0] > 4'd9)
			second_bcd_cnt <= {2'b0,second_cnt + 6'd6};
		else
			second_bcd_cnt <= {2'b0,second_cnt};
		if(minute_cnt[3:0] > 4'd9)
			minute_bcd_cnt <= {2'b0,minute_cnt + 6'd6};
		else
			minute_bcd_cnt <= {2'b0,minute_cnt};
		if(hour_cnt[3:0] > 4'd9)
			hour_bcd_cnt <= {3'b0,hour_cnt + 5'd6};
		else
			hour_bcd_cnt <= {3'b0,hour_cnt};
	end
	always@(posedge clk)//output
	begin
		hour_h   <= hour_bcd_cnt[7:4];
		hour_l   <= hour_bcd_cnt[3:0];
		minute_h <= minute_bcd_cnt[7:4];
		minute_l <= minute_bcd_cnt[3:0];
		second_h <= second_bcd_cnt[7:4];
		second_l <= second_bcd_cnt[3:0];
	end
endmodule