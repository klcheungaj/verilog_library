#include <iostream>
#include <queue>
#include "assert.h"
#include <vector>
#include <map>
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#include <iomanip>
#include <sys/stat.h>  // mkdir
#include <cmath>  // mkdir
#include <fstream>

#include "Vraw2rgb_tb.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <verilated_fst_sc.h>
#include <systemc.h>

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace std;

SC_MODULE(top_tb) {
    sc_clock            clk;
    sc_signal<bool>     rstn;

    sc_signal<bool>     o_vsync;
    sc_signal<bool>     o_hsync;
    sc_signal<bool>     o_de;
    sc_signal<bool>     o_valid;
    sc_signal<uint32_t> o_x_cnt;
    sc_signal<uint32_t> o_y_cnt;
    sc_signal<uint64_t>    o_rgb;
    
    enum SimState{
        SIM_STATE_IDLE,
        SIM_STATE_RUN,
        SIM_STATE_END_NO_ERR,
        SIM_STATE_END_WITH_ERR
    };

    void showPicture() {
        using namespace cv;
        Mat m = Mat(270, 480, CV_8UC3);
        cout << "memory size: " << memory.size() << endl;
        cout << "Mat size: " << m.size() << endl;
        m.data = memory.data();
        cv::cvtColor(m, m, cv::COLOR_BGR2RGB);
        // memcpy(m.data, memory.data(), 480*270*3);
        cout << memory.data() << endl;
        // imshow("debayer picture", m);
        imwrite("logs/debayer.bmp", m);
    }

private:
    #define TB_ASSERT(condition, message) \
        if (!(condition)) { \
            std::cerr << "Assertion `" #condition "` failed in " << __FILE__ \
                        << " line " << __LINE__ << ": " << message << std::endl; \
            state = SIM_STATE_END_WITH_ERR; \
        }

    vector<uint8_t> memory;
    SimState state;

    uint64_t getAllOnes(uint64_t numOfOne) {
        return ((1ULL << numOfOne) - 1ULL);
    }

    void sequencer() {
        while (true) {//forever begin
            wait(clk.posedge_event()); // @(posedge clk)

            // Apply inputs
            if (sc_time_stamp() < sc_time(100, SC_NS)) {
                rstn = false;  // Assert reset
            } else {
                rstn = true;  // Deassert reset
            }
        }
    }
    
    void monitor() {
        wait(rstn.posedge_event());
        int frame_cnt = 0;
        int y_cnt = 0;
        int x_cnt = 0;
        int64_t clk_cnt = 0;
        bool r1_vsync = o_vsync;
        bool r1_de = o_de;

        while (true) {      // forever begin
            wait(clk.posedge_event()); // @(posedge clk)
            ++clk_cnt;

            if (frame_cnt > 0) {
                state = SIM_STATE_END_NO_ERR;
            }

            if (r1_vsync && !o_vsync) {
                ++frame_cnt;
                cout << "frame count: " << frame_cnt << endl;
            }

            if (r1_de && !o_de) {
                ++y_cnt;
                x_cnt = 0;
            }

            if (o_valid) {
                memcpy(memory.data() + (y_cnt)*(3*480) + x_cnt*(2*3), &o_rgb.read(), 3*2);
                cout << "y count: " << y_cnt << ". ";
                cout << "x count: " << x_cnt <<endl;
                x_cnt += 1;
            }

            if (clk_cnt > 1e6)
                state = SIM_STATE_END_WITH_ERR;

            r1_vsync = o_vsync;
            r1_de = o_de;
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
        std::unique_ptr<Vraw2rgb_tb> &dut,
        size_t max_vsync_cnt
    ) 
    :sc_module(name)
    ,clk("clk", 5, SC_NS, 0.5, 3, SC_NS, true)
    {    
        SC_HAS_PROCESS(top_tb);
        SC_THREAD(sequencer);
        SC_THREAD(monitor);
        dut->clk(clk);
        dut->rstn(rstn);
        dut->o_vsync(o_vsync);
        dut->o_hsync(o_hsync);
        dut->o_de(o_de);
        dut->o_valid(o_valid);
        dut->o_x_cnt(o_x_cnt);
        dut->o_y_cnt(o_y_cnt);
        dut->o_rgb(o_rgb);
        rstn = false;
        memory.resize(480*270*3);

        state = SIM_STATE_IDLE;
    }
};

int sc_main(int argc, char* argv[]) {
    srand (time(NULL));

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
    std::unique_ptr<Vraw2rgb_tb> dut(new Vraw2rgb_tb("dut"));
    std::unique_ptr<top_tb> tb(new top_tb("top_tb", dut, 4));
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
        tb->showPicture();
    }
    tb->print_result();

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
