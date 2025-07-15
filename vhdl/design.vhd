library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity goertzel_algorithm is
    port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        start       : in  STD_LOGIC;
        sample_in   : in  STD_LOGIC_VECTOR(13 downto 0); -- 14-bit unsigned input
        real_part   : out STD_LOGIC_VECTOR(33 downto 0); -- 34-bit output
        imag_part   : out STD_LOGIC_VECTOR(33 downto 0); -- 34-bit output
        magnitude_squared : out STD_LOGIC_VECTOR(33 downto 0) -- 34-bit output
    );
end goertzel_algorithm;

architecture Behavioral of goertzel_algorithm is
    constant N : integer := 137; -- Number of samples
    -- Precomputed coefficients (replace with your actual values from MATLAB/Python)
    constant k : integer := 3; -- Rounded value of (N * f_target / f_sample)
    constant cosine : integer := 16384; -- Q14 format, cos(w) ~ 1.0
    constant sine   : integer := 4012;  -- Q14 format, sin(w) ~ 0.2447
    constant coeff  : integer := 32768; -- Q14 format, 2*cos(w) ~ 2.0

    signal Q1, Q2 : integer := 0;
    signal sample_count : integer range 0 to N := 0;
    signal real_out, imag_out, mag_sq_out : integer := 0;

begin
    process(clk, rst)
        variable Q0_var : integer := 0;
    begin
        if rst = '1' then
            Q1 <= 0;
            Q2 <= 0;
            sample_count <= 0;
            real_out <= 0;
            imag_out <= 0;
            mag_sq_out <= 0;
        elsif rising_edge(clk) then
            if start = '1' then
                if sample_count < N then
                    -- Using Q14 (Value of 16384) to handle floating-point operations
                    Q0_var := (coeff * Q1) / 16384 - Q2 + to_integer(unsigned(sample_in));
                    Q2 <= Q1;
                    Q1 <= Q0_var;
                    sample_count <= sample_count + 1;
                else
                    real_out <= Q1 - (Q2 * cosine) / 16384;
                    imag_out <= (Q2 * sine) / 16384;
                    mag_sq_out <= (Q1 - (Q2 * cosine) / 16384) * (Q1 - (Q2 * cosine) / 16384) + ((Q2 * sine) / 16384) * ((Q2 * sine) / 16384);
                end if;
            end if;
        end if;
    end process;

    real_part <= std_logic_vector(to_signed(real_out, 34));
    imag_part <= std_logic_vector(to_signed(imag_out, 34));
    magnitude_squared <= std_logic_vector(to_signed(mag_sq_out, 34));

end Behavioral;
