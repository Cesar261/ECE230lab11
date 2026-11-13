module top(
    input  btnU,     // Reset
    input  btnC,     // Input Clock
    output [6:0] led // LED outputs per IO Table
);

    // ==========================================
    // 1. Ripple Counter (Divide by 8)
    // ==========================================
    wire q0_n, q1_n, q2_n;

    // Stage 1 (led[0])
    t_ff tff0 (
        .t(1'b1), 
        .clk(btnC), 
        .rst(btnU),  // <--- FIXED: Added missing reset connection
        .q(led[0]), 
        .q_not(q0_n)
    );

    // Stage 2 (led[1]) - clocked by inverted output of Stage 1
    t_ff tff1 (
        .t(1'b1), 
        .clk(q0_n), 
        .rst(btnU),  // <--- FIXED: Added missing reset connection
        .q(led[1]), 
        .q_not(q1_n)
    );

    // Stage 3 (led[2]) - clocked by inverted output of Stage 2
    t_ff tff2 (
        .t(1'b1), 
        .clk(q1_n), 
        .rst(btnU),  // <--- FIXED: Added missing reset connection
        .q(led[2]), 
        .q_not(q2_n)
    );

    // ==========================================
    // 2. Modulo Divider (Divide by 12, Count of 6)
    // ==========================================
    wire [2:0] next_count;
    wire c1, c2, c3;
    wire cmp;
    wire [2:0] d_inputs;
    wire out_d;

    // 3-Bit Adder to compute (Count + 1)
    full_adder fa0 (
        .A(led[3]), .B(1'b1), .Cin(1'b0), // Add 1 to bit 0
        .Y(next_count[0]), .Cout(c1)
    );
    full_adder fa1 (
        .A(led[4]), .B(1'b0), .Cin(c1),   // Ripple carry to bit 1
        .Y(next_count[1]), .Cout(c2)
    );
    full_adder fa2 (
        .A(led[5]), .B(1'b0), .Cin(c2),   // Ripple carry to bit 2
        .Y(next_count[2]), .Cout(c3)
    );

    // Comparator: Check if current state == 5 (binary 101)
    // Since we want 6 states, we count 0, 1, 2, 3, 4, 5. 
    assign cmp = (led[5] & ~led[4] & led[3]);

    // Combinatorial logic for the next state of the counter
    // If Reset (btnU) or Comparator (cmp) is high, reset the count to 0. 
    // Otherwise, load next_count.
    assign d_inputs[0] = (btnU | cmp) ? 1'b0 : next_count[0];
    assign d_inputs[1] = (btnU | cmp) ? 1'b0 : next_count[1];
    assign d_inputs[2] = (btnU | cmp) ? 1'b0 : next_count[2];

    // State Flip-Flops for the modulo counter
    // <--- FIXED: Removed the empty .q_not() from these lines
    d_ff dff_count0 (.d(d_inputs[0]), .clk(btnC), .q(led[3]));
    d_ff dff_count1 (.d(d_inputs[1]), .clk(btnC), .q(led[4]));
    d_ff dff_count2 (.d(d_inputs[2]), .clk(btnC), .q(led[5]));

    // Combinatorial logic for the output toggler
    assign out_d = btnU ? 1'b0 : (cmp ? ~led[6] : led[6]);

    // Output Flip-Flop
    // <--- FIXED: Removed the empty .q_not() from this line
    d_ff dff_out (.d(out_d), .clk(btnC), .q(led[6]));

endmodule