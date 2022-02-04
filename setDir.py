import sys
import json

if __name__ == "__main__":
    settings, target = sys.argv[1:3]

    s = "".join(line for line in open(settings).readlines() if not line.strip().startswith("//"))
    data = json.loads(s)
    defaultProfile = data["defaultProfile"]
    for profile in data["profiles"]["list"]:
        profile["startingDirectory"] = target
    
    open(settings, "w").write(json.dumps(data, indent=4))
