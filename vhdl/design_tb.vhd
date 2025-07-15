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
        file input_file : text open read_mode is "sine_phase_digital.txt";
        variable line_in : line;
        variable hex_val : string(1 to 4);
        variable sample_unsigned : unsigned(13 downto 0);
        variable n : integer := 0;
        variable i : integer; -- For manual hex conversion
        variable out_line : line; -- For outputting results
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

            -- Manual hex string to integer conversion
            i := 0;
            for idx in 1 to 4 loop
                i := i * 16;
                case hex_val(idx) is
                    when '0' to '9' => i := i + character'pos(hex_val(idx)) - character'pos('0');
                    when 'A' to 'F' => i := i + 10 + character'pos(hex_val(idx)) - character'pos('A');
                    when 'a' to 'f' => i := i + 10 + character'pos(hex_val(idx)) - character'pos('a');
                    when others => null;
                end case;
            end loop;

            sample_unsigned := to_unsigned(i, 14);
            sample_in <= std_logic_vector(sample_unsigned);
            start <= '1';
            wait for clk_period;
            start <= '0';
            wait for clk_period;
            n := n + 1;
        end loop;

        -- Wait for outputs to settle
        wait for clk_period * 10;

		-- Print magnitude_squared value
        write(out_line, string'("Magnitude Squared: "));
        write(out_line, to_integer(unsigned(magnitude_squared)));
        writeline(output, out_line);

		report "Testbench finished.";
    end process;

end Behavioral;
