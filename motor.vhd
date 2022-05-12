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
    Y0: out STD_LOGIC;
     clk:    in STD_LOGIC
     

  );
end lab06;

architecture Behavioral of lab06 is


-- Step 6: Create a signal for rx_data
signal motor_state: integer :=0;
signal light: STD_LOGIC_VECTOR(14 downto 0); 
    signal clk_100Hz: STD_LOGIC := '0';
    signal count : integer := 0;
    signal rotate: integer :=0;
    signal state: integer:=0;
    signal money: integer:=100;



begin

--MOTOR STUFF
 process(clk) begin
        if rising_edge(clk) then
            if (count = (1000000 - 1)) then
                clk_100Hz <= not clk_100Hz;
                count<=0;
                else  
                    count<=count+1;
            end if;
         end if;
         
           
                  
    end process;
    
--Button
    process(btnC, btnL, btnR) begin
        if(btnC = '1' and money>1) then
            money<=money-1;
            state<=1;
        elsif (btnL = '1' and money > 2) then
           money<=money-2;
            state <= 2;
        elsif (btnR = '1') then
            state <=3;
        else
            state<=0;
        end if;
    end process;
    
   

--MOTOR
    process(clk_100Hz) begin
        if(state=1) then
            if(rotate = 0 ) then
                rotate<=1000000;
            else
                rotate <= rotate -1;
            end if;
            if(rotate >0 )then 
                if( rising_edge(clk_100Hz)) then
                        case motor_state is
                        when 0 =>  
                            motor_state<=motor_state+1;
                            motorA<="0001";
                        when 1 => 
                            motor_state<=motor_state+1;
                            motorA<="0010";
    
                        when 2 => 
                            motor_state<=motor_state+1;
                             motorA<="0100";
                        when others => 
                            motor_state<=0;
                            motorA<="1000";
                        end case; 
                    end if;
                end if;
            end if;
            
            if(state=2) then
                if( rising_edge(clk_100Hz)) then
    
                        case motor_state is
                        when 0 =>  
                            motor_state<=motor_state+1;
                            motorB<="0001";
                        when 1 => 
                            motor_state<=motor_state+1;
                            motorB<="0010";
    
                        when 2 => 
                            motor_state<=motor_state+1;
                             motorB<="0100";
                        when others => 
                            motor_state<=0;
                            motorB<="1000";
                        end case; 
                    end if;
                end if;
                
                if(state=3) then
                    if( rising_edge(clk_100Hz)) then
        
                            case motor_state is
                            when 0 =>  
                                motor_state<=motor_state+1;
                                motorC<="0001";
                            when 1 => 
                                motor_state<=motor_state+1;
                                motorC<="0010";
                            when 2 => 
                                motor_state<=motor_state+1;
                                 motorC<="0100";
                            when others => 
                                motor_state<=0;
                                motorC<="1000";
                            end case; 
                        end if;
                    end if;
                

        end process;
        
        
        
      

end Behavioral;