#include <iostream>
#include <queue>
#include "assert.h"
#include <queue>
#include <map>
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#include <iomanip>
#include <sys/stat.h>  // mkdir
#include <cmath>  // mkdir
#include <fstream>

#include "Vfractional_multiply.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <verilated_fst_sc.h>
#include <systemc.h>

#define IN_BIT 8
#define OUT_BIT 6
#define FRAC_BIT 8
#define Q_BITS 16
#ifndef FACTOR      //may be defined in makefile
    #define FACTOR (16.0f/255.0f)
#endif
using namespace std;

SC_MODULE(top_tb) {
    sc_clock clk;
    sc_signal<bool> rstn;
    sc_signal<uint32_t> din;
    sc_signal<uint32_t> dout;
    sc_signal<uint32_t> frac;
    sc_signal<bool> r1_valid;
    sc_signal<bool> r2_valid;


    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };


private:
    SimState state;
    queue<uint32_t> q_din;
    uint32_t tmp_pt_nbr[8];

    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            std::cerr << sc_time_stamp() << ":  " << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << std::endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }

    bool checkResult(uint32_t din, uint32_t dout, uint32_t frac) {
        bool ret = false;
        float golden = float(din) * FACTOR;
        float dout_float = dout + (float)frac / float(1<<FRAC_BIT);
        ret = fabs(golden - dout_float) < 1/float((1<<FRAC_BIT));
        if (!ret) {
            cout << "din: " << din << ". dout: " << dout << ". fractional part: " << frac << endl; 
            cout << "golden: " << golden << ". received in float: " << dout_float << endl; 
            cout << "maximum allowed error: " << 1/float(1<<FRAC_BIT) << endl;
        }
        return ret;
    }

    void sequencer() {
        while (true) {//forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            if (sc_time_stamp() < sc_time(100, SC_NS)) {
                rstn = false;  // Assert reset
                r1_valid = 0;
                r2_valid = 0;
            } else if (sc_time_stamp() < sc_time(120, SC_NS)) {
                rstn = true;    // deassert reset
            } else {
                uint32_t data = (rand() % (1<<IN_BIT));
                cout << din.read() << endl; 
                din = data;
                q_din.push(data);
                r1_valid = true;
                r2_valid = r1_valid;
            }
        }
    }
    
    void monitor() {
        wait(rstn.posedge_event());

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            if (r2_valid.read()) {
                TB_ASSERT(!q_din.empty(), "Expect result queue is empty" << endl);
                TB_ASSERT(checkResult(q_din.front(), dout.read(), frac.read()), ". Failed");
                q_din.pop();
            }

            
            if (sc_time_stamp() > sc_time(10, SC_MS)) {
                state = SIM_STATE_END_NO_ERR;
            }
        }
    }

public:
    bool has_error() const {
        return state == SIM_STATE_END_WITH_ERR;
    }

    bool is_simulation_end() const {
        return state == SIM_STATE_END_NO_ERR || state == SIM_STATE_END_WITH_ERR;
    }

    void print_result() const {
        cout << "--------------------printing final result----------------\r\n";
    }
    
    top_tb (
        const sc_module_name name,
        std::unique_ptr<Vfractional_multiply> &dut
    ) 
    :sc_module(name)
    ,clk("clk", 5, SC_NS, 0.5, 3, SC_NS, true)
    {    
        SC_HAS_PROCESS(top_tb);
        SC_THREAD(sequencer);
        SC_THREAD(monitor);
        dut->clk(clk);
        dut->rstn(rstn);
        dut->din(din);
        dut->dout(dout);
        dut->frac(frac);

        rstn = false;
        state = SIM_STATE_IDLE;

        cout << "FACTOR macro is " << FACTOR << endl;
    }
};

int sc_main(int argc, char* argv[]) {
    // srand (time(NULL));
    srand (1);

    if (false && argc && argv) {}
    Verilated::debug(0);
    Verilated::randReset(2);
#if VM_TRACE
    Verilated::traceEverOn(true);
#endif
    Verilated::commandArgs(argc, argv);
    ios::sync_with_stdio();
    Verilated::mkdir("logs");
    ofstream tb_log("logs/tb_log.txt", std::ofstream::trunc);
    streambuf *coutbuf = cout.rdbuf(); //save old buf
    cout.rdbuf(tb_log.rdbuf()); //redirect std::cout to out.txt!

    /*  instantiate dut and testbench top   */
    std::unique_ptr<Vfractional_multiply> dut(new Vfractional_multiply("dut"));
    std::unique_ptr<top_tb> tb(new top_tb("top_tb", dut));
    sc_core::sc_start(sc_core::SC_ZERO_TIME);

    const char* flag = nullptr;
    /*  enable tracing  */
#if VM_TRACE
    VerilatedFstSc* tfp = nullptr;
    flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0 == strcmp(flag, "+trace")) {
        printf("Enabling waves into logs/wave.fst...\r\n");
        tfp = new VerilatedFstSc;
        dut->trace(tfp, 99);  // Trace 99 levels of hierarchy
        Verilated::mkdir("logs");
        tfp->open("logs/wave.fst");
    }
#endif

    /*  run simulation  */
    do {
        sc_start(1, SC_NS);
    } while(!Verilated::gotFinish() && !tb->is_simulation_end());
    
    if (tb->has_error()) {
        printf("[error] simulation end early due to error. Simulation time: %s\r\n", sc_time_stamp().to_string().c_str());
    } else {
        printf("[info] simulation end normally. Simulation time: %s\r\n", sc_time_stamp().to_string().c_str());
    }
    tb->print_result();
    sc_start(10, SC_NS);    // run 10ns to capture more waveform

    dut->final();
    cout.rdbuf(coutbuf); //reset to standard output again
#if VM_TRACE
    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }
#endif
    // Coverage analysis (calling write only after the test is known to pass)
#if VM_COVERAGE
    VerilatedCov::write("logs/coverage.dat");
#endif

    // imshow("recover_image", recover_image);
    // waitKey(0);
    return 0;
}
