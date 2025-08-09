package fifo_test_pack;
import fifo_env_pack::*;
import fifo_config_pack::*;
import sequence_pack::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_test extends uvm_test;
`uvm_component_utils(fifo_test)
virtual fifo_if fifo_vif;
fifo_config fifo_config_obj_test;
sequence_class_reset reset_seq;
sequence_class_write_and_read writeandread_seq;
sequence_class_write_only write_seq;
sequence_class_read_only read_seq;
sequence_class_random random_;
fifo_env env;
    function new(string name= "fifo_test",uvm_component parent =null);
    super.new(name,parent);
    endfunction //new()
    function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env=fifo_env::type_id::create("env",this);
    fifo_config_obj_test=fifo_config::type_id::create("fifo_config_obj_test");
    writeandread_seq=sequence_class_write_and_read::type_id::create("writeandread_seq",this);
    reset_seq=sequence_class_reset::type_id::create("reset_seq",this);
    write_seq=sequence_class_write_only::type_id::create("write_seq",this);
    read_seq=sequence_class_read_only::type_id::create("read_seq",this);
random_=sequence_class_random::type_id::create("random_",this);

    if (!uvm_config_db #(virtual fifo_if)::get(this,"","fifo",fifo_config_obj_test.fifo_vif))
    `uvm_fatal("build_phase","TEST - unable to get the virtual interface from the data base");
    uvm_config_db #(fifo_config)::set(this,"*","KEY",fifo_config_obj_test);
    endfunction
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","reset_asserted",UVM_MEDIUM)
    reset_seq.start(env.agt.sqr);
     `uvm_info("run_phase","reset_deasserted",UVM_MEDIUM)
     `uvm_info("run_phase","random_asserted",UVM_MEDIUM)
     random_.start(env.agt.sqr);
     `uvm_info("run_phase","random_deasserted",UVM_MEDIUM)
    `uvm_info("run_phase","inside the write test",UVM_MEDIUM)
    write_seq.start(env.agt.sqr);
    `uvm_info("run_phase","finished the write test",UVM_MEDIUM)
    `uvm_info("run_phase","inside the write and read test",UVM_MEDIUM)
    writeandread_seq.start(env.agt.sqr);
    `uvm_info("run_phase","finished the write and read test",UVM_MEDIUM)
    `uvm_info("run_phase","inside the read test",UVM_MEDIUM)
    read_seq.start(env.agt.sqr);
    phase.drop_objection(this);
`uvm_info("run_phase","finished the read test",UVM_MEDIUM)
    endtask
endclass //fifo_test extends superClass
    
endpackage