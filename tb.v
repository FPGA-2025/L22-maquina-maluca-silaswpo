`timescale 1ns/1ps

module tb();

reg clk;
reg rst_n;
reg start;
wire [3:0] state;

maquina_maluca dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .state(state)
);

parameter T = 10;
integer ciclo;

always #(T/2) clk = ~clk;

initial begin
    $dumpfile("saida_maquina.vcd");
    $dumpvars(0, tb);
end

initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    ciclo = 0;
    #15;

    $display("== Teste 1: Ciclo completo com reservatório vazio ==");
    rst_n = 1;
    #T;
    start = 1;
    #T;
    start = 0;

    // Aguardar estados: IDLE → LIGAR → VERIFICAR → ENCHER → VERIFICAR → MOER → FILTRO...
    repeat(10) begin
        #T;
        $display("T1: ciclo=%0d | state=%0d", ciclo, state);
        ciclo = ciclo + 1;
    end

    $display("== Teste 2: Novo ciclo, agora com água pronta ==");
    start = 1;
    #T;
    start = 0;
    repeat(9) begin
        #T;
        $display("T2: ciclo=%0d | state=%0d", ciclo, state);
        ciclo = ciclo + 1;
    end

    $display("== Teste 3: Reset durante operação ==");
    start = 1;
    #T;
    rst_n = 0;
    #T;
    rst_n = 1;
    repeat(3) begin
        #T;
        $display("T3: ciclo=%0d | state=%0d", ciclo, state);
        ciclo = ciclo + 1;
    end

    $display("== Teste 4: Nunca inicia (start = 0) ==");
    start = 0;
    repeat(5) begin
        #T;
        $display("T4: ciclo=%0d | state=%0d", ciclo, state);
        ciclo = ciclo + 1;
    end

    $display("Testbench finalizado.");
    $finish;
end

endmodule
