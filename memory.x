/* Linker script for the STM32F103C8T6 */
MEMORY
{
  FLASH : ORIGIN = 0x08000000, LENGTH = 64K
  RAM : ORIGIN = 0x20000000, LENGTH = 20K
#  RAM : ORIGIN = 0x20000000 - 0x20, LENGTH = 20K - 0x20
#  extabram : org = 0x06008000 - 0x10020, len = 0x10000 - 0x20
#  .ARM.exidx : org = 0x06008000 - 0x10020, len = 0x10000 - 0x20
#  ARM.exidx : org = 0x06008000 - 0x10020, len = 0x10000 - 0x20
}

SECTIONS
{
#  .ARM.extab : {*(.ARM.extab* .gnu.linkonce.armextab.*)} > extabram
#  .ARM.exidx : {*(.ARM.extab* .gnu.linkonce.armextab.*)} > RAM

#	/DISCARD/ :
#	{
#		*(.ARM.exidx .ARM.exidx.*);
#	}
}

