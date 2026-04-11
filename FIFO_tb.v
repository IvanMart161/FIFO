`timescale 1ns/1ps

module FIFO_tb;


    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;


    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

  
    FIFO #(DATA_WIDTH, ADDR_WIDTH) uut (
        .clk(clk), 
        .rst(rst), 
        .wr_en(wr_en), 
        .rd_en(rd_en), 
        .data_in(data_in), 
        .data_out(data_out), 
        .full(full), 
        .empty(empty)
    );


    always #50 clk = ~clk;

    
    task push_data(input [DATA_WIDTH-1:0] value);
        begin
            
            while (full) begin
                @(posedge clk);
            end
            
           
            data_in <= value;
            wr_en   <= 1;
            @(posedge clk);
            wr_en   <= 0;
            data_in <= 8'hzz; 
        end
    endtask

   
    task pop_data();
        begin
            while (empty) begin
                @(posedge clk);
            end
            
            rd_en <= 1;
            @(posedge clk);
            rd_en <= 0;
        end
    endtask

    
    initial begin 
        
        $dumpfile("fifo_test.vcd"); 
        $dumpvars(0, FIFO_tb);

     
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        
       
        #150 rst = 0; 

 
        push_data(8'h1F); push_data(8'h23); push_data(8'h5A); push_data(8'hB1);
        push_data(8'hB2); push_data(8'hB3); push_data(8'hB4); push_data(8'hA1);
        push_data(8'hA2); push_data(8'h3F); push_data(8'hBA); push_data(8'hBB);
        push_data(8'h8B); push_data(8'hA7); push_data(8'hB9); push_data(8'hBC);

        fork
            begin
                push_data(8'h58); 
                push_data(8'hBA); 
                push_data(8'h91); 
                push_data(8'hC4); 
                push_data(8'hFF);
            end
            
            begin
                #500; 
                repeat(21) pop_data();
            end
        join

        #500;
        $display("Testbench finished at %0t", $time);
        $finish;
    end 
    
endmodule