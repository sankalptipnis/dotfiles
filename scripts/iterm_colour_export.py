#!/usr/bin/env python3

# This script takes an iTerm Color Profile as an argument and translates it for use with 
# Visual Studio Code's built-in terminal.

# To export an iTerm Color Profile:
#  1) Open iTerm
#  2) Go to Preferences -> Profiles -> Colors
#  3) Other Actions -> Save Profile as JSON

# To generate the applicable color settings and use them in VS Code:
#  1) Run this script from the command line: 
#     python iterm_colour_export.py [iterm_colour_profile_json_file] -o vsc
#  2) In VS Code, go to 
#     Preferences -> Settings -> Workbench -> Appearance -> Color Customizations -> Edit in settings.json
#  3) Copy and paste the output from the script under `"workbench.colorCustomizations"`

import json
from pathlib import Path
import argparse

vsc_dict = {
    'terminal.background': 'Background Color',
    'terminal.foreground': 'Foreground Color',
    'terminalCursor.background': 'Cursor Text Color',
    'terminalCursor.foreground': 'Cursor Color',
    'terminal.ansiBlack': 'Ansi 0 Color',
    'terminal.ansiRed': 'Ansi 1 Color',
    'terminal.ansiGreen': 'Ansi 2 Color',
    'terminal.ansiYellow': 'Ansi 3 Color',
    'terminal.ansiBlue': 'Ansi 4 Color',
    'terminal.ansiMagenta': 'Ansi 5 Color',
    'terminal.ansiCyan': 'Ansi 6 Color',
    'terminal.ansiWhite': 'Ansi 7 Color',
    'terminal.ansiBrightBlack': 'Ansi 8 Color',
    'terminal.ansiBrightRed': 'Ansi 9 Color',
    'terminal.ansiBrightGreen': 'Ansi 10 Color',
    'terminal.ansiBrightYellow': 'Ansi 11 Color',
    'terminal.ansiBrightBlue': 'Ansi 12 Color',
    'terminal.ansiBrightMagenta': 'Ansi 13 Color',
    'terminal.ansiBrightCyan': 'Ansi 14 Color',
    'terminal.ansiBrightWhite': 'Ansi 15 Color',    
}


def component_to_hex(c):
    hex_value = hex(c)[2:]
    if len(hex_value) == 1:
        return f"0{hex_value}"
    else:
        return hex_value


def convert(iterm_colour_profile_json):

    res = dict()

    for property, colour in vsc_dict.items():
        colour_values = iterm_colour_profile_json[colour]
        red = component_to_hex(int(colour_values['Red Component'] * 255))
        green = component_to_hex(int(colour_values['Green Component'] * 255))
        blue = component_to_hex(int(colour_values['Blue Component'] * 255))
        output_value = f"#{red}{green}{blue}"
        res[property] = output_value
        
    return json.dumps(res, indent=4)
    
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('iterm_colour_profile', type=str, help='path to the file containing the iterm colour profile')
    
    args = parser.parse_args()
    
    iterm_colour_profile_file = Path(args.iterm_colour_profile)
    
    with open(iterm_colour_profile_file) as json_file:
        iterm_colour_profile_json = json.load(json_file)
        
    res = convert(iterm_colour_profile_json)
    
    print(res)


if __name__ == "__main__":
    main()


    
    
    
    
    


    
    



