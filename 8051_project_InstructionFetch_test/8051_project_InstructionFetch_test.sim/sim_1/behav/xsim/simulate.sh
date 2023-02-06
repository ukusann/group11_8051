#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Mon Feb 06 17:30:24 WET 2023
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_tob_1_behav -key {Behavioral:sim_1:Functional:tb_tob_1} -tclbatch tb_tob_1.tcl -view /home/matheus/group11_8051/8051_project_InstructionFetch_test/tb_tob_1_behav.wcfg -log simulate.log"
xsim tb_tob_1_behav -key {Behavioral:sim_1:Functional:tb_tob_1} -tclbatch tb_tob_1.tcl -view /home/matheus/group11_8051/8051_project_InstructionFetch_test/tb_tob_1_behav.wcfg -log simulate.log

