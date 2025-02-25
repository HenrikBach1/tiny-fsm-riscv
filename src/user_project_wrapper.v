// User Project Wrapper for Caravel
module user_project_wrapper (
    input wire wb_clk_i,
    input wire wb_rst_i,
    // ...other inputs and outputs...

    // Wishbone interface
    input wire wb_stb_i,
    input wire wb_cyc_i,
    input wire wb_we_i,
    input wire [3:0] wb_sel_i,
    input wire [31:0] wb_adr_i,
    input wire [31:0] wb_dat_i,
    output wire [31:0] wb_dat_o,
    output wire wb_ack_o
);

// PicoRV32 instance
wire [3:0] fsm_config;
wire mem_valid;
wire mem_ready;
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [3:0] mem_wstrb;
wire [31:0] mem_rdata;

picorv32 cpu (
    .clk(wb_clk_i),
    .resetn(~wb_rst_i),
    .fsm_config(fsm_config),
    .mem_valid(mem_valid),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata)
);

// FSM overlay instance
fsm_overlay fsm (
    .clk(wb_clk_i),
    .resetn(~wb_rst_i),
    .config(fsm_config)
);

// Wishbone to PicoRV32 memory-mapped interface
assign mem_valid = wb_stb_i && wb_cyc_i;
assign mem_addr = wb_adr_i;
assign mem_wdata = wb_dat_i;
assign mem_wstrb = wb_we_i ? wb_sel_i : 4'b0;
assign wb_dat_o = mem_rdata;
assign wb_ack_o = mem_ready;

endmodule
