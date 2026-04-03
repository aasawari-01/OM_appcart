import os
import re

dirs_to_search = [
    r"c:\Users\ASUS\AndroidStudioProjects\om_appcart\lib\view\screens",
    r"c:\Users\ASUS\AndroidStudioProjects\om_appcart\lib\feature"
]

for d in dirs_to_search:
    for root, dirs, files in os.walk(d):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        content = f.read()
                    
                    if "floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat" not in content and "floatingActionButton: CustFab" in content:
                        content = re.sub(
                            r"(\s+)floatingActionButton:\s*CustFab",
                            r"\1floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,\1floatingActionButton: CustFab",
                            content
                        )
                        with open(path, "w", encoding="utf-8") as f:
                            f.write(content)
                        print(f"Updated {file}")
                except Exception as e:
                    pass
