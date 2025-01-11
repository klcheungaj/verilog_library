
`timescale 1ns/100ps

`include "axis_align.sv"

module axis_align_tb ();

`define SETUP #0.5
`define assert_stop(condition, msg) assert(condition) else begin \
    $error(msg); \
    $fatal(1); \
end

parameter PERIOD = 10;
parameter AXIS_DW = 64;
localparam AXIS_KW = ((AXIS_DW-1)>>3)+1;
logic clk = 0;
logic rst = 1;

logic                 s_axis_tvalid = '0;  
logic                 s_axis_tready;
logic   [AXIS_DW-1:0] s_axis_tdata = '0;
logic   [AXIS_KW-1:0] s_axis_tkeep = '0;
logic                 s_axis_tlast = '0;

logic                 m_axis_tready;
logic                 m_axis_tvalid;
logic   [AXIS_DW-1:0] m_axis_tdata;
logic   [AXIS_KW-1:0] m_axis_tkeep;
logic                 m_axis_tlast;


logic [7:0] q_tdata[$];
int q_send_beats[$];
int q_recv_beats[$];
int q_send_keep_cnt[$];
int q_recv_keep_cnt[$];
int burst_cnt = 0;
always #(PERIOD/2) clk = !clk;
integer s1 = 1;
integer s2 = 2;
integer s3 = 3;
integer s4 = 4;
integer s5 = 5;
integer s6 = 6;

axis_align #(
    .AXIS_DW(AXIS_DW)
) u_axis_align (
    .clk(clk),
    .rst(rst),
    .s_axis_tvalid(s_axis_tvalid),  
    .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tlast(s_axis_tlast),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast)
);

initial begin
    // #2000000 $finish;
end

initial begin
    $timeformat(-9, 0, " ns", 10);
    // $dumpfile("wave.vcd");
    // $dumpvars(2);
end

initial begin
    checking();
end

initial begin
    // data_tdata = {64'hA24AA96248F2681C, 64'h1F95B10FACC9DD68, 64'h58AB7254D58BCEB4, 64'h612E059009BDBE04};
    // data_tkeep = {8'h7F, 8'hff, 8'hff, 8'hc0};
    // data_tvalid =  {1'b1, 1'b1, 1'b1, 1'b1};
    #50
    rst = 0;

    wait (burst_cnt >= 2000000);
    #100 
    $display("test ended normally");
    $finish;
end

logic [1:0] state = 0;
int target_send_cnt = 0;
int send_cnt = 0;
always_ff @(posedge clk) begin
    if (rst) begin
        send_cnt <= `SETUP 0;
        s_axis_tdata <= `SETUP '0;
        s_axis_tvalid <= `SETUP '0;
        s_axis_tkeep <= `SETUP '0;
        s_axis_tlast <= `SETUP '0;
    end else begin
        case (state)
        0: begin
            send_cnt <= `SETUP '0;
            s_axis_tdata <= `SETUP '0;
            s_axis_tvalid <=`SETUP '0;
            s_axis_tkeep <= `SETUP '0;
            s_axis_tlast <= `SETUP '0;
            target_send_cnt <= `SETUP ($urandom() % 255) + 1;
            state <= `SETUP 1;
        end

        1: begin
            if (!s_axis_tvalid || (s_axis_tready && s_axis_tvalid)) begin
                s_axis_tdata <= `SETUP {$urandom(), $urandom()};
                s_axis_tvalid <= `SETUP $urandom();
                if (send_cnt + 1 == target_send_cnt) begin // last beat or maybe first beat
                    s_axis_tkeep <= `SETUP rand_ones_rightmost();
                end else if (send_cnt == 0 && !s_axis_tvalid) begin   // first beat 
                    s_axis_tkeep <= `SETUP rand_ones_leftmost();
                end else begin
                    s_axis_tkeep <= `SETUP '1;
                end

                if ((!s_axis_tvalid && send_cnt + 1 == target_send_cnt) ||
                    (s_axis_tready && s_axis_tvalid && send_cnt + 2 == target_send_cnt) ) begin
                    s_axis_tlast <= `SETUP 1;
                end else begin
                    s_axis_tlast <= `SETUP 0;
                end
            end

            if (s_axis_tready && s_axis_tvalid) begin
                send_cnt <= `SETUP send_cnt + 1;
                if (send_cnt + 1 == target_send_cnt) begin
                    state <= `SETUP 0;
                    s_axis_tvalid <= `SETUP '0;
                    s_axis_tlast <= `SETUP 0;
                end
            end
        end

        2: begin

        end

        3: begin

        end
        endcase
    end
end

integer seed = 20;
always_ff @(posedge clk) begin
    if (rst) begin
        m_axis_tready <= 0;
    end else begin
        m_axis_tready <= `SETUP $urandom();
    end
end

function integer count_ones (input [AXIS_KW-1:0] keep);
    count_ones = 0; 
    for (int i = 0 ; i<AXIS_KW ; i=i+1) begin
        if (keep[i] == 1'b1)begin
            count_ones = count_ones + 1;
        end
    end 
endfunction

function logic [AXIS_KW-1:0] push_ones_leftmost([AXIS_KW-1:0] tkeep);
    integer num;
    push_ones_leftmost  = 0;
    num = count_ones(tkeep);
    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
        if (i < num)
            push_ones_leftmost[AXIS_KW-1-i] = 1'b1;
        else
            push_ones_leftmost[AXIS_KW-1-i] = 1'b0;
    end
endfunction

function logic [AXIS_KW-1:0] push_ones_rightmost([AXIS_KW-1:0] tkeep);
    integer num;
    push_ones_rightmost  = 0;
    num = count_ones(tkeep);
    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
        if (i < num)
            push_ones_rightmost[i] = 1'b1;
        else
            push_ones_rightmost[i] = 1'b0;
    end
endfunction

function logic [AXIS_KW-1:0] rand_ones_rightmost();
    integer num;
    rand_ones_rightmost  = 0;
    num = ($urandom() % AXIS_KW) + 1;
    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
        if (i < num)
            rand_ones_rightmost[i] = 1'b1;
        else
            rand_ones_rightmost[i] = 1'b0;
    end
endfunction

function logic [AXIS_KW-1:0] rand_ones_leftmost();
    integer num;
    rand_ones_leftmost  = 0;
    num = ($urandom() % AXIS_KW) + 1;
    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
        if (i < num)
            rand_ones_leftmost[AXIS_KW-1-i] = 1'b1;
        else
            rand_ones_leftmost[AXIS_KW-1-i] = 1'b0;
    end
endfunction

task checking();
    int send_keep_cnt = 0;
    int recv_keep_cnt = 0;
    int recv_beats = 0;
    int send_beats = 0;
    fork
        begin
            recv_keep_cnt = '0;
            recv_beats = '0;
            forever @(posedge clk) begin
                if (m_axis_tvalid && m_axis_tready) begin
                    recv_beats = recv_beats + 1;
                    recv_keep_cnt = recv_keep_cnt + count_ones(m_axis_tkeep);
                    if (m_axis_tlast) begin
                        `assert_stop(m_axis_tkeep == push_ones_rightmost(m_axis_tkeep), "ones of tkeep are not at right for last beat");
                    end else if (recv_beats == 1) begin
                        `assert_stop(m_axis_tkeep == push_ones_leftmost(m_axis_tkeep), "ones of tkeep are not at left for 1st beat");
                    end else begin
                        `assert_stop(m_axis_tkeep == '1, "tkeep should be all one if not first of last transfer");
                    end

                    if (m_axis_tlast) begin
                        $display("[%t] a burst received. Number of beats: %d, Number of kept byte: %d", $realtime, recv_beats, recv_keep_cnt);
                        q_recv_beats.push_back(recv_beats);
                        q_recv_keep_cnt.push_back(recv_keep_cnt);
                        recv_beats = 0;
                        recv_keep_cnt = 0;
                    end
                end
            end
        end

        begin
            send_keep_cnt = 0;
            forever @(posedge clk) begin
                if (s_axis_tvalid && s_axis_tready) begin
                    send_beats = send_beats + 1;
                    send_keep_cnt = send_keep_cnt + count_ones(s_axis_tkeep);
                    if (s_axis_tlast) begin
                        `assert_stop(s_axis_tkeep == push_ones_rightmost(s_axis_tkeep), "ones of tkeep are not at right for last beat");
                    end else if (send_beats == 1) begin
                        `assert_stop(s_axis_tkeep == push_ones_leftmost(s_axis_tkeep), "ones of tkeep are not at left for 1st beat");
                    end else begin
                        `assert_stop(s_axis_tkeep == '1, "tkeep should be all one if not first of last transfer");
                    end

                    if (s_axis_tlast) begin
                        $display("[%t] a burst sent. Number of beats: %d, Number of kept byte: %d", $realtime, send_beats, send_keep_cnt);
                        q_send_beats.push_back(send_beats);
                        q_send_keep_cnt.push_back(send_keep_cnt);
                        send_beats = 0;
                        send_keep_cnt = 0;
                        burst_cnt = burst_cnt + 1;
                    end
                end
            end
        end

        begin
            forever @(posedge clk) begin
                int temp_recv = 0;
                int temp_send = 0;
                if (q_recv_beats.size() != 0) begin
                    temp_recv = q_recv_beats.pop_front();
                    temp_send = q_send_beats.pop_front();
                    `assert_stop(temp_recv == temp_send || temp_recv + 1 == temp_send, 
                                    $sformatf("[%t] number of receive beats (%d) is larger than or too less than number of send beats (%d)", 
                                    $realtime, temp_recv, temp_send));
                end
            end
        end

        begin
            forever @(posedge clk) begin
                int temp_recv = 0;
                int temp_send = 0;
                if (q_recv_keep_cnt.size() != 0) begin
                    temp_recv = q_recv_keep_cnt.pop_front();
                    temp_send = q_send_keep_cnt.pop_front();
                    `assert_stop(temp_recv == temp_send, 
                                    $sformatf("[%t] number of receive keep byte (%d) is different from number of send keep byte (%d)", 
                                    $realtime, temp_recv, temp_send));
                end
            end
        end

        begin
            forever @(posedge clk) begin
                if (s_axis_tvalid && s_axis_tready) begin
                    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
                        if (s_axis_tkeep[i]) begin
                            q_tdata.push_back(s_axis_tdata[i*8 +: 8]);
                        end
                    end
                end
            end
        end

        begin
            logic [7:0] front = 0;
            forever @(posedge clk) begin
                if (m_axis_tvalid && m_axis_tready) begin
                    for (int i=0 ; i<AXIS_KW ; i=i+1) begin
                        if (m_axis_tkeep[i]) begin
                            front = q_tdata.pop_front(); 
                            `assert_stop(m_axis_tdata[i*8 +: 8] == front, 
                                            $sformatf("[%t] m_axis_tdata: %x, index: %d, expected byte: %x", $realtime, m_axis_tdata, i, front));
                        end
                    end
                end
            end
        end

        begin
            forever @(posedge clk) begin
                if (m_axis_tvalid)
                    `assert_stop(m_axis_tkeep != '0, "tkeep should have at least one bit set")
                
                if (s_axis_tvalid)
                    `assert_stop(s_axis_tkeep != '0, "tkeep should have at least one bit set")
            end
        end
        
        begin
            int diff = 0;
            forever @(posedge clk) begin
                diff = q_send_beats.size() - q_recv_beats.size();
                `assert_stop($abs(diff) < 2, "The sizes of send beat queue and receive beat queue differ by more than 1");
                diff = q_send_keep_cnt.size() - q_recv_keep_cnt.size();
                `assert_stop($abs(diff) < 2, "The sizes of send tkeep queue and receive tkeep queue differ by more than 1");
            end
        end
    join
endtask

endmodule
