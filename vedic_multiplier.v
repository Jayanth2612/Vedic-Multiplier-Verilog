code with normal assignment 


module ha(a, b, sum, carry);
input a;
input b;
output sum;
output carry;
assign carry=a&b;
assign sum=a^b;
endmodule


module vedic_2x2(A,B,P);
input [1:0]A;
input [1:0]B;
output [3:0]P;
wire [3:0]P;
wire [3:0]temp;
assign P[0]=A[0]&B[0]; 
assign temp[0]=A[1]&B[0];
assign temp[1]=A[0]&B[1];
assign temp[2]=A[1]&B[1]; 
ha z1(temp[0],temp[1],P[1],temp[3]);
ha z2(temp[2],temp[3],P[2],P[3]);
endmodule







module vedic4bit_multiplier (
    input [3:0] A,  
    input [3:0] B,  
    output [7:0] P  
);
   
    wire [3:0] m0, m1, m2, m3;
    wire [7:0] temp1, temp2, temp3, temp4, temp5;

    
    vedic_2x2 U1 (A[1:0], B[1:0], m0); 
    vedic_2x2 U2 (A[3:2], B[1:0], m1); 
    vedic_2x2 U3 (A[1:0], B[3:2], m2); 
    vedic_2x2 U4 (A[3:2], B[3:2], m3); 

    
    assign temp1 = {4'b0000, m0};          
    assign temp2 = {2'b00, m1, 2'b00};     
    assign temp3 = {2'b00, m2, 2'b00};     
    assign temp4 = {m3, 4'b0000};          

    
    assign temp5 = temp1 + temp2 + temp3;  
    assign P = temp5 + temp4;              

endmodule

module vedic8bit_multiplier(
    input [7:0] A,  
    input [7:0] B,  
    output [15:0] P  
);
    wire [7:0] m0, m1, m2, m3;  
    wire [15:0] temp1, temp2, temp3, temp4, temp5;

   
    vedic4bit_multiplier VM1 (A[3:0], B[3:0], m0);  
    vedic4bit_multiplier VM2 (A[7:4], B[3:0], m1);  
    vedic4bit_multiplier VM3 (A[3:0], B[7:4], m2);
    vedic4bit_multiplier VM4 (A[7:4], B[7:4], m3);  

    
    assign temp1 = {8'b0, m0};                      
    assign temp2 = {4'b0, m1, 4'b0};                
    assign temp3 = {4'b0, m2, 4'b0};                
    assign temp4 = {m3, 8'b0};                     

    assign temp5 = temp1 + temp2 + temp3;           
    assign P = temp5 + temp4;                       

endmodule


module vedic16bit_multiplier(
    input [15:0] A,  
    input [15:0] B,  
    output [31:0] P  
);
    wire [15:0] m0, m1, m2, m3;  
    wire [31:0] temp1, temp2, temp3, temp4, temp5;

    
    vedic8bit_multiplier VM1 (A[7:0], B[7:0], m0);      
    vedic8bit_multiplier VM2 (A[15:8], B[7:0], m1);    
    vedic8bit_multiplier VM3 (A[7:0], B[15:8], m2);   
    vedic8bit_multiplier VM4 (A[15:8], B[15:8], m3);    

    
    assign temp1 = {16'b0, m0};                          
    assign temp2 = {8'b0, m1, 8'b0};                   
    assign temp3 = {8'b0, m2, 8'b0};                   
    assign temp4 = {m3, 16'b0};                         

    assign temp5 = temp1 + temp2 + temp3;                
    assign P = temp5 + temp4;                     
endmodule


module vedic32bit_multiplier(
    input [31:0] A,  
    input [31:0] B,  
    output [63:0] P  
);
    wire [31:0] m0, m1, m2, m3;  
    wire [63:0] temp1, temp2, temp3, temp4, temp5;

   
    vedic16bit_multiplier VM1 (A[15:0], B[15:0], m0);   
    vedic16bit_multiplier VM2 (A[31:16], B[15:0], m1);  
    vedic16bit_multiplier VM3 (A[15:0], B[31:16], m2);  
    vedic16bit_multiplier VM4 (A[31:16], B[31:16], m3); 

   
    assign temp1 = {32'b0, m0};                         
    assign temp2 = {16'b0, m1, 16'b0};                  
    assign temp3 = {16'b0, m2, 16'b0};                  
    assign temp4 = {m3, 32'b0};                         

    assign temp5 = temp1 + temp2 + temp3;               
    assign P = temp5 + temp4;                           

endmodule

module tb_vedic32bit_multiplier;

    
    reg [31:0] A;
    reg [31:0] B;

    
    wire [63:0] P;

    
    vedic32bit_multiplier uut (
        .A(A), 
        .B(B), 
        .P(P)
    );

    
    initial begin
        
        $monitor("A = %d, B = %d, P = %d", A, B, P);

        
        A = 32'd1;  
        B = 32'd2;  
        #10; 

        
        A = 32'd15; 
        B = 32'd10;
        #10; 

        
        A = 32'd100000;  
        B = 32'd200000;  
        #10;

        
        A = 32'd4294967295;  
        B = 32'd4294967295;  
        #10;

        
        A = 32'd0;
        B = 32'd12345;
        #10;

        
        A = 32'd2468;
        B = 32'd1357;
        #10;

        
        A = 32'd987654321;
        B = 32'd1;
        #10;

        
    end

endmodule

------------------------------------------------------------------------------------------------------------------
code with carry look ahed adder


module ha(a, b, sum, carry);
    input a;
    input b;
    output sum;
    output carry;
    assign carry = a & b;
    assign sum = a ^ b;
endmodule

// 2x2 Vedic Multiplier
module vedic_2x2(A, B, P);
    input [1:0] A;
    input [1:0] B;
    output [3:0] P;
    wire [3:0] P;
    wire [3:0] temp;
    assign P[0] = A[0] & B[0]; 
    assign temp[0] = A[1] & B[0];
    assign temp[1] = A[0] & B[1];
    assign temp[2] = A[1] & B[1]; 
    ha z1(temp[0], temp[1], P[1], temp[3]);
    ha z2(temp[2], temp[3], P[2], P[3]);
endmodule

// 8-bit Carry Look-Ahead Adder (CLA)
module carry_lookahead_adder #(parameter N = 8) (
    input [N-1:0] A,          // Input operand A
    input [N-1:0] B,          // Input operand B
    output [N-1:0] Sum,       // Sum output
    output Cout               // Carry output
);
    wire [N-1:0] G, P;        // Generate and Propagate signals
    wire [N:0] C;             // Carry signals from C0 to CN

    // Generate the Propagate (P) and Generate (G) signals
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign P[i] = A[i] ^ B[i];      // Propagate: A XOR B
            assign G[i] = A[i] & B[i];      // Generate: A AND B
        end
    endgenerate

    // Compute the carry signals using the look-ahead formula
    assign C[0] = 1'b0;  // Set Carry-in (Cin) to 0
    generate
        for (i = 1; i <= N; i = i + 1) begin
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);  // Carry generation
        end
    endgenerate

    // Compute the sum bits
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign Sum[i] = P[i] ^ C[i];  // Sum = P XOR Carry
        end
    endgenerate

    // Final carry-out
    assign Cout = C[N];  // Carry-out is the last carry

endmodule

// 4-bit Vedic Multiplier
module vedic4bit_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] m0, m1, m2, m3;
    wire [7:0] temp1, temp2, temp3, temp4, temp5;
    wire [7:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 2x2 Vedic multiplier
    vedic_2x2 U1 (A[1:0], B[1:0], m0); // 2x2 Vedic multiplier for lower 2 bits of A and B
    vedic_2x2 U2 (A[3:2], B[1:0], m1); // 2x2 Vedic multiplier for upper 2 bits of A and lower 2 bits of B
    vedic_2x2 U3 (A[1:0], B[3:2], m2); // 2x2 Vedic multiplier for lower 2 bits of A and upper 2 bits of B
    vedic_2x2 U4 (A[3:2], B[3:2], m3); // 2x2 Vedic multiplier for upper 2 bits of A and upper 2 bits of B

    // Use CLA to add the partial products
    carry_lookahead_adder #(8) CLA1 (
        .A({4'b0000, m0}), 
        .B({2'b00, m1, 2'b00}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    carry_lookahead_adder #(8) CLA2 (
        .A(sum1), 
        .B({2'b00, m2, 2'b00}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    carry_lookahead_adder #(8) CLA3 (
        .A(sum2), 
        .B({m3, 4'b0000}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 8-bit Vedic Multiplier
module vedic8bit_multiplier (
    input [7:0] A,
    input [7:0] B,
    output [15:0] P
);
    wire [7:0] m0, m1, m2, m3;
    wire [15:0] temp1, temp2, temp3, temp4, temp5;
    wire [15:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 4x4 Vedic multiplier
    vedic4bit_multiplier VM1 (A[3:0], B[3:0], m0);  // 4x4 Vedic multiplier for lower 4 bits
    vedic4bit_multiplier VM2 (A[7:4], B[3:0], m1);  // 4x4 Vedic multiplier for upper 4 bits of A and lower 4 bits of B
    vedic4bit_multiplier VM3 (A[3:0], B[7:4], m2);  // 4x4 Vedic multiplier for lower 4 bits of A and upper 4 bits of B
    vedic4bit_multiplier VM4 (A[7:4], B[7:4], m3);  // 4x4 Vedic multiplier for upper 4 bits

    // Use CLA to add the partial products
    carry_lookahead_adder #(16) CLA1 (
        .A({8'b0, m0}), 
        .B({4'b0, m1, 4'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    carry_lookahead_adder #(16) CLA2 (
        .A(sum1), 
        .B({4'b0, m2, 4'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    carry_lookahead_adder #(16) CLA3 (
        .A(sum2), 
        .B({m3, 8'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 16-bit Vedic Multiplier
module vedic16bit_multiplier (
    input [15:0] A,
    input [15:0] B,
    output [31:0] P
);
    wire [15:0] m0, m1, m2, m3;
    wire [31:0] temp1, temp2, temp3, temp4, temp5;
    wire [31:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 8x8 Vedic multiplier
    vedic8bit_multiplier VM1 (A[7:0], B[7:0], m0);     // 8x8 Vedic multiplier for lower 8 bits
    vedic8bit_multiplier VM2 (A[15:8], B[7:0], m1);    // 8x8 Vedic multiplier for upper 8 bits of A and lower 8 bits of B
    vedic8bit_multiplier VM3 (A[7:0], B[15:8], m2);    // 8x8 Vedic multiplier for lower 8 bits of A and upper 8 bits of B
    vedic8bit_multiplier VM4 (A[15:8], B[15:8], m3);   // 8x8 Vedic multiplier for upper 8 bits

    // Use CLA to add the partial products
    carry_lookahead_adder #(32) CLA1 (
        .A({16'b0, m0}), 
        .B({8'b0, m1, 8'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    carry_lookahead_adder #(32) CLA2 (
        .A(sum1), 
        .B({8'b0, m2, 8'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    carry_lookahead_adder #(32) CLA3 (
        .A(sum2), 
        .B({m3, 16'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule



module vedic32bit_multiplier (
    input [31:0] A,
    input [31:0] B,
    output [63:0] P
);
    wire [31:0] m0, m1, m2, m3;
    wire [63:0] temp1, temp2, temp3, temp4, temp5;
    wire [63:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 16x16 Vedic multiplier
    vedic16bit_multiplier VM1 (A[15:0], B[15:0], m0);   // 16x16 Vedic multiplier for lower 16 bits
    vedic16bit_multiplier VM2 (A[31:16], B[15:0], m1);   // 16x16 Vedic multiplier for upper 16 bits of A and lower 16 bits of B
    vedic16bit_multiplier VM3 (A[15:0], B[31:16], m2);   // 16x16 Vedic multiplier for lower 16 bits of A and upper 16 bits of B
    vedic16bit_multiplier VM4 (A[31:16], B[31:16], m3);  // 16x16 Vedic multiplier for upper 16 bits

    // Use CLA to add the partial products
    carry_lookahead_adder #(64) CLA1 (
        .A({32'b0, m0}), 
        .B({16'b0, m1, 16'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    carry_lookahead_adder #(64) CLA2 (
        .A(sum1), 
        .B({16'b0, m2, 16'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    carry_lookahead_adder #(64) CLA3 (
        .A(sum2), 
        .B({m3, 32'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule


module tb_vedic32bit_multiplier;

    
    reg [31:0] A;
    reg [31:0] B;

    
    wire [63:0] P;

    
    vedic32bit_multiplier uut (
        .A(A), 
        .B(B), 
        .P(P)
    );

    
    initial begin
        
        $monitor("A = %d, B = %d, P = %d", A, B, P);

        
        A = 32'd1;  
        B = 32'd2;  
        #10; 

        
        A = 32'd15; 
        B = 32'd10;
        #10; 

        
        A = 32'd100000;  
        B = 32'd200000;  
        #10;

        
        A = 32'd4294967295;  
        B = 32'd4294967295;  
        #10;

        
        A = 32'd0;
        B = 32'd12345;
        #10;

        
        A = 32'd2468;
        B = 32'd1357;
        #10;

        
        A = 32'd987654321;
        B = 32'd1;
        #10;

        
    end

endmodule

----------------------------------------------------------------------------------------------------------------

code with ripple carry adder


module ha(a, b, sum, carry);
    input a;
    input b;
    output sum;
    output carry;
    assign carry = a & b;
    assign sum = a ^ b;
endmodule

// 2x2 Vedic Multiplier
module vedic_2x2(A, B, P);
    input [1:0] A;
    input [1:0] B;
    output [3:0] P;
    wire [3:0] temp;
    wire [3:0] temp_carry;

    assign P[0] = A[0] & B[0]; // LSB product
    assign temp[0] = A[1] & B[0];
    assign temp[1] = A[0] & B[1];
    assign temp[2] = A[1] & B[1];

    ha z1(temp[0], temp[1], P[1], temp_carry[0]); // First half adder
    ha z2(temp[2], temp_carry[0], P[2], P[3]); // Second half adder
endmodule

// Ripple Carry Adder (RCA) for adding two n-bit numbers
module ripple_carry_adder #(parameter N = 8) (
    input [N-1:0] A,      // Input operand A
    input [N-1:0] B,      // Input operand B
    output [N-1:0] Sum,   // Sum output
    output Cout           // Carry output
);
    wire [N-1:0] carry;
    assign carry[0] = 1'b0; // Initial carry-in is set to 0

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_loop
            if (i == 0) begin
                full_adder FA0 (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(carry[i+1])
                );
            end else if (i == N-1) begin
                full_adder FA_last (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(Cout)
                );
            end else begin
                full_adder FA (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(carry[i+1])
                );
            end
        end
    endgenerate
endmodule

// Full Adder (FA) used in Ripple Carry Adder
module full_adder(
    input A, B, Cin,
    output Sum, Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

// 4-bit Vedic Multiplier
module vedic4bit_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] m0, m1, m2, m3;
    wire [7:0] temp1, temp2, temp3, temp4;
    wire [7:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 2x2 Vedic multiplier
    vedic_2x2 U1 (A[1:0], B[1:0], m0);  // 2x2 Vedic multiplier for lower 2 bits
    vedic_2x2 U2 (A[3:2], B[1:0], m1);  // 2x2 Vedic multiplier for upper 2 bits of A and lower 2 bits of B
    vedic_2x2 U3 (A[1:0], B[3:2], m2);  // 2x2 Vedic multiplier for lower 2 bits of A and upper 2 bits of B
    vedic_2x2 U4 (A[3:2], B[3:2], m3);  // 2x2 Vedic multiplier for upper 2 bits of A and upper 2 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(8) RCA1 (
        .A({4'b0000, m0}), 
        .B({2'b00, m1, 2'b00}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(8) RCA2 (
        .A(sum1), 
        .B({2'b00, m2, 2'b00}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(8) RCA3 (
        .A(sum2), 
        .B({m3, 4'b0000}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 8-bit Vedic Multiplier
module vedic8bit_multiplier (
    input [7:0] A,
    input [7:0] B,
    output [15:0] P
);
    wire [7:0] m0, m1, m2, m3;
    wire [15:0] temp1, temp2, temp3, temp4;
    wire [15:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 4x4 Vedic multiplier
    vedic4bit_multiplier VM1 (A[3:0], B[3:0], m0);  // 4x4 Vedic multiplier for lower 4 bits
    vedic4bit_multiplier VM2 (A[7:4], B[3:0], m1);  // 4x4 Vedic multiplier for upper 4 bits of A and lower 4 bits of B
    vedic4bit_multiplier VM3 (A[3:0], B[7:4], m2);  // 4x4 Vedic multiplier for lower 4 bits of A and upper 4 bits of B
    vedic4bit_multiplier VM4 (A[7:4], B[7:4], m3);  // 4x4 Vedic multiplier for upper 4 bits of A and upper 4 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(16) RCA1 (
        .A({8'b0, m0}), 
        .B({4'b0, m1, 4'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(16) RCA2 (
        .A(sum1), 
        .B({4'b0, m2, 4'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(16) RCA3 (
        .A(sum2), 
        .B({m3, 8'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 16-bit Vedic Multiplier
module vedic16bit_multiplier (
    input [15:0] A,
    input [15:0] B,
    output [31:0] P
);
    wire [15:0] m0, m1, m2, m3;
    wire [31:0] temp1, temp2, temp3, temp4;
    wire [31:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 8x8 Vedic multiplier
    vedic8bit_multiplier VM1 (A[7:0], B[7:0], m0);     // 8x8 Vedic multiplier for lower 8 bits
    vedic8bit_multiplier VM2 (A[15:8], B[7:0], m1);    // 8x8 Vedic multiplier for upper 8 bits of A and lower 8 bits of B
    vedic8bit_multiplier VM3 (A[7:0], B[15:8], m2);    // 8x8 Vedic multiplier for lower 8 bits of A and upper 8 bits of B
    vedic8bit_multiplier VM4 (A[15:8], B[15:8], m3);   // 8x8 Vedic multiplier for upper 8 bits of A and upper 8 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(32) RCA1 (
        .A({16'b0, m0}), 
        .B({8'b0, m1, 8'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(32) RCA2 (
        .A(sum1), 
        .B({8'b0, m2, 8'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(32) RCA3 (
        .A(sum2), 
        .B({m3, 16'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 32-bit Vedic Multiplier
module vedic32bit_multiplier (
    input [31:0] A,
    input [31:0] B,
    output [63:0] P
);
    wire [31:0] m0, m1, m2, m3;
    wire [63:0] temp1, temp2, temp3, temp4;
    wire [63:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 16x16 Vedic multiplier
    vedic16bit_multiplier VM1 (A[15:0], B[15:0], m0);   // 16x16 Vedic multiplier for lower 16 bits
    vedic16bit_multiplier VM2 (A[31:16], B[15:0], m1);   // 16x16 Vedic multiplier for upper 16 bits of A and lower 16 bits of B
    vedic16bit_multiplier VM3 (A[15:0], B[31:16], m2);   // 16x16 Vedic multiplier for lower 16 bits of A and upper 16 bits of B
    vedic16bit_multiplier VM4 (A[31:16], B[31:16], m3);  // 16x16 Vedic multiplier for upper 16 bits

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(64) RCA1 (
        .A({32'b0, m0}), 
        .B({16'b0, m1, 16'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(64) RCA2 (
        .A(sum1), 
        .B({16'b0, m2, 16'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(64) RCA3 (
        .A(sum2), 
        .B({m3, 32'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule


------------------------------------------------------------------------------------------------------------------
code with ripple carry adder 



module ha(a, b, sum, carry);
    input a;
    input b;
    output sum;
    output carry;
    assign carry = a & b;
    assign sum = a ^ b;
endmodule

// 2x2 Vedic Multiplier
module vedic_2x2(A, B, P);
    input [1:0] A;
    input [1:0] B;
    output [3:0] P;
    wire [3:0] temp;
    wire [3:0] temp_carry;

    assign P[0] = A[0] & B[0]; // LSB product
    assign temp[0] = A[1] & B[0];
    assign temp[1] = A[0] & B[1];
    assign temp[2] = A[1] & B[1];

    ha z1(temp[0], temp[1], P[1], temp_carry[0]); // First half adder
    ha z2(temp[2], temp_carry[0], P[2], P[3]); // Second half adder
endmodule

// Ripple Carry Adder (RCA) for adding two n-bit numbers
module ripple_carry_adder #(parameter N = 8) (
    input [N-1:0] A,      // Input operand A
    input [N-1:0] B,      // Input operand B
    output [N-1:0] Sum,   // Sum output
    output Cout           // Carry output
);
    wire [N-1:0] carry;
    assign carry[0] = 1'b0; // Initial carry-in is set to 0

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_loop
            if (i == 0) begin
                full_adder FA0 (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(carry[i+1])
                );
            end else if (i == N-1) begin
                full_adder FA_last (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(Cout)
                );
            end else begin
                full_adder FA (
                    .A(A[i]), .B(B[i]), .Cin(carry[i]), 
                    .Sum(Sum[i]), .Cout(carry[i+1])
                );
            end
        end
    endgenerate
endmodule

// Full Adder (FA) used in Ripple Carry Adder
module full_adder(
    input A, B, Cin,
    output Sum, Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule

// 4-bit Vedic Multiplier
module vedic4bit_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] m0, m1, m2, m3;
    wire [7:0] temp1, temp2, temp3, temp4;
    wire [7:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 2x2 Vedic multiplier
    vedic_2x2 U1 (A[1:0], B[1:0], m0);  // 2x2 Vedic multiplier for lower 2 bits
    vedic_2x2 U2 (A[3:2], B[1:0], m1);  // 2x2 Vedic multiplier for upper 2 bits of A and lower 2 bits of B
    vedic_2x2 U3 (A[1:0], B[3:2], m2);  // 2x2 Vedic multiplier for lower 2 bits of A and upper 2 bits of B
    vedic_2x2 U4 (A[3:2], B[3:2], m3);  // 2x2 Vedic multiplier for upper 2 bits of A and upper 2 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(8) RCA1 (
        .A({4'b0000, m0}), 
        .B({2'b00, m1, 2'b00}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(8) RCA2 (
        .A(sum1), 
        .B({2'b00, m2, 2'b00}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(8) RCA3 (
        .A(sum2), 
        .B({m3, 4'b0000}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 8-bit Vedic Multiplier
module vedic8bit_multiplier (
    input [7:0] A,
    input [7:0] B,
    output [15:0] P
);
    wire [7:0] m0, m1, m2, m3;
    wire [15:0] temp1, temp2, temp3, temp4;
    wire [15:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 4x4 Vedic multiplier
    vedic4bit_multiplier VM1 (A[3:0], B[3:0], m0);  // 4x4 Vedic multiplier for lower 4 bits
    vedic4bit_multiplier VM2 (A[7:4], B[3:0], m1);  // 4x4 Vedic multiplier for upper 4 bits of A and lower 4 bits of B
    vedic4bit_multiplier VM3 (A[3:0], B[7:4], m2);  // 4x4 Vedic multiplier for lower 4 bits of A and upper 4 bits of B
    vedic4bit_multiplier VM4 (A[7:4], B[7:4], m3);  // 4x4 Vedic multiplier for upper 4 bits of A and upper 4 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(16) RCA1 (
        .A({8'b0, m0}), 
        .B({4'b0, m1, 4'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(16) RCA2 (
        .A(sum1), 
        .B({4'b0, m2, 4'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(16) RCA3 (
        .A(sum2), 
        .B({m3, 8'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule

// 16-bit Vedic Multiplier
module vedic16bit_multiplier (
    input [15:0] A,
    input [15:0] B,
    output [31:0] P
);
    wire [15:0] m0, m1, m2, m3;
    wire [31:0] temp1, temp2, temp3, temp4;
    wire [31:0] sum1, sum2;
    wire carry1, carry2;

    // Generate partial products using 8x8 Vedic multiplier
    vedic8bit_multiplier VM1 (A[7:0], B[7:0], m0);     // 8x8 Vedic multiplier for lower 8 bits
    vedic8bit_multiplier VM2 (A[15:8], B[7:0], m1);    // 8x8 Vedic multiplier for upper 8 bits of A and lower 8 bits of B
    vedic8bit_multiplier VM3 (A[7:0], B[15:8], m2);    // 8x8 Vedic multiplier for lower 8 bits of A and upper 8 bits of B
    vedic8bit_multiplier VM4 (A[15:8], B[15:8], m3);   // 8x8 Vedic multiplier for upper 8 bits of A and upper 8 bits of B

    // Add the partial products using Ripple Carry Adders (RCA)
    ripple_carry_adder #(32) RCA1 (
        .A({16'b0, m0}), 
        .B({8'b0, m1, 8'b0}), 
        .Sum(sum1), 
        .Cout(carry1)
    );

    ripple_carry_adder #(32) RCA2 (
        .A(sum1), 
        .B({8'b0, m2, 8'b0}), 
        .Sum(sum2), 
        .Cout(carry2)
    );

    // Final addition of the last partial product
    ripple_carry_adder #(32) RCA3 (
        .A(sum2), 
        .B({m3, 16'b0}), 
        .Sum(P), 
        .Cout()
    );

endmodule



module matrix_multiplier_2x2(
    input [15:0] A11, A12, A21, A22,  // Elements of matrix A
    input [15:0] B11, B12, B21, B22,  // Elements of matrix B
    output [31:0] C11, C12, C21, C22  // Elements of resulting matrix C
);
    wire [31:0] P11, P12, P21, P22, P13, P14, P23, P24;  // Partial products
    wire [31:0] S11, S12, S21, S22;                     // Sums for final results
    wire carry1, carry2,carry3,carry4;

    // Instantiate 32-bit Vedic multipliers for each product
    vedic16bit_multiplier VM1 (A11, B11, P11);  
    vedic16bit_multiplier VM2 (A12, B21, P12);  
    vedic16bit_multiplier VM3 (A11, B12, P13);  
    vedic16bit_multiplier VM4 (A12, B22, P14);  
    vedic16bit_multiplier VM5 (A21, B11, P21);  
    vedic16bit_multiplier VM6 (A22, B21, P22);  
    vedic16bit_multiplier VM7 (A21, B12, P23);  
    vedic16bit_multiplier VM8 (A22, B22, P24);  

    ripple_carry_adder #(32) CLA1(
        .A(P11), 
        .B(P12), 
        .Sum(S11), 
        .Cout(carry1)
    );  
     ripple_carry_adder #(32) CLA2(
        .A(P13), 
        .B(P14), 
        .Sum(S12), 
        .Cout(carry2)
    );
  
      ripple_carry_adder #(32) CLA3(
        .A(P21), 
        .B(P22), 
        .Sum(S21), 
        .Cout(carry3)
    );
 ripple_carry_adder #(32) CLA4(
        .A(P23), 
        .B(P24), 
        .Sum(S22), 
        .Cout(carry4)
    );
  

    assign C11 = S11;
    assign C12 = S12;
    assign C21 = S21;
    assign C22 = S22;

endmodule


module tb_matrix_multiplier_2x2;
    reg [15:0] A11, A12, A21, A22;  // Elements of matrix A
    reg [15:0] B11, B12, B21, B22;  // Elements of matrix B
    wire [31:0] C11, C12, C21, C22; // Elements of resulting matrix C

    // Instantiate the matrix multiplier module
    matrix_multiplier_2x2 uut (
        .A11(A11), .A12(A12), .A21(A21), .A22(A22),
        .B11(B11), .B12(B12), .B21(B21), .B22(B22),
        .C11(C11), .C12(C12), .C21(C21), .C22(C22)
    );

    initial begin
        // Test case 1
        A11 = 16'd2; A12 = 16'd3; A21 = 16'd4; A22 = 16'd5;
        B11 = 16'd1; B12 = 16'd0; B21 = 16'd1; B22 = 16'd1;
        #10;
        $display("C11: %d, C12: %d, C21: %d, C22: %d", C11, C12, C21, C22);

        // Test case 2
        A11 = 16'd6235; A12 = 16'd20; A21 = 16'd30; A22 = 16'd40;
        B11 = 16'd6295; B12 = 16'd15; B21 = 16'd25; B22 = 16'd35;
        #10;
        $display("C11: %d, C12: %d, C21: %d, C22: %d", C11, C12, C21, C22);

        // Test case 3
        A11 = 16'd7; A12 = 16'd8; A21 = 16'd9; A22 = 16'd495;
        B11 = 16'd5678; B12 = 16'd3495; B21 = 16'd3; B22 = 16'd2;
        #10;
        $display("C11: %d, C12: %d, C21: %d, C22: %d", C11, C12, C21, C22);

        
    end
endmodule
---------------------------------------------------------------------------------------------------------------

