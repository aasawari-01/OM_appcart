import os
import re

lib_path = r'c:\Users\ASUS\AndroidStudioProjects\om_appcart\lib'

# 1. First, find all files containing FlutterStepIndicator and remove it
def remove_step_indicator():
    for root, dirs, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                if 'FlutterStepIndicator' in content:
                    print(f"Removing FlutterStepIndicator from {file_path}")
                    # Remove import
                    content = re.sub(r"import 'package:flutter_stepindicator/flutter_stepindicator\.dart';\n*", "", content)
                    
                    # Remove the FlutterStepIndicator widget block
                    # It usually looks like Padding( ... child: FlutterStepIndicator( ...  ) ),
                    # We will use regex to find FlutterStepIndicator block or just do it with string replace if they are all identical.
                    # Since parsing widgets with regex is hard, let's look for:
                    pattern1 = r'\s*Padding\(\s*padding:\s*const\s*EdgeInsets\.symmetric\(horizontal:\s*16,\s*vertical:\s*12\),\s*child:\s*FlutterStepIndicator\([\s\S]*?onChange:\s*\(i\)\s*\{\},[\s\S]*?\),[\s\S]*?\),\s*SizedBox\(height:\s*ResponsiveHelper\.spacing\(context,\s*8\)\),'
                    
                    content = re.sub(pattern1, "", content)
                    
                    # Also try without the SizedBox
                    pattern2 = r'\s*Padding\(\s*padding:\s*const\s*EdgeInsets\.symmetric\(horizontal:\s*16,\s*vertical:\s*12\),\s*child:\s*FlutterStepIndicator\([\s\S]*?onChange:\s*\(i\)\s*\{\},[\s\S]*?\),\s*?\),'
                    content = re.sub(pattern2, "", content)

                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(content)

# 2. Add isForm: true to CustomAppBar
def update_custom_app_bar():
    for root, dirs, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart') and 'custom_app_bar' not in file:
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                if 'CustomAppBar(' in content:
                    # Decide if it's a form. 
                    # We assume it is a form if the file is NOT a list screen.
                    # Usually list screens have "list" in their names.
                    is_form = False
                    if 'list' not in file.lower() and ('form' in file.lower() or 'screen' in file.lower() or 'detail' in file.lower()):
                        # Further heuristic: does it have _steps or is it a form-like entity?
                        # Actually the user said "app bar filter should show only to list screens not form"
                        # So if it's not a list screen, it's a form/detail screen where filter should NOT show.
                        if 'list' not in file.lower():
                            is_form = True

                    # Wait, lost_and_found_screen is a list screen in reality?
                    if file == 'lost_and_found_screen.dart':
                        # Lost and found screen has a List of items, it IS a list screen
                        is_form = False
                    if file == 'complaint_feedback_screen.dart':
                         is_form = True # form
                    if file == 'create_failure_screen.dart':
                         is_form = True 
                    if file == 'occ_failure_screen.dart' or file == 'station_failure_screen.dart' or file == 'station_diary_screen.dart':
                         is_form = True 

                    # If it has Stepper:
                    if '_currentStep' in content and '_steps' in content:
                        is_form = True
                    
                    if is_form:
                        # Replace CustomAppBar(title: '...', ...)
                        # with CustomAppBar(title: '...', isForm: true, currentStep: _currentStep, totalSteps: _steps.length, ...) if step variables exist
                        
                        # First, if it already has isForm, skip
                        if 'isForm:' in content:
                            continue
                        
                        has_steps = '_currentStep' in content and '_steps' in content
                        
                        def replacer(match):
                            original = match.group(0)
                            # add isForm: true,
                            if has_steps:
                                replacement = original + "\n          isForm: true,\n          currentStep: _currentStep,\n          totalSteps: _steps.length,"
                            else:
                                replacement = original + "\n          isForm: true,"
                            return replacement

                        # The regex matches CustomAppBar(
                        new_content = re.sub(r'CustomAppBar\(', replacer, content)
                        
                        if new_content != content:
                            print(f"Updated CustomAppBar in {file_path}")
                            with open(file_path, 'w', encoding='utf-8') as f:
                                f.write(new_content)

remove_step_indicator()
update_custom_app_bar()
