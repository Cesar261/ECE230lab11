module t_ff(
    input t,
    input clk,
    input rst, // Added asynchronous reset input
    output reg q,
    output q_not
);
    // Set initial state
    initial begin
        q <= 1'b0;      
    end
    
    assign q_not = ~q;

    // Trigger on rising edge of clock OR rising edge of reset (Asynchronous)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0; // Reset immediately goes to 0
        end else if (t) begin
            q <= ~q;   // Toggle if T is asserted
        end
    end
    
endmodule