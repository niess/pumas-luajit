#! /usr/bin/env python3
import os
import shutil
import subprocess


def pre_build(*args, **kwargs):
    if not os.path.exists('docs/docs/index.md'):
        shutil.copy('README.md', 'docs/docs/index.md')

    subprocess.run('./docs/scripts/generate-coverage.sh', shell=True,
        capture_output=False)


if __name__ == '__main__':
    pre_build()
