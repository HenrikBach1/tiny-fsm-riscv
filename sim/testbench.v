// Testbench for FSM + PicoRV32 Integration
// Simulates the FSM and verifies CPU control.
module testbench();
    reg clk, rst_n;
    reg [7:0] fsm_input;
    wire [3:0] fsm_state;

    // Instantiate FSM
    fsm_overlay uut (
        .clk(clk),
        .rst_n(rst_n),
        .fsm_input(fsm_input),
        .fsm_state(fsm_state)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        fsm_input = 8'b00000000;
        #10 rst_n = 1; // Release reset
    end

    always #5 clk = ~clk; // Clock generation
endmodule