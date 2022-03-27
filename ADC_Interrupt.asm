.org 0x002A
   jmp ADC_Int
.org 0x00
   jmp main

main:
ldi R20, 0xFF
out DDRA, R20
out DDRB, R20
ldi R20, 0x00
sts DDRF, R20 ;The IO-Reg commands do not go above the SREG (0x3F or 0x5F), you have to talk to them "normally", I think.

ldi R20, 0x40 ;AVCC, right justified in first channel, input from ADC0
out ADMUX, R20
ldi R20, (1<<ADEN) | (1<<ADFR) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)   ; enable conversion, single ended mode, polling, no interrupt with 128 prescaling
out ADCSRA, R20
sbi ADCSRA, ADSC ;start ADC conversion
sei

HERE: rjmp HERE

ADC_Int:

	sbis ADCSRA, ADIF; skip if end of conversion
	rjmp ADC_Int
	sbi ADCSRA, ADIF ;clear interrupt flag
	in R20, ADCL
	out PORTA, R20
	in R20, ADCH
	out PORTB, R20

reti
