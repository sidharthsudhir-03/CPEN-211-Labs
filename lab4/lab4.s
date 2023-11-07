//ADDRESS_MAP_ARM.S FILE
/* Memory */
        .equ  DDR_BASE,             0x00000000
        .equ  DDR_END,              0x3FFFFFFF
        .equ  A9_ONCHIP_BASE,       0xFFFF0000
        .equ  A9_ONCHIP_END,        0xFFFFFFFF
        .equ  SDRAM_BASE,           0xC0000000
        .equ  SDRAM_END,            0xC3FFFFFF
        .equ  FPGA_ONCHIP_BASE,     0xC8000000
        .equ  FPGA_ONCHIP_END,      0xC803FFFF
        .equ  FPGA_CHAR_BASE,       0xC9000000
        .equ  FPGA_CHAR_END,        0xC9001FFF

/* Cyclone V FPGA devices */
        .equ  LEDR_BASE,             0xFF200000
        .equ  HEX3_HEX0_BASE,        0xFF200020
        .equ  HEX5_HEX4_BASE,        0xFF200030
        .equ  SW_BASE,               0xFF200040
        .equ  KEY_BASE,              0xFF200050
        .equ  JP1_BASE,              0xFF200060
        .equ  JP2_BASE,              0xFF200070
        .equ  PS2_BASE,              0xFF200100
        .equ  PS2_DUAL_BASE,         0xFF200108
        .equ  JTAG_UART_BASE,        0xFF201000
        .equ  JTAG_UART_2_BASE,      0xFF201008
        .equ  IrDA_BASE,             0xFF201020
        .equ  TIMER_BASE,            0xFF202000
        .equ  TIMER_2_BASE,          0xFF202020
        .equ  AV_CONFIG_BASE,        0xFF203000
        .equ  PIXEL_BUF_CTRL_BASE,   0xFF203020
        .equ  CHAR_BUF_CTRL_BASE,    0xFF203030
        .equ  AUDIO_BASE,            0xFF203040
        .equ  VIDEO_IN_BASE,         0xFF203060
        .equ  ADC_BASE,              0xFF204000

/* Cyclone V HPS devices */
        .equ   HPS_GPIO1_BASE,       0xFF709000
        .equ   I2C0_BASE,            0xFFC04000
        .equ   I2C1_BASE,            0xFFC05000
        .equ   I2C2_BASE,            0xFFC06000
        .equ   I2C3_BASE,            0xFFC07000
        .equ   HPS_TIMER0_BASE,      0xFFC08000
        .equ   HPS_TIMER1_BASE,      0xFFC09000
        .equ   HPS_TIMER2_BASE,      0xFFD00000
        .equ   HPS_TIMER3_BASE,      0xFFD01000
        .equ   FPGA_BRIDGE,          0xFFD0501C

/* ARM A9 MPCORE devices */
        .equ   PERIPH_BASE,          0xFFFEC000   /* base address of peripheral devices */
        .equ   MPCORE_PRIV_TIMER,    0xFFFEC600   /* PERIPH_BASE + 0x0600 */

        /* Interrupt controller (GIC) CPU interface(s) */
        .equ   MPCORE_GIC_CPUIF,     0xFFFEC100   /* PERIPH_BASE + 0x100 */
        .equ   ICCICR,               0x00         /* CPU interface control register */
        .equ   ICCPMR,               0x04         /* interrupt priority mask register */
        .equ   ICCIAR,               0x0C         /* interrupt acknowledge register */
        .equ   ICCEOIR,              0x10         /* end of interrupt register */
        /* Interrupt controller (GIC) distributor interface(s) */
        .equ   MPCORE_GIC_DIST,      0xFFFED000   /* PERIPH_BASE + 0x1000 */
        .equ   ICDDCR,               0x00         /* distributor control register */
        .equ   ICDISER,              0x100        /* interrupt set-enable registers */
        .equ   ICDICER,              0x180        /* interrupt clear-enable registers */
        .equ   ICDIPTR,              0x800        /* interrupt processor targets registers */
        .equ   ICDICFR,              0xC00        /* interrupt configuration registers */


.text
.globl _start
_start:

//MAIN.S FILE
  ldr r4,=SW_BASE
      ldr r5,=KEY_BASE 
      ldr r6,=LEDR_BASE

      // enter the value of "key" on SW0-SW9 here, then press KEY3
wait_key3:
      ldr r7,[r4]         // Read SW0-SW9 into R7

      str r7,[r6]         // Show SW0-SW9 value on LEDR0-LEDR9
      // NOTE: str r7,[r6] is at address 0x00000010. If your 
      // binary search "jumps" to the above instruction this 
      // is likely because an LDR or STR instruction inside your 
      // binary_search function accesses an address that is NOT
      // a multiple of 4.  Using LDR or STR with such an address
      // triggers a ``Data Abort'' exception, which in turn 
      // causes the Cortex-A9 to set the PC to 0x00000010.  
      // Debug tip: Check you write -numData to the right 
      // address in memory.

      ldr r9,[r5]         // Read KEY0-KEY3 into R9 

      ands r9,r9,#8       // Is KEY3 pressed?
      // Value on KEY3 is in bit position 3 of R9.  Why 8?  
      // Remember that 8 is 1000 in binary, where the 1 is in 
      // bit position 3.  Recall that ANDS is AND that sets 
      // the status bits.  
      // 
      // If KEY3 is pressed ands r9,r9,#8 sets Z flag to 0 
      // to indicate R9 is not zero.  
      //
      // If KEY3 is NOT pressed ands r9,r9,#8 sets Z flag to 1 
      // to indicate R9 is zero.

      beq wait_key3       // Branch if Z=1 (KEY3 was NOT pressed)

      // initialize numbers array by copying array "data" to "numbers"
      ldr r0, =data
      ldr r1, =numbers
      mov r2,#100
      add r2,r0, r2, LSL #2
      bl  init_numbers

      ldr r0, =numbers    // 1st argument in R0 = numbers
      mov r1,r7           // 2nd argument in R1 = key
      mov r2,#100         // 3rd argument in R2 = length

      // caller saving registers here because we are not expecting student submissions to respect ARM calling convensions
      push {r4-r12,r14}       // save to stack
      ldr r3,=mystackptr  // 
      str sp,[r3]         // saving value of stack pointer to mystackptr 

      bl  binary_search   // call binary_search    

      // caller restoring registers, starting with stack pointer which might have been clobbered
      ldr r3, =mystackptr
      ldr sp,[r3]
      pop  {r4-r12,r14}

      // setting r4, r5, r6 back to non-garbage values
      ldr r4,=SW_BASE
      ldr r5,=KEY_BASE 
      ldr r6,=LEDR_BASE

      str r0,[r6]         // display result on LEDR0-LEDR9 (check your result!)
     
      // If not single-stepping then select "Actions>Stop" before pressing 
      // KEY0.  Then, check values in numbers array are correct by clicking on
      // the "Memory" tab in the Altera Monitor Program.  You can set the number
      // format of memory by right-clicking on the background, selecting "Number
      // format" then "Decimal".  Repeat and in the last step select "Signed 
      // representation".  If endIndex was 99, you should see something like 
      // Figure 6 in the Lab 9 handout.

wait_key0:                
      ldr  r1,[r5]        // read KEY0-KEY3
      ands r1,r1,#1       // check if KEY0 pressed
      beq  wait_key0      // wait for KEY0 to be pressed

      b wait_key3         // go back and try another search

// "init_numbers" copies array pointed at by r0 into array pointed at by r1
// The following code is NOT recursive.  It contains a loop.
init_numbers:
      ldr r3, [r0], #4
      str r3, [r1], #4
      cmp r0, r2
      blt init_numbers
      mov pc, lr

mystackptr:
.word 0

data:
.word 28
.word 37
.word 44
.word 60
.word 85
.word 99
.word 121
.word 127
.word 129
.word 138

.word 143
.word 155
.word 162
.word 164
.word 175
.word 179
.word 205
.word 212
.word 217
.word 231

.word 235
.word 238
.word 242
.word 248
.word 250
.word 258
.word 283
.word 286
.word 305
.word 311

.word 316
.word 322
.word 326
.word 351
.word 355
.word 364
.word 366
.word 376
.word 391
.word 398

.word 408
.word 410
.word 415
.word 418
.word 425
.word 437
.word 441
.word 452
.word 474
.word 488

.word 506
.word 507
.word 526
.word 532
.word 534
.word 547
.word 548
.word 583
.word 585
.word 595

.word 603
.word 621
.word 640
.word 661
.word 666
.word 690
.word 692
.word 713
.word 719
.word 750

.word 755
.word 768
.word 775
.word 776
.word 784
.word 785
.word 791
.word 797
.word 798
.word 804

.word 828
.word 842
.word 846
.word 858
.word 884
.word 887
.word 890
.word 893
.word 908
.word 936

.word 939
.word 953
.word 960
.word 970
.word 978
.word 979
.word 981
.word 990
.word 1002
.word 1007

numbers:
.fill 100,4,0xDEADBEEF   // set 100 locations to easily recognizable "bad" value



//LAB4.S FILE (BINARYSEARCH)
binary_search:
  
  //r0 is number
  // r1 is key
  // r2 is length 
  // r3 is startIndex
  // r4 is endIndex
  // r5 middleIndex
  // r6 keyIndex
  // r7 NumIters
  // r8 numbers[middleIndex]
  //Unused variables 
  
  MOV R3, #0 //startIndex = 0
  SUB R4, R2, #1 //endIndex = length - 1
  MOV R5, R4, LSR #1 // middleIndex = endIndex/2
  MOV R6, #1
  NEG R6, R6 // keyIndex = -1
  MOV R7, #1 //NumIters = 1
  MOV R9, #1
  NEG R9, R9 //temp = -1
  B while_loop
  
while_loop:

  CMP R6, R9
  BNE return_keyIndex 
  CMP R3,R4
  BGT return_keyIndex
  LDR R8, [R0, R5, LSL#2]
  CMP R8, R1
  BEQ else_if_one
  CMP R8, R1
  BGT else_if_two
  ADD R3, R5, #1
  B remaining_while_loop
  
remaining_while_loop:

  MOV R11, R7
  NEG R11, R11
  STR R11, [R0, R5, LSL #2]
  SUB R10, R4, R3
  MOV R10, R10, LSR #1
  ADD R5, R3, R10
  ADD R7, R7, #1
  B while_loop
  
else_if_one:

  MOV R6, R5
  B remaining_while_loop
  
else_if_two:

  SUB R4, R5, #1
  B remaining_while_loop
  
  
return_keyIndex:
  MOV R0, R6
  MOV PC,LR
  
