onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/per_frame_vsync
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/per_frame_href
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/per_frame_clken
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/per_img_Bit
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_line_up
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_line_down
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_pixel_up
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_pixel_down
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/x_cnt
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/y_cnt
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_num1
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_y1
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_num2
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/max_y2
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/u_projection_ram/data
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/u_projection_ram/rdaddress
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/u_projection_ram/wraddress
add wave -noupdate -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/u_projection_ram/wren
add wave -noupdate -format Analog-Step -height 74 -max 147.0 -radix unsigned /bmp_sim_VIP_tb/u_VIP_horizon_projection/u_projection_ram/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29983338341 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 494
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
configure wave -timelineunits ns
update
WaveRestoreZoom {29977870123 ps} {30001164731 ps}
