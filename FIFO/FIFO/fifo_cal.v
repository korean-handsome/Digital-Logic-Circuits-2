// calculate address logic
module fifo_cal_addr(state, head, tail, data_count, we, re, next_head, next_tail, next_data_count);
	input[2:0] state, head, tail;
	input[3:0] data_count;
	output reg we, re;
	output reg[2:0] next_head, next_tail;
	output reg[3:0] next_data_count;

	parameter INIT = 3'b000;
	parameter NO_OP = 3'b001;
	parameter WRITE = 3'b010;
	parameter WR_ERROR = 3'b011;
	parameter READ = 3'b100;
	parameter RD_ERROR = 3'b101;

	always@(state, head, tail, data_count)
	case(state)
	INIT: begin
		we=0; 
		re=0;
		next_head=0;
		next_tail=0;
		next_data_count=0;
		end
	NO_OP: begin
		we=0;
		re=0;
		next_head = head;
		next_tail=tail;
		next_data_count=data_count;
		end
	WRITE: begin
	if(data_count == 8)
		re=1;
	else
		begin
		we=1;
		re=0;
		next_head = head;
		next_tail = tail + 3'b1;
		next_data_count = data_count + 4'b1;
		end
		end
	WR_ERROR: begin
		we=0;
		re=0;
		next_head = head;
		next_tail=tail;
		next_data_count=data_count;
		end
	READ: begin
	if(data_count == 0)
		we=1;
	else
		begin
		we=0;
		re=1;
		next_head = head + 3'b1;
		next_tail = tail;
		next_data_count = data_count - 4'b1;
		end
		end
	RD_ERROR: begin
		we=0;
		re=0;
		next_head = head;
		next_tail=tail;
		next_data_count=data_count;
		end
	default: begin
		we=0; 
		re=0;
		next_head=3'bx;
		next_tail=3'bx;
		next_data_count=4'bx;
		end
	endcase
endmodule

		
		