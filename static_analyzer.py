#-------------------------------------------------------
# File name   : static_analyzer.py
# Developers  : I.A. Martynenko
# Email       : <MartynenkoIA@mpei.ru>
# Date        : 26.05.2026
# Version     : 1.0
# Description : Static analyzer for Verilog files. Finds parameters and signals dependent on them.
# Run command : python static_analyzer.py <path_to_verilog_file>
# Options     : <path_to_verilog_file> - mandatory path to the .v file to be analyzed.
#-------------------------------------------------------

import sys
import re

def analyze_verilog(filepath):
    # Dictionary to store found parameters
    parameters = []
    
    # Regular expressions for finding parameters and signals
    # Matches: parameter PARAM_NAME = ...
    param_pattern = re.compile(r'\bparameter\s+([A-Za-z0-9_]+)\b')
    # Matches: input/output/wire/reg [SOMETHING-1:0] signal_name
    signal_pattern = re.compile(r'\b(?:input|output|wire|reg)\s+(?:wire\s+|reg\s+)?\[(.*?)\]\s+([A-Za-z0-9_]+)')

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Error: File {filepath} not found.")
        return

    # Pass 1: Find all parameters
    for line in lines:
        param_match = param_pattern.search(line)
        if param_match:
            parameters.append(param_match.group(1))

    print("=== Static Analysis Report ===")
    print(f"File analyzed: {filepath}")
    print(f"Parameters found: {', '.join(parameters) if parameters else 'None'}\n")
    print("Signals dependent on parameters:")
    print("-" * 50)

    found_dependent_signals = False

    # Pass 2: Find signals and check if their width depends on parameters
    for line_num, line in enumerate(lines, start=1):
        signal_matches = signal_pattern.finditer(line)
        for match in signal_matches:
            width_str = match.group(1) # e.g. "DATA_WIDTH-1:0"
            signal_name = match.group(2)
            
            # Check if any known parameter is inside the width definition
            dependent_params = [p for p in parameters if p in width_str]
            
            if dependent_params:
                found_dependent_signals = True
                print(f"Line {line_num:4d} | Signal: {signal_name:10s} | Width: [{width_str}] | Depends on: {', '.join(dependent_params)}")

    if not found_dependent_signals:
        print("No parameter-dependent signals found.")
        
    print("-" * 50)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python static_analyzer.py <file.v>")
    else:
        analyze_verilog(sys.argv[1])