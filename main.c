/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 08/16/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <string.h>
#include <eeprom.h>
#include "def.c"
#include "delay.h"

#define LSB 0.0006103515625
#define ADC_VOL_24 1.5
#define ADC_VOL_5 0.44
#define ADC_VOL_8 0.72
#define ADC_VOL_8N 1.5
#define VAR_ERROR  20

// Declare your global variables here
void processSerialNumber();
void processCalibrationApplied();
void processCalibrationChanged();
void read_eeprom_Program1();
void read_eeprom_Program2();
//void processPulseWidthSetting();
void processCuttOff(char);
void processGenerateFout(unsigned char);

void main(void)
{
// Declare your local variables here
      
   //char gainStr[10], offsetStr[10], temp[20];      
   //char * ch_temp;
   unsigned char idx = 0, flow_sample_counter=0, check_stop_process = 0, enableSendingValues = 0,
            samples_diff_ep_flag = 0, ep_sampling_check_flag = 0, empty_pipe_type = NO_EP, ep_detected_cnt = 0;
   
   signed int max_sample = 0, min_sample = 0, last_sample_pos  = 0 , first_sample_pos = 0,last_sample_neg  = 0 , first_sample_neg = 0,temp_max_sample_ep = 0, temp_min_sample_ep = 0,
       max_sample_pulse_pos_ep = 0, min_sample_pulse_neg_ep = 0;
   unsigned int max_count = 0, min_count = 0, curr_max_cnt = 0, curr_min_cnt = 0, curr_sum_max= 0, curr_sum_min = 0,
                ep_max_cnt = 0, ep_min_cnt = 0;
   //signed long int max_samples[20],min_samples[20];
   signed long int sum_max = 0, sum_min = 0; 
   
   unsigned long int sum_diff_counter = 0, cntr = 0;
   
   float sum = 0, sum_avg_max = 0, sum_avg_min = 0, sum_avg_curr_max = 0, sum_avg_curr_min = 0,
        diff_avg_max_min = 0, sum_all_diffs = 0, avg_sum_max = 0, avg_sum_min = 0, avg_curr_sum_min = 0,
        average1 = 0, average2 = 0, curAverage1 = 0, curAverage2 = 0, diff_avg = 0, dbi_measured = 0, accuracyFault = 0, send_array[MAX_ELEMENT_CNT],
        dbi_temp = 0, ceofCurrAvg = 1;  
   float avg_sum_min_arr[SHIFT_LENGHT_MAX],avg_sum_max_arr[SHIFT_LENGHT_MAX],avg_sum_curr_min_arr[SHIFT_LENGHT_MAX],avg_sum_curr_max_arr[SHIFT_LENGHT_MAX];
    char ResetFlags = MCUCSR ;
   static unsigned int wathchdog_counter;  
   init();
     
   // eeprom_write_dword(SERIAL_ADDR,SERIAL_NUMBER);
   // delay_ms(2000);  
    
    read_eeprom_values();
    delay_us(1000);
    time2_init();
      
    send_offset = 0;
    enable_watchdog(); 
    // printf("ResetFlag %x wd %d\n",ResetFlags,wathchdog_counter);
     if (ResetFlags & (1<<3))
        wathchdog_counter++;
     else
        wathchdog_counter = 0;
     
while(1)
      {       
       #asm("WDR");
          
      // Place your code here
        if(wd_test)
        {  
            rx_wr_index = 0;    
            wd_test = 0;
            for (cntr = 0; cntr < 1000000;cntr++);
        } 
  
        if(stopSendingDiffValues == 1)
        {   
            rx_wr_index = 0;  
            startSendingDiffValues = 0;  
            stopSendingDiffValues = 0;
            zeroAdjusting = 0; 
            db_monitoring = 0; 
           // LED_R = 0;
            min_max_cnt_cmd = 0;  
            ep_check_cmd = 0;
            //sendAckResponse();
            //
        }
 
           
 
        if(measure_Q3_calib || measure_Q2_calib || accuracy_measurement)
        {
            rx_wr_index = 0;
        } 
        if(ep_positive_pulse_measurement)
        {       
            temp_max_sample_ep = abs(spi_sampling());   
            //max_samples[ep_max_cnt] = temp_max_sample_ep; 
            //ep_max_cnt++;                          
           // printf("ep %d\n",temp_max_sample_ep);
            if (temp_max_sample_ep > max_sample_pulse_pos_ep )
                max_sample_pulse_pos_ep = temp_max_sample_ep;    
        }
       // */        
        if(ep_negative_pulse_measurement)
        {   
            temp_min_sample_ep = abs(spi_sampling()); 
            //min_samples[ep_min_cnt] = temp_min_sample_ep; 
            //ep_min_cnt++;
            // printf("%d %d\n",temp_min_sample_ep,abs(temp_min_sample_ep));            
            if (temp_min_sample_ep > min_sample_pulse_neg_ep )
                min_sample_pulse_neg_ep = temp_min_sample_ep;
        
        }
        if(current_sample_max) 
        {
           curr_sum_max += read_adc(4); 
           curr_max_cnt++;
        } 
        
        if (read_max_samples)
        {
            max_sample = spi_sampling(); 
            last_sample_pos = max_sample;
            if (max_count == 0)
                first_sample_pos = max_sample;
            sum_max += max_sample;
            max_count++;        
        }
                            
        if(current_sample_min) 
        {
           curr_sum_min += read_adc(4); 
           curr_min_cnt++;
        }                    
        if (read_min_samples)
        {
            min_sample = spi_sampling();
            last_sample_neg = min_sample;
            if(min_count == 0)
               first_sample_neg = min_sample; 
            sum_min += min_sample;
            min_count++;
        }  
        if(ref_sensor_pulse_measurement_stopped)
        {  
            check_stop_process = 1;
        } 
        if(pulse_is_detected)
        {        
            send_array[0] = 0xbb;
            send_array[1] = (float)pulse_edge_cnt;
            sendParamsFloat(send_array,2);         
            pulse_is_detected = 0;
        }   
        ///*
        if(respose_uart_activity && enableSendingValues)
        {                                              
            
            enableSendingValues = 0;
            if(serial_number_applied)
                processSerialNumber();                    

             if(calibration_changed)
                processCalibrationChanged();            

             if(calibration_applied)
                processCalibrationApplied();            
             if(reade2prom1 == 1)
                read_eeprom_Program1();
             if(reade2prom2 == 1)
                read_eeprom_Program2(); 
             if(PulseWidthSettingApplied)
                //processPulseWidthSetting();
                processCuttOff(PULSE_WIDTH_ADDR);
             if(cutt_off_changed)
                processCuttOff(CUTT_OFF_ADDR);
             if(start_fout_test)
                processGenerateFout(1);
             if(stop_fout_test)        
                processGenerateFout(0); 
             if(windowSizeChanged)
                processCuttOff(WINDOW_SIZE_ADDR);  
            if(ep_change_diff_samples_limit_flag)
               processCuttOff(EP_SAMPLES_DIFF_LIMIT_ADDR);
            if(ep_change_pulse_limit_flag)
               processCuttOff(EP_PULSE_MAX_VALUE_LIMIT_ADDR);
            if(inverseSignCmd)
                processCuttOff(SIGN_ADDR);  
             if(wd_monitoring)
               {
                    send_array[0] =  (float)wathchdog_counter;
                    sendParamsFloat(send_array,1); 
                    wd_monitoring = 0;
                    rx_wr_index = 0;
                    //LED_R = 0;
               }
                if (zeroAdjusting == 1)
                {                   
                        rx_wr_index = 0;
                        /*
                        send_array[0] = avg_sum_min;
                        send_array[1] = avg_sum_max; 
                        send_array[2] = avg_curr_sum_min;
                        send_array[3] = avg_curr_sum_max;  
                        send_array[4] = diff_avg_max_min;
                        send_array[5] = ceofCurrAvg; 
                        */ 
                        send_array[0] = avg_sum_min;
                        send_array[1] = avg_sum_max; 
                        send_array[2] = ceofCurrAvg;
                        send_array[3] = avg_curr_sum_max;
                        send_array[4] = dbi_temp;   
                       // send_array[5] = avg_curr_sum_min;
                     //   printf("min %4.3f max %4.3f %4.3f %4.3f %4.3f %4.3f",avg_sum_min,avg_sum_max,avg_curr_sum_min,
                     //       avg_curr_sum_max,diff_avg_max_min,ceofCurrAvg);                                           
                        sendParamsFloat(send_array,5);
                }
                if(db_monitoring)
                {   
                    rx_wr_index = 0;
                    send_f(dbi_temp);
                }
        } 
        //*/
         
        if (sample_ready_flag && max_count !=0 && min_count !=0)
        {    
          // printf("watch_dog timer counter %lu\n",wathchdog_counter);
          if(ep_check_cmd)
            {
                
               // printf("f-lp %d l-fn %d\n",first_sample_pos - last_sample_pos,last_sample_neg-first_sample_neg);
              //  printf("fp %d ls %d f-lp %d ln %d fn %d l-fn%d\n",first_sample_pos,last_sample_pos,first_sample_pos - last_sample_pos,last_sample_neg,first_sample_neg,last_sample_neg-first_sample_neg);
               // printf("mpe %d mne %d\n",max_sample_pulse_pos_ep,min_sample_pulse_neg_ep);
                send_array[0] = first_sample_pos-last_sample_pos;
                send_array[1] = last_sample_neg-first_sample_neg;
                send_array[2] = max_sample_pulse_pos_ep;
                send_array[3] = min_sample_pulse_neg_ep; 
                send_array[4] = empty_pipe_type; 
                //send_array[4] = dbi_temp;
                sendParamsFloat(send_array,5);        
              /*
              // printf("p %d m %d\n",ep_max_cnt,ep_min_cnt);
                
               printf("max samples: ");
                for(i = 0 ; i < 5; i++)
                    printf("[%d]%d",i,max_samples[i]);
                   
                printf("\nmin samples: ");
                for(i = 0 ; i < 10; i++)
                    printf("[%d]%d",i,min_samples[i]);
                printf("\n");
                */
                rx_wr_index = 0; 
            } 
            
            ep_max_cnt = 0;
            ep_min_cnt = 0; 
            
            if (max_sample_pulse_pos_ep < pulseMaxValuesLimit && min_sample_pulse_neg_ep < pulseMaxValuesLimit)
            {
               ep_sampling_check_flag = 1;
               //EMPTY_PIPE = 0;
               //LED = 1;
            }  
            else
            {  
               ep_sampling_check_flag = 0;
               //EMPTY_PIPE = 1;
               //LED = 0;
            }  
            max_sample_pulse_pos_ep = 0;
            min_sample_pulse_neg_ep = 0;  
            //printf("f-lp %d l-fn %d %d\n",first_sample_pos - last_sample_pos,last_sample_neg-first_sample_neg,diffSamplesLimit);
            if( (first_sample_pos - last_sample_pos  > diffSamplesLimit) || (last_sample_neg -first_sample_neg > diffSamplesLimit))
            
                samples_diff_ep_flag = 1;
            else
                samples_diff_ep_flag = 0;        
         /*
         if(serial_number_applied)
            processSerialNumber();                    

         if(calibration_changed)
            processCalibrationChanged();            

         if(calibration_applied)
            processCalibrationApplied();            
        if(reade2prom == 1)
          read_eeprom_Program();
         if(PulseWidthSettingApplied)
            processCuttOff(PULSE_WIDTH_ADDR);//processPulseWidthSetting();
        if(cutt_off_changed)
            processCuttOff(CUTT_OFF_ADDR);
         if(start_fout_test)
            processGenerateFout(1);
         if(stop_fout_test)        
            processGenerateFout(0); 
         if(windowSizeChanged)
            processCuttOff(WINDOW_SIZE_ADDR); 
            */ 
       if(wd_monitoring)
       {
            send_array[0] =  (float)wathchdog_counter;
            sendParamsFloat(send_array,1); 
            wd_monitoring = 0;
            rx_wr_index = 0;
            //LED_R = 0;
       }
       average1 = (float)((sum_max) / (float)max_count);
       average1 *= signValue;   
       average2 = (float)((sum_min) / (float)min_count);
       average2 *= signValue; 
       curAverage1 = (float)((curr_sum_max) / (float)curr_max_cnt);   
       curAverage2 = (float)((curr_sum_min) / (float)curr_min_cnt);  
       if(min_max_cnt_cmd)
       {
            send_array[0] = max_count; 
            send_array[1] = min_count; 
            send_array[2] = curr_max_cnt;
            send_array[3] = curr_min_cnt;
            //printf("min %d max %d\n",max_count,min_count);
            sendParamsFloat(send_array,4);
            rx_wr_index = 0;            
       } 
       //printf("xc %d mc %d\n",max_count,min_count);
       max_count = 0;
       min_count = 0;             
       curr_max_cnt = 0;
       curr_min_cnt = 0;   
       sum_max = 0;
       sum_min = 0;
       curr_sum_max = 0;
       curr_sum_min = 0;
      // sample_ready_flag = 0;        
       //if(CALIB_PROCESSING == 0)
       //{  
          if(ref_sensor_pulse_measurement_started)
          {
            diff_avg_max_min = average1 - average2;
            sum_all_diffs += diff_avg_max_min;
            sum_diff_counter++;
            //printf("ovf %lu s %4.1f c %lu p1 %4.3f\n",ovf_timer0_cnt,sum_all_diffs,sum_diff_counter,pulse_duration_1);
          }
          //if(ref_sensor_pulse_measurement_stopped)
          if(check_stop_process)
          {     
            check_stop_process = 0;                
            diff_avg = sum_all_diffs / sum_diff_counter;
            dbi_measured = (pulse_edge_cnt*LITER_PER_PULSE) / (pulse_duration_1);
            //printf("pulse_duration_1 %4.3f pulse_edge_cnt %lu sum_all_diffs %4.4f sum_diff_counter %d diff_avg %4.3f\n",pulse_duration_1,pulse_edge_cnt,sum_all_diffs,sum_diff_counter,diff_avg);
            sum_all_diffs = 0;
            sum_diff_counter = 0;
            diff_avg_max_min = 0;
            ref_sensor_pulse_measurement_stopped = 0;
            ref_sensor_pulse_measurement_started = 0;
            if(measure_Q3_calib_send_data)
            {
               dbi_Q3 = dbi_measured;
               diff_Q3 = diff_avg;
               send_array[0] = dbi_measured; 
               send_array[1] = diff_avg; 
               sendParamsFloat(send_array,2);
               measure_Q3_calib_send_data = 0;
            } 
            if(measure_Q2_calib_send_data)
            { 
               dbi_Q2 = dbi_measured;
               diff_Q2 = diff_avg;
               send_array[0] = dbi_measured; 
               send_array[1] = diff_avg; 
               sendParamsFloat(send_array,2);
               measure_Q2_calib_send_data = 0;
            }
            //sendParamsFloat(dbi_measured,diff_avg);   
            if(accuracy_measurement_send_data)
            {
                dbi_final = (diff_avg - offset)/gain; 
                accuracyFault = ((dbi_final - dbi_measured)/dbi_measured)*100;
                send_array[0] = dbi_measured;
                send_array[1] = dbi_final;
                send_array[2] = accuracyFault;
                send_array[3] = diff_avg;                     
                sendParamsFloat(send_array,4);
                accuracy_measurement_send_data = 0;
            }
               
          }
              
              
           //} //if(CALIB_PROCESSING == 0)
           //else
           //{
                //flow_avg_max[flow_sample_counter] = average1;
                //flow_avg_min[flow_sample_counter] = average2;
            sum_avg_max += average1;
            sum_avg_min += average2;                
            sum_avg_curr_max += curAverage1;                
            sum_avg_curr_min += curAverage2;
            //diff_avg_max_min = average1 - average2; 
            //  printf("windowSize %d %d\n",pulseWidth,1000/(pulseWidth*2));  
            if(flow_sample_counter== (1000/(pulseWidth*2)))//(1000 / (PULSE_DURATION*2 + REST_DURATION*2)))
            {   
                             
                sum=0; 
               //sum_avg_max = 0;
               // sum_avg_min = 0;
                avg_sum_max = 0;
                avg_sum_min = 0;   
                diff_avg_max_min = 0;
                enableSendingValues = 1;  
                /*for(counter=0 ; counter <= flow_sample_counter ; counter++)
                {
                    //sum+=flow[counter];
                    sum_avg_max += flow_avg_max[counter]; 
                  //  printf("flow_avg_max %d %4.3f sum_avg_max % 4.3f\n",counter,flow_avg_max[counter],sum_avg_max);
                    sum_avg_min += flow_avg_min[counter];      
                                                   
                }
                */ 
                                                                                                                                                      
                avg_sum_max = (float)(sum_avg_max/(float)(flow_sample_counter+1.0));
                avg_sum_min = (float)(sum_avg_min/(float)(flow_sample_counter+1.0));  
                avg_curr_sum_max = (float)(sum_avg_curr_max/(float)(flow_sample_counter+1.0));
                avg_curr_sum_min = (float)(sum_avg_curr_min/(float)(flow_sample_counter+1.0));                  
                  
                avg_sum_min_arr[insert_idx] = avg_sum_min;
                avg_sum_max_arr[insert_idx] = avg_sum_max;
                avg_sum_curr_min_arr[insert_idx] = avg_curr_sum_min;
                avg_sum_curr_max_arr[insert_idx] = avg_curr_sum_max;
                    
                if(insert_idx == windowSize - 1)
                    insert_idx = 0;
                else
                    insert_idx++;
                  
                for(idx=0;idx < windowSize; idx++)
                {
                    sum_avg_sum_min += avg_sum_min_arr[idx];
                    sum_avg_sum_max += avg_sum_max_arr[idx];
                    sum_avg_curr_sum_min += avg_sum_curr_min_arr[idx];
                    sum_avg_curr_sum_max += avg_sum_curr_max_arr[idx];
                }  
                //printf("windowsize %d sum_max %4.3f\n",windowSize,sum_avg_curr_sum_max);                               
                avg_sum_min = (float)(sum_avg_sum_min / (float)(windowSize));
                avg_sum_max = (float)(sum_avg_sum_max / (float)(windowSize));
                avg_curr_sum_min = (float)(sum_avg_curr_sum_min / (float)(windowSize));
                avg_curr_sum_max = (float)(sum_avg_curr_sum_max / (float)(windowSize));
                          
               
                                
                diff_avg_max_min = (avg_sum_max - avg_sum_min);///ceofCurrAvg;
                
              /* 
                if (zeroAdjusting == 1)
                {                   
                        rx_wr_index = 0;
                        send_array[0] = avg_sum_min;
                        send_array[1] = avg_sum_max;  
                        send_array[2] = avg_curr_sum_min;
                        send_array[3] = avg_curr_sum_max;  
                        send_array[4] = diff_avg_max_min;
                        send_array[5] = ceofCurrAvg;    
                     //   printf("min %4.3f max %4.3f %4.3f %4.3f %4.3f %4.3f",avg_sum_min,avg_sum_max,avg_curr_sum_min,
                     //       avg_curr_sum_max,diff_avg_max_min,ceofCurrAvg);                                           
                        sendParamsFloat(send_array,2);
                }
                */
                if(startSendingDiffValues)
                {  
                    send_f(diff_avg_max_min);
                    rx_wr_index = 0;  
                }
               if(generate_fout_test == 1)
                {
                    dbi_temp = 10.7;
                    dbi_final = fabs(dbi_temp);
                    if(dbi_temp <= cutt_off)
                        TCCR1B &= 0xF8;
                    else
                    {
                        TCCR1B |= TIMER_PRESCALE;
                        db_changed = 1;
                    }
                }           
		        else if(generate_fout_test  == 0 && gain != 0 && offset != 0)
                {             
                  eeprom_avg_curr_sum_max = eeprom_read_float(CURR_ADDR);
                  ceofCurrAvg = avg_curr_sum_max / eeprom_avg_curr_sum_max;
                  dbi_temp = (diff_avg_max_min - offset)/(gain*ceofCurrAvg);
                  //  if(diff_avg_max_min < (offset / 2.0))
                  //      DIRECTION = 1;
                  //  else
                        
                            
                    dbi_final = fabs(dbi_temp); 
                    if(ep_sampling_check_flag)
                    {
                        empty_pipe_type = PULSE_LEVEL; 
                        //printf("pulse\n");
                        //EMPTY_PIPE = 0;
                        //LED = 1;
                    }
                    else if (dbi_final > (cutt_off/0.8)*31.25*1.3)
                    {
                        empty_pipe_type = DBI_VALUE; 
                        //printf("dbi\n");
                        //EMPTY_PIPE = 0;
                        //LED = 1;
                    }
                    else if(samples_diff_ep_flag)
                    {
                        empty_pipe_type = SAMPLE_DIFF_LEVEL;  
                        //printf("sample\n");
                        //EMPTY_PIPE = 0;
                        //LED = 1;
                    }
                    else
                    {
                        //EMPTY_PIPE = 1;
                        //LED = 0;                            
                        empty_pipe_type = NO_EP;
                    }                                                
                    if(empty_pipe_type != NO_EP)
                    {                       
                        ep_detected_cnt++;
                        if(ep_detected_cnt >= 5)
                        {
                            TCCR1B &= 0xF8;
                            EMPTY_PIPE = 0; 
                            ep_detected_cnt = 0;
                            LED = 1;
                        }                       
                    }
                    else 
                    {   
                        EMPTY_PIPE = 1;
                        LED = 0;
                        ep_detected_cnt = 0;
                        if(dbi_temp < 0)  // check reverse current
                        {              
                            if(dbi_final < cutt_off)
                            {                 
                                DIRECTION = 0;
                                TCCR1B &= 0xF8;
                            }
                            else
                            {    
                                DIRECTION = 1;
                                TCCR1B |= TIMER_PRESCALE;
                                db_changed = 1;
                            }
                        }
                        else  
                        {   
                            DIRECTION = 0;           
                            if(dbi_final < cutt_off)
                                TCCR1B &= 0xF8;
                            else
                            { 
                                TCCR1B |= TIMER_PRESCALE;
                                db_changed = 1;
                            }                        
                        }
                    }
                    
                }
                else               
                {
                    dbi_temp = 0;
                    dbi_final = 0;
                    TCCR1B &= 0xF8;
                } 
                /*
                if(db_monitoring)
                {   
                    rx_wr_index = 0;
                    send_f(dbi_temp);
                }  
                */   
                
                    
                sum_avg_max = 0;                 
                sum_avg_min = 0;                             
                sum_avg_curr_max = 0;                 
                sum_avg_curr_min = 0;
                flow_sample_counter = 0;   
                sum_avg_sum_min = 0;
                sum_avg_sum_max = 0;   
                sum_avg_curr_sum_min = 0;
                sum_avg_curr_sum_max = 0;   
            }
            else
                flow_sample_counter++; 
       //}//if(CALIB_PROCESSING == 0)       
       sample_ready_flag = 0;      
    }//sample_ready_flag 
    else
     sample_ready_flag = 0;            
  }//while(1)
}
void processSerialNumber()
{
    char temp[20];
    char addr = 0;
    unsigned char idx = 0;
    serial_number_applied = 0;  
            
    idx = 0;        
    memset(temp,'\0',20); 
   // send(rx_wr_index);
    // for(index = 0; index < rx_wr_index ; index++)
       // putchar(rx_buffer[index]);
    //   printf("%x,",rx_buffer[index]);  
    addr = SERIAL_ADDR;        
    while(rx_buffer[idx+2] != 0x04 && idx < rx_wr_index)
    {
      temp[idx] = rx_buffer[idx+2];  
      //printf("%c,",temp[idx]);
      //eeprom_write_byte(addr,temp[idx]);
      //addr += 1;
      idx++;
    }       
    //printf("%lu",atol(temp));    
    //if(eeprom_serial_num == SERIAL_NUMBER)
    //{
        eeprom_write_dword(addr,atol(temp));
        eeprom_serial_num = atol(temp);   
    //}
    rx_wr_index = 0; 
    //LED_R = 0;
}
void processCalibrationChanged()
{
    char temp[20];
    char * ch_temp;
    char gainStr[10], offsetStr[10];
    unsigned char idx = 0, len_total = 0, len_gain = 0, len_offset = 0;

    memset(gainStr,'\0',10);
    memset(offsetStr,'\0',10);
    memset(temp,'\0',20);                      
    
    calibration_changed = 0; 
    idx = 0;        
    memset(temp,'\0',20); 
                      

                    
    while(rx_buffer[idx+1] != 0x04 && idx < rx_wr_index)
    {
      temp[idx] = rx_buffer[idx+1];
      idx++;
    }    
   // printf("tempStr %s\n",temp);
    len_total = strlen(temp);
    ch_temp = strchr(temp,',');
    len_gain = ch_temp - temp + 1; 
    memcpy(gainStr,temp + 1, len_gain - 1);
               
    len_offset = len_total - len_gain;
    memcpy(offsetStr, temp + len_gain , len_offset);
    //printf("gainStr %s offsetStr %s\n",gainStr,offsetStr);
    gain = atof(gainStr);
    offset = atof(offsetStr);
    //send_f(gain);
    //send_f(offset); 
    eeprom_write_byte(0,0xBB);
    eeprom_write_float(GAIN_ADDR,gain);
    eeprom_write_float(OFFSET_ADDR,offset);
    eeprom_write_float(CURR_ADDR,avg_curr_sum_max);
                
    rx_wr_index = 0;  
    //TCCR1B |= 0x03;  // start timer1 after calibration  
    delay_ms(1); 
             
    //LED_R = 0; 
}
void processCalibrationApplied()
{
    //unsigned char idx = 0;
    float send_array[2];
    calibration_applied = 0; 
    //idx = 0;        
    gain = (diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_Q2);
    offset = diff_Q3 - gain*dbi_Q3;
            
    //printf("diff_q3 %f dbi_q3 %f diff_Q2 %f dbi_Q2 %f d3-d2 %f Q3-Q2 %f gain %f offset %f\n",
    //        diff_Q3,dbi_Q3,diff_Q2,dbi_Q2,diff_Q3 - diff_Q2,dbi_Q3 - dbi_Q2,(diff_Q3 - diff_Q2)/(dbi_Q3 - dbi_Q2),diff_Q3 - gain*dbi_Q3);
            
    //TCCR1B |= 0x03;  // start timer1 after calibration
    delay_ms(100);
    send_array[0] = gain;
    send_array[1] = offset;
    eeprom_write_byte(0,0xBB);
    eeprom_write_float(GAIN_ADDR,gain);
    eeprom_write_float(OFFSET_ADDR,offset);
    sendParamsFloat(send_array,2);    
    rx_wr_index = 0;   
}
/*
void processPulseWidthSetting()
{
    char temp[20];
    
    char PulseWidthStr[10];
    unsigned char idx = 0, len_gain = 0;
   // printf("avg_curr_sum_max %4.3f %4.3f\n",avg_curr_sum_max,avg_curr_sum_min);
    memset(PulseWidthStr,'\0',10);
    
    PulseWidthSettingApplied = 0; 
    idx = 0;        
    memset(temp,'\0',20); 
                      
    while(rx_buffer[idx+1] != 0x04 && idx < rx_wr_index)
    {
      temp[idx] = rx_buffer[idx+1];
      idx++;
    }    
    len_gain = strlen(temp);
    memcpy(PulseWidthStr,temp + 1, len_gain - 1);
    pulseWidthTemp = atoi(PulseWidthStr);
   // printf("pulseWidthTemp %d\n",pulseWidthTemp);    
                                       
    eeprom_write_byte(PULSE_WIDTH_VALID,0x55);
    eeprom_write_byte(PULSE_WIDTH_ADDR,pulseWidthTemp);
    rx_wr_index = 0;  
    //LED_R = 0;    
}
*/
void read_eeprom_Program1()
{
           unsigned char check_byte; 
           //unsigned long int serial_number = 0;
           //char addr;
           float send_array[4];
           //serial_number = 0;
           rx_wr_index = 0; 
           reade2prom1 = 0;  
           delay_ms(100); 
           check_byte = eeprom_read_byte(0);  
           //serial_number = eeprom_read_dword(SERIAL_ADDR);
           
           //addr = PULSE_WIDTH_ADDR;
           //pulseWidth = eeprom_read_byte(PULSE_WIDTH_ADDR);
           //addr = WINDOW_SIZE_ADDR; 
           //windowSize = eeprom_read_byte(WINDOW_SIZE_ADDR);
           //addr = CUTT_OFF_ADDR;   
           //cutt_off = eeprom_read_float(CUTT_OFF_ADDR); 
            
           if (check_byte != 0xBB)
           {
            offset = 0;
            gain = 0;
           }
           
           send_array[0] = offset;
           send_array[1] = gain;
           send_array[2] = eeprom_serial_num; 
           send_array[3] = eeprom_avg_curr_sum_max;
           /*send_array[3] = cutt_off; 
           send_array[4] = VERSION;
           send_array[6] = pulseWidth;  
           send_array[7] = windowSize;
           send_array[8] = pulseMaxValuesLimit; 
           send_array[9] = diffSamplesLimit;
           send_array[10] = signValue;
           */                       
           sendParamsFloat(send_array,4); 
            //LED_R = 0;
}
void read_eeprom_Program2()
{
            
          float send_array[7];
          reade2prom2 = 0;
          //LED =1;  
           delay_ms(100); 
           ///*
           send_array[0] = VERSION;   
           send_array[1] = pulseWidth;  
           send_array[2] = windowSize;   
           send_array[3] = cutt_off;
           send_array[4] = pulseMaxValuesLimit; 
           send_array[5] = diffSamplesLimit;
           send_array[6] = signValue;  
           sendParamsFloat(send_array,7);
           //*/
          //printf("%4.3f %4.3f %4.3f %4.3f %4.3f %4.3f %4.3f\n",VERSION,(float)pulseWidth,(float)windowSize,(float)cutt_off,(float)pulseMaxValuesLimit,(float)diffSamplesLimit,(float)signValue);
          //printf("read_eeprom"); 
          //LED = 0; 
          rx_wr_index = 0; 
}

void processCuttOff(char addr)
{
    char temp[20];
    unsigned char idx;
    idx = 0;        
    //printf("processCuttOff");
    memset(temp,'\0',20); 
    while(rx_buffer[idx+2] != 0x04 && idx < rx_wr_index)
    {
      temp[idx] = rx_buffer[idx+2];  
      idx++;
    }       
        switch(addr)
        {
            case CUTT_OFF_ADDR:
                cutt_off = atof(temp);   
                cutt_off_changed = 0; 
                eeprom_write_float(addr,atof(temp)); 
                break;
            case WINDOW_SIZE_ADDR:
                windowSizeTemp = atoi(temp);//atof(temp);
                windowSizeChanged = 0; 
                eeprom_write_byte(addr,atoi(temp));
                insert_idx = 0;
                addr = WINDOW_SIZE_VALID_ADDR;
                eeprom_write_byte(addr,0x55);
                break;
            case PULSE_WIDTH_ADDR: 
                PulseWidthSettingApplied = 0;
                pulseWidthTemp = atoi(temp);
                // printf("pulseWidthTemp %d\n",pulseWidthTemp);    
                eeprom_write_byte(PULSE_WIDTH_VALID,0x55);
                eeprom_write_byte(PULSE_WIDTH_ADDR,pulseWidthTemp);
                break;
            case EP_SAMPLES_DIFF_LIMIT_ADDR:     
                ep_change_diff_samples_limit_flag = 0;                  
                diffSamplesLimit = atoi(temp);
                // printf("pulseWidthTemp %d\n",pulseWidthTemp);    
                eeprom_write_byte(EP_SAMPLES_DIFF_LIMIT_VALID_ADDR,0x55);
                eeprom_write_word(EP_SAMPLES_DIFF_LIMIT_ADDR,diffSamplesLimit);
                break;
            case EP_PULSE_MAX_VALUE_LIMIT_ADDR:
                ep_change_pulse_limit_flag = 0;                  
                pulseMaxValuesLimit = atoi(temp);
                //printf("pulseMaxValuesLimit set to %d\n",pulseMaxValuesLimit);    
                eeprom_write_byte(EP_PULSE_MAX_VALUE_LIMIT_VALID_ADDR,0x55);
                                
                eeprom_write_word(EP_PULSE_MAX_VALUE_LIMIT_ADDR,pulseMaxValuesLimit);
                //printf("pulseMaxValuesLimit read back %d\n",eeprom_read_word(EP_PULSE_MAX_VALUE_LIMIT_ADDR));
                break;
            case SIGN_ADDR:  
                inverseSignCmd = 0;
                signValue = -signValue;
                eeprom_write_byte(SIGN_VALID_ADDR,0x55);
                eeprom_write_byte(SIGN_ADDR,signValue);
                break; 
        }
    rx_wr_index = 0; 
    //LED_R = 0;
}
void processGenerateFout(unsigned char value)
{
    start_fout_test = 0;
    stop_fout_test = 0;
    generate_fout_test = value;
    rx_wr_index = 0; 
    //LED_R = 0;
}
