module maquina_maluca (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    output wire  [3:0] state
);

    localparam IDLE                = 4'd0; //alterado 4'd1
    localparam LIGAR_MAQUINA       = 4'd1;
    localparam VERIFICAR_AGUA      = 4'd2;
    localparam ENCHER_RESERVATORIO = 4'd3;
    localparam MOER_CAFE           = 4'd4;
    localparam COLOCAR_NO_FILTRO   = 4'd5;
    localparam PASSAR_AGITADOR     = 4'd6;
    localparam TAMPEAR             = 4'd7;
    localparam REALIZAR_EXTRACAO   = 4'd8; //alterado ordem de todos até aqui

    reg [3:0] current_state, next_state;
    reg agua_enchida;

    assign state = current_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            agua_enchida  <= 1'b0; //alterado 1'b1
        end else begin
            current_state <= next_state;
            if (current_state == ENCHER_RESERVATORIO)
                agua_enchida <= 1'b1; //alterado 1'b0
        end
    end

    always @(*) begin
        case (current_state)
            IDLE:
                next_state = start ? LIGAR_MAQUINA : IDLE;

            LIGAR_MAQUINA:
                next_state = VERIFICAR_AGUA; //alterado moer cafe

            VERIFICAR_AGUA:
                next_state = (agua_enchida ? MOER_CAFE : ENCHER_RESERVATORIO);//dividido entre verificar moer e encher agua

            ENCHER_RESERVATORIO:
                next_state = VERIFICAR_AGUA; //alterado colocar no filtro

            MOER_CAFE:
                next_state = COLOCAR_NO_FILTRO; //alterado moer cafe

            COLOCAR_NO_FILTRO:
                next_state = PASSAR_AGITADOR; //alterado realizar extração

            PASSAR_AGITADOR:
                next_state = TAMPEAR; // alterado idle

            TAMPEAR:
                next_state = REALIZAR_EXTRACAO; //alterado verificar agua

            REALIZAR_EXTRACAO:
                next_state = IDLE; //alterado realizar extração

            default:
                next_state = IDLE; // alterado moer
        endcase
    end

endmodule