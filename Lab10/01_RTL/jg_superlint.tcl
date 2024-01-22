clear -all

check_superlint -init

set_superlint_engine_mode_fsm_deadlock_livelock {M Tri}
set_superlint_deadcode_full_case_filter true
set_superlint_fsm_automatic_assumptions_type coi
set_superlint_fsm_ignore_self_transitions true
set_superlint_prove_parallel_tasks on
#set_proofgrid_per_engine_max_local_jobs 
set_proofgrid_max_local_jobs 20

#config_rtlds -rule -disable -domain all
#config_rtlds -rule -enable  -domain {LINT AUTO_FORMAL}
#config_rtlds -rule  -disable -tag {CAS_IS_DFRC FSM_NO_MTRN FSM_NO_TRRN SIG_IS_DLCK SIG_NO_TGFL SIG_NO_TGRS SIG_NO_TGST} 
#config_rtlds -rule -enable -category {AUTO_FORMAL_OVERFLOW AUTO_FORMAL_DEAD_CODE AUTO_FORMAL_FSM_DEADLOCK_LIVELOCK}
check_superlint -configure -load_rule_file ~/Lab10/Exercise/01_RTL/lint_rule.def

analyze -sv -f design.f
elaborate -top BEV

clock clk
reset !inf.rst_n

check_superlint -extract 
check_superlint -prove -time_limit 2m 
