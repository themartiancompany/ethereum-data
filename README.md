[comment]: <> (SPDX-License-Identifier: AGPL-3.0)

[comment]: <> (-----------------------------------------)
[comment]: <> (Copyright © 2026)
[comment]: <> (            Pellegrino Prevete)
[comment]: <> (All rights reserved)
[comment]: <> (-----------------------------------------)

[comment]: <> (This program is free software: you can)
[comment]: <> (redistribute it and/or modify it under)
[comment]: <> (the terms of the GNU Affero General)
[comment]: <> (Public License as published by the)
[comment]: <> (Free Software Foundation, either version)
[comment]: <> (3 of the License.)

[comment]: <> (This program is distributed in the hope)
[comment]: <> (that it will be useful, but WITHOUT ANY)
[comment]: <> (WARRANTY; without even the implied)
[comment]: <> (warranty of MERCHANTABILITY or FITNESS)
[comment]: <> (FOR A PARTICULAR PURPOSE. See the GNU)
[comment]: <> (AFFERO General Public License for more)
[comment]: <> (details.)

[comment]: <> (You should have received a copy of the)
[comment]: <> (GNU Affero General Public License along)
[comment]: <> (with this program. If not, see)
[comment]: <> (<https://www.gnu.org/licenses/>.)

# EVM Chains

Currently
[EVMFS](
  https://github.com/themartiancompany/evmfs)
and
[NPM](
  https://www.npmjs.com)
mirrors of the blockchain networks dataset managed by
[Ligi](
  https://github.com/themartiancompany/chains).

At a later point JSON obtained from a smart
editable contract version deployment of the data
on that list.

Right now it is in the sense that you can edit
the evmfs link in the Makefile to point to another
JSON

The smart contract deployment is supposed to
mirror the data, or at least contain the RPC
links because this package is a dependency for
[LibEVM](
  https://github.com/themartiancompany/libevm).

## Build

You can build the NPM package with Make
with the command

```bash
make
```

## Install

The data can be installed with the command

```bash
make \
  install
```

The data can be retrieved from NPM
with the command

```bash
npm \
  install \
  "ethereum-data"

## Forking (re-publishing) a new list

After the package is build one can republish an
edited version of the list on the EVMFS by typing

```bash
make \
  publish
```

To republish the package
on NPM on his/her own namespace one can type

```bash
make \
  publish-npm
```

After appropriately editing the `package.json`.

## License

This Document is released by Pellegrino Prevete
under the terms of the GNU Affero General Public
License version 3.

The chain list under MIT currently.
