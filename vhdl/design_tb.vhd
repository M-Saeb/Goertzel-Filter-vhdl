library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity goertzel_algorithm_tb is
end goertzel_algorithm_tb;

architecture Behavioral of goertzel_algorithm_tb is
    -- DUT component declaration
    component goertzel_algorithm is
        port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            start       : in  STD_LOGIC;
            sample_in   : in  STD_LOGIC_VECTOR(13 downto 0);
            real_part   : out STD_LOGIC_VECTOR(33 downto 0);
            imag_part   : out STD_LOGIC_VECTOR(33 downto 0);
            magnitude_squared : out STD_LOGIC_VECTOR(33 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '1';
    signal start       : STD_LOGIC := '0';
    signal sample_in   : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');
    signal real_part   : STD_LOGIC_VECTOR(33 downto 0);
    signal imag_part   : STD_LOGIC_VECTOR(33 downto 0);
    signal magnitude_squared : STD_LOGIC_VECTOR(33 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate DUT
    uut: goertzel_algorithm
        port map (
            clk => clk,
            rst => rst,
            start => start,
            sample_in => sample_in,
            real_part => real_part,
            imag_part => imag_part,
            magnitude_squared => magnitude_squared
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_process : process
        file input_file : text open read_mode is "matlab/signal_files/sine_phase_digital.txt";
        variable line_in : line;
        variable hex_val : string(1 to 3);
        variable sample_unsigned : unsigned(13 downto 0);
        variable n : integer := 0;
    begin
        -- Reset
        rst <= '1';
        wait for clk_period * 2;
        rst <= '0';
        wait for clk_period;

        -- Feed samples
        while not endfile(input_file) loop
            readline(input_file, line_in);
            read(line_in, hex_val);
            sample_unsigned := to_unsigned(to_integer(image'("16#" & hex_val)), 14);
            sample_in <= std_logic_vector(sample_unsigned);
            start <= '1';
            wait for clk_period;
            start <= '0';
            wait for clk_period;
            n := n + 1;
        end loop;
        file_close(input_file);

        -- Wait for outputs to settle
        wait for clk_period * 1000;
        report "Testbench finished.";
        wait;
    end process;

end Behavioral;
