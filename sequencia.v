module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);

    // Registradores
    reg [7:0] palavra_armazenada;  
    reg [7:0] shift_register;      
    reg buscando;                  

    // Estado atual 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            palavra_armazenada <= 8'b0;
            shift_register <= 8'b0;
            buscando <= 1'b0;
            encontrado <= 1'b0;
        end
        else begin
            
            //Próximo estado
            // Armazena nova palavra quando setar_palavra está ativo
            if (setar_palavra) begin
                palavra_armazenada <= palavra;
                encontrado <= 1'b0;  // Reseta a flag de encontrado quando muda a palavra
            end
            
            // Lógica de busca
            if (start) begin
                shift_register <= 8'b0;
                buscando <= 1'b1;
                encontrado <= 1'b0;
            end
            else if (buscando && !encontrado) begin
                // Desloca o novo bit para o registrador
                shift_register <= {shift_register[6:0], bit_in};
            end
            
            // Saída
            if (buscando && (shift_register == palavra_armazenada)) begin
                encontrado <= 1'b1;
            end
        end
    end

endmodule