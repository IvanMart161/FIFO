`timescale 1ns/1ps

module FIFO_tb;

parameter DATA_WIDTH = 8, ADDR_WIDTH = 4;

reg clk, rst, wr_en, rd_en;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire full, empty;

FIFO #(DATA_WIDTH, ADDR_WIDTH) uut (
    .clk(clk), .rst(rst), .wr_en(wr_en), 
    .rd_en(rd_en), .data_in(data_in), .data_out(data_out), 
    .full(full), .empty(empty)
);

always #50 clk = ~clk;

initial begin 
    $dumpfile("fifo_test.vcd"); 
    $dumpvars(0, FIFO_tb);

    clk = 0;
    rst = 1;
    wr_en <= 0;
    rd_en <= 0;
    data_in = 0;
    
    #150 rst = 0; 

    
    @(posedge clk) begin
        wr_en <= 1;
        data_in <= 8'h1F;
        @(posedge clk) data_in <= 8'h23;
        @(posedge clk) data_in <= 8'h5A;
        @(posedge clk) data_in <= 8'hB1;
        @(posedge clk) data_in <= 8'hB2;
        @(posedge clk) data_in <= 8'hB3;
        @(posedge clk) data_in <= 8'hB4;
        @(posedge clk) wr_en <= 0; 

    end

    #200; 

   
    

    #200; 
    
   
    @(posedge clk) rd_en = 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk) rd_en = 0;  


    
    #1000; 
    $display("Testbench finished!");
    $finish;
end 
    
endmodule