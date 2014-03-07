
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name LEDgrid -dir "C:/Xilinx/Projects/JR LAB/LAB 4/LEDgrid/planAhead_run_1" -part xc3s100ecp132-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Xilinx/Projects/JR LAB/LAB 4/LEDgrid/ProjectMain.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Xilinx/Projects/JR LAB/LAB 4/LEDgrid} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ProjectMain.ucf" [current_fileset -constrset]
add_files [list {ProjectMain.ucf}] -fileset [get_property constrset [current_run]]
link_design
