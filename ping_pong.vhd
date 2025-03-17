library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ping_pong is
  port (
    clk : in std_logic;
    reset : in std_logic;
    K : in std_logic;
    P : in std_logic;
    ret : out std_logic_vector(0 to 9);
	 HEX0, HEX2 : out std_logic_vector(6 downto 0)
  );
end ping_pong;

architecture ping_pong of ping_pong is
  type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21);
  signal present_state : state;
  signal next_state : state;
  signal kk, pp : std_logic;
  signal clk2hz : std_logic;
  signal dcnt : std_logic_vector(24 downto 0);
  signal kwin : std_logic_vector(3 downto 0);
  signal pwin : std_logic_vector(3 downto 0);
  signal kdot : std_logic_vector(2 downto 0);
  signal pdot : std_logic_vector(2 downto 0);
begin
  kk <= K;
  pp <= P;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if dcnt = 24999999 then
        dcnt <= "0000000000000000000000000";
      else
        dcnt <= dcnt + 1;
      end if;
    end if;
  end process;

  clk2hz <= dcnt(24); --2Hz
  process (clk2hz, reset)
  begin
    if reset = '0' then
      present_state <= s0;
    elsif clk2hz'event and clk2hz = '1' then
      present_state <= next_state;
    end if;
  end process;
  
  process (pp, kk, present_state, reset)
  begin
    if reset = '0' then
		pwin <= "0000";
		kwin <= "0000";
		next_state <= s0;
	 else 
		 if present_state = s0 then
			if pp = '0' then
			  next_state <= s1;
			elsif pp = '1' then
			  next_state <= s0;
			end if;
		 elsif present_state = s9 then
			if kk = '1' then
			  next_state <= s10;
			elsif kk = '0' then
				pwin <= pwin + 1;
			  next_state <= s0;
			end if;
		 elsif present_state = s10 then
			if kk = '1' then
			  next_state <= s0;
			elsif kk = '0' then
			  next_state <= s11;
			end if;
		 elsif present_state = s18 then
			if pp = '0' then
				next_state <= s20;
			elsif pp = '1' then
			  next_state <= s19;
			end if;
		 elsif present_state = s19 then
			if pp = '0' then
			  next_state <= s2;
			elsif pp = '1' then
				next_state <= s20;
			end if;
		 elsif present_state = s20 then
			if kk = '1' then
			  next_state <= s20;
			elsif kk = '0' then
			  next_state <= s21;
			end if;
		 elsif present_state = s21 then
			next_state <= s11;
		 else
			if present_state = s1 then
			  next_state <= s2;
			elsif present_state = s2 then
			  next_state <= s3;
			elsif present_state = s3 then
			  next_state <= s4;
			elsif present_state = s4 then
			  next_state <= s5;
			elsif present_state = s5 then
			  next_state <= s6;
			elsif present_state = s6 then
			  next_state <= s7;
			elsif present_state = s7 then
			  next_state <= s8;
			elsif present_state = s8 then
			  next_state <= s9;
			elsif present_state = s11 then
			  next_state <= s12;
			elsif present_state = s12 then
			  next_state <= s13;
			elsif present_state = s13 then
			  next_state <= s14;
			elsif present_state = s14 then
			  next_state <= s15;
			elsif present_state = s15 then
			  next_state <= s16;
			elsif present_state = s16 then
			  next_state <= s17;
			elsif present_state = s17 then
			  next_state <= s18;
			end if;
		 end if;
		 if present_state = s0 then
			ret <= "0000000000";
		 elsif present_state = s1 then
			ret <= "1000000000";
		 elsif present_state = s2 then
			ret <= "0100000000";
		 elsif present_state = s3 then
			ret <= "0010000000";
		 elsif present_state = s4 then
			ret <= "0001000000";
		 elsif present_state = s5 then
			ret <= "0000100000";
		 elsif present_state = s6 then
			ret <= "0000010000";
		 elsif present_state = s7 then
			ret <= "0000001000";
		 elsif present_state = s8 then
			ret <= "0000000100";
		 elsif present_state = s9 then
			ret <= "0000000010";
		 elsif present_state = s10 then
			ret <= "0000000001";
		 elsif present_state = s11 then
			ret <= "0000000010";
		 elsif present_state = s12 then
			ret <= "0000000100";
		 elsif present_state = s13 then
			ret <= "0000001000";
		 elsif present_state = s14 then
			ret <= "0000010000";
		 elsif present_state = s15 then
			ret <= "0000100000";
		 elsif present_state = s16 then
			ret <= "0001000000";
		 elsif present_state = s17 then
			ret <= "0010000000";
		 elsif present_state = s18 then
			ret <= "0100000000";
		 elsif present_state = s19 then
			ret <= "1000000000";
		 elsif present_state = s20 then
			ret <= "0000000000";
		 elsif present_state = s21 then
			ret <= "0000000001";
		 end if;
	  end if;
  end process;
  
  HEX0 <= "1000000" when pwin = 0 else
    "1111001" when pwin = 1 else
    "0100100" when pwin = 2 else
    "0110000" when pwin = 3 else
    "0011001" when pwin = 4 else
    "0010010" when pwin = 5 else
    "0000010" when pwin = 6 else
    "1111000" when pwin = 7 else
    "0000000" when pwin = 8 else
    "0010000" when pwin = 9 else
    "1111111";
	 
	HEX2 <= "1000000" when kwin = 0 else
    "1111001" when kwin = 1 else
    "0100100" when kwin = 2 else
    "0110000" when kwin = 3 else
    "0011001" when kwin = 4 else
    "0010010" when kwin = 5 else
	 "1111111";
end ping_pong;