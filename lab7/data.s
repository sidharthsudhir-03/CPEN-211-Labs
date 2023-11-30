    MOV R0, SW_BASE           ; R0 = 21 (Address of switch inputs)
    MOV R1, LEDR_BASE         ; R1 = 22 (Address of LED outputs)
    LDR R0, [R0]              ; R0 = 0x0140
    LDR R1, [R1]              ; R1 = 0X0100
    MOV R2, #19               ; R2 = 19
    MVN R3, R2                ; R3 = ~19 = 0xFFEC (16-bit two's complement)
    CMP R3, R2                ; Compare 19 with 0xFFE6; sets Negative flag (N) 
    ADD R4, R2, R2, LSL #1    ; R4 = 19 + (19 << 1) = 19 + 38 = 57 
    STR R4, [R1]              ; Stores 57 at LED address 
    LDR R5, [R0]              ; R5 = SW_INPUT 
    STR R5, [R1]              ; Stores SW_INPUT at LED address 
    ADD R3, R4, R2            ; R3 = 57 + 19 = 76 
    STR R3, [R1]              ; Stores 76 at LED address
    LDR R4, [R0]              ; R4 = SW_INPUT 
    CMP R4, R3                ; Compare SW_INPUT with 76
    ADD R2, R4, R3, LSR #1    ; R2 = SW_INPUT + (76 >> 1) = SW_INPUT + 38
    STR R2, [R1]          ; Stores (SW_INPUT + 38) at LED
    MOV R6, R5, LSR #1        ; R6 = (SW_INPUT + 38) >> 1
    STR R6, [R1]
    HALT                      ; Halts execution
    SW_BASE: 
    .word 0x0140     ; Memory address for switch inputs
    LEDR_BASE:
    .word 0x0100   ; Memory address for LED outputs
