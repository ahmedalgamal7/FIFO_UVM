import uvm_pkg::*;
import fifo_test_pack::*;
`include "uvm_macros.svh"
module top ();
bit clk;
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
fifo_if fifo_interface (clk);
FIFO dut (fifo_interface);
bind FIFO sva assertions (fifo_interface);
initial begin
    uvm_config_db #(virtual fifo_if)::set(null,"uvm_test_top","fifo",fifo_interface);
    run_test("fifo_test");
end
endmodule