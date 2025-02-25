// 🔹 Extend PicoRV32 to properly interface with FSM
// ✅ Ensure `mem_valid`, `mem_ready`, `mem_addr`, `mem_wdata`, `mem_wstrb` exist
// ✅ Add read-back logic for `fsm_config`
// ✅ Verify FSM config register is properly memory-mapped

// ...existing code...

module picorv32 (
    input wire clk,
    input wire resetn,
    // ...other inputs and outputs...

    // Add FSM interface
    output reg [3:0] fsm_config,

    // Memory-mapped interface
    input wire mem_valid,
    output reg mem_ready,
    input wire [31:0] mem_addr,
    input wire [31:0] mem_wdata,
    input wire [3:0] mem_wstrb,
    output reg [31:0] mem_rdata
);

// ...existing code...

// Memory-mapped FSM Configuration Register
reg [31:0] fsm_config_reg; // Register to store FSM configuration

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        fsm_config_reg <= 32'b0;
        fsm_config <= 4'b0;
        mem_ready <= 1'b0;
    end else begin
        // Write: CPU writes FSM config at 0x1000_0000
        if (mem_valid && mem_addr == 32'h1000_0000 && mem_wstrb) begin
            fsm_config_reg <= mem_wdata;
            fsm_config <= mem_wdata[3:0]; // Assign lower 4 bits to FSM
            mem_ready <= 1'b1;
        end else if (mem_valid && mem_addr == 32'h1000_0000 && !mem_wstrb) begin
            // Read: CPU reads FSM config
            mem_rdata <= {28'b0, fsm_config}; // Return FSM config in lower 4 bits
            mem_ready <= 1'b1;
        end else begin
            mem_ready <= 1'b0;
        end
    end
end

// ...existing code...

endmodule
