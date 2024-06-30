library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity goertzel_filter is
    port (
        input_signal : in unsigned (11 downto 0); -- 12-bit unsigned input
        clk : in std_logic;                       -- Clock signal
        rst : in std_logic;                       -- Reset signal
        magnitude : out signed(39 downto 0)       -- 40-bit signed output magnitude
    );
end entity goertzel_filter;

architecture Behavioral of goertzel_filter is
    constant N : integer := 135;  -- Number of samples
    constant cosine_coef : signed(19 downto 0) := to_signed(18631, 20); -- Calculated coefficient
    constant sine_coef : signed(19 downto 0) := to_signed(5860, 20);    -- Calculated coefficient
    constant scale_factor : signed(19 downto 0) := to_signed(10000, 20);
    
    signal q0_v : signed(19 downto 0) := (others => '0');
    signal q1_v : signed(19 downto 0) := (others => '0');
    signal q2_v : signed(19 downto 0) := (others => '0');
    signal real_part_v : signed(19 downto 0) := (others => '0');
    signal imag_part_v : signed(19 downto 0) := (others => '0');
    
begin
    process (clk, rst)
        variable q0 : signed(19 downto 0) := (others => '0');
        variable q1 : signed(19 downto 0) := (others => '0');
        variable q2 : signed(19 downto 0) := (others => '0');
        variable real_part : signed(19 downto 0) := (others => '0');
        variable imag_part : signed(19 downto 0) := (others => '0');
        variable input_sample : signed(19 downto 0);
        variable magnitude_temp : signed(39 downto 0);
    begin
        if rst = '1' then
            q0 := (others => '0');
            q1 := (others => '0');
            q2 := (others => '0');
            real_part := (others => '0');
            imag_part := (others => '0');
            magnitude <= (others => '0');
        elsif rising_edge(clk) then
            -- Convert 12-bit unsigned input signal to 20-bit signed
            input_sample := signed(resize(input_signal, 20)) - (2**11);
            
            q0 := input_sample + resize(cosine_coef * q1 / scale_factor, 20) - q2;
            q2 := q1;
            q1 := q0;
            
            real_part := q1 - resize(q2 * cosine_coef / scale_factor, 20);
            imag_part := resize(q2 * sine_coef / scale_factor, 20);
            
            magnitude_temp := resize(real_part * real_part + imag_part * imag_part, 40);
            magnitude <= magnitude_temp;
            
            q0_v <= q0;
            q1_v <= q1;
            q2_v <= q2;
            real_part_v <= real_part;
            imag_part_v <= imag_part;
        end if;
    end process;
end architecture Behavioral;
