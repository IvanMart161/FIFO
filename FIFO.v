module FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH = 16
) (
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);
    

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0] w_ptr, r_ptr;

    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
        end else begin
            if (wr_en && !full) begin 

                mem[w_ptr[ADDR_WIDTH-1:0]] <= data_in;
                w_ptr <= w_ptr + 1'b1;
            end
            
            if (rd_en && !empty) begin 
                r_ptr <= r_ptr + 1'b1;
            end

        end
    end
    assign empty = (w_ptr == r_ptr);
    assign full = (w_ptr[ADDR_WIDTH] != r_ptr[ADDR_WIDTH]) && (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);
    assign data_out = mem[r_ptr[ADDR_WIDTH-1:0]];
endmodule