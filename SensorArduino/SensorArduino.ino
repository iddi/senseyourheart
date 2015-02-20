// This program can either sample an analog signal on "Analog-Input_Pin, or act as an interval
// timer on pin "Digital-Input_Pin". The selection is made directly after reset. If the reply on
// the promt ">" is "I", then the interval mode is selected, otherwise the A/D mode.
// In both cases the program is interrupt driven:
//   - Interval mode: A hardware interrupt is generated on a low-to-high transition on digital
//     input pin "Digital-Input_Pin". The interrupt service routine "Send_Interval()" sends the
//     elapsed time with respect to the previous transition as a hexadecimal string over the 
//     serial bus. This is done with a 4us resolution.
//   - A/D mode: A timer interrupt is generated every 2ms (=500Hz). The interrupt service
//      routine samples pin "Analog_Input_Pin" and sends the value over the serial bus as a byte.
//
//                                                                 Geert Langereis, february 2010

const int Baudrate = 19200;
const int Analog_Input_Pin = 0;
const int Digital_Input_Pin = 2;    // the pin that has INTO functionality

void setup()
{
    Serial.begin(Baudrate);          // For sending data to the computer over USB
    Serial.print(">");
    while (Serial.available()==0){
    }
    if (Serial.read()=='I')
    {
        pinMode(Digital_Input_Pin, INPUT);
        attachInterrupt(0,Send_Interval, RISING); // Attach to INTO
    }
    else
    {
        // The following settings are for a Duemillanove with a 16Mhz ATMega328
        cli();                    // disable interrupts while messing with their settings
        TCCR1A = 0x00;            // clear default timer settings, this kills the millis() function
        TCCR1B = 0x00;            // timer in normal mode
        TCCR1B |= (1 << WGM12);   // Configure timer 1 for CTC mode
        TCCR1B |= (0 << CS12);    // Set timer prescaling by setting 3 bits
        TCCR1B |= (1 << CS11);    // 001=1; 010=8, 100=256, 101=1024
        TCCR1B |= (1 << CS10);
        TIMSK1 |= (1 << OCIE1A);  // Enable CTC interrupt with OCF1A flag in TIFR1
        OCR1A = 124;              // Turn interrupts back on
        sei();
    }
}

void loop() {
  // nothing to do, its all in the interrupt handlers!
}

unsigned long LastTime, NewTime, j;
void Send_Interval()
{
  NewTime = micros();        // Resolution 4us, only one overrun (=error in 70 minutes)
  Serial.println(NewTime-LastTime, HEX);
  LastTime = NewTime;
}

ISR(TIMER1_COMPA_vect)       // when timer counts down it fires this interrupt for A/D-mode
{
  int val = analogRead(Analog_Input_Pin);
  Serial.write( (val >> 2));
}
        

