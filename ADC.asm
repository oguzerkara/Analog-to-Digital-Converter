.org 0x00

ldi R20, 0xFF
out DDRA, R20
out DDRB, R20
ldi R20, 0x00
sts DDRF, R20 ;The IO-Reg commands do not go above the SREG (0x3F or 0x5F), you have to talk to them "normally", I think.

ldi R20, 0x87   ; enable conversion, single ended mode, polling, no interrupt with 128 prescaling
out ADCSRA, R20
ldi R20, 0x60 ;AVCC, left justified in first channel
out ADMUX, R20

start:
	sbi ADCSRA,ADSC  ;start conversion
polling:
	sbis ADCSRA, ADIF; skip if end of conversion
	rjmp polling
	sbi ADCSRA, ADIF ;clear interrupt flag
	in R20, ADCH
	out PORTA, R20
	in R20, ADCL
	out PORTB, R20
	rjmp start
