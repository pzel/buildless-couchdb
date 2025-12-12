# Buildless Preact App (with in-browser test suite)

## TLDR: How to run this

`make serve`,  `make setup`, `make test`

You will need docker available on your system. CouchDB will be running locally
in a docker container, with the volume `buildless-couchdb-data` connected.

## This project builds on [buildless](https://github.com/pzel/buildless)

Please see the
[README](https://github.com/pzel/buildless/blob/master/README.md) of the
original project for rationale and goals.


## What's changed versus buildless?

1) There is an instance of [CouchDB]https://couchdb.apache.org/) running
locally, and the app's PouchDB is set up to replicate to CouchDB.

CouchDB uses the [per-user
database](https://docs.couchdb.org/en/stable/config/couch-peruser.html) scheme,
and 20 users are seeded via `make setup` (or `./bin/addUsers`). The usernames
and passwords are generated sequentially:

| Username | Password         |
|----------|------------------|
| user1    | user1-password   |
| user2    | user2-password   |
| ...      | ...              |
| user<N>  | user<N>-password |


2) The Preact component (the App) knows how to shut down cleanly

The web browser can only keep so many concurrent connections open to the same
host, and running the test suite creates a bunch of `App` instances, each of
which holds a persistent http connection to CouchDB. 

In order to recycle these cleanly and reclaim connection slots, I had to
introduce a per-test setup/teardown mechanism, such that:

1) At setup: a new instance of App is rendered and its container div stored in
a global variable 

2) At teardown: the global app element is null-rendered,
triggering the component's `componentWillUnmount`, and closing connections to
the db


