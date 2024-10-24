////////////////////////////////////////////
// revision       : 1.0
// File generated : 1970-01-01 08:00:00
////////////////////////////////////////////
#pragma once

#define PARAM_NUM_LED              9         
#define PARAM_NUM_DDR              2         
#define PARAM_NUM_CLK              2         
#define PARAM_NUM_MIPI             4         
#define PARAM_NUM_GPIO             12        
#define PARAM_NUM_LVDS0            15        
#define PARAM_NUM_LVDS1            15        
#define PARAM_NUM_XGE              4         

#define REG_PMA_RSTN                              0x0        //index: 0
    #define OFFSET_OSC_TEST_RSTN                  0         
    #define OFFSET_MIPI_RSTN                      1         
    #define OFFSET_GPIO_TEST_RSTN                 2         
    #define OFFSET_MEM_TEST_RSTN                  3         
    #define OFFSET_PM_GPIO_TEST_RSTN              4         
    #define OFFSET_LVDS_TEST_RSTN                 5         
    #define OFFSET_DDR_CFG_RSTN                   6         
    #define OFFSET_PMA_RSTN                       7         
#define REG_XGE_TEST_START                        0x4        //index: 1
    #define OFFSET_MIPI_START                     0         
    #define OFFSET_MEM_START                      1         
    #define OFFSET_XGE_TEST_START                 2         
#define REG_KR_RESTART_TRAINING                   0x8        //index: 2
#define REG_LED                                   0xc        //index: 3
#define REG_MEM_RUN_SEC                           0x10       //index: 4
#define REG_CLK_PASS                              0x14       //index: 5
#define REG_CLK_FAIL                              0x18       //index: 6
#define REG_DDR_CFG_DONE                          0x1c       //index: 7
#define REG_MEM_DONE                              0x24       //index: 9
#define REG_MEM_WR_BANDWIDTH                      0x2c       //index: 11
#define REG_MEM_RD_BANDWIDTH                      0x34       //index: 13
#define REG_MEM_ERROR_DQ_TOTAL                    0x3c       //index: 15
#define REG_GPIO_PASS                             0x44       //index: 17
#define REG_GPIO_FAIL                             0x48       //index: 18
#define REG_MIPI_PASS                             0x4c       //index: 19
#define REG_MIPI_FAIL                             0x5c       //index: 23
#define REG_MIPI_CLK_ACTIVE                       0x6c       //index: 27
#define REG_MIPI_FRAME_VALID                      0x7c       //index: 31
#define REG_LVDS0_PASS                            0x8c       //index: 35
#define REG_LVDS0_TARGET_POINT                    0xc8       //index: 50
    #define OFFSET_LVDS0_START_POINT              0         
    #define OFFSET_LVDS0_END_POINT                8         
    #define OFFSET_LVDS0_TARGET_POINT             16        
#define REG_LVDS0_PASS_CNT_LINE                   0x104      //index: 65
#define REG_LVDS0_FAIL_CNT_LINE                   0x140      //index: 80
#define REG_LVDS1_PASS                            0x17c      //index: 95
#define REG_LVDS1_TARGET_POINT                    0x1b8      //index: 110
    #define OFFSET_LVDS1_START_POINT              0         
    #define OFFSET_LVDS1_END_POINT                8         
    #define OFFSET_LVDS1_TARGET_POINT             16        
#define REG_LVDS1_PASS_CNT_LINE                   0x1f4      //index: 125
#define REG_LVDS1_FAIL_CNT_LINE                   0x230      //index: 140
#define REG_XGE_INIT_DONE                         0x26c      //index: 155
