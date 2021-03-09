-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- Generated by Quartus II Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version
-- Created on Tue Mar 09 17:29:47 2021

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY StateMachine IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';
        direction : IN STD_LOGIC := '0';
        enable : IN STD_LOGIC := '0';
        output_1 : OUT STD_LOGIC;
        output_2 : OUT STD_LOGIC
    );
END StateMachine;

ARCHITECTURE BEHAVIOR OF StateMachine IS
    TYPE type_fstate IS (s0,s1,s2,s3);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,direction,enable)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= s0;
            output_1 <= '0';
            output_2 <= '0';
        ELSE
            output_1 <= '0';
            output_2 <= '0';
            CASE fstate IS
                WHEN s0 =>
                    IF (((direction = '1') AND (enable = '1'))) THEN
                        reg_fstate <= s1;
                    ELSIF (NOT((enable = '1'))) THEN
                        reg_fstate <= s0;
                    ELSIF ((NOT((direction = '1')) AND (enable = '1'))) THEN
                        reg_fstate <= s3;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= s0;
                    END IF;

                    output_2 <= '1';

                    output_1 <= '1';
                WHEN s1 =>
                    IF (((direction = '1') AND (enable = '1'))) THEN
                        reg_fstate <= s2;
                    ELSIF (NOT((enable = '1'))) THEN
                        reg_fstate <= s1;
                    ELSIF ((NOT((direction = '1')) AND (enable = '1'))) THEN
                        reg_fstate <= s0;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= s1;
                    END IF;

                    output_2 <= '0';

                    output_1 <= '1';
                WHEN s2 =>
                    IF (((direction = '1') AND (enable = '1'))) THEN
                        reg_fstate <= s3;
                    ELSIF (NOT((enable = '1'))) THEN
                        reg_fstate <= s2;
                    ELSIF ((NOT((direction = '1')) AND (enable = '1'))) THEN
                        reg_fstate <= s1;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= s2;
                    END IF;

                    output_2 <= '0';

                    output_1 <= '0';
                WHEN s3 =>
                    IF (((direction = '1') AND (enable = '1'))) THEN
                        reg_fstate <= s0;
                    ELSIF (NOT((enable = '1'))) THEN
                        reg_fstate <= s3;
                    ELSIF ((NOT((direction = '1')) AND (enable = '1'))) THEN
                        reg_fstate <= s2;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= s3;
                    END IF;

                    output_2 <= '1';

                    output_1 <= '0';
                WHEN OTHERS => 
                    output_1 <= 'X';
                    output_2 <= 'X';
                    report "Reach undefined state";
            END CASE;
        END IF;
    END PROCESS;
END BEHAVIOR;
