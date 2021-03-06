library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab06 is
  Port (
  --MOTOR STUFF
    motorA, motorB, motorC  : OUT STD_LOGIC_VECTOR (3 downto 0);
  
    
  --SENSOR STUFF
    cs: BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);
    mosi    : OUT   STD_LOGIC;
    miso    : IN    STD_LOGIC;
    sclk    : BUFFER STD_LOGIC;
    
    -- Buttons
    btnC, btnR, btnL : IN STD_LOGIC;
--Others
    Y0, A0, B0, C0,D0: out STD_LOGIC;
     clk:    in STD_LOGIC
     

  );
end lab06;

architecture Behavioral of lab06 is

COMPONENT spi_master
  GENERIC(
    slaves  : INTEGER;  --number of spi slaves
    d_width : INTEGER); --data bus width
  PORT(
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : IN     STD_LOGIC;                             --initiate transaction
    cpol    : IN     STD_LOGIC;                             --spi clock polarity
    cpha    : IN     STD_LOGIC;                             --spi clock phase
    cont    : IN     STD_LOGIC;                             --continuous mode command
    clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr    : IN     INTEGER;                               --address of slave
    tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    miso    : IN     STD_LOGIC;                             --master in, slave out
    sclk    : BUFFER STD_LOGIC;                             --spi clock
    ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
    rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) --data received
    );
END COMPONENT;

-- Step 6: Create a signal for rx_data
signal motor_state: integer :=0;
signal motor_stateB: integer :=0;
signal motor_stateC: integer :=0;
    signal clk_4Hz: STD_LOGIC := '0';

    signal clk_100Hz: STD_LOGIC := '0';
    signal count : integer := 0;
        signal count1 : integer := 0;

    signal motorone: STD_LOGIC :='0';
    signal motortwo: STD_LOGIC :='0';
    signal motorthree: STD_LOGIC :='0';
    signal move: STD_LOGIC :='0';
    signal coin: STD_LOGIC:='1';

    signal rotate1: integer :=0;
    signal rotate2: integer :=0;
    signal rotate3: integer :=0;
    signal state: integer:=0;
    signal money: integer:=0;
signal light: STD_LOGIC_VECTOR(14 downto 0); 


begin

--MOTOR STUFF
 process(clk) begin
        if rising_edge(clk) then
            if (count = (200000 - 1)) then
                clk_100Hz <= not clk_100Hz;
                count<=0;
                else  
                    count<=count+1;
            end if;
         end if;
end process;
 process(clk) begin
       if rising_edge(clk) then
           if (count1 = (20000000 - 1)) then
               clk_4Hz <= not clk_4Hz;
               count1<=0;
               else  
                   count1<=count1+1;
           end if;
        end if;
end process;
process(money) begin
    if(money = 0) then 

    elsif(money = 1 )then

    elsif(money = 2 )then

    else

    end if;

end process;
    
    process(clk_4Hz) begin
            
          
        if((light(11)='1' )) then
        coin<='0';
        elsif(coin = '0') then 
        coin <= '1';
        money<=money +1;
        else
        end if;    
    end process;   
 
    
--Light Sensor
    
  spi_master_0: spi_master
    GENERIC MAP(
        slaves => 1,
        d_width => 15 
    )
    PORT MAP(
        clock => clk,
        reset_n => '1',
        enable => '1',
        cpol => '1',
        cpha => '1',
        cont => '0',
        clk_div => 50,
        addr => 0,
        tx_data => (OTHERS => '0'),
        miso => miso,
        sclk => sclk,
        ss_n => cs,
        mosi => mosi,
        busy => open,
        rx_data => light
    );
   

--MOTOR
    process(clk_100Hz, state) begin
        if(rising_edge(clk_100Hz) ) then
                if(rotate1 = 2100) then
                motorone<='0';
                elsif(rotate2 = 2100) then
                    motortwo<='0';  
                elsif(rotate3 = 2100) then
                    motorthree<='0';  
                 elsif(btnC='1') then
                    motorone<='1';
                    motortwo<='0';                
                    motorthree<='0';
                     
                 elsif(btnL='1') then
                    motorone<='0';
                 motortwo<='1';                
                 motorthree<='0';
    
                  elsif(btnR='1') then
                       motorone<='0';
                      motortwo<='0';                
                      motorthree<='1';
                   else                                                                  
                 end if;
                 else
           end if;
        if( rising_edge(clk_100Hz) ) then
           if(motorone = '1' and motortwo = '0' and motorthree = '0'  ) then
                     if(rotate1 < 2100) then
                          rotate1<=rotate1+1;
                     else
                     rotate1<=0;
                     end if;
                    
                    if(motor_state = 0 )then
                            motor_state<=motor_state+1;
                            motorA<="0001";
                    elsif(motor_state = 1 )then
                        motor_state<=motor_state+1;
                        motorA<="0010";
                    elsif(motor_state = 2 )then
                        motor_state<=motor_state+1;
                        motorA<="0100";
                    elsif(motor_state = 3 )then
                        motor_state<=0;
                        motorA<="1000";
                      else
                    end if;
                       
                 else
              end if;
              if(motorone = '0' and motortwo = '1' and motorthree = '0' ) then
                        if(rotate2 < 2100) then
                            rotate2<=rotate2+1;
                       else
                       rotate2<=0;
                       end if;

                  if(motor_stateB = 0 )then
                          motor_stateB<=motor_stateB+1;
                          motorB<="0001";
                  elsif(motor_stateB = 1 )then
                      motor_stateB<=motor_stateB+1;
                      motorB<="0010";
                  elsif(motor_stateB = 2 )then
                      motor_stateB<=motor_stateB+1;
                      motorB<="0100";
                  elsif(motor_stateB = 3 )then
                      motor_stateB<=0;
                      motorB<="1000";
                    else
                  end if;
                     
               else
                end if;
                
                if(motorone = '0' and motortwo = '0' and motorthree = '1' ) then
                        if(rotate3 < 2100) then
                            rotate3<=rotate3+1;
                       else
                       rotate3<=0;
                       end if;

                      if(motor_stateC = 0 )then
                              motor_stateC<=motor_stateC+1;
                              motorC<="0001";
                      elsif(motor_stateC = 1 )then
                          motor_stateC<=motor_stateC+1;
                          motorC<="0010";
                      elsif(motor_stateC = 2 )then
                          motor_stateC<=motor_stateC+1;
                          motorC<="0100";
                      elsif(motor_stateC = 3 )then
                          motor_stateC<=0;
                          motorC<="1000";
                        else
                      end if;
                         
                   else
                    end if;                
              else
           end if;
        end process;
        
        

end Behavioral;


