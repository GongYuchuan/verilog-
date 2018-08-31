module seg_7
(
	input wire[3:0] in,
	input wire clk,
	input wire en,
	output reg[6:0] out
);

	always@(negedge clk)
	begin
		if(en)
		begin
			case(in)
				4'b0000:out <= 7'b0111_111;
				4'b0001:out <= 7'b0000_111;
				4'b0010:out <= 7'b1011_011;
				4'b0011:out <= 7'b1001_111;
				4'b0100:out <= 7'b1100_110;
				4'b0101:out <= 7'b1101_101;
				4'b0110:out <= 7'b1111_101;
				4'b0111:out <= 7'b0100_111;
				4'b1000:out <= 7'b1111_111;
				4'b1001:out <= 7'b1100_111;
				default:out <= out;
			endcase
		end
		else
			out <= 7'b0;
	end
endmodule