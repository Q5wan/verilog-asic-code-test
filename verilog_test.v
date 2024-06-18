module tt_um_Q5wan_4_bit_ALU (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Register declarations
  reg [7:0] A, B;     // Registers for storing inputs A and B
  reg [7:0] Y;        // Register for storing output Y

  // Assign A and B on positive edge of clock and reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      A <= 8'b0;
      B <= 8'b0;
    end else begin
      A <= ui_in & 8'b0000_1111;
      B <= (ui_in & 8'b1111_0000) >> 4;
    end
  end

  // Calculate Y on negative edge of clock
  always @(negedge clk) begin
    case (uio_in[2:0])  // Use only lower 3 bits of uio_in for operation selection
      3'b000 : Y <= A + B;
      3'b001 : Y <= A - B;
      3'b010 : Y <= A & B;
      3'b011 : Y <= A | B;
      3'b100 : Y <= A ^ B;
      3'b101 : Y <= ~A;
      3'b110 : Y <= A >> 1;
      3'b111 : Y <= A << 1;
      default : Y <= 8'b0; // Default case, though this should not occur with valid inputs
    endcase
  end

  // Outputs
  assign uo_out  = Y; // Output the result Y
  assign uio_out = 0; 
  assign uio_oe  = 0; 

endmodule
