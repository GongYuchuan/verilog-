module flashing_instruction
(
	input wire en,
	input wire clk,
	input wire rst,
	output reg instruction
);
	
	parameter crystal_frequency = 26'd50_000_000;
	reg[24:0] frequency_divider;
	
	always@(posedge clk or negedge rst)
	begin
		if(~rst)
		begin
			frequency_divider <= 25'b0;
			instruction       <= 1'b1;
		end
		else
		begin
			if(en == 1'b1)
			begin
				if(frequency_divider == crystal_frequency/2-26'b1)// 1s/周期
				begin
					frequency_divider <= 20'b0;
					instruction       <= ~instruction;
				end
				else
					frequency_divider <= frequency_divider + 20'b1;
			end
			else
				instruction <= 1'b1;
		end
	end
endmodule