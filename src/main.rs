// std and main are not available for bare metal software
#![no_std]
#![no_main]

extern crate stm32f1;
extern crate panic_halt;
extern crate cortex_m_rt;

use cortex_m_rt::entry;
use stm32f1::stm32f103;

// use `main` as the entry point of this application
#[entry]
fn main() -> ! {
    // get handles to the hardware
    let peripherals = stm32f103::Peripherals::take().unwrap();
    let gpioc = &peripherals.GPIOC;
    let rcc = &peripherals.RCC;

    // enable the GPIO clock for IO port C
    rcc.apb2enr.write(|w| w.iopcen().set_bit());
    gpioc.crh.write(|w| unsafe{
		if cfg!(feature = "OLIMEX_H103") { // OLIMEX-H103
				w.mode12().bits(0b11);
				w.cnf12().bits(0b00)
		} else {
				w.mode13().bits(0b11);
				w.cnf13().bits(0b00)
		}	
    });

    loop{
		if cfg!(feature = "OLIMEX_H103") { // OLIMEX-H103
			gpioc.bsrr.write(|w| w.bs12().set_bit());
		} else {
			gpioc.bsrr.write(|w| w.bs13().set_bit());
		}	
       
	   cortex_m::asm::delay(2000000);

	   if cfg!(feature = "OLIMEX_H103") { // OLIMEX-H103
			gpioc.brr.write(|w| w.br12().set_bit());
		} else {
			gpioc.brr.write(|w| w.br13().set_bit());
		}	
        cortex_m::asm::delay(2000000);
    }
}
