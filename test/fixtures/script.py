#!/usr/bin/env python3
"""Check pod health across a Kubernetes namespace."""

import argparse
import subprocess
import sys
from dataclasses import dataclass


@dataclass
class Pod:
    name: str
    namespace: str
    status: str

    @property
    def healthy(self) -> bool:
        return self.status == "Running"


def get_pods(namespace: str) -> list[Pod]:
    result = subprocess.run(
        ["kubectl", "get", "pods", "-n", namespace, "--no-headers",
         "-o", "custom-columns=NAME:.metadata.name,STATUS:.status.phase"],
        capture_output=True,
        text=True,
        check=True,
    )
    pods = []
    for line in result.stdout.strip().splitlines():
        parts = line.split()
        if len(parts) == 2:
            pods.append(Pod(name=parts[0], namespace=namespace, status=parts[1]))
    return pods


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("namespace", default="default", nargs="?")
    args = parser.parse_args()

    pods = get_pods(args.namespace)
    if not pods:
        print(f"No pods found in {args.namespace}", file=sys.stderr)
        return 1

    failed = [p for p in pods if not p.healthy]
    for pod in pods:
        status = "OK" if pod.healthy else "FAIL"
        print(f"  [{status}] {pod.name}: {pod.status}")

    return len(failed)


if __name__ == "__main__":
    sys.exit(main())
