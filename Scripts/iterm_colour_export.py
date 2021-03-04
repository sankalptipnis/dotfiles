# This script takes an iTerm Color Profile as an argument and translates it for use with Visual Studio Code's built-in terminal 
# or Sublime Text's Termius terminal.

# Usage : python iterm_colour_export.py [-o OUTPUT] iterm_colour_profile
# e.g.:   python iterm_colour_export.py default.json -o sublime

# To export an iTerm Color Profile:
#       1) Open iTerm
#       2) Go to Preferences -> Profiles -> Colors
#       3) Other Actions -> Save Profile as JSON

# To generate the applicable color settings and use them in VS Code:
#       1) Run this script from the command line: python iterm_colour_export.py [iterm_colour_profile_json_file] -o vsc
#       2) In VS Code, Go to Preferences -> Settings -> Workbench -> Appearance -> Color Customizations -> Edit in settings.json
#       3) Copy and paste the output from the script under `"workbench.colorCustomizations"`

# To generate the applicable color settings and use them in Sublime Text:
#       1) Run this script from the command line: python iterm_colour_export.py [iterm_colour_profile_json_file] -o sublime
#       2) In Sublime Text, Go to Command Palette (Command + Shift + P) -> Preferences: Termius Settings
#       3) Copy and paste the output from the script into `Terminus.sublime-settings -- User` under `"user_theme_colors"`
#       4) Add `"theme": "user"` into `Terminus.sublime-settings

import json
from pathlib import Path
import argparse

sublime_dict = {
    'background': 'Background Color',
    'foreground': 'Foreground Color',
    'black': 'Ansi 0 Color',
    'red': 'Ansi 1 Color',
    'green': 'Ansi 2 Color',
    'yellow': 'Ansi 3 Color',
    'blue': 'Ansi 4 Color',
    'magenta': 'Ansi 5 Color',
    'cyan': 'Ansi 6 Color',
    'white': 'Ansi 7 Color',
    'light_black': 'Ansi 8 Color',
    'light_red': 'Ansi 9 Color',
    'light_green': 'Ansi 10 Color',
    'light_brown': 'Ansi 11 Color',
    'light_blue': 'Ansi 12 Color',
    'light_magenta': 'Ansi 13 Color',
    'light_cyan': 'Ansi 14 Color',
    'light_white': 'Ansi 15 Color',
}

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


def convert(iterm_colour_profile_json, output_mode):

    if output_mode == 'vsc':
        mapping = vsc_dict
    elif output_mode == 'sublime':
        mapping = sublime_dict
    else:
        raise ValueError("Output mode must be one of 'vsc' or 'sublime'.")
        
    res = dict()

    for property, colour in mapping.items():
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
    parser.add_argument('-o', '--output', type=str, help='text editor for which the colour profile is required: must be one of "vsc" or "sublime".', default='vsc')
    
    args = parser.parse_args()
    
    iterm_colour_profile_file = Path(args.iterm_colour_profile)
    
    with open(iterm_colour_profile_file) as json_file:
        iterm_colour_profile_json = json.load(json_file)
        
    res = convert(iterm_colour_profile_json, args.output)
    
    print(res)

if __name__ == "__main__":
    main()


    
    
    
    
    


    
    



