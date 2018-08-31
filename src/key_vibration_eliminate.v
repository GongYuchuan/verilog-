module key_vibration_eliminate
(
	input wire in,
	input wire clk,
	input wire rst,
	output reg out
);

	parameter crystal_frequency = 26'd50_000_000;
	
	reg[1:0] delay_reg;
	reg[19:0] frequency_divider;
	reg       frequency_divider_out;
	
	always@(posedge clk or negedge rst)
	begin
		if(~rst)
		begin
			frequency_divider     <= 20'b0;
			frequency_divider_out <= 1'b0;
		end
		else
		begin
			if(frequency_divider == crystal_frequency/200-26'b1)//10ms
			begin
				frequency_divider     <= 20'b0;
				frequency_divider_out <= ~frequency_divider_out;
			end
			else
				frequency_divider <= frequency_divider + 20'b1;
		end
	end
	
	always@(posedge frequency_divider_out or negedge rst)
	begin
		if(~rst)
		begin
			delay_reg <= 2'b11;//这里根据实际情况，初始化成高电平后面不会误判
			out <= 1'b1;
		end
		else
		begin
			delay_reg[1:0] <= {delay_reg[0],in};
			if(delay_reg[0] == delay_reg[1])
				out <= delay_reg[0];
			else
				out <= out;
		end
	end
endmodule