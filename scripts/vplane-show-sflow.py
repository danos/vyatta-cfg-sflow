#!/usr/bin/env python3
#
# Copyright (c) 2016 Brocade Communications Systems, Inc.
# Copyright (c) 2019, AT&T Intellectual Property.
# All Rights Reserved.

# SPDX-License-Identifier: GPL-2.0-only

from argparse import ArgumentParser
from vplaned import Controller

def main():
    parser = ArgumentParser()
    parser.add_argument("-s", "--show", action='store_true',
                        help="Show sFlow stats")
    parser.add_argument("-c", "--clear", action='store_true',
                        help="Clear sFlow stats")
    args = parser.parse_args()

    with Controller() as controller:
        for dp in controller.get_dataplanes():
            with dp:
                if args.show:
                    response = dp.string_command("sflow show 0 0 0")
                    print(response)
                elif args.clear:
                    response = dp.string_command("sflow clear 0 0 0")

if __name__ == '__main__':
    main()
