import json
import sys

data = json.load(open(sys.argv[1]))
for c in data["cells"]:
    print(c.keys())
    c["execution_count"] = None
    c["outputs"] = []

print json.dumps(data, indent=1)
