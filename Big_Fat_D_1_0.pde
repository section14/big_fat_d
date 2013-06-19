#include <Bounce.h>

/* Big fat D version 1.0 */

//trigger out
int gateDataPin_32 = 0;
int gateDataPin_16 = 1;
int gateDataPin_8a = 2;
int gateDataPin_8b = 3;

//sequencer rotary switch
int rotary_32 = 62;
int rotary_16 = 63;
int rotary_8 = 64;

int resetButton = 66;

Bounce bouncer = Bounce(resetButton, 10);

//reset pins
int resetPin32 = 14;
int resetPin16 = 15;
int resetPin8a = 16;
int resetPin8b = 17;

//arrays for keeping commands to ic's in proper place
int step_32_loop[] = {0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};
int step_16_loop[] = {0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};

//dac pins  //////////////////////////////////////////
int clockPin_32 = 47;
int cvDataPin_32 = 46;
int latchPin_32 = 48;
int clockPin_16 = 50;
int cvDataPin_16 = 49;
int latchPin_16 = 51;
int clockPin_8a = 53;
int cvDataPin_8a = 52;
int latchPin_8a = 54;
int clockPin_8b = 56;
int cvDataPin_8b = 55;
int latchPin_8b = 57;

//LED shift registers  /////////////////////////////////
int ledShift_32_clock = 35;
int ledShift_32_data = 34;
int ledShift_32_latch = 36;
int ledShift_16_clock = 38;
int ledShift_16_data = 37;
int ledShift_16_latch = 39;
int ledShift_8a_clock = 41;
int ledShift_8a_data = 40;
int ledShift_8a_latch = 42;
int ledShift_8b_clock = 44;
int ledShift_8b_data = 43;
int ledShift_8b_latch = 45;

//CV multiplexers  ///////////////////////////////////
int s0_32 = 23;
int s1_32 = 22;
int s2_32 = 24;
int r0_32 = 0;
int r1_32 = 0;
int r2_32 = 0;
int row_32 = 0;
int cv_in_32 = 5; //analog read
int bin_32[] = {0,1,2,3,4,5,6,7};

int s0_16 = 26;
int s1_16 = 25;
int s2_16 = 27;
int r0_16 = 0;
int r1_16 = 0;
int r2_16 = 0;
int row_16 = 0;
int cv_in_16 = 6; //analog read
int bin_16[] = {0,1,2,3,4,5,6,7};

int s0_8a = 29;
int s1_8a = 28;
int s2_8a = 30;
int r0_8a = 0;
int r1_8a = 0;
int r2_8a = 0;
int row_8a = 0;
int cv_in_8a = 7; //analog read
int bin_8a[] = {0,1,2,3,4,5,6,7};

int s0_8b = 32;
int s1_8b = 31;
int s2_8b = 33;
int r0_8b = 0;
int r1_8b = 0;
int r2_8b = 0;
int row_8b = 0;
int cv_in_8b = 11; //analog read
int bin_8b[] = {0,1,2,3,4,5,6,7};

// note pitch and pot values
int cvData_32;
int cvData_16;
int cvData_8a;
int cvData_8b;

int potVal_32;
int potVal_16;
int potVal_8a;
int potVal_8b;

int cvOctave_32;
int cvOctave_16;
int cvOctave_8a;
int cvOctave_8b;

int stepNum_32 = 0;
int stepNum_16 = 4;
int stepNum_8a = 2;
int stepNum_8b = 6;

//step direction vars
int step32_dir = 0;
int step16_dir = 0;
int step8a_dir = 0;
int step8b_dir = 0;
int step32_bounce = 0;
int step16_bounce = 0;
int step8a_bounce = 0;
int step8b_bounce = 0;

//step direction pin (pendulum)
int step32_dir_pin = 8;
int step16_dir_pin = 9;
int step8a_dir_pin = 10;
int step8b_dir_pin = 11;

//octave switches
int octave_32 = 4;
int octave_16 = 5;
int octave_8a = 6;
int octave_8b = 7;

//sequencer stage
int seqStage;

//max number of steps
int maxNum_32 = 31;
int maxNum_16 = 15;

volatile int state_32 = LOW;
volatile int state_16 = LOW;
volatile int state_8a = LOW;
volatile int state_8b = LOW;

void setup()
  {
    pinMode(resetButton, INPUT);
    
    pinMode(rotary_32, INPUT);
    pinMode(rotary_16, INPUT);
    pinMode(rotary_8, INPUT);
    
    pinMode(octave_32, INPUT);
    pinMode(octave_16, INPUT);
    pinMode(octave_8a, INPUT);
    pinMode(octave_8b, INPUT);
    
    pinMode(resetPin32, INPUT);
    pinMode(resetPin16, INPUT);
    pinMode(resetPin8a, INPUT);
    pinMode(resetPin8b, INPUT);
    
    //step pendulum switches
    pinMode (step32_dir_pin, INPUT);
    pinMode (step16_dir_pin, INPUT);
    pinMode (step8a_dir_pin, INPUT);
    pinMode (step8b_dir_pin, INPUT);
    
    pinMode (gateDataPin_32, OUTPUT);
    pinMode (gateDataPin_16, OUTPUT);
    pinMode (gateDataPin_8a, OUTPUT);
    pinMode (gateDataPin_8b, OUTPUT);
    
    pinMode (cv_in_32, INPUT);
    pinMode (s0_32, OUTPUT);
    pinMode (s1_32, OUTPUT);
    pinMode (s2_32, OUTPUT);
    
    pinMode (cv_in_16, INPUT);
    pinMode (s0_16, OUTPUT);
    pinMode (s1_16, OUTPUT);
    pinMode (s2_16, OUTPUT);
    
    pinMode (cv_in_8a, INPUT);
    pinMode (s0_8a, OUTPUT);
    pinMode (s1_8a, OUTPUT);
    pinMode (s2_8a, OUTPUT);
    
    pinMode (cv_in_8b, INPUT);
    pinMode (s0_8b, OUTPUT);
    pinMode (s1_8b, OUTPUT);
    pinMode (s2_8b, OUTPUT);
    
    pinMode (clockPin_32, OUTPUT);
    pinMode (cvDataPin_32, OUTPUT);
    pinMode (latchPin_32, OUTPUT);
    pinMode (clockPin_16, OUTPUT);
    pinMode (cvDataPin_16, OUTPUT);
    pinMode (latchPin_16, OUTPUT);
    pinMode (clockPin_8a, OUTPUT);
    pinMode (cvDataPin_8a, OUTPUT);
    pinMode (latchPin_8a, OUTPUT);
    pinMode (clockPin_8b, OUTPUT);
    pinMode (cvDataPin_8b, OUTPUT);
    pinMode (latchPin_8b, OUTPUT);
    
    pinMode (ledShift_32_clock, OUTPUT);
    pinMode (ledShift_32_data, OUTPUT);
    pinMode (ledShift_32_latch, OUTPUT);
    pinMode (ledShift_16_clock, OUTPUT);
    pinMode (ledShift_16_data, OUTPUT);
    pinMode (ledShift_16_latch, OUTPUT);
    pinMode (ledShift_8a_clock, OUTPUT);
    pinMode (ledShift_8a_data, OUTPUT);
    pinMode (ledShift_8a_latch, OUTPUT);
    pinMode (ledShift_8b_clock, OUTPUT);
    pinMode (ledShift_8b_data, OUTPUT);
    pinMode (ledShift_8b_latch, OUTPUT);
  
    attachInterrupt (5, voltIn_32, CHANGE);
    attachInterrupt (4, voltIn_16, CHANGE);
    attachInterrupt (3, voltIn_8a, CHANGE);
    attachInterrupt (2, voltIn_8b, CHANGE);
  }
 
void loop()
  {
    //update and set bouncer var which prevents reset button
    //from trigger many resets on one push
    bouncer.update();
    
    int resetButtonVal = bouncer.read();
    
    if (resetButtonVal == HIGH)
      {
        delay (500);
        resetSeq();
        delay(50);
      }

    //rotary switch sequencer length switch. 32, 16 or 8
    if (digitalRead(rotary_32 == HIGH))
      {
        seqStage = 0;
      }
    else if (digitalRead(rotary_16 == HIGH))
      {
        seqStage = 1;
      }
    else if (digitalRead(rotary_8 == HIGH))
      {
        seqStage = 2;
      }
      
    //pendulum switches read
    if (digitalRead(step32_dir_pin) == HIGH)
      {
        step32_dir = 1;
      }
    else
      {
        step32_dir = 0;
      }
      
    if (digitalRead(step16_dir_pin) == HIGH)
      {
        step16_dir = 1;
      }
    else
      {
        step16_dir = 0;
      }
      
    if (digitalRead(step8a_dir_pin) == HIGH)
      {
        step8a_dir = 1;
      }
    else
      {
        step8a_dir = 0;
      }
      
    if (digitalRead(step8b_dir_pin) == HIGH)
      {
        step8b_dir = 1;
      }
    else
      {
        step8b_dir = 0;
      }
      
    //2 or 4 octave range
    int oct_32 = digitalRead(octave_32);
    
    if (oct_32 == HIGH)
      {
        cvOctave_32 = 255;
      }
    else
      {
        cvOctave_32 = 127;
      }
      
    int oct_16 = digitalRead(octave_16);
    
    if (oct_16 == HIGH)
      {
        cvOctave_16 = 255;
      }
    else
      {
        cvOctave_16 = 127;
      }
      
    int oct_8a = digitalRead(octave_8a);
    
    if (oct_8a == HIGH)
      {
        cvOctave_8a = 255;
      }
    else
      {
        cvOctave_8a = 127;
      }
      
    int oct_8b = digitalRead(octave_8b);
    
    if (oct_8b == HIGH)
      {
        cvOctave_8b = 255;
      }
    else
      {
        cvOctave_8b = 127;
      }
      
    //if rotary switch is set to all 32 steps
    if (seqStage == 0)
      {    
        
        if (stepNum_32 <= 7)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_32_latch, LOW);
                shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_32_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_32 = row_32 & 0x01;
            r1_32 = (row_32>>1) & 0x01;
            r2_32 = (row_32>>2) & 0x01;
            digitalWrite(s0_32, r0_32);
            digitalWrite(s1_32, r1_32);
            digitalWrite(s2_32, r2_32);
            potVal_32 = analogRead(cv_in_32);
            cvData_32 = map(potVal_32, 0, 1023, 0, cvOctave_32);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);
          }
        else if (stepNum_32 > 7 && stepNum_32 <= 15)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                digitalWrite (gateDataPin_16, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_16_latch, LOW);
                shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_16_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
                digitalWrite (gateDataPin_16, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_16 = row_32 & 0x01;
            r1_16 = (row_32>>1) & 0x01;
            r2_16 = (row_32>>2) & 0x01;
            digitalWrite(s0_16, r0_16);
            digitalWrite(s1_16, r1_16);
            digitalWrite(s2_16, r2_16);
            potVal_16 = analogRead(cv_in_16);
            cvData_16 = map(potVal_16, 0, 1023, 0, cvOctave_16);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);       
          }
        else if (stepNum_32 > 15 && stepNum_32 <= 23)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                digitalWrite (gateDataPin_8a, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_8a_latch, LOW);
                shiftOut (ledShift_8a_data, ledShift_8a_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_8a_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
                digitalWrite (gateDataPin_8a, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_8a = row_32 & 0x01;
            r1_8a = (row_32>>1) & 0x01;
            r2_8a = (row_32>>2) & 0x01;
            digitalWrite(s0_8a, r0_8a);
            digitalWrite(s1_8a, r1_8a);
            digitalWrite(s2_8a, r2_8a);
            potVal_8a = analogRead(cv_in_8a);
            cvData_8a = map(potVal_8a, 0, 1023, 0, cvOctave_8a);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);        
          }
        else if (stepNum_32 > 23 && stepNum_32 <= 31)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                digitalWrite (gateDataPin_8b, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_8b_latch, LOW);
                shiftOut (ledShift_8b_data, ledShift_8b_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_8b_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
                digitalWrite (gateDataPin_8b, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_8b = row_32 & 0x01;
            r1_8b = (row_32>>1) & 0x01;
            r2_8b = (row_32>>2) & 0x01;
            digitalWrite(s0_8b, r0_8b);
            digitalWrite(s1_8b, r1_8b);
            digitalWrite(s2_8b, r2_8b);
            potVal_8b = analogRead(cv_in_8b);
            cvData_8b = map(potVal_8b, 0, 1023, 0, cvOctave_8b);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);        
          }        
          
       }
    else if (seqStage == 1) // if range is set to dual 16 steps
       {
        if (stepNum_32 <= 7)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_32_latch, LOW);
                shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_32_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_32 = row_32 & 0x01;
            r1_32 = (row_32>>1) & 0x01;
            r2_32 = (row_32>>2) & 0x01;
            digitalWrite(s0_32, r0_32);
            digitalWrite(s1_32, r1_32);
            digitalWrite(s2_32, r2_32);
            potVal_32 = analogRead(cv_in_32);
            cvData_32 = map(potVal_32, 0, 1023, 0, cvOctave_32);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);
          }
        else if (stepNum_32 > 7 && stepNum_32 <= 15)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_16_latch, LOW);
                shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_16_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_16 = row_32 & 0x01;
            r1_16 = (row_32>>1) & 0x01;
            r2_16 = (row_32>>2) & 0x01;
            digitalWrite(s0_16, r0_16);
            digitalWrite(s1_16, r1_16);
            digitalWrite(s2_16, r2_16);
            potVal_16 = analogRead(cv_in_16);
            cvData_16 = map(potVal_16, 0, 1023, 0, cvOctave_16);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);       
          }
        
        if (stepNum_16 <= 7)
          {
            //trigger out and led's
            if (state_16 == HIGH)
              { 
                digitalWrite (gateDataPin_16, HIGH);
                
                byte bit_16 = 0;
                bitWrite(bit_16,step_16_loop[stepNum_16],HIGH);
                digitalWrite (ledShift_8a_latch, LOW);
                shiftOut (ledShift_8a_data, ledShift_8a_clock, MSBFIRST, bit_16);
                digitalWrite (ledShift_8a_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_16, LOW);
                digitalWrite (gateDataPin_8a, LOW);
              }
            
            // cv pitch value procedure
            row_16 = bin_16[step_16_loop[stepNum_16]];
            r0_8a = row_16 & 0x01;
            r1_8a = (row_16>>1) & 0x01;
            r2_8a = (row_16>>2) & 0x01;
            digitalWrite(s0_8a, r0_8a);
            digitalWrite(s1_8a, r1_8a);
            digitalWrite(s2_8a, r2_8a);
            potVal_8a = analogRead(cv_in_8a);
            cvData_8a = map(potVal_8a, 0, 1023, 0, cvOctave_8a);
            
            digitalWrite (latchPin_16, LOW);
            shiftOut (cvDataPin_16, clockPin_16, MSBFIRST, cvData_16);
            digitalWrite (latchPin_16, HIGH);        
          }
        else if (stepNum_16 > 7 && stepNum_16 <= 15)
          {
            //trigger out and led's
            if (state_16 == HIGH)
              { 
                digitalWrite (gateDataPin_16, HIGH);
                
                byte bit_16 = 0;
                bitWrite(bit_16,step_16_loop[stepNum_16],HIGH);
                digitalWrite (ledShift_8b_latch, LOW);
                shiftOut (ledShift_8b_data, ledShift_8b_clock, MSBFIRST, bit_16);
                digitalWrite (ledShift_8b_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_16, LOW);
              }
            
            // cv pitch value procedure
            row_16 = bin_16[step_16_loop[stepNum_16]];
            r0_8b = row_16 & 0x01;
            r1_8b = (row_16>>1) & 0x01;
            r2_8b = (row_16>>2) & 0x01;
            digitalWrite(s0_8b, r0_8b);
            digitalWrite(s1_8b, r1_8b);
            digitalWrite(s2_8b, r2_8b);
            potVal_8b = analogRead(cv_in_8b);
            cvData_8b = map(potVal_8b, 0, 1023, 0, cvOctave_8b);
            
            digitalWrite (latchPin_16, LOW);
            shiftOut (cvDataPin_16, clockPin_16, MSBFIRST, cvData_16);
            digitalWrite (latchPin_16, HIGH);        
          }
       }
       
    else if (seqStage == 2) // if step range is set to quad 8 step
       {
        if (stepNum_32 <= 7)
          {
            //trigger out and led's
            if (state_32 == HIGH)
              { 
                digitalWrite (gateDataPin_32, HIGH);
                
                byte bit_32 = 0;
                bitWrite(bit_32,step_32_loop[stepNum_32],HIGH);
                digitalWrite (ledShift_32_latch, LOW);
                shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_32);
                digitalWrite (ledShift_32_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_32, LOW);
              }
            
            // cv pitch value procedure
            row_32 = bin_32[step_32_loop[stepNum_32]];
            r0_32 = row_32 & 0x01;
            r1_32 = (row_32>>1) & 0x01;
            r2_32 = (row_32>>2) & 0x01;
            digitalWrite(s0_32, r0_32);
            digitalWrite(s1_32, r1_32);
            digitalWrite(s2_32, r2_32);
            potVal_32 = analogRead(cv_in_32);
            cvData_32 = map(potVal_32, 0, 1023, 0, cvOctave_32);
            
            digitalWrite (latchPin_32, LOW);
            shiftOut (cvDataPin_32, clockPin_32, MSBFIRST, cvData_32);
            digitalWrite (latchPin_32, HIGH);
          }
        
        if (stepNum_16 < 7)
          {
            //trigger out and led's
            if (state_16 == HIGH)
              { 
                digitalWrite (gateDataPin_16, HIGH);
                
                byte bit_16 = 0;
                bitWrite(bit_16,step_16_loop[stepNum_16],HIGH);
                digitalWrite (ledShift_16_latch, LOW);
                shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_16);
                digitalWrite (ledShift_16_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_16, LOW);
              }
            
            // cv pitch value procedure
            row_16 = bin_16[step_16_loop[stepNum_16]];
            r0_16 = row_16 & 0x01;
            r1_16 = (row_16>>1) & 0x01;
            r2_16 = (row_16>>2) & 0x01;
            digitalWrite(s0_16, r0_16);
            digitalWrite(s1_16, r1_16);
            digitalWrite(s2_16, r2_16);
            potVal_16 = analogRead(cv_in_16);
            cvData_16 = map(potVal_16, 0, 1023, 0, cvOctave_16);
            
            digitalWrite (latchPin_16, LOW);
            shiftOut (cvDataPin_16, clockPin_16, MSBFIRST, cvData_16);
            digitalWrite (latchPin_16, HIGH);       
          }
        
        if (stepNum_8a < 7)
          {
            //trigger out and led's
            if (state_8a == HIGH)
              { 
                digitalWrite (gateDataPin_8a, HIGH);
                
                byte bit_8a = 0;
                bitWrite(bit_8a,stepNum_8a,HIGH);
                digitalWrite (ledShift_8a_latch, LOW);
                shiftOut (ledShift_8a_data, ledShift_8a_clock, MSBFIRST, bit_8a);
                digitalWrite (ledShift_8a_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_8a, LOW);
              }
            
            // cv pitch value procedure
            row_8a = bin_8a[stepNum_8a];
            r0_8a = row_8a & 0x01;
            r1_8a = (row_8a>>1) & 0x01;
            r2_8a = (row_8a>>2) & 0x01;
            digitalWrite(s0_8a, r0_8a);
            digitalWrite(s1_8a, r1_8a);
            digitalWrite(s2_8a, r2_8a);
            potVal_8a = analogRead(cv_in_8a);
            cvData_8a = map(potVal_8a, 0, 1023, 0, cvOctave_8a);
            
            digitalWrite (latchPin_8a, LOW);
            shiftOut (cvDataPin_8a, clockPin_8a, MSBFIRST, cvData_8a);
            digitalWrite (latchPin_8a, HIGH);        
          }
        
        if (stepNum_8b < 7)
          {
            //trigger out and led's
            if (state_8b == HIGH)
              { 
                digitalWrite (gateDataPin_8b, HIGH);
                
                byte bit_8b = 0;
                bitWrite(bit_8b,stepNum_8b,HIGH);
                digitalWrite (ledShift_8b_latch, LOW);
                shiftOut (ledShift_8b_data, ledShift_8b_clock, MSBFIRST, bit_8b);
                digitalWrite (ledShift_8b_latch, HIGH);
              }
            else
              {
                digitalWrite (gateDataPin_8b, LOW);
              }
            
            // cv pitch value procedure
            row_8b = bin_8b[stepNum_8b];
            r0_8b = row_8b & 0x01;
            r1_8b = (row_8b>>1) & 0x01;
            r2_8b = (row_8b>>2) & 0x01;
            digitalWrite(s0_8b, r0_8b);
            digitalWrite(s1_8b, r1_8b);
            digitalWrite(s2_8b, r2_8b);
            potVal_8b = analogRead(cv_in_8b);
            cvData_8b = map(potVal_8b, 0, 1023, 0, cvOctave_8b);
            
            digitalWrite (latchPin_8b, LOW);
            shiftOut (cvDataPin_8b, clockPin_8b, MSBFIRST, cvData_8b);
            digitalWrite (latchPin_8b, HIGH);        
          }  
       }
    
  }
  
void resetSeq() //resets all sequences from button
  {
    digitalWrite (gateDataPin_32, LOW);
    digitalWrite (gateDataPin_16, LOW);
    digitalWrite (gateDataPin_8a, LOW);
    digitalWrite (gateDataPin_8b, LOW);
    
    state_32 = LOW;
    state_16 = LOW;
    state_8a = LOW;
    state_8b = LOW;
    
    //LED pins
    if (seqStage == 0)
      {
        byte bit_reset_32 = 0;
        stepNum_32 = 31;
        bitWrite(bit_reset_32,stepNum_32,HIGH);
        digitalWrite (ledShift_32_latch, LOW);
        shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_reset_32);
        digitalWrite (ledShift_32_latch, HIGH);
      }
    else if (seqStage == 1)
      {  
        byte bit_reset_32 = 0;
        stepNum_32 = 15;
        bitWrite(bit_reset_32,stepNum_32,HIGH);
        digitalWrite (ledShift_32_latch, LOW);
        shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_reset_32);
        digitalWrite (ledShift_32_latch, HIGH);
        
        byte bit_reset_16 = 0;
        stepNum_16 = 31;
        bitWrite(bit_reset_16,stepNum_16,HIGH);
        digitalWrite (ledShift_16_latch, LOW);
        shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_reset_16);
        digitalWrite (ledShift_16_latch, HIGH);
      }
    else if (seqStage == 2)
      {
        byte bit_reset_32 = 0;
        stepNum_32 = 7;
        bitWrite(bit_reset_32,stepNum_32,HIGH);
        digitalWrite (ledShift_32_latch, LOW);
        shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_reset_32);
        digitalWrite (ledShift_32_latch, HIGH);
        
        byte bit_reset_16 = 0;
        stepNum_16 = 15;
        bitWrite(bit_reset_16,stepNum_16,HIGH);
        digitalWrite (ledShift_16_latch, LOW);
        shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_reset_16);
        digitalWrite (ledShift_16_latch, HIGH);
        
        byte bit_reset_8a = 0;
        stepNum_8a = 23;
        bitWrite(bit_reset_8a,stepNum_8a,HIGH);
        digitalWrite (ledShift_8a_latch, LOW);
        shiftOut (ledShift_8a_data, ledShift_8a_clock, MSBFIRST, bit_reset_8a);
        digitalWrite (ledShift_8a_latch, HIGH);
        
        byte bit_reset_8b = 0;
        stepNum_8b = 31;
        bitWrite(bit_reset_8b,stepNum_8b,HIGH);
        digitalWrite (ledShift_8b_latch, LOW);
        shiftOut (ledShift_8b_data, ledShift_8b_clock, MSBFIRST, bit_reset_8b);
        digitalWrite (ledShift_8b_latch, HIGH);
      }
    
  }
  
void resetSeq_32()
  {
    if (seqStage == 0)
      {
        stepNum_32 = 31;
      }
    else if (seqStage == 1)
      {
        stepNum_32 = 15;
      }
    else if (seqStage == 2)
      {
        stepNum_32 = 7;
      }
      
    state_32 = LOW;
    digitalWrite (gateDataPin_32, LOW);
    
    byte bit_reset_32 = 0;
    bitWrite(bit_reset_32,stepNum_32,HIGH);
    digitalWrite (ledShift_32_latch, LOW);
    shiftOut (ledShift_32_data, ledShift_32_clock, MSBFIRST, bit_reset_32);
    digitalWrite (ledShift_32_latch, HIGH);
  }
  
void resetSeq_16()
  {
    if (seqStage == 1)
      {
        stepNum_16 = 31;
      }
    else if (seqStage == 2)
      {
        stepNum_16 = 15;
      }
    
    state_16 = LOW;
    digitalWrite (gateDataPin_16, LOW);
    
    byte bit_reset_16 = 0;
    bitWrite(bit_reset_16,stepNum_16,HIGH);
    digitalWrite (ledShift_16_latch, LOW);
    shiftOut (ledShift_16_data, ledShift_16_clock, MSBFIRST, bit_reset_16);
    digitalWrite (ledShift_16_latch, HIGH);
  }
  
void resetSeq_8a()
  {
    stepNum_8a = 23;
    state_8a = LOW;
    digitalWrite (gateDataPin_8a, LOW);
    
    byte bit_reset_8a = 0;
    bitWrite(bit_reset_8a,stepNum_8a,HIGH);
    digitalWrite (ledShift_8a_latch, LOW);
    shiftOut (ledShift_8a_data, ledShift_8a_clock, MSBFIRST, bit_reset_8a);
    digitalWrite (ledShift_8a_latch, HIGH);
  }
  
void resetSeq_8b()
  {
    stepNum_8b = 31;
    state_8b = LOW;
    digitalWrite (gateDataPin_8b, LOW);
    
    byte bit_reset_8b = 0;
    bitWrite(bit_reset_8b,stepNum_8b,HIGH);
    digitalWrite (ledShift_8b_latch, LOW);
    shiftOut (ledShift_8b_data, ledShift_8b_clock, MSBFIRST, bit_reset_8b);
    digitalWrite (ledShift_8b_latch, HIGH);
  }
 
void voltIn_32()
  {
    state_32 = !state_32;
    stepPos_32();
  }
  
void voltIn_16()
  {
    state_16 = !state_16;
    stepPos_16();
  }
  
void voltIn_8a()
  {
    state_8a = !state_8a;
    stepPos_8a();
  }
  
void voltIn_8b()
  {
    state_8b = !state_8b;
    stepPos_8b();
  }
 
void stepPos_32()
  { 
    if (seqStage == 0)
      {
        maxNum_32 = 31;
      }
    else if (seqStage == 1)
      {
        maxNum_32 = 15;
      }
    else if (seqStage == 2 )
      {
        maxNum_32 = 7;
      }

    if (state_32 == HIGH)
      {   
        if (step32_dir == 0)
          {
            ++stepNum_32;
              
            if (stepNum_32 > maxNum_32)
              {
                stepNum_32 = 0;
              }
          }
         else if (step32_dir == 1) //if pendulum mode
          {
            if (step32_bounce == 0)
               {
                 ++stepNum_32;
                     
                  if (stepNum_32 >= maxNum_32)
                     {
                       step32_bounce = 1; //set to reverse mode
                     }
               }  
              else if (step32_bounce == 1)
               {
                  --stepNum_32;
                     
                  if (stepNum_32 <= 0)
                    {
                      step32_bounce = 0; //set to forward mode
                    }
               }    
          }
      }
  }

void stepPos_16()
  { 
    int resetNum_16 = 16;
    
    if (seqStage == 1)
      {
        maxNum_16 = 31;
        resetNum_16 = 16;
      }
    else if (seqStage == 2)
      {
        maxNum_16 = 15;
        resetNum_16 = 8;
      }
    
    if (state_16 == HIGH)
      {
        if (step16_dir == 0)
          {
            ++stepNum_16;
              
            if (stepNum_16 > maxNum_16)
              {
                stepNum_16 = resetNum_16;
              }
          }
         else if (step16_dir == 1) //if pendulum mode
          {
            if (step16_bounce == 0)
               {
                 ++stepNum_16;
                     
                  if (stepNum_16 >= maxNum_16)
                     {
                       step16_bounce = 1; //set to reverse mode
                     }
               }  
             else if (step16_bounce == 1)
               {
                  --stepNum_16;
                     
                  if (stepNum_16 <= resetNum_16)
                    {
                      step16_bounce = 0; //set to forward mode
                    }
               }    
          }
      }
  }

void stepPos_8a()
  {
    if (state_8a == HIGH)
      {
        if (step8a_dir == 0)
          {
            ++stepNum_8a;
              
            if (stepNum_8a > 23)
              {
                stepNum_8a = 16;
              }
          }
         else if (step8a_dir == 1) //if pendulum mode
          {
            if (step8a_bounce == 0)
               {
                 ++stepNum_8a;
                     
                  if (stepNum_8a >= 23)
                     {
                       step8a_bounce = 1; //set to reverse mode
                     }
               }  
             else if (step8a_bounce == 1)
               {
                  --stepNum_8a;
                     
                  if (stepNum_8a <= 16)
                    {
                      step8a_bounce = 0; //set to forward mode
                    }
               }    
          }
      }
  }
  
void stepPos_8b()
  {
    if (state_8b == HIGH)
      {
        if (step8b_dir == 0)
          {
            ++stepNum_8b;
              
            if (stepNum_8b > 31)
              {
                stepNum_8b = 24;
              }
          }
         else if (step8b_dir == 1) //if pendulum mode
          {
            if (step8b_bounce == 0)
               {
                 ++stepNum_8b;
                     
                  if (stepNum_8b >= 31)
                     {
                       step8b_bounce = 1; //set to reverse mode
                     }
               }  
             else if (step8b_bounce == 1)
               {
                  --stepNum_8b;
                     
                  if (stepNum_8b <= 24)
                    {
                      step8b_bounce = 0; //set to forward mode
                    }
               }    
          }
      }
  }
