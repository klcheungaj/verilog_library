// Generator : SpinalHDL v1.6.4    git head : 598c18959149eb18e5eee5b0aa3eef01ecaa41a1
// Component : Axi4_2x512_1x512

`timescale 1ns/1ps 

module Axi4_2x512_1x512 (
  input               io_axis_0_aw_valid,
  output              io_axis_0_aw_ready,
  input      [31:0]   io_axis_0_aw_payload_addr,
  input      [3:0]    io_axis_0_aw_payload_id,
  input      [7:0]    io_axis_0_aw_payload_len,
  input      [2:0]    io_axis_0_aw_payload_size,
  input      [1:0]    io_axis_0_aw_payload_burst,
  input      [0:0]    io_axis_0_aw_payload_lock,
  input      [3:0]    io_axis_0_aw_payload_cache,
  input      [3:0]    io_axis_0_aw_payload_qos,
  input               io_axis_0_w_valid,
  output              io_axis_0_w_ready,
  input      [511:0]  io_axis_0_w_payload_data,
  input      [63:0]   io_axis_0_w_payload_strb,
  input               io_axis_0_w_payload_last,
  output              io_axis_0_b_valid,
  input               io_axis_0_b_ready,
  output     [3:0]    io_axis_0_b_payload_id,
  output     [1:0]    io_axis_0_b_payload_resp,
  input               io_axis_0_ar_valid,
  output              io_axis_0_ar_ready,
  input      [31:0]   io_axis_0_ar_payload_addr,
  input      [3:0]    io_axis_0_ar_payload_id,
  input      [7:0]    io_axis_0_ar_payload_len,
  input      [2:0]    io_axis_0_ar_payload_size,
  input      [1:0]    io_axis_0_ar_payload_burst,
  input      [0:0]    io_axis_0_ar_payload_lock,
  input      [3:0]    io_axis_0_ar_payload_cache,
  input      [3:0]    io_axis_0_ar_payload_qos,
  output              io_axis_0_r_valid,
  input               io_axis_0_r_ready,
  output     [511:0]  io_axis_0_r_payload_data,
  output     [3:0]    io_axis_0_r_payload_id,
  output     [1:0]    io_axis_0_r_payload_resp,
  output              io_axis_0_r_payload_last,
  input               io_axis_1_aw_valid,
  output              io_axis_1_aw_ready,
  input      [31:0]   io_axis_1_aw_payload_addr,
  input      [3:0]    io_axis_1_aw_payload_id,
  input      [7:0]    io_axis_1_aw_payload_len,
  input      [2:0]    io_axis_1_aw_payload_size,
  input      [1:0]    io_axis_1_aw_payload_burst,
  input      [0:0]    io_axis_1_aw_payload_lock,
  input      [3:0]    io_axis_1_aw_payload_cache,
  input      [3:0]    io_axis_1_aw_payload_qos,
  input               io_axis_1_w_valid,
  output              io_axis_1_w_ready,
  input      [511:0]  io_axis_1_w_payload_data,
  input      [63:0]   io_axis_1_w_payload_strb,
  input               io_axis_1_w_payload_last,
  output              io_axis_1_b_valid,
  input               io_axis_1_b_ready,
  output     [3:0]    io_axis_1_b_payload_id,
  output     [1:0]    io_axis_1_b_payload_resp,
  input               io_axis_1_ar_valid,
  output              io_axis_1_ar_ready,
  input      [31:0]   io_axis_1_ar_payload_addr,
  input      [3:0]    io_axis_1_ar_payload_id,
  input      [7:0]    io_axis_1_ar_payload_len,
  input      [2:0]    io_axis_1_ar_payload_size,
  input      [1:0]    io_axis_1_ar_payload_burst,
  input      [0:0]    io_axis_1_ar_payload_lock,
  input      [3:0]    io_axis_1_ar_payload_cache,
  input      [3:0]    io_axis_1_ar_payload_qos,
  output              io_axis_1_r_valid,
  input               io_axis_1_r_ready,
  output     [511:0]  io_axis_1_r_payload_data,
  output     [3:0]    io_axis_1_r_payload_id,
  output     [1:0]    io_axis_1_r_payload_resp,
  output              io_axis_1_r_payload_last,
  output              io_axim_aw_valid,
  input               io_axim_aw_ready,
  output     [31:0]   io_axim_aw_payload_addr,
  output     [7:0]    io_axim_aw_payload_id,
  output     [7:0]    io_axim_aw_payload_len,
  output     [2:0]    io_axim_aw_payload_size,
  output     [1:0]    io_axim_aw_payload_burst,
  output     [0:0]    io_axim_aw_payload_lock,
  output     [3:0]    io_axim_aw_payload_cache,
  output     [3:0]    io_axim_aw_payload_qos,
  output              io_axim_w_valid,
  input               io_axim_w_ready,
  output     [511:0]  io_axim_w_payload_data,
  output     [63:0]   io_axim_w_payload_strb,
  output              io_axim_w_payload_last,
  input               io_axim_b_valid,
  output              io_axim_b_ready,
  input      [7:0]    io_axim_b_payload_id,
  input      [1:0]    io_axim_b_payload_resp,
  output              io_axim_ar_valid,
  input               io_axim_ar_ready,
  output     [31:0]   io_axim_ar_payload_addr,
  output     [7:0]    io_axim_ar_payload_id,
  output     [7:0]    io_axim_ar_payload_len,
  output     [2:0]    io_axim_ar_payload_size,
  output     [1:0]    io_axim_ar_payload_burst,
  output     [0:0]    io_axim_ar_payload_lock,
  output     [3:0]    io_axim_ar_payload_cache,
  output     [3:0]    io_axim_ar_payload_qos,
  input               io_axim_r_valid,
  output              io_axim_r_ready,
  input      [511:0]  io_axim_r_payload_data,
  input      [7:0]    io_axim_r_payload_id,
  input      [1:0]    io_axim_r_payload_resp,
  input               io_axim_r_payload_last,
  input               clk,
  input               reset
);

  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_r_payload_id;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_b_payload_id;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_r_payload_id;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_b_payload_id;
  wire       [6:0]    io_axim_readOnly_arbiter_io_inputs_0_ar_payload_id;
  wire       [6:0]    io_axim_readOnly_arbiter_io_inputs_1_ar_payload_id;
  wire       [6:0]    io_axim_writeOnly_arbiter_io_inputs_0_aw_payload_id;
  wire       [6:0]    io_axim_writeOnly_arbiter_io_inputs_1_aw_payload_id;
  wire                io_axis_0_readOnly_decoder_io_input_ar_ready;
  wire                io_axis_0_readOnly_decoder_io_input_r_valid;
  wire       [511:0]  io_axis_0_readOnly_decoder_io_input_r_payload_data;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_input_r_payload_id;
  wire       [1:0]    io_axis_0_readOnly_decoder_io_input_r_payload_resp;
  wire                io_axis_0_readOnly_decoder_io_input_r_payload_last;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_qos;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_r_ready;
  wire                io_axis_0_writeOnly_decoder_io_input_aw_ready;
  wire                io_axis_0_writeOnly_decoder_io_input_w_ready;
  wire                io_axis_0_writeOnly_decoder_io_input_b_valid;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_input_b_payload_id;
  wire       [1:0]    io_axis_0_writeOnly_decoder_io_input_b_payload_resp;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [31:0]   io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_qos;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [511:0]  io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [63:0]   io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_b_ready;
  wire                io_axis_1_readOnly_decoder_io_input_ar_ready;
  wire                io_axis_1_readOnly_decoder_io_input_r_valid;
  wire       [511:0]  io_axis_1_readOnly_decoder_io_input_r_payload_data;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_input_r_payload_id;
  wire       [1:0]    io_axis_1_readOnly_decoder_io_input_r_payload_resp;
  wire                io_axis_1_readOnly_decoder_io_input_r_payload_last;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_qos;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_r_ready;
  wire                io_axis_1_writeOnly_decoder_io_input_aw_ready;
  wire                io_axis_1_writeOnly_decoder_io_input_w_ready;
  wire                io_axis_1_writeOnly_decoder_io_input_b_valid;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_input_b_payload_id;
  wire       [1:0]    io_axis_1_writeOnly_decoder_io_input_b_payload_resp;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [31:0]   io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_qos;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [511:0]  io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [63:0]   io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_b_ready;
  wire                io_axim_readOnly_arbiter_io_inputs_0_ar_ready;
  wire                io_axim_readOnly_arbiter_io_inputs_0_r_valid;
  wire       [511:0]  io_axim_readOnly_arbiter_io_inputs_0_r_payload_data;
  wire       [6:0]    io_axim_readOnly_arbiter_io_inputs_0_r_payload_id;
  wire       [1:0]    io_axim_readOnly_arbiter_io_inputs_0_r_payload_resp;
  wire                io_axim_readOnly_arbiter_io_inputs_0_r_payload_last;
  wire                io_axim_readOnly_arbiter_io_inputs_1_ar_ready;
  wire                io_axim_readOnly_arbiter_io_inputs_1_r_valid;
  wire       [511:0]  io_axim_readOnly_arbiter_io_inputs_1_r_payload_data;
  wire       [6:0]    io_axim_readOnly_arbiter_io_inputs_1_r_payload_id;
  wire       [1:0]    io_axim_readOnly_arbiter_io_inputs_1_r_payload_resp;
  wire                io_axim_readOnly_arbiter_io_inputs_1_r_payload_last;
  wire                io_axim_readOnly_arbiter_io_output_ar_valid;
  wire       [31:0]   io_axim_readOnly_arbiter_io_output_ar_payload_addr;
  wire       [7:0]    io_axim_readOnly_arbiter_io_output_ar_payload_id;
  wire       [7:0]    io_axim_readOnly_arbiter_io_output_ar_payload_len;
  wire       [2:0]    io_axim_readOnly_arbiter_io_output_ar_payload_size;
  wire       [1:0]    io_axim_readOnly_arbiter_io_output_ar_payload_burst;
  wire       [0:0]    io_axim_readOnly_arbiter_io_output_ar_payload_lock;
  wire       [3:0]    io_axim_readOnly_arbiter_io_output_ar_payload_cache;
  wire       [3:0]    io_axim_readOnly_arbiter_io_output_ar_payload_qos;
  wire                io_axim_readOnly_arbiter_io_output_r_ready;
  wire                io_axim_writeOnly_arbiter_io_inputs_0_aw_ready;
  wire                io_axim_writeOnly_arbiter_io_inputs_0_w_ready;
  wire                io_axim_writeOnly_arbiter_io_inputs_0_b_valid;
  wire       [6:0]    io_axim_writeOnly_arbiter_io_inputs_0_b_payload_id;
  wire       [1:0]    io_axim_writeOnly_arbiter_io_inputs_0_b_payload_resp;
  wire                io_axim_writeOnly_arbiter_io_inputs_1_aw_ready;
  wire                io_axim_writeOnly_arbiter_io_inputs_1_w_ready;
  wire                io_axim_writeOnly_arbiter_io_inputs_1_b_valid;
  wire       [6:0]    io_axim_writeOnly_arbiter_io_inputs_1_b_payload_id;
  wire       [1:0]    io_axim_writeOnly_arbiter_io_inputs_1_b_payload_resp;
  wire                io_axim_writeOnly_arbiter_io_output_aw_valid;
  wire       [31:0]   io_axim_writeOnly_arbiter_io_output_aw_payload_addr;
  wire       [7:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_id;
  wire       [7:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_len;
  wire       [2:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_size;
  wire       [1:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_burst;
  wire       [0:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_lock;
  wire       [3:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_cache;
  wire       [3:0]    io_axim_writeOnly_arbiter_io_output_aw_payload_qos;
  wire                io_axim_writeOnly_arbiter_io_output_w_valid;
  wire       [511:0]  io_axim_writeOnly_arbiter_io_output_w_payload_data;
  wire       [63:0]   io_axim_writeOnly_arbiter_io_output_w_payload_strb;
  wire                io_axim_writeOnly_arbiter_io_output_w_payload_last;
  wire                io_axim_writeOnly_arbiter_io_output_b_ready;
  wire                io_axim_readOnly_ar_valid;
  wire                io_axim_readOnly_ar_ready;
  wire       [31:0]   io_axim_readOnly_ar_payload_addr;
  wire       [7:0]    io_axim_readOnly_ar_payload_id;
  wire       [7:0]    io_axim_readOnly_ar_payload_len;
  wire       [2:0]    io_axim_readOnly_ar_payload_size;
  wire       [1:0]    io_axim_readOnly_ar_payload_burst;
  wire       [0:0]    io_axim_readOnly_ar_payload_lock;
  wire       [3:0]    io_axim_readOnly_ar_payload_cache;
  wire       [3:0]    io_axim_readOnly_ar_payload_qos;
  wire                io_axim_readOnly_r_valid;
  wire                io_axim_readOnly_r_ready;
  wire       [511:0]  io_axim_readOnly_r_payload_data;
  wire       [7:0]    io_axim_readOnly_r_payload_id;
  wire       [1:0]    io_axim_readOnly_r_payload_resp;
  wire                io_axim_readOnly_r_payload_last;
  wire                io_axim_writeOnly_aw_valid;
  wire                io_axim_writeOnly_aw_ready;
  wire       [31:0]   io_axim_writeOnly_aw_payload_addr;
  wire       [7:0]    io_axim_writeOnly_aw_payload_id;
  wire       [7:0]    io_axim_writeOnly_aw_payload_len;
  wire       [2:0]    io_axim_writeOnly_aw_payload_size;
  wire       [1:0]    io_axim_writeOnly_aw_payload_burst;
  wire       [0:0]    io_axim_writeOnly_aw_payload_lock;
  wire       [3:0]    io_axim_writeOnly_aw_payload_cache;
  wire       [3:0]    io_axim_writeOnly_aw_payload_qos;
  wire                io_axim_writeOnly_w_valid;
  wire                io_axim_writeOnly_w_ready;
  wire       [511:0]  io_axim_writeOnly_w_payload_data;
  wire       [63:0]   io_axim_writeOnly_w_payload_strb;
  wire                io_axim_writeOnly_w_payload_last;
  wire                io_axim_writeOnly_b_valid;
  wire                io_axim_writeOnly_b_ready;
  wire       [7:0]    io_axim_writeOnly_b_payload_id;
  wire       [1:0]    io_axim_writeOnly_b_payload_resp;
  wire                io_axis_0_readOnly_ar_valid;
  wire                io_axis_0_readOnly_ar_ready;
  wire       [31:0]   io_axis_0_readOnly_ar_payload_addr;
  wire       [3:0]    io_axis_0_readOnly_ar_payload_id;
  wire       [7:0]    io_axis_0_readOnly_ar_payload_len;
  wire       [2:0]    io_axis_0_readOnly_ar_payload_size;
  wire       [1:0]    io_axis_0_readOnly_ar_payload_burst;
  wire       [0:0]    io_axis_0_readOnly_ar_payload_lock;
  wire       [3:0]    io_axis_0_readOnly_ar_payload_cache;
  wire       [3:0]    io_axis_0_readOnly_ar_payload_qos;
  wire                io_axis_0_readOnly_r_valid;
  wire                io_axis_0_readOnly_r_ready;
  wire       [511:0]  io_axis_0_readOnly_r_payload_data;
  wire       [3:0]    io_axis_0_readOnly_r_payload_id;
  wire       [1:0]    io_axis_0_readOnly_r_payload_resp;
  wire                io_axis_0_readOnly_r_payload_last;
  wire                io_axis_0_writeOnly_aw_valid;
  wire                io_axis_0_writeOnly_aw_ready;
  wire       [31:0]   io_axis_0_writeOnly_aw_payload_addr;
  wire       [3:0]    io_axis_0_writeOnly_aw_payload_id;
  wire       [7:0]    io_axis_0_writeOnly_aw_payload_len;
  wire       [2:0]    io_axis_0_writeOnly_aw_payload_size;
  wire       [1:0]    io_axis_0_writeOnly_aw_payload_burst;
  wire       [0:0]    io_axis_0_writeOnly_aw_payload_lock;
  wire       [3:0]    io_axis_0_writeOnly_aw_payload_cache;
  wire       [3:0]    io_axis_0_writeOnly_aw_payload_qos;
  wire                io_axis_0_writeOnly_w_valid;
  wire                io_axis_0_writeOnly_w_ready;
  wire       [511:0]  io_axis_0_writeOnly_w_payload_data;
  wire       [63:0]   io_axis_0_writeOnly_w_payload_strb;
  wire                io_axis_0_writeOnly_w_payload_last;
  wire                io_axis_0_writeOnly_b_valid;
  wire                io_axis_0_writeOnly_b_ready;
  wire       [3:0]    io_axis_0_writeOnly_b_payload_id;
  wire       [1:0]    io_axis_0_writeOnly_b_payload_resp;
  wire                io_axis_1_readOnly_ar_valid;
  wire                io_axis_1_readOnly_ar_ready;
  wire       [31:0]   io_axis_1_readOnly_ar_payload_addr;
  wire       [3:0]    io_axis_1_readOnly_ar_payload_id;
  wire       [7:0]    io_axis_1_readOnly_ar_payload_len;
  wire       [2:0]    io_axis_1_readOnly_ar_payload_size;
  wire       [1:0]    io_axis_1_readOnly_ar_payload_burst;
  wire       [0:0]    io_axis_1_readOnly_ar_payload_lock;
  wire       [3:0]    io_axis_1_readOnly_ar_payload_cache;
  wire       [3:0]    io_axis_1_readOnly_ar_payload_qos;
  wire                io_axis_1_readOnly_r_valid;
  wire                io_axis_1_readOnly_r_ready;
  wire       [511:0]  io_axis_1_readOnly_r_payload_data;
  wire       [3:0]    io_axis_1_readOnly_r_payload_id;
  wire       [1:0]    io_axis_1_readOnly_r_payload_resp;
  wire                io_axis_1_readOnly_r_payload_last;
  wire                io_axis_1_writeOnly_aw_valid;
  wire                io_axis_1_writeOnly_aw_ready;
  wire       [31:0]   io_axis_1_writeOnly_aw_payload_addr;
  wire       [3:0]    io_axis_1_writeOnly_aw_payload_id;
  wire       [7:0]    io_axis_1_writeOnly_aw_payload_len;
  wire       [2:0]    io_axis_1_writeOnly_aw_payload_size;
  wire       [1:0]    io_axis_1_writeOnly_aw_payload_burst;
  wire       [0:0]    io_axis_1_writeOnly_aw_payload_lock;
  wire       [3:0]    io_axis_1_writeOnly_aw_payload_cache;
  wire       [3:0]    io_axis_1_writeOnly_aw_payload_qos;
  wire                io_axis_1_writeOnly_w_valid;
  wire                io_axis_1_writeOnly_w_ready;
  wire       [511:0]  io_axis_1_writeOnly_w_payload_data;
  wire       [63:0]   io_axis_1_writeOnly_w_payload_strb;
  wire                io_axis_1_writeOnly_w_payload_last;
  wire                io_axis_1_writeOnly_b_valid;
  wire                io_axis_1_writeOnly_b_ready;
  wire       [3:0]    io_axis_1_writeOnly_b_payload_id;
  wire       [1:0]    io_axis_1_writeOnly_b_payload_resp;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [31:0]   io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [3:0]    io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos;
  reg                 io_axis_0_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [31:0]   io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [3:0]    io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos;
  reg                 io_axis_0_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;
  wire                io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [31:0]   io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [3:0]    io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos;
  reg                 io_axis_1_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [31:0]   io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [3:0]    io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos;
  reg                 io_axis_1_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;
  wire                io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1;

  Axi4ReadOnlyDecoder io_axis_0_readOnly_decoder (
    .io_input_ar_valid                (io_axis_0_readOnly_ar_valid                                    ), //i
    .io_input_ar_ready                (io_axis_0_readOnly_decoder_io_input_ar_ready                   ), //o
    .io_input_ar_payload_addr         (io_axis_0_readOnly_ar_payload_addr[31:0]                       ), //i
    .io_input_ar_payload_id           (io_axis_0_readOnly_ar_payload_id[3:0]                          ), //i
    .io_input_ar_payload_len          (io_axis_0_readOnly_ar_payload_len[7:0]                         ), //i
    .io_input_ar_payload_size         (io_axis_0_readOnly_ar_payload_size[2:0]                        ), //i
    .io_input_ar_payload_burst        (io_axis_0_readOnly_ar_payload_burst[1:0]                       ), //i
    .io_input_ar_payload_lock         (io_axis_0_readOnly_ar_payload_lock                             ), //i
    .io_input_ar_payload_cache        (io_axis_0_readOnly_ar_payload_cache[3:0]                       ), //i
    .io_input_ar_payload_qos          (io_axis_0_readOnly_ar_payload_qos[3:0]                         ), //i
    .io_input_r_valid                 (io_axis_0_readOnly_decoder_io_input_r_valid                    ), //o
    .io_input_r_ready                 (io_axis_0_readOnly_r_ready                                     ), //i
    .io_input_r_payload_data          (io_axis_0_readOnly_decoder_io_input_r_payload_data[511:0]      ), //o
    .io_input_r_payload_id            (io_axis_0_readOnly_decoder_io_input_r_payload_id[3:0]          ), //o
    .io_input_r_payload_resp          (io_axis_0_readOnly_decoder_io_input_r_payload_resp[1:0]        ), //o
    .io_input_r_payload_last          (io_axis_0_readOnly_decoder_io_input_r_payload_last             ), //o
    .io_outputs_0_ar_valid            (io_axis_0_readOnly_decoder_io_outputs_0_ar_valid               ), //o
    .io_outputs_0_ar_ready            (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1    ), //i
    .io_outputs_0_ar_payload_addr     (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_addr[31:0]  ), //o
    .io_outputs_0_ar_payload_id       (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_id[3:0]     ), //o
    .io_outputs_0_ar_payload_len      (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]    ), //o
    .io_outputs_0_ar_payload_size     (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]   ), //o
    .io_outputs_0_ar_payload_burst    (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]  ), //o
    .io_outputs_0_ar_payload_lock     (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_lock        ), //o
    .io_outputs_0_ar_payload_cache    (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]  ), //o
    .io_outputs_0_ar_payload_qos      (io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_qos[3:0]    ), //o
    .io_outputs_0_r_valid             (io_axim_readOnly_arbiter_io_inputs_0_r_valid                   ), //i
    .io_outputs_0_r_ready             (io_axis_0_readOnly_decoder_io_outputs_0_r_ready                ), //o
    .io_outputs_0_r_payload_data      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_data[511:0]     ), //i
    .io_outputs_0_r_payload_id        (io_axis_0_readOnly_decoder_io_outputs_0_r_payload_id[3:0]      ), //i
    .io_outputs_0_r_payload_resp      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_resp[1:0]       ), //i
    .io_outputs_0_r_payload_last      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_last            ), //i
    .clk                              (clk                                                            ), //i
    .reset                            (reset                                                          )  //i
  );
  Axi4WriteOnlyDecoder io_axis_0_writeOnly_decoder (
    .io_input_aw_valid                (io_axis_0_writeOnly_aw_valid                                    ), //i
    .io_input_aw_ready                (io_axis_0_writeOnly_decoder_io_input_aw_ready                   ), //o
    .io_input_aw_payload_addr         (io_axis_0_writeOnly_aw_payload_addr[31:0]                       ), //i
    .io_input_aw_payload_id           (io_axis_0_writeOnly_aw_payload_id[3:0]                          ), //i
    .io_input_aw_payload_len          (io_axis_0_writeOnly_aw_payload_len[7:0]                         ), //i
    .io_input_aw_payload_size         (io_axis_0_writeOnly_aw_payload_size[2:0]                        ), //i
    .io_input_aw_payload_burst        (io_axis_0_writeOnly_aw_payload_burst[1:0]                       ), //i
    .io_input_aw_payload_lock         (io_axis_0_writeOnly_aw_payload_lock                             ), //i
    .io_input_aw_payload_cache        (io_axis_0_writeOnly_aw_payload_cache[3:0]                       ), //i
    .io_input_aw_payload_qos          (io_axis_0_writeOnly_aw_payload_qos[3:0]                         ), //i
    .io_input_w_valid                 (io_axis_0_writeOnly_w_valid                                     ), //i
    .io_input_w_ready                 (io_axis_0_writeOnly_decoder_io_input_w_ready                    ), //o
    .io_input_w_payload_data          (io_axis_0_writeOnly_w_payload_data[511:0]                       ), //i
    .io_input_w_payload_strb          (io_axis_0_writeOnly_w_payload_strb[63:0]                        ), //i
    .io_input_w_payload_last          (io_axis_0_writeOnly_w_payload_last                              ), //i
    .io_input_b_valid                 (io_axis_0_writeOnly_decoder_io_input_b_valid                    ), //o
    .io_input_b_ready                 (io_axis_0_writeOnly_b_ready                                     ), //i
    .io_input_b_payload_id            (io_axis_0_writeOnly_decoder_io_input_b_payload_id[3:0]          ), //o
    .io_input_b_payload_resp          (io_axis_0_writeOnly_decoder_io_input_b_payload_resp[1:0]        ), //o
    .io_outputs_0_aw_valid            (io_axis_0_writeOnly_decoder_io_outputs_0_aw_valid               ), //o
    .io_outputs_0_aw_ready            (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1    ), //i
    .io_outputs_0_aw_payload_addr     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_addr[31:0]  ), //o
    .io_outputs_0_aw_payload_id       (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_id[3:0]     ), //o
    .io_outputs_0_aw_payload_len      (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]    ), //o
    .io_outputs_0_aw_payload_size     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]   ), //o
    .io_outputs_0_aw_payload_burst    (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]  ), //o
    .io_outputs_0_aw_payload_lock     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_lock        ), //o
    .io_outputs_0_aw_payload_cache    (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]  ), //o
    .io_outputs_0_aw_payload_qos      (io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_qos[3:0]    ), //o
    .io_outputs_0_w_valid             (io_axis_0_writeOnly_decoder_io_outputs_0_w_valid                ), //o
    .io_outputs_0_w_ready             (io_axim_writeOnly_arbiter_io_inputs_0_w_ready                   ), //i
    .io_outputs_0_w_payload_data      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_data[511:0]  ), //o
    .io_outputs_0_w_payload_strb      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_strb[63:0]   ), //o
    .io_outputs_0_w_payload_last      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_last         ), //o
    .io_outputs_0_b_valid             (io_axim_writeOnly_arbiter_io_inputs_0_b_valid                   ), //i
    .io_outputs_0_b_ready             (io_axis_0_writeOnly_decoder_io_outputs_0_b_ready                ), //o
    .io_outputs_0_b_payload_id        (io_axis_0_writeOnly_decoder_io_outputs_0_b_payload_id[3:0]      ), //i
    .io_outputs_0_b_payload_resp      (io_axim_writeOnly_arbiter_io_inputs_0_b_payload_resp[1:0]       ), //i
    .clk                              (clk                                                             ), //i
    .reset                            (reset                                                           )  //i
  );
  Axi4ReadOnlyDecoder io_axis_1_readOnly_decoder (
    .io_input_ar_valid                (io_axis_1_readOnly_ar_valid                                    ), //i
    .io_input_ar_ready                (io_axis_1_readOnly_decoder_io_input_ar_ready                   ), //o
    .io_input_ar_payload_addr         (io_axis_1_readOnly_ar_payload_addr[31:0]                       ), //i
    .io_input_ar_payload_id           (io_axis_1_readOnly_ar_payload_id[3:0]                          ), //i
    .io_input_ar_payload_len          (io_axis_1_readOnly_ar_payload_len[7:0]                         ), //i
    .io_input_ar_payload_size         (io_axis_1_readOnly_ar_payload_size[2:0]                        ), //i
    .io_input_ar_payload_burst        (io_axis_1_readOnly_ar_payload_burst[1:0]                       ), //i
    .io_input_ar_payload_lock         (io_axis_1_readOnly_ar_payload_lock                             ), //i
    .io_input_ar_payload_cache        (io_axis_1_readOnly_ar_payload_cache[3:0]                       ), //i
    .io_input_ar_payload_qos          (io_axis_1_readOnly_ar_payload_qos[3:0]                         ), //i
    .io_input_r_valid                 (io_axis_1_readOnly_decoder_io_input_r_valid                    ), //o
    .io_input_r_ready                 (io_axis_1_readOnly_r_ready                                     ), //i
    .io_input_r_payload_data          (io_axis_1_readOnly_decoder_io_input_r_payload_data[511:0]      ), //o
    .io_input_r_payload_id            (io_axis_1_readOnly_decoder_io_input_r_payload_id[3:0]          ), //o
    .io_input_r_payload_resp          (io_axis_1_readOnly_decoder_io_input_r_payload_resp[1:0]        ), //o
    .io_input_r_payload_last          (io_axis_1_readOnly_decoder_io_input_r_payload_last             ), //o
    .io_outputs_0_ar_valid            (io_axis_1_readOnly_decoder_io_outputs_0_ar_valid               ), //o
    .io_outputs_0_ar_ready            (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1    ), //i
    .io_outputs_0_ar_payload_addr     (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_addr[31:0]  ), //o
    .io_outputs_0_ar_payload_id       (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_id[3:0]     ), //o
    .io_outputs_0_ar_payload_len      (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]    ), //o
    .io_outputs_0_ar_payload_size     (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]   ), //o
    .io_outputs_0_ar_payload_burst    (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]  ), //o
    .io_outputs_0_ar_payload_lock     (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_lock        ), //o
    .io_outputs_0_ar_payload_cache    (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]  ), //o
    .io_outputs_0_ar_payload_qos      (io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_qos[3:0]    ), //o
    .io_outputs_0_r_valid             (io_axim_readOnly_arbiter_io_inputs_1_r_valid                   ), //i
    .io_outputs_0_r_ready             (io_axis_1_readOnly_decoder_io_outputs_0_r_ready                ), //o
    .io_outputs_0_r_payload_data      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_data[511:0]     ), //i
    .io_outputs_0_r_payload_id        (io_axis_1_readOnly_decoder_io_outputs_0_r_payload_id[3:0]      ), //i
    .io_outputs_0_r_payload_resp      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_resp[1:0]       ), //i
    .io_outputs_0_r_payload_last      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_last            ), //i
    .clk                              (clk                                                            ), //i
    .reset                            (reset                                                          )  //i
  );
  Axi4WriteOnlyDecoder io_axis_1_writeOnly_decoder (
    .io_input_aw_valid                (io_axis_1_writeOnly_aw_valid                                    ), //i
    .io_input_aw_ready                (io_axis_1_writeOnly_decoder_io_input_aw_ready                   ), //o
    .io_input_aw_payload_addr         (io_axis_1_writeOnly_aw_payload_addr[31:0]                       ), //i
    .io_input_aw_payload_id           (io_axis_1_writeOnly_aw_payload_id[3:0]                          ), //i
    .io_input_aw_payload_len          (io_axis_1_writeOnly_aw_payload_len[7:0]                         ), //i
    .io_input_aw_payload_size         (io_axis_1_writeOnly_aw_payload_size[2:0]                        ), //i
    .io_input_aw_payload_burst        (io_axis_1_writeOnly_aw_payload_burst[1:0]                       ), //i
    .io_input_aw_payload_lock         (io_axis_1_writeOnly_aw_payload_lock                             ), //i
    .io_input_aw_payload_cache        (io_axis_1_writeOnly_aw_payload_cache[3:0]                       ), //i
    .io_input_aw_payload_qos          (io_axis_1_writeOnly_aw_payload_qos[3:0]                         ), //i
    .io_input_w_valid                 (io_axis_1_writeOnly_w_valid                                     ), //i
    .io_input_w_ready                 (io_axis_1_writeOnly_decoder_io_input_w_ready                    ), //o
    .io_input_w_payload_data          (io_axis_1_writeOnly_w_payload_data[511:0]                       ), //i
    .io_input_w_payload_strb          (io_axis_1_writeOnly_w_payload_strb[63:0]                        ), //i
    .io_input_w_payload_last          (io_axis_1_writeOnly_w_payload_last                              ), //i
    .io_input_b_valid                 (io_axis_1_writeOnly_decoder_io_input_b_valid                    ), //o
    .io_input_b_ready                 (io_axis_1_writeOnly_b_ready                                     ), //i
    .io_input_b_payload_id            (io_axis_1_writeOnly_decoder_io_input_b_payload_id[3:0]          ), //o
    .io_input_b_payload_resp          (io_axis_1_writeOnly_decoder_io_input_b_payload_resp[1:0]        ), //o
    .io_outputs_0_aw_valid            (io_axis_1_writeOnly_decoder_io_outputs_0_aw_valid               ), //o
    .io_outputs_0_aw_ready            (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1    ), //i
    .io_outputs_0_aw_payload_addr     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_addr[31:0]  ), //o
    .io_outputs_0_aw_payload_id       (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_id[3:0]     ), //o
    .io_outputs_0_aw_payload_len      (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]    ), //o
    .io_outputs_0_aw_payload_size     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]   ), //o
    .io_outputs_0_aw_payload_burst    (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]  ), //o
    .io_outputs_0_aw_payload_lock     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_lock        ), //o
    .io_outputs_0_aw_payload_cache    (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]  ), //o
    .io_outputs_0_aw_payload_qos      (io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_qos[3:0]    ), //o
    .io_outputs_0_w_valid             (io_axis_1_writeOnly_decoder_io_outputs_0_w_valid                ), //o
    .io_outputs_0_w_ready             (io_axim_writeOnly_arbiter_io_inputs_1_w_ready                   ), //i
    .io_outputs_0_w_payload_data      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_data[511:0]  ), //o
    .io_outputs_0_w_payload_strb      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_strb[63:0]   ), //o
    .io_outputs_0_w_payload_last      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_last         ), //o
    .io_outputs_0_b_valid             (io_axim_writeOnly_arbiter_io_inputs_1_b_valid                   ), //i
    .io_outputs_0_b_ready             (io_axis_1_writeOnly_decoder_io_outputs_0_b_ready                ), //o
    .io_outputs_0_b_payload_id        (io_axis_1_writeOnly_decoder_io_outputs_0_b_payload_id[3:0]      ), //i
    .io_outputs_0_b_payload_resp      (io_axim_writeOnly_arbiter_io_inputs_1_b_payload_resp[1:0]       ), //i
    .clk                              (clk                                                             ), //i
    .reset                            (reset                                                           )  //i
  );
  Axi4ReadOnlyArbiter io_axim_readOnly_arbiter (
    .io_inputs_0_ar_valid            (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_valid               ), //i
    .io_inputs_0_ar_ready            (io_axim_readOnly_arbiter_io_inputs_0_ar_ready                            ), //o
    .io_inputs_0_ar_payload_addr     (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[31:0]  ), //i
    .io_inputs_0_ar_payload_id       (io_axim_readOnly_arbiter_io_inputs_0_ar_payload_id[6:0]                  ), //i
    .io_inputs_0_ar_payload_len      (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]    ), //i
    .io_inputs_0_ar_payload_size     (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]   ), //i
    .io_inputs_0_ar_payload_burst    (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0]  ), //i
    .io_inputs_0_ar_payload_lock     (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock        ), //i
    .io_inputs_0_ar_payload_cache    (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache[3:0]  ), //i
    .io_inputs_0_ar_payload_qos      (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos[3:0]    ), //i
    .io_inputs_0_r_valid             (io_axim_readOnly_arbiter_io_inputs_0_r_valid                             ), //o
    .io_inputs_0_r_ready             (io_axis_0_readOnly_decoder_io_outputs_0_r_ready                          ), //i
    .io_inputs_0_r_payload_data      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_data[511:0]               ), //o
    .io_inputs_0_r_payload_id        (io_axim_readOnly_arbiter_io_inputs_0_r_payload_id[6:0]                   ), //o
    .io_inputs_0_r_payload_resp      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_resp[1:0]                 ), //o
    .io_inputs_0_r_payload_last      (io_axim_readOnly_arbiter_io_inputs_0_r_payload_last                      ), //o
    .io_inputs_1_ar_valid            (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_valid               ), //i
    .io_inputs_1_ar_ready            (io_axim_readOnly_arbiter_io_inputs_1_ar_ready                            ), //o
    .io_inputs_1_ar_payload_addr     (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[31:0]  ), //i
    .io_inputs_1_ar_payload_id       (io_axim_readOnly_arbiter_io_inputs_1_ar_payload_id[6:0]                  ), //i
    .io_inputs_1_ar_payload_len      (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]    ), //i
    .io_inputs_1_ar_payload_size     (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]   ), //i
    .io_inputs_1_ar_payload_burst    (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0]  ), //i
    .io_inputs_1_ar_payload_lock     (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock        ), //i
    .io_inputs_1_ar_payload_cache    (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache[3:0]  ), //i
    .io_inputs_1_ar_payload_qos      (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos[3:0]    ), //i
    .io_inputs_1_r_valid             (io_axim_readOnly_arbiter_io_inputs_1_r_valid                             ), //o
    .io_inputs_1_r_ready             (io_axis_1_readOnly_decoder_io_outputs_0_r_ready                          ), //i
    .io_inputs_1_r_payload_data      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_data[511:0]               ), //o
    .io_inputs_1_r_payload_id        (io_axim_readOnly_arbiter_io_inputs_1_r_payload_id[6:0]                   ), //o
    .io_inputs_1_r_payload_resp      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_resp[1:0]                 ), //o
    .io_inputs_1_r_payload_last      (io_axim_readOnly_arbiter_io_inputs_1_r_payload_last                      ), //o
    .io_output_ar_valid              (io_axim_readOnly_arbiter_io_output_ar_valid                              ), //o
    .io_output_ar_ready              (io_axim_readOnly_ar_ready                                                ), //i
    .io_output_ar_payload_addr       (io_axim_readOnly_arbiter_io_output_ar_payload_addr[31:0]                 ), //o
    .io_output_ar_payload_id         (io_axim_readOnly_arbiter_io_output_ar_payload_id[7:0]                    ), //o
    .io_output_ar_payload_len        (io_axim_readOnly_arbiter_io_output_ar_payload_len[7:0]                   ), //o
    .io_output_ar_payload_size       (io_axim_readOnly_arbiter_io_output_ar_payload_size[2:0]                  ), //o
    .io_output_ar_payload_burst      (io_axim_readOnly_arbiter_io_output_ar_payload_burst[1:0]                 ), //o
    .io_output_ar_payload_lock       (io_axim_readOnly_arbiter_io_output_ar_payload_lock                       ), //o
    .io_output_ar_payload_cache      (io_axim_readOnly_arbiter_io_output_ar_payload_cache[3:0]                 ), //o
    .io_output_ar_payload_qos        (io_axim_readOnly_arbiter_io_output_ar_payload_qos[3:0]                   ), //o
    .io_output_r_valid               (io_axim_readOnly_r_valid                                                 ), //i
    .io_output_r_ready               (io_axim_readOnly_arbiter_io_output_r_ready                               ), //o
    .io_output_r_payload_data        (io_axim_readOnly_r_payload_data[511:0]                                   ), //i
    .io_output_r_payload_id          (io_axim_readOnly_r_payload_id[7:0]                                       ), //i
    .io_output_r_payload_resp        (io_axim_readOnly_r_payload_resp[1:0]                                     ), //i
    .io_output_r_payload_last        (io_axim_readOnly_r_payload_last                                          ), //i
    .clk                             (clk                                                                      ), //i
    .reset                           (reset                                                                    )  //i
  );
  Axi4WriteOnlyArbiter io_axim_writeOnly_arbiter (
    .io_inputs_0_aw_valid            (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_valid               ), //i
    .io_inputs_0_aw_ready            (io_axim_writeOnly_arbiter_io_inputs_0_aw_ready                            ), //o
    .io_inputs_0_aw_payload_addr     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[31:0]  ), //i
    .io_inputs_0_aw_payload_id       (io_axim_writeOnly_arbiter_io_inputs_0_aw_payload_id[6:0]                  ), //i
    .io_inputs_0_aw_payload_len      (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]    ), //i
    .io_inputs_0_aw_payload_size     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0]   ), //i
    .io_inputs_0_aw_payload_burst    (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]  ), //i
    .io_inputs_0_aw_payload_lock     (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock        ), //i
    .io_inputs_0_aw_payload_cache    (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache[3:0]  ), //i
    .io_inputs_0_aw_payload_qos      (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos[3:0]    ), //i
    .io_inputs_0_w_valid             (io_axis_0_writeOnly_decoder_io_outputs_0_w_valid                          ), //i
    .io_inputs_0_w_ready             (io_axim_writeOnly_arbiter_io_inputs_0_w_ready                             ), //o
    .io_inputs_0_w_payload_data      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_data[511:0]            ), //i
    .io_inputs_0_w_payload_strb      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_strb[63:0]             ), //i
    .io_inputs_0_w_payload_last      (io_axis_0_writeOnly_decoder_io_outputs_0_w_payload_last                   ), //i
    .io_inputs_0_b_valid             (io_axim_writeOnly_arbiter_io_inputs_0_b_valid                             ), //o
    .io_inputs_0_b_ready             (io_axis_0_writeOnly_decoder_io_outputs_0_b_ready                          ), //i
    .io_inputs_0_b_payload_id        (io_axim_writeOnly_arbiter_io_inputs_0_b_payload_id[6:0]                   ), //o
    .io_inputs_0_b_payload_resp      (io_axim_writeOnly_arbiter_io_inputs_0_b_payload_resp[1:0]                 ), //o
    .io_inputs_1_aw_valid            (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_valid               ), //i
    .io_inputs_1_aw_ready            (io_axim_writeOnly_arbiter_io_inputs_1_aw_ready                            ), //o
    .io_inputs_1_aw_payload_addr     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[31:0]  ), //i
    .io_inputs_1_aw_payload_id       (io_axim_writeOnly_arbiter_io_inputs_1_aw_payload_id[6:0]                  ), //i
    .io_inputs_1_aw_payload_len      (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]    ), //i
    .io_inputs_1_aw_payload_size     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0]   ), //i
    .io_inputs_1_aw_payload_burst    (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]  ), //i
    .io_inputs_1_aw_payload_lock     (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock        ), //i
    .io_inputs_1_aw_payload_cache    (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache[3:0]  ), //i
    .io_inputs_1_aw_payload_qos      (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos[3:0]    ), //i
    .io_inputs_1_w_valid             (io_axis_1_writeOnly_decoder_io_outputs_0_w_valid                          ), //i
    .io_inputs_1_w_ready             (io_axim_writeOnly_arbiter_io_inputs_1_w_ready                             ), //o
    .io_inputs_1_w_payload_data      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_data[511:0]            ), //i
    .io_inputs_1_w_payload_strb      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_strb[63:0]             ), //i
    .io_inputs_1_w_payload_last      (io_axis_1_writeOnly_decoder_io_outputs_0_w_payload_last                   ), //i
    .io_inputs_1_b_valid             (io_axim_writeOnly_arbiter_io_inputs_1_b_valid                             ), //o
    .io_inputs_1_b_ready             (io_axis_1_writeOnly_decoder_io_outputs_0_b_ready                          ), //i
    .io_inputs_1_b_payload_id        (io_axim_writeOnly_arbiter_io_inputs_1_b_payload_id[6:0]                   ), //o
    .io_inputs_1_b_payload_resp      (io_axim_writeOnly_arbiter_io_inputs_1_b_payload_resp[1:0]                 ), //o
    .io_output_aw_valid              (io_axim_writeOnly_arbiter_io_output_aw_valid                              ), //o
    .io_output_aw_ready              (io_axim_writeOnly_aw_ready                                                ), //i
    .io_output_aw_payload_addr       (io_axim_writeOnly_arbiter_io_output_aw_payload_addr[31:0]                 ), //o
    .io_output_aw_payload_id         (io_axim_writeOnly_arbiter_io_output_aw_payload_id[7:0]                    ), //o
    .io_output_aw_payload_len        (io_axim_writeOnly_arbiter_io_output_aw_payload_len[7:0]                   ), //o
    .io_output_aw_payload_size       (io_axim_writeOnly_arbiter_io_output_aw_payload_size[2:0]                  ), //o
    .io_output_aw_payload_burst      (io_axim_writeOnly_arbiter_io_output_aw_payload_burst[1:0]                 ), //o
    .io_output_aw_payload_lock       (io_axim_writeOnly_arbiter_io_output_aw_payload_lock                       ), //o
    .io_output_aw_payload_cache      (io_axim_writeOnly_arbiter_io_output_aw_payload_cache[3:0]                 ), //o
    .io_output_aw_payload_qos        (io_axim_writeOnly_arbiter_io_output_aw_payload_qos[3:0]                   ), //o
    .io_output_w_valid               (io_axim_writeOnly_arbiter_io_output_w_valid                               ), //o
    .io_output_w_ready               (io_axim_writeOnly_w_ready                                                 ), //i
    .io_output_w_payload_data        (io_axim_writeOnly_arbiter_io_output_w_payload_data[511:0]                 ), //o
    .io_output_w_payload_strb        (io_axim_writeOnly_arbiter_io_output_w_payload_strb[63:0]                  ), //o
    .io_output_w_payload_last        (io_axim_writeOnly_arbiter_io_output_w_payload_last                        ), //o
    .io_output_b_valid               (io_axim_writeOnly_b_valid                                                 ), //i
    .io_output_b_ready               (io_axim_writeOnly_arbiter_io_output_b_ready                               ), //o
    .io_output_b_payload_id          (io_axim_writeOnly_b_payload_id[7:0]                                       ), //i
    .io_output_b_payload_resp        (io_axim_writeOnly_b_payload_resp[1:0]                                     ), //i
    .clk                             (clk                                                                       ), //i
    .reset                           (reset                                                                     )  //i
  );
  assign io_axim_ar_valid = io_axim_readOnly_ar_valid;
  assign io_axim_readOnly_ar_ready = io_axim_ar_ready;
  assign io_axim_ar_payload_addr = io_axim_readOnly_ar_payload_addr;
  assign io_axim_ar_payload_id = io_axim_readOnly_ar_payload_id;
  assign io_axim_ar_payload_len = io_axim_readOnly_ar_payload_len;
  assign io_axim_ar_payload_size = io_axim_readOnly_ar_payload_size;
  assign io_axim_ar_payload_burst = io_axim_readOnly_ar_payload_burst;
  assign io_axim_ar_payload_lock = io_axim_readOnly_ar_payload_lock;
  assign io_axim_ar_payload_cache = io_axim_readOnly_ar_payload_cache;
  assign io_axim_ar_payload_qos = io_axim_readOnly_ar_payload_qos;
  assign io_axim_readOnly_r_valid = io_axim_r_valid;
  assign io_axim_r_ready = io_axim_readOnly_r_ready;
  assign io_axim_readOnly_r_payload_data = io_axim_r_payload_data;
  assign io_axim_readOnly_r_payload_last = io_axim_r_payload_last;
  assign io_axim_readOnly_r_payload_id = io_axim_r_payload_id;
  assign io_axim_readOnly_r_payload_resp = io_axim_r_payload_resp;
  assign io_axim_aw_valid = io_axim_writeOnly_aw_valid;
  assign io_axim_writeOnly_aw_ready = io_axim_aw_ready;
  assign io_axim_aw_payload_addr = io_axim_writeOnly_aw_payload_addr;
  assign io_axim_aw_payload_id = io_axim_writeOnly_aw_payload_id;
  assign io_axim_aw_payload_len = io_axim_writeOnly_aw_payload_len;
  assign io_axim_aw_payload_size = io_axim_writeOnly_aw_payload_size;
  assign io_axim_aw_payload_burst = io_axim_writeOnly_aw_payload_burst;
  assign io_axim_aw_payload_lock = io_axim_writeOnly_aw_payload_lock;
  assign io_axim_aw_payload_cache = io_axim_writeOnly_aw_payload_cache;
  assign io_axim_aw_payload_qos = io_axim_writeOnly_aw_payload_qos;
  assign io_axim_w_valid = io_axim_writeOnly_w_valid;
  assign io_axim_writeOnly_w_ready = io_axim_w_ready;
  assign io_axim_w_payload_data = io_axim_writeOnly_w_payload_data;
  assign io_axim_w_payload_strb = io_axim_writeOnly_w_payload_strb;
  assign io_axim_w_payload_last = io_axim_writeOnly_w_payload_last;
  assign io_axim_writeOnly_b_valid = io_axim_b_valid;
  assign io_axim_b_ready = io_axim_writeOnly_b_ready;
  assign io_axim_writeOnly_b_payload_id = io_axim_b_payload_id;
  assign io_axim_writeOnly_b_payload_resp = io_axim_b_payload_resp;
  assign io_axis_0_readOnly_ar_valid = io_axis_0_ar_valid;
  assign io_axis_0_ar_ready = io_axis_0_readOnly_ar_ready;
  assign io_axis_0_readOnly_ar_payload_addr = io_axis_0_ar_payload_addr;
  assign io_axis_0_readOnly_ar_payload_id = io_axis_0_ar_payload_id;
  assign io_axis_0_readOnly_ar_payload_len = io_axis_0_ar_payload_len;
  assign io_axis_0_readOnly_ar_payload_size = io_axis_0_ar_payload_size;
  assign io_axis_0_readOnly_ar_payload_burst = io_axis_0_ar_payload_burst;
  assign io_axis_0_readOnly_ar_payload_lock = io_axis_0_ar_payload_lock;
  assign io_axis_0_readOnly_ar_payload_cache = io_axis_0_ar_payload_cache;
  assign io_axis_0_readOnly_ar_payload_qos = io_axis_0_ar_payload_qos;
  assign io_axis_0_r_valid = io_axis_0_readOnly_r_valid;
  assign io_axis_0_readOnly_r_ready = io_axis_0_r_ready;
  assign io_axis_0_r_payload_data = io_axis_0_readOnly_r_payload_data;
  assign io_axis_0_r_payload_last = io_axis_0_readOnly_r_payload_last;
  assign io_axis_0_r_payload_id = io_axis_0_readOnly_r_payload_id;
  assign io_axis_0_r_payload_resp = io_axis_0_readOnly_r_payload_resp;
  assign io_axis_0_writeOnly_aw_valid = io_axis_0_aw_valid;
  assign io_axis_0_aw_ready = io_axis_0_writeOnly_aw_ready;
  assign io_axis_0_writeOnly_aw_payload_addr = io_axis_0_aw_payload_addr;
  assign io_axis_0_writeOnly_aw_payload_id = io_axis_0_aw_payload_id;
  assign io_axis_0_writeOnly_aw_payload_len = io_axis_0_aw_payload_len;
  assign io_axis_0_writeOnly_aw_payload_size = io_axis_0_aw_payload_size;
  assign io_axis_0_writeOnly_aw_payload_burst = io_axis_0_aw_payload_burst;
  assign io_axis_0_writeOnly_aw_payload_lock = io_axis_0_aw_payload_lock;
  assign io_axis_0_writeOnly_aw_payload_cache = io_axis_0_aw_payload_cache;
  assign io_axis_0_writeOnly_aw_payload_qos = io_axis_0_aw_payload_qos;
  assign io_axis_0_writeOnly_w_valid = io_axis_0_w_valid;
  assign io_axis_0_w_ready = io_axis_0_writeOnly_w_ready;
  assign io_axis_0_writeOnly_w_payload_data = io_axis_0_w_payload_data;
  assign io_axis_0_writeOnly_w_payload_strb = io_axis_0_w_payload_strb;
  assign io_axis_0_writeOnly_w_payload_last = io_axis_0_w_payload_last;
  assign io_axis_0_b_valid = io_axis_0_writeOnly_b_valid;
  assign io_axis_0_writeOnly_b_ready = io_axis_0_b_ready;
  assign io_axis_0_b_payload_id = io_axis_0_writeOnly_b_payload_id;
  assign io_axis_0_b_payload_resp = io_axis_0_writeOnly_b_payload_resp;
  assign io_axis_1_readOnly_ar_valid = io_axis_1_ar_valid;
  assign io_axis_1_ar_ready = io_axis_1_readOnly_ar_ready;
  assign io_axis_1_readOnly_ar_payload_addr = io_axis_1_ar_payload_addr;
  assign io_axis_1_readOnly_ar_payload_id = io_axis_1_ar_payload_id;
  assign io_axis_1_readOnly_ar_payload_len = io_axis_1_ar_payload_len;
  assign io_axis_1_readOnly_ar_payload_size = io_axis_1_ar_payload_size;
  assign io_axis_1_readOnly_ar_payload_burst = io_axis_1_ar_payload_burst;
  assign io_axis_1_readOnly_ar_payload_lock = io_axis_1_ar_payload_lock;
  assign io_axis_1_readOnly_ar_payload_cache = io_axis_1_ar_payload_cache;
  assign io_axis_1_readOnly_ar_payload_qos = io_axis_1_ar_payload_qos;
  assign io_axis_1_r_valid = io_axis_1_readOnly_r_valid;
  assign io_axis_1_readOnly_r_ready = io_axis_1_r_ready;
  assign io_axis_1_r_payload_data = io_axis_1_readOnly_r_payload_data;
  assign io_axis_1_r_payload_last = io_axis_1_readOnly_r_payload_last;
  assign io_axis_1_r_payload_id = io_axis_1_readOnly_r_payload_id;
  assign io_axis_1_r_payload_resp = io_axis_1_readOnly_r_payload_resp;
  assign io_axis_1_writeOnly_aw_valid = io_axis_1_aw_valid;
  assign io_axis_1_aw_ready = io_axis_1_writeOnly_aw_ready;
  assign io_axis_1_writeOnly_aw_payload_addr = io_axis_1_aw_payload_addr;
  assign io_axis_1_writeOnly_aw_payload_id = io_axis_1_aw_payload_id;
  assign io_axis_1_writeOnly_aw_payload_len = io_axis_1_aw_payload_len;
  assign io_axis_1_writeOnly_aw_payload_size = io_axis_1_aw_payload_size;
  assign io_axis_1_writeOnly_aw_payload_burst = io_axis_1_aw_payload_burst;
  assign io_axis_1_writeOnly_aw_payload_lock = io_axis_1_aw_payload_lock;
  assign io_axis_1_writeOnly_aw_payload_cache = io_axis_1_aw_payload_cache;
  assign io_axis_1_writeOnly_aw_payload_qos = io_axis_1_aw_payload_qos;
  assign io_axis_1_writeOnly_w_valid = io_axis_1_w_valid;
  assign io_axis_1_w_ready = io_axis_1_writeOnly_w_ready;
  assign io_axis_1_writeOnly_w_payload_data = io_axis_1_w_payload_data;
  assign io_axis_1_writeOnly_w_payload_strb = io_axis_1_w_payload_strb;
  assign io_axis_1_writeOnly_w_payload_last = io_axis_1_w_payload_last;
  assign io_axis_1_b_valid = io_axis_1_writeOnly_b_valid;
  assign io_axis_1_writeOnly_b_ready = io_axis_1_b_ready;
  assign io_axis_1_b_payload_id = io_axis_1_writeOnly_b_payload_id;
  assign io_axis_1_b_payload_resp = io_axis_1_writeOnly_b_payload_resp;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_valid && io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1 = (io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_valid && io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_valid = io_axis_0_readOnly_decoder_io_outputs_0_ar_rValid;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos = io_axis_0_readOnly_decoder_io_outputs_0_ar_payload_qos;
  assign io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_ready = io_axim_readOnly_arbiter_io_inputs_0_ar_ready;
  assign io_axis_0_readOnly_decoder_io_outputs_0_r_payload_id = io_axim_readOnly_arbiter_io_inputs_0_r_payload_id[3:0];
  assign io_axis_0_readOnly_ar_ready = io_axis_0_readOnly_decoder_io_input_ar_ready;
  assign io_axis_0_readOnly_r_valid = io_axis_0_readOnly_decoder_io_input_r_valid;
  assign io_axis_0_readOnly_r_payload_data = io_axis_0_readOnly_decoder_io_input_r_payload_data;
  assign io_axis_0_readOnly_r_payload_last = io_axis_0_readOnly_decoder_io_input_r_payload_last;
  assign io_axis_0_readOnly_r_payload_id = io_axis_0_readOnly_decoder_io_input_r_payload_id;
  assign io_axis_0_readOnly_r_payload_resp = io_axis_0_readOnly_decoder_io_input_r_payload_resp;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1 = (io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = io_axis_0_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos = io_axis_0_writeOnly_decoder_io_outputs_0_aw_payload_qos;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = io_axim_writeOnly_arbiter_io_inputs_0_aw_ready;
  assign io_axis_0_writeOnly_decoder_io_outputs_0_b_payload_id = io_axim_writeOnly_arbiter_io_inputs_0_b_payload_id[3:0];
  assign io_axis_0_writeOnly_aw_ready = io_axis_0_writeOnly_decoder_io_input_aw_ready;
  assign io_axis_0_writeOnly_w_ready = io_axis_0_writeOnly_decoder_io_input_w_ready;
  assign io_axis_0_writeOnly_b_valid = io_axis_0_writeOnly_decoder_io_input_b_valid;
  assign io_axis_0_writeOnly_b_payload_id = io_axis_0_writeOnly_decoder_io_input_b_payload_id;
  assign io_axis_0_writeOnly_b_payload_resp = io_axis_0_writeOnly_decoder_io_input_b_payload_resp;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_valid && io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire_1 = (io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_valid && io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_valid = io_axis_1_readOnly_decoder_io_outputs_0_ar_rValid;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_qos = io_axis_1_readOnly_decoder_io_outputs_0_ar_payload_qos;
  assign io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_ready = io_axim_readOnly_arbiter_io_inputs_1_ar_ready;
  assign io_axis_1_readOnly_decoder_io_outputs_0_r_payload_id = io_axim_readOnly_arbiter_io_inputs_1_r_payload_id[3:0];
  assign io_axis_1_readOnly_ar_ready = io_axis_1_readOnly_decoder_io_input_ar_ready;
  assign io_axis_1_readOnly_r_valid = io_axis_1_readOnly_decoder_io_input_r_valid;
  assign io_axis_1_readOnly_r_payload_data = io_axis_1_readOnly_decoder_io_input_r_payload_data;
  assign io_axis_1_readOnly_r_payload_last = io_axis_1_readOnly_decoder_io_input_r_payload_last;
  assign io_axis_1_readOnly_r_payload_id = io_axis_1_readOnly_decoder_io_input_r_payload_id;
  assign io_axis_1_readOnly_r_payload_resp = io_axis_1_readOnly_decoder_io_input_r_payload_resp;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire_1 = (io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = io_axis_1_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_qos = io_axis_1_writeOnly_decoder_io_outputs_0_aw_payload_qos;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = io_axim_writeOnly_arbiter_io_inputs_1_aw_ready;
  assign io_axis_1_writeOnly_decoder_io_outputs_0_b_payload_id = io_axim_writeOnly_arbiter_io_inputs_1_b_payload_id[3:0];
  assign io_axis_1_writeOnly_aw_ready = io_axis_1_writeOnly_decoder_io_input_aw_ready;
  assign io_axis_1_writeOnly_w_ready = io_axis_1_writeOnly_decoder_io_input_w_ready;
  assign io_axis_1_writeOnly_b_valid = io_axis_1_writeOnly_decoder_io_input_b_valid;
  assign io_axis_1_writeOnly_b_payload_id = io_axis_1_writeOnly_decoder_io_input_b_payload_id;
  assign io_axis_1_writeOnly_b_payload_resp = io_axis_1_writeOnly_decoder_io_input_b_payload_resp;
  assign io_axim_readOnly_arbiter_io_inputs_0_ar_payload_id = {3'd0, io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id};
  assign io_axim_readOnly_arbiter_io_inputs_1_ar_payload_id = {3'd0, io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id};
  assign io_axim_readOnly_ar_valid = io_axim_readOnly_arbiter_io_output_ar_valid;
  assign io_axim_readOnly_ar_payload_addr = io_axim_readOnly_arbiter_io_output_ar_payload_addr;
  assign io_axim_readOnly_ar_payload_id = io_axim_readOnly_arbiter_io_output_ar_payload_id;
  assign io_axim_readOnly_ar_payload_len = io_axim_readOnly_arbiter_io_output_ar_payload_len;
  assign io_axim_readOnly_ar_payload_size = io_axim_readOnly_arbiter_io_output_ar_payload_size;
  assign io_axim_readOnly_ar_payload_burst = io_axim_readOnly_arbiter_io_output_ar_payload_burst;
  assign io_axim_readOnly_ar_payload_lock = io_axim_readOnly_arbiter_io_output_ar_payload_lock;
  assign io_axim_readOnly_ar_payload_cache = io_axim_readOnly_arbiter_io_output_ar_payload_cache;
  assign io_axim_readOnly_ar_payload_qos = io_axim_readOnly_arbiter_io_output_ar_payload_qos;
  assign io_axim_readOnly_r_ready = io_axim_readOnly_arbiter_io_output_r_ready;
  assign io_axim_writeOnly_arbiter_io_inputs_0_aw_payload_id = {3'd0, io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id};
  assign io_axim_writeOnly_arbiter_io_inputs_1_aw_payload_id = {3'd0, io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id};
  assign io_axim_writeOnly_aw_valid = io_axim_writeOnly_arbiter_io_output_aw_valid;
  assign io_axim_writeOnly_aw_payload_addr = io_axim_writeOnly_arbiter_io_output_aw_payload_addr;
  assign io_axim_writeOnly_aw_payload_id = io_axim_writeOnly_arbiter_io_output_aw_payload_id;
  assign io_axim_writeOnly_aw_payload_len = io_axim_writeOnly_arbiter_io_output_aw_payload_len;
  assign io_axim_writeOnly_aw_payload_size = io_axim_writeOnly_arbiter_io_output_aw_payload_size;
  assign io_axim_writeOnly_aw_payload_burst = io_axim_writeOnly_arbiter_io_output_aw_payload_burst;
  assign io_axim_writeOnly_aw_payload_lock = io_axim_writeOnly_arbiter_io_output_aw_payload_lock;
  assign io_axim_writeOnly_aw_payload_cache = io_axim_writeOnly_arbiter_io_output_aw_payload_cache;
  assign io_axim_writeOnly_aw_payload_qos = io_axim_writeOnly_arbiter_io_output_aw_payload_qos;
  assign io_axim_writeOnly_w_valid = io_axim_writeOnly_arbiter_io_output_w_valid;
  assign io_axim_writeOnly_w_payload_data = io_axim_writeOnly_arbiter_io_output_w_payload_data;
  assign io_axim_writeOnly_w_payload_strb = io_axim_writeOnly_arbiter_io_output_w_payload_strb;
  assign io_axim_writeOnly_w_payload_last = io_axim_writeOnly_arbiter_io_output_w_payload_last;
  assign io_axim_writeOnly_b_ready = io_axim_writeOnly_arbiter_io_output_b_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      io_axis_0_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      io_axis_0_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      io_axis_1_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      io_axis_1_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
    end else begin
      if(io_axis_0_readOnly_decoder_io_outputs_0_ar_valid) begin
        io_axis_0_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(io_axis_0_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        io_axis_0_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(io_axis_0_writeOnly_decoder_io_outputs_0_aw_valid) begin
        io_axis_0_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(io_axis_0_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        io_axis_0_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
      if(io_axis_1_readOnly_decoder_io_outputs_0_ar_valid) begin
        io_axis_1_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(io_axis_1_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        io_axis_1_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(io_axis_1_writeOnly_decoder_io_outputs_0_aw_valid) begin
        io_axis_1_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(io_axis_1_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        io_axis_1_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
    end
  end


endmodule

module Axi4WriteOnlyArbiter (
  input               io_inputs_0_aw_valid,
  output              io_inputs_0_aw_ready,
  input      [31:0]   io_inputs_0_aw_payload_addr,
  input      [6:0]    io_inputs_0_aw_payload_id,
  input      [7:0]    io_inputs_0_aw_payload_len,
  input      [2:0]    io_inputs_0_aw_payload_size,
  input      [1:0]    io_inputs_0_aw_payload_burst,
  input      [0:0]    io_inputs_0_aw_payload_lock,
  input      [3:0]    io_inputs_0_aw_payload_cache,
  input      [3:0]    io_inputs_0_aw_payload_qos,
  input               io_inputs_0_w_valid,
  output              io_inputs_0_w_ready,
  input      [511:0]  io_inputs_0_w_payload_data,
  input      [63:0]   io_inputs_0_w_payload_strb,
  input               io_inputs_0_w_payload_last,
  output              io_inputs_0_b_valid,
  input               io_inputs_0_b_ready,
  output     [6:0]    io_inputs_0_b_payload_id,
  output     [1:0]    io_inputs_0_b_payload_resp,
  input               io_inputs_1_aw_valid,
  output              io_inputs_1_aw_ready,
  input      [31:0]   io_inputs_1_aw_payload_addr,
  input      [6:0]    io_inputs_1_aw_payload_id,
  input      [7:0]    io_inputs_1_aw_payload_len,
  input      [2:0]    io_inputs_1_aw_payload_size,
  input      [1:0]    io_inputs_1_aw_payload_burst,
  input      [0:0]    io_inputs_1_aw_payload_lock,
  input      [3:0]    io_inputs_1_aw_payload_cache,
  input      [3:0]    io_inputs_1_aw_payload_qos,
  input               io_inputs_1_w_valid,
  output              io_inputs_1_w_ready,
  input      [511:0]  io_inputs_1_w_payload_data,
  input      [63:0]   io_inputs_1_w_payload_strb,
  input               io_inputs_1_w_payload_last,
  output              io_inputs_1_b_valid,
  input               io_inputs_1_b_ready,
  output     [6:0]    io_inputs_1_b_payload_id,
  output     [1:0]    io_inputs_1_b_payload_resp,
  output              io_output_aw_valid,
  input               io_output_aw_ready,
  output     [31:0]   io_output_aw_payload_addr,
  output     [7:0]    io_output_aw_payload_id,
  output     [7:0]    io_output_aw_payload_len,
  output     [2:0]    io_output_aw_payload_size,
  output     [1:0]    io_output_aw_payload_burst,
  output     [0:0]    io_output_aw_payload_lock,
  output     [3:0]    io_output_aw_payload_cache,
  output     [3:0]    io_output_aw_payload_qos,
  output              io_output_w_valid,
  input               io_output_w_ready,
  output     [511:0]  io_output_w_payload_data,
  output     [63:0]   io_output_w_payload_strb,
  output              io_output_w_payload_last,
  input               io_output_b_valid,
  output              io_output_b_ready,
  input      [7:0]    io_output_b_payload_id,
  input      [1:0]    io_output_b_payload_resp,
  input               clk,
  input               reset
);

  wire                cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_ready;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [31:0]   cmdArbiter_io_output_payload_addr;
  wire       [6:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire       [0:0]    cmdArbiter_io_output_payload_lock;
  wire       [3:0]    cmdArbiter_io_output_payload_cache;
  wire       [3:0]    cmdArbiter_io_output_payload_qos;
  wire       [0:0]    cmdArbiter_io_chosen;
  wire       [1:0]    cmdArbiter_io_chosenOH;
  wire                cmdArbiter_io_output_fork_io_input_ready;
  wire                cmdArbiter_io_output_fork_io_outputs_0_valid;
  wire       [31:0]   cmdArbiter_io_output_fork_io_outputs_0_payload_addr;
  wire       [6:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_id;
  wire       [7:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_len;
  wire       [2:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_size;
  wire       [1:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_burst;
  wire       [0:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_lock;
  wire       [3:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_cache;
  wire       [3:0]    cmdArbiter_io_output_fork_io_outputs_0_payload_qos;
  wire                cmdArbiter_io_output_fork_io_outputs_1_valid;
  wire       [31:0]   cmdArbiter_io_output_fork_io_outputs_1_payload_addr;
  wire       [6:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_id;
  wire       [7:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_len;
  wire       [2:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_size;
  wire       [1:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_burst;
  wire       [0:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_lock;
  wire       [3:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_cache;
  wire       [3:0]    cmdArbiter_io_output_fork_io_outputs_1_payload_qos;
  wire                cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_push_ready;
  wire                cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_valid;
  wire       [0:0]    cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_payload;
  wire       [2:0]    cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_occupancy;
  reg                 _zz_io_output_w_valid;
  reg        [511:0]  _zz_io_output_w_payload_data;
  reg        [63:0]   _zz_io_output_w_payload_strb;
  reg                 _zz_io_output_w_payload_last;
  reg                 _zz_io_output_b_ready;
  wire                cmdArbiter_io_output_fork_io_outputs_1_translated_valid;
  wire                cmdArbiter_io_output_fork_io_outputs_1_translated_ready;
  wire       [0:0]    cmdArbiter_io_output_fork_io_outputs_1_translated_payload;
  wire                io_output_w_fire;
  wire       [0:0]    writeRspIndex;
  wire                writeRspSels_0;
  wire                writeRspSels_1;

  StreamArbiter cmdArbiter (
    .io_inputs_0_valid            (io_inputs_0_aw_valid                      ), //i
    .io_inputs_0_ready            (cmdArbiter_io_inputs_0_ready              ), //o
    .io_inputs_0_payload_addr     (io_inputs_0_aw_payload_addr[31:0]         ), //i
    .io_inputs_0_payload_id       (io_inputs_0_aw_payload_id[6:0]            ), //i
    .io_inputs_0_payload_len      (io_inputs_0_aw_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size     (io_inputs_0_aw_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst    (io_inputs_0_aw_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_lock     (io_inputs_0_aw_payload_lock               ), //i
    .io_inputs_0_payload_cache    (io_inputs_0_aw_payload_cache[3:0]         ), //i
    .io_inputs_0_payload_qos      (io_inputs_0_aw_payload_qos[3:0]           ), //i
    .io_inputs_1_valid            (io_inputs_1_aw_valid                      ), //i
    .io_inputs_1_ready            (cmdArbiter_io_inputs_1_ready              ), //o
    .io_inputs_1_payload_addr     (io_inputs_1_aw_payload_addr[31:0]         ), //i
    .io_inputs_1_payload_id       (io_inputs_1_aw_payload_id[6:0]            ), //i
    .io_inputs_1_payload_len      (io_inputs_1_aw_payload_len[7:0]           ), //i
    .io_inputs_1_payload_size     (io_inputs_1_aw_payload_size[2:0]          ), //i
    .io_inputs_1_payload_burst    (io_inputs_1_aw_payload_burst[1:0]         ), //i
    .io_inputs_1_payload_lock     (io_inputs_1_aw_payload_lock               ), //i
    .io_inputs_1_payload_cache    (io_inputs_1_aw_payload_cache[3:0]         ), //i
    .io_inputs_1_payload_qos      (io_inputs_1_aw_payload_qos[3:0]           ), //i
    .io_output_valid              (cmdArbiter_io_output_valid                ), //o
    .io_output_ready              (cmdArbiter_io_output_fork_io_input_ready  ), //i
    .io_output_payload_addr       (cmdArbiter_io_output_payload_addr[31:0]   ), //o
    .io_output_payload_id         (cmdArbiter_io_output_payload_id[6:0]      ), //o
    .io_output_payload_len        (cmdArbiter_io_output_payload_len[7:0]     ), //o
    .io_output_payload_size       (cmdArbiter_io_output_payload_size[2:0]    ), //o
    .io_output_payload_burst      (cmdArbiter_io_output_payload_burst[1:0]   ), //o
    .io_output_payload_lock       (cmdArbiter_io_output_payload_lock         ), //o
    .io_output_payload_cache      (cmdArbiter_io_output_payload_cache[3:0]   ), //o
    .io_output_payload_qos        (cmdArbiter_io_output_payload_qos[3:0]     ), //o
    .io_chosen                    (cmdArbiter_io_chosen                      ), //o
    .io_chosenOH                  (cmdArbiter_io_chosenOH[1:0]               ), //o
    .clk                          (clk                                       ), //i
    .reset                        (reset                                     )  //i
  );
  StreamFork cmdArbiter_io_output_fork (
    .io_input_valid                (cmdArbiter_io_output_valid                                 ), //i
    .io_input_ready                (cmdArbiter_io_output_fork_io_input_ready                   ), //o
    .io_input_payload_addr         (cmdArbiter_io_output_payload_addr[31:0]                    ), //i
    .io_input_payload_id           (cmdArbiter_io_output_payload_id[6:0]                       ), //i
    .io_input_payload_len          (cmdArbiter_io_output_payload_len[7:0]                      ), //i
    .io_input_payload_size         (cmdArbiter_io_output_payload_size[2:0]                     ), //i
    .io_input_payload_burst        (cmdArbiter_io_output_payload_burst[1:0]                    ), //i
    .io_input_payload_lock         (cmdArbiter_io_output_payload_lock                          ), //i
    .io_input_payload_cache        (cmdArbiter_io_output_payload_cache[3:0]                    ), //i
    .io_input_payload_qos          (cmdArbiter_io_output_payload_qos[3:0]                      ), //i
    .io_outputs_0_valid            (cmdArbiter_io_output_fork_io_outputs_0_valid               ), //o
    .io_outputs_0_ready            (io_output_aw_ready                                         ), //i
    .io_outputs_0_payload_addr     (cmdArbiter_io_output_fork_io_outputs_0_payload_addr[31:0]  ), //o
    .io_outputs_0_payload_id       (cmdArbiter_io_output_fork_io_outputs_0_payload_id[6:0]     ), //o
    .io_outputs_0_payload_len      (cmdArbiter_io_output_fork_io_outputs_0_payload_len[7:0]    ), //o
    .io_outputs_0_payload_size     (cmdArbiter_io_output_fork_io_outputs_0_payload_size[2:0]   ), //o
    .io_outputs_0_payload_burst    (cmdArbiter_io_output_fork_io_outputs_0_payload_burst[1:0]  ), //o
    .io_outputs_0_payload_lock     (cmdArbiter_io_output_fork_io_outputs_0_payload_lock        ), //o
    .io_outputs_0_payload_cache    (cmdArbiter_io_output_fork_io_outputs_0_payload_cache[3:0]  ), //o
    .io_outputs_0_payload_qos      (cmdArbiter_io_output_fork_io_outputs_0_payload_qos[3:0]    ), //o
    .io_outputs_1_valid            (cmdArbiter_io_output_fork_io_outputs_1_valid               ), //o
    .io_outputs_1_ready            (cmdArbiter_io_output_fork_io_outputs_1_translated_ready    ), //i
    .io_outputs_1_payload_addr     (cmdArbiter_io_output_fork_io_outputs_1_payload_addr[31:0]  ), //o
    .io_outputs_1_payload_id       (cmdArbiter_io_output_fork_io_outputs_1_payload_id[6:0]     ), //o
    .io_outputs_1_payload_len      (cmdArbiter_io_output_fork_io_outputs_1_payload_len[7:0]    ), //o
    .io_outputs_1_payload_size     (cmdArbiter_io_output_fork_io_outputs_1_payload_size[2:0]   ), //o
    .io_outputs_1_payload_burst    (cmdArbiter_io_output_fork_io_outputs_1_payload_burst[1:0]  ), //o
    .io_outputs_1_payload_lock     (cmdArbiter_io_output_fork_io_outputs_1_payload_lock        ), //o
    .io_outputs_1_payload_cache    (cmdArbiter_io_output_fork_io_outputs_1_payload_cache[3:0]  ), //o
    .io_outputs_1_payload_qos      (cmdArbiter_io_output_fork_io_outputs_1_payload_qos[3:0]    ), //o
    .clk                           (clk                                                        ), //i
    .reset                         (reset                                                      )  //i
  );
  StreamFifoLowLatency cmdArbiter_io_output_fork_io_outputs_1_translated_fifo (
    .io_push_valid      (cmdArbiter_io_output_fork_io_outputs_1_translated_valid                   ), //i
    .io_push_ready      (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_push_ready      ), //o
    .io_push_payload    (cmdArbiter_io_output_fork_io_outputs_1_translated_payload                 ), //i
    .io_pop_valid       (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_valid       ), //o
    .io_pop_ready       (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_ready       ), //i
    .io_pop_payload     (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_payload     ), //o
    .io_flush           (1'b0                                                                      ), //i
    .io_occupancy       (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_occupancy[2:0]  ), //o
    .clk                (clk                                                                       ), //i
    .reset              (reset                                                                     )  //i
  );
  always @(*) begin
    case(cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_payload)
      1'b0 : begin
        _zz_io_output_w_valid = io_inputs_0_w_valid;
        _zz_io_output_w_payload_data = io_inputs_0_w_payload_data;
        _zz_io_output_w_payload_strb = io_inputs_0_w_payload_strb;
        _zz_io_output_w_payload_last = io_inputs_0_w_payload_last;
      end
      default : begin
        _zz_io_output_w_valid = io_inputs_1_w_valid;
        _zz_io_output_w_payload_data = io_inputs_1_w_payload_data;
        _zz_io_output_w_payload_strb = io_inputs_1_w_payload_strb;
        _zz_io_output_w_payload_last = io_inputs_1_w_payload_last;
      end
    endcase
  end

  always @(*) begin
    case(writeRspIndex)
      1'b0 : _zz_io_output_b_ready = io_inputs_0_b_ready;
      default : _zz_io_output_b_ready = io_inputs_1_b_ready;
    endcase
  end

  assign io_inputs_0_aw_ready = cmdArbiter_io_inputs_0_ready;
  assign io_inputs_1_aw_ready = cmdArbiter_io_inputs_1_ready;
  assign io_output_aw_valid = cmdArbiter_io_output_fork_io_outputs_0_valid;
  assign io_output_aw_payload_addr = cmdArbiter_io_output_fork_io_outputs_0_payload_addr;
  assign io_output_aw_payload_len = cmdArbiter_io_output_fork_io_outputs_0_payload_len;
  assign io_output_aw_payload_size = cmdArbiter_io_output_fork_io_outputs_0_payload_size;
  assign io_output_aw_payload_burst = cmdArbiter_io_output_fork_io_outputs_0_payload_burst;
  assign io_output_aw_payload_lock = cmdArbiter_io_output_fork_io_outputs_0_payload_lock;
  assign io_output_aw_payload_cache = cmdArbiter_io_output_fork_io_outputs_0_payload_cache;
  assign io_output_aw_payload_qos = cmdArbiter_io_output_fork_io_outputs_0_payload_qos;
  assign io_output_aw_payload_id = {cmdArbiter_io_chosen,cmdArbiter_io_output_payload_id};
  assign cmdArbiter_io_output_fork_io_outputs_1_translated_valid = cmdArbiter_io_output_fork_io_outputs_1_valid;
  assign cmdArbiter_io_output_fork_io_outputs_1_translated_payload = cmdArbiter_io_chosen;
  assign cmdArbiter_io_output_fork_io_outputs_1_translated_ready = cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_push_ready;
  assign io_output_w_valid = (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_valid && _zz_io_output_w_valid);
  assign io_output_w_payload_data = _zz_io_output_w_payload_data;
  assign io_output_w_payload_strb = _zz_io_output_w_payload_strb;
  assign io_output_w_payload_last = _zz_io_output_w_payload_last;
  assign io_inputs_0_w_ready = ((cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_valid && io_output_w_ready) && (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_payload == 1'b0));
  assign io_inputs_1_w_ready = ((cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_valid && io_output_w_ready) && (cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_payload == 1'b1));
  assign io_output_w_fire = (io_output_w_valid && io_output_w_ready);
  assign cmdArbiter_io_output_fork_io_outputs_1_translated_fifo_io_pop_ready = (io_output_w_fire && io_output_w_payload_last);
  assign writeRspIndex = io_output_b_payload_id[7 : 7];
  assign writeRspSels_0 = (writeRspIndex == 1'b0);
  assign writeRspSels_1 = (writeRspIndex == 1'b1);
  assign io_inputs_0_b_valid = (io_output_b_valid && writeRspSels_0);
  assign io_inputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_inputs_0_b_payload_id = io_output_b_payload_id[6 : 0];
  assign io_inputs_1_b_valid = (io_output_b_valid && writeRspSels_1);
  assign io_inputs_1_b_payload_resp = io_output_b_payload_resp;
  assign io_inputs_1_b_payload_id = io_output_b_payload_id[6 : 0];
  assign io_output_b_ready = _zz_io_output_b_ready;

endmodule

module Axi4ReadOnlyArbiter (
  input               io_inputs_0_ar_valid,
  output              io_inputs_0_ar_ready,
  input      [31:0]   io_inputs_0_ar_payload_addr,
  input      [6:0]    io_inputs_0_ar_payload_id,
  input      [7:0]    io_inputs_0_ar_payload_len,
  input      [2:0]    io_inputs_0_ar_payload_size,
  input      [1:0]    io_inputs_0_ar_payload_burst,
  input      [0:0]    io_inputs_0_ar_payload_lock,
  input      [3:0]    io_inputs_0_ar_payload_cache,
  input      [3:0]    io_inputs_0_ar_payload_qos,
  output              io_inputs_0_r_valid,
  input               io_inputs_0_r_ready,
  output     [511:0]  io_inputs_0_r_payload_data,
  output     [6:0]    io_inputs_0_r_payload_id,
  output     [1:0]    io_inputs_0_r_payload_resp,
  output              io_inputs_0_r_payload_last,
  input               io_inputs_1_ar_valid,
  output              io_inputs_1_ar_ready,
  input      [31:0]   io_inputs_1_ar_payload_addr,
  input      [6:0]    io_inputs_1_ar_payload_id,
  input      [7:0]    io_inputs_1_ar_payload_len,
  input      [2:0]    io_inputs_1_ar_payload_size,
  input      [1:0]    io_inputs_1_ar_payload_burst,
  input      [0:0]    io_inputs_1_ar_payload_lock,
  input      [3:0]    io_inputs_1_ar_payload_cache,
  input      [3:0]    io_inputs_1_ar_payload_qos,
  output              io_inputs_1_r_valid,
  input               io_inputs_1_r_ready,
  output     [511:0]  io_inputs_1_r_payload_data,
  output     [6:0]    io_inputs_1_r_payload_id,
  output     [1:0]    io_inputs_1_r_payload_resp,
  output              io_inputs_1_r_payload_last,
  output              io_output_ar_valid,
  input               io_output_ar_ready,
  output     [31:0]   io_output_ar_payload_addr,
  output     [7:0]    io_output_ar_payload_id,
  output     [7:0]    io_output_ar_payload_len,
  output     [2:0]    io_output_ar_payload_size,
  output     [1:0]    io_output_ar_payload_burst,
  output     [0:0]    io_output_ar_payload_lock,
  output     [3:0]    io_output_ar_payload_cache,
  output     [3:0]    io_output_ar_payload_qos,
  input               io_output_r_valid,
  output              io_output_r_ready,
  input      [511:0]  io_output_r_payload_data,
  input      [7:0]    io_output_r_payload_id,
  input      [1:0]    io_output_r_payload_resp,
  input               io_output_r_payload_last,
  input               clk,
  input               reset
);

  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [31:0]   cmdArbiter_io_output_payload_addr;
  wire       [6:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire       [0:0]    cmdArbiter_io_output_payload_lock;
  wire       [3:0]    cmdArbiter_io_output_payload_cache;
  wire       [3:0]    cmdArbiter_io_output_payload_qos;
  wire       [0:0]    cmdArbiter_io_chosen;
  wire       [1:0]    cmdArbiter_io_chosenOH;
  reg                 _zz_io_output_r_ready;
  wire       [0:0]    readRspIndex;
  wire                readRspSels_0;
  wire                readRspSels_1;

  StreamArbiter cmdArbiter (
    .io_inputs_0_valid            (io_inputs_0_ar_valid                     ), //i
    .io_inputs_0_ready            (cmdArbiter_io_inputs_0_ready             ), //o
    .io_inputs_0_payload_addr     (io_inputs_0_ar_payload_addr[31:0]        ), //i
    .io_inputs_0_payload_id       (io_inputs_0_ar_payload_id[6:0]           ), //i
    .io_inputs_0_payload_len      (io_inputs_0_ar_payload_len[7:0]          ), //i
    .io_inputs_0_payload_size     (io_inputs_0_ar_payload_size[2:0]         ), //i
    .io_inputs_0_payload_burst    (io_inputs_0_ar_payload_burst[1:0]        ), //i
    .io_inputs_0_payload_lock     (io_inputs_0_ar_payload_lock              ), //i
    .io_inputs_0_payload_cache    (io_inputs_0_ar_payload_cache[3:0]        ), //i
    .io_inputs_0_payload_qos      (io_inputs_0_ar_payload_qos[3:0]          ), //i
    .io_inputs_1_valid            (io_inputs_1_ar_valid                     ), //i
    .io_inputs_1_ready            (cmdArbiter_io_inputs_1_ready             ), //o
    .io_inputs_1_payload_addr     (io_inputs_1_ar_payload_addr[31:0]        ), //i
    .io_inputs_1_payload_id       (io_inputs_1_ar_payload_id[6:0]           ), //i
    .io_inputs_1_payload_len      (io_inputs_1_ar_payload_len[7:0]          ), //i
    .io_inputs_1_payload_size     (io_inputs_1_ar_payload_size[2:0]         ), //i
    .io_inputs_1_payload_burst    (io_inputs_1_ar_payload_burst[1:0]        ), //i
    .io_inputs_1_payload_lock     (io_inputs_1_ar_payload_lock              ), //i
    .io_inputs_1_payload_cache    (io_inputs_1_ar_payload_cache[3:0]        ), //i
    .io_inputs_1_payload_qos      (io_inputs_1_ar_payload_qos[3:0]          ), //i
    .io_output_valid              (cmdArbiter_io_output_valid               ), //o
    .io_output_ready              (io_output_ar_ready                       ), //i
    .io_output_payload_addr       (cmdArbiter_io_output_payload_addr[31:0]  ), //o
    .io_output_payload_id         (cmdArbiter_io_output_payload_id[6:0]     ), //o
    .io_output_payload_len        (cmdArbiter_io_output_payload_len[7:0]    ), //o
    .io_output_payload_size       (cmdArbiter_io_output_payload_size[2:0]   ), //o
    .io_output_payload_burst      (cmdArbiter_io_output_payload_burst[1:0]  ), //o
    .io_output_payload_lock       (cmdArbiter_io_output_payload_lock        ), //o
    .io_output_payload_cache      (cmdArbiter_io_output_payload_cache[3:0]  ), //o
    .io_output_payload_qos        (cmdArbiter_io_output_payload_qos[3:0]    ), //o
    .io_chosen                    (cmdArbiter_io_chosen                     ), //o
    .io_chosenOH                  (cmdArbiter_io_chosenOH[1:0]              ), //o
    .clk                          (clk                                      ), //i
    .reset                        (reset                                    )  //i
  );
  always @(*) begin
    case(readRspIndex)
      1'b0 : _zz_io_output_r_ready = io_inputs_0_r_ready;
      default : _zz_io_output_r_ready = io_inputs_1_r_ready;
    endcase
  end

  assign io_inputs_0_ar_ready = cmdArbiter_io_inputs_0_ready;
  assign io_inputs_1_ar_ready = cmdArbiter_io_inputs_1_ready;
  assign io_output_ar_valid = cmdArbiter_io_output_valid;
  assign io_output_ar_payload_addr = cmdArbiter_io_output_payload_addr;
  assign io_output_ar_payload_len = cmdArbiter_io_output_payload_len;
  assign io_output_ar_payload_size = cmdArbiter_io_output_payload_size;
  assign io_output_ar_payload_burst = cmdArbiter_io_output_payload_burst;
  assign io_output_ar_payload_lock = cmdArbiter_io_output_payload_lock;
  assign io_output_ar_payload_cache = cmdArbiter_io_output_payload_cache;
  assign io_output_ar_payload_qos = cmdArbiter_io_output_payload_qos;
  assign io_output_ar_payload_id = {cmdArbiter_io_chosen,cmdArbiter_io_output_payload_id};
  assign readRspIndex = io_output_r_payload_id[7 : 7];
  assign readRspSels_0 = (readRspIndex == 1'b0);
  assign readRspSels_1 = (readRspIndex == 1'b1);
  assign io_inputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_inputs_0_r_payload_data = io_output_r_payload_data;
  assign io_inputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_inputs_0_r_payload_last = io_output_r_payload_last;
  assign io_inputs_0_r_payload_id = io_output_r_payload_id[6 : 0];
  assign io_inputs_1_r_valid = (io_output_r_valid && readRspSels_1);
  assign io_inputs_1_r_payload_data = io_output_r_payload_data;
  assign io_inputs_1_r_payload_resp = io_output_r_payload_resp;
  assign io_inputs_1_r_payload_last = io_output_r_payload_last;
  assign io_inputs_1_r_payload_id = io_output_r_payload_id[6 : 0];
  assign io_output_r_ready = _zz_io_output_r_ready;

endmodule

//Axi4WriteOnlyDecoder replaced by Axi4WriteOnlyDecoder

//Axi4ReadOnlyDecoder replaced by Axi4ReadOnlyDecoder

module Axi4WriteOnlyDecoder (
  input               io_input_aw_valid,
  output              io_input_aw_ready,
  input      [31:0]   io_input_aw_payload_addr,
  input      [3:0]    io_input_aw_payload_id,
  input      [7:0]    io_input_aw_payload_len,
  input      [2:0]    io_input_aw_payload_size,
  input      [1:0]    io_input_aw_payload_burst,
  input      [0:0]    io_input_aw_payload_lock,
  input      [3:0]    io_input_aw_payload_cache,
  input      [3:0]    io_input_aw_payload_qos,
  input               io_input_w_valid,
  output              io_input_w_ready,
  input      [511:0]  io_input_w_payload_data,
  input      [63:0]   io_input_w_payload_strb,
  input               io_input_w_payload_last,
  output              io_input_b_valid,
  input               io_input_b_ready,
  output     [3:0]    io_input_b_payload_id,
  output     [1:0]    io_input_b_payload_resp,
  output              io_outputs_0_aw_valid,
  input               io_outputs_0_aw_ready,
  output     [31:0]   io_outputs_0_aw_payload_addr,
  output     [3:0]    io_outputs_0_aw_payload_id,
  output     [7:0]    io_outputs_0_aw_payload_len,
  output     [2:0]    io_outputs_0_aw_payload_size,
  output     [1:0]    io_outputs_0_aw_payload_burst,
  output     [0:0]    io_outputs_0_aw_payload_lock,
  output     [3:0]    io_outputs_0_aw_payload_cache,
  output     [3:0]    io_outputs_0_aw_payload_qos,
  output              io_outputs_0_w_valid,
  input               io_outputs_0_w_ready,
  output     [511:0]  io_outputs_0_w_payload_data,
  output     [63:0]   io_outputs_0_w_payload_strb,
  output              io_outputs_0_w_payload_last,
  input               io_outputs_0_b_valid,
  output              io_outputs_0_b_ready,
  input      [3:0]    io_outputs_0_b_payload_id,
  input      [1:0]    io_outputs_0_b_payload_resp,
  input               clk,
  input               reset
);

  wire                cmdAllowedStart;
  wire                io_input_aw_fire;
  wire                io_input_b_fire;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l640;
  wire                when_Utils_l642;
  wire                io_input_w_fire;
  wire                when_Utils_l615;
  reg                 pendingDataCounter_incrementIt;
  reg                 pendingDataCounter_decrementIt;
  wire       [2:0]    pendingDataCounter_valueNext;
  reg        [2:0]    pendingDataCounter_value;
  wire                pendingDataCounter_willOverflowIfInc;
  wire                pendingDataCounter_willOverflow;
  reg        [2:0]    pendingDataCounter_finalIncrement;
  wire                when_Utils_l640_1;
  wire                when_Utils_l642_1;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;
  wire                allowData;
  reg                 _zz_cmdAllowedStart;

  assign io_input_aw_fire = (io_input_aw_valid && io_input_aw_ready);
  assign io_input_b_fire = (io_input_b_valid && io_input_b_ready);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_aw_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(io_input_b_fire) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_willOverflowIfInc = ((pendingCmdCounter_value == 3'b111) && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign when_Utils_l640 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l640) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l642) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l642 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign io_input_w_fire = (io_input_w_valid && io_input_w_ready);
  assign when_Utils_l615 = (io_input_w_fire && io_input_w_payload_last);
  always @(*) begin
    pendingDataCounter_incrementIt = 1'b0;
    if(cmdAllowedStart) begin
      pendingDataCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingDataCounter_decrementIt = 1'b0;
    if(when_Utils_l615) begin
      pendingDataCounter_decrementIt = 1'b1;
    end
  end

  assign pendingDataCounter_willOverflowIfInc = ((pendingDataCounter_value == 3'b111) && (! pendingDataCounter_decrementIt));
  assign pendingDataCounter_willOverflow = (pendingDataCounter_willOverflowIfInc && pendingDataCounter_incrementIt);
  assign when_Utils_l640_1 = (pendingDataCounter_incrementIt && (! pendingDataCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l640_1) begin
      pendingDataCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l642_1) begin
        pendingDataCounter_finalIncrement = 3'b111;
      end else begin
        pendingDataCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l642_1 = ((! pendingDataCounter_incrementIt) && pendingDataCounter_decrementIt);
  assign pendingDataCounter_valueNext = (pendingDataCounter_value + pendingDataCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_aw_payload_addr & (~ 32'hffffffff)) == 32'h0) && io_input_aw_valid);
  assign decodedCmdError = (decodedCmdSels == 1'b0);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign allowData = (pendingDataCounter_value != 3'b000);
  assign cmdAllowedStart = ((io_input_aw_valid && allowCmd) && _zz_cmdAllowedStart);
  assign io_input_aw_ready = (((|(decodedCmdSels & io_outputs_0_aw_ready)) || 1'b0) && allowCmd);
  assign io_outputs_0_aw_valid = ((io_input_aw_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_aw_payload_addr = io_input_aw_payload_addr;
  assign io_outputs_0_aw_payload_id = io_input_aw_payload_id;
  assign io_outputs_0_aw_payload_len = io_input_aw_payload_len;
  assign io_outputs_0_aw_payload_size = io_input_aw_payload_size;
  assign io_outputs_0_aw_payload_burst = io_input_aw_payload_burst;
  assign io_outputs_0_aw_payload_lock = io_input_aw_payload_lock;
  assign io_outputs_0_aw_payload_cache = io_input_aw_payload_cache;
  assign io_outputs_0_aw_payload_qos = io_input_aw_payload_qos;
  assign io_input_w_ready = (((|(pendingSels & io_outputs_0_w_ready)) || 1'b0) && allowData);
  assign io_outputs_0_w_valid = ((io_input_w_valid && pendingSels[0]) && allowData);
  assign io_outputs_0_w_payload_data = io_input_w_payload_data;
  assign io_outputs_0_w_payload_strb = io_input_w_payload_strb;
  assign io_outputs_0_w_payload_last = io_input_w_payload_last;
  assign io_input_b_valid = ((|io_outputs_0_b_valid) || 1'b0);
  assign io_input_b_payload_id = io_outputs_0_b_payload_id;
  assign io_input_b_payload_resp = io_outputs_0_b_payload_resp;
  assign io_outputs_0_b_ready = io_input_b_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingDataCounter_value <= 3'b000;
      pendingSels <= 1'b0;
      pendingError <= 1'b0;
      _zz_cmdAllowedStart <= 1'b1;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      pendingDataCounter_value <= pendingDataCounter_valueNext;
      if(cmdAllowedStart) begin
        pendingSels <= decodedCmdSels;
      end
      if(cmdAllowedStart) begin
        pendingError <= decodedCmdError;
      end
      if(cmdAllowedStart) begin
        _zz_cmdAllowedStart <= 1'b0;
      end
      if(io_input_aw_ready) begin
        _zz_cmdAllowedStart <= 1'b1;
      end
    end
  end


endmodule

module Axi4ReadOnlyDecoder (
  input               io_input_ar_valid,
  output              io_input_ar_ready,
  input      [31:0]   io_input_ar_payload_addr,
  input      [3:0]    io_input_ar_payload_id,
  input      [7:0]    io_input_ar_payload_len,
  input      [2:0]    io_input_ar_payload_size,
  input      [1:0]    io_input_ar_payload_burst,
  input      [0:0]    io_input_ar_payload_lock,
  input      [3:0]    io_input_ar_payload_cache,
  input      [3:0]    io_input_ar_payload_qos,
  output              io_input_r_valid,
  input               io_input_r_ready,
  output     [511:0]  io_input_r_payload_data,
  output     [3:0]    io_input_r_payload_id,
  output     [1:0]    io_input_r_payload_resp,
  output              io_input_r_payload_last,
  output              io_outputs_0_ar_valid,
  input               io_outputs_0_ar_ready,
  output     [31:0]   io_outputs_0_ar_payload_addr,
  output     [3:0]    io_outputs_0_ar_payload_id,
  output     [7:0]    io_outputs_0_ar_payload_len,
  output     [2:0]    io_outputs_0_ar_payload_size,
  output     [1:0]    io_outputs_0_ar_payload_burst,
  output     [0:0]    io_outputs_0_ar_payload_lock,
  output     [3:0]    io_outputs_0_ar_payload_cache,
  output     [3:0]    io_outputs_0_ar_payload_qos,
  input               io_outputs_0_r_valid,
  output              io_outputs_0_r_ready,
  input      [511:0]  io_outputs_0_r_payload_data,
  input      [3:0]    io_outputs_0_r_payload_id,
  input      [1:0]    io_outputs_0_r_payload_resp,
  input               io_outputs_0_r_payload_last,
  input               clk,
  input               reset
);

  wire                io_input_ar_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l615;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l640;
  wire                when_Utils_l642;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;

  assign io_input_ar_fire = (io_input_ar_valid && io_input_ar_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l615 = (io_input_r_fire && io_input_r_payload_last);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_ar_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(when_Utils_l615) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_willOverflowIfInc = ((pendingCmdCounter_value == 3'b111) && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign when_Utils_l640 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l640) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l642) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l642 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_ar_payload_addr & (~ 32'hffffffff)) == 32'h0) && io_input_ar_valid);
  assign decodedCmdError = (decodedCmdSels == 1'b0);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign io_input_ar_ready = (((|(decodedCmdSels & io_outputs_0_ar_ready)) || 1'b0) && allowCmd);
  assign io_outputs_0_ar_valid = ((io_input_ar_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_0_ar_payload_id = io_input_ar_payload_id;
  assign io_outputs_0_ar_payload_len = io_input_ar_payload_len;
  assign io_outputs_0_ar_payload_size = io_input_ar_payload_size;
  assign io_outputs_0_ar_payload_burst = io_input_ar_payload_burst;
  assign io_outputs_0_ar_payload_lock = io_input_ar_payload_lock;
  assign io_outputs_0_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_0_ar_payload_qos = io_input_ar_payload_qos;
  assign io_input_r_valid = (|io_outputs_0_r_valid);
  assign io_input_r_payload_data = io_outputs_0_r_payload_data;
  assign io_input_r_payload_id = io_outputs_0_r_payload_id;
  assign io_input_r_payload_resp = io_outputs_0_r_payload_resp;
  assign io_input_r_payload_last = io_outputs_0_r_payload_last;
  assign io_outputs_0_r_ready = io_input_r_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingSels <= 1'b0;
      pendingError <= 1'b0;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      if(io_input_ar_ready) begin
        pendingSels <= decodedCmdSels;
      end
      if(io_input_ar_ready) begin
        pendingError <= decodedCmdError;
      end
    end
  end


endmodule

module StreamFifoLowLatency (
  input               io_push_valid,
  output              io_push_ready,
  input      [0:0]    io_push_payload,
  output reg          io_pop_valid,
  input               io_pop_ready,
  output reg [0:0]    io_pop_payload,
  input               io_flush,
  output     [2:0]    io_occupancy,
  input               clk,
  input               reset
);

  wire       [0:0]    _zz_ram_port0;
  wire       [1:0]    _zz_pushPtr_valueNext;
  wire       [0:0]    _zz_pushPtr_valueNext_1;
  wire       [1:0]    _zz_popPtr_valueNext;
  wire       [0:0]    _zz_popPtr_valueNext_1;
  wire       [0:0]    _zz_ram_port;
  reg                 _zz_1;
  reg                 pushPtr_willIncrement;
  reg                 pushPtr_willClear;
  reg        [1:0]    pushPtr_valueNext;
  reg        [1:0]    pushPtr_value;
  wire                pushPtr_willOverflowIfInc;
  wire                pushPtr_willOverflow;
  reg                 popPtr_willIncrement;
  reg                 popPtr_willClear;
  reg        [1:0]    popPtr_valueNext;
  reg        [1:0]    popPtr_value;
  wire                popPtr_willOverflowIfInc;
  wire                popPtr_willOverflow;
  wire                ptrMatch;
  reg                 risingOccupancy;
  wire                empty;
  wire                full;
  wire                pushing;
  wire                popping;
  wire       [0:0]    readed;
  wire                when_Stream_l1019;
  wire                when_Stream_l1032;
  wire       [1:0]    ptrDif;
  (* ram_style = "distributed" *) reg [0:0] ram [0:3];

  assign _zz_pushPtr_valueNext_1 = pushPtr_willIncrement;
  assign _zz_pushPtr_valueNext = {1'd0, _zz_pushPtr_valueNext_1};
  assign _zz_popPtr_valueNext_1 = popPtr_willIncrement;
  assign _zz_popPtr_valueNext = {1'd0, _zz_popPtr_valueNext_1};
  assign _zz_ram_port = io_push_payload;
  assign _zz_ram_port0 = ram[popPtr_value];
  always @(posedge clk) begin
    if(_zz_1) begin
      ram[pushPtr_value] <= _zz_ram_port;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    pushPtr_willIncrement = 1'b0;
    if(pushing) begin
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    pushPtr_willClear = 1'b0;
    if(io_flush) begin
      pushPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = (pushPtr_value == 2'b11);
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @(*) begin
    pushPtr_valueNext = (pushPtr_value + _zz_pushPtr_valueNext);
    if(pushPtr_willClear) begin
      pushPtr_valueNext = 2'b00;
    end
  end

  always @(*) begin
    popPtr_willIncrement = 1'b0;
    if(popping) begin
      popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    popPtr_willClear = 1'b0;
    if(io_flush) begin
      popPtr_willClear = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = (popPtr_value == 2'b11);
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  always @(*) begin
    popPtr_valueNext = (popPtr_value + _zz_popPtr_valueNext);
    if(popPtr_willClear) begin
      popPtr_valueNext = 2'b00;
    end
  end

  assign ptrMatch = (pushPtr_value == popPtr_value);
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  assign readed = _zz_ram_port0;
  assign when_Stream_l1019 = (! empty);
  always @(*) begin
    if(when_Stream_l1019) begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  always @(*) begin
    if(when_Stream_l1019) begin
      io_pop_payload = readed;
    end else begin
      io_pop_payload = io_push_payload;
    end
  end

  assign when_Stream_l1032 = (pushing != popping);
  assign ptrDif = (pushPtr_value - popPtr_value);
  assign io_occupancy = {(risingOccupancy && ptrMatch),ptrDif};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pushPtr_value <= 2'b00;
      popPtr_value <= 2'b00;
      risingOccupancy <= 1'b0;
    end else begin
      pushPtr_value <= pushPtr_valueNext;
      popPtr_value <= popPtr_valueNext;
      if(when_Stream_l1032) begin
        risingOccupancy <= pushing;
      end
      if(io_flush) begin
        risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module StreamFork (
  input               io_input_valid,
  output reg          io_input_ready,
  input      [31:0]   io_input_payload_addr,
  input      [6:0]    io_input_payload_id,
  input      [7:0]    io_input_payload_len,
  input      [2:0]    io_input_payload_size,
  input      [1:0]    io_input_payload_burst,
  input      [0:0]    io_input_payload_lock,
  input      [3:0]    io_input_payload_cache,
  input      [3:0]    io_input_payload_qos,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output     [31:0]   io_outputs_0_payload_addr,
  output     [6:0]    io_outputs_0_payload_id,
  output     [7:0]    io_outputs_0_payload_len,
  output     [2:0]    io_outputs_0_payload_size,
  output     [1:0]    io_outputs_0_payload_burst,
  output     [0:0]    io_outputs_0_payload_lock,
  output     [3:0]    io_outputs_0_payload_cache,
  output     [3:0]    io_outputs_0_payload_qos,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output     [31:0]   io_outputs_1_payload_addr,
  output     [6:0]    io_outputs_1_payload_id,
  output     [7:0]    io_outputs_1_payload_len,
  output     [2:0]    io_outputs_1_payload_size,
  output     [1:0]    io_outputs_1_payload_burst,
  output     [0:0]    io_outputs_1_payload_lock,
  output     [3:0]    io_outputs_1_payload_cache,
  output     [3:0]    io_outputs_1_payload_qos,
  input               clk,
  input               reset
);

  reg                 _zz_io_outputs_0_valid;
  reg                 _zz_io_outputs_1_valid;
  wire                when_Stream_l825;
  wire                when_Stream_l825_1;
  wire                io_outputs_0_fire;
  wire                io_outputs_1_fire;

  always @(*) begin
    io_input_ready = 1'b1;
    if(when_Stream_l825) begin
      io_input_ready = 1'b0;
    end
    if(when_Stream_l825_1) begin
      io_input_ready = 1'b0;
    end
  end

  assign when_Stream_l825 = ((! io_outputs_0_ready) && _zz_io_outputs_0_valid);
  assign when_Stream_l825_1 = ((! io_outputs_1_ready) && _zz_io_outputs_1_valid);
  assign io_outputs_0_valid = (io_input_valid && _zz_io_outputs_0_valid);
  assign io_outputs_0_payload_addr = io_input_payload_addr;
  assign io_outputs_0_payload_id = io_input_payload_id;
  assign io_outputs_0_payload_len = io_input_payload_len;
  assign io_outputs_0_payload_size = io_input_payload_size;
  assign io_outputs_0_payload_burst = io_input_payload_burst;
  assign io_outputs_0_payload_lock = io_input_payload_lock;
  assign io_outputs_0_payload_cache = io_input_payload_cache;
  assign io_outputs_0_payload_qos = io_input_payload_qos;
  assign io_outputs_0_fire = (io_outputs_0_valid && io_outputs_0_ready);
  assign io_outputs_1_valid = (io_input_valid && _zz_io_outputs_1_valid);
  assign io_outputs_1_payload_addr = io_input_payload_addr;
  assign io_outputs_1_payload_id = io_input_payload_id;
  assign io_outputs_1_payload_len = io_input_payload_len;
  assign io_outputs_1_payload_size = io_input_payload_size;
  assign io_outputs_1_payload_burst = io_input_payload_burst;
  assign io_outputs_1_payload_lock = io_input_payload_lock;
  assign io_outputs_1_payload_cache = io_input_payload_cache;
  assign io_outputs_1_payload_qos = io_input_payload_qos;
  assign io_outputs_1_fire = (io_outputs_1_valid && io_outputs_1_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      _zz_io_outputs_0_valid <= 1'b1;
      _zz_io_outputs_1_valid <= 1'b1;
    end else begin
      if(io_outputs_0_fire) begin
        _zz_io_outputs_0_valid <= 1'b0;
      end
      if(io_outputs_1_fire) begin
        _zz_io_outputs_1_valid <= 1'b0;
      end
      if(io_input_ready) begin
        _zz_io_outputs_0_valid <= 1'b1;
        _zz_io_outputs_1_valid <= 1'b1;
      end
    end
  end


endmodule

//StreamArbiter replaced by StreamArbiter

module StreamArbiter (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input      [31:0]   io_inputs_0_payload_addr,
  input      [6:0]    io_inputs_0_payload_id,
  input      [7:0]    io_inputs_0_payload_len,
  input      [2:0]    io_inputs_0_payload_size,
  input      [1:0]    io_inputs_0_payload_burst,
  input      [0:0]    io_inputs_0_payload_lock,
  input      [3:0]    io_inputs_0_payload_cache,
  input      [3:0]    io_inputs_0_payload_qos,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input      [31:0]   io_inputs_1_payload_addr,
  input      [6:0]    io_inputs_1_payload_id,
  input      [7:0]    io_inputs_1_payload_len,
  input      [2:0]    io_inputs_1_payload_size,
  input      [1:0]    io_inputs_1_payload_burst,
  input      [0:0]    io_inputs_1_payload_lock,
  input      [3:0]    io_inputs_1_payload_cache,
  input      [3:0]    io_inputs_1_payload_qos,
  output              io_output_valid,
  input               io_output_ready,
  output     [31:0]   io_output_payload_addr,
  output     [6:0]    io_output_payload_id,
  output     [7:0]    io_output_payload_len,
  output     [2:0]    io_output_payload_size,
  output     [1:0]    io_output_payload_burst,
  output     [0:0]    io_output_payload_lock,
  output     [3:0]    io_output_payload_cache,
  output     [3:0]    io_output_payload_qos,
  output     [0:0]    io_chosen,
  output     [1:0]    io_chosenOH,
  input               clk,
  input               reset
);

  wire       [3:0]    _zz__zz_maskProposal_0_2;
  wire       [3:0]    _zz__zz_maskProposal_0_2_1;
  wire       [1:0]    _zz__zz_maskProposal_0_2_2;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_maskProposal_0;
  wire       [3:0]    _zz_maskProposal_0_1;
  wire       [3:0]    _zz_maskProposal_0_2;
  wire       [1:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_chosen;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_0,maskLocked_1};
  assign _zz__zz_maskProposal_0_2_1 = {2'd0, _zz__zz_maskProposal_0_2_2};
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_maskProposal_0 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[3 : 2] | _zz_maskProposal_0_2[1 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_output_payload_lock = (maskRouted_0 ? io_inputs_0_payload_lock : io_inputs_1_payload_lock);
  assign io_output_payload_cache = (maskRouted_0 ? io_inputs_0_payload_cache : io_inputs_1_payload_cache);
  assign io_output_payload_qos = (maskRouted_0 ? io_inputs_0_payload_qos : io_inputs_1_payload_qos);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_io_chosen = io_chosenOH[1];
  assign io_chosen = _zz_io_chosen;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule
