STM32_blink
===========

This is the cargo project with the source code for the blogpost: https://jonathanklimt.de/electrics/programming/rust-STM32F103-blink/

## Jedzias Notes ##

### rust-lld: error: no memory region specified for section '.ARM.exidx' ###



1. Specify the memory region in the linker script: (ToDo: check this. minus or plus 0x20? and the interleave ... better a separate memory section!
) 
        /* Linker script for the STM32F103C8T6 */
        MEMORY
        {
          FLASH : ORIGIN = 0x08000000, LENGTH = 64K
          RAM : ORIGIN = 0x20000000 - 0x20, LENGTH = 20K - 0x20
        }
        
        SECTIONS
        {
          .ARM.exidx : {*(.ARM.extab* .gnu.linkonce.armextab.*)} > RAM
        }
        
2. or specify (like 3. below) as RUSTFLAGS environment variable 
        set RUSTFLAGS=-C linker=arm-none-eabi-ld && cargo build --release

3. or, change linker to local arm (`"-C", "linker=arm-none-eabi-ld"`) in *.cargo/config* because of rust failing with
        Compiling stm32_blink v0.1.0 (E:\Projects\Elektronik\ARM\STM32F103\BluePill\Rust\jounathaen\stm32_blink)
        error: linking with `rust-lld` failed: exit code: 1
        |
        = note: "rust-lld" "-flavor" "gnu" "-L" "C:\\WinJunked\\Users\\Jedzia.pubsiX\\.rustup\\toolchains\\nightly-x86_64-pc-windows-gnu\\lib\\rustlib\\thumbv7m-none-
        eabi\\lib" "E:\\Projects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thumbv7m-none-eabi\\release\\deps\\stm32_blink-29a08ed5a3
        b6d04f.stm32_blink.bjtqargo-cgu.1.rcgu.o" "-o" "E:\\Projects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thumbv7m-none-eabi\\r
        elease\\deps\\stm32_blink-29a08ed5a3b6d04f" "--gc-sections" "-L" "E:\\Projects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thu
        mbv7m-none-eabi\\release\\deps" "-L" "E:\\Projects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\release\\deps" "-L" "E:\\Projec
        ts\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thumbv7m-none-eabi\\release\\build\\cortex-m-b161dba4a69bc355\\out" "-L" "E:\\P
        rojects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thumbv7m-none-eabi\\release\\build\\cortex-m-rt-c8ee25c8e9e8e771\\out" "-L
        " "E:\\Projects\\Elektronik\\ARM\\STM32F103\\BluePill\\Rust\\jounathaen\\stm32_blink\\target\\thumbv7m-none-eabi\\release\\build\\stm32f1-e42af3cd3ca12097\\out"
        "-L" "C:\\WinJunked\\Users\\Jedzia.pubsiX\\.rustup\\toolchains\\nightly-x86_64-pc-windows-gnu\\lib\\rustlib\\thumbv7m-none-eabi\\lib" "--start-group" "-Bstatic
        " "D:\\Users\\JEDZIA~1.PUB\\AppData\\Local\\Temp\\rustcI0ZvzX\\libcortex_m_rt-0835c5a8e7314307.rlib" "D:\\Users\\JEDZIA~1.PUB\\AppData\\Local\\Temp\\rustcI0ZvzX
        \\libcortex_m-74e7d3cfc5f0e7a9.rlib" "--end-group" "C:\\WinJunked\\Users\\Jedzia.pubsiX\\.rustup\\toolchains\\nightly-x86_64-pc-windows-gnu\\lib\\rustlib\\thumb
        v7m-none-eabi\\lib\\libcompiler_builtins-a0d49a4ba4763303.rlib" "-Tlink.x" "-Bdynamic"
        = note: rust-lld: error: no memory region specified for section '.ARM.exidx'
        
        error: aborting due to previous error
        
        error: could not compile `stm32_blink`.
        
        To learn more, run the command again with --verbose.
    
Patch:

     .cargo/config | 4 ++--
     1 file changed, 2 insertions(+), 2 deletions(-)
    
    diff --git a/.cargo/config b/.cargo/config
    index e832178..936ee79 100644
    --- a/.cargo/config
    +++ b/.cargo/config
    @@ -7,11 +7,11 @@ target = "thumbv7m-none-eabi"# Cortex-M3
     
     rustflags = [
       # LLD (shipped with the Rust toolchain) is used as the default linker
    -  "-C", "link-arg=-Tlink.x",
    +  #"-C", "link-arg=-Tlink.x",
     
       # if you run into problems with LLD switch to the GNU linker by commenting out
       # this line
    -  # "-C", "linker=arm-none-eabi-ld",
    +  "-C", "linker=arm-none-eabi-ld",
     
       # if you need to link to pre-compiled C libraries provided by a C toolchain
       # use GCC as the linker by commenting out both lines above and then
    