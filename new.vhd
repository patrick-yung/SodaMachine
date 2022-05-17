library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.Numeric_Std.ALL;

entity RunningBlock is
    
    port (
        clk : in std_logic;
    --button
        btnc,btnd,btnr,btnu,btnl: in std_logic;
    --VGA monitor
        hsync, vsync : out std_logic;
        red, green, blue : out std_logic_vector(3 downto 0);
        Reset: in std_logic;
        
    --light Sensor
    cs      : BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);
    mosi    : OUT   STD_LOGIC;
    miso    : IN    STD_LOGIC;
    sclk    : BUFFER STD_LOGIC;
    data    :in std_logic_vector(7 downto 0);
    
    switch  : IN STD_LOGIC_VECTOR(7 downto 0);
    --MOTOR STUFF
    motorA, motorB, motorC  : OUT STD_LOGIC_VECTOR (3 downto 0)

    );
end RunningBlock;

architecture RunningBlock_arch of RunningBlock is
    --------- VGA CONSTANT START ---------
    -- row constants
    constant H_TOTAL : integer := 1344 - 1;
    constant H_SYNC : integer := 48 - 1;
    constant H_BACK : integer := 240 - 1;
    constant H_START : integer := 48 + 240 - 1;
    constant H_ACTIVE : integer := 1024 - 1;
    constant H_END : integer := 1344 - 32 - 1;
    constant H_FRONT : integer := 32 - 1;

    -- column constants
    constant V_TOTAL : integer := 625 - 1;
    constant V_SYNC : integer := 3 - 1;
    constant V_BACK : integer := 12 - 1;
    constant V_START : integer := 3 + 12 - 1;
    constant V_ACTIVE : integer := 600 - 1;
    constant V_END : integer := 625 - 10 - 1;
    constant V_FRONT : integer := 10 - 1;
    signal hcount : integer := 0;
    signal vcount : integer := 0;
    constant ratio: integer := 10;
    --------- VGA CONSTANT END ---------

    -- for clock
    component clock_divider is
        generic (N : integer);
        port (
            clk : in std_logic;
            clk_out : out std_logic
        );
    end component;
    component clk_4hz is
        port (
            clk : in std_logic;
            clk_out : out std_logic
        );
    end component;
    
  --for light sensor
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

    signal clk1Hz, clk10Hz, clk50MHz : std_logic;
    signal light: STD_LOGIC_VECTOR(14 downto 0); 

    -- for the position of block
    constant X_STEP : integer := 40;
    constant Y_STEP : integer := 120;
    constant SIZE : integer := 120;
    signal x : integer := H_START;
    signal y : integer := V_START;
    signal dx : integer := X_STEP;
    signal dy : integer := Y_STEP;


    -- for the color of the block
type colors is (C_Black, C_DarkGreen, C_LightGreen, C_Red, C_White, C_Pink);
        type dollar is array(0 to 6, 0 to 6) of colors;
        type T_2D is array (0 to 5, 0 to 4) of colors;

        
        constant one: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_White,C_Black,C_White,C_White),
        (C_White,C_Black,C_Black,C_White,C_White),
        (C_White,C_White,C_Black,C_White,C_White),
        (C_White,C_White,C_Black,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant two: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant three: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant four: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White));
        
        constant five: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant six: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant seven: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White));
        
        constant eight: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant nine: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_White,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant zero: T_2D:=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White));
        
        constant A: T_2D :=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_White,C_Black,C_White));
        
        constant B: T_2D :=(
        (C_White,C_White,C_White,C_White,C_White),
        (C_White,C_Black,C_Black,C_White,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_White,C_White),
        (C_White,C_Black,C_White,C_Black,C_White),
        (C_White,C_Black,C_Black,C_White,C_White));
        constant dot: T_2D :=(
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White));
        constant tick: T_2D :=(
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_Black,C_White),
            (C_Black,C_White,C_Black,C_White,C_White),
            (C_White,C_Black,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White));
        constant dot2: T_2D :=(
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White));
        constant error: T_2D :=(
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White),
            (C_White,C_White,C_White,C_White,C_White),
            (C_White,C_White,C_Black,C_White,C_White));
    signal color : colors;
    
    --for money
    signal clk_1, clk_4 : std_logic;
    signal s_mode : std_logic := '0';
    signal insert : integer := 50;
    signal state : integer := 0;
    constant itemA : integer := 10;
    constant itemB : integer := 5;    
    signal coin : std_logic := '1';
    signal clk_100Hz: STD_LOGIC := '0';
    signal count : integer := 0;
        signal count1 : integer := 0;

        --Motor Stuff
    signal rotate1: integer :=0;
    signal rotate2: integer :=0;
    signal rotate3: integer :=0;
    signal motor: integer:=0;
    signal motor_state: integer :=0;
    signal motor_stateB: integer :=0;
    signal motor_stateC: integer :=0;
    signal motorone: STD_LOGIC :='0';
    signal motortwo: STD_LOGIC :='0';
    signal motorthree: STD_LOGIC :='0';
begin
    --------- VGA UTILITY START ---------
    -- generate 50MHz clock
    u_clk50mhz : clock_divider generic map(N => 1) port map(clk, clk50MHz);

    -- horizontal counter in [0, H_TOTAL]
    pixel_count_proc : process (clk50MHz)
    begin
        if (rising_edge(clk50MHz)) then
            if (hcount = H_TOTAL) then
                hcount <= 0;
            else
                hcount <= hcount + 1;
            end if;
        end if;
    end process pixel_count_proc;

    -- generate hsync in [0, H_SYNC)
    hsync_gen_proc : process (hcount) begin
        if (hcount <= H_SYNC) then
            hsync <= '1';
        else
            hsync <= '0';
        end if;
    end process hsync_gen_proc;

    -- vertical counter in [0, V_TOTAL]
    line_count_proc : process (clk50MHz)
    begin
        if (rising_edge(clk50MHz)) then
            if (hcount = H_TOTAL) then
                if (vcount = V_TOTAL) then
                    vcount <= 0;
                else
                    vcount <= vcount + 1;
                end if;
            end if;
        end if;
    end process line_count_proc;

    -- generate vsync in [0, V_SYNC)
    vsync_gen_proc : process (vcount)
    begin
        if (vcount <= V_SYNC) then
            vsync <= '1';
        else
            vsync <= '0';
        end if;
    end process vsync_gen_proc;
    --------- VGA UTILITY END ---------

    -- generate 1Hz, 50MHz clock
    u_clk1hz : clock_divider generic map(N => 50000000) port map(clk, clk1Hz);
    u_clk10hz : clock_divider generic map(N => 5000000) port map(clk, clk10Hz);

        u4 : clk_4hz port map(clk, clk_4);

 --button press
 
                       
     process(clk_4, state, btnc,btnd,btnr ) begin

            if rising_edge (clk_4) then
                 if btnu ='1' then
                     s_mode <=not s_mode;
                 elsif btnc = '1' then
                     if  s_mode ='0' and insert >= itemA then
                         insert <= insert - itemA;
                         state<= 1;
                         motorone<='1';
                         motortwo<='0';                
                         motorthree<='0';
                     elsif s_mode ='1' and insert >= itemB then
                         insert <= insert - itemB;
                         state<=2;
                         motorone<='0';
                         motortwo<='1';                
                         motorthree<='0';
                     elsif insert <itemA and insert <itemB then
                         state<=3;
                     end if;
                 elsif btnr = '1' then
                     if insert >0 then
                     insert <= insert -1;
                     motorone<='0';
                     motortwo<='0';                
                     motorthree<='1';
                     elsif insert <0 then
                     insert <= 0;
                     end if;
                 elsif(light(11 downto 5) = 0 and coin ='1') then
                     coin <='0';
                 elsif(light(11 downto 7) = 0 and coin ='0') then
                     coin <='1';
                     insert <= insert +1;
                 else
                 end if;
             end if;
           if rising_edge (clk_4) then
                if(rotate1 < 2100) then
                    rotate1<=rotate1+1;
                end if;
                if(rotate2 < 2100) then
                    rotate2<=rotate2+1;
                end if;
                if(rotate3 < 2100) then
                    rotate3<=rotate3+1;
                end if;
           end if;
           end process;






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






















    -- select the correct color of the pixel (hcount, vcount).
    process (hcount, vcount)
    begin
        if ((hcount >= H_START and hcount < H_END) and (vcount >= V_START and vcount < V_TOTAL)) then
            --Letter A
            if(hcount>H_START+100 and hcount<=H_START+150 and vcount>V_START+100 and vcount <=V_START +160) then
                color <= A((vcount-V_START-100)/ratio,(hcount-H_START-100)/ratio);
             --Letter ':'
            elsif(hcount>H_START+150 and hcount<=H_START+200 and vcount>V_START+100 and vcount <=V_START +160) then 
               color <= dot2((vcount-V_START-100)/ratio,(hcount-H_START-150)/ratio);
           --Letter 1
              elsif(hcount>H_START+200 and hcount<=H_START+250 and vcount>V_START+100 and vcount <=V_START +160) then 
                 color <= one((vcount-V_START-100)/ratio,(hcount-H_START-200)/ratio);          
                 --Letter 3
              elsif(hcount>H_START+250 and hcount<=H_START+300 and vcount>V_START+100 and vcount <=V_START +160) then 
                 color <= zero((vcount-V_START-100)/ratio,(hcount-H_START-250)/ratio);   
                 --Letter 5
              elsif(hcount>H_START+300 and hcount<=H_START+350 and vcount>V_START+100 and vcount <=V_START +160) then 
                 color <= dot((vcount-V_START-100)/ratio,(hcount-H_START-300)/ratio);
               --Letter 7
              elsif(hcount>H_START+350 and hcount<=H_START+400 and vcount>V_START+100 and vcount <=V_START +160) then 
                 color <= zero((vcount-V_START-100)/ratio,(hcount-H_START-350)/ratio);     
               --Letter 9
              elsif(hcount>H_START+400 and hcount<=H_START+450 and vcount>V_START+100 and vcount <=V_START +160) then 
                 color <= zero((vcount-V_START-100)/ratio,(hcount-H_START-400)/ratio);       
                                  
--Second Line
            --Letter B    
            elsif(hcount>H_START+100 and hcount<=H_START+150 and vcount>V_START+160 and vcount <=V_START +220) then 
                  color <= B((vcount-V_START-160)/ratio,(hcount-H_START-100)/ratio);
            --Letter :                
            elsif(hcount>H_START+150 and hcount<=H_START+200 and vcount>V_START+160 and vcount <=V_START +220) then 
                          color <= dot2((vcount-V_START-160)/ratio,(hcount-H_START-150)/ratio); 
            --Letter  2
            elsif(hcount>H_START+200 and hcount<=H_START+250 and vcount>V_START+160 and vcount <=V_START +220) then 
                           color <= zero((vcount-V_START-160)/ratio,(hcount-H_START-200)/ratio);
            --Letter  4
            elsif(hcount>H_START+250 and hcount<=H_START+300 and vcount>V_START+160 and vcount <=V_START +220) then 
                           color <= five((vcount-V_START-160)/ratio,(hcount-H_START-250)/ratio);
            --Letter 6
            elsif(hcount>H_START+300 and hcount<=H_START+350 and vcount>V_START+160 and vcount <=V_START +220) then 
                           color <= dot((vcount-V_START-160)/ratio,(hcount-H_START-300)/ratio);
            --Letter 8
            elsif(hcount>H_START+350 and hcount<=H_START+400 and vcount>V_START+160 and vcount <=V_START +220) then 
                           color <= zero((vcount-V_START-160)/ratio,(hcount-H_START-350)/ratio);
            --Letter0
            elsif(hcount>H_START+400 and hcount<=H_START+450 and vcount>V_START+160 and vcount <=V_START +220) then 
                           color <= zero((vcount-V_START-160)/ratio,(hcount-H_START-400)/ratio);
           --select  items
            elsif(hcount>H_START+450 and hcount<=H_START+500 and vcount>V_START+100 and vcount <=V_START +160 and s_mode='0' ) then 
                           color <= tick((vcount-V_START-100)/ratio,(hcount-H_START-450)/ratio);
           elsif(hcount>H_START+450 and hcount<=H_START+500 and vcount>V_START+160 and vcount <=V_START +220 and s_mode='1') then 
                           color <= tick((vcount-V_START-160)/ratio,(hcount-H_START-450)/ratio);
                           
--Third Line  (icon)
            
--Forth Line (digit)
            elsif(hcount>H_START+100 and hcount<=H_START+150 and vcount>V_START+400 and vcount <=V_START +460) then
            case (insert/10) is
                when 1 => color <= one((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 2 => color <= two((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 3 => color <= three((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);     
                when 4 => color <= four((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 5 => color <= five((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 6 => color <= six((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 7 => color <= seven((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 8 => color <= eight((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 9 => color <= nine((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                when 0 => color <= zero((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);    
                when others=> color <=error((vcount-V_START-400)/ratio,(hcount-H_START-100)/ratio);
                end case;
                
            elsif(hcount>H_START+150 and hcount<=H_START+200 and vcount>V_START+400 and vcount <=V_START +460) then
            case (insert mod 10) is
                when 1 => color <= one((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 2 => color <= two((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 3 => color <= three((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);     
                when 4 => color <= four((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 5 => color <= five((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 6 => color <= six((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 7 => color <= seven((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 8 => color <= eight((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 9 => color <= nine((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
                when 0 => color <= zero((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);    
                when others=> color <=error((vcount-V_START-400)/ratio,(hcount-H_START-150)/ratio);
            end case;
            elsif(hcount>H_START+300 and hcount<=H_START+350 and vcount > V_START+400 and vcount <V_START+460) then
                case(state) is
                when 1 =>color <= A((vcount-V_START-400)/ratio,(hcount-H_START-300)/ratio);
                when 2 =>color <= B((vcount-V_START-400)/ratio,(hcount-H_START-300)/ratio);
                when 3=>color <= error((vcount-V_START-400)/ratio,(hcount-H_START-300)/ratio);
                when others=> color <= error((vcount-V_START-400)/ratio,(hcount-H_START-300)/ratio);
                end case;
            elsif(hcount>H_START+350 and hcount<=H_START+400 and vcount > V_START+400 and vcount <V_START+460 and coin ='0') then
                color <= error((vcount-V_START-400)/ratio,(hcount-H_START-350)/ratio);
            else
                color <= C_Pink;
            end if;
        else
            color <= C_Pink;
        end if;
    end process;
    
    -- output the correct RGB according to the signal 'color'.
    process (color)
    begin
        case(color) is
                when C_Black =>
            red <= "0000";
            green <= "0000";
            blue <= "0000";
            when C_DarkGreen =>
            red <= "0000";
            green <= "1000";
            blue <= "0000";
            when C_LightGreen =>
            red <= "0000";
            green <= "1111";
            blue <= "0000";
            when C_Red =>
            red <= "1111";
            green <= "0000";
            blue <= "0000";
            when C_White =>
            red <= "1111";
            green <= "1111";
            blue <= "1111";
            when C_Pink =>
            red <= "1111";
            green <= "0000";
            blue <= "1111";
            when others =>
            red <= "0000";
            green <= "0000";
            blue <= "0000";
            end case;
    end process; -- 
    
 -- For PMODALS   
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
        tx_data => (others=>'0'),
        miso => miso,
        sclk => sclk,
        ss_n => cs,
        mosi => mosi,
        busy => open,
        rx_data => light
    );
end RunningBlock_arch;
