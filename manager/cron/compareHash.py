#!/bin/python3

import argparse
import json
from json.decoder import JSONDecodeError
import os
import sys

parser = argparse.ArgumentParser(description="Compare hashes for web server")
parser.add_argument("--api", type=str, required=True, help="api hash")
parser.add_argument("--site", type=str, required=True, help="site hash")

args = parser.parse_args()


def rewrite():
    with open(f"{sys.path[0]}/data.json", "w") as file:
        file.write(json.dumps({"api": args.api, "site": args.site}))


if not os.path.exists(f"{sys.path[0]}/data.json"):
    rewrite()
    print("api,site")
    exit(0)


try:
    file = open(f"{sys.path[0]}/data.json", "r")

    prevData = json.load(file)

    if "site" not in prevData or "api" not in prevData:
        rewrite()
        print("api,site")
        exit(0)

    if args.api != prevData["api"] and args.site != prevData["site"]:
        rewrite()
        print("api,site")
    elif args.api != prevData["api"]:
        rewrite()
        print("api")
    elif args.site != prevData["site"]:
        rewrite()
        print("site")
except JSONDecodeError:
    rewrite()
    print("api,site")
