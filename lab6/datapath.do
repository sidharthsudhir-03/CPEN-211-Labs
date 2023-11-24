onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/clk
add wave -noupdate /datapath_tb/mdata
add wave -noupdate /datapath_tb/sximm8
add wave -noupdate /datapath_tb/sximm5
add wave -noupdate /datapath_tb/PC
add wave -noupdate /datapath_tb/write
add wave -noupdate /datapath_tb/loada
add wave -noupdate /datapath_tb/loadb
add wave -noupdate /datapath_tb/asel
add wave -noupdate /datapath_tb/bsel
add wave -noupdate /datapath_tb/loadc
add wave -noupdate /datapath_tb/loads
add wave -noupdate /datapath_tb/vsel
add wave -noupdate /datapath_tb/readnum
add wave -noupdate /datapath_tb/writenum
add wave -noupdate /datapath_tb/shift
add wave -noupdate /datapath_tb/ALUop
add wave -noupdate /datapath_tb/out
add wave -noupdate /datapath_tb/N
add wave -noupdate /datapath_tb/V
add wave -noupdate /datapath_tb/Z
add wave -noupdate /datapath_tb/err
add wave -noupdate /datapath_tb/R0
add wave -noupdate /datapath_tb/R1
add wave -noupdate /datapath_tb/R2
add wave -noupdate /datapath_tb/R3
add wave -noupdate /datapath_tb/R4
add wave -noupdate /datapath_tb/R5
add wave -noupdate /datapath_tb/R6
add wave -noupdate /datapath_tb/R7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {200 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
