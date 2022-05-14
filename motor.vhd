library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab06 is
  Port (
  --MOTOR STUFF
    motorA, motorB, motorC  : OUT STD_LOGIC_VECTOR (3 downto 0);
  
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
    Y0, A0, B0: out STD_LOGIC;
     clk:    in STD_LOGIC
     

  );
end lab06;

architecture Behavioral of lab06 is


-- Step 6: Create a signal for rx_data
signal motor_state: integer :=0;
signal motor_stateB: integer :=0;
signal motor_stateC: integer :=0;

signal light: STD_LOGIC_VECTOR(14 downto 0); 
    signal clk_100Hz: STD_LOGIC := '0';
    signal clk_4Hz: STD_LOGIC := '0';

    signal count : integer := 0;
    signal motorone: STD_LOGIC :='0';
    signal motortwo: STD_LOGIC :='0';
    signal motorthree: STD_LOGIC :='0';
    signal move: STD_LOGIC :='0';
    signal rotate1: integer :=0;
    signal rotate2: integer :=0;
    signal rotate3: integer :=0;
    signal state: integer:=0;
    signal money: integer:=100;



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
       
 
    
--Button
    
  
   

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


  --SENSOR STUFF
    cs: BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);
    mosi    : OUT   STD_LOGIC;
    miso    : IN    STD_LOGIC;
    sclk    : BUFFER STD_LOGIC;
    
    -- Buttons
    btnC, btnR, btnL : IN STD_LOGIC;
--Others
    Y0, A0, B0: out STD_LOGIC;
     clk:    in STD_LOGIC
     

  );
end lab06;

architecture Behavioral of lab06 is


-- Step 6: Create a signal for rx_data
signal motor_state: integer :=0;
signal motor_stateB: integer :=0;
signal motor_stateC: integer :=0;

signal light: STD_LOGIC_VECTOR(14 downto 0); 
    signal clk_100Hz: STD_LOGIC := '0';
    signal clk_4Hz: STD_LOGIC := '0';

    signal count : integer := 0;
    signal count1 : integer := 0;
    signal motorone: STD_LOGIC :='0';
    signal motortwo: STD_LOGIC :='0';
    signal motorthree: STD_LOGIC :='0';
    signal move: STD_LOGIC :='0';
    signal rotate: integer :=20000-1;
    signal state: integer:=0;
    signal money: integer:=100;



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
       
  process(clk_100Hz) begin
       if rising_edge(clk_100Hz) then
           if (count1 = (2000000000 - 1)) then
               clk_4Hz <= not clk_4Hz;
               count1<=0;
               else  
                   count1<=count1+1;
           end if;
        end if;
end process;  
    
--Button
coins:   process(clk_100Hz,btnC, btnL, btnR) begin
     if(rising_edge(clk_100Hz) ) then
            if(rotate = 20000000) then
            Y0<='1';
            end if;
             if(btnC='1' ) then
                motorone<='1';
                motortwo<='0';                
                motorthree<='0';
                 rotate<=0;
                 B0<='1';
                 A0<='0';
                 Y0<='0';
                 
             elsif(btnL='1') then
                motorone<='0';
             motortwo<='1';                
             motorthree<='0';
              rotate<=0;

              elsif(btnR='1') then
                   motorone<='0';
                  motortwo<='0';                
                  motorthree<='1';
                   rotate<=0;
            
               else 
               rotate<=rotate+1;
               B0<='0';
               A0<='1';                                                                  
             end if;
             
             
             else
       end if;
                          
   end process;
    
  
   

--MOTOR
    process(clk_100Hz, state) begin
        if( rising_edge(clk_100Hz) ) then
           if(motorone = '1' and motortwo = '0' and motorthree = '0'  ) then
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


